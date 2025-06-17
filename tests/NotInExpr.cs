namespace Demo {
    public partial class NotIn {
        public void Check(string tipo) {
            if (!System.Array.Exists(new[]{"Aluno", "Funcionario"}, x => x == tipo)) Console.WriteLine("nao");
        }
    }
}
