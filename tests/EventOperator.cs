using System;

namespace Demo {
    [Obsolete]
    public partial class MyClass {
        public event EventHandler OnSomething;
        public int Add(int a, int b) {
            int result;
            result = a + b;
            return result;
        }
    }
}
