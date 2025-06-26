namespace Demo;

type
  Foo = public class
  end;

  BeginSemi = class
  public
    class method Foo;
  end;

implementation

class method BeginSemi.Foo;
begin;
  System.Console.WriteLine('Hello');
end;

End;
