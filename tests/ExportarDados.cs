namespace SGUWeb {
    public partial class ExportarDados : TPageBasico2 {
        public void Button2_Click(object sender, System.EventArgs e);
        public void Button1_Click(object sender, System.EventArgs e);
        public void Page_Load(object sender, EventArgs e);
        public void Page_Load(object sender, EventArgs e) {
            base.Page_Load(sender, e);
        }
        public void Button1_Click(object sender, System.EventArgs e) {
            TFuncionario f;
            f = new TFuncionario();
            f.ConsistenciaAdicionaisFolhaLTCAT();
            f.gerarCSV(TSguUtils.PathRaizAbsoluto + '\\arquivos\\Adicionais.csv');
            hlAdicionais.Visible = true;
        }
        public void Button2_Click(object sender, System.EventArgs e) {
            TSetorAlocacao s;
            s = new TSetorAlocacao();
            s.BuscarAlocacoes();
            s.gerarCSV(TSguUtils.PathRaizAbsoluto + '\\arquivos\\Colaboradores.csv');
            hlColaboradores.Visible = true;
        }
    }
}
