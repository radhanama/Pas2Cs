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
        try
        {
            var file = Path.Combine(tempDir, "Demo.cs");
            File.WriteAllText(file, @"class Demo {
    int Foo() { return 1; }
    void Bar() {
        var x = foo;
    }
}");

            using var server = new OmniSharpStub(file);
            int exitCode = await Program.Main(new[] { tempDir, "--threads", "1" });
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

            using var server = new OmniSharpStub(file1);
            int exitCode = await Program.Main(new[] { tempDir, "--threads", "1" });
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
}
