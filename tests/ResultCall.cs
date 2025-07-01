namespace Demo {
    public partial class TRetornoZoom {
    }
    
    public partial class Foo {
        public TRetornoZoom Response(string body_string) {
            TRetornoZoom result;
            result = new TRetornoZoom();
            result.definirMensagem("00", body_string);
            return result;
        }
    }
}
