namespace Demo;

type
  WithExample = public class
  public
    method Test(p: Person);
  end;

implementation

method WithExample.Test(p: Person);
begin
  with p do
    Console.WriteLine(Name);
end;

end.
