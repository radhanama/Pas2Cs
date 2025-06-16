namespace Demo {
    public partial class Sample {
        // TODO: field count: int -> declare a field
        public int count;
        // TODO: property Name: string -> implement as auto-property
        public string Name { get; set; }
        // TODO: const DefaultCount -> define a constant
        public const int DefaultCount = 10;
        public void Create();
        public void Destroy();
        public void Create() {
            base.Create();
        }
        public void Destroy() {
            base.Destroy();
        }
    }
}
