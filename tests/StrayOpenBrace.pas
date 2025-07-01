namespace Demo;

type
  StrayOpenBrace = public class
  public
    class method Demo();
  end;

implementation

class method StrayOpenBrace.Demo();
begin
  {
  System.Console.WriteLine('hi');
  System.Console.WriteLine('there');
  // missing closing brace
end;

end.
