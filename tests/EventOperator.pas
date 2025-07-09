namespace Demo;

interface

uses System;

type
  [Obsolete]
  MyClass = public class
  public
    event OnSomething: EventHandler;
    operator Add(a, b: Integer): Integer;
  end;

implementation

operator MyClass.Add(a, b: Integer): Integer;
begin
  result := a + b;
end;

end.
