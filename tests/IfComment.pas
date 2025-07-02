namespace Demo;

type
  IfComment = public class
  public
    class method Demo(x: Integer);
  end;

implementation

class method IfComment.Demo(x: Integer);
begin
  if (x = 1) or (x = 2) { or (x = 3) or (x = 4)} then
    System.Console.WriteLine('Yes');
end;

end.
