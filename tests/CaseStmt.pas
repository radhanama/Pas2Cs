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
    1: exit;
    2: exit;
  end;
end;

end.
