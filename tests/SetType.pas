namespace Demo;

type
  TestSet = public class
  public
    method Example;
  end;

implementation

method TestSet.Example;
var
  s: set of Integer;
  x: Integer;
begin
  s := [1, 2];
  x := 0;
end;

end.
