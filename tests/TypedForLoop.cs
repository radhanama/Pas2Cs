namespace Demo {
    public partial class TypedForLoop {
        public static int Sum(int[] arr) {
            int total;
            total = 0;
            for (int i = 0; i <= length(arr) - 1; i++) total = total + arr[i];
            return total;
        }
    }
}
