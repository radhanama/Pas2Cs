namespace Demo;

type
  TypedForLoop = class
  public
    class method Sum(arr: array of Integer): Integer;
  end;

implementation

class method TypedForLoop.Sum(arr: array of Integer): Integer;
var
  total: Integer;
begin
  total := 0;
  for i: Integer := 0 to length(arr) - 1 do
    total := total + arr[i];
  result := total;
end;

end.
