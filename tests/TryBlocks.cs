using System;

namespace Demo {
    public partial class TryExceptExample {
        public static void DoStuff() {
            try
            {
                Console.WriteLine("A");
            }
            catch (Exception E)
            {
                Console.WriteLine(E.Message);
            }
        }
    }
    
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
