namespace Demo;

interface

uses System.Threading.Tasks, System.Threading;

type
  TaskExample = public class
  public
    class method Run;
  end;

implementation

class method TaskExample.Run;
begin
  Task.Factory.StartNew(procedure(); begin
    Thread.Sleep(3000);
  end);
end;

end.
