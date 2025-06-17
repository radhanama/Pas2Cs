namespace Demo;

type
  OverloadAttr = public class
  public
    method Foo(a: Integer); overload;
    method Foo(a: Integer; b: Integer); overload;
  end;

implementation

method OverloadAttr.Foo(a: Integer);
begin
end;

method OverloadAttr.Foo(a: Integer; b: Integer);
begin
end;

end.
