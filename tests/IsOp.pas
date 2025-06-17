namespace Demo;

type
  IsExample = class
  public
    class method Check(o: Object);
  end;

implementation

class method IsExample.Check(o: Object);
begin
  if o is String then
    o := nil;
end;

end.
