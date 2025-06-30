namespace Demo;

type
  MultiVars = public class
  public
    class method Demo();
    class method SplitDecl();
  end;

implementation

class method MultiVars.Demo();
var
  ano_aux, mes_aux, dt_aux: String;
begin
  ano_aux := '2024';
  mes_aux := '12';
  dt_aux := ano_aux + mes_aux;
  System.Console.WriteLine(dt_aux);
end;

class method MultiVars.SplitDecl();
var  s105_deposito_FGTS  : String;
     s106_base_calc_FGTS   : String; // comment on same line
     s107_total_proventos: String;
begin
  System.Console.WriteLine(s107_total_proventos);
end;

