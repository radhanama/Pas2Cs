namespace Demo {
    public partial class Foo {
        // TODO: field ehVazio: bool -> declare a field
        public bool ehVazio;
        // TODO: field indUltimaPos: int -> declare a field
        public int indUltimaPos;
        public bool Check(int frowInd) {
            bool result;
            if (self.ehVazio || frowInd > self.indUltimaPos || frowInd == -1) result = true; else result = false;
            return result;
        }
    }
}
