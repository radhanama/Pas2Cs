
namespace SGUWeb;

interface

uses System.Collections, System.ComponentModel, ShineOn.Rtl,System.Data,System.Drawing,System.Web,System.Web.SessionState,  System.Web.UI, System.Web.UI.WebControls,System.Web.UI.HtmlControls,  SGU.Business, SGU.Controllers, MetaBuilders.WebControls, ShineOn.Vcl, C1.Win.C1Report, c1.Web.C1WebReport, log4net, System.Configuration, System.Globalization, System.Threading, System.Xml, System.IO, log4net.Config, c1.C1Zip, System.Net, SGU.Data.Web,  BarcodeNETWorkShop, System.Text, System.Text.RegularExpressions;

type
  TNFPedidoPage = public class(TPageBasico2)
  {$REGION 'Designer Managed Code'}
  private
    method btnCancelarEdicao_Click(sender: System.Object; e: System.EventArgs);
    method btnEditaNF_Click(sender: System.Object; e: System.EventArgs);
    method btnAbrirOC_Click(sender: System.Object; e: System.EventArgs);
    procedure InitializeComponent;
    procedure Button1_Click(sender: System.Object; e: System.EventArgs);
    procedure cmbCC_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
    procedure cmbFonte_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
    procedure cmbMetaFase_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
    procedure rbTipoDespesa_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
    procedure btnAdicionarItem_Click(sender: System.Object; e: System.EventArgs);
    procedure btnAdicionar_Click(sender: System.Object; e: System.EventArgs);
    procedure lkbBuscaEmpresa_Click(sender: System.Object; e: System.EventArgs);
    procedure CVDtVencimento_ServerValidate(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);
    procedure btnSalvar_Click(sender: System.Object; e: System.EventArgs);
    procedure CVDtEmissao_ServerValidate(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);
    procedure dgItem_EditCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure dgItem_CancelCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure dgItem_DeleteCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure dgItem_UpdateCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure dgParcelaPgto_CancelCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure dgParcelaPgto_DeleteCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure dgParcelaPgto_EditCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure dgParcelaPgto_UpdateCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure CustomValidator1_ServerValidate(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);
    procedure txtDescricaoGeral_TextChanged(sender: System.Object; e: System.EventArgs);
    procedure CustomValidator2_ServerValidate(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);
    procedure btnConfirmar_Click(sender: System.Object; e: System.EventArgs);
    procedure btnBuscarPedido_Click(sender: System.Object; e: System.EventArgs);
    procedure Button1_Click1(sender: System.Object; e: System.EventArgs);
    procedure btnAdicionar_Click1(sender: System.Object; e: System.EventArgs);
    procedure CVDtEmissao_ServerValidate1(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);
    procedure CustomValidator3_ServerValidate(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);
    procedure dgHistorico_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
    procedure lkbExibeHist_Click(sender: System.Object; e: System.EventArgs);
    procedure lbkOcultarHist_Click(sender: System.Object; e: System.EventArgs);
    procedure dgItemDoc_DeleteCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure CustomValidator4_ServerValidate(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);
    procedure dgParcelaPgto_CancelCommand1(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure dgParcelaPgto_DeleteCommand1(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure dgParcelaPgto_EditCommand1(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure dgParcelaPgto_UpdateCommand1(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure btnImprimir_Click(sender: System.Object; e: System.EventArgs);
    procedure CustomValidator2_ServerValidate1(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);
    procedure btnExcluir_Click(sender: System.Object; e: System.EventArgs);
    procedure lkbNumPedido_Click(sender: System.Object; e: System.EventArgs);
    procedure dgHistorico_DeleteCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure dgHistorico_ItemDataBound(sender: System.Object; e: System.Web.UI.WebControls.DataGridItemEventArgs);
    procedure CVProcImportacao_ServerValidate(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);
    procedure btnVoltar_Click(sender: System.Object; e: System.EventArgs);
    
  {$ENDREGION}
  private
  protected
    pnForm1: System.Web.UI.WebControls.Panel;


    pnFormulario: System.Web.UI.WebControls.Panel;
    pnMensagem: System.Web.UI.WebControls.Panel;
    pnLinhaDigitavel: System.Web.UI.WebControls.Panel;
    Label1: System.Web.UI.WebControls.Label;
    //txtLinhaDigitavel: System.Web.UI.WebControls.TextBox;
    txtNumPedido: System.Web.UI.WebControls.TextBox;
    pnNumProcessoImportacao: System.Web.UI.WebControls.Panel;
    RequiredFieldValidator5: System.Web.UI.WebControls.RequiredFieldValidator;
    pnAtesto: System.Web.UI.WebControls.Panel;
    uploadArea: SGUWeb.TUploadEventoAnexoUC;
    Panel2: System.Web.UI.WebControls.Panel;
    Panel3: System.Web.UI.WebControls.Panel;
    Label6: System.Web.UI.WebControls.Label;
    ckbAtestoForm: System.Web.UI.WebControls.CheckBox; 
    ckbCartao: System.Web.UI.WebControls.CheckBox; 
    Label20: System.Web.UI.WebControls.Label;
    Label18: System.Web.UI.WebControls.Label;
    pnlNotaFiscal: System.Web.UI.WebControls.Panel;
    pnForm2: System.Web.UI.WebControls.Panel;
    Label3: System.Web.UI.WebControls.Label;
    Panel6: System.Web.UI.WebControls.Panel;
    txtDescricaoGeral: System.Web.UI.WebControls.TextBox;
    txtOBS: System.Web.UI.WebControls.TextBox;
    CVProcImportacao: System.Web.UI.WebControls.CustomValidator;
    Panel7: System.Web.UI.WebControls.Panel;
    Label4: System.Web.UI.WebControls.Label;
    Panel8: System.Web.UI.WebControls.Panel;
    Panel9: System.Web.UI.WebControls.Panel;
    Panel10: System.Web.UI.WebControls.Panel;
    Panel12: System.Web.UI.WebControls.Panel;
    Panel13: System.Web.UI.WebControls.Panel;
    Panel14: System.Web.UI.WebControls.Panel;
    Panel15: System.Web.UI.WebControls.Panel;
    Panel16: System.Web.UI.WebControls.Panel;
    Panel17: System.Web.UI.WebControls.Panel;
    Panel18: System.Web.UI.WebControls.Panel;
    Panel19: System.Web.UI.WebControls.Panel;
    Panel20: System.Web.UI.WebControls.Panel;
    Panel21: System.Web.UI.WebControls.Panel;
    Panel22: System.Web.UI.WebControls.Panel;
    Panel23: System.Web.UI.WebControls.Panel;
    Panel24: System.Web.UI.WebControls.Panel;
    dgItem: System.Web.UI.WebControls.DataGrid;
    dgPatrimonio: System.Web.UI.WebControls.DataGrid;
    Label12: System.Web.UI.WebControls.Label;
    btnEditaNF: System.Web.UI.WebControls.Button;
    btnAprovar: System.Web.UI.WebControls.Button;
    btnAbrirOC: System.Web.UI.WebControls.Button;
    btnCancelarEdicao: System.Web.UI.WebControls.Button;
    btnAdicionar: System.Web.UI.WebControls.Button;
    pnAdicionarCronograma: System.Web.UI.WebControls.Panel;
    Label27: System.Web.UI.WebControls.Label;
    lbDiffValor: System.Web.UI.WebControls.Label;
    Panel120: System.Web.UI.WebControls.Panel;
    lbTitCronograma: System.Web.UI.WebControls.Label;
    Label10: System.Web.UI.WebControls.Label;
    Panel25: System.Web.UI.WebControls.Panel;
    Panel26: System.Web.UI.WebControls.Panel;
    cmbFormaPagtoParcela: System.Web.UI.WebControls.DropDownList;
    Panel27: System.Web.UI.WebControls.Panel;
    Panel28: System.Web.UI.WebControls.Panel;
    Panel29: System.Web.UI.WebControls.Panel;
    Panel30: System.Web.UI.WebControls.Panel;
    Panel31: System.Web.UI.WebControls.Panel;
    Panel32: System.Web.UI.WebControls.Panel;
    Panel33: System.Web.UI.WebControls.Panel;
    Panel34: System.Web.UI.WebControls.Panel;
    Panel35: System.Web.UI.WebControls.Panel;
    Panel36: System.Web.UI.WebControls.Panel;
    Panel37: System.Web.UI.WebControls.Panel;
    Panel38: System.Web.UI.WebControls.Panel;
    Panel39: System.Web.UI.WebControls.Panel;
    Panel45: System.Web.UI.WebControls.Panel;
    dgParcelaPgto: System.Web.UI.WebControls.DataGrid;
    Panel47: System.Web.UI.WebControls.Panel;
    Panel50: System.Web.UI.WebControls.Panel;
    Panel51: System.Web.UI.WebControls.Panel;
    Panel52: System.Web.UI.WebControls.Panel;
    Panel53: System.Web.UI.WebControls.Panel;
    Panel54: System.Web.UI.WebControls.Panel;
    PnExibirHistorico: System.Web.UI.WebControls.Panel;
    rbIndRemessa: System.Web.UI.WebControls.RadioButtonList;
    pnForm4: System.Web.UI.WebControls.Panel;
    btnSalvar: System.Web.UI.WebControls.Button;
    Panel57: System.Web.UI.WebControls.Panel;
    Panel58: System.Web.UI.WebControls.Panel;
    Panel59: System.Web.UI.WebControls.Panel;
    Label14: System.Web.UI.WebControls.Label;
    Label19: System.Web.UI.WebControls.Label;
    CustomValidator1: System.Web.UI.WebControls.CustomValidator;
    Panel65: System.Web.UI.WebControls.Panel;
    Panel66: System.Web.UI.WebControls.Panel;
    Panel67: System.Web.UI.WebControls.Panel;
    Panel68: System.Web.UI.WebControls.Panel;
    Panel69: System.Web.UI.WebControls.Panel;
    Panel70: System.Web.UI.WebControls.Panel;
    Panel71: System.Web.UI.WebControls.Panel;
    Panel72: System.Web.UI.WebControls.Panel;
    Panel73: System.Web.UI.WebControls.Panel;    
    Panel74: System.Web.UI.WebControls.Panel;
    txtDiasVencimentoParcela: System.Web.UI.WebControls.TextBox;
    Panel75: System.Web.UI.WebControls.Panel;
    Panel76: System.Web.UI.WebControls.Panel;
    Panel77: System.Web.UI.WebControls.Panel;
    Panel78: System.Web.UI.WebControls.Panel;
    Panel79: System.Web.UI.WebControls.Panel;
    Panel80: System.Web.UI.WebControls.Panel;
    Panel81: System.Web.UI.WebControls.Panel;
    pnNumPedido: System.Web.UI.WebControls.Panel;
    btnBuscarPedido: System.Web.UI.WebControls.Button;
    lbNomeEmpresa: System.Web.UI.WebControls.Label;
    lbCC: System.Web.UI.WebControls.Label;
    lbFonte: System.Web.UI.WebControls.Label;
    lbMetaFase: System.Web.UI.WebControls.Label;
    lbDtEntrada: System.Web.UI.WebControls.Label;
    Panel1: System.Web.UI.WebControls.Panel;
    Panel5: System.Web.UI.WebControls.Panel;
    Button1: System.Web.UI.WebControls.Button;
    Panel11: System.Web.UI.WebControls.Panel;
    lbQtdReceb: System.Web.UI.WebControls.Label;
    txtQtdRecebida: System.Web.UI.WebControls.TextBox;
    Panel56: System.Web.UI.WebControls.Panel;
    dgItemDoc: System.Web.UI.WebControls.DataGrid;
    Panel83: System.Web.UI.WebControls.Panel;
    Panel84: System.Web.UI.WebControls.Panel;
    Label25: System.Web.UI.WebControls.Label;
    cmbNumParcelas: System.Web.UI.WebControls.DropDownList;
    pnForm3: System.Web.UI.WebControls.Panel;
    Label17: System.Web.UI.WebControls.Label;
    Label21: System.Web.UI.WebControls.Label;
    txtDtEmissao: System.Web.UI.WebControls.TextBox;
    Label22: System.Web.UI.WebControls.Label;
    CVDtEmissao: System.Web.UI.WebControls.CustomValidator;
    Label11: System.Web.UI.WebControls.Label;
    txtDtVencimento: System.Web.UI.WebControls.TextBox;
    Panel4: System.Web.UI.WebControls.Panel;
    CustomValidator3: System.Web.UI.WebControls.CustomValidator;
    Panel40: System.Web.UI.WebControls.Panel;
    Label7: System.Web.UI.WebControls.Label;
    Panel41: System.Web.UI.WebControls.Panel;
    Panel42: System.Web.UI.WebControls.Panel;
    Panel43: System.Web.UI.WebControls.Panel;
    Label8: System.Web.UI.WebControls.Label;
    txtNumDoc: System.Web.UI.WebControls.TextBox;
    Panel44: System.Web.UI.WebControls.Panel;
    CustomValidator4: System.Web.UI.WebControls.CustomValidator;
    txtNumProcImportacao: System.Web.UI.WebControls.TextBox;
    Panel46: System.Web.UI.WebControls.Panel;
    txtSerie: System.Web.UI.WebControls.TextBox;
    Label9: System.Web.UI.WebControls.Label;
    Panel48: System.Web.UI.WebControls.Panel;
    Label23: System.Web.UI.WebControls.Label;
    Panel60: System.Web.UI.WebControls.Panel;
    dgHistorico: System.Web.UI.WebControls.DataGrid;
    Panel61: System.Web.UI.WebControls.Panel;
    Panel62: System.Web.UI.WebControls.Panel;
    pnHistorico: System.Web.UI.WebControls.Panel;
    Label13: System.Web.UI.WebControls.Label;
    lbTotalPago: System.Web.UI.WebControls.Label;
    Panel49: System.Web.UI.WebControls.Panel;
    Panel64: System.Web.UI.WebControls.Panel;
    Panel85: System.Web.UI.WebControls.Panel;
    dgImposto: System.Web.UI.WebControls.DataGrid;
    pnDetalheHist: System.Web.UI.WebControls.Panel;
    Panel88: System.Web.UI.WebControls.Panel;
    lkbExibeHist: System.Web.UI.WebControls.LinkButton;
    dgCondicaoPgtoDoc: System.Web.UI.WebControls.DataGrid;
    Panel89: System.Web.UI.WebControls.Panel;
    Panel90: System.Web.UI.WebControls.Panel;
    Panel91: System.Web.UI.WebControls.Panel;
    Panel92: System.Web.UI.WebControls.Panel;
    Panel93: System.Web.UI.WebControls.Panel;
    Panel55: System.Web.UI.WebControls.Panel;
    lbkOcultarHist: System.Web.UI.WebControls.LinkButton;
    Panel63: System.Web.UI.WebControls.Panel;
    Panel87: System.Web.UI.WebControls.Panel;
    Panel94: System.Web.UI.WebControls.Panel;
    Panel95: System.Web.UI.WebControls.Panel;
    Panel97: System.Web.UI.WebControls.Panel;
    Panel98: System.Web.UI.WebControls.Panel;
    Label15: System.Web.UI.WebControls.Label;
    Panel99: System.Web.UI.WebControls.Panel;
    Panel100: System.Web.UI.WebControls.Panel;
    Panel101: System.Web.UI.WebControls.Panel;
    Label16: System.Web.UI.WebControls.Label;
    Panel86: System.Web.UI.WebControls.Panel;
    Panel102: System.Web.UI.WebControls.Panel;
    Panel103: System.Web.UI.WebControls.Panel;
    Panel96: System.Web.UI.WebControls.Panel;
    Panel104: System.Web.UI.WebControls.Panel;
    Panel105: System.Web.UI.WebControls.Panel;
    Panel106: System.Web.UI.WebControls.Panel;
    dgItemDocHist: System.Web.UI.WebControls.DataGrid;
    Panel107: System.Web.UI.WebControls.Panel;
    Panel108: System.Web.UI.WebControls.Panel;
    Label24: System.Web.UI.WebControls.Label;
    Panel109: System.Web.UI.WebControls.Panel;
    Panel110: System.Web.UI.WebControls.Panel;
    Panel111: System.Web.UI.WebControls.Panel;
    Label26: System.Web.UI.WebControls.Label;
    lbSitPedido: System.Web.UI.WebControls.Label;
    Panel112: System.Web.UI.WebControls.Panel;
    Label28: System.Web.UI.WebControls.Label;
    lbSaldoAntecipado: System.Web.UI.WebControls.Label;
    Panel113: System.Web.UI.WebControls.Panel;
    Panel114: System.Web.UI.WebControls.Panel;
    Panel115: System.Web.UI.WebControls.Panel;
    Panel116: System.Web.UI.WebControls.Panel;
    Label29: System.Web.UI.WebControls.Label;
    Panel117: System.Web.UI.WebControls.Panel;
    Panel118: System.Web.UI.WebControls.Panel;
    btnImprimir: System.Web.UI.WebControls.Button;
    Panel119: System.Web.UI.WebControls.Panel;
    HyperLink1: System.Web.UI.WebControls.HyperLink;
    Label30: System.Web.UI.WebControls.Label;
    txtSitPedido: System.Web.UI.WebControls.TextBox;
    Panel121: System.Web.UI.WebControls.Panel;
    Label31: System.Web.UI.WebControls.Label;
    cmbServPuc: System.Web.UI.WebControls.DropDownList;
    RequiredFieldValidator3: System.Web.UI.WebControls.RequiredFieldValidator;
    
    pnServPuc: System.Web.UI.WebControls.Panel;
    Panel122: System.Web.UI.WebControls.Panel;
    Panel123: System.Web.UI.WebControls.Panel;
    Label32: System.Web.UI.WebControls.Label;
    Label33: System.Web.UI.WebControls.Label;
    Label34: System.Web.UI.WebControls.Label;
    Label35: System.Web.UI.WebControls.Label;
    Label36: System.Web.UI.WebControls.Label;
    Panel82: System.Web.UI.WebControls.Panel;
    Panel124: System.Web.UI.WebControls.Panel;
    lbNumBanco: System.Web.UI.WebControls.Label;
    Panel125: System.Web.UI.WebControls.Panel;
    Panel126: System.Web.UI.WebControls.Panel;
    Panel127: System.Web.UI.WebControls.Panel;
    lbNumAgencia: System.Web.UI.WebControls.Label;
    Panel128: System.Web.UI.WebControls.Panel;
    Panel129: System.Web.UI.WebControls.Panel;
    Panel130: System.Web.UI.WebControls.Panel;
    lbNumCC: System.Web.UI.WebControls.Label;
    Panel131: System.Web.UI.WebControls.Panel;
    Panel132: System.Web.UI.WebControls.Panel;
    Panel133: System.Web.UI.WebControls.Panel;
    CustomValidator2: System.Web.UI.WebControls.CustomValidator;
    Panel134: System.Web.UI.WebControls.Panel;
    Panel135: System.Web.UI.WebControls.Panel;
    btnExcluir: System.Web.UI.WebControls.Button;
    Panel136: System.Web.UI.WebControls.Panel;
    lkbNumPedido: System.Web.UI.WebControls.LinkButton;
    Label37: System.Web.UI.WebControls.Label;
    txtProcImportacao: System.Web.UI.WebControls.TextBox;
    btnAbreImport: System.Web.UI.HtmlControls.HtmlInputButton;
    btnVoltar: System.Web.UI.WebControls.Button;
    Panel137: System.Web.UI.WebControls.Panel;
    
    
    detDoc: SGUWeb.TExibeDetDocUC;
    method btnAprovarDocumento(sender: System.Object; e: System.EventArgs);
    procedure OnInit(e: EventArgs); override;
    procedure Page_Load(sender: System.Object; e: System.EventArgs); override;    
        
  private
    procedure buscarDocumento;
    function  getControlador() :TControladorMaterial;
    method cmbFormaPagtoParcela_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
    method ckbCartaoCheckedChanged(sender: System.Object; e: System.EventArgs);
    procedure preencheFonte(usuario: TUsuario; idCC :string);
    procedure preencheMeta(usuario: TUsuario; idCC :string);
    procedure preencheCentroCusto(usuario: TUsuario);
    procedure carregaTipoDespesa;
    procedure atualizaDiffValorParcela;
    procedure cargaFormulario;
    procedure preparaGridItemPedido;
    procedure preparaGridItemDoc;
    procedure preparaGridParcela;
    procedure atualizarValorTotalItens;
    procedure salvarPedido;
    procedure desabilitarEdicao;
    function buscarHistoricoPedido : DataSet;
    procedure preparaGridHistorico;
    procedure exibeHistorico;
    procedure ocultarHistorico;
    procedure exibeEscolhaNumPedido;
    procedure atualizarSituacaoDoc;
    procedure preparaProcessoImportacao;
    procedure exibeDetalheNota;    
    procedure salvarBoletos;
    function confirmar(var msg : String) : Boolean;
  public

  end;

implementation


{$REGION 'Designer Managed Code'}
/// <summary>
/// Required method for Designer support -- do not modify
/// the contents of this method with the code editor.
/// </summary>
procedure TNFPedidoPage.InitializeComponent;
begin
  Self.btnBuscarPedido.Click +=  Self.btnBuscarPedido_Click;
  Self.CVProcImportacao.ServerValidate +=  Self.CVProcImportacao_ServerValidate;
  Self.CVDtEmissao.ServerValidate +=  Self.CVDtEmissao_ServerValidate1;
  Self.CustomValidator3.ServerValidate +=  Self.CustomValidator3_ServerValidate;
  Self.lkbNumPedido.Click +=  Self.lkbNumPedido_Click;
  Self.CustomValidator4.ServerValidate +=  Self.CustomValidator4_ServerValidate;
  Self.dgItem.CancelCommand +=  Self.dgItem_CancelCommand;
  Self.dgItem.EditCommand +=  Self.dgItem_EditCommand;
  Self.dgItem.UpdateCommand +=  Self.dgItem_UpdateCommand;
  Self.dgItem.DeleteCommand +=  Self.dgItem_DeleteCommand;  
  Self.Button1.Click +=  Self.Button1_Click1;
  Self.CustomValidator2.ServerValidate +=  Self.CustomValidator2_ServerValidate1;
  Self.dgItemDoc.DeleteCommand +=  Self.dgItemDoc_DeleteCommand;
  self.btnEditaNF.Click += self.btnEditaNF_Click;
  self.btnAprovar.Click += self.btnAprovarDocumento;;
  self.btnAbrirOC.Click += self.btnAbrirOC_Click;
  self.btnCancelarEdicao.Click += self.btnCancelarEdicao_Click;
  Self.btnAdicionar.Click +=  Self.btnAdicionar_Click1;
  Self.CustomValidator1.ServerValidate +=  Self.CustomValidator1_ServerValidate;
  Self.dgParcelaPgto.CancelCommand +=  Self.dgParcelaPgto_CancelCommand1;
  Self.dgParcelaPgto.EditCommand +=  Self.dgParcelaPgto_EditCommand1;
  Self.dgParcelaPgto.UpdateCommand +=  Self.dgParcelaPgto_UpdateCommand1;
  Self.dgParcelaPgto.DeleteCommand +=  Self.dgParcelaPgto_DeleteCommand1;
  self.ckbCartao.CheckedChanged += self.ckbCartaoCheckedChanged;
  Self.lkbExibeHist.Click +=  Self.lkbExibeHist_Click;
  Self.lbkOcultarHist.Click +=  Self.lbkOcultarHist_Click;
  Self.dgHistorico.DeleteCommand +=  Self.dgHistorico_DeleteCommand;
  Self.dgHistorico.ItemDataBound +=  Self.dgHistorico_ItemDataBound;
  Self.dgHistorico.SelectedIndexChanged +=  Self.dgHistorico_SelectedIndexChanged;
  //self.cmbFormaPagtoParcela.SelectedIndexChanged +=  cmbFormaPagtoParcela_SelectedIndexChanged;
  Self.btnSalvar.Click +=  Self.btnSalvar_Click;  
  Self.btnImprimir.Click +=  Self.btnImprimir_Click;
  Self.btnExcluir.Click +=  Self.btnExcluir_Click;
  Self.btnVoltar.Click +=  Self.btnVoltar_Click;
  Self.Load +=  Self.Page_Load;
end;
{$ENDREGION}

procedure TNFPedidoPage.OnInit(e: EventArgs);
begin
  //
  // Required for Designer support
  //
    if not DesignMode then initializeComponent;
  inherited OnInit(e);
end;

procedure TNFPedidoPage.Page_Load(sender: System.Object; e: System.EventArgs);
var
 usuario : TUsuario;
begin
  inherited;
  if not Self.IsPostBack then
  begin    
    usuario := TUSuario(session['usuario']);
     getControlador.setUsuario(usuario);    
     getControlador.iniciar;
     preencheCentroCusto(usuario);
     cmbServPuc.Items.Insert(0, '');
     pnServPuc.visible := false;
     pnNumProcessoImportacao.Visible := false;

     lbDtEntrada.Text := Datetime.Today.ToString(TSGUUtils.fmtData);

     {cmbCondicao.DataSource := getControlador.getDSCondicaopgtoDoc;
     cmbCondicao.DataBind;
    }

      exibeEscolhaNumPedido;

   if Request.Params['MSG'] <> nil then
    begin
      TPageHelper.alert( String(Request.Params['MSG']) , self);
    end;

    if Request.Params['id_doc'] <> nil then
    begin
      getControlador.carregarDocumentoNFPorIdDoc(StrToInt(Request.Params['id_doc']));
      cargaFormulario;
      btnVoltar.Visible :=true;
    end
    else if Request.Params['num_pedido'] <> nil then
    begin
      txtNumPedido.Text :=  Request.Params['num_pedido'].ToString;
      btnBuscarPedido_Click(nil,nil);
      btnVoltar.Visible :=false;
    end;


  {
    if Request.Params['num_pedido'] <> nil then
    begin
      getControlador.carregarDocumento(StrToInt(Request.Params['num_pedido']));
      cargaFormulario;
    end;
   }

  end;
end;

procedure TNFPedidoPage.preencheCentroCusto(usuario: TUsuario);
begin

end;

procedure TNFPedidoPage.carregaTipoDespesa;
var
  ds: DataSet;
begin
end;

procedure TNFPedidoPage.atualizaDiffValorParcela;
var
  vlDiff : double;
  vlPago, vl : double;
begin
  //vlDiff := getControlador.getItemPedido.getTotal - getControlador.getCondicaoPagamento.getTotal;
  vlDiff := getControlador.getItemDoc.getTotal ;
  vlPago := getControlador.getVlTotalConsumido;
  vl := getControlador.getItemDoc.getTotal -vlPago;
  btnAdicionar.enabled := true;
  if vl <= 0 then
  begin
    vl := 0.0;
    btnAdicionar.enabled := false;
  end;


  lbDiffValor.Text := vlDiff.ToString(TSGUUtils.fmtValor);
  lbSaldoAntecipado.Text := vlPago.ToString(TSGUUtils.fmtValor);
  lbTotalPago.Text := vl.ToString(TSGUUtils.fmtValor);

  if lbTotalPago.Text = '0,00' then
    btnAdicionar.enabled := false;

 // txtVlParcela.Text := vlDiff.ToString(TSGUUtils.fmtValorSemVirgula);
end;

procedure TNFPedidoPage.cargaFormulario;
var
  pedido: TPedido;
  docDespesa: TDocumentoDespesa;
  empresa : TEmpresa;
  procImport : TProcessoImportacao;
    docCartao : TDocumentoCartao;
    dv : DataView;
begin
  pedido := getControlador.getPedido;
  docDespesa := getControlador.getDocDespesa;

  pnNumPedido.Visible := false;
  pnForm1.visible := true;
  pnForm2.visible := true;
  pnForm3.visible := true;
  pnForm4.visible := true;
  self.ocultarHistorico;

     dv := new DataView (getControlador.getFormaPgto.Tables[0]);
    dv.RowFilter := 'COMPL_VALOR <> ''DA''';
   

  cmbFormaPagtoParcela.DataSource := dv;
  cmbFormaPagtoParcela.DataBind;
  cmbFormaPagtoParcela_SelectedIndexChanged(nil, nil);

  {if getControlador.existeARMAssociada then
  begin
    txtQtdRecebida.Visible := false;
    lbQtdReceb.Visible := false;
  end;
  }


  txtNumPedido.Text := pedido.numPedido.toString;
  lbSitPedido.Text := pedido.getDescricaoSitPedido;
  lkbNumPedido.text := pedido.numPedido.toString;

  empresa := pedido.getEmpresa;
  lbNomeEmpresa.Text := empresa.nomeEmpresa.Trim;
  lbNumBanco.Text := TSGUUtils.testarStrNulo(empresa.numBanco);
  lbNumAgencia.Text := empresa.getAgenciaComDV;
  lbNumCC.Text := empresa.getNumCCComDV;
  lbCC.text := pedido.getCentroCusto.descCC.Trim;
  lbFonte.Text := pedido.getFonte.tit_fonte.Trim;
  lbMetaFase.Text := pedido.getMetaFase.controle;
  txtNumProcImportacao.Text  := getControlador.testarStrNulo(docDespesa.numProcesso);

  pnAtesto.Visible := false;
 if pedido.getMetaFase.idEvento <> TNulo.int then
 begin
     pnAtesto.Visible := true;
 end;

  //lbDtEntrada.Text := getControlador.testarDthNulo(pedido.dataCriacao);
  txtDescricaoGeral.Text := pedido.descPedido.Trim;
  preparaGridItemPedido;
  preparaGridItemDoc;
  preparaGridParcela;  
  btnExcluir.Enabled := false;
  txtNumDoc.text := getControlador.testarStrNulo( docDespesa.numDoc);
  ckbAtestoForm.Checked := (docDespesa.indAtesto = 'S');
  txtOBS.Text := TSGUUtils.testarStrNulo(docDespesa.justificativa);
  txtSerie.text := getControlador.testarStrNulo( docDespesa.serie);
  txtDtEmissao.text := getControlador.testarDthNulo(docDespesa.dataEmissao);
  txtDtVencimento.text := getControlador.testarDthNulo(docDespesa.dataValidade);  
  txtProcImportacao.Text  := getControlador.testarStrNulo(docDespesa.numProcesso);
  atualizarSituacaoDoc;

  pnServPuc.Visible := getControlador.getItemDoc.possuiItemServico;
  cmbServPuc.SelectedValue := getControlador.testarStrNulo(docDespesa.indServicoPUC);
  
  preparaProcessoImportacao;

   if pnNumProcessoImportacao.Visible then
   begin
      procImport := new  TProcessoImportacao;
      procImport.ConsultaProcesso(getControlador.testarStrNulo(docDespesa.numProcesso));
      if (not procImport.ehVazio) and (procImport.iND_REMESSA = 'S') then
        rbIndRemessa.SelectedValue := 'S';
    
   end;

   ckbCartao.visible := false;
   if getControlador.existeARMAssociada then
   begin
    ckbCartao.visible := true;
    docCartao := new TDocumentoCartao;
    docCartao.buscarPorIdDoc(docDespesa.idDoc);
    ckbCartao.checked := (not docCartao.ehVazio);
    ckbCartaoCheckedChanged(nil, nil);

   end;
  if not docDespesa.podeAlterar then
  begin
    if not  ( ( (docDespesa.sitDoc.Trim = 'PROTOCOLADO') or (docDespesa.sitDoc.Trim = 'DOC APROVADO')) and (docDespesa.ehUsuarioEspecial(TUsuario(session['usuario']).idUsuario ))) then
      desabilitarEdicao;
    btnImprimir.enabled := true;
  end
  else if not docDespesa.ehNova then
  begin
    btnImprimir.enabled := true;
    btnExcluir.Enabled := true;
  end;

  if docDespesa.sitDoc.Trim = 'PENDENTE' then
    btnImprimir.Enabled := false;    

  if docDespesa.ehDocumentoAntecipado then
  begin
     //Panel113.Visible := false;
     //Panel120.Visible := false;
     //Panel49.Visible := false;
     pnForm2.Visible := false;
     desabilitarEdicao;
     btnImprimir.Enabled := true;
  end;
    
  preparaGridHistorico;  

  if not docDespesa.ehNova then
  begin
    exibeDetalheNota;
  end;

end;

procedure TNFPedidoPage.preparaGridItemDoc;
begin
  dgItemDoc.DataSource := getControlador.getItemDoc.defaultDataSet;
  dgItemDoc.DataBind;
  atualizaDiffValorParcela;
end;

procedure TNFPedidoPage.preparaGridItemPedido;
begin
  dgItem.DataSource := getControlador.getItemPedido.defaultDataSet;
  dgItem.DataBind;
  atualizarValorTotalItens;
end;

procedure TNFPedidoPage.preparaGridParcela;
begin

  dgParcelaPgto.DataSource := getControlador.getCondicaoPgtoDoc.defaultDataSet;
  dgParcelaPgto.DataBind;
  
  dgParcelaPgto.Columns[5].Visible := (getControlador.getCondicaoPgtoDoc.formaPgto='BO');
  atualizaDiffValorParcela;
end;

procedure TNFPedidoPage.atualizarSituacaoDoc;
begin
  lbSitPedido.Text := getControlador.getPedido.getDescricaoSitPedido;
  txtSitPedido.text := GetControlador.testarStrNulo( getControlador.getDocDespesa.getDescricaoSitDoc);
end;

procedure TNFPedidoPage.btnVoltar_Click(sender: System.Object; e: System.EventArgs);
begin
  TPageHelper.voltarNavegacao(self);
end;

procedure TNFPedidoPage.dgHistorico_ItemDataBound(sender: System.Object; e: System.Web.UI.WebControls.DataGridItemEventArgs);
var
  lit : ListItemType;
  li : ListItem;
  de : LinkButton;
  tipoDoc : string;
begin
  lit := e.Item.ItemType;

  If (e.Item.ItemType <> ListItemType.Header) AND (e.Item.ItemType <> ListItemType.Footer) then
  begin
    de := LinkButton(e.Item.Cells[2].Controls[0]);


    tipoDoc := e.Item.Cells[1].Text.Trim;
    de.Enabled := (tipoDoc = 'DIRETA') or (tipoDoc = 'REGULAR');
  end;


end;

procedure TNFPedidoPage.dgHistorico_DeleteCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
var
  idDoc, tipoDoc : string;
  irow : integer;
begin
  idDoc  := dgHistorico.Items[e.Item.ItemIndex].Cells[0].Text.trim;
  tipoDoc  := dgHistorico.Items[e.Item.ItemIndex].Cells[1].Text.trim;

  if tipoDoc.trim = 'DIRETA' then
    response.Redirect('/SGUWeb/material/CompraDireta.aspx?id_doc=' + idDoc)
  else
    response.Redirect('/SGUWeb/material/NFPedido.aspx?id_doc=' + idDoc);

end;

procedure TNFPedidoPage.lkbNumPedido_Click(sender: System.Object; e: System.EventArgs);
begin
  response.redirect('OrdemCompra.aspx?num_pedido='+ getControlador.getPedido.numPedido.ToString)
end;

procedure TNFPedidoPage.btnExcluir_Click(sender: System.Object; e: System.EventArgs);
var
  docDesp : TDocumentoDespesa;
  msg : String;
begin
  docDesp := getControlador.getDocDespesa;
  if docDesp.ehDocumentoAntecipado then
  begin
    TPageHelper.alert('Documentos antecipados devem ser excluídos na própria ordem de compra (excluindo a parcela)', self.Page);
    exit;
  end;

  getControlador.excluirNFPedido(msg);
  response.redirect('NFPedido.aspx?num_pedido='+ getControlador.getPedido.numPedido.ToString+ '&MSG=' + Server.HtmlEncode(msg))
end;

procedure TNFPedidoPage.CustomValidator2_ServerValidate1(source: System.Object;
  args: System.Web.UI.WebControls.ServerValidateEventArgs);
begin
  args.IsValid := not getControlador.getItemDoc.ehVazio;
end;

procedure TNFPedidoPage.atualizarValorTotalItens;
begin
end;

procedure TNFPedidoPage.salvarPedido;
var
  pedido: TPedido;
begin
  salvarBoletos;

  pedido := getControlador.getPedido;
  if getControlador.getDocDespesa.ehDocumentoAntecipado then
  begin
    TPageHelper.alert('Documentos antecipados não podem ser alterados', self.Page);
    exit;
  end;

  if pnNumProcessoImportacao.Visible then
  begin
    txtProcImportacao.Text := txtNumProcImportacao.Text.Trim;
    getControlador.adicionarNumProcessoImport(txtNumProcImportacao.Text.Trim, rbIndRemessa.SelectedValue = 'S');
  end;
  if getControlador.getDocDespesa.sitDoc.Trim = 'AGUARD APROV DOC' then
    TPageHelper.alert('Um novo nº de protocolo foi gerado! É necessário imprimir novamente o documento para recebimento na Tesouraria', self.Page);
  getControlador.salvarNFPedido(txtNumDoc.Text.ToUpper, txtSerie.Text.Trim, txtOBS.Text, txtDescricaoGeral.Text, cmbServPuc.SelectedValue, txtNumProcImportacao.text.trim, StrToDate(txtDtVencimento.Text.Trim), StrToDate(lbDtEntrada.Text.Trim), StrToDate(txtDtEmissao.Text.Trim), ckbCartao.Checked );
  
  

  getControlador.verificaMudancaEstadoPedido;
  atualizarSituacaoDoc;

  if pnAtesto.Visible then
  begin
    var docDesp : TDocumentoDespesa := getControlador.getDocDespesa;
    if ckbAtestoForm.Checked then
        docDesp.indAtesto := 'S'
    else
        docDesp.indAtesto := 'N';

    docDesp.salvar();
        
  end;

  if getControlador.existeARMAssociada then
      getControlador.setCondicaoPagamentoCartao(ckbCartao.checked);
end;

procedure TNFPedidoPage.desabilitarEdicao;
begin
  TPageHelper.DesabilitarCamposEditaveis(pnForm1.Controls);
  TPageHelper.DesabilitarCamposEditaveis(pnForm2.Controls);
  TPageHelper.DesabilitarCamposEditaveis(pnForm3.Controls);  
  TPageHelper.DesabilitarCamposEditaveis(pnForm4.Controls);  
  TPageHelper.DesabilitarCamposEditaveis(pnNumProcessoImportacao.Controls);
  btnVoltar.Enabled := true;

  dgItemDoc.Columns[dgItemDoc.Columns.Count-1].Visible := false;
  dgParcelaPgto.Columns[dgParcelaPgto.Columns.Count-1].Visible := false;
  dgParcelaPgto.Columns[dgParcelaPgto.Columns.Count-2].Visible := false;
end;

procedure TNFPedidoPage.CustomValidator3_ServerValidate(source: System.Object;
  args: System.Web.UI.WebControls.ServerValidateEventArgs);
var
  dt, dtLimite, dtEmissao : DateTime;
begin
  if String.isNullOrEmpty(txtDtVencimento.Text.Trim) then
  begin
    CustomValidator(source).ErrorMessage := 'Data de Validade obrigatória';
    args.isValid := false;
    exit;
  end;

  try
    dt := StrToDate(txtDtVencimento.Text.Trim);
  except
    CustomValidator(source).ErrorMessage := 'Data de Validade inválida';
    args.isValid := false;
    exit;
  end;
 


  dtLimite := TFeriadoPuc.somaDiasUteis(Datetime.Today,3);
  if dt < dtLimite then
  begin
    CustomValidator(source).ErrorMessage := 'A Data de Validade deve ser a partir de ' + dtLimite.toString(TSGUUtils.fmtData);
    args.isValid := false;
    exit;
  end;

end;

procedure TNFPedidoPage.CVDtEmissao_ServerValidate1(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);
var
  dt : DateTime;
begin
  if String.isNullOrEmpty(txtDtEmissao.Text.Trim) then
  begin
    CustomValidator(source).ErrorMessage := 'Data de Emissão obrigatória';
    args.isValid := false;
    exit;
  end;

  try
    dt := StrToDate(txtDtEmissao.Text.Trim);
  except
    CustomValidator(source).ErrorMessage := 'Data de Emissão inválida';
    args.isValid := false;
    exit;
  end;

  if dt < DateTime.Today.AddMonths(-2) then
  begin
    CustomValidator(source).ErrorMessage := 'A Data de Emissão não inferior a 2 meses da data atual';
    args.isValid := false;
    exit;
  end;

  if dt > DateTime.Today then
  begin
    CustomValidator(source).ErrorMessage := 'A Data de Emissão não pode ser futura';
    args.isValid := false;
    exit;
  end;

end;

procedure TNFPedidoPage.btnAdicionar_Click1(sender: System.Object; e: System.EventArgs);
var
  msg : string;
begin

  if getControlador.adicionarParcelasNFPedido(cmbNumParcelas.SelectedValue, txtDtVencimento.Text.Trim, cmbFormaPagtoParcela.SelectedValue, cmbFormaPagtoParcela.SelectedItem.Text, msg) then
  begin
    preparaGridParcela;    
    atualizaDiffValorParcela;
  end
  else
  begin
    TPageHelper.alert(msg, self.Page); 
  end;

end;

procedure TNFPedidoPage.Button1_Click1(sender: System.Object; e: System.EventArgs);
var
  radio :RowSelectorColumn;
  selIndex : integer;
  qtd, id, qtdDesp : string;
  msg : string;

begin
  radio := dgItem.Columns[dgItem.Columns.Count -1] as RowSelectorColumn;

  try
    selIndex := radio.SelectedIndexes[0] ;
  except
    TPageHelper.alert('Selecione um item', self.page);
    exit;
  end;

  if selIndex < 0 then
  begin
    TPageHelper.alert('Selecione um item', self.page);
    exit;
  end;

  id := dgItem.Items[selIndex].Cells[0].Text;
  qtdDesp :=  dgItem.Items[selIndex].Cells[4].Text;
  qtd := txtQtdRecebida.Text;

  if not getControlador.adicionarItemDoc(id, qtdDesp, qtd, msg) then
  begin
    TPageHelper.alert(msg, self.page);
    exit;
  end;

  self.preparaGridItemDoc;
  preparaGridItemPedido;
  pnServPuc.Visible := getControlador.getItemDoc.possuiItemServico;  

end;

procedure TNFPedidoPage.btnBuscarPedido_Click(sender: System.Object; e: System.EventArgs);
var
  numPedido : integer;
begin
  try
    numPedido := StrToInt (txtNumPedido.Text.Trim);
  except
    TPageHelper.alert('Nº de pedido inválido', self.Page);
    exit;
  end;

  getControlador.carregarNovaNFPedido(numPedido);
  

  if (getControlador.getPedido.sitPedido <> 'E') and
  (getControlador.getPedido.sitPedido <> 'M') then
  begin
    TPageHelper.alert('Apenas pedidos Emitidos ou Parcialmente Atendidos podem ser informados', self.Page);
    exit;
  end;

  if getControlador.existemPedidosAntecipadosNaoProtocolados(numPedido) then
  begin
    TPageHelper.alert('Existem pagamentos antecipados que não foram entregues na tesouraria. Regularize a situação antes de cadastrar a nota!', self.Page);
    exit;
  end;

  cargaFormulario;

end;

procedure TNFPedidoPage.btnConfirmar_Click(sender: System.Object; e: System.EventArgs);
var
  msg : string;
begin
  if self.IsValid then
  begin
    salvarPedido;
    if (getControlador.validarDisponibilidadeOrcamentaria(msg)) then
    begin
      if not  ( ( (getControlador.getDocDespesa.sitDoc.Trim = 'PROTOCOLADO') or (getControlador.getDocDespesa.sitDoc.Trim = 'DOC APROVADO')) and (getControlador.getDocDespesa.ehUsuarioEspecial(TUsuario(session['usuario']).idUsuario ))) then
      begin
        getControlador.getDocDespesa.sitDoc := 'AGUARD APROV DOC';
        getControlador.getDocDespesa.idUsuario := TUsuario(session['usuario']).idUsuario;
      end;
      atualizarSituacaoDoc;
      getControlador.verificaMudancaEstadoPedido;
      getControlador.getDocDespesa.salvar;
      btnImprimir.enabled := true;
      TPageHelper.alert('Dados salvos com sucesso', self.Page);      
      txtNumPedido.Text := getControlador.getPedido.numPedido.ToString;
      desabilitarEdicao;            
      btnImprimir.enabled := true;
    end
    else
    begin
      TPageHelper.alert(msg, self.Page);
    end;

  end;
end;

procedure TNFPedidoPage.CustomValidator2_ServerValidate(source: System.Object;
  args: System.Web.UI.WebControls.ServerValidateEventArgs);
begin
  if String.isNullOrEmpty(txtDescricaoGeral.Text.Trim) then
  begin
    CustomValidator(source).ErrorMessage := 'Descrição geral obrigatória';
    args.IsValid := false;
    exit;
  end;

  if txtDescricaoGeral.Text.Trim.Length > 100 then
  begin
    CustomValidator(source).ErrorMessage := 'O tamanho da descrição geral excede o tamanho máximo de 100 caracteres (tamanho atual é de ' +
    txtDescricaoGeral.Text.Trim.Length.ToString + ' caracteres' ;
    args.IsValid := false;
    exit;
  end;

  if getControlador.existeARMAssociada then
  begin
    
  end;


end;

procedure TNFPedidoPage.txtDescricaoGeral_TextChanged(sender: System.Object;
  e: System.EventArgs);
var
  msg : string;
begin
  msg := 'O tamanho da descrição geral excede o tamanho máximo de 100 caracteres (tamanho atual é de ' +
    txtDescricaoGeral.Text.Trim.Length.ToString + ' caracteres' ;
  if txtDescricaoGeral.Text.Trim.Length > 100 then
    TPageHelper.alert(msg, self.page);
end;

procedure TNFPedidoPage.CustomValidator1_ServerValidate(source: System.Object;
  args: System.Web.UI.WebControls.ServerValidateEventArgs);
var
  msg : string;
  
  i: Integer;
  linhaDigit : String;
  condPgtoAux : TCondicaoPgtoDoc;
  hs : System.Collections.Generic.HashSet<String>;
  linhaDigitAux : String;
begin
  args.IsValid := true;

   if (not btnAdicionar.Enabled) and (dgItem.Items.Count = 0) then
    exit;

  if not getControlador.validarParcelamentoNFPedido(msg) then
  begin
    args.IsValid := false;
    CustomValidator(source).ErrorMessage := msg;
  end;

    if  (dgParcelaPgto.Columns[5].Visible) then
  begin
    hs := new System.Collections.Generic.HashSet<String>;
    condPgtoAux := new TCondicaoPgtoDoc;
    for i := 0 to dgParcelaPgto.Items.Count -1 do
    begin
      linhaDigit := TSGUutils.formataBoleto( textBox(dgParcelaPgto.Items[i].Cells[5].FindControl('txtBoleto')).Text);

      
        if not TSGUUtils.ValidarCodigoBarra(linhaDigit.Replace('.','').Replace(' ','')) then
        begin
          args.IsValid := false;
          CustomValidator1.ErrorMessage := 'Nº do boleto da parcela ' + (i+1).ToString + ' inválido!';

          exit;
        end;

         
      condPgtoAux.buscarPorNumBoleto(linhaDigit);
      if (not condPgtoAux.ehVazio) and (condPgtoAux.idDoc <> getControlador.getDocDespesa.idDoc) then
      begin
        args.IsValid := false;
          CustomValidator1.ErrorMessage  := 'Nº do boleto da parcela ' + (i+1).ToString + ' já foi cadastrado!';        
         exit;
      end;

      if hs.Contains(linhaDigit) then
      begin
        args.IsValid := false;
          CustomValidator1.ErrorMessage := 'Boleto ' + linhaDigit + ' duplicado';
        exit;
      end;

      hs.Add(linhaDigit);

    end;
  end;

  
end;

procedure TNFPedidoPage.dgParcelaPgto_UpdateCommand(source: System.Object;
  e: System.Web.UI.WebControls.DataGridCommandEventArgs);
var
  nivel1, nivel2 : string;
  vl : double;
  dt, dtLimite : Datetime;
  strVl, strDt, strQtd : string;
  txtDt, txtBoxVl : textBox;
  condPgto : TCondicaoPagamento;
begin

  condPgto :=  getControlador.getCondicaoPagamento;

  txtBoxVl:= textbox(e.item.cells[3].controls[0]);
  txtDt:= textbox(e.item.cells[4].controls[0]);

  strVl := txtBoxVl.Text.Trim.Replace('.', '');


  try
    vl := double.parse(strVl);
  except
    TPageHelper.alert('Valor inválido', self.Page);
    exit;
  end;

  try
    dt := StrToDate(txtDt.Text.Trim);
  except
    TPageHelper.alert('Data inválida', self.Page);
    exit;
  end;

  if dt > Datetime.Today.AddMonths(6) then
  begin
    TPageHelper.alert('A data não pode ser ultrapassar 6 meses', self.Page);
    exit;
  end;

  //{
  dtLimite := TFeriadoPuc.somaDiasUteis(Datetime.Today,3);
  if condPgto.condicaoPgto='BOLETO' then
    dtLimite := Datetime.Today;
  if dt <dtLimite then
  begin
    TPageHelper.alert('A data não pode ser inferior a ' + dtLimite.ToString(TSGUUtils.fmtData), self.Page);
    exit;
  end;
//}
  //Marcos - Solicitação do Gustavo / Pedro Estagiário 24/01/2017
  //dtLimite := TFeriadoPUC.proximoDiaUtil(Datetime.Today.AddDays(2));
  //if dt <dtLimite then
  if dt < DateTime.Now.Date then
  begin
    //alert('A data não pode ser inferior a ' + dtLimite.ToString(TSGUUtils.fmtData));
    TPageHelper.alert('A data não pode ser inferior a data corrente.', self.Page);
    exit;
  end;


  condPgto.irParaIndice(e.Item.DataSetIndex);

  condPgto.dtVencimento := dt;
  condPgto.vlParcela := vl;

  dgParcelaPgto.EditItemIndex := -1;
  self.preparaGridParcela;
  self.atualizaDiffValorParcela;

end;

procedure TNFPedidoPage.dgParcelaPgto_EditCommand(source: System.Object;
  e: System.Web.UI.WebControls.DataGridCommandEventArgs);
begin
  dgParcelaPgto.DataSource := getControlador.getCondicaoPagamento.defaultDataSet;
  dgParcelaPgto.EditItemIndex:= e.Item.ItemIndex;
  dgParcelaPgto.databind;
end;

procedure TNFPedidoPage.dgParcelaPgto_DeleteCommand(source: System.Object;
  e: System.Web.UI.WebControls.DataGridCommandEventArgs);
var
  condPgto : TCondicaoPagamento;
begin
  condPgto :=  getControlador.getCondicaoPagamento;
  condPgto.defaultDataTable.DefaultView.Delete(e.Item.DataSetIndex);
  condPgto.ultimo;
  dgParcelaPgto.DataSource := condPgto.defaultDataSet;

  TPageHelper.FazerDataBindExclusao(dgParcelaPgto);
  self.atualizaDiffValorParcela;

end;

procedure TNFPedidoPage.dgParcelaPgto_CancelCommand(source: System.Object;
  e: System.Web.UI.WebControls.DataGridCommandEventArgs);
begin
   dgParcelaPgto.EditItemIndex := -1;
   preparaGridParcela;
end;

procedure TNFPedidoPage.dgItem_UpdateCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
var
  itemPedido : TItemPedido;
  nivel1, nivel2 : string;
  vl : double;
  qtd : integer;
  strVl, strDesc, strQtd : string;
  txtBoxDesc, txtBoxQtd, txtBoxVl : textBox;
begin
  itemPedido :=  getControlador.getItemPedido;

  nivel1 := e.item.cells[2].Text.Trim;
  nivel2 := e.item.cells[3].Text.Trim;

  txtBoxDesc:= textbox(e.item.cells[1].controls[0]);
  txtBoxQtd:= textbox(e.item.cells[4].controls[0]);
  txtBoxVl:= textbox(e.item.cells[5].controls[0]);

  strVl := txtBoxVl.Text.Trim.Replace('.', '');
  strQtd := txtBoxQtd.Text.Trim.Replace('.', '');


  try
    vl := double.parse(strVl);
  except
    TPageHelper.alert('Valor inválido', self.Page);
    exit;
  end;

  try
    qtd := StrToInt(strQtd);
  except
    TPageHelper.alert('Quantidade inválida', self.Page);
    exit;
  end;

  itemPedido.irParaIndice(e.Item.DataSetIndex);
  itemPedido.valorItem := vl;
  itemPedido.qtdItemEncomenda := qtd;
  itemPedido.descItem :=  txtBoxDesc.Text;

  dgItem.EditItemIndex := -1;
  self.preparaGridItemPedido;
  self.atualizarValorTotalItens;

end;

procedure TNFPedidoPage.dgItem_DeleteCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
var
  itemPedido : TItemPedido;
  idDet : Integer;
begin
  itemPedido :=  getControlador.getItemPedido;
  idDet  := StrToInt(dgItem.Items[e.Item.ItemIndex].Cells[0].Text.trim);
  
  itemPedido.defaultDataTable.DefaultView.Delete(e.Item.DataSetIndex);
  itemPedido.ultimo;
  dgItem.DataSource := itemPedido.defaultDataSet;

  TPageHelper.FazerDataBindExclusao(dgItem);
  self.atualizarValorTotalItens;

end;

procedure TNFPedidoPage.dgItem_CancelCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
begin
  dgItem.DataSource := getControlador.getItemPedido.defaultDataSet;
  dgItem.EditItemIndex:= -1;
  dgItem.databind;
end;

procedure TNFPedidoPage.dgItem_EditCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
begin
  dgItem.DataSource := getControlador.getItemPedido.defaultDataSet;
  dgItem.EditItemIndex:= e.Item.ItemIndex;
  dgItem.databind;
end;

procedure TNFPedidoPage.CVDtEmissao_ServerValidate(source: System.Object;
  args: System.Web.UI.WebControls.ServerValidateEventArgs);
var
  dt : DateTime;
begin
  if String.isNullOrEmpty(txtDtEmissao.Text.Trim) then
  begin
    CustomValidator(source).ErrorMessage := 'Data de Emissão obrigatória';
    args.isValid := false;
    exit;
  end;

  try
    dt := StrToDate(txtDtEmissao.Text.Trim);
  except
    CustomValidator(source).ErrorMessage := 'Data de Emissão inválida';
    args.isValid := false;
    exit;
  end;

  if dt < DateTime.Today.AddMonths(-6) then
  begin
    CustomValidator(source).ErrorMessage := 'A Data de Emissão não inferior a 6 meses da data atual';
    args.isValid := false;
    exit;
  end;

  if dt > DateTime.Today then
  begin
    CustomValidator(source).ErrorMessage := 'A Data de Emissão não pode ser futura';
    args.isValid := false;
    exit;
  end;

end;

procedure TNFPedidoPage.btnSalvar_Click(sender: System.Object; e: System.EventArgs);
var
  idEvento : integer;
  msg : String;
  msgAlerta : String;
begin
  if self.IsValid then
  begin
    salvarPedido;

    
    txtNumPedido.Text := getControlador.getPedido.numPedido.ToString;     
    preparaGridHistorico;    

    if self.confirmar(msg) then
    begin
      msgAlerta := 'Dados salvos com sucesso\n\n O sistema apresentará a seguir um resumo com os dados da Autorização de Pagamento cadastrada e a opção para anexar a Nota Fiscal digitalizada.';
      if getControlador.getCondicaoPgtoDoc.formaPgto = 'BO' then
        msgAlerta := 'Dados salvos com sucesso\n\n O sistema apresentará a seguir um resumo com os dados da Autorização de Pagamento cadastrada e a opção para anexar a Nota Fiscal digitalizada e o boleto.';

      if  ( (getControlador.getDocDespesa.sitDoc.Trim = 'PROTOCOLADO') or (getControlador.getDocDespesa.sitDoc.Trim = 'DOC APROVADO'))   then 
          msgAlerta := 'Dados alterados com sucesso';

      TPageHelper.alert(msgAlerta, self.Page);
      btnImprimir.Enabled := true;
      exibeDetalheNota;
    end
    else
    begin
      TPageHelper.alert(msg, self.Page);
      btnImprimir.Enabled := false;
    end;

  end;

end;

procedure TNFPedidoPage.CVDtVencimento_ServerValidate(source: System.Object;
  args: System.Web.UI.WebControls.ServerValidateEventArgs);
begin

end;

procedure TNFPedidoPage.lkbBuscaEmpresa_Click(sender: System.Object; e: System.EventArgs);
begin
  Page.RegisterStartupScript('al','<script language="javascript">abre_busca_completa(document.getElementById(''form1''), document.getElementById(''form1'').txtIdCliente, "", document.getElementById(''form1'').txtNomeEmpresa, "N", "S", "N", "N","N");</script>');
end;

procedure TNFPedidoPage.btnAdicionar_Click(sender: System.Object; e: System.EventArgs);
var
  msg : string;
begin


end;

procedure TNFPedidoPage.btnAdicionarItem_Click(sender: System.Object; e: System.EventArgs);
var
  msg : string;
begin
{
  if getControlador.adicionarItemPedido(rbTipoDespesa.SelectedValue, cmbTipoDespesa.SelectedValue, txtDescricaoItem.Text, txtQtdItem.Text, txtValor.Text, cmbTipoDespesa.SelectedValue, cmbTipoDespesa.SelectedItem.Text.Trim,  msg) then
  begin
    preparaGridItemPedido;
    txtDescricaoItem.Text := '';
    txtValor.Text := '';
    txtQtdItem.Text := '';
    TPageHelper.alert('Item inserido com sucesso!', self.Page);
    atualizarValorTotalItens;
    cmbCC.Enabled := false;
    cmbFonte.Enabled := false;
    cmbMetaFase.Enabled := false;
  end
  else
  begin
    TPageHelper.alert(msg, self.Page);
  end;
  }
end;

procedure TNFPedidoPage.rbTipoDespesa_SelectedIndexChanged(sender: System.Object;
  e: System.EventArgs);
begin
    carregaTipoDespesa;
end;

procedure TNFPedidoPage.cmbMetaFase_SelectedIndexChanged(sender: System.Object;
  e: System.EventArgs);
var
  idMetaFase : integer;
begin
  carregaTipoDespesa;

end;

procedure TNFPedidoPage.preencheFonte(usuario: TUsuario; idCC: string);
begin
{
  cmbFonte.DataSource := getControlador.CarregarFonteRecurso(idCC, usuario);
  cmbFonte.DataTextField := 'TIT_FONTE';
  cmbFonte.DataValueField := 'COD_FONTE';
  cmbFonte.DataBind;
  cmbFonte.Items.Insert(0, '');
 }
end;

procedure TNFPedidoPage.preencheMeta(usuario: TUsuario; idCC: string);
begin
{
  cmbMetaFase.DataSource := getControlador.carregarMetaFase(cmbFonte.SelectedValue, idCC, usuario);
  cmbMetaFase.DataTextField := 'CONTROLE';
  cmbMetaFase.DataValueField := 'ID_META_FASE';
  cmbMetaFase.DataBind;
  cmbMetaFase.Items.Insert(0, '');
  cmbMetaFase_SelectedIndexChanged(nil, nil);
 }
end;

function TNFPedidoPage.getControlador : TControladorMaterial;
begin
  createControlador(TControladoresFactory.CONTROLADOR_MATERIAL);
  result := TControladorMaterial(controlador);
end;

procedure TNFPedidoPage.cmbFonte_SelectedIndexChanged(sender: System.Object;
  e: System.EventArgs);
var
  usuario :TUsuario;
begin
  usuario := TUsuario(Session['usuario']);

  //preencheMeta(usuario, cmbCC.SelectedValue);
end;

procedure TNFPedidoPage.cmbCC_SelectedIndexChanged(sender: System.Object;
  e: System.EventArgs);
var
  usuario :TUsuario;
begin
  usuario := TUsuario(Session['usuario']);

  //preencheFonte(usuario, cmbCC.SelectedValue);
end;

procedure TNFPedidoPage.Button1_Click(sender: System.Object; e: System.EventArgs);
var
  i : integer;
begin

end;

procedure TNFPedidoPage.buscarDocumento;
begin
end;

function TNFPedidoPage.buscarHistoricoPedido: DataSet;
begin

end;

procedure TNFPedidoPage.preparaGridHistorico;
begin
  dgHistorico.DataSource := getControlador.buscarHistoricoPedido;
  dgHistorico.DataBind;
end;

procedure TNFPedidoPage.exibeHistorico;
begin
  PnExibirHistorico.visible := false;
  pnHistorico.Visible := true;
  pnDetalheHist.Visible := false;
end;

procedure TNFPedidoPage.ocultarHistorico;
begin
  PnExibirHistorico.visible := true;
  pnDetalheHist.visible := false; 
  pnHistorico.visible := false;
end;

procedure TNFPedidoPage.exibeEscolhaNumPedido;
begin
  pnNumPedido.Visible := true;
  pnForm1.visible := false;
  pnForm2.visible := false;
  pnForm3.visible := false;
  pnForm4.visible := false;
  PnExibirHistorico.visible := false;  
  PnExibirHistorico.visible := false;
  self.ocultarHistorico;
  PnExibirHistorico.visible := false;
end;

procedure TNFPedidoPage.btnImprimir_Click(sender: System.Object; e: System.EventArgs);
var
  url : string;
  docDesp : TDocumentoDespesa;
begin

  docDesp := getControlador.getDocDespesa;
  if docDesp.ehDocumentoAntecipado then
    url := getControlador.gerarImpressaoAntecipado(docDesp.idDoc.ToString)
  else
    url := getControlador.gerarImpressaoAutorizacaoPgto;

  Page.RegisterStartupScript('al1','<script language="javascript">window.open('''+ url+ ''');</script>');


end;

procedure TNFPedidoPage.dgParcelaPgto_UpdateCommand1(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
var
  nivel1, nivel2 : string;
  vl : double;
  dt : Datetime;
  strVl, strDt, strQtd : string;
  txtDt, txtBoxVl : textBox;
  condPgto : TCondicaoPgtoDoc;
  dtLimite : DateTime;
begin

  condPgto :=  getControlador.getCondicaoPgtoDoc;

  txtBoxVl:= textbox(e.item.cells[3].controls[0]);
  txtDt:= textbox(e.item.cells[4].controls[0]);

  strVl := txtBoxVl.Text.Trim.Replace('.', '');


  try
    vl := double.parse(strVl);
  except
    TPageHelper.alert('Valor inválido', self.Page);
    exit;
  end;

  try
    dt := StrToDate(txtDt.Text.Trim);
  except
    TPageHelper.alert('Data inválida', self.Page);
    exit;
  end;

  if dt > Datetime.Today.AddMonths(6) then
  begin
    TPageHelper.alert('A data não pode ser ultrapassar 6 meses', self.Page);
    exit;
  end;

  dtLimite := TFeriadoPuc.somaDiasUteis(Datetime.Today,3);
  if condPgto.formaPgto = 'BO' then
    dtLimite := Datetime.Today;
  if dt <dtLimite then
  begin
    TPageHelper.alert('A data não pode ser inferior a ' + dtLimite.ToString(TSGUUtils.fmtData), self.Page);
    exit;
  end;


  condPgto.irParaIndice(e.Item.DataSetIndex);

  condPgto.dtVencimento := dt;
  condPgto.vlParcela := vl;

  dgParcelaPgto.EditItemIndex := -1;
  self.preparaGridParcela;
  self.atualizaDiffValorParcela;
  
end;

procedure TNFPedidoPage.dgParcelaPgto_EditCommand1(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
begin
  dgParcelaPgto.DataSource := getControlador.getCondicaoPgtoDoc.defaultDataSet;
  dgParcelaPgto.EditItemIndex:= e.Item.ItemIndex;
  dgParcelaPgto.databind;
end;

procedure TNFPedidoPage.dgParcelaPgto_DeleteCommand1(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
var
  condPgto : TCondicaoPgtoDoc;
begin
  condPgto :=  getControlador.getCondicaoPgtoDoc;
  condPgto.defaultDataTable.DefaultView.Delete(e.Item.DataSetIndex);
  condPgto.ultimo;
  dgParcelaPgto.DataSource := condPgto.defaultDataSet;

  TPageHelper.FazerDataBindExclusao(dgParcelaPgto);
  self.atualizaDiffValorParcela;
  atualizaDiffValorParcela;

end;

procedure TNFPedidoPage.dgParcelaPgto_CancelCommand1(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
begin
   dgParcelaPgto.EditItemIndex := -1;
   preparaGridParcela;
end;

procedure TNFPedidoPage.CustomValidator4_ServerValidate(source: System.Object;
  args: System.Web.UI.WebControls.ServerValidateEventArgs);
var
  idCliente : integer;
begin
  args.IsValid := true;
  try
    idCliente := getControlador.getPedido.idCliente;
  except
    exit;
  end;

  if txtNumDoc.Text.Trim = '' then
  begin
    CustomValidator(source).errorMessage := 'O nº da Nota Fiscal é obrigatório';
    args.IsValid := false;
    exit;
  end;

  if String.isNullOrEmpty(txtSerie.text.trim) then
  begin
    CustomValidator(source).errorMessage := 'O nº da série é obrigatório';
    args.IsValid := false;
  end;

  try
    getControlador.getDocDespesa.DataEmissao := Convert.ToDateTime(txtDtEmissao.Text.Trim);
  except
  end;

  if getControlador.getDocDespesa.existeNotaPorFornecedor(txtNumDoc.text, txtSerie.text, idCliente) then
  begin
    CustomValidator(source).errorMessage := 'O nº da Nota Fiscal/Série já existe para o fornecedor';
    args.IsValid := false;
  end;

end;

procedure TNFPedidoPage.dgItemDoc_DeleteCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
var
  idItem : string;
  rowToDelete : integer;
  msg : string;
  possuiServico: boolean;
begin

  rowToDelete := e.Item.ItemIndex;
  idItem  := dgItemDoc.Items[rowToDelete].Cells[0].Text.trim;

  if getControlador.removerItemDoc(idItem, msg) then
  begin
    Page.RegisterStartupScript('al1','<script language="javascript">alert(''Item excluido com sucesso.'');</script>');
    possuiServico := getControlador.getItemDoc.possuiItemServico;
    pnServPuc.Visible := possuiServico;
    if not possuiServico then
      cmbServPuc.SelectedValue := '';
    self.preparaGridItemDoc;
    preparaGridItemPedido;
  end
  else
    Page.RegisterStartupScript('al1','<script language="javascript">alert(''' + msg + ''');</script>');



end;

procedure TNFPedidoPage.lbkOcultarHist_Click(sender: System.Object; e: System.EventArgs);
begin
  ocultarHistorico;
end;

procedure TNFPedidoPage.lkbExibeHist_Click(sender: System.Object; e: System.EventArgs);
begin
  exibeHistorico;
end;

procedure TNFPedidoPage.dgHistorico_SelectedIndexChanged(sender: System.Object;
  e: System.EventArgs);
var
  nomeArqF : string;
  idDoc: integer;
  selIndex : integer;
  detCP : TDetalheCP;
  itemDoc : TitemDoc;
  imposto : TImposto;
  bemPatrimonial : TBEMPATRIMONIAL;
begin
  selIndex := dgHistorico.SelectedIndex;
  idDoc := StrToInt(dgHistorico.Items[selIndex].Cells[0].Text.trim);
  TPageHelper.marcarLinhaSelecionadaGrid(dgHistorico);

  detCP := new TDetalheCP; 
  dgCondicaoPgtoDoc.DataSource := detCP.buscarLiquidoPorIdDoc(idDoc);
  dgCondicaoPgtoDoc.DataBind;

  imposto := new  TImposto;
  imposto.buscarPorIdDoc(idDoc);
  dgImposto.DataSource := imposto.defaultDataSet;
  dgImposto.DataBind;

  itemDoc := new  TItemDoc;
  itemDoc.buscarItemDoc(idDOc, -1);
  dgItemDocHist.DataSource := itemDoc.defaultDataSet;
  dgItemDocHist.DataBind;

  bemPatrimonial := new TBEMPATRIMONIAL;
  bemPatrimonial.buscarBensAtivosPorIdDoc(idDoc);
  dgPatrimonio.DataSource := bemPatrimonial.defaultDataSet;
  dgPatrimonio.DataBind;


  pnDetalheHist.visible := true;


end;

procedure TNFPedidoPage.preparaProcessoImportacao;
var
  idCliente: Integer;
begin
  idCliente := getControlador.getPedido.idCliente;
  pnNumProcessoImportacao.Visible := false;
  {if (idCliente =  TEmpresa.IdEmpresaBancoPaulista) then
    pnNumProcessoImportacao.Visible := true;}

  {if (idCliente  = TEmpresa.IdEmpresaFortrade) or (idCliente= TEmpresa.IdEmpresaHzImport) then
  begin
    pnBuscaProcImport.Visible := true;
  end
  else
  begin
    pnBuscaProcImport.Visible := false;
  end;
}
end;

procedure TNFPedidoPage.CVProcImportacao_ServerValidate(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);

var
  procImp : TProcessoImportacao;
begin
  args.IsValid := true;

  if  not (pnNumProcessoImportacao.Visible) then
    exit;

  if (txtNumProcImportacao.Text.trim='') then
  begin
    CustomValidator(source).ErrorMessage := 'Processo de Importação Obrigatório';
    args.IsValid := false;
  end;

  if not getControlador.getDocDespesa.ehNova then
    exit;

  procImp := new  TProcessoImportacao;
  procImp.ConsultaProcesso(txtNumProcImportacao.Text.trim);
  if not procImp.ehVazio then
  begin
    CustomValidator(source).ErrorMessage := 'Processo de Importação já existe';
    args.IsValid := false;
  end;
  

end;

function TNFPedidoPage.confirmar(var msg : String) : Boolean;
begin
    if (getControlador.validarDisponibilidadeOrcamentaria(msg)) then
    begin
      if  not  (( (getControlador.getDocDespesa.sitDoc.Trim = 'PROTOCOLADO') or (getControlador.getDocDespesa.sitDoc.Trim = 'DOC APROVADO')) and (getControlador.getDocDespesa.ehUsuarioEspecial(TUsuario(session['usuario']).idUsuario ))) then
        if not ((ckbCartao.Checked) and (getControlador.existeARMAssociada) ) then
        begin
          getControlador.getDocDespesa.sitDoc := 'AGUARD APROV DOC';
          getControlador.getDocDespesa.idUsuario := TUsuario(session['usuario']).idUsuario;
        end;
        atualizarSituacaoDoc;
      getControlador.verificaMudancaEstadoPedido;
      getControlador.getDocDespesa.salvar;
      btnImprimir.enabled := true;
      TPageHelper.alert('Dados salvos com sucesso', self.Page);      
      txtNumPedido.Text := getControlador.getPedido.numPedido.ToString;
      //desabilitarEdicao;            
      btnImprimir.enabled := true;
      result := true;
    end
    else
    begin
      result := false;
    end;
end;

method TNFPedidoPage.ckbCartaoCheckedChanged(sender: System.Object; e: System.EventArgs);
begin
  pnForm3.Visible := (not ckbCartao.Checked)
end;

procedure TNFPedidoPage.exibeDetalheNota;
var
  ds : DataSet;
  u : TUsuario;
begin
  
  btnAprovar.Visible := false;
  pnFormulario.Visible := false;
  pnMensagem.Visible := true;
  btnExcluir.Enabled := false;
  btnEditaNF.Enabled := false;

 // uploadArea.iniciar(getControlador.getDocDespesa.idDoc.toString, TTipoEventoAnexo.idTipoDocumentoPgto, false);  
  // uploadArea.setResumido(true);
   
  // uploadArea.exibePainel;

  //btnCancelarEdicao.Visible := true;
  //frameExibeDetDoc.Attributes['src'] := '/SGUWeb/apoio/ExibeDetDoc.aspx?ID_DOC=' + getControlador.getDocDespesa.idDoc.toString;
  detDoc.carregar(getControlador.getDocDespesa.idDoc);

  if getControlador.getDocDespesa.ehDocumentoAntecipado then
      btnEditaNF.visible := false;

    if (TSGUUtils.testarStrNulo(getControlador.getDocDespesa.chaveAcesso)='') then
      detDoc.exibeLinkReceita
    else
      btnEditaNF.visible := false;

  if (getControlador.getDocDespesa.sitDoc = 'AGUARD APROV DOC')  then
   begin
    u := TUSUArio(session['usuario']);
    btnEditaNF.Enabled := true;
    ds := u.buscarUsuarioPrograma( u.idUsuario, TPrograma.codProgramaAprovacaoDocumento);
    btnExcluir.Enabled := true;
    btnAprovar.Visible := (ds.Tables[0].Rows.Count > 0);

    if (TSGUUtils.testarStrNulo(getControlador.getDocDespesa.chaveAcesso)='') then
      detDoc.exibeLinkReceita;   
   end;

   if ( ( (getControlador.getDocDespesa.sitDoc.Trim = 'PROTOCOLADO') or (getControlador.getDocDespesa.sitDoc.Trim = 'DOC APROVADO')) and (getControlador.getDocDespesa.ehUsuarioEspecial(TUsuario(session['usuario']).idUsuario ))) then         
      btnEditaNF.Enabled := true;

end;

method TNFPedidoPage.btnCancelarEdicao_Click(sender: System.Object; e: System.EventArgs);
begin

    pnFormulario.Visible := false;
  pnMensagem.Visible := true;
end;

method TNFPedidoPage.btnEditaNF_Click(sender: System.Object; e: System.EventArgs);
begin
  pnFormulario.Visible := true;
  pnMensagem.Visible := false;
  btnCancelarEdicao.Visible := true;
end;

method TNFPedidoPage.btnAbrirOC_Click(sender: System.Object; e: System.EventArgs);
begin
  response.Redirect('OrdemCompra.aspx?NUM_PEDIDO=' + txtNumPedido.Text );
end;

method TNFPedidoPage.btnAprovarDocumento(sender: System.Object; e: System.EventArgs);
var
  docDesp : TDocumentoDespesa;
  eventoAnexo : TEventoAnexo;
  msg : String;
begin
  docDesp := new TDocumentoDespesa;
  docDesp.buscarDocumentoDespesa(getControlador.getDocDespesa.idDoc);
  if (docDesp.sitDoc <> 'AGUARD APROV DOC') and (docDesp.sitDoc <> 'DOC APROVADO') then
  begin
    TPageHelper.alert('Erro ao aprovar', self);
    exit;
  end;

  docDesp.getCondicaoPgtoDoc.primeiro;
   if (not docDesp.getCondicaoPgtoDoc.ehVazio) and (docDesp.getCondicaoPgtoDoc.formaPgto='CC') and (docDesp.getCondicaoPgtoDoc.dtVencimento < TFeriadoPuc.somaDiasUteis(Datetime.Today,3)) then
   begin
     TPageHelper.alert('A data de vencimento da primeira parcela deve ser a partir de ' + TFeriadoPuc.somaDiasUteis(Datetime.Today,3).ToString(TSguUtils.fmtData), self);
      exit;
   end;

    eventoAnexo := new TEventoAnexo(false);
   eventoAnexo.BuscarAnexos(docDesp.idDoc.ToString, TTipoEventoAnexo.idTipoDocumentoPgto);

    if (TSGUutils.testarStrNulo( docDesp.chaveAcesso) = '' )then
   begin
         if (docDesp.getCondicaoPgtoDoc.formaPgto = 'BO') and  (eventoAnexo.numeroRegistros < 1 ) then
       begin      
            TPageHelper.alert('É necessário anexar a nota fiscal, o cadastro do CNPJ na Receita Federal e o(s) boleto(s).', self.Page);
            exit;
        end
        else if (eventoAnexo.numeroRegistros < 1 )  then
        begin
            TPageHelper.alert('É necessário anexar a Nota Fiscal e o cadastro do CNPJ na Receita Federal.', self.Page);        
          exit;
        end; 

    end
    else // Chave de acesso
    begin      
       if (docDesp.getCondicaoPgtoDoc.formaPgto = 'BO') and  (eventoAnexo.numeroRegistros < 1 ) then
       begin   
         TPageHelper.alert('É necessário anexar o resumo do DANFE, o XML da Nota Fiscal e o(s) boleto(s).', self.Page);        
          exit;
       end
       else if (eventoAnexo.numeroRegistros < 1 )  then
        begin
            TPageHelper.alert('É necessário anexar o resumo do DANFE e o XML da Nota Fiscal.', self.Page);        
          exit;
        end;       
    end;


      if (docDesp.indRequerAprovacao = 'S') and (docDesp.idUsuarioAprovacao = TNulo.int) then
      begin
        TPageHelper.alert('Documento requer aprovação do responsável pela meta',self.page);
        exit;
      end;

          if not getControlador.validarDisponibilidadeOrcamentaria(docDesp.getPedido.idMetaFase.ToString, docDesp.getPedido.codFonte , docDesp.getPedido.idCC.ToString, msg, true) then
    begin
        TPageHelper.alert(msg,self.page);
        exit;
    end;

 
  if TConfigSGU.ehAAA then
    docDesp.sitDoc := 'PROTOCOLADO'
  else
    docDesp.sitDoc := 'DOC APROVADO';
  docDesp.salvar;

  TPageHelper.alert('Documento Aprovado com sucesso', self);
  self.atualizarSituacaoDoc;             
  exibeDetalheNota;

end;

method TNFPedidoPage.cmbFormaPagtoParcela_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
begin
    pnLinhaDigitavel.Visible := false;  
end;

procedure TNFPedidoPage.salvarBoletos;
var
  linhaDigit : String;
  i : Integer;
  condicaoPgtoDoc : TCondicaoPgtoDoc;
begin
if  (dgParcelaPgto.Columns[5].Visible) then
  begin        
    condicaoPgtoDoc := getControlador.getCondicaoPgtoDoc;
    for i := 0 to dgParcelaPgto.Items.Count -1 do
    begin
       linhaDigit :=  TSGUUtils.formataBoleto( textBox(dgParcelaPgto.Items[i].Cells[5].FindControl('txtBoleto')).Text);
      condicaoPgtoDoc.irParaIndice(dgParcelaPgto.Items[i].DataSetIndex);
      
      condicaoPgtoDoc.linhaDigitavel := linhaDigit;
      condicaoPgtoDoc.valorBoleto := TSGUUtils.retornaValorCodBarra(linhaDigit);
      condicaoPgtoDoc.dtVencimentoBoleto := TSGUUtils.retornaDtVencimentoCodBarra(linhaDigit);

      
    end;
    condicaoPgtoDoc.primeiro;
  end;

end;

end.

