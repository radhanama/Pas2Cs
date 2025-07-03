using LogManager;

namespace Demo {
    public partial class Example {
        public static void Test() {
            LogManager.GetLogger(typeof(Example).ToString());
        }
    }
}
