namespace Demo {
    public static partial class Defaults {
        public static void Test(int a, int b);
    }
    public static partial class Defaults {
        public static void Test(int a, int b) {
            base.Test(a, b);
        }
    }
}
