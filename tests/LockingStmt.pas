namespace Demo;

type
  LockingExample = public class
  public
    class method Run(obj: Object);
  end;

implementation

class method LockingExample.Run(obj: Object);
begin
  locking obj do
    Console.WriteLine('locked');
end;

end.
