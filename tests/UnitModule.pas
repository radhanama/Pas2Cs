unit Demo;

interface

type
  Example = class
  public
    procedure SayHi;
  end;

implementation

procedure Example.SayHi;
begin
  System.Console.WriteLine('Hi');
end;

end.
