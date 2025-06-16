using System.Data;

namespace Demo {
    public partial class MyClass {
        public DataSet myfunction(string idAutor, string idLicit, string situacao, string dtIniEmissao, string dtFimEmissao, string idCC, string idMetaFase) {
            TStringList strSql;
            DateTime dtIni, dtFim;
            strSql = new TStringList();
            strSql.Add("my sql");
            if (!String.isNullOrEmpty(idAutor) && idAutor != "-1") strSql.Add("my sql " + idAutor.ToString);
            if (!String.isNullOrEmpty(idLicit)) strSql.Add("my sql" + idLicit + ")");
            if (!String.isNullOrEmpty(idCC) && idCC != "-1") strSql.Add("my sql " + idCC);
            if (!String.isNullOrEmpty(idMetaFase)) strSql.Add("my sql" + idMetaFase);
            if (!String.isNullOrEmpty(situacao)) strSql.Add("my sql '" + situacao + "'");
            if (!String.isNullOrEmpty(dtIniEmissao)) {
                dtIni = StrToDate(dtIniEmissao);
                strSql.Add("my sql '" + dtIni.Tostring("yyyy-MM-dd") + "'");
            }
            if (!String.isNullOrEmpty(dtFimEmissao)) {
                dtFim = StrToDate(dtFimEmissao);
                strSql.Add("my sql '" + dtFim.Tostring("yyyy-MM-dd") + "'");
            }
            strSql.Add("my sql");
            return helper.openSQL(strSql.Text);
        }
    }
}
