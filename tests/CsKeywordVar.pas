namespace Demo;

type
  CsKeywordVar = public class
  public
    method Demo;
  end;

implementation

method CsKeywordVar.Demo;
var
  lock: Integer;
  base: Integer;
begin
  lock := 1;
  base := lock;
end;

end.
