namespace Demo {
    public partial class OutArg {
        public void DoStuff() {
            int d;
            bool ok;
            int frowInd;
            if (!TryEncodeDate(1, 1, 29, out d)) TryEncodeDate(1, 1, 28, out d);
            if (self.ehVazio || frowInd > self.indUltimaPos || frowInd == -1) ok = true; else ok = false;
            UseValue(ref d);
        }
    }
}
