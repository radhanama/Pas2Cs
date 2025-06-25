namespace Demo;

type
  ShiftOps = public class
  public
    class method Demo(): Integer;
  end;

implementation

class method ShiftOps.Demo(): Integer;
var x: Integer;
begin
  x := 1 shl 2;
  x := x shr 1;
  x := x xor 3;
  exit x;
end;

end.
