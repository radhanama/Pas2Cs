namespace Demo;

type
  LoopExample = public class
  public
    class method CountThree();
  end;

implementation

class method LoopExample.CountThree();
var
  i: Integer;
begin
  i := 0;
  loop
  begin
    i := i + 1;
    if i = 3 then break;
  end;
end;

end.
