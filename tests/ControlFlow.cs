using System.Collections.Generic;

namespace Demo {
    public partial class BasicIf {
        public static void Check(int x) {
            if (x == 5) Console.WriteLine("Hi");
        }
    }
    
    public partial class IfElse {
        public static void Check(int x) {
            if (x >= 0) Console.WriteLine("pos"); else Console.WriteLine("neg");
        }
    }
    
    public partial class LongIf {
        public static void Check(bool a, bool b, bool c, bool d, bool e, bool x, bool y) {
            if (a && b && c && d && e || x && y) Console.WriteLine("ok");
        }
    }
    
    public partial class ComplexIf {
        public static void Check(object v, Dictionary<string, int> dict, int[] arr) {
            if ((int)v > dict["foo"] && arr[0] < dict.Count && dict.ContainsKey("bar") || arr.Length > 0) Console.WriteLine("ok");
        }
    }
    
    public partial class ShortCircuit {
        public void Check(bool a, bool b) {
            if (a || b) Console.WriteLine("yes");
            if (a && b) Console.WriteLine("and");
        }
    }
}
