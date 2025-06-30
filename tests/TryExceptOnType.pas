namespace Demo;

interface

uses System;

type
  TryExceptOnType = public class
  public
    class method DoStuff();
  end;

implementation

class method TryExceptOnType.DoStuff();
begin
  try
    Console.WriteLine('A');
  except
    on Exception do
      Console.WriteLine('Error');
  end;
end;

end.
