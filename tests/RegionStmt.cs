namespace Demo {
    public partial class Foo {
        public void Test() {
            #region inner
            if (!isPostBack) {
                DoIt();
            }
            #endregion
        }
    }
}
