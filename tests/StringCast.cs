using System.Data;

namespace Demo {
    public partial class CastExample {
        public static void Run(DataSet ds) {
            ((string)ds.Tables[0].Rows[1].Item["COD"]).Trim();
        }
    }
}
