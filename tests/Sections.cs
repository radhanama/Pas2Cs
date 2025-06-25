namespace Demo {
    public partial class Foo {
        public void Hidden() {
            System.Console.WriteLine("hidden");
        }
        public void Visible() {
            System.Console.WriteLine("visible");
        }
        public void ReallyHidden() {
            System.Console.WriteLine("really hidden");
        }
        public void PublishedMethod() {
            System.Console.WriteLine("published");
        }
    }
}
