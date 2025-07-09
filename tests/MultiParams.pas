namespace Demo;

type
  MultiParams = public class
  public
    procedure ShowSum(a,b,c: Integer; prefix: String);
  end;

implementation

procedure MultiParams.ShowSum(a,b,c: Integer; prefix: String);
var sum: Integer;
begin
  sum := a + b + c;
  System.Console.WriteLine(prefix + sum);
end;

