namespace N;

interface

uses System;

type
  TTest = public class
  public
    method Foo(x: Integer);
    method Empty(x: Integer);
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

method TTest.Empty(x: Integer);
begin
  case x of
    1: Console.WriteLine('one');
  else;
  end;
end;

end.
