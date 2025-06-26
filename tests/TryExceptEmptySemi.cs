using System;

namespace Demo {
    public partial class TryExceptEmptySemiExample {
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
