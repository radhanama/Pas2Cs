// ------------------------------------------------------------
// CaseFixer.cs – post-transpilation case-repair tool
// ------------------------------------------------------------
// Build:  dotnet build -c Release
// Run:    CaseFixer <solution-root> [--backup] [--threads N] [--verbose] [--dry-run]
// Requires an OmniSharp instance listening on http://localhost:2000
// ------------------------------------------------------------

using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text;
using System.Text.RegularExpressions;
using System.Text.Json.Serialization;
using System.Threading;
using System.Threading.Tasks;
using System.Runtime.CompilerServices;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

[assembly: InternalsVisibleTo("CaseFixer.Tests")]

namespace CaseFixer;

/// <summary>
/// Walks *.cs files produced by an Oxygene->C# transpiler and fixes
/// identifier casing mismatches by querying OmniSharp (Roslyn).
/// </summary>
internal static class Program
{
    private static readonly HttpClient Http = new() { BaseAddress = new("http://localhost:2000/") };

    // Cache to avoid hitting OmniSharp repeatedly for the same symbol
    private static readonly ConcurrentDictionary<string, string> CanonicalCaseCache =
        new(StringComparer.OrdinalIgnoreCase);

    internal delegate Task<(string? Name, bool IsParameterless)> SymbolResolver(string filePath, SyntaxTree tree, SyntaxToken token);

    internal static SymbolResolver ResolveSymbol = GetSymbolInfoAsync;

    internal static void ResetCache() => CanonicalCaseCache.Clear();

    public static async Task<int> Main(string[] args)
    {
        if (args.Length == 0 || args[0] is "-h" or "--help")
        {
            Console.WriteLine("Usage: CaseFixer <root-directory> [--backup] [--threads N] [--verbose] [--dry-run]");
            return 1;
        }

        var root = Path.GetFullPath(args[0]);
        bool backup = args.Contains("--backup");
        bool verbose = args.Contains("--verbose");
        bool dryRun = args.Contains("--dry-run");
        int threads = args.SkipWhile(a => a != "--threads").Skip(1).Select(int.Parse).FirstOrDefault(Environment.ProcessorCount);

        if (!Directory.Exists(root))
        {
            Console.Error.WriteLine($"Directory not found: {root}");
            return 2;
        }

        var files = Directory.EnumerateFiles(root, "*.cs", SearchOption.AllDirectories)
                             .Where(f => !f.EndsWith(".Designer.cs", StringComparison.OrdinalIgnoreCase))
                             .ToList();

        var sem = new SemaphoreSlim(threads);
        var tasks = files.Select(path => ProcessFileAsync(path, backup, verbose, dryRun, sem));
        var counts = await Task.WhenAll(tasks);
        var totalFixed = counts.Sum();

        Console.WriteLine($"\n\u2714 Done – processed {files.Count} file(s), fixed {totalFixed} identifier(s).\n");
        return 0;
    }

    internal static async Task<(string Result, int Fixed)> FixSourceAsync(string source, string filePath, SymbolResolver resolver)
    {
        var tree = CSharpSyntaxTree.ParseText(source);
        var root = tree.GetRoot();

        var edits = new List<(int start, int length, string replacement)>();

        foreach (var token in root.DescendantTokens().Where(t => t.IsKind(SyntaxKind.IdentifierToken)))
        {
            var original = token.ValueText;
            if (string.IsNullOrWhiteSpace(original)) continue;

            if (CanonicalCaseCache.TryGetValue(original, out var cached))
            {
                if (!string.Equals(original, cached, StringComparison.Ordinal))
                    edits.Add((token.SpanStart, token.Span.Length, cached));
                continue;
            }

            var (symbolName, isMethod) = await resolver(filePath, tree, token);
            if (symbolName is null && !isMethod) continue;

            if (symbolName is not null)
            {
                CanonicalCaseCache.TryAdd(original, symbolName);
                if (!string.Equals(original, symbolName, StringComparison.Ordinal))
                    edits.Add((token.SpanStart, token.Span.Length, symbolName));
            }

            if (isMethod && token.Parent is IdentifierNameSyntax name)
            {
                bool alreadyCall = name.Parent is InvocationExpressionSyntax inv && inv.Expression == name;
                if (!alreadyCall && name.Parent is MemberAccessExpressionSyntax mem && mem.Name == name && mem.Parent is InvocationExpressionSyntax inv2 && inv2.Expression == mem)
                    alreadyCall = true;

                if (!alreadyCall)
                    edits.Add((token.SpanStart + token.Span.Length, 0, "()"));
            }
        }

        if (edits.Count == 0) return (source, 0);

        var sb = new StringBuilder(source);
        foreach (var (start, length, replacement) in edits.OrderByDescending(e => e.start))
        {
            sb.Remove(start, length).Insert(start, replacement);
        }

        return (sb.ToString(), edits.Count);
    }

    // --------------------------------------------------------
    // Core per-file processing logic
    // --------------------------------------------------------
    private static async Task<int> ProcessFileAsync(string path, bool backup, bool verbose, bool dryRun, SemaphoreSlim sem)
    {
        await sem.WaitAsync();
        try
        {
            var source = await File.ReadAllTextAsync(path);
            var (result, count) = await FixSourceAsync(source, path, ResolveSymbol);
            if (count == 0) return 0;

            if (!dryRun)
            {
                if (backup)
                    File.Copy(path, path + ".bak", overwrite: true);

                await File.WriteAllTextAsync(path, result);
            }
            if (verbose)
                Console.WriteLine($"[{Path.GetFileName(path)}] fixed {count} identifier(s).");

            return count;
        }
        finally
        {
            sem.Release();
        }
    }

    // --------------------------------------------------------
    // OmniSharp helpers
    // --------------------------------------------------------
    private static async Task<(string? Name, bool IsParameterless)> GetSymbolInfoAsync(string filePath, SyntaxTree tree, SyntaxToken token)
    {
        var pos = tree.GetLineSpan(token.Span).StartLinePosition;
        var req = new GotoReq(filePath, pos.Line + 1, pos.Character + 1);
        try
        {
            var res = await Http.PostAsJsonAsync("/v2/gotodefinition", req);
            if (res.IsSuccessStatusCode)
            {
                var data = await res.Content.ReadFromJsonAsync<GotoResp>();
                var def = data?.Definitions.FirstOrDefault();
                if (def != null)
                {
                    var guess = Path.GetFileNameWithoutExtension(def.FileName);
                    string? canonical = null;
                    bool isMethod = false;
                    if (string.Equals(guess, token.ValueText, StringComparison.OrdinalIgnoreCase))
                        canonical = guess;

                    if (File.Exists(def.FileName))
                    {
                        var defLines = await File.ReadAllLinesAsync(def.FileName);
                        var line = defLines.ElementAtOrDefault(def.Range.Start.Line - 1);
                        if (line != null && def.Range.Start.Column - 1 < line.Length)
                        {
                            var length = def.Range.End.Column - def.Range.Start.Column;
                            canonical ??= line.Substring(def.Range.Start.Column - 1, length);
                            var after = line.Substring(def.Range.Start.Column - 1 + length);
                            if (System.Text.RegularExpressions.Regex.IsMatch(after, @"^\s*\(\s*\)"))
                                isMethod = true;
                        }
                    }
                    return (canonical, isMethod);
                }
            }

            // fallback to auto-complete when definition lookup fails
            var comp = await GetCompletionInfoAsync(filePath, tree, token);
            return comp;
        }
        catch
        {
            // network / JSON error – ignore, compiler will report later
        }
        return default;
    }

    private static async Task<(string? Name, bool IsParameterless)> GetCompletionInfoAsync(string filePath, SyntaxTree tree, SyntaxToken token)
    {
        var pos = tree.GetLineSpan(token.Span).EndLinePosition;
        var source = await File.ReadAllTextAsync(filePath);
        var req = new AutoCompleteReq
        (
            filePath,
            pos.Line + 1,
            pos.Character + 1,
            source,
            token.ValueText,
            true,
            true,
            true
        );

        try
        {
            var res = await Http.PostAsJsonAsync("/autocomplete", req);
            if (!res.IsSuccessStatusCode) return default;
            var items = await res.Content.ReadFromJsonAsync<AutoCompleteResp[]>();
            var match = items?.FirstOrDefault(i => string.Equals(i.DisplayText?.Split('(')[0], token.ValueText, StringComparison.OrdinalIgnoreCase));
            if (match == null) return default;
            bool paramless = match.Snippet?.Contains("()") == true;
            var name = match.DisplayText?.Split('(')[0] ?? match.CompletionText;
            return (name, paramless);
        }
        catch
        {
            // ignore
        }
        return default;
    }

    // --------------------------------------------------------
    // DTOs for OmniSharp JSON contract (only what we use)
    // --------------------------------------------------------
    private record GotoReq(string FileName, int Line, int Column);
    private record GotoResp([property: JsonPropertyName("definitions")] Location[] Definitions);
    private record Location(string FileName, TextRange Range);
    private record TextRange(Position Start, Position End);
    private record Position(int Line, int Column);
    private record AutoCompleteReq(string FileName, int Line, int Column, string Buffer, string WordToComplete, bool WantMethodHeader, bool WantKind, bool WantSnippet);
    private record AutoCompleteResp(string CompletionText, string DisplayText, string Snippet, string Kind, string MethodHeader);
}
