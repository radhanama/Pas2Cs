using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;

namespace Pas2CsCS
{
    public class SyntaxErrorException : Exception
    {
        public SyntaxErrorException(string message) : base(message) {}
    }

    public static class Transpiler
    {
        public static (string result, List<string> todos) Transpile(string source)
        {
            string tmp = Path.GetTempFileName() + ".pas";
            File.WriteAllText(tmp, source);
            try
            {
            var psi = new ProcessStartInfo
            {
                FileName = "python3",
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
            };
            var root = Path.GetFullPath(Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)!, "..", "..", "..", ".."));
            psi.Environment["PYTHONPATH"] = root;
            psi.ArgumentList.Add("-c");
            psi.ArgumentList.Add("import pas2cs, pathlib, sys; src=pathlib.Path(sys.argv[1]).read_text(); out,todos=pas2cs.transpile(src); print(out); sys.stderr.write('\\n'.join(todos))");
            psi.ArgumentList.Add(tmp);

                using var proc = Process.Start(psi)!;
                string stdout = proc.StandardOutput.ReadToEnd();
                string stderr = proc.StandardError.ReadToEnd();
                proc.WaitForExit();

                if (proc.ExitCode != 0)
                {
                    throw new SyntaxErrorException(stderr);
                }

                var todos = stderr.Length == 0
                    ? new List<string>()
                    : stderr.Split('\n', StringSplitOptions.RemoveEmptyEntries).ToList();
                return (stdout, todos);
            }
            finally
            {
                try { File.Delete(tmp); } catch { }
            }
        }
    }
}
