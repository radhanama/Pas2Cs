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
        public static void DoNothingNoSemi() {
            try
            {
                Console.WriteLine("B");
            }
            catch (Exception E)
            {}
        }
    }
}

