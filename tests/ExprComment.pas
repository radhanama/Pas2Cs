namespace Demo;

type
  ExprComment = public class
  public
    class method Check(flag1: Boolean; flag2: Boolean);
    class method CheckStart(flag1: Integer; flag2: Integer);
  end;

implementation

class method ExprComment.Check(flag1: Boolean; flag2: Boolean);
begin
  if flag1 or { comment } flag2 then
    System.Console.WriteLine('y');
end;

class method ExprComment.CheckStart(flag1: Integer; flag2: Integer);
begin
  if ({(flag1 = 1) or} (flag2 = 2)) then
    System.Console.WriteLine('z');
end;

end.
