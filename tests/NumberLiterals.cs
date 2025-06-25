namespace Demo {
    public partial class NumberLiterals {
        // TODO: const HexVal -> define a constant
        public const int HexVal = 0x1A;
        // TODO: const BinVal -> define a constant
        public const int BinVal = 0b1011;
        public int Value() {
            return HexVal + BinVal;
        }
    }
}
