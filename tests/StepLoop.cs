namespace Demo {
    public partial class StepExample {
        public static int Sum() {
            int i;
            int total;
            total = 0;
            for (i = 1; i <= 5; i += 2) total = total + i;
            return total;
        }
    }
}
