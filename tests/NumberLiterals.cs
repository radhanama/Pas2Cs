namespace Demo {
    public partial class NumberLiterals {
        public const int HexVal = 0x1A;
        public const int BinVal = 0b1011;
        public int Value() {
            int result;
            result = HexVal + BinVal;
            return result;
        }
    }
}
