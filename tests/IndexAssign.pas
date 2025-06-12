namespace Demo;

type
  IndexAssign = public class
  public
    function Foo(ds: DataSet): Integer;
  end;

implementation

function IndexAssign.Foo(ds: DataSet): Integer;
var
  columns: array[0..2] of DataColumn;
begin
  columns[0] := ds.Tables['RH.HIST_FOLHA'].Columns['ANO'];
  result := 0;
end;

