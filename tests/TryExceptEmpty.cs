using System;

namespace Demo {
    public partial class TryExceptEmptyExample {
        public static void DoNothing() {
            try
            {
                Console.WriteLine("A");
            }
            catch (Exception)
            {}
        }
    }
}
