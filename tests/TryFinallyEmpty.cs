using System;

namespace Demo {
    public partial class TryFinallyEmptyExample {
        public static void DoNothing() {
            try
            {
                Console.WriteLine("A");
            }
            finally
            {
            }
        }
    }
}
