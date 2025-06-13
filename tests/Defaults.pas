namespace Demo;

type
  Defaults = public class
  public
    procedure Test(var a: Integer; b: Integer := 1);
  end;

implementation

procedure Defaults.Test(var a: Integer; b: Integer := 1);
begin
  inherited;
end;
