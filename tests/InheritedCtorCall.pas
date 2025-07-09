namespace Demo;

type
  Base = public class
  public
    constructor;
  end;

  Derived = public class(Base)
  public
    constructor;
  end;

implementation

constructor Base.Create;
begin
end;

constructor Derived.Create;
begin
  inherited constructor;
end;

end.
