namespace Demo;

type
  WhileDemo = public class
  public
    class method Test(arr: Array of Integer);
  end;

implementation

class method WhileDemo.Test(arr: Array of Integer);
var
  i: Integer := 0;
begin
  while (i <= 2) do
    i := i + arr[0];
end;

end.
