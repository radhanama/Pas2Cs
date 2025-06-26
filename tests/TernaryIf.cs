namespace Demo {
    public partial class Utils {
        public int Pick(int a, int b) {
            var res = (a > b) ? a : b;
            return res;
        }
    }
}
