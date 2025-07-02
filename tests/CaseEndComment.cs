using System;

namespace Demo {
    public partial class CaseEndComment {
        public void Test(string val) {
            switch (val)
            {
                case 'A': Console.WriteLine("a"); break;
                //    'B':
                //      Console.WriteLine('b');
            }
        }
    }
}
