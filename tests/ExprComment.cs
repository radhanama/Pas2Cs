namespace Demo {
    public partial class ExprComment {
        public static void Check(bool flag1, bool flag2) {
            if (flag1 || flag2) System.Console.WriteLine("y");
        }
        public static void CheckStart(int flag1, int flag2) {
            if (flag2 == 2) System.Console.WriteLine("z");
        }
        public static double SumWithLineComment(double v1, double v2, double v3, double v4) {
            double result;
            result = Math.Round(v1 + v2, 2) + Math.Round(v3, 2) + Math.Round(v4, 2);
            return result;
        }
    }
}
