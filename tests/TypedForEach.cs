namespace Demo {
    public partial class TypedForEach {
        public static int Sum(int[] arr) {
            int total;
            total = 0;
            foreach (int item in arr) total = total + item;
            return total;
        }
    }
}
