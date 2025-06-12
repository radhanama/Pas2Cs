namespace Example;

type
  GenExample = public class
  public
    method UseList(l: List<String>);
  end;

implementation

method GenExample.UseList(l: List<String>);
var
  v: List<Integer>;
begin
  v := new List<Integer>;
  l.AddRange(v);
end;

end.
