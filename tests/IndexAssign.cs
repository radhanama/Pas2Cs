namespace Demo {
    public partial class IndexAssign {
        public int Foo(DataSet ds) {
            DataColumn[] columns;
            columns[0] = ds.Tables['RH.HIST_FOLHA'].Columns['ANO'];
            return 0;
        }
    }
}
