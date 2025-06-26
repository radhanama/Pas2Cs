namespace Demo {
    public partial class SguUtils {
        public static DateTime UltimoDiaMes(int mes, int ano) {
            DateTime result;
            TDateTime d;
            if (mes == 2) {
                if (!TryEncodeDate(ano, mes, 29, out d)) TryEncodeDate(ano, mes, 28, out d);
                result = d;
            } else if (mes == 1 || mes == 3 || mes == 5 || mes == 7 || mes == 8 || mes == 10 || mes == 12) {
                TryEncodeDate(ano, mes, 31, out d);
                result = d;
            } else {
                TryEncodeDate(ano, mes, 30, out d);
                result = d;
            }
            return result;
        }
    }
}
