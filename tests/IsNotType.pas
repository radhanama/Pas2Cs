namespace Demo;

type
  IsNotExample = class
  public
    method Check(o: Object);
  end;

implementation

method IsNotExample.Check(o: Object);
begin
  if o is not String then
    Console.WriteLine('not string');
end;

end.
