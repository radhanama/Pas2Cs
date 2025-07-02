namespace N {
    public partial class TTest {
        public void Foo(int x) {
            switch (x)
            {
                case -1: Console.WriteLine("neg one"); break;
                case -2: Console.WriteLine("neg two"); break;
            }
        }
        public void Bar(int x) {
            switch (x)
            {
                case -1:{
                    {
                        Console.WriteLine("neg one");
                    }
                break;
                }
                case -2:{
                    {
                        Console.WriteLine("neg two");
                    }
                break;
                }
            }
        }
    }
}
