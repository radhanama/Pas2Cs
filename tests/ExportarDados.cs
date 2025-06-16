using System.Collections;
using System.ComponentModel;
using ShineOn.Rtl;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using SGU.Business;
using SGU.Controllers;
using MetaBuilders.WebControls;
using ShineOn.Vcl;
using C1.Win.C1Report;
using c1.Web.C1WebReport;
using log4net;
using System.Configuration;
using System.Globalization;
using System.Threading;
using System.Xml;
using System.IO;
using log4net.Config;
using c1.C1Zip;
using System.Net;
using SGU.Data.Web;
using BarcodeNETWorkShop;
using System.Text;
using System.Text.RegularExpressions;

namespace SGUWeb {
    public partial class ExportarDados : TPageBasico2 {
        public void Page_Load(object sender, EventArgs e) {
            base.Page_Load(sender, e);
        }
        public void Button1_Click(object sender, System.EventArgs e) {
            TFuncionario f;
            f = new TFuncionario();
            f.ConsistenciaAdicionaisFolhaLTCAT();
            f.gerarCSV(TSguUtils.PathRaizAbsoluto + "\\arquivos\\Adicionais.csv");
            hlAdicionais.Visible = true;
        }
        public void Button2_Click(object sender, System.EventArgs e) {
            TSetorAlocacao s;
            s = new TSetorAlocacao();
            s.BuscarAlocacoes();
            s.gerarCSV(TSguUtils.PathRaizAbsoluto + "\\arquivos\\Colaboradores.csv");
            hlColaboradores.Visible = true;
        }
    }
}
