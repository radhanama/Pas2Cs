namespace Demo {
    public partial class StrayBrace {
        public static void Demo() {
            System.Console.WriteLine("hi");
            System.Console.WriteLine("there"); /* System.Console.WriteLine('ignored'); */
        }
    }
}
