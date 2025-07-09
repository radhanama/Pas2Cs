namespace Demo;

type
  NumberLiterals = public class
  public
    const HexVal: Integer = $1A;
    const BinVal: Integer = %1011;
    function Value: Integer;
  end;

implementation

function NumberLiterals.Value: Integer;
begin
  result := HexVal + BinVal;
end;

end.
