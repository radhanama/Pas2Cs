namespace Demo;

type
  Utils = public class
  public
    class method Check(x: Integer; y: Integer);
  end;

implementation

class method Utils.Check(x: Integer; y: Integer);
begin
  if (x mod y) <> 0 then
    x := x mod y;
end;

end.
