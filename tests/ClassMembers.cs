namespace Demo {
    public static partial class Sample {
        // TODO: field count: int -> declare a field
        // TODO: property Name: string -> implement as auto-property
        // TODO: const DefaultCount -> define a constant
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
