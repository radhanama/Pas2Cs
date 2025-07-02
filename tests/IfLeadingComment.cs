using System;

namespace Demo {
    public partial class IfLeadingComment {
        public static void Check(bool flag) {
            if (/* first line
                   second line */ flag) Console.WriteLine("a");
        }
    }
}
