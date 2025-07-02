namespace Demo;

type
  ExprInlineComment = public class
  public
    class method Demo(x, y: Integer);
  end;

implementation

class method ExprInlineComment.Demo(x, y: Integer);
begin
  if (x > 0) and { skip check } (y > 0) then
    System.Console.WriteLine('ok');
end;

end.
