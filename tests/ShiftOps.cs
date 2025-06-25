namespace Demo {
    public partial class Utils {
        public int Shifts(int maskBits) {
            var shifted = 1 << maskBits;
            var maskByte = 255 >> maskBits;
            return shifted + maskByte;
        }
    }
}
