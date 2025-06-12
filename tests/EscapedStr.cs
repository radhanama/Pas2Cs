namespace Demo {
    public static partial class EscapedStr {
        public static string GetSql(string ano, string mes);
    }
    public static partial class EscapedStr {
        public static string GetSql(string ano, string mes) {
            return 'WHERE ANO = ''' + ano + ''' AND MES = ''' + mes + '''';
        }
    }
}
