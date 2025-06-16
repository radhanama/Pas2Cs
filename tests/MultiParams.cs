namespace Demo {
    public partial class MultiParams {
        public void ShowSum(int a, int b, int c, string prefix) {
            int sum;
            sum = a + b + c;
            System.Console.WriteLine(prefix + sum);
        }
    }
}
