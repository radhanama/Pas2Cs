namespace SGUWeb {
    public static partial class ExportarDados : TPageBasico2 {
        public static void Button2_Click(object sender, System.EventArgs e);
        public static void Button1_Click(object sender, System.EventArgs e);
        public static void Page_Load(object sender, EventArgs e);
    }
    public static partial class ExportarDados {
        public static void Page_Load(object sender, EventArgs e) {
            // TODO: inherited call
        }
    }
    public static partial class ExportarDados {
        public static void Button1_Click(object sender, System.EventArgs e) {
            TFuncionario f;
            f = new TFuncionario();
            f.ConsistenciaAdicionaisFolhaLTCAT();
            f.gerarCSV(TSguUtils.PathRaizAbsoluto + '\\arquivos\\Adicionais.csv');
            hlAdicionais.Visible = true;
        }
    }
    public static partial class ExportarDados {
        public static void Button2_Click(object sender, System.EventArgs e) {
            TSetorAlocacao s;
            s = new TSetorAlocacao();
            s.BuscarAlocacoes();
            s.gerarCSV(TSguUtils.PathRaizAbsoluto + '\\arquivos\\Colaboradores.csv');
            hlColaboradores.Visible = true;
        }
    }
}
