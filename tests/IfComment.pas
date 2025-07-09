namespace Demo;

interface

uses System;

type
  IfComment = class
  public
    class method Check(flag: Boolean);
  end;

implementation

class method IfComment.Check(flag: Boolean);
begin
  if flag then
  begin
    Console.WriteLine('y');
  end {comment}
  else
  begin
    Console.WriteLine('n');
  end;
end;

end.
