using System;

namespace Demo {
    public partial class ExprComment {
        public static void Check(int cc) {
            if (cc == 1) /* or cc = 2 */
            Console.WriteLine("y");
        }
        public static void CheckMulti(int flag1, int flag2, int flag3) {
            if (flag1 == 1 || flag2 == 2 || flag3 == 3) Console.WriteLine("z");
        }
        public static void CheckLeading(bool flag) {
            if (flag) Console.WriteLine("p");
        }
    }
}
