using System;

namespace Demo {
    public partial class MyClass {
        // TODO: event OnSomething: EventHandler -> implement
        public event EventHandler OnSomething;
        public int Add(int a, int b) {
            return a + b;
        }
    }
}
