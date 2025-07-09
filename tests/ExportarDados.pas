namespace Demo;

interface

type
  ExportarDados = public class
  public
    procedure DoSomething(value: Integer);
  end;

implementation

procedure ExportarDados.DoSomething(value: Integer);
begin
  System.Console.WriteLine('Export');
end;

end.
