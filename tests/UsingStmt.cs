namespace Demo {
    public partial class UsingExample {
        public static void DoStuff() {
            using (var res = GetRes()) Console.WriteLine(res);
        }
    }
}
