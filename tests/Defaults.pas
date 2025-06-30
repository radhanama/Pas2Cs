namespace Demo;

type
  Defaults = public class
  public
    procedure Test(var a: Integer; b: Integer := 1);
    procedure TestEq(a: String = '');
  end;

implementation

procedure Defaults.Test(var a: Integer; b: Integer := 1);
begin
  inherited;
end;

procedure Defaults.TestEq(a: String = '');
begin
  inherited;
end;
