namespace Demo;

type
  SingleStmt = public class
  public
    class method TestIf(x: Integer);
    class method TestFor();
  end;

implementation

class method SingleStmt.TestIf(x: Integer);
begin
  if x = 5 then
    System.Console.WriteLine('Hi');
end;

class method SingleStmt.TestFor();
begin
  for i := 1 to 3 do
    System.Console.WriteLine(i);
end;
