namespace Demo {
    public partial class Utils {
        public void Sanitize(Char ch, Char[] invalidChars, StringBuilder sanitizedInput) {
            if (Array.IndexOf(invalidChars, ch) == -1) sanitizedInput.Append(ch); else sanitizedInput.Append("_");
        }
    }
}
