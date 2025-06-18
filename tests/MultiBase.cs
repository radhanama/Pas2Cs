namespace Demo {
    public partial class BaseCls {
        public void BaseMethod() {
        }
    }
    
    public partial class Child : BaseCls, IFoo, IBar {
        public void BaseMethod() {
        }
        public void Foo() {
        }
        public void Bar() {
        }
    }
}
