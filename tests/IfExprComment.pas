namespace Demo;

interface

uses System;

type
  ExprComment = class
  public
    class method Check(cc: Integer);
  end;

implementation

class method ExprComment.Check(cc: Integer);
begin
  if (cc = 1) { or cc = 2 } then
    Console.WriteLine('y');
end;

end.
