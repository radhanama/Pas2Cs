using System;

namespace Demo {
    public partial class Ternary {
        public static int Select(bool flag) {
            int result;
            int val;
            val = flag ? 1 : 0;
            result = val;
            return result;
        }
    }
    
    public partial class ShortIf {
        public static string AddBr(string msg) {
            string result;
            msg = msg + (msg != "" ? "<br />" : null);
            result = msg;
            return result;
        }
    }
    
    public partial class IfThenSemi {
        public static void Demo(bool flag) {
            if (flag) {
                if (flag) {}
                /* no-op */
                {
                    System.Console.WriteLine("Hello");
                }
            }
        }
    }
    
    public partial class IfElseEmptyExample {
        public static void Check(bool flag) {
            if (flag) Console.WriteLine("yes"); /* nothing */
        }
    }
    
    public partial class Foo {
        public bool ehVazio;
        public int indUltimaPos;
        public bool Check(int frowInd) {
            bool result;
            if (this.ehVazio || frowInd > this.indUltimaPos || frowInd == -1) result = true; else result = false;
            return result;
        }
    }
    
    public partial class PadZeros {
        public static string PreencheComZeros(double n, int t) {
            string result;
            string aux;
            aux = n.ToString;
            if (Length(aux) > t) aux = Copy(aux, 0, t); /* pega as primeiras t posicoes */
            else aux = TSGUutils.Replicar("0", t - Length(aux)) + aux; /* preenche com zeros */
            result = aux;
            return result;
        }
    }
}
