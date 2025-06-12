namespace Demo {
    public static partial class Foo {
        public static void Hidden();
        public static void Visible();
    }
    public static partial class Foo {
        public static void Hidden() {
            System.Console.WriteLine('hidden');
        }
    }
    public static partial class Foo {
        public static void Visible() {
            System.Console.WriteLine('visible');
        }
    }
}

