namespace Demo {
    public partial class DateParseCompare {
        public void Check(int numDias) {
            if (DateTime.Now < DateTime.parse("22/05/2025") && numDias > 9955) Console.WriteLine("ok");
        }
    }
}
