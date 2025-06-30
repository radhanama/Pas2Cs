namespace Demo;

interface

uses System;

type
  IfElseEmptyExample = public class
  public
    class method Check(flag: Boolean);
  end;

implementation

class method IfElseEmptyExample.Check(flag: Boolean);
begin
  if flag then
    Console.WriteLine('yes')
  else
    // nothing
end;

end.
