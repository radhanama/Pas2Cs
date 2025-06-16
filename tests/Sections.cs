namespace Demo {
    public partial class Foo {
        public void Hidden();
        public void Visible();
        public void Hidden() {
            System.Console.WriteLine('hidden');
        }
        public void Visible() {
            System.Console.WriteLine('visible');
        }
    }
}
