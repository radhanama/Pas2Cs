namespace Demo {
    public partial class RaiseComment {
        public static void Test() {
            throw new Exception("boom"); /* oops */
        }
    }
}
