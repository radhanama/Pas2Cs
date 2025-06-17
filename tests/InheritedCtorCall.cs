namespace Demo {
    public partial class Base {
        public void Create() {
        }
    }
    
    public partial class Derived : Base {
        public void Create() {
            base.Create();
        }
    }
}
