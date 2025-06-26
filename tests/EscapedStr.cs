namespace Demo {
    public partial class EscapedStr {
        public string GetSql(string ano, string mes) {
            string result;
            result = "WHERE ANO = '" + ano + "' AND MES = '" + mes + "'";
            return result;
        }
    }
}
