using System;

namespace Demo {
    public partial class Commented {
        public void SayHello() {
            #region Hello
            System.Console.WriteLine("Hello");
            #endregion
        }
    }
    
    public partial class Foo {
        public int ValueParen() {
            int result;
            /* comment with *** inside
                 multiple lines */
            result = 123;
            return result;
        }
        #region extra
        public int ValueBrace() {
            int result;
            /* comment
                multiple lines */
            result = 123;
            return result;
        }
        #endregion
        public int ValueCStyle() {
            int result;
            /* comment
                 multiple lines */
            result = 123;
            return result;
        }
        public void HeaderLineComment() {
            /* header comment */
            int i;
            i = 1;
        }
    }
    
    /// <remarks>
    /// comment before class
    /// </remarks>
    public partial class PreComment {
    }
}
