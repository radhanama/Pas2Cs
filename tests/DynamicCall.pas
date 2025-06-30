namespace Demo;

type
  DynamicCall = public class
  public
    method Test(o: Object);
  end;

implementation

method DynamicCall.Test(o: Object);
begin
  var texto := o:ToString();
end;

end.
