using System.Data;

namespace Demo {
    public partial class CastExample {
        public static void Run(DataSet ds) {
            ((string)ds.Tables[0].Rows[1].Item["COD"]).Trim();
            if (ds.Tables[0].Rows.Count > 10000) {
                log.Error("QUERY COM LINHAS ACIMA DO NORMAL");
                log.Error("QUERY STRING:" + sql);
                log.Error("LINHAS DA QUERY: \"" + ds.Tables[0].Rows.Count.ToString + "\"");
            }
        }
    }
}
