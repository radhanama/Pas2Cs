using System;
using System.IO;

namespace Pas2CsCS
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length != 1)
            {
                Console.WriteLine("usage: dotnet run -p Pas2CsCS <input.pas>");
                return;
            }

            string src = File.ReadAllText(args[0]);

            try
            {
                var (result, todos) = Transpiler.Transpile(src);
                Console.WriteLine(result);
                if (todos.Count > 0)
                {
                    Console.Error.WriteLine("TODO items:");
                    foreach (var todo in todos)
                        Console.Error.WriteLine(todo);
                }
            }
            catch (SyntaxErrorException ex)
            {
                Console.Error.WriteLine(ex.Message);
                Environment.Exit(1);
            }
        }
    }
}
