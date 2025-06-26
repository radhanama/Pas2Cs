namespace N;

type
  TRange = public class
  public
    method Foo(x: Integer);
  end;

implementation

method TRange.Foo(x: Integer);
begin
  case x of
    1..1005: System.Console.WriteLine('range');
    2000: System.Console.WriteLine('other');
  end;
end;

end.
