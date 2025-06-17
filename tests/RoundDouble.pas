namespace Demo;

type
  RoundDouble = public class
  public
    class method Adjust(qt_quebra: Integer);
  end;

implementation

class method RoundDouble.Adjust(qt_quebra: Integer);
begin
  if qt_quebra > 10 then
    qt_quebra := Round(double(qt_quebra / 3))-1;
end;

end.
