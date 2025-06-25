namespace N {
    public partial class TRange {
        public void Foo(int x) {
            switch (x)
            {
                case var v when v >= 1 && v <= 1005: System.Console.WriteLine("range"); break;
                case 2000: System.Console.WriteLine("other"); break;
            }
        }
    }
}
