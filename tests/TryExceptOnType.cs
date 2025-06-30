using System;

namespace Demo {
    public partial class TryExceptOnType {
        public static void DoStuff() {
            try
            {
                Console.WriteLine("A");
            }
            catch (Exception)
            {
                Console.WriteLine("Error");
            }
        }
    }
}
