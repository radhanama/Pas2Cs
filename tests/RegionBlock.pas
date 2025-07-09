namespace Demo;

interface

type
  Foo = class
  public
    method A();
    method B();
  end;

implementation

{$REGION 'Impl'}
method Foo.A;
begin
end;

method Foo.B;
begin
end;
{$ENDREGION}

end.
