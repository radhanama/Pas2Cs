namespace Demo {
    public partial class LambdaClass {
        public bool Run() {
            var predicate = i => i > 0;
            return predicate(5);
        }
    }
}
