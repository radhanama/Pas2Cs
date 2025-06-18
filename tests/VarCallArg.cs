namespace Demo {
    public partial class ExceptionDemo {
        // TODO: field _unhandledExceptionCount: int -> declare a field
        public static int _unhandledExceptionCount;
        public static void Check() {
            if (Interlocked.Exchange(ref _unhandledExceptionCount, 1) != 0) return;
        }
    }
}
