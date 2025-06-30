namespace Demo {
    public partial class LambdaClass {
        public bool Run() {
            var predicate = i => i > 0;
            var eq = (a, b) => a == b;
            return predicate(5) && eq(5, 5);
        }
    }
}
