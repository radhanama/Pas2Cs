namespace Demo {
    public partial class TypeOfNew {
        public static Byte[] MakeArray(int len) {
            return new Byte[len];
        }
        public static void Show() {
            Console.WriteLine(typeof(int));
        }
    }
}
