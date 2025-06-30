namespace Demo {
    public partial class ShortIf {
        public static string AddBr(string msg) {
            string result;
            msg = msg + (msg != "" ? "<br />" : null);
            result = msg;
            return result;
        }
    }
}
