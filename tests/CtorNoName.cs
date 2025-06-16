namespace Demo {
    public partial class CtorNoName {
        public void Create();
        public void Create(bool flag);
        public void Destroy();
        public void Create() {
            base.Create();
        }
        public void Create(bool flag) {
            base.Create(flag);
        }
        public void Destroy() {
            base.Destroy();
        }
    }
}
