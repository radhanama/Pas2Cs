using System;

namespace Demo {
    public partial class IfComment {
        public static void Check(bool flag) {
            if (flag) {
                Console.WriteLine("y");
                /* comment */
            } else {
                Console.WriteLine("n");
            }
        }
    }
}
