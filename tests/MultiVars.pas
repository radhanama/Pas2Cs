namespace Demo;

type
  MultiVars = public class
  public
    class method Demo();
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

