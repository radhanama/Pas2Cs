// ------------------------------------------------------------
// CaseFixer.cs – post-transpilation case-repair tool
// ------------------------------------------------------------
// Build:  dotnet build -c Release
// Run:    CaseFixer <solution-root> [--backup] [--threads N] [--verbose] [--dry-run] [--roslyn]
// Requires an OmniSharp instance listening on http://localhost:2000 unless --roslyn is used
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
/// identifier casing mismatches by querying OmniSharp or a local Roslyn compiler.
/// </summary>
internal static class Program
{
    private static readonly HttpClient Http = new() { BaseAddress = new("http://localhost:2000/") };

    // Cache to avoid resolving the same symbol repeatedly
    // Stores the canonical casing and whether the symbol represents a
    // parameterless method (so we know if parentheses should be added)
    private static readonly ConcurrentDictionary<string, (string Name, bool IsMethod)> CanonicalCaseCache =
        new(StringComparer.OrdinalIgnoreCase);

    internal delegate Task<(string? Name, bool IsParameterless)> SymbolResolver(string filePath, SyntaxTree tree, SyntaxToken token);

    internal static SymbolResolver ResolveSymbol = GetSymbolInfoAsync;

    internal static RoslynResolver? FallbackResolver { get; private set; }

    internal static void ResetCache() => CanonicalCaseCache.Clear();

    private static async Task<bool> OmniSharpReadyAsync()
    {
        try
        {
            using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(2));
            var res = await Http.GetAsync("/checkreadiness", cts.Token);
            return res.IsSuccessStatusCode;
        }
        catch
        {
            return false;
        }
    }

    private static string ApplyNamingConvention(string name, SyntaxToken token)
    {
        if (string.IsNullOrEmpty(name)) return name;

        bool isTypeDecl = token.Parent is ClassDeclarationSyntax cd && cd.Identifier == token ||
                           token.Parent is StructDeclarationSyntax sd && sd.Identifier == token ||
                           token.Parent is InterfaceDeclarationSyntax id && id.Identifier == token ||
                           token.Parent is EnumDeclarationSyntax ed && ed.Identifier == token;
        if (isTypeDecl)
            return ToPascalCase(name);

        bool isVarDecl = token.Parent is VariableDeclaratorSyntax ||
                         token.Parent is ParameterSyntax ||
                         token.Parent is ForEachStatementSyntax fs && fs.Identifier == token ||
                         token.Parent is CatchDeclarationSyntax cd2 && cd2.Identifier == token;
        if (isVarDecl)
            return ToCamelCase(name);

        return name;
    }

    private static string ToPascalCase(string s) =>
        string.IsNullOrEmpty(s) ? s : char.ToUpperInvariant(s[0]) + s.Substring(1);

    private static string ToCamelCase(string s)
    {
        if (string.IsNullOrEmpty(s)) return s;
        if (s.Length == 1) return s.ToLowerInvariant();
        return char.ToLowerInvariant(s[0]) + s.Substring(1);
    }

    public static async Task<int> Main(string[] args)
    {
        if (args.Length == 0 || args[0] is "-h" or "--help")
        {
            Console.WriteLine("Usage: CaseFixer <root-directory> [--backup] [--threads N] [--verbose] [--dry-run] [--roslyn]");
            return 1;
        }

        var root = Path.GetFullPath(args[0]);
        bool backup = args.Contains("--backup");
        bool verbose = args.Contains("--verbose");
        bool dryRun = args.Contains("--dry-run");
        bool useRoslyn = args.Contains("--roslyn");
        int threads = args.SkipWhile(a => a != "--threads").Skip(1).Select(int.Parse).FirstOrDefault(Environment.ProcessorCount);

        bool omniReady = await OmniSharpReadyAsync();
        if (!useRoslyn && !omniReady)
        {
            Console.Error.WriteLine("Warning: OmniSharp not reachable – falling back to built-in resolver.");
            useRoslyn = true;
        }

        if (!Directory.Exists(root))
        {
            Console.Error.WriteLine($"Directory not found: {root}");
            return 2;
        }

        var files = Directory.EnumerateFiles(root, "*.cs", SearchOption.AllDirectories)
                             .Where(f => !f.EndsWith(".Designer.cs", StringComparison.OrdinalIgnoreCase))
                             .ToList();

        SymbolResolver resolver;
        if (useRoslyn)
        {
            var roslyn = new RoslynResolver(root);
            resolver = roslyn.ResolveAsync;
            FallbackResolver = null;
        }
        else
        {
            FallbackResolver = new RoslynResolver(root);
            resolver = ResolveSymbol;
        }

        var sem = new SemaphoreSlim(threads);
        var tasks = files.Select(path => ProcessFileAsync(path, backup, verbose, dryRun, sem, resolver));
        var counts = await Task.WhenAll(tasks);
        var totalFixed = counts.Sum();

        Console.WriteLine($"\n\u2714 Done – processed {files.Count} file(s), fixed {totalFixed} identifier(s).\n");
        return 0;
    }

    internal static async Task<(string Result, int Fixed)> FixSourceAsync(string source, string filePath, SymbolResolver resolver, bool verbose = false)
    {
        var tree = CSharpSyntaxTree.ParseText(source, path: filePath);
        var root = tree.GetRoot();

        var edits = new List<(int start, int length, string replacement)>();

        foreach (var token in root.DescendantTokens().Where(t => t.IsKind(SyntaxKind.IdentifierToken)))
        {
            var original = token.ValueText;
            if (string.IsNullOrWhiteSpace(original)) continue;

            if (CanonicalCaseCache.TryGetValue(original, out var cached))
            {
                if (verbose)
                {
                    Console.WriteLine($"  cache for {original} -> {cached.Name} (method={cached.IsMethod})");
                }
                if (!string.Equals(original, cached.Name, StringComparison.Ordinal))
                {
                    edits.Add((token.SpanStart, token.Span.Length, cached.Name));
                    if (verbose)
                    {
                        var pos = tree.GetLineSpan(token.Span).StartLinePosition;
                        Console.WriteLine($"  {original} -> {cached.Name} at {pos.Line + 1}:{pos.Character + 1}");
                    }
                }

                if (cached.IsMethod && token.Parent is IdentifierNameSyntax idName)
                {
                    bool alreadyCall = idName.Parent is InvocationExpressionSyntax inv && inv.Expression == idName;
                    if (!alreadyCall && idName.Parent is MemberAccessExpressionSyntax mem && mem.Name == idName && mem.Parent is InvocationExpressionSyntax inv2 && inv2.Expression == mem)
                        alreadyCall = true;
                    if (!alreadyCall)
                    {
                        edits.Add((token.SpanStart + token.Span.Length, 0, "()"));
                        if (verbose)
                        {
                            var pos = tree.GetLineSpan(token.Span).StartLinePosition;
                            Console.WriteLine($"  added parentheses for {token.ValueText} at {pos.Line + 1}:{pos.Character + 1}");
                        }
                    }
                }
                continue;
            }

            var (symbolName, isMethod) = await resolver(filePath, tree, token);
            if (verbose)
            {
                if (symbolName != null)
                {
                    Console.WriteLine($"  resolved for {original} -> {(symbolName ?? "null")} (paramless={isMethod})");
                }
            }
            if (symbolName is null && !isMethod) continue;

            if (symbolName is not null)
            {
                var fixedName = ApplyNamingConvention(symbolName, token);
                CanonicalCaseCache.TryAdd(original, (fixedName, isMethod));
                if (!string.Equals(original, fixedName, StringComparison.Ordinal))
                {
                    edits.Add((token.SpanStart, token.Span.Length, fixedName));
                    if (verbose)
                    {
                        var pos = tree.GetLineSpan(token.Span).StartLinePosition;
                        Console.WriteLine($"  {original} -> {fixedName} at {pos.Line + 1}:{pos.Character + 1}");
                    }
                }
            }

            if (isMethod && token.Parent is IdentifierNameSyntax idName2)
            {
                bool alreadyCall = idName2.Parent is InvocationExpressionSyntax inv && inv.Expression == idName2;
                if (!alreadyCall && idName2.Parent is MemberAccessExpressionSyntax mem && mem.Name == idName2 && mem.Parent is InvocationExpressionSyntax inv2 && inv2.Expression == mem)
                    alreadyCall = true;

                if (!alreadyCall)
                {
                    edits.Add((token.SpanStart + token.Span.Length, 0, "()"));
                    if (verbose)
                    {
                        var pos = tree.GetLineSpan(token.Span).StartLinePosition;
                        Console.WriteLine($"  added parentheses for {token.ValueText} at {pos.Line + 1}:{pos.Character + 1}");
                    }
                }
            }
        }

        if (edits.Count == 0) return (source, 0);

        var sb = new StringBuilder(source);
        foreach (var (start, length, replacement) in edits.OrderByDescending(e => e.start))
        {
            sb.Remove(start, length).Insert(start, replacement);
        }

        var result = sb.ToString();
        if (verbose)
        {
            Console.WriteLine("--- syntax tree ---");
            var newRoot = CSharpSyntaxTree.ParseText(result).GetRoot();
            DumpSyntaxTree(newRoot, "");
        }

        return (result, edits.Count);
    }

    // --------------------------------------------------------
    // Core per-file processing logic
    // --------------------------------------------------------
    private static async Task<int> ProcessFileAsync(string path, bool backup, bool verbose, bool dryRun, SemaphoreSlim sem, SymbolResolver resolver)
    {
        await sem.WaitAsync();
        try
        {
            var source = await File.ReadAllTextAsync(path);

            var (result, count) = await FixSourceAsync(source, path, resolver, verbose);
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
    // OmniSharp HTTP helpers
    // --------------------------------------------------------
    private static async Task<(string? Name, bool IsParameterless)> GetSymbolInfoAsync(string filePath, SyntaxTree tree, SyntaxToken token)
    {
        var pos = tree.GetLineSpan(token.Span).StartLinePosition;
        var req = new GotoReq(filePath, pos.Line + 1, pos.Character + 1);
        try
        {
            var res = await Http.PostAsJsonAsync("/v2/gotoDefinition", req);
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
            if (comp == default && FallbackResolver != null)
                comp = await FallbackResolver.ResolveAsync(filePath, tree, token);
            return comp;
        }
        catch
        {
            // network / JSON error – ignore, compiler will report later
        }
        if (FallbackResolver != null)
            return await FallbackResolver.ResolveAsync(filePath, tree, token);
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
            if (!res.IsSuccessStatusCode) goto Fallback;
            var items = await res.Content.ReadFromJsonAsync<AutoCompleteResp[]>();
            var match = items?.FirstOrDefault(i =>
                string.Equals(i.DisplayText?.Split('(')[0], token.ValueText, StringComparison.OrdinalIgnoreCase) ||
                string.Equals(i.CompletionText, token.ValueText, StringComparison.OrdinalIgnoreCase));
            if (match == null) goto Fallback;
            bool paramless = match.Snippet?.Contains("()") == true;
            var name = match.DisplayText?.Split('(')[0] ?? match.CompletionText;
            return (name, paramless);
        }
        catch
        {
            // ignore
        }
Fallback:
        if (FallbackResolver != null)
            return await FallbackResolver.ResolveAsync(filePath, tree, token);
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

    private static void DumpSyntaxTree(SyntaxNode node, string indent)
    {
        Console.WriteLine($"{indent}{node.Kind()}");
        indent += "  ";
        foreach (var child in node.ChildNodesAndTokens())
        {
            if (child.IsNode)
            {
                DumpSyntaxTree(child.AsNode()!, indent);
            }
            else
            {
                var tok = child.AsToken();
                Console.WriteLine($"{indent}{tok.Kind()} {tok.ValueText}");
            }
        }
    }
}
