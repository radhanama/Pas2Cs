using System;

namespace Demo {
    public partial class TryExceptExample {
        public static void DoStuff() {
            try {
                Console.WriteLine("A");
            } catch (Exception E) {
                Console.WriteLine(E.Message);
            }
        }
    }
}
