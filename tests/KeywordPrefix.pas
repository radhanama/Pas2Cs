namespace Demo;

type
  KeywordPrefix = public class
  public
    method Demo;
  end;

implementation

method KeywordPrefix.Demo;
var
  origVal, curVal: String;
begin
  origVal := 'a';
  curVal := origVal;
end;

end.
