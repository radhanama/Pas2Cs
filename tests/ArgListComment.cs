namespace Demo {
    public partial class ArgListComment {
        public static void ThreeArgs(int a, int b, int c) {
        }
        public static void Run() {
            ThreeArgs(1 // first, 2 // second, 3);
        }
    }
}
