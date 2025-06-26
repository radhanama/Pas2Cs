namespace Demo;

interface

uses System;

type
  TryExceptEmptySemiExample = public class
  public
    class method DoNothing();
  end;

implementation

class method TryExceptEmptySemiExample.DoNothing();
begin
  try
    Console.WriteLine('A');
  except;
  end;
end;

end.
