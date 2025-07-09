namespace Demo;

interface

uses System;

type
  ExprComment = class
  public
    class method Check(cc: Integer);
    class method CheckMulti(flag1, flag2, flag3: Integer);
    class method CheckLine(flag1, flag2: Boolean);
  end;

implementation

class method ExprComment.Check(cc: Integer);
begin
  if (cc = 1) { or cc = 2 } then
    Console.WriteLine('y');
end;

class method ExprComment.CheckMulti(flag1, flag2, flag3: Integer);
begin
  if (flag1 = 1) or (flag2 = 2) or (flag3 = 3) { or (flag3 = 4) } then
    Console.WriteLine('z');
end;

class method ExprComment.CheckLine(flag1, flag2: Boolean);
begin
  if (flag1) // comment
    or (flag2) then
    Console.WriteLine('x');
end;

end.
