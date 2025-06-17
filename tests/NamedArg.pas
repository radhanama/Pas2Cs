namespace Demo;

interface

uses System;

type
  NamedArg = public class
  public
    procedure UseArgs;
  end;

implementation

procedure NamedArg.UseArgs;
begin
  Console.WriteLine(value := 123, message := 'ok');
end;

end.
