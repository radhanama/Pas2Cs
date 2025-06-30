namespace Demo {
    public partial class AsExample {
        public string CastIt(object v) {
            string result;
            string s;
            s = v as string;
            result = s;
            return result;
        }
    }
    
    public partial class AsCastCall {
        public void Update(object adapter, object ds, string name) {
            (adapter as DB2DataAdapter).Update(ds, name);
        }
        public void SetText(object ctrl, string valor) {
            (ctrl as TextBox).Text = valor;
        }
    }
    
    public partial class IsExample {
        public static void Check(object o) {
            if (o is string) o = null;
        }
    }
}
