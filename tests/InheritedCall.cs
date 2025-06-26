namespace Demo {
    public partial class Base {
        public int Foo(int a) {
            int result;
            result = a;
            return result;
        }
    }
    
    public partial class Derived : Base {
        public int Foo(int a) {
            int result;
            var request = base.Foo(a);
            result = request;
            return result;
        }
    }
}
