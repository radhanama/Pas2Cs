namespace Demo;

type
  TypedForEach = class
  public
    class method Sum(arr: array of Integer): Integer;
  end;

implementation

class method TypedForEach.Sum(arr: array of Integer): Integer;
var
  total: Integer;
begin
  total := 0;
  for each item: Integer in arr do
    total := total + item;
  result := total;
end;

end.
