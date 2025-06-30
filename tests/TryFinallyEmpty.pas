namespace Demo;

interface

uses System;

type
  TryFinallyEmptyExample = public class
  public
    class method DoNothing();
  end;

implementation

class method TryFinallyEmptyExample.DoNothing();
begin
  try
    Console.WriteLine('A');
  finally
  end;
end;

end.
