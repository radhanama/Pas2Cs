namespace N {
    public partial class TTest {
        public string Foo(string val) {
            string result;
            switch (val)
            {
                case 'S': result = "one"; break;
                case 'B': result = "two"; break;
            }
            return result;
        }
    }
}
