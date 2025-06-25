namespace Demo;

type
  Utils = class
  public
    method Shifts(maskBits: Integer): Integer;
  end;

implementation

method Utils.Shifts(maskBits: Integer): Integer;
begin
  var shifted := 1 shl maskBits;
  var maskByte := 255 shr maskBits;
  result := shifted + maskByte;
end;

end.
