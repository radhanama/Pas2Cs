namespace SGUWeb;

interface

uses System.Collections, System.ComponentModel, ShineOn.Rtl,System.Data,System.Drawing,System.Web,System.Web.SessionState,  System.Web.UI, System.Web.UI.WebControls,System.Web.UI.HtmlControls,  SGU.Business, SGU.Controllers, MetaBuilders.WebControls, ShineOn.Vcl, C1.Win.C1Report, c1.Web.C1WebReport, log4net, System.Configuration, System.Globalization, System.Threading, System.Xml, System.IO, log4net.Config, c1.C1Zip, System.Net, SGU.Data.Web,  BarcodeNETWorkShop, System.Text, System.Text.RegularExpressions;

type
  ExportarDados = public partial class(TPageBasico2)
  protected
    method Button2_Click(sender: System.Object; e: System.EventArgs);
    method Button1_Click(sender: System.Object; e: System.EventArgs);
    method Page_Load(sender: Object; e: EventArgs);override;
  end;

implementation

method ExportarDados.Page_Load(sender: Object; e: EventArgs);
begin
  inherited;
end;

method ExportarDados.Button1_Click(sender: System.Object; e: System.EventArgs);
var
  f:TFuncionario;
begin
  
  f := new TFuncionario;
  f.ConsistenciaAdicionaisFolhaLTCAT();

  f.gerarCSV(TSguUtils.PathRaizAbsoluto + '\\arquivos\\Adicionais.csv');
  
  hlAdicionais.Visible := true;
end;

method ExportarDados.Button2_Click(sender: System.Object; e: System.EventArgs);
var s: TSetorAlocacao;
begin
  s:= new TSetorAlocacao;

  s.BuscarAlocacoes;
  s.gerarCSV(TSguUtils.PathRaizAbsoluto + '\\arquivos\\Colaboradores.csv');

  hlColaboradores.Visible := true;

end;

end.
