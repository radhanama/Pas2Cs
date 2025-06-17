namespace Demo {
    public partial class TypedUsing {
        public static IDisposable GetRes() {
            return null;
        }
        public static void DoStuff() {
            using (IDisposable res = GetRes()) Console.WriteLine(res);
        }
    }
}
