namespace Demo;

type
  ExprComment = public class
  public
    class method Check(flag1: Boolean; flag2: Boolean);
  end;

implementation

class method ExprComment.Check(flag1: Boolean; flag2: Boolean);
begin
  if flag1 or { comment } flag2 then
    System.Console.WriteLine('y');
end;

end.
