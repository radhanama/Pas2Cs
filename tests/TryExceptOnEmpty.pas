namespace Demo;

interface

uses System;

type
  TryExceptOnEmpty = public class
  public
    class method DoStuff();
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

end.
