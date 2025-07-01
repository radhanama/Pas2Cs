#region Hello
#endregion
/* comment with *** inside
     multiple lines */
/* comment
    multiple lines */
/* comment
     multiple lines */
using System;

namespace Demo {
    public partial class Commented {
        public void SayHello() {
            System.Console.WriteLine("Hello");
        }
    }
    
    public partial class Foo {
        public int ValueParen() {
            int result;
            result = 123;
            return result;
        }
        public int ValueBrace() {
            int result;
            result = 123;
            return result;
        }
        public int ValueCStyle() {
            int result;
            result = 123;
            return result;
        }
    }
}
