using System;

namespace Demo {
    public partial class TryExceptOnEmpty {
        public static void DoStuff() {
            try
            {
                Console.WriteLine("A");
            }
            catch (Exception E)
            {}
        }
    }
}
