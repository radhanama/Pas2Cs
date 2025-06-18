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
  exit predicate(5);
end;

end.
