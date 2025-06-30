namespace Demo;

interface

uses System;

type
  TryExceptOnEmpty = public class
  public
    class method DoStuff();
    class method DoNothingNoSemi();
  end;

implementation

class method TryExceptOnEmpty.DoStuff();
begin
  try
    Console.WriteLine('A');
  except
    on E: Exception do;
  end;
end;

class method TryExceptOnEmpty.DoNothingNoSemi();
begin
  try
    Console.WriteLine('B');
  except
    on E: Exception do
  end;
end;

end.

