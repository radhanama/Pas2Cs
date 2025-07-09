namespace Demo;

type
  YieldExample = public class
  public
    method Dummy;
  end;

implementation

method YieldExample.Dummy;
begin
  yield 5;
end;

end.
