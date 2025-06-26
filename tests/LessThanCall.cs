using System;

namespace Demo {
    public partial class DateCheck {
        public static void Test() {
            if (DateTime.Today < (DateTime)0) return;
        }
    }
}
