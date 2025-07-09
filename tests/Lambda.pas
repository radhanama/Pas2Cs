namespace Demo;

type
  LambdaClass = public class
  public
    method Run: Boolean;
  end;

implementation

method LambdaClass.Run: Boolean;
begin
  var predicate := (i: Integer) -> i > 0;
  var eq := (a, b) -> a = b;
  exit predicate(5) and eq(5, 5);
end;

end.
