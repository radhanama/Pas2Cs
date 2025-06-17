namespace Demo;

type
  UsingExample = public class
  public
    class method DoStuff;
  end;

implementation

class method UsingExample.DoStuff;
begin
  using res := GetRes() do
    Console.WriteLine(res);
end;

end.
