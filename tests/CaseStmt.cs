namespace N {
    public partial class TTest {
        public void Foo(int x) {
            switch (x)
            {
                case 1: return; break;
                case 2: return; break;
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
