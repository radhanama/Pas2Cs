using System;

namespace Demo {
    public partial class IfElseEmptyExample {
        public static void Check(bool flag) {
            if (flag) Console.WriteLine("yes"); else {}
        }
    }
}
