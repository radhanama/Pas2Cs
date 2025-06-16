namespace Demo {
    public static partial class ForDownToDemo {
        public static void Test();
    }
    public static partial class ForDownToDemo {
        public static void Test() {
            for (var i = 3; i >= 1; i--) System.Console.WriteLine(i);
        }
    }
}
