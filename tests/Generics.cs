using System.Collections.Generic;
using Newtonsoft.Json.Linq;
using System.Collections;

namespace Demo {
    public partial class MyList : List<string> {
        public void Foo() {
        }
    }
    
    public partial class GenExample {
        public void UseList(List<string> l) {
            List<int> v;
            v = new List<int>();
            l.AddRange(v);
        }
        public void Parse(JObject ret) {
            Hashtable aux;
            aux = (ret as JObject).ToObject<Hashtable>();
        }
    }
    
    public partial class GenericStatic {
        public static void Use() {
            System.Collections.Generic.List<string>.Sort(null);
        }
    }
    
    public partial class GenClass {
        public static void DeSerialize<T>(string json, T obj) {
        }
    }
}
