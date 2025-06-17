namespace Demo {
    public partial class BreakExample {
        public static void DoBreak(int[] arr) {
            int i;
            for (i = 0; i <= arr.Length - 1; i++) {
                if (arr[i] == 0) break;
                if (arr[i] < 0) continue;
            }
        }
    }
}
