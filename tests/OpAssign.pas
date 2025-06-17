namespace Demo;

type
  OpAssign = public class
  public
    method Example;
  end;

implementation

method OpAssign.Example;
var
  x: Integer;
begin
  x := 5;
  x += 2;
  x -= 1;
end;

end.
