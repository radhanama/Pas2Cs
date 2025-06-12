namespace Demo {
    public static partial class MultiParams {
        public static void ShowSum(int a, int b, int c, string prefix);
    }
    public static partial class MultiParams {
        public static void ShowSum(int a, int b, int c, string prefix) {
            int sum;
            sum = a + b + c;
            System.Console.WriteLine(prefix + sum);
        }
    }
}

