namespace Demo;

type
  BreakExample = public class
  public
    class method DoBreak(arr: array of Integer);
  end;

implementation

class method BreakExample.DoBreak(arr: array of Integer);
var
  i: Integer;
begin
  for i := 0 to arr.Length - 1 do
  begin
    if arr[i] = 0 then break;
    if arr[i] < 0 then continue;
  end;
end;

end.
