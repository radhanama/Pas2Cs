namespace Demo {
    public static partial class Example {
        public static void DoStuff(int value);
        public static int Multiply(int a, int b);
    }
    public static partial class Example {
        public static void DoStuff(int value) {
            System.Console.WriteLine('Hi');
        }
    }
    public static partial class Example {
        public static int Multiply(int a, int b) {
            return a * b;
        }
    }
}
