using System;

namespace Demo {
    public partial class ExprComment {
        public static void Check(int cc) {
            if (cc == 1) /* or cc = 2 */
            Console.WriteLine("y");
        }
    }
}
