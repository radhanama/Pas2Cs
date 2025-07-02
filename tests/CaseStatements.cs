using System;

namespace N {
    public partial class TTest {
        public void SimpleCase(int x) {
            switch (x)
            {
                case 1: return; break;
                case 2: return; break;
            }
        }
        public void WithElse(int x) {
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
        public void Empty(int x) {
            switch (x)
            {
                case 1: Console.WriteLine("one"); break;
                default:
                {
                break;
                }
            }
        }
        public string UpperCase(string val) {
            string result;
            switch (val)
            {
                case 'S': result = "one"; break;
                case 'B': result = "two"; break;
            }
            return result;
        }
        public void CommentBranch(string val) {
            switch (val)
            {
                case 'FIRST':{
                    {
                        Console.WriteLine("one");
                    }
                break;
                }
                case 'SECOND':
                /* after colon comment */
                {
                    {
                        Console.WriteLine("two");
                    }
                break;
                }
            }
        }
    }
    
    public partial class EnumCase {
        public void WeekDay(DayOfWeek day) {
            switch (day)
            {
                case DayOfWeek.Friday: System.Console.WriteLine("fri"); break;
                case DayOfWeek.Monday: System.Console.WriteLine("mon"); break;
            }
        }
    }
}
