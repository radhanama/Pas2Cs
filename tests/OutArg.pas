namespace Demo;

interface

uses System;

type
  SguUtils = public class
  public
    class function UltimoDiaMes(mes, ano: Integer): DateTime;
  end;

implementation

class function SguUtils.UltimoDiaMes(mes, ano: Integer): DateTime;
var
  d: TDateTime;
begin
  if mes = 2 then
  begin
    if not TryEncodeDate(ano, mes, 29, out d) then
      TryEncodeDate(ano, mes, 28, out d);
    result := d;
  end
  else
  if (mes = 1) or (mes = 3) or (mes = 5) or (mes = 7) or (mes = 8)
    or (mes = 10) or (mes = 12) then
  begin
    TryEncodeDate(ano, mes, 31, out d);
    result := d;
  end
  else
  begin
    TryEncodeDate(ano, mes, 30, out d);
    result := d;
  end;
end;

end.
