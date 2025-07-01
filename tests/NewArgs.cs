namespace Demo {
    public partial class Foo {
        public static void Make() {
            System.Collections.Generic.List<int> t;
            t = new System.Collections.Generic.List<int>(5);
        }
        public static void Named() {
            Demo.Bar v;
            v = new Demo.Bar(1, "a");
        }
    }
}
