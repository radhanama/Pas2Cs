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
        public static void DoHandle() {
            try
            {
                Console.WriteLine("B");
            }
            catch (Exception)
            {
                Console.WriteLine("Error");
            }
        }
    }
}
