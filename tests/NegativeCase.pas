namespace N;

type
  TTest = public class
  public
    method Foo(x: Integer);
  end;

implementation

method TTest.Foo(x: Integer);
begin
  case x of
    -1: Console.WriteLine('neg one');
    -2: Console.WriteLine('neg two');
  end;
end;

end.
