namespace N;

interface

type
  TTest = public class
  public
    method Foo(val: String): String;
  end;

implementation

method TTest.Foo(val: String): String;
begin
  Case val of
    'S': result := 'one';
    'B': result := 'two';
  end;
end;

end.
