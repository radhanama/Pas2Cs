using System;

namespace Demo {
    public partial class TypedUsing {
        public static IDisposable GetRes() {
            IDisposable result;
            result = null;
            return result;
        }
        public static void DoStuff() {
            using (IDisposable res = GetRes()) Console.WriteLine(res);
        }
    }
}
