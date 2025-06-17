namespace Demo;

type
  AsCastCall = public class
  public
    method Update(adapter: Object; ds: Object; name: String);
  end;

implementation

method AsCastCall.Update(adapter: Object; ds: Object; name: String);
begin
  (adapter as DB2DataAdapter).Update(ds, name);
end;

end.
