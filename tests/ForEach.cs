namespace Demo {
    public partial class ForEachExample {
        public static int Sum(int[] arr) {
            int total;
            total = 0;
            foreach (var item in arr) total = total + item;
            return total;
        }
    }
}
