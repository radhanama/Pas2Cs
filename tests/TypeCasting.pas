namespace Demo;

type
  AsExample = public class
  public
    method CastIt(v: Object): String;
  end;

  AsCastCall = public class
  public
    method Update(adapter: Object; ds: Object; name: String);
    method SetText(ctrl: Object; valor: String);
  end;

  IsExample = class
  public
    class method Check(o: Object);
  end;

implementation

method AsExample.CastIt(v: Object): String;
var
  s: String;
begin
  s := v as String;
  result := s;
end;

method AsCastCall.Update(adapter: Object; ds: Object; name: String);
begin
  (adapter as DB2DataAdapter).Update(ds, name);
end;

method AsCastCall.SetText(ctrl: Object; valor: String);
begin
  (ctrl as TextBox).Text := valor;
end;

class method IsExample.Check(o: Object);
begin
  if o is String then
    o := nil;
end;

end.
