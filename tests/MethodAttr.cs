namespace Demo {
    public partial class AttrSample {
        public static int Foo() {
            int result;
            result = 0;
            return result;
        }
        [Obsolete]
        public static int Bar(int x) {
            int result;
            result = x;
            return result;
        }
    }
}
