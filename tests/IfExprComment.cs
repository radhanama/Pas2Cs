using System;

namespace Demo {
    public partial class ExprComment {
        public static void Check(int cc) {
            if (cc == 1 /* or cc = 2 */) Console.WriteLine("y");
        }
        public static void CheckMulti(int flag1, int flag2, int flag3) {
            if (flag1 == 1 || flag2 == 2 || flag3 == 3 /* or (flag3 = 4) */) Console.WriteLine("z");
        }
        public static void CheckLine(bool flag1, bool flag2) {
            if (flag1 /* comment */ || flag2) Console.WriteLine("x");
        }
    }
}
