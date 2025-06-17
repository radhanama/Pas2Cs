namespace Demo {
    public partial class RoundDouble {
        public static void Adjust(int qt_quebra) {
            if (qt_quebra > 10) qt_quebra = Math.Round((double)(qt_quebra / 3)) - 1;
        }
    }
}
