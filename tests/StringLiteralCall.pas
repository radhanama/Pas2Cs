namespace Demo;

type
  StringLiteralCall = class
  public
    method Demo(): Boolean;
  end;

implementation

method StringLiteralCall.Demo(): Boolean;
begin
  result := 'abc'.ToUpper() = 'ABC';
end;

end.
