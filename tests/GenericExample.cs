namespace Example {
    public partial class GenExample {
        public void UseList(List<string> l) {
            List<int> v;
            v = new List<int>();
            l.AddRange(v);
        }
    }
}
