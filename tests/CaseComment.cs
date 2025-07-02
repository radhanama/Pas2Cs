using System;

namespace Demo {
    public partial class CaseComment {
        public void Test(char val) {
            switch (val)
            {
                /* A */
                case 'A': Console.WriteLine("a"); break;
                /* B */
                case 'B': Console.WriteLine("b"); break;
            }
        }
    }
}

