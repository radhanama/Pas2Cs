using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace CaseFixer.Tests;

internal sealed class RoslynResolver : IDisposable
{
    private readonly string _root;
    private readonly Program.SymbolResolver _previous;
    private CSharpCompilation? _comp;

    public RoslynResolver(string root)
    {
        _root = root;
        _previous = Program.ResolveSymbol;
        Program.ResolveSymbol = ResolveAsync;
    }

    public async Task<(string? Name, bool IsParameterless)> ResolveAsync(string filePath, SyntaxTree tree, SyntaxToken token)
    {
        await BuildCompilationAsync(filePath, tree);
        var model = _comp!.GetSemanticModel(tree);
        SyntaxNode node = token.Parent!;
        if (node is MemberAccessExpressionSyntax member && member.Name.Identifier == token)
            node = member.Name;
        else if (node is QualifiedNameSyntax qn && qn.Right.Identifier == token)
            node = qn.Right;

        var info = model.GetSymbolInfo(node);
        var symbol = info.Symbol ?? info.CandidateSymbols.FirstOrDefault() ??
                     model.GetDeclaredSymbol(node);
        if (symbol == null)
        {
            string text = token.ValueText;
            if (string.Equals(text, "tolist", StringComparison.OrdinalIgnoreCase))
                return ("ToList", true);
            if (string.Equals(text, "tostring", StringComparison.OrdinalIgnoreCase))
                return ("ToString", true);
            if (!string.IsNullOrEmpty(text))
                return (char.ToUpperInvariant(text[0]) + text.Substring(1), true);
            return default;
        }
        bool paramless = symbol is IMethodSymbol m && m.Parameters.Length == 0;
        return (symbol.Name, paramless);
    }

    private async Task BuildCompilationAsync(string mainPath, SyntaxTree mainTree)
    {
        var trees = new List<SyntaxTree>();
        var files = Directory.GetFiles(_root, "*.cs");
        foreach (var f in files)
        {
            if (Path.GetFullPath(f) == Path.GetFullPath(mainPath))
                trees.Add(mainTree);
            else
                trees.Add(CSharpSyntaxTree.ParseText(await File.ReadAllTextAsync(f), path: f));
        }

        var refs = AppDomain.CurrentDomain.GetAssemblies()
            .Where(a => !a.IsDynamic && !string.IsNullOrEmpty(a.Location))
            .Select(a => MetadataReference.CreateFromFile(a.Location))
            .ToList();

        _comp = CSharpCompilation.Create("CaseFixerTests", trees, refs,
            new CSharpCompilationOptions(OutputKind.DynamicallyLinkedLibrary));
    }

    public void Dispose()
    {
        Program.ResolveSymbol = _previous;
    }
}
