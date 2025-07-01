namespace Demo {
    public partial class Tnulo {
        public int fInt;
        public int @int { get => fInt; set => fInt = value; }
    }
    
    public partial class TUse {
        public void DoIt(Tnulo n) {
            n.@int = 5;
        }
    }
}
