using System;

namespace Demo {
    public partial class Commented {
        public void SayHello() {
            /* region Hello */
            System.Console.WriteLine("Hello");
            /* endregion */
        }
    }
    
    public partial class Foo {
        /* $REGION 'extra' */
        /* $ENDREGION */
        public int ValueParen() {
            int result;
            /* comment with *** inside
                 multiple lines */
            result = 123;
            return result;
        }
        public int ValueBrace() {
            int result;
            /* comment
                multiple lines */
            result = 123;
            return result;
        }
        public int ValueCStyle() {
            int result;
            /* comment
                 multiple lines */
            result = 123;
            return result;
        }
    }
}
