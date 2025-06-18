namespace Demo;

type
  OutArg = public class
  public
    method DoStuff;
  end;

implementation

method OutArg.DoStuff;
var
  d: Integer;
  ok: Boolean;
  frowInd: Integer;
begin
  if not TryEncodeDate(1, 1, 29, out d) then
    TryEncodeDate(1, 1, 28, out d);
  if ( self.ehVazio ) or
     ( frowInd > self.indUltimaPos ) or
     ( frowInd = -1 ) then
    ok := true
  else
    ok := false;
  UseValue(var d);
end;

end.
