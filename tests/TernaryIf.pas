namespace Demo;

type
  Utils = class
  public
    method Pick(a, b: Integer): Integer;
  end;

implementation

method Utils.Pick(a, b: Integer): Integer;
begin
  var res := if a > b then a else b;
  result := res;
end;

end.
