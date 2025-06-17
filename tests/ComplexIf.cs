using System.Collections.Generic;

namespace Demo {
    public partial class ComplexIf {
        public static void Check(object v, Dictionary<string, int> dict, int[] arr) {
            if ((int)v > dict["foo"] && arr[0] < dict.Count && dict.ContainsKey("bar") || arr.Length > 0) Console.WriteLine("ok");
        }
    }
}
