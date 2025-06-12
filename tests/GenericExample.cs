namespace Example {
    public static partial class GenExample {
        public static void UseList(List<string> l);
    }
    public static partial class GenExample {
        public static void UseList(List<string> l) {
            List<int> v;
            v = new List<int>();
            l.AddRange(v);
        }
    }
}
