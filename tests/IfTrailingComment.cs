using System;

namespace Demo {
    public partial class IfTrailingComment {
        public static void Check(bool flag) {
            if (flag) Console.WriteLine("a"); // comment
            else Console.WriteLine("b");
        }
    }
}
