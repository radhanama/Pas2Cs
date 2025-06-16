namespace Demo;

type
  ForDownToDemo = public class
  public
    class method Test();
  end;

implementation

class method ForDownToDemo.Test();
begin
  for i := 3 downto 1 do
    System.Console.WriteLine(i);
end;

end.
