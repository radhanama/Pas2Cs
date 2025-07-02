namespace Demo;

interface

uses System;

type
  IfLeadingComment = class
  public
    class method Check(flag: Boolean);
  end;

implementation

class method IfLeadingComment.Check(flag: Boolean);
begin
  if { first line
       second line } flag then
    Console.WriteLine('a');
end;

end.
