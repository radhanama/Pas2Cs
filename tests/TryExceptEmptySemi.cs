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
        public static void DoCatch() {
            try
            {
                Console.WriteLine("A");
            }
            catch (Exception)
            {
                Console.WriteLine("B");
            }
        }
    }
}
