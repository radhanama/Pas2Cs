namespace Demo {
    public static partial class Sample {
        // TODO: field count: int
        // TODO: property Name: string
        // TODO: const DefaultCount
        public static void Create();
        public static void Destroy();
    }
    public static partial class Sample {
        public static void Create() {
            base.Create();
        }
    }
    public static partial class Sample {
        public static void Destroy() {
            base.Destroy();
        }
    }
}
