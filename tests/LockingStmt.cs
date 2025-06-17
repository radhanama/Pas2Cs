namespace Demo {
    public partial class LockingExample {
        public static void Run(object obj) {
            lock (obj) Console.WriteLine("locked");
        }
    }
}
