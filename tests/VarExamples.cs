using System;

namespace Demo {
    public partial class VarInfer {
        public void Example() {
            var cli = new WebClient();
        }
    }
    
    public partial class VarStmt {
        public const double MinVal = -32768.1;
        public void Example() {
            string delimiter = ",";
        }
    }
    
    public partial class NamedArg {
        public void UseArgs() {
            Console.WriteLine(123, "ok");
        }
    }
    
    public partial class NotIn {
        public void Check(string tipo) {
            if (!System.Array.Exists(new[]{"Aluno", "Funcionario"}, x => x == tipo)) Console.WriteLine("nao");
        }
    }
}
