namespace Demo;

interface

type
  Foo = class
  public
    method Test;
  end;

implementation

method Foo.Test;
begin
  {$REGION 'inner'}
  if not isPostBack then
  begin
    DoIt();
  end;
  {$ENDREGION}
end;

end.
