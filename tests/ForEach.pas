namespace Demo;

type
  ForEachExample = public class
  public
    class method Sum(arr: array of Integer): Integer;
  end;

implementation

class method ForEachExample.Sum(arr: array of Integer): Integer;
var
  total: Integer;
begin
  total := 0;
  for each item in arr do
    total := total + item;
  result := total;
end;

end.
