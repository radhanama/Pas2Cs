namespace Demo;

interface

type
  Example = public class
  public
    procedure DoStuff(value: Integer);
    function Multiply(a: Integer; b: Integer): Integer;
  end;

implementation

procedure Example.DoStuff(value: Integer);
begin
  System.Console.WriteLine('Hi');
end;

function Example.Multiply(a: Integer; b: Integer): Integer;
begin
  result := a * b;
end;
