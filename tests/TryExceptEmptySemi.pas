namespace Demo;

interface

uses System;

type
  TryExceptEmptySemiExample = public class
  public
    class method DoNothing();
    class method DoCatch();
  end;

implementation

class method TryExceptEmptySemiExample.DoNothing();
begin
  try
    Console.WriteLine('A');
  except;
  end;
end;

class method TryExceptEmptySemiExample.DoCatch();
begin
  try
    Console.WriteLine('A');
  except;
    Console.WriteLine('B');
  end;
end;

end.
