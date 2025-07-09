namespace Demo;

type
  HourCheck = public class
  public
    class method ValidarHora(hora: Integer): Integer;
  end;

implementation

class method HourCheck.ValidarHora(hora: Integer): Integer;
begin
  if hora < 0 or hora > 23 then
  begin
    result := -1;
    exit;
  end;
  result := hora;
end;

end.
