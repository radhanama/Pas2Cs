using System;

namespace Demo {
    public partial class RaiseExample {
        public static void DoRaise() {
            throw new Exception("fail");
        }
    }
}
