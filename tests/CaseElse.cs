using System;

namespace N {
    public partial class TTest {
        public void Foo(int x) {
            switch (x)
            {
                case 1: Console.WriteLine("one"); break;
                default:
                {
                    Console.WriteLine("other");
                break;
                }
            }
        }
    }
}
