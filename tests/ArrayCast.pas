namespace Demo;

type
  ArrayCast = class
  public
    class method Create;
    class method Len: Integer;
  end;

implementation

class method ArrayCast.Create;
var
  arr: array of Integer;
begin
  arr := array of Integer([1, 2, 3]);
end;

class method ArrayCast.Len: Integer;
begin
  result := array of Byte([1, 2, 3]).Length;
end;

end.
