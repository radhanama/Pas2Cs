namespace Demo {
    public static partial class CtorNoName {
        public static void Create();
        public static void Create(bool flag);
        public static void Destroy();
    }
    public static partial class CtorNoName {
        public static void Create() {
            base.Create();
        }
    }
    public static partial class CtorNoName {
        public static void Create(bool flag) {
            base.Create(flag);
        }
    }
    public static partial class CtorNoName {
        public static void Destroy() {
            base.Destroy();
        }
    }
}
