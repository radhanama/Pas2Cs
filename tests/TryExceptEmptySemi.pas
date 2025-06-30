namespace Demo;

interface

uses System;

type
  TryExceptEmptySemiExample = public class
  public
    class method DoNothing();
    class method DoHandle();
  end;

implementation

class method TryExceptEmptySemiExample.DoNothing();
begin
  try
    Console.WriteLine('A');
  except;
  end;
end;

class method TryExceptEmptySemiExample.DoHandle();
begin
  try
    Console.WriteLine('B');
  except;
    Console.WriteLine('Error');
  end;
end;

end.
