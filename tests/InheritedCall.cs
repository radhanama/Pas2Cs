namespace Demo {
    public partial class Base {
        public int Foo(int a) {
            return a;
        }
    }
    
    public partial class Derived : Base {
        public int Foo(int a) {
            var request = base.Foo(a);
            return request;
        }
    }
}
