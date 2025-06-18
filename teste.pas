namespace SGUWeb;

interface

uses System.Collections, System.ComponentModel, ShineOn.Rtl,System.Data,System.Drawing,System.Web,System.Web.SessionState,  System.Web.UI, System.Web.UI.WebControls,System.Web.UI.HtmlControls,  SGU.Business, SGU.Controllers, MetaBuilders.WebControls, ShineOn.Vcl, C1.Win.C1Report, c1.Web.C1WebReport, log4net, System.Configuration, System.Globalization, System.Threading, System.Xml, System.IO, log4net.Config, c1.C1Zip, System.Net, SGU.Data.Web,  BarcodeNETWorkShop, System.Text, System.Text.RegularExpressions;

type
  ConcedeAcesso = public partial class(TPageBasico2)
  private
    var str: TStringList;
    procedure CriaColuna(codModulo: string; nomeDiv: string; exibeModulo : boolean;qt_quebra:integer);
    function montarNomePrograma(prog : Tprograma) : string;
    function montarNomePrograma2Niveis(prog : Tprograma) : string;
    function totalFuncionalidades(codModulo: string ):integer;

    procedure MontarAcesso();

  protected
    method btnDesbloquear_Click(sender: System.Object; e: System.EventArgs);
    method hlBusca_Click(sender: System.Object; e: System.EventArgs);
    method lkbProcessos_Click(sender: System.Object; e: System.EventArgs);
    method txtIdCliente_ValueChanged(sender: System.Object; e: System.EventArgs);
    method cmbDepto_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
    method dgMeta_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
    method btnVoltar_Click(sender: System.Object; e: System.EventArgs);
    method Button1_Click(sender: System.Object; e: System.EventArgs);
    method CustomValidator2_ServerValidate(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);
    method CustomValidator1_ServerValidate(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);
    method btnNovo_Click(sender: System.Object; e: System.EventArgs);
    method btnBloquear_Click(sender: System.Object; e: System.EventArgs);
    method btnReiniciar_Click(sender: System.Object; e: System.EventArgs);
    method btnSalvar_Click(sender: System.Object; e: System.EventArgs);
    method cmbUsuario_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
    method copiaDadosPesqFavorecido(sender: System.Object; e: System.EventArgs);
    method Page_Load(sender: Object; e: EventArgs); override;
    procedure CarregarUsuarios;
    function getControlador: TControladorPermissaoEspecial;
  public
    procedure recarregaUsuario;
  end;

implementation

method ConcedeAcesso.Page_Load(sender: Object; e: EventArgs);
var
   usuario :TUsuario;
   meta : TmetaFase;
   cc: TCentroCusto;
begin
   self.Page.MaintainScrollPositionOnPostBack := true;
  inherited;

  pesFavorecido.callBackEvent := new EventHandler(self.copiaDadosPesqFavorecido);
  if not page.IsPostBack then
  begin
    //carregar 
    cc := new TCentroCusto;
    cc.buscarAtivosParaAtendimento;

    gerenciaProcessos.escondeJanela;
    
    cmbDepto.DataSource := cc.defaultDataTable;
    cmbDepto.DataTextField := 'DESC_CC';
    cmbDepto.DataValueField := 'ID_CC';
    cmbDepto.DataBind;

    cmbDepto.selectedValue :=  TUsuario(Session['usuario']).idCC.toString;

    if TUsuario(Session['usuario']).idCC <> 73 then
      cmbDepto.enabled := false
    else
      cmbDepto.enabled := true;

    meta := new TmetaFase;
    meta.buscarMetaFasePorCC( cmbDepto.selectedValue , 'S' );

    cmbMeta.Items.Clear;
    cmbMeta.SelectedValue := nil;
    cmbMeta.DataSource := meta.defaultDataTable;  
    cmbMeta.DataTextField := 'CONTROLE';
    cmbMeta.DataValueField := 'ID_META_FASE';
    cmbMeta.DataBind;
    
    
    CarregarUsuarios;

    //carregar acesso do usuário selecionado
    cmbUsuario_SelectedIndexChanged(nil,nil);


    
  end;
end;

procedure ConcedeAcesso.CriaColuna(codModulo: string; nomeDiv: string; exibeModulo : boolean; qt_quebra:integer);
var
  //str: TStringList;
  programa: TPrograma;
  usuario: TUsuario;
  ds: DataSet;
  qt,i: Integer;
  codSubModulo: string;
  descSubModulo, descModulo: string;
  identSubModulo, identPrograma : string;
  ult_modulo, classSubModulo, ult_grupo : string;
  checked : String;
  exibeTodos : Boolean;
begin
  
  {if cmbUsuario.SelectedValue = '' then
    exit;
  }
  
  identPrograma := '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
  qt := 1;
  programa := new  TPrograma;
  
  usuario:= new TUsuario;

  if btnSalvar.Text = 'Incluir' then
    usuario.Buscar(-1)
  else
    usuario.Buscar( StrtoInt(cmbUsuario.SelectedValue) );

  exibeTodos := false;
  if (TUsuario(Session['usuario']).idCC = TCentroCusto.ccVradmSistema) or (((codModulo = 'RHUMANOS'',''MF') and (TUsuario(Session['usuario']).idCC = TCentroCusto.ccRH))) then
    exibeTodos := true;
  //versão com a nova construção do menu departamental
  ds := usuario.carregarSubModulos2NiveisParaConcederAcesso(codModulo, exibeTodos, TUsuario(Session['usuario']).idCC);
  classSubModulo := 'ttl_conteudo';

  ult_modulo := '';
  ult_grupo := '';

  for I := 0 to ds.Tables[0].Rows.Count - 1 do
  begin

    if ult_modulo <> string(ds.Tables[0].Rows[i].Item['COD_SUPER_GRUPO']).Trim then
    begin

        ult_modulo := string(ds.Tables[0].Rows[i].Item['COD_SUPER_GRUPO']).Trim;

         if qt > qt_quebra then
          begin
            //realizar a quebra de coluna a cada N funcionalidades
            //mantém sempre agrupado por submódulo
            str.Add('</td><td valign="top">');
            qt := 1;
          end;

          if ds.Tables[0].Rows[i].Item['DSC_LOGO2'] <> System.dbNull.value then
          begin            
            str.Add('<img border="0" src="..\imagens\'+ ds.Tables[0].Rows[i].Item['DSC_LOGO2'].toString.trim +'"/>');
          end;

        descModulo := string(ds.Tables[0].Rows[i].Item['SUPER_GRUPO']).Trim;
        str.Add('<span class="ttl_conteudo_sublinhado">' + descModulo + '</span><br><br>');
        classSubModulo := 'ttl_conteudo_pequeno';

        identPrograma := '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
        classSubModulo := 'ttl_conteudo';
    end;

    if ds.Tables[0].Rows[i].Item['COD_GRUPO'] = System.dbNull.value then
    begin
      codSubModulo := '';
      descSubModulo := '';
      programa.obterProgramaPorUsuarioSuperGrupoParaConcederAcesso(usuario.idUsuario, ult_modulo, exibeTodos, TUsuario(Session['usuario']).idCC);
      identPrograma := '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
      classSubModulo := 'ttl_conteudo';
    end
    else
    begin
      if ult_grupo <> ds.Tables[0].Rows[i].Item['COD_GRUPO'].toString() then
      begin
        ult_grupo := ds.Tables[0].Rows[i].Item['COD_GRUPO'].toString();
        identPrograma := '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
        classSubModulo := 'ttl_conteudo';
      end;

      codSubModulo := string(ds.Tables[0].Rows[i].Item['COD_GRUPO']).Trim;
      descSubModulo := string(ds.Tables[0].Rows[i].Item['GRUPO']).Trim;
      programa.obterProgramaPorUsuarioGrupoParaConcederAcesso(usuario.idUsuario, codSubModulo, exibeTodos, TUsuario(Session['usuario']).idCC);
    end;

    identSubModulo := identPrograma;
    identPrograma := identSubModulo + identPrograma;

    if not String.isNullOrEmpty(descSubModulo) then
      str.Add('<span class="ttl_conteudo_pequeno">' + identSubModulo +  descSubModulo + '</span><br>');


    programa.primeiro;
    while not programa.ehFim do
    begin            
      if programa.getCampoString('possui_acesso') = 'S' then
        checked := ' checked'
      else
        checked := '';

      str.Add(identPrograma + ' <input type="checkbox" name="ckbPrograma" value="' + programa.codPrograma.Trim + '" '+checked+'> ' + montarNomePrograma2Niveis(programa) + '<br>');
      programa.proximo;
      qt := qt + 1;
    end;

    str.Add('<br>');

    programa.primeiro;

  end;

end;


function ConcedeAcesso.totalFuncionalidades(codModulo: string ):integer;
var
  //str: TStringList;
  programa: TPrograma;
  usuario: TUsuario;
  ds: DataSet;
  qt,i: Integer;
  exibeTodos : Boolean;
begin  
  qt := 0;
  programa := new  TPrograma;
 
  usuario := TUsuario(session['usuario']);
  
  exibeTodos := false;
  if (TUsuario(Session['usuario']).idCC = TCentroCusto.ccVradmSistema) or (((codModulo = 'RHUMANOS'',''MF') and (TUsuario(Session['usuario']).idCC = TCentroCusto.ccRH))) then
    exibeTodos := true;

  ds := TUsuario(session['usuario']).carregarSubModulos2NiveisParaConcederAcesso(codModulo, exibeTodos,TUsuario(Session['usuario']).idCC);

  for I := 0 to ds.Tables[0].Rows.Count - 1 do
  begin

    if ds.Tables[0].Rows[i].Item['COD_GRUPO'] = System.dbNull.value then
    begin
      programa.obterProgramaPorUsuarioSuperGrupoParaConcederAcesso(usuario.idUsuario, string(ds.Tables[0].Rows[i].Item['COD_SUPER_GRUPO']).Trim, exibeTodos, TUsuario(Session['usuario']).idCC);
    end
    else
    begin
      programa.obterProgramaPorUsuarioGrupoParaConcederAcesso(usuario.idUsuario, string(ds.Tables[0].Rows[i].Item['COD_GRUPO']).Trim, exibeTodos, TUsuario(Session['usuario']).idCC);
    end;

    programa.primeiro;
    while not programa.ehFim do
    begin

      qt := qt + 1;
      programa.proximo;
    end;

    programa.primeiro;
  end;


   programa.free;
   result := qt;
end;

function ConcedeAcesso.montarNomePrograma(prog: Tprograma): string;
var
  nome : string;
  grupo : string;
begin
  nome := prog.nomePrograma.Trim;
  grupo := prog.getGrupoMenu.descGrupo.Trim;
  if grupo <> TNulo.str then
    nome := grupo + ' - ' + nome;
  result := nome;
end;

function ConcedeAcesso.montarNomePrograma2Niveis(prog: Tprograma): string;
var
  nome : string;
  grupo : string;
begin
  if prog.idCCAcesso = TNUlo.int then
    nome := prog.nomePrograma.Trim
  else if prog.idCCAcesso.ToString = cmbDepto.SelectedValue then
    nome := '<a style="color:red!important">' + prog.nomePrograma.Trim + "</a>"
  else
    nome := '<a title="' + getControlador.getSiglaCC(prog.idCCAcesso) + '" style="color:blue!important">' + prog.nomePrograma.Trim + "</a>";

  result := nome;
end;

procedure ConcedeAcesso.MontarAcesso();
var
  numProg : integer;
  s, nomeDiv : string;
   estaNaSegundaColuna : boolean;
   codModulos, codModulo1, codModulo2 : string;
   exibeMod1, exibeMod2 : boolean;
   qt_quebra:integer;
begin
  qt_quebra := 0;  
  numProg := 0;
  estaNaSegundaColuna := false;
  nomeDiv := 'MenuSGUDeptoCol3';
  //Session['programa'] := nil;
  
  
  str:= new  TStringList;
  str.Add('<div id="' + nomeDiv + '">');
  

  //ORCAMENTO
  codModulos := 'ORCAMENTO';
  str.Add('<div><span class="ttl_modulo">Or&ccedil;amento&nbsp;</span><br><img src="..\imagens\img_sgu_linhascoloridas.jpg"></div>'); 
  str.Add('<table cellpadding="10"><tr><td valign="top">');
  qt_quebra := totalFuncionalidades(codModulos);

  //só quebrar se usuário possuir mais que 10 funcionalidaddes
  if qt_quebra > 10 then
    qt_quebra := Round(double(qt_quebra / 3))-1;

  CriaColuna(codModulos , 'MenuSGUDeptoCol1', true, qt_quebra);

  str.Add('</td></tr></table>');
  
  
  //FINANCAS  
  codModulos := 'FINANCAS';

  str.Add('<div><span class="ttl_modulo">Finan&ccedil;as&nbsp;</span><br><img src="..\imagens\img_sgu_linhascoloridas.jpg"></div>'); 
  
  str.Add('<table cellpadding="10"><tr><td valign="top">');
  qt_quebra := totalFuncionalidades(codModulos);

  //só quebrar se usuário possuir mais que 10 funcionalidaddes
  if qt_quebra > 10 then
    qt_quebra := Round(double(qt_quebra / 3))-1;

  CriaColuna(codModulos , 'MenuSGUDeptoCol1', true, qt_quebra);

  str.Add('</td></tr></table>');

  //ADMINISTRATIVO  
  codModulos := 'ADM';
  str.Add('<div><span class="ttl_modulo">Administrativo&nbsp;</span><br><img src="..\imagens\img_sgu_linhascoloridas.jpg"></div>'); 
  str.Add('<table cellpadding="10"><tr><td valign="top">');
  qt_quebra := totalFuncionalidades(codModulos);

  //só quebrar se usuário possuir mais que 10 funcionalidaddes
  if qt_quebra > 10 then
    qt_quebra := Round(double(qt_quebra / 3))-1;

  CriaColuna(codModulos , 'MenuSGUDeptoCol1', true, qt_quebra);

  str.Add('</td></tr></table>');
  
  //MF e  RH
  codModulos := 'RHUMANOS'',''MF';
  str.Add('<div><span class="ttl_modulo">Recursos Humanos&nbsp;</span><br><img src="..\imagens\img_sgu_linhascoloridas.jpg"></div>'); 
  str.Add('<table cellpadding="10"><tr><td valign="top">');
  qt_quebra := totalFuncionalidades(codModulos);

  //só quebrar se usuário possuir mais que 10 funcionalidaddes
  if qt_quebra > 10 then
    qt_quebra := Round(double(qt_quebra / 3))-1;

  CriaColuna(codModulos , 'MenuSGUDeptoCol1', true, qt_quebra);

  str.Add('</td></tr></table>');


  codModulos := 'ALUNO';
  str.Add('<div><span class="ttl_modulo">Aluno&nbsp;</span><br><img src="..\imagens\img_sgu_linhascoloridas.jpg"></div>'); 
  str.Add('<table cellpadding="10"><tr><td valign="top">');
  qt_quebra := totalFuncionalidades(codModulos);

  //só quebrar se usuário possuir mais que 10 funcionalidaddes
  if qt_quebra > 10 then
    qt_quebra := Round(double(qt_quebra / 3))-1;

  CriaColuna(codModulos , 'MenuSGUDeptoCol1', true, qt_quebra);

  str.Add('</td></tr></table>');



  //SESMT
  if (TUsuario(Session['usuario']).idCC in [19,75, TCentroCusto.ccVradmSistema]) then
  begin
    codModulos := 'SESMT';
    str.Add('<div><span class="ttl_modulo">SESMT&nbsp;</span><br><img src="..\imagens\img_sgu_linhascoloridas.jpg"></div>');
    str.Add('<table cellpadding="10"><tr><td valign="top">');
    qt_quebra := totalFuncionalidades(codModulos);

    //só quebrar se usuário possuir mais que 10 funcionalidaddes
    if qt_quebra > 10 then
      qt_quebra := Round(double(qt_quebra / 3))-1;

    CriaColuna(codModulos , 'MenuSGUDeptoCol1', true, qt_quebra);

    str.Add('</td></tr></table>');
  end;
  

  str.Add('</div>');
  pnModulo.Controls.Add(new LiteralControl( str.Text));
  ViewState["modulos"] := str.Text;
  //TpageHelper.doOnLoad(self);

  str.free;
end;

method ConcedeAcesso.cmbUsuario_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
var
  usuario: TUsuario;
  usuario2: TUsuario;
  dt : DataTable;
  i:Integer;
begin
  btnSalvar.Text := 'Salvar';
  usuario := new TUsuario;

  lkbProcessos.Visible := true;

  btnBloquear.Enabled := true;
  btnReiniciar.Enabled := true;
  
  dgMeta.Visible := true;
  lbTodas.Visible := false;

  lbUsuario.Visible := true;
  cmbUsuario.Visible := true;
  btnNovo.Visible := true;
  btnVoltar.visible := false;
  hlBusca.Visible := false;
  btnDesbloquear.Visible := true;

  if cmbUsuario.Items.Count = 0 then
  begin
    txtCPF.Text := '';
    txtEmail.Text := '';
    txtNome.text := '';
    txtLogin.Text := '';
    lbConfirmacao.Text := '';
    exit;
  end;
  
  usuario.Buscar(strtoint(cmbUsuario.SelectedValue));  
  txtNome.Text := usuario.nome.Trim;
  txtLogin.Text := usuario.username.Trim;
  txtCPF.Text := usuario.cpf.Trim;
  txtEmail.Text := usuario.email.Trim;
  
  lbConfirmacao.Text := '';

  if usuario.idUsuarioConfirmacao <> TNulo.int then
  begin
    usuario2:= new TUsuario;
    usuario2.Buscar(usuario.idUsuarioConfirmacao);
    lbConfirmacao.Text := 'Acesso confirmado em ' + usuario.dtUltimaConfirmacao.ToString('dd/MM/yy HH:mm') + ' por ' + usuario2.nome.ToString;
  end;

  btnBloquear.Enabled := true;
  btnReiniciar.Enabled := true;

  MontarAcesso();

  getControlador.CarregarPermissaoEspecial(strtoint(cmbUsuario.SelectedValue)  ,'ADOR66');
  if getControlador.temPermissaoEspecialMeta then
  begin
    dgMeta.Visible := true;
    dgMeta.DataSource := getControlador.obterPermissaoEspecialMeta;
    dgMeta.DataBind;
    lbTodas.Visible := false;
  end
  else
  begin
    dgMeta.Visible := false;
    lbTodas.Visible := true;
  end;

  btnDesbloquear.Visible := cmbUsuario.SelectedItem.Text.Contains('BLOQUEADO');

  //ckbAssunto.DataSource := usuario.BuscarGruposAssuntosCC(cmbdepto.SelectedValue);
  //ckbAssunto.DataTextField := 'nome_grupo';
  //ckbAssunto.DataValueField := 'id_grupo';
  //ckbAssunto.DataBind;

  
  for i := 0 to cmbUsuario.Items.Count-1 do
    if cmbUsuario.Items[i].Text.Contains('BLOQUEADO') then
       cmbUsuario.Items.Item[i].Attributes.Add("style", "Color: Red");
end;

method ConcedeAcesso.btnSalvar_Click(sender: System.Object; e: System.EventArgs);
var 
usuario:TUsuario;
senha:String;
texto : TStringList;
programas :  String;
gId : TGeradorId;
trans : TBusinessTransaction;
perm : TPermissaoEspecial;
i:Integer;
aux:String;
f : TFuncionario;
p : TPapel;
begin
  
  if not page.IsValid then
  begin
    pnModulo.Controls.Add(new LiteralControl(ViewState["modulos"].ToString) );
    exit;
  end;

  //validar e-mail
  if not TSGUUTils.ValidarEmail(txtEmail.Text) then
  begin
    TPageHelper.alert('E-mail inválido',self);    
    pnModulo.Controls.Add(new LiteralControl(ViewState["modulos"].ToString) );
    exit;
  end;

  usuario:=new TUsuario;
  
  //Verifica se o usuario existe e está bloqueado
  if btnSalvar.Text = 'Incluir' then
  begin
    usuario.buscarPorCPFCentroCusto(txtCPF.Text.Replace('.', '').Replace('-', ''), Convert.ToInt32(cmbDepto.SelectedValue));

    if not usuario.ehVazio then
    begin
      if usuario.indBloqueio = 'S' then
      begin
        TPageHelper.alert('Usuário já existe e encontra-se com acesso bloqueado. Se desejar utilize a opção "Desbloquear Usuário".', self);   
        exit;
      end;
    end;
  end;
  

  usuario.Buscar(-1);

  trans := new TBusinessTransaction;
  trans.beginTrans;

  try
  if btnSalvar.Text = 'Incluir' then
  begin
    usuario.adicionar;
    senha := TSguUtils.GeraSenha;
    gId := new TGeradorId;
    usuario.idUsuario := gId.NovoId(8);
    usuario.senha := senha;
    usuario.codGestao := 'DEPTO';

    if txtIdCliente.Value <> '' then
    begin
      f := new TFuncionario;
      f.Buscar(txtIdCliente.Value);
      usuario.idCliente := f.idCliente;
    end
    else
    begin
      trans.rollbackTrans;    
      TPageHelper.alert('Usuário precisa ser vinculado a um funcionário.',self);
      pnModulo.Controls.Add(new LiteralControl(ViewState["modulos"].ToString) );
      exit;
    end;
  end
  else
  begin
    usuario.Buscar(StrtoInt(cmbUsuario.SelectedValue));
  end;

  usuario.cpf := txtCPF.Text.Trim;
  usuario.username := txtLogin.Text.ToUpper.Trim.Replace(' ','');

  if txtNome.Text.ToUpper.Trim.Length > 45 then
    usuario.nome := txtNome.Text.ToUpper.Trim.Substring(0, 45)
  else
    usuario.nome := txtNome.Text.ToUpper.Trim;

  usuario.email := txtEmail.Text.Trim;
  
  usuario.indDepart := 'S';  
  usuario.idCC := strtoInt(cmbDepto.SelectedValue);
  usuario.indBloqueio := 'N';

  usuario.idUsuarioConfirmacao := Tusuario(Session['usuario']).idUsuario;
  usuario.dtUltimaConfirmacao := DateTime.Now;

  usuario.salvar;
  perm := getControlador.getPermissaoMeta;
  perm.SalvarAutorMetas(usuario.idUsuario);

  if btnSalvar.Text = 'Incluir' then
  begin
    usuario.BuscarPorUserName(txtLogin.Text.ToUpper.Trim.Replace(' ',''));
  end;

  programas := Request.Form['ckbPrograma'];

  if programas = nil then
    programas := '';
  
  usuario.AtualizarProgramasAcesso(usuario.idUsuario.ToString , programas);

  aux := '';


  p := new TPapel;
  p.atualizarPapeisPorPrograma(usuario.idUsuario);

  trans.commitTrans;

  except
  on ex:Exception do
    begin
      trans.rollbackTrans;    
      TPageHelper.alert('Erro ao salvar os dados',self);
      TEmail.enviar('admsgu@puc-rio.br', 'noreply-sgu@puc-rio.br', 'Erro ao salvar usuário', ex.Message + ' <br > ' + ex.StackTrace);
      pnModulo.Controls.Add(new LiteralControl(ViewState["modulos"].ToString) );
      exit; 
   end;
  end;
 

  if btnSalvar.Text = 'Incluir' then
  begin
    //enviar as informações por email

    texto := new  TStringList;
    texto.Add('SGU - NOTIFICAÇÃO DE CRIAÇÃO DE USUÁRIO PARA ACESSO AO SISTEMA');
    texto.Add('*************************************************************');
    texto.Add('');
    texto.Add('Prezado(a) ' + usuario.nome.trim );
    texto.Add('');
    texto.Add('Informamos que foi criado um usuário para que você possa ter acesso ao SGU.');
    texto.add('Login: ' + usuario.username.Trim);
    texto.add('Senha: ' +senha);
    texto.Add('');
    texto.Add('');
    texto.Add('Atenciosamente,');
    texto.Add('Administração do SGU');  

    if usuario.cpf <> '55555555555' then
    begin
      TEmail.enviar(usuario.email, 'noreply-sgu@puc-rio.br', 'SGU - NOTIFICAÇÃO DE CRIAÇÃO DE USUÁRIO PARA ACESSO AO SISTEMA', texto.text);
      TPageHelper.alert('Um e-mail foi enviado para o novo usuário contendo os dados de login/senha para acesso ao SGU.\nConfigure o acesso aos processos.', self);
    end
    else
    begin
      TPageHelper.alert('Usuário criado com sucesso.', self, 0, 'S');
    end;

    CarregarUsuarios;
    cmbUsuario.SelectedValue := usuario.idUsuario.ToString;
    btnSalvar.Text := 'Salvar';  
    lkbProcessos_Click(nil, nil);
  end
  else
  begin
    if (sender <> nil) then
    begin
      TPageHelper.alert('Dados atualizados com sucesso', self , 0, 'S');
        texto := new  TStringList;
        texto.Add('SGU - NOTIFICAÇÃO DE ALTERAÇÃO DAS PERMISSÕES DE ACESSOS AO SISTEMA');
        texto.Add('*************************************************************');
        texto.Add('');
       texto.Add('Informamos que o seu acesso ao SGU foi alterado pelo login ' + TUSUARIO(session['usuario']).username + ' (' + TUSUARIO(session['usuario']).nome + ') em ' + Datetime.now.ToString(TSGUUtils.fmtDataHora) );
        texto.add('Login: ' + usuario.username.Trim);  
        texto.Add('');
        texto.Add('Atenciosamente,');
        texto.Add('Administração do SGU'); 

        TEmail.enviar(usuario.email, 'noreply-sgu@puc-rio.br', 'NOTIFICAÇÃO DE ALTERAÇÃO DAS PERMISSÕES DE ACESSOS AO SISTEMA', texto.text);
     end;
  end;
  lkbProcessos.Visible := true;
  btnBloquear.Enabled := true;
  btnReiniciar.Enabled := true;
  hlBusca.Visible := false;
  btnSalvar.Text := 'Salvar';  

  
  btnVoltar_Click(nil,nil);
  
end;

method ConcedeAcesso.btnReiniciar_Click(sender: System.Object; e: System.EventArgs);
var 
  usuario:TUsuario;
  texto  :TStringList;
  senha :String;
begin
  pnModulo.Controls.Add(new LiteralControl(ViewState["modulos"].ToString) );
  usuario:=new TUsuario;
  usuario.Buscar(StrtoInt(cmbUsuario.SelectedValue));

  if (usuario.email = TNulo.str) or (usuario.email.Trim = '') then
  begin
    TPageHelper.alert('O usuário '+ cmbUsuario.SelectedItem.Text.Trim() +' não possui e-mail cadastrado.', self.Page);
    exit;
  end;

  senha := TSGUUtils.GeraSenha();
  usuario.senha := senha;
  usuario.salvar;

  TPageHelper.alert('Senha reiniciada com sucesso. O usuário '+ cmbUsuario.SelectedItem.Text.Trim() +' receberá em instantes a nova senha por e-mail.', self.Page);

  texto := new  TStringList;
  texto.Add('SGU - NOTIFICAÇÃO DE ALTERAÇÃO DA SENHA PARA ACESSO AO SISTEMA');
  texto.Add('*************************************************************');
  texto.Add('');
  texto.Add('Informamos que a sua senha de acesso ao SGU foi reiniciada.');
  texto.add('Login: ' + usuario.username.Trim);
  texto.add('Nova senha: ' +senha);
  texto.Add('');
  texto.Add('');
  texto.Add('Atenciosamente,');
  texto.Add('SGU');  

  TEmail.enviar(usuario.email, 'noreply-sgu@puc-rio.br', 'SGU - NOTIFICAÇÃO DE ALTERAÇÃO DA SENHA PARA ACESSO AO SISTEMA', texto.text);
  
end;

method ConcedeAcesso.btnBloquear_Click(sender: System.Object; e: System.EventArgs);
var 
  usuario:TUsuario;
begin
  pnModulo.Controls.Add(new LiteralControl(ViewState["modulos"].ToString) );
  usuario:=new TUsuario;
  usuario.Buscar(StrtoInt(cmbUsuario.SelectedValue));

  usuario.indBloqueio := 'S';
  usuario.salvar;

  TPageHelper.alert('O usuário '+ cmbUsuario.SelectedItem.Text.Trim() +' foi bloqueado com sucesso.', self.Page);

  CarregarUsuarios;

  //carregar acesso do usuário selecionado
  if cmbUsuario.Items.Count > 0 then  
  begin
    cmbUsuario_SelectedIndexChanged(nil,nil);
  end;

end;

method ConcedeAcesso.btnNovo_Click(sender: System.Object; e: System.EventArgs);
begin
  btnSalvar.Text := 'Incluir';  
  txtNome.Text := '';
  txtLogin.Text := '';
  txtCPF.Text := '';
  txtEmail.Text := '';

  lbConfirmacao.text := '';

  lkbProcessos.Visible := false;

  btnBloquear.Enabled := false;
  btnReiniciar.Enabled := false;
  MontarAcesso();

  getControlador.CarregarPermissaoEspecial(-1  ,'ADOR66');
  dgMeta.Visible := false;
  lbTodas.Visible := true;

  lbUsuario.Visible := false;
  cmbUsuario.Visible := false;
  btnNovo.Visible := false;
  btnVoltar.visible := true;
  hlBusca.Visible := true;
  btnDesbloquear.Visible := false;

end;

procedure ConcedeAcesso.CarregarUsuarios;
var
    usuario : TUsuario;
    i: Integer;
begin
  usuario := new TUsuario;
  usuario.carregarPorIdCC(cmbDepto.SelectedValue );
  cmbUsuario.Items.Clear;
  cmbUSuario.SelectedValue := nil;
  cmbUsuario.DataSource := usuario.defaultDataTable;
  cmbUsuario.DataTextField := 'NOME';
  cmbUsuario.DataValueField := 'ID_USUARIO';
  cmbUsuario.DataBind;

end;

method ConcedeAcesso.CustomValidator1_ServerValidate(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);
begin
   if (txtCPF.Text.Trim = '55555555555') then
   begin
    args.IsValid := true;
    exit;
   end;
  args.IsValid := TSGUUtils.validar_cpf(txtCPF.Text.Trim);

  if (txtCPF.Text.Trim = '00000000000') then
    args.IsValid := true;

end;

method ConcedeAcesso.CustomValidator2_ServerValidate(source: System.Object; args: System.Web.UI.WebControls.ServerValidateEventArgs);
var
  usuario:TUsuario;
begin
  args.IsValid := true;
  usuario := new TUsuario;
  usuario.BuscarPorUserName(txtLogin.Text.Trim.ToUpper.Replace(' ',''));
  
  //checar se possui outro login igual cadastrado
  if btnSalvar.Text = 'Incluir' then
  begin
    if not usuario.ehVazio then
      args.IsValid := false;
  end
  else
  begin
    while not usuario.ehFim do
    begin
      if usuario.idUsuario.ToString  <> cmbUsuario.SelectedValue then
        args.IsValid := false;

      usuario.proximo;
    end;
  end;
end;

function ConcedeAcesso.getControlador: TControladorPermissaoEspecial;
begin
  createControlador(TControladoresFactory.CONTROLADOR_PERMISSAO_ESPECIAL);
  result := TControladorPermissaoEspecial(controlador);
end;

method ConcedeAcesso.Button1_Click(sender: System.Object; e: System.EventArgs);
var
  perm : TPermissaoEspecial;

begin
  pnModulo.Controls.Add(new LiteralControl(ViewState["modulos"].ToString) );
  if cmbMEta.Items.Count <= 0 then
    exit;
  perm := getControlador.getPermissaoMeta;

  //se já exister, não faz nada
  perm.primeiro;
  while not perm.ehFim do
  begin
    if perm.idMetaFase = StrtoInt(cmbMeta.SelectedValue) then
    begin
      exit;
    end;
    perm.proximo;
  end;

  lbTodas.Visible := false;
  
  perm.adicionar;  
  perm.idMetaFase := strtoint(cmbMeta.SelectedValue);
  perm.setCampo('controle',cmbMeta.SelectedItem.Text);  
  
  dgMeta.DataSource := perm.defaultDataTable;
  dgMeta.DataBind;  
  dgMeta.Visible := true;

end;

method ConcedeAcesso.btnVoltar_Click(sender: System.Object; e: System.EventArgs);
begin
  lbUsuario.Visible := true;
  cmbUsuario.Visible := true;
  btnNovo.Visible := true;
  btnVoltar.Visible := false;
  btnDesbloquear.Visible := true;
  hlBusca.Visible := false;
  btnSalvar.Text := 'Salvar';
  lkbProcessos.Visible := true;

  cmbUsuario_SelectedIndexChanged(nil,nil);
end;

method ConcedeAcesso.dgMeta_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
var
  perm : TPermissaoEspecial;
begin
  pnModulo.Controls.Add(new LiteralControl(ViewState["modulos"].ToString) );
  perm := getControlador.getPermissaoMeta;
  perm.irParaIndice(dgMeta.SelectedIndex);
  perm.remover;

  dgMeta.DataSource := perm.defaultDataTable;
  dgMeta.DataBind;  

  dgMeta.Visible := perm.numeroRegistros > 0;

end;

method ConcedeAcesso.cmbDepto_SelectedIndexChanged(sender: System.Object; e: System.EventArgs);
var
    meta : TMetaFase;
begin
  CarregarUsuarios;
  cmbUsuario_SelectedIndexChanged(nil,nil);

    meta := new TmetaFase;
    meta.buscarMetaFasePorCC( cmbDepto.selectedValue , 'S' );

    cmbMeta.Items.Clear;
    cmbMeta.SelectedValue := nil;
    cmbMeta.DataSource := meta.defaultDataTable;  
    cmbMeta.DataTextField := 'CONTROLE';
    cmbMeta.DataValueField := 'ID_META_FASE';
    cmbMeta.DataBind;

end;

method ConcedeAcesso.txtIdCliente_ValueChanged(sender: System.Object; e: System.EventArgs);
var func : TFuncionario;
begin
  func := new TFuncionario;
  func.Buscar(txtIdCliente.Value);

  pnModulo.Controls.Add(new LiteralControl(ViewState["modulos"].ToString) );

  if not func.ehVazio then
  begin
    txtNome.Text := func.nome.Trim;
    txtCPF.Text := func.cpf.Trim;
    txtEmail.Text := func.email;
  end;


end;

method ConcedeAcesso.lkbProcessos_Click(sender: System.Object; e: System.EventArgs);
begin
  self.Validate();
  if self.IsValid then
  begin
    gerenciaProcessos.exibeJanela(Convert.ToInt32(cmbUsuario.SelectedValue));
  end
  else
  begin
    TPageHelper.alert('Dados inconsistentes', self.Page);
  end;
end;

procedure ConcedeAcesso.recarregaUsuario;
begin
  cmbUsuario_SelectedIndexChanged(nil, nil);
end;

method ConcedeAcesso.copiaDadosPesqFavorecido(sender: System.Object; e: System.EventArgs);
begin
  txtIdCliente.Value := pesFavorecido.getMatricula;
  txtIdCliente_ValueChanged(nil,nil);
end;

method ConcedeAcesso.hlBusca_Click(sender: System.Object; e: System.EventArgs);
begin
  pesFavorecido.abreJanela(true, false, false, false, false, false, true);
end;

method ConcedeAcesso.btnDesbloquear_Click(sender: System.Object; e: System.EventArgs);
var 
  usuario:TUsuario;
begin

  pnModulo.Controls.Add(new LiteralControl(ViewState["modulos"].ToString) );
  usuario:=new TUsuario;
  usuario.Buscar(StrtoInt(cmbUsuario.SelectedValue));

  usuario.indBloqueio := 'N';
  usuario.salvar;

  TPageHelper.alert('O usuário '+ cmbUsuario.SelectedItem.Text.Trim().Replace('(BLOQUEADO)', '') + ' foi desbloqueado com sucesso.', self.Page, 'S');

  CarregarUsuarios;

  //carregar acesso do usuário selecionado
  if cmbUsuario.Items.Count > 0 then  
  begin
    cmbUsuario_SelectedIndexChanged(nil,nil);
  end;
  
end;

end.
