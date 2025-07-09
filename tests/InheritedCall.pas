namespace Demo;

type
  Base = public class
  public
    method Foo(a: Integer): Integer; virtual;
  end;

  Derived = public class(Base)
  public
    method Foo(a: Integer): Integer; override;
  end;

implementation

method Base.Foo(a: Integer): Integer;
begin
  result := a;
end;

method Derived.Foo(a: Integer): Integer;
var request := inherited Foo(a);
begin
  result := request;
end;

end.
