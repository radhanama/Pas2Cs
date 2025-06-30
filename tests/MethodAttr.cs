namespace Demo {
    public partial class AttrSample {
        public static int Foo() {
            int result;
            result = 0;
            return result;
        }
        [Obsolete]
        public static int Bar(int x) {
            int result;
            result = x;
            return result;
        }
    }
    
    public partial class WebService {
        [WebMethod(EnableSession = true)]
        [ScriptMethod]
        public static string SalvarCadastro(string natrend, string prestserv, string data, string base_calculo, string vl_imposto) {
            string result;
            result = "";
            return result;
        }
        [WebMethod]
        public string DescricaoNatRend(object natrend) {
            string result;
            result = "";
            return result;
        }
    }
}
