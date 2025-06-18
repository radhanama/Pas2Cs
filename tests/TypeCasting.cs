namespace Demo {
    public partial class AsExample {
        public string CastIt(object v) {
            string s;
            s = v as string;
            return s;
        }
    }
    
    public partial class AsCastCall {
        public void Update(object adapter, object ds, string name) {
            (adapter as DB2DataAdapter).Update(ds, name);
        }
    }
    
    public partial class IsExample {
        public static void Check(object o) {
            if (o is string) o = null;
        }
    }
}
