namespace Demo;

type
  PasKeywordVar = public class
  public
    method Demo;
  end;

implementation

method PasKeywordVar.Demo;
var
  enum: Integer;
  interface: Integer;
begin
  enum := 1;
  interface := enum;
end;

end.
