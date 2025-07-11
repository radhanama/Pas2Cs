using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace CaseFixer.Tests;

public class CaseFixerTests
{
    [Fact]
    public async Task AddsParenthesesToMethodCall()
    {
        var tempDir = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
        Directory.CreateDirectory(tempDir);
        Program.ResetCache();
        try
        {
            var file = Path.Combine(tempDir, "Demo.cs");
            var original = @"class Demo {
    int Foo() { return 1; }
    void Bar() {
        var x = foo;
    }
}";
            File.WriteAllText(file, original);

            int exitCode = await Program.Main(new[] { tempDir, "--threads", "1", "--roslyn" });
            Assert.Equal(0, exitCode);

            string result = File.ReadAllText(file);
            Assert.Contains("Foo()", result);
        }
        finally
        {
            Directory.Delete(tempDir, true);
        }
    }

    [Fact]
    public async Task ProcessesMultipleFiles()
    {
        var tempDir = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
        Directory.CreateDirectory(tempDir);
        Program.ResetCache();
        try
        {
            var file1 = Path.Combine(tempDir, "Demo.cs");
            var file2 = Path.Combine(tempDir, "DemoOther.cs");

            File.WriteAllText(file1, @"class Demo {
    int Foo() { return 1; }
}");

            File.WriteAllText(file2, @"class DemoOther {
    void Bar() {
        var d = new Demo();
        var x = d.foo;
    }
}");

            int exitCode = await Program.Main(new[] { tempDir, "--threads", "1", "--roslyn" });
            Assert.Equal(0, exitCode);

            string result1 = File.ReadAllText(file1);
            string result2 = File.ReadAllText(file2);
            Assert.Contains("Foo()", result2);
            Assert.Equal("class Demo {\n    int Foo() { return 1; }\n}", result1.Replace("\r", ""));
        }
        finally
        {
            Directory.Delete(tempDir, true);
        }
    }

    [Fact]
    public async Task UsesCompletionWhenDefinitionMissing()
    {
        var tempDir = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
        Directory.CreateDirectory(tempDir);
        Program.ResetCache();
        try
        {
            var file = Path.Combine(tempDir, "Demo.cs");
            File.WriteAllText(file, @"class Demo {
    int Foo() { return 1; }
    void Bar() {
        var x = foo;
    }
}");

            int exitCode = await Program.Main(new[] { tempDir, "--threads", "1", "--roslyn" });
            Assert.Equal(0, exitCode);

            string result = File.ReadAllText(file);
            Assert.Contains("Foo()", result);
        }
        finally
        {
            Directory.Delete(tempDir, true);
        }
    }
    [Fact]
    public async Task FixesBuiltInMethodNames()
    {
        var tempDir = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
        Directory.CreateDirectory(tempDir);
        Program.ResetCache();
        try
        {
            var file = Path.Combine(tempDir, "Demo.cs");
            File.WriteAllText(file, @"using System.Collections.Generic;
class Demo {
    void Bar() {
        var list = new List<int>();
        var s = list.tolist();
        var str = s.tostring;
    }
}");
            int exitCode = await Program.Main(new[] { tempDir, "--threads", "1", "--roslyn" });
            Assert.Equal(0, exitCode);

            string result = File.ReadAllText(file);
            Assert.Contains("ToList()", result);
            Assert.Contains("ToString()", result);
        }
        finally
        {
            Directory.Delete(tempDir, true);
        }
    }

    [Fact]
    public async Task DryRunDoesNotModifyFiles()
    {
        var tempDir = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
        Directory.CreateDirectory(tempDir);
        Program.ResetCache();
        try
        {
            var file = Path.Combine(tempDir, "Demo.cs");
            var original = @"class Demo {
    int Foo() { return 1; }
    void Bar() {
        var x = foo;
    }
}";
            File.WriteAllText(file, original);
            int exitCode = await Program.Main(new[] { tempDir, "--threads", "1", "--dry-run", "--roslyn" });
            Assert.Equal(0, exitCode);
            string result = File.ReadAllText(file);
            Assert.Equal(original.Replace("\r", ""), result.Replace("\r", ""));
        }
        finally
        {
            Directory.Delete(tempDir, true);
        }
    }

    [Fact]
    public async Task FixesClassAndVariableCasing()
    {
        var tempDir = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
        Directory.CreateDirectory(tempDir);
        Program.ResetCache();
        try
        {
            var file = Path.Combine(tempDir, "Demo.cs");
            File.WriteAllText(file, @"class demo {
    int MyField = 1;
    void test() {
        int LocalVar = MyField;
    }
}");

            int exitCode = await Program.Main(new[] { tempDir, "--threads", "1", "--roslyn" });
            Assert.Equal(0, exitCode);

            string result = File.ReadAllText(file).Replace("\r", "");
            Assert.Contains("class Demo", result);
            Assert.Contains("int myField = 1", result);
            Assert.Contains("int localVar = myField", result);
        }
        finally
        {
            Directory.Delete(tempDir, true);
        }
    }

    [Fact]
    public async Task LogsChangesWhenVerbose()
    {
        var tempDir = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
        Directory.CreateDirectory(tempDir);
        Program.ResetCache();
        try
        {
            var file = Path.Combine(tempDir, "Demo.cs");
            File.WriteAllText(file, @"class Demo {
    int Foo() { return 1; }
    void Bar() {
        var x = foo;
    }
}");

            var sw = new StringWriter();
            var originalOut = Console.Out;
            Console.SetOut(sw);

            int exitCode = await Program.Main(new[] { tempDir, "--threads", "1", "--verbose", "--roslyn" });

            Console.SetOut(originalOut);
            Assert.Equal(0, exitCode);

            string output = sw.ToString();
            Assert.Contains("resolved for foo", output);
            Assert.Contains("foo -> Foo", output);
            Assert.Contains("added parentheses", output);
            Assert.Contains("CompilationUnit", output);
        }
        finally
        {
            Directory.Delete(tempDir, true);
        }
    }
}
