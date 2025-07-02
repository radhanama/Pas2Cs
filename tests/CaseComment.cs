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
        public void CommentedBranch(char val) {
            switch (val)
            {
                case 'A': Console.WriteLine("a"); break;
                /* 'B': */
                /* Console.WriteLine('b'); */
                case 'C': Console.WriteLine("c"); break;
            }
        }
    }
}

