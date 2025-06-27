using System;

namespace Demo {
    public partial class TypeOfNew {
        public static byte[] MakeArray(int len) {
            byte[] result;
            result = new byte[len];
            return result;
        }
        public static void Show() {
            Console.WriteLine(typeof(int));
        }
    }
}
