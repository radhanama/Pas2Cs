namespace Demo {
    public partial class LoopExample {
        public static void CountThree() {
            int i;
            i = 0;
            while (true) {
                i = i + 1;
                if (i == 3) break;
            }
        }
    }
}
