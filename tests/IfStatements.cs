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
                {
                    System.Console.WriteLine("Hello");
                }
            }
        }
    }
    
    public partial class IfElseEmptyExample {
        public static void Check(bool flag) {
            if (flag) Console.WriteLine("yes"); else {}
        }
    }
    
    public partial class Foo {
        // TODO: field ehVazio: bool -> declare a field
        public bool ehVazio;
        // TODO: field indUltimaPos: int -> declare a field
        public int indUltimaPos;
        public bool Check(int frowInd) {
            bool result;
            if (this.ehVazio || frowInd > this.indUltimaPos || frowInd == -1) result = true; else result = false;
            return result;
        }
    }
}
