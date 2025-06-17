namespace Demo;

type
  StepExample = public class
  public
    class method Sum(): Integer;
  end;

implementation

class method StepExample.Sum(): Integer;
var
  i: Integer;
  total: Integer;
begin
  total := 0;
  for i := 1 to 5 step 2 do
    total := total + i;
  result := total;
end;

end.
