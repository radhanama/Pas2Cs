namespace Test {
    public partial class Foo {
        public int Bar() {
            int result;
            result = 1;
            return result;
        }
        public string TipoFonte() {
            string result;
            if (fonteAux.tipo.trim == "0") result = "P"; /* Fonte PUC */
            else if (fonteAux.tipo.trim == "1") result = "C"; /* Fonte Convenio */
            else result = "J"; /* Fonte Projeto */
            return result;
        }
    }
}
