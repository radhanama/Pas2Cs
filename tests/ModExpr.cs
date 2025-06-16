namespace Demo {
    public static partial class Utils {
        public static void Check(int x, int y);
    }
    public static partial class Utils {
        public static void Check(int x, int y) {
            if (x % y != 0) x = x % y;
        }
    }
}
