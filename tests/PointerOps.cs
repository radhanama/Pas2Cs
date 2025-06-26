namespace Demo {
    public partial class PointerOps {
        public unsafe void Demo() {
            int x;
            int* p;
            int y;
            x = 5;
            p = &x;
            y = *p;
        }
    }
}
