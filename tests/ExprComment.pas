namespace Demo;

type
  ExprComment = public class
  public
    class method Check(flag1: Boolean; flag2: Boolean);
    class method CheckStart(flag1: Integer; flag2: Integer);
    class method SumWithLineComment(v1, v2, v3, v4: Double): Double;
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

class method ExprComment.SumWithLineComment(v1, v2, v3, v4: Double): Double;
begin
  result := Math.Round(v1 + v2, 2)
    // extra
    + Math.Round(v3, 2)
    + Math.Round(v4, 2);
end;

end.
