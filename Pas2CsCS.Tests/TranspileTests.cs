using System;
using System.Collections.Generic;
using System.IO;
using Xunit;
using Pas2CsCS;

namespace Pas2CsCS.Tests
{
    public class TranspileTests
    {
        private static string ReadFile(string name)
        {
            var baseDir = Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "tests");
            return File.ReadAllText(Path.Combine(baseDir, name));
        }

        [Fact]
        public void Test_MathUtils()
        {
            var src = ReadFile("MathUtils.pas");
            var expected = ReadFile("MathUtils.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_ExportarDados()
        {
            var src = ReadFile("ExportarDados.pas");
            var expected = ReadFile("ExportarDados.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_ExampleProcedures()
        {
            var src = ReadFile("Example.pas");
            var expected = ReadFile("Example.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_MultiParams()
        {
            var src = ReadFile("MultiParams.pas");
            var expected = ReadFile("MultiParams.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_MultiVars()
        {
            var src = ReadFile("MultiVars.pas");
            var expected = ReadFile("MultiVars.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_Comments()
        {
            var src = ReadFile("Commented.pas");
            var expected = ReadFile("Commented.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_SingleStmt()
        {
            var src = ReadFile("SingleStmt.pas");
            var expected = ReadFile("SingleStmt.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_EscapedStr()
        {
            var src = ReadFile("EscapedStr.pas");
            var expected = ReadFile("EscapedStr.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_ArrayVar()
        {
            var src = ReadFile("ArrayVar.pas");
            var expected = ReadFile("ArrayVar.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_IndexAssign()
        {
            var src = ReadFile("IndexAssign.pas");
            var expected = ReadFile("IndexAssign.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_GenericExample()
        {
            var src = ReadFile("GenericExample.pas");
            var expected = ReadFile("GenericExample.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_GenericStatic()
        {
            var src = ReadFile("GenericStatic.pas");
            var expected = ReadFile("GenericStatic.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_Sections()
        {
            var src = ReadFile("Sections.pas");
            var expected = ReadFile("Sections.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_GenericBase()
        {
            var src = ReadFile("GenericBase.pas");
            var expected = ReadFile("GenericBase.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_ComplexFunction()
        {
            var src = ReadFile("ComplexFunction.pas");
            var expected = ReadFile("ComplexFunction.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_ReturnOnly()
        {
            var src = ReadFile("ReturnOnly.pas");
            var expected = ReadFile("ReturnOnly.cs").Trim();
            var (result, todos) = Transpiler.Transpile(src);
            Assert.Equal(expected, result.Trim());
            Assert.Empty(todos);
        }

        [Fact]
        public void Test_ErrorReporting()
        {
            var src = ReadFile("BadSyntax.pas");
            Assert.Throws<SyntaxErrorException>(() => Transpiler.Transpile(src));
        }
    }
}
