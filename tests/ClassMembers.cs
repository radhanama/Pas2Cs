namespace Demo {
    public partial class Sample {
        // TODO: field count: int -> declare a field
        public int count;
        public string Name { get => get_Name; set => set_Name = value; }
        // TODO: const DefaultCount -> define a constant
        public const int DefaultCount = 10;
        public void Create() {
            base.Create();
        }
        public void Destroy() {
            base.Destroy();
        }
    }
}
