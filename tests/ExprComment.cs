namespace Demo {
    public partial class ExprComment {
        public static void Check(bool flag1, bool flag2) {
            if (flag1 || flag2) System.Console.WriteLine("y");
        }
        public static void CheckStart(int flag1, int flag2) {
            if (flag2 == 2) System.Console.WriteLine("z");
        }
    }
}
