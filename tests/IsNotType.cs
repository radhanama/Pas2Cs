namespace Demo {
    public partial class IsNotExample {
        public void Check(object o) {
            if (o is not string) Console.WriteLine("not string");
        }
    }
}
