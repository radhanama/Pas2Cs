using System.Data;

namespace Demo {
    public partial class TypeOfExpr {
        public void AddCol(DataTable dt) {
            dt.Columns.Add("Count", typeof(int));
        }
    }
}
