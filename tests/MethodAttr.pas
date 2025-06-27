namespace Demo;

type
  AttrSample = public class
  public
    class method Foo: Integer; static;
    [Obsolete]
    class method Bar(x: Integer): Integer; static;
  end;

implementation

class method AttrSample.Foo: Integer;
begin
  Result := 0;
end;

class method AttrSample.Bar(x: Integer): Integer;
begin
  Result := x;
end;
