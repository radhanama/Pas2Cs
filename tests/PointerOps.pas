namespace Demo;

type
  PointerOps = public class
  public
    method Demo;
  end;

implementation

method PointerOps.Demo;
var
  x: Integer;
  p: ^Integer;
  y: Integer;
begin
  x := 5;
  p := @x;
  y := p^;
end;

end.
