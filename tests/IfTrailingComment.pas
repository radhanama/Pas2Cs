namespace Demo;

interface

uses System;

type
  IfTrailingComment = class
  public
    class method Check(flag: Boolean);
  end;

implementation

class method IfTrailingComment.Check(flag: Boolean);
begin
  if flag then
    Console.WriteLine('a') // comment
  else
    Console.WriteLine('b');
end;

end.
