namespace SGU.Business;

interface

uses System.Data, ShineOn.Rtl, ShineOn.Vcl, log4net, System.Collections, System.IO, SGU.DataAccess, System.Web;


type
  TFuncGrat = public class(TBCBasico2)
  protected

  {$REGION 'Associaçőes'}
      gratificacao : TGratificacao;
      pfunc : TPapelFuncional;
    {$ENDREGION}

  private
    {$REGION 'Declaração dos Métodos de Acesso'}
    function getIdFuncGrat : integer;
    procedure setIdFuncGrat (idF : integer);
    function getCodPd : string;
    procedure setCodPd (cod : string);
//    function getIdCliente : integer;
//    procedure setIdCliente (idC : integer);
    function getMatricula : string;
    procedure setMatricula (mat : string);
    function getValor : double;
    procedure setValor (val : double);
    function getDtInicio : datetime;
    procedure setDtInicio (dtI : datetime);
    function getCodPapel : string;
    procedure setCodPapel (cod : string);
    function getCodGratificacao : string;
    procedure setCodGratificacao (cod : string);
    function getDtFim : datetime;
    procedure setDtFim (dtF : datetime);
    function getValorAntecip : double;
    procedure setValorAntecip (val : double);
    function getQtdRef : integer;
    procedure setQtdRef (qtd : integer);
    {$ENDREGION}

  protected

    function getDAO : TDAFuncGrat;

  public    {$REGION 'Declaração dos Métodos para Obter Associaçőes'}
    function getGratificacao : TGratificacao;
    function getPapelFuncional : TPapelFuncional;
    {$ENDREGION}

    {$REGION 'Declaração das Propriedades'}
    property idFuncGrat : integer read getIdFuncGrat write setIdFuncGrat;
    //property codPd : string read getCodPd write setCodPd;
//    property idCliente : integer read getIdCliente write setIdCliente;
    property matricula : string read getMatricula write setMatricula;
    property valor : double read getValor write setValor;
    property dtInicio : datetime read getDtInicio write setDtInicio;
    property codPapel : string read getCodPapel write setCodPapel;
    property codGratificacao : string read getCodGratificacao write setCodGratificacao;
    property dtFim : datetime read getDtFim write setDtFim;
    property vlantecipacao : double read getValorAntecip write setValorAntecip;
    property qtdRef : integer read getQtdRef write setQtdRef;
    {$ENDREGION}

    constructor ;
    function salvar(): integer; override;
    procedure buscarPorIdCCRespEMatricula (idCC:integer; matricula : string) ;
    procedure BuscarPorMatricula( mat : string );
    procedure BuscarPorMatriculaNoMes( mat, ano, mes : string );
    procedure Buscar(id_func_grat: integer);
    function calcularAjusteGratFunc(ano, mes: string; func:Tfuncionario; out qtd:double) : double;
    function calcularTotalGratFunc(ano, mes: string): double;
    function BuscarUltimoId(matricula:string):integer;
    function BuscarPorFiltros(id_cc_lot, id_cc, nome, matricula, cargo, lote, cod_grat, dt_inicio, dt_fim, ind_ativa, dt_termino_ini,dt_termino_fim, agrupamento, papel, sit_func, filtro : string ) : DataSet;

    function GerarGratFunc( ano,mes,matricula : string ) : double;
    function calcularTotalGratFuncBruto(ano, mes: string): double;
    class procedure CalcularAntecipacaoSalarial(ano,mes,categoria,lote, ult_matricula :string ) ;
    procedure CalcularAntecipacaoSalarialInstancia(ano,mes,categoria,lote, ult_matricula :string ) ;

    class procedure CalcularDissidio(ano,mes,perc,categoria,data :string);
    procedure CalcularDissidioInstancia(ano,mes,perc,categoria,data :string);
end;

implementation

uses System.Data, ShineOn.Rtl, ShineOn.Vcl, log4net, System.Collections, System.IO, SGU.DataAccess, System.Web;

{$REGION 'Construtor'}
 constructor TFuncGrat;
begin
  inherited;
  self.ftableName := 'RH.FUNC_GRAT';

end;
{$ENDREGION}

{$REGION 'Métodos de Acesso'}
function TFuncGrat.getIdFuncGrat : integer;
begin
  result := integer(getCampo('ID_FUNC_GRAT',TObject(TNulo.int)));
end;

procedure TFuncGrat.setIdFuncGrat (idF : integer);
begin
  setCampo('ID_FUNC_GRAT', TObject(TNulo.int), TObject(idF));
end;

function TFuncGrat.getQtdRef : integer;
begin
  result := integer(self.getCampo('QTD_REF', TObject(TNulo.int)));
end;

procedure TFuncGrat.setQtdRef(qtd : integer);
begin
  self.setCampo('QTD_REF', TObject(TNulo.int), TObject(qtd));
end;


function TFuncGrat.getCodPd : string;
begin
  result := string(getCampo('COD_PD',TObject(TNulo.str)));
end;

procedure TFuncGrat.setCodPd (cod : string);
begin
  setCampo('COD_PD', TObject(TNulo.str), TObject(cod));
end;
{
function TFuncGrat.getIdCliente  : integer;
begin
  result := integer(getCampo('ID_CLIENTE',TObject(TNulo.int)));
end;

procedure TFuncGrat.setIdCliente (idC : integer);
begin
  setCampo('ID_CLIENTE', TObject(TNulo.int), TObject(idC));
end;
}
function TFuncGrat.getMatricula : string;
begin
  result := string(getCampo('MATRICULA',TObject(TNulo.str)));
end;
 
procedure TFuncGrat.setMatricula (mat : string);
begin
  setCampo('MATRICULA', TObject(TNulo.str), TObject(mat));
end;

function TFuncGrat.getValor : double;
begin
  result := double(getCampo('VALOR',TObject(TNulo.dbl)));
end;

procedure TFuncGrat.setValor (val : double);
begin
  setCampo('VALOR', TObject(TNulo.dbl), TObject(val));
end;



function TFuncGrat.getDtInicio : datetime;
begin
  result := datetime(getCampo('DT_INICIO',TObject(TNulo.dth)));
end;

function TFuncGrat.getGratificacao: TGratificacao;
begin
  if self.gratificacao = nil then
  begin
    self.gratificacao := new  TGratificacao;
    self.gratificacao.buscar(self.codGratificacao);
  end
  else
  if self.gratificacao.codGratificacao <> self.codGratificacao then
  begin
     self.gratificacao.buscar(self.codGratificacao);
  end;
  result := self.gratificacao;
end;

function TFuncGrat.getPapelFuncional: TPapelFuncional;
begin
 if self.pfunc = nil then
  begin
    self.pfunc := new  TPapelFuncional;
    self.pfunc.buscar(self.codPapel);
  end
  else
  if self.pfunc.codPapel <> self.codPapel then
  begin
     self.pfunc.buscar(self.codPapel);
  end;

  result := self.pfunc;
end;

procedure TFuncGrat.setDtInicio (dtI : datetime);
begin
  setCampo('DT_INICIO', TObject(TNulo.dth), TObject(dtI));
end;

function TFuncGrat.getCodPapel : string;
begin
  result := string(getCampo('COD_PAPEL',TObject(TNulo.str)));
end;

procedure TFuncGrat.setCodPapel (cod : string);
begin
  setCampo('COD_PAPEL', TObject(TNulo.str), TObject(cod));
end;

function TFuncGrat.getCodGratificacao : string;
begin
  result := string(getCampo('COD_GRATIFICACAO',TObject(TNulo.str)));
end;

procedure TFuncGrat.setCodGratificacao (cod : string);
begin
  setCampo('COD_GRATIFICACAO', TObject(TNulo.str), TObject(cod));
end;

function TFuncGrat.getDtFim : datetime;
begin
  result := datetime(getCampo('DT_FIM',TObject(TNulo.dth)));
end;

procedure TFuncGrat.setDtFim (dtF : datetime);
begin
  setCampo('DT_FIM', TObject(TNulo.dth), TObject(dtF));
end;

function TFuncGrat.getValorAntecip : double;
begin
  result := double(getCampo('VL_ANTECIPACAO',TObject(TNulo.dbl)));
end;

procedure TFuncGrat.setValorAntecip (val : double);
begin
  setCampo('VL_ANTECIPACAO', TObject(TNulo.dbl), TObject(val));
end;

{$ENDREGION}

{$REGION 'Métodos de Recuperação de Dados'}

procedure TFuncGrat.Buscar(id_func_grat: integer);
begin
    defaultDataSet := getDAO.Buscar(id_func_grat);
end;

function TFuncGrat.BuscarPorFiltros(id_cc_lot,id_cc, nome, matricula, cargo, lote,
  cod_grat, dt_inicio, dt_fim, ind_ativa, dt_termino_ini,dt_termino_fim, agrupamento, papel,sit_func, filtro: string): DataSet;
begin
  result := getDAO.BuscarPorFiltros(id_cc_lot,id_cc, nome, matricula, cargo, lote, cod_grat, dt_inicio, dt_fim, ind_ativa, dt_termino_ini,dt_termino_fim, agrupamento, papel,sit_func, filtro);
end;

procedure TFuncGrat.BuscarPorMatricula(mat: string);
begin
  defaultDataSet := getDAO.BuscarPorMatricula(mat);
end;
procedure TFuncGrat.BuscarPorMatriculaNoMes( mat, ano, mes : string );
var
  dt_base : string;
begin
  dt_base := ano+'-'+mes+'-01';
  defaultDataSet := getDAO.BuscarPorMatriculaNoMes(mat,dt_base);
end;

function TFuncGrat.BuscarUltimoId(matricula:string): integer;
begin
  result := getDAO.BuscarUltimoId(matricula);
end;

{$ENDREGION}

{$REGION 'Métodos de Atualização'}
function TFuncGrat.salvar: integer;
begin
  result := getDAO.Atualizar(self.defaultDataSet);
end;
{$ENDREGION}

{$REGION 'Lógica de Negócio'}
function TFuncGrat.calcularAjusteGratFunc(ano, mes :string; func :TFuncionario; out qtd:double): double;
var
  vl_ajuste :double;
  mfolha : TMovFolhaTrab;
  
  i : Integer;
  tot_dias_ferias,
  tot_dias_sem_grat: Integer;
begin
  
  vl_ajuste := 0;
  

    if (copy(self.dtinicio.ToString('dd/MM/yyyy'),3,7) = mes + '/' + ano)
          and (dayof(self.dtinicio) > 1) then
    begin
      tot_dias_sem_grat := Dayof(self.dtinicio) - 1;
      
      
      //ver se tem ferias comecando após inicio da gratificacao...
      tot_dias_ferias := 0;
      if func.periodoFerias_ini.Count > 0 then
      begin
        for i:=0 to func.periodoFerias_ini.Count-1 do
        begin
          
          if DateTime(func.periodoFerias_ini[i] ) >= self.dtInicio then
            tot_dias_ferias := tot_dias_ferias +  DateTime( func.periodoFerias_fim[i] ).Subtract( DateTime(func.periodoFerias_ini[i]) ).days+1;

          if (DateTime(func.periodoFerias_fim[i] ) > self.dtInicio) and ( DateTime(func.periodoFerias_ini[i] ) < self.dtInicio  ) then
            tot_dias_ferias := tot_dias_ferias +  DateTime( func.periodoFerias_fim[i] ).Subtract(self.dtInicio ).days+1;
          
        end;
      end; 
    
      //se está acabando no mesmo mes, fazer o ajuste
      if (copy(self.dtfim.ToString('dd/MM/yyyy'),3,7) = mes + '/' + ano) and (dayof(self.dtfim) < 30) then
        tot_dias_sem_grat := tot_dias_sem_grat + (30 - dayof(self.dtfim) );

      vl_ajuste := (((self.valor + self.vlantecipacao) / 30) * (tot_dias_sem_grat + tot_dias_ferias));
      qtd := 30 - (tot_dias_sem_grat + tot_dias_ferias);

    end;

    
  
    if (self.dtfim <> Tnulo.dth) and (copy(self.dtinicio.ToString('dd/MM/yyyy'),3,7) <> mes + '/' + ano) then
       if (copy(self.dtfim.ToString('dd/MM/yyyy'),3,7) = mes + '/' + ano)
          and (dayof(self.dtfim) < 30) then
          begin

            tot_dias_sem_grat := (30 - Dayof(self.dtfim) );


            //ver se tem ferias terminando ANTES do término da gratificacao...
            tot_dias_ferias := 0;
            if func.periodoFerias_ini.Count > 0 then
            begin
              for i:=0 to func.periodoFerias_ini.Count-1 do
              begin
          
                if DateTime(func.periodoFerias_fim[i] ) <= self.dtFim then
                  tot_dias_ferias := tot_dias_ferias +  DateTime( func.periodoFerias_fim[i] ).Subtract(  DateTime(func.periodoFerias_ini[i]) ).days+1;

                if (DateTime(func.periodoFerias_fim[i] ) > self.dtFim) and (DateTime(func.periodoFerias_ini[i] ) < self.dtFim)  then
                  tot_dias_ferias := tot_dias_ferias +  self.dtFim.Subtract(  DateTime(func.periodoFerias_ini[i]) ).days+1;
          
              end;
            end;

            vl_ajuste := (((self.valor + self.vlantecipacao) / 30) * (tot_dias_sem_grat + tot_dias_ferias));
            qtd := 30 - (tot_dias_sem_grat + tot_dias_ferias);
          end;

        //gmoreira - 30/08/2020
        //se teve ferias no mes, é necessario ajustar tb.
        if vl_ajuste = 0 then
        begin
          tot_dias_ferias := 0;
          if func.periodoFerias_ini.Count > 0 then
          begin
            for i:=0 to func.periodoFerias_ini.Count-1 do
            begin
                tot_dias_ferias := tot_dias_ferias +  DateTime( func.periodoFerias_fim[i] ).Subtract(  DateTime(func.periodoFerias_ini[i]) ).days+1;
            end;
          end;

          vl_ajuste := (((self.valor + self.vlantecipacao) / 30) * (tot_dias_ferias));
          qtd := 30 - (tot_dias_ferias);
          end;
          
          
    result := vl_ajuste * -1;
end;

function TFuncGrat.calcularTotalGratFunc(ano, mes: string): double;
var
  tot_gratif:double;
  func : TFuncionario;
  qtdDias:Double;
begin
  tot_gratif := 0;

  func := new TFuncionario;
  func.Buscar(self.matricula);
  func.MontarPeriodosFerias(ano,mes);

  while not self.ehFim do
  begin
    tot_gratif := tot_gratif + self.valor + self.vlantecipacao + self.calcularAjusteGratFunc(ano, mes,func,qtdDias);
    self.proximo;
   end;
   result := tot_gratif;
end;

function TFuncGrat.calcularTotalGratFuncBruto(ano, mes: string): double;
var
  tot_gratif_bruto:double;
begin
  tot_gratif_bruto := 0;

  while not self.ehFim do
  begin
    tot_gratif_bruto := tot_gratif_bruto + self.valor + self.vlantecipacao;
    self.proximo;
  end;

  result := tot_gratif_bruto;
end;

function TFuncGrat.GerarGratFunc(ano,mes,matricula: string  ) : double;
var
vl_ajuste, tot_gratif : double;

begin
  self.BuscarPorMatricula(matricula);
  self.primeiro;
  tot_gratif := 0;
  while not self.ehFim do
  begin

    if (copy(self.dtinicio.ToString('dd/MM/yyyy'),3,7) = mes + '/' + ano)
          and (dayof(self.dtinicio) > 1) then
       vl_ajuste := ((self.valor/30) * (Dayof(self.dtinicio) - 1))  - self.valor
    else
       vl_ajuste := 0;

    TMovFolhaTrab.GerarPD(ano,mes,matricula,'PFX004','','',math.Round(self.valor,2),0);

    if  vl_ajuste < 0 then
       TMovFolhaTrab.GerarPD(ano,mes,matricula,'PEV004-','','',math.Round(vl_ajuste,2),0);

    tot_gratif := tot_gratif + valor + vl_ajuste;
    self.proximo;
   end;
   result := tot_gratif;
end;

class procedure TFuncGrat.CalcularAntecipacaoSalarial(ano,mes,categoria,lote, ult_matricula :string ) ;
var
  funcGrat : TFuncGrat;
begin
  funcGrat := new  TFuncGrat;
  funcGrat.CalcularAntecipacaoSalarialInstancia(ano,mes,categoria,lote, ult_matricula) ;
end;

procedure TFuncGrat.CalcularAntecipacaoSalarialInstancia(ano, mes, categoria,
  lote, ult_matricula: string);
begin
  getDAO.CalcularAntecipacaoSalarial(ano,mes,categoria,lote, ult_matricula) ;
end;

class procedure TFuncGrat.CalcularDissidio(ano,mes,perc,categoria,data :string);
var
  funcGrat : TFuncGrat;
begin
  funcGrat := new  TFuncGrat;
  funcGrat.CalcularDissidioInstancia(ano, mes, perc, categoria, data);
end;

procedure TFuncGrat.CalcularDissidioInstancia(ano, mes, perc, categoria,data: string);
begin
  getDAO.CalcularDissidio(ano,mes, categoria);
  getDAO.GravarHistoricoDissidioGratif(ano,mes, perc, categoria, data );
end;

{$ENDREGION}

{$REGION 'Metodos Privados'}
function TFuncGrat.getDAO : TDAFuncGrat;
begin
  result := TDAFuncGrat(self.daoObject);
end;
{$ENDREGION}
 procedure TFuncGrat.buscarPorIdCCRespEMatricula (idCC:integer; matricula : string) ;
begin
    //bacalhau para a CCPG
  if idCC = TCentroCusto.ccCCPG then
    idCC :=  TCentroCusto.ccCCG;

  //bacalhau da VRDesenv
  if idCC = TCentroCusto.ccVRDesenv then
    idCC :=  TCentroCusto.ccVRAC;

   self.defaultDataSet := getDAO.buscarPorIdCCRespEMatricula (idCC, matricula ) 
end;

end.
