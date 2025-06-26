namespace Demo {
    public partial class HourCheck {
        public static int ValidarHora(int hora) {
            int result;
            if (hora < 0 || hora > 23) {
                result = -1;
                return;
            }
            result = hora;
            return result;
        }
    }
}
