namespace Demo;

type
  ArrayVar = public class
  public
    function Foo(ds: DataSet): Integer;
  end;

implementation

function ArrayVar.Foo(ds: DataSet): Integer;
var
  columns: array[0..2] of DataColumn;
begin
  result := 0;
end;

