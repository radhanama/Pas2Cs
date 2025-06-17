namespace Demo;

type
  RepeatExample = public class
  public
    class method LoopIt();
  end;

implementation

class method RepeatExample.LoopIt();
var
  i: Integer;
begin
  i := 0;
  repeat
    i := i + 1;
  until i > 3;
end;

end.
