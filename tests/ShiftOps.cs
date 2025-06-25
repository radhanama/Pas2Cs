namespace Demo {
    public partial class ShiftOps {
        public static int Demo() {
            int x;
            x = 1 << 2;
            x = x >> 1;
            x = x ^ 3;
            return x;
        }
    }
}
