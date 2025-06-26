namespace Demo {
    public partial class TypeOfNew {
        public static byte[] MakeArray(int len) {
            return new byte[len];
        }
        public static void Show() {
            Console.WriteLine(typeof(int));
        }
    }
}
