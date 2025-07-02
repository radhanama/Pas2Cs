namespace Demo {
    public partial class ExitComment {
        public static int Test(bool flag) {
            if (!flag) return -1; /* fail */
            return 0;
        }
    }
}
