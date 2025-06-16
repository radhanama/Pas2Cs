namespace Demo;

type
  LongIf = public class
  public
    class method Check(a, b, c, d, e, x, y: Boolean);
  end;

implementation

class method LongIf.Check(a, b, c, d, e, x, y: Boolean);
begin
  if (a and b and c and d and e) or (x and y) then
    Console.WriteLine('ok');
end;

end.
