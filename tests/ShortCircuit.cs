namespace Demo {
    public partial class ShortCircuit {
        public void Check(bool a, bool b) {
            if (a || b) Console.WriteLine("yes");
            if (a && b) Console.WriteLine("and");
        }
    }
}
