namespace Demo {
    public partial class LongIf {
        public static void Check(bool a, bool b, bool c, bool d, bool e, bool x, bool y) {
            if (a && b && c && d && e || x && y) Console.WriteLine("ok");
        }
    }
}
