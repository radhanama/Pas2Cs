namespace Demo;

type
  Sample = public class
  public
    count: Integer;
    property Name: String read get_Name write set_Name;
    const DefaultCount : Integer = 10;
    constructor Create;
    destructor Destroy;
  end;

implementation

constructor Sample.Create;
begin
  inherited;
end;

destructor Sample.Destroy;
begin
  inherited;
end;
