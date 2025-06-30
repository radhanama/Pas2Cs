namespace Demo {
    public partial class IfThenSemi {
        public static void Demo(bool flag) {
            if (flag) {
                if (flag) {}
                {
                    System.Console.WriteLine("Hello");
                }
            }
        }
    }
}
