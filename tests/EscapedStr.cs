namespace Demo {
    public partial class EscapedStr {
        public string GetSql(string ano, string mes);
        public string GetSql(string ano, string mes) {
            return 'WHERE ANO = ''' + ano + ''' AND MES = ''' + mes + '''';
        }
    }
}
