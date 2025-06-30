namespace Demo {
    public partial class StringLiteralCall {
        public bool Demo() {
            bool result;
            result = "abc".ToUpper() == "ABC";
            return result;
        }
    }
}
