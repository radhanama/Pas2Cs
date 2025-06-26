namespace Demo {
    public partial class CharCodeExample {
        public static string GetNewline() {
            string result;
            result = "\r" + "\n";
            return result;
        }
    }
    
    public partial class CharSeq {
        public static string GetCRLF() {
            string result;
            result = "\r\n";
            return result;
        }
    }
}
