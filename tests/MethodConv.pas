namespace Demo;

type
  Conventions = public class
  public
    function Foo(a: Integer): Integer; cdecl; deprecated;
    procedure Bar; stdcall; platform;
  end;

implementation

function Conventions.Foo(a: Integer): Integer;
begin
  result := a;
end;

procedure Conventions.Bar;
begin
end;

end.
