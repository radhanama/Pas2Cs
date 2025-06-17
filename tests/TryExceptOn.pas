namespace Demo;

interface

uses System;

type
  TryExceptExample = public class
  public
    class method DoStuff();
  end;

implementation

class method TryExceptExample.DoStuff();
begin
  try
    Console.WriteLine('A');
  except
    on E: Exception do
      Console.WriteLine(E.Message);
  end;
end;

end.
