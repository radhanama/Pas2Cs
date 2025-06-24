namespace SGU.Business;

interface

uses System.Web, System.Data, System.IO, System.Reflection, log4net,
	     SGU.DataAccess,
	     System.Text, System.Web, System.Configuration, SGU.Infra, System.Collections, System.Collections.Generic;

type
  TBCBasico2 = public abstract class
  
  private
    fdefaultDataSet :DataSet;
    fdefaultDataTable :DataTable;
    businessTrans :TBusinessTransaction;
    fInternet : Boolean;
    

    procedure setDefaultDataSet(ds :DataSet);
    function strConexao():string;
    function getDAOType :System.Type;
    procedure createDAO;
    procedure iniciar;

  protected
    class var
      log :ILog; //static
    var
      frowInd : integer;
      ftableName :string;
      fdaoObject :TDABasico2;

    function getCampo( nomeCampo: string; tipoNulo:Object) : Object;
    procedure setCampo( nomeCampo: string; tipoNulo, valor:Object); 

  public
    constructor ;  
    constructor ( eh_internet : Boolean);  
    constructor (businessTrans :TBusinessTransaction);  

    procedure popularDS(data : DataTable);
    procedure buscarSchema();

    {$REGION 'Propriedades'}
    property defaultDataSet :DataSet read fdefaultDataSet write setDefaultDataSet;
    property defaultDataTable :DataTable read fdefaultDataTable write fdefaultDataTable;
    property stringConexao :string read strConexao;
    property daoObject :TDABasico2 read fdaoObject write fdaoObject;
    function numeroRegistros: integer;
    property internet :boolean read fInternet write fInternet;
    {$ENDREGION}

    {$REGION 'Métodos de Acesso'}
    procedure setBusinessTransaction(businessTrans :TBusinessTransaction);
    function  getBusinessTransaction :TBusinessTransaction;
    function getDataSet() : DataSet;
    {$ENDREGION}

    {$REGION 'Métodos de Atualização do DataSet Padrão'}
    procedure setAutoIncrement(nomeCampo :string);
    procedure adicionar(); 
    procedure adicionar(tableName:string); 
    procedure adicionarNaPosicao(posicao : Integer ); 
    procedure remover();
    function  salvar(): integer; virtual; abstract;
    procedure limpar();
    procedure copiarDados( bc : TBCBasico2);
    procedure historico; virtual;
    {$ENDREGION}

    {$REGION 'Métodos de Navegação no DataSet Padrão'}
    function primeiro() : boolean;
    function ultimo() : boolean;
    function proximo(): boolean;
    function anterior(): boolean;
    function indUltimaPos():integer;
    function indPrimeiraPos():integer;
    function irParaIndice(i:integer):boolean;
    {$ENDREGION}

    {$REGION 'Métodos de Controle da Navegação no DataSet Padrão'}
    function ehPrimeiro(): boolean;
    function ehUltimo(): boolean;
    function ehVazio(): boolean;
    function ehFim(): boolean;
    function ehNova(): boolean;
    function ehDeletado(): boolean;
    {$ENDREGION}

    {$REGION 'Obter Campos Estendidos no DataSet Padrão'}
    function getCampoString(nome_campo : String ) : String; 
    function getCampoNumerico(nome_campo : String ) : double; 
    function getCampoInteiro(nome_campo : String ) : Int32; 
    function getCampoData(nome_campo : String ) : datetime;
   {$ENDREGION}

    {$REGION 'Setar Campos Estendidos no DataSet Padrão'}
    procedure setCampo(nome_campo : String; valor : string );
    procedure setCampo(nome_campo : String; valor : double); 
    procedure setCampo(nome_campo : String; valor : integer ); 
    procedure setCampo(nome_campo : String; valor : datetime); 
    {$ENDREGION}

    function gerarCSV( fullFileName:string): integer;
    function gerarJson() : String;
    function gerarListHashtable() : List<Hashtable>;

  end;

implementation

{$REGION 'Construtor'}
constructor TBCBasico2;
begin
  inherited;
  iniciar;
end;

constructor TBCBasico2(eh_internet: boolean);
begin
  inherited constructor;
  internet := eh_internet;
  iniciar;
  self.setBusinessTransaction(businessTrans);
end;

constructor TBCBasico2(businessTrans: TBusinessTransaction);
begin
  inherited constructor;
  iniciar;
  self.setBusinessTransaction(businessTrans);
end;

procedure TBCBasico2.iniciar;
begin
  self.fdefaultDataSet := nil;
  self.fdefaultDataTable := nil;
  self.frowInd := -1;
  self.ftableName := '';
  log := log4net.LogManager.GetLogger(typeof(TBCBasico2).toString);
  createDAO;
end;

function TBCBasico2.irParaIndice(i: integer): boolean;
var idx : integer;
begin
  self.primeiro;
  idx := 0 ;
  while (not self.ehfim) and (idx < i) do
  begin
    self.proximo;
    idx := idx + 1;
  end;
  result := (idx = i);
end;

procedure TBCBasico2.createDAO();
var
  config : AppSettingsReader;
  classType :System.Type;
  helper: TDAHelper;
  projeto : String;
begin
  config := new  AppSettingsReader();
  classType := self.getDAOType;
  try
  projeto :=  config.GetValue('projeto',System.Type.GetType('System.String')).ToString();
  except
    projeto :=  '';
  end;

  //classType := System.Type.GetType('TDA' +  Self.GetType.Name.Substring(1).toUpper);

  //2020-11-17
  //se for projeto AAA, não abrir nova conexão
  if (self.fInternet) and (not TSGUUtils.estaNaInternet) and (projeto <> 'AAA') then
  begin

    if (HttpContext.Current = nil) then
    begin
     // helper := TDAHelperFactory.getNewHelperImpl(THelperImpl.hlOLEDB);
       helper := TBusinessFacade.getHelper('helper_internet');
    end    
    else
    begin
      //se objeto é de internet, criar helper para conexao na internet!
      {if HttpContext.Current.Items['helper_internet'] = nil then
        HttpContext.Current.Items['helper_internet'] := TDAHelperFactory.getNewHelperImpl(THelperImpl.hlOLEDB);
    
      helper := TDAHelper(HttpContext.Current.Items['helper_internet']);}
      helper := TBusinessFacade.getHelper('helper_internet');
    end;
    helper.internet := true;
  end
  else  
  if (HttpContext.Current <> nil) and (HttpContext.Current.Session <> nil) then
  begin
    helper := TBusinessFacade.getHelper(HttpContext.Current.Session.SessionID)
  end
  else
  begin
    //log.Info('Sessão Nula em TBCBasico2.createDAO.');
    //helper := TDAHelperFactory.getNewHelperImpl(THelperImpl.hlOLEDB);
    //2010-06-10 - Gmoreira e Pedro - Pegar sempre o mesmo helper
    //Console.WriteLine('Pegou Helper unico');
    helper := TBusinessFacade.getHelper('SINGLETON');
  end;

  //gmoreira - 2017-09-26 - devido ao novo modulo de Esocial
  //se não achou o tipo, pula fora
  if (classType = nil) then exit;

  if self.businessTrans = nil then
    self.daoObject :=  TDABasico2(Activator.CreateInstance(classType, [helper]))
  else
    self.daoObject :=  TDABasico2(Activator.CreateInstance(classType, [businessTrans.getDAHelper]));
end;
{$ENDREGION}

{$REGION 'Métodos de Navegação'}
function TBCBasico2.numeroRegistros: integer;
begin
  if self = nil then
  begin
    raise new  exception('TBCBasico2.numeroRegistros - Chamou método de objeto (self) NULO.');
  end;

  if (self.defaultDataTable <> nil) and
     (self.defaultDataTable.DefaultView <> nil) then
  begin
    result := self.defaultDataTable.DefaultView.Count;
  end
  else
    result := 0;
end;

function TBCBasico2.primeiro : boolean;
begin
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.primeiro - Inicio');
  end;}
  
  if not self.ehVazio() then
  begin
    fRowInd := self.indPrimeiraPos;
    result := true;
  end
  else
  begin
    result := false;
  end;

  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.primeiro - Fim');
  end;}
end;

function TBCBasico2.ultimo : boolean;
begin
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.ultimo - Inicio');
  end;}

  if not self.ehVazio() then
  begin
    self.frowInd := self.indUltimaPos;
    result := true;
  end
  else
  begin
    result := false;
  end;

  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.ultimo - Fim');
  end;}
end;

function TBCBasico2.ehNova: boolean;
begin
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico.ehNova - Inicio');
  end;}

  if not ehVazio and not ehFim  then
  begin
    if self.defaultDataTable.Rows[frowInd].RowState = DataRowState.Added then
      result := true;
  end
  else
    result := false;

  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico.ehNova - Fim');
  end;}
end;

function TBCBasico2.ehDeletado: boolean;
begin
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico.ehDeletado - Inicio');
  end;}

  if not ehVazio and not ehFim  then
  begin
    if self.defaultDataTable.Rows[frowInd].RowState = DataRowState.Deleted then
      result := true;
  end
  else
    result := false;

  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico.ehDeletado - Fim');
  end;}
end;

function TBCBasico2.proximo: boolean;
var
  i:integer;
begin
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.proximo - Inicio');
  end;}

  if not self.ehFim then
  begin
    for i:= self.frowInd+1 to self.fdefaultDataTable.Rows.Count - 1 do
    begin
      if self.fdefaultDataTable.Rows[i].RowState <> DatarowState.Deleted then
      begin
        self.frowInd := i;
        result := true;
        break;
      end;
    end;

    //não tem proxima posicao valida, então coloca um indice invalido.
    if i = self.fdefaultDataTable.Rows.Count then
      self.frowInd := self.fdefaultDataTable.Rows.Count;
  end
  else
    result := false;

  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.proximo - Fim');
  end;}
end;

function TBCBasico2.anterior: boolean;
var
  i:integer;
begin
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.anterior - Inicio');
  end;}

  if not self.ehFim then
  begin
    for i:= self.frowInd-1 downto 0 do
    begin
      if self.fdefaultDataTable.Rows[i].RowState <> DatarowState.Deleted then
      begin
        self.frowInd := i;
        result := true;
        break;
      end;
    end;
    //não tem proxima posicao valida, então coloca um indice invalido.
    if i = self.fdefaultDataTable.Rows.Count then
      self.frowInd := -1;
  end
  else
    result := false;

  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.anterior - Fim');
  end;}
end;
procedure TBCBasico2.copiarDados(bc: TBCBasico2);
var
  dr:DataRow;
  i:integer;
begin

  if self.defaultDataTable = nil then
    self.defaultDataTable := bc.defaultDataTable.Clone;

  self.limpar;

  bc.primeiro;

  while not bc.ehFim do
  begin
    dr := self.fdefaultDataTable.NewRow;

    for i := 0 to bc.defaultDataTable.Columns.Count-1 do
    begin
      dr[i] := bc.defaultDataTable.Rows[bc.frowInd][i];
    end;

    self.fdefaultDataTable.Rows.Add(dr);

    bc.proximo;
  end;

  self.primeiro;
  bc.primeiro;
end;
{$ENDREGION}

{$REGION 'Métodos de Controle da Navegação no DataSet Padrão'}
function TBCBasico2.ehPrimeiro: boolean;
var
  i:integer;
begin
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.ehPrimeiro - Inicio');
  end;}

  if self.ehVazio then
  begin
    result := false;
  end
  else
  begin
    for I := 0 to self.defaultDataTable.Rows.Count - 1 do
    begin
      if self.defaultDataTable.Rows[i].RowState <> DataRowState.Deleted then
      begin
        result :=  self.frowInd = i;
        break;
      end;
    end;
  end;

  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.ehPrimeiro - Fim');
  end;}
end;

function TBCBasico2.ehUltimo: boolean;
var
  i:integer;
begin
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.ehUltimo - Inicio');
  end;}

  if self.ehVazio then
  begin
    result := false;
  end
  else
  begin
    for I := self.defaultDataTable.Rows.Count - 1 downto 0 do
    begin
      if self.defaultDataTable.Rows[i].RowState <> DataRowState.Deleted then
      begin
        result :=  self.frowInd = i;
        break;
      end;
    end;
  end;

  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.ehUltimo - Fim');
  end;}
end;

function TBCBasico2.ehVazio: boolean;
begin
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.ehVazio - Inicio');
  end;}

  if numeroRegistros = 0 then
  begin
    result := true;
  end
  else
  begin  
    result := false;
  end;
    
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.ehVazio - Fim');
  end;}
end;

function TBCBasico2.ehFim: boolean;
begin
  if ( self.ehVazio ) or 
     ( frowInd > self.indUltimaPos) or
     ( frowInd = -1 )   then
    result := true
  else
    result := false;

end;

function TBCBasico2.indUltimaPos: integer;
var
  i:integer;
begin
  result := -1;
  
  if self.ehVazio then
    exit;

  for i := self.defaultDataTable.Rows.Count - 1 downto 0 do
    begin
      if self.defaultDataTable.Rows[i].RowState <> DataRowState.Deleted then
      begin
        result :=  i;
        break;
      end;
  end;
end;
{$ENDREGION}

{$REGION 'Métodos de Acesso'}
procedure TBCBasico2.setAutoIncrement(nomeCampo: string);
begin
  self.defaultDataSet.Tables[ftableName].Columns[nomeCampo].AutoIncrement := true;
end;

procedure TBCBasico2.setBusinessTransaction(businessTrans: TBusinessTransaction);
begin

end;

function TBCBasico2.gerarCSV(fullFileName: string): integer;
var
  stream : StreamWriter;
  str, nmArq, ln : string;
  i: Integer;
  k: Integer;
begin

  try

  stream := new  StreamWriter(fullFileName, false, System.Text.Encoding.GetEncoding('ISO-8859-1'));

  try
  ln := '';

  for i := 0 to self.fdefaultDataTable.Columns.Count - 1 do
  begin
      ln := ln +  self.fdefaultDataTable.Columns[i].columnName + ';'
  end;

  stream.WriteLine(ln);

  for i := 0 to  self.fdefaultDataTable.Rows.Count - 1 do
  begin
    ln := '';
    for k := 0 to self.fdefaultDataTable.Columns.Count - 1 do
    begin

      
      if self.fdefaultDataTable.Rows[i][k] <> System.DBNull.Value  then
      begin
        //tudo que é ";" tem que virar virgula
        self.fdefaultDataTable.Rows[i][k] := self.fdefaultDataTable.Rows[i][k].toString.Replace(';',',');

        //retirar quebra de linha
        self.fdefaultDataTable.Rows[i][k] := self.fdefaultDataTable.Rows[i][k].toString.Replace(#13,'');

        self.fdefaultDataTable.Rows[i][k] := self.fdefaultDataTable.Rows[i][k].toString.Replace(#10,'');

      end;

      if (self.fdefaultDataTable.Rows[i][k] <> System.DBNull.Value) and ( self.fdefaultDataTable.Rows[i][k] is DateTime )   then
        ln := ln + DateTime(self.fdefaultDataTable.Rows[i][k]).toString('dd/MM/yyyy') + ';'
      else
        ln := ln + self.fdefaultDataTable.Rows[i][k].toString.trim + ';';

    end;
    stream.WriteLine(ln);
  end;
    result :=  1;
  finally
    stream.Close;
  end;

  except
    result :=  0;
  end;

end;

function TBCBasico2.getBusinessTransaction: TBusinessTransaction;
begin
  result := self.businessTrans;
end;

procedure TBCBasico2.setCampo(nomeCampo: string; tipoNulo, valor:Object);
var b:Array of byte;
begin
  b := new array of byte(0);

   if not self.ehVazio() then
   begin

    try
      defaultDataTable.Columns[nomeCampo].ReadOnly := false;
    except
    end;

    if valor = nil then
        defaultDataTable.Rows[self.frowInd].Item[nomeCampo] := System.DBNull.Value
    else      
      if valor.Equals(tipoNulo) then
      begin
        defaultDataTable.Rows[self.frowInd].Item[nomeCampo] := System.DBNull.Value
      end
      else
      begin
          {if (defaultDataTable.Rows[self.frowInd].Item[nomeCampo].GetType = b.GetType) then
             defaultDataTable.Rows[self.frowInd].Item[nomeCampo] := System.Text.Encoding.UTF8.GetBytes(valor.ToString()) 
          else}
            try
              defaultDataTable.Rows[self.frowInd].Item[nomeCampo] := Object(valor);
            except
              //se der erro tenta como bytes
              defaultDataTable.Rows[self.frowInd].Item[nomeCampo] := System.Text.Encoding.UTF8.GetBytes(valor.ToString());
            end;
      end;
   end;
  
end;

function TBCBasico2.getCampo(nomeCampo:string ; tipoNulo:Object) : Object;
begin
  if (not self.ehVazio) and (not (defaultDataTable.Rows[self.frowInd].Item[nomeCampo] = System.DBNull.Value)) then
  begin
    result := defaultDataTable.Rows[self.frowInd].Item[nomeCampo];
  end
  else
    result := tipoNulo;
end;

function TBCBasico2.getDataSet: DataSet;
begin
  result := fdefaultDataSet;
end;

procedure TBCBasico2.historico;
begin

end;

function TBCBasico2.indPrimeiraPos: integer;
var
  i:integer;
begin
  result := -1;
  
  for i := 0 to self.defaultDataTable.Rows.Count - 1 do
    begin
      if self.defaultDataTable.Rows[i].RowState <> DataRowState.Deleted then
      begin
        result := i;
        break;
      end;
    end;
end;
{$ENDREGION}

{$REGION 'Métodos de Atualização do DataSet Padrão'}
procedure TBCBasico2.limpar;
begin
  self.primeiro;

  while not self.ehFim do
  begin
    if self.defaultDataTable.Rows[self.frowInd].RowState = DataRowState.Added then
    begin
      self.remover;
    end
    else
    begin
      self.remover;
      self.proximo;
    end;
  end;

  self.frowInd := -1;
end;

procedure TBCBasico2.adicionar(tableName:string);
var
  dr: DataRow;
  i: integer;
  dt: DateTime;
  rand :Random;
begin

  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.adicionar - Inicio');
  end;}

   Try
   dt := DateTime.Today;

   dr := self.defaultDataSet.Tables[tableName].NewRow();

   for i := 0 to self.defaultDataSet.Tables[tableName].Columns.Count-1 do
   begin

    if (not self.defaultDataSet.Tables[tableName].Columns[i].AllowDBNull)  then
    begin
      if self.defaultDataSet.Tables[tableName].Columns[i].DataType = System.Type.GetType('System.DateTime') then
      begin
        dr.Item[i] := dt;
      end
      else
      if self.defaultDataSet.Tables[tableName].Columns[i].DataType = System.Type.GetType('System.TimeSpan') then
      begin
        dr.Item[i] := dt.TimeOfDay;
      end
      else
      if self.defaultDataSet.Tables[tableName].Columns[i].DataType = System.Type.GetType('System.String') then
      begin
        dr.Item[i] := '';
      end
      else
      if self.defaultDataSet.Tables[tableName].Columns[i].DataType = System.Type.GetType('System.Int32') then
      begin
        dr.Item[i] := Object(-1);
      end
      else
      begin
        dr.Item[i] := '-1';
      end;

    end
    else
    begin
      dr.Item[i] := System.DbNull.Value;
    end;

   { if (self.defaultDataSet.Tables[tableName].Columns[i].AutoIncrement) then
    begin
      //dr.Item[i] := Convert.toString(Random(100000) * (-1));
      rand := new Random(100000);
      dr.Item[i] := Convert.toString(rand.Next * (-1));
    end;}

   end;

   self.defaultDataSet.Tables[tableName].Rows.Add(dr);
   self.frowInd := self.defaultDataSet.Tables[tableName].Rows.Count-1;

   except
    on e:exception do
    begin
      if (log.IsErrorEnabled) then
      begin
        if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
         log.Error('Erro TBCBasico2.Adicionar - ' + e.Message + ' Tabela:' + self.ftableName + ' Pilha de Execução: ' + e.StackTrace);
      end;
      raise new  Exception('Erro ao adicionar nova linha na tabela : ' + self.ftableName + ' Erro: ' + e.Message);
    end;

   end;

 { if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.Adicionar - Fim');
  end;}
end;

procedure TBCBasico2.adicionar();
begin
{
  if self.defaultDataSet = nil then
     getDAO.buscar(self.ftableName);
}
  if self.defaultDataSet = nil then
     self.buscarSchema();
  adicionar(self.defaultDataSet.Tables[0].TableName);
end;

procedure TBCBasico2.remover();
begin
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.remover - Inicio');
  end;}
   try
     if self.defaultDataTable.Rows[self.frowInd].RowState <> DataRowState.Deleted then
     begin
       self.defaultDataTable.Rows[self.frowInd].Delete;
     end;
   except
    on e:exception do
    begin
      if (log.IsErrorEnabled) then
      begin
        if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
         log.Error('Erro TBCBasico2.remover - ' + e.Message + ' Tabela:' + self.ftableName + ' Pilha de Execução: ' + e.StackTrace);
      end;
      raise new  Exception('Erro ao remover linha na tabela : ' + self.ftableName + ' Erro: ' + e.Message);
    end;
   end;

  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.remover - Fim');
  end;}
end;
{$ENDREGION}

{$REGION 'Obter Campos Extendidos no DataSet Padrão'}
function TBCBasico2.getCampoString(nome_campo : String ) : String;
begin
  nome_campo  := nome_campo.ToUpper;
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.getCampoString - Inicio');
  end;}

  if not self.ehVazio() then
  begin
    if defaultDataTable.Rows[self.frowInd].Item[nome_campo] <> System.DBNull.Value then
      result := string(defaultDataTable.Rows[self.frowInd].Item[nome_campo])
    else
      result := TNulo.str;
  end
  else
    result := '';

  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.getCampoString - Fim');
  end;}
end;

function TBCBasico2.getCampoData(nome_campo : String ) : datetime;
begin
  nome_campo  := nome_campo.ToUpper;
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.getCampoData - Inicio');
  end;}

  if not self.ehVazio() then
  begin
    if defaultDataTable.Rows[self.frowInd].Item[nome_campo] <> System.DBNull.Value then
       result := datetime(defaultDataTable.Rows[self.frowInd].Item[nome_campo])
    else
       result := TNulo.dth;
  end
  else
      result := System.Convert.ToDateTime(nil);

 { if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.getCampoData - Fim');
  end;}
end;

function TBCBasico2.getCampoNumerico(nome_campo : String ) : double;
begin
  nome_campo  := nome_campo.ToUpper;
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.getCampoNumerico - Inicio');
  end;}

  if not self.ehVazio() then
  begin
    if defaultDataTable.Rows[self.frowInd].Item[nome_campo] <> System.DBNull.Value then
      result :=  Convert.ToDouble (defaultDataTable.Rows[self.frowInd].Item[nome_campo])
    else
      result := TNulo.dbl;
  end
  else
    result := 0;

  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.getCampoNumerico - Fim');
  end;}
end;

function TBCBasico2.getCampoInteiro(nome_campo : String ) : Int32;
begin
  nome_campo  := nome_campo.ToUpper;
  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.getCampoNumerico - Inicio');
  end;}
  
  if not self.ehVazio() then
  begin
    if defaultDataTable.Rows[self.frowInd].Item[nome_campo] <> System.DBNull.Value then
      result := Int32(defaultDataTable.Rows[self.frowInd].Item[nome_campo])
    else
      result := TNulo.int;
  end
  else
    result := 0;

 { if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.getCampoNumerico - Fim');
  end;}
end;

procedure TBCBasico2.setCampo(nome_campo: String; valor: double);
begin
  self.setCampo(nome_campo, Object(TNulo.dbl), Object(valor));
end;

procedure TBCBasico2.setCampo(nome_campo, valor: string);
begin
  self.setCampo(nome_campo, Object(TNulo.str), Object(valor));
end;

procedure TBCBasico2.setCampo(nome_campo: String; valor: datetime);
begin
  self.setCampo(nome_campo, Object(TNulo.dth), Object(valor));
end;

procedure TBCBasico2.setCampo(nome_campo: String; valor: integer);
begin
  self.setCampo(nome_campo, Object(TNulo.int), Object(valor));
end;


{$ENDREGION}

{$REGION 'Métodos Privados'}
procedure TBCBasico2.setDefaultDataSet(ds: DataSet);
begin
  if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.setDefaultDataSet - Inicio');
  end;
  fdefaultDataSet := ds;
  fdefaultDataTable := ds.Tables[0];
  fdefaultDataTable.TableName := self.ftableName;

  if not self.primeiro then
  begin
    frowInd := -1;
  end;
  if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.setDefaultDataSet - Fim');
  end;
end;

function TBCBasico2.strConexao : string;
var
   helper : TDAHelper;
begin
  if (HttpContext.Current <> nil) and (HttpContext.Current.Session <> nil) then
    helper := TBusinessFacade.getHelper(HttpContext.Current.Session.SessionID)
  else
  begin
    log.Info('Sessão Nula em TBCBasico2.strConexao.');
    helper := TDAHelperFactory.getNewHelperImpl(THelperImpl.hlOLEDB);
  end;

  //result := helper.montaStringConexao();
  result := '';
end;

function TBCBasico2.getDAOType :System.Type;
var
  i: Integer;
  namespacePath: string;
  daAssembly: &Assembly;
  types: array of System.Type;
begin
  namespacePath := TSguUtils.PathCompletoAbsoluto;

  if  ( Self.GetType.Name.toUpper.IndexOf('TESOCIAL') >=0 ) or ( Self.GetType.Name.toUpper.IndexOf('TREINF') >=0 ) then
  begin
    namespacePath := namespacePath + '\eSocial.DataAccess.dll';
    daAssembly := System.Reflection.&Assembly.UnsafeLoadFrom(namespacePath);
  end
  else
  begin
    namespacePath := namespacePath + '\SGU.DataAccess.dll';    
    daAssembly := System.Reflection.&Assembly.UnsafeLoadFrom(namespacePath);
  end;
  
  
  //try    
    //daAssembly := System.Reflection.&Assembly.LoadFrom(namespacePath);
  //except    
    //daAssembly := System.Reflection.&Assembly.UnsafeLoadFrom(namespacePath);
  //end;


  types := daAssembly.GetTypes;
  for i := 0 to System.Array(types).Length - 1 do
  begin
    if types[i].Name.ToUpper = 'TDA' + Self.GetType.Name.Substring(1).toUpper then
    begin
      result := types[i];
      exit;
    end;
  end;
end;
{$ENDREGION}

procedure TBCBasico2.adicionarNaPosicao(posicao : Integer );
var
  dr: DataRow;
  i: integer;
  dt: DateTime;
  rand :Random;
  tableName : String;
begin

  tableName := self.defaultDataSet.Tables[0].TableName;

  {if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.adicionar - Inicio');
  end;}

   Try
   dt := DateTime.Today;

   dr := self.defaultDataSet.Tables[tableName].NewRow();

   for i := 0 to self.defaultDataSet.Tables[tableName].Columns.Count-1 do
   begin

    if (not self.defaultDataSet.Tables[tableName].Columns[i].AllowDBNull) and (not self.defaultDataSet.Tables[tableName].Columns[i].AutoIncrement) then
    begin
      if self.defaultDataSet.Tables[tableName].Columns[i].DataType = System.Type.GetType('System.DateTime') then
      begin
        dr.Item[i] := dt;
      end
      else
      if self.defaultDataSet.Tables[tableName].Columns[i].DataType = System.Type.GetType('System.TimeSpan') then
      begin
        dr.Item[i] := dt.TimeOfDay;
      end
      else
      if self.defaultDataSet.Tables[tableName].Columns[i].DataType = System.Type.GetType('System.String') then
      begin
        dr.Item[i] := '';
      end
      else
      if self.defaultDataSet.Tables[tableName].Columns[i].DataType = System.Type.GetType('System.Int32') then
      begin
        dr.Item[i] := Object(-1);
      end
      else
      begin
        dr.Item[i] := '-1';
      end;

    end
    else
    begin
      dr.Item[i] := System.DbNull.Value;
    end;

    if (self.defaultDataSet.Tables[tableName].Columns[i].AutoIncrement) then
    begin
      //dr.Item[i] := Convert.toString(Random(100000) * (-1));
      rand := new Random(100000);
      dr.Item[i] := Convert.toString(rand.Next * (-1));
    end;

   end;

   self.defaultDataSet.Tables[tableName].Rows.InsertAt(dr,posicao);
   self.frowInd := self.defaultDataSet.Tables[tableName].Rows.Count-1;

   except
    on e:exception do
    begin
      if (log.IsErrorEnabled) then
      begin
        if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
         log.Error('Erro TBCBasico2.Adicionar - ' + e.Message + ' Tabela:' + self.ftableName + ' Pilha de Execução: ' + e.StackTrace);
      end;
      raise new  Exception('Erro ao adicionar nova linha na tabela : ' + self.ftableName + ' Erro: ' + e.Message);
    end;

   end;

 { if (log.IsDebugEnabled) then
  begin
    if log4net.ThreadContext.Properties.get_Item('id_usuario') <> nil then
      //COMENTARIO 0511 log.debug('TBCBasico2.Adicionar - Fim');
  end;}

end;

procedure TBCBasico2.popularDS(data : DataTable);
var
  i, j : Integer;
begin
  self.buscarSchema();
  for j := 0 to data.Rows.Count - 1 do begin
    self.adicionar;
    for i := 0 to data.Columns.Count - 1 do begin
      try
        self.defaultDataTable.Rows[j].Item[data.Columns[i].ColumnName] := data.Rows[j].Item[data.Columns[i].ColumnName];
      except

      end;
    end;    
  end;
  
end;

procedure TBCBasico2.buscarSchema();
begin
  try
    if self.defaultDataTable <> nil then begin
        self.defaultDataSet := daoObject.buscarSchema(self.defaultDataTable.TableName);
    end else begin
        self.defaultDataSet := daoObject.buscarSchema(self.ftableName);  
    end;
  except
    on ex:Exception do
    begin
        raise new Exception(ex.Message + '<br>' + ex.StackTrace);
    end;

  end;
end;

function TBCBasico2.gerarJson() : String;
var
  rows : List<Hashtable>;
begin
  rows := gerarListHashtable();
  result := SGUJsonHandler.Serialize(rows);
end;

function TBCBasico2.gerarListHashtable() : List<Hashtable>;
var
  i, k : Integer;
  rows : List<Hashtable>;
  row : Hashtable;
begin
  rows := new List<Hashtable>();

  for i := 0 to  self.fdefaultDataTable.Rows.Count - 1 do
  begin
    
    row := new Hashtable();

    for k := 0 to self.fdefaultDataTable.Columns.Count - 1 do
    begin
      
      if self.fdefaultDataTable.Rows[i][k] <> System.DBNull.Value  then
        row[self.fdefaultDataTable.Columns[k].columnName] := self.fdefaultDataTable.Rows[i][k].toString.trim
      else
        row[self.fdefaultDataTable.Columns[k].columnName] := nil;

    end;

    rows.Add(row);

 end;
 
 result := rows;

end;

end.
