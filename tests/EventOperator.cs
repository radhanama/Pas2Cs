using System;

namespace Demo {
    public partial class MyClass {
        // TODO: event OnSomething: EventHandler -> implement
        public event EventHandler OnSomething;
        public int Add(int a, int b) {
            int result;
            result = a + b;
            return result;
        }
    }
}
