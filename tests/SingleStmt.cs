namespace Demo {
    public partial class SingleStmt {
        public static void TestIf(int x);
        public static void TestFor();
        public static void TestIf(int x) {
            if (x == 5) System.Console.WriteLine('Hi');
        }
        public static void TestFor() {
            for (var i = 1; i <= 3; i++) System.Console.WriteLine(i);
        }
    }
}
