namespace Demo;

type
  ShortCircuit = public class
  public
    method Check(a: Boolean; b: Boolean);
  end;

implementation

method ShortCircuit.Check(a: Boolean; b: Boolean);
begin
  if a or else b then
    Console.WriteLine('yes');
  if a and then b then
    Console.WriteLine('and');
end;

end.
