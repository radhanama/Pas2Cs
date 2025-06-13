namespace Demo;

type
  CtorNoName = public class
  public
    constructor;
    constructor(flag: Boolean);
    destructor;
  end;

implementation

constructor CtorNoName.Create;
begin
  inherited;
end;

constructor CtorNoName.Create(flag: Boolean);
begin
  inherited;
end;

destructor CtorNoName.Destroy;
begin
  inherited;
end;
