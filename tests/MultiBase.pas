namespace Demo;

type
  BaseCls = public class
  public
    method BaseMethod;
  end;

  Child = public class(BaseCls, IFoo, IBar)
  public
    method BaseMethod;
    method Foo;
    method Bar;
  end;

implementation

method BaseCls.BaseMethod;
begin
end;

method Child.BaseMethod;
begin
end;

method Child.Foo;
begin
end;

method Child.Bar;
begin
end;

end.
