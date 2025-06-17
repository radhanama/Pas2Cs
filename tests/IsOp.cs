namespace Demo {
    public partial class IsExample {
        public static void Check(object o) {
            if (o is string) o = null;
        }
    }
}
