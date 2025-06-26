namespace N;

interface

uses System;

type
  TTest = public class
  public
    method Foo(x: Integer);
  end;

implementation

method TTest.Foo(x: Integer);
begin
  case x of
    1: Console.WriteLine('one');
  else
    Console.WriteLine('other');
  end;
end;

end.
