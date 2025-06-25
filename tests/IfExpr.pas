namespace Demo;

type
  Ternary = class
  public
    class method Select(flag: Boolean): Integer;
  end;

implementation

class method Ternary.Select(flag: Boolean): Integer;
var
  val: Integer;
begin
  val := if flag then 1 else 0;
  result := val;
end;

end.
