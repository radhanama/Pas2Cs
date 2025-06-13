namespace Demo {
    public static partial class Sample {
        // TODO: field count: int -> declare a field
        public int count;
        // TODO: property Name: string -> implement as auto-property
        public string Name { get; set; }
        // TODO: const DefaultCount -> define a constant
        public const int DefaultCount = 10;
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
