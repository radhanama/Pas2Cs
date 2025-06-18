namespace Demo;

interface

uses System;

type
  TryExceptEmptyExample = public class
  public
    class method DoNothing();
  end;

implementation

class method TryExceptEmptyExample.DoNothing();
begin
  try
    Console.WriteLine('A');
  except
  end;
end;

end.
