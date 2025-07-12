using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace CaseFixer;

internal sealed class RoslynResolver
{
    private readonly string _root;
    private CSharpCompilation? _comp;
    private readonly object _lock = new();

    public RoslynResolver(string root)
    {
        _root = root;
    }

    public async Task<(string? Name, bool IsParameterless)> ResolveAsync(string filePath, SyntaxTree tree, SyntaxToken token)
    {
        if (_comp == null)
        {
            lock (_lock)
            {
                if (_comp == null)
                {
                    _comp = BuildCompilationAsync(filePath, tree).GetAwaiter().GetResult();
                }
            }
        }

        var treeInComp = _comp.SyntaxTrees.FirstOrDefault(t => Path.GetFullPath(t.FilePath) == Path.GetFullPath(tree.FilePath)) ?? tree;
        var model = _comp.GetSemanticModel(treeInComp);
        var tokenInComp = treeInComp.GetRoot().FindToken(token.SpanStart);
        SyntaxNode node = tokenInComp.Parent!;
        if (node is MemberAccessExpressionSyntax member && member.Name.Identifier == token)
            node = member.Name;
        else if (node is QualifiedNameSyntax qn && qn.Right.Identifier == token)
            node = qn.Right;

        var symbol = model.GetSymbolInfo(node).Symbol ?? model.GetDeclaredSymbol(node);
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

    private async Task<CSharpCompilation> BuildCompilationAsync(string mainPath, SyntaxTree mainTree)
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

        var refs = new List<MetadataReference>();
        if (AppContext.GetData("TRUSTED_PLATFORM_ASSEMBLIES") is string tpa)
        {
            refs.AddRange(tpa.Split(Path.PathSeparator)
                .Where(File.Exists)
                .Select(MetadataReference.CreateFromFile));
        }
        else
        {
            refs.AddRange(AppDomain.CurrentDomain.GetAssemblies()
                .Where(a => !a.IsDynamic && !string.IsNullOrEmpty(a.Location))
                .Select(a => MetadataReference.CreateFromFile(a.Location)));
        }

        return CSharpCompilation.Create("CaseFixer", trees, refs,
            new CSharpCompilationOptions(OutputKind.DynamicallyLinkedLibrary));
    }
}
