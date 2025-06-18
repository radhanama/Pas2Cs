namespace Demo;

type
  ArrayCast = class
  public
    class method Create;
  end;

implementation

class method ArrayCast.Create;
var
  arr: array of Integer;
begin
  arr := array of Integer([1, 2, 3]);
end;

end.
