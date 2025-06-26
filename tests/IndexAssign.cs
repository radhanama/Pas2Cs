namespace Demo {
    public partial class IndexAssign {
        public int Foo(DataSet ds) {
            int result;
            DataColumn[] columns;
            columns[0] = ds.Tables["RH.HIST_FOLHA"].Columns["ANO"];
            result = 0;
            return result;
        }
    }
}
