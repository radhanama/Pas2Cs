using System.Data;

namespace Demo {
    public partial class CastExample {
        public static void Run(DataSet ds) {
            ((string)ds.Tables[0].Rows[1].Item["COD"]).Trim();
            if (ds.Tables[0].Rows.Count > 10000) {
                log.Error("QUERY COM LINHAS ACIMA DO NORMAL");
                log.Error("QUERY STRING:" + sql);
                log.Error("LINHAS DA QUERY: \"" + ds.Tables[0].Rows.Count.ToString() + "\"");
            }
        }
    }
    
    public partial class RoundDouble {
        public static void Adjust(int qt_quebra) {
            if (qt_quebra > 10) qt_quebra = Math.Round((double)(qt_quebra / 3)) - 1;
        }
    }
}
