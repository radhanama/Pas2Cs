namespace Demo {
    public static partial class IndexAssign {
        public static int Foo(DataSet ds);
    }
    public static partial class IndexAssign {
        public static int Foo(DataSet ds) {
            DataColumn[] columns;
            columns[0] = ds.Tables['RH.HIST_FOLHA'].Columns['ANO'];
            return 0;
        }
    }
}
