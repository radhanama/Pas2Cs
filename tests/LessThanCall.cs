namespace Demo {
    public static partial class DateCheck {
        public static void Test();
    }
    public static partial class DateCheck {
        public static void Test() {
            if (DateTime.Today < (DateTime)0) return;
        }
    }
}
