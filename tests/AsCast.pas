namespace Demo;

type
  AsExample = public class
  public
    method CastIt(v: Object): String;
  end;

implementation

method AsExample.CastIt(v: Object): String;
var
  s: String;
begin
  s := v as String;
  result := s;
end;

end.
