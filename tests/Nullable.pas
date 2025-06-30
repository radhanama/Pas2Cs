namespace Demo;

type
  NullableTest = public class
  public
    method Accept(val: Integer?);
    method AcceptDate(dt: nullable DateTime);
  end;

implementation

method NullableTest.Accept(val: Integer?);
begin
end;

method NullableTest.AcceptDate(dt: nullable DateTime);
begin
end;

end.
