namespace Demo {
    public partial class AsCastCall {
        public void Update(object adapter, object ds, string name) {
            (adapter as DB2DataAdapter).Update(ds, name);
        }
    }
}
