namespace Demo;

type
  Chain = public class
  public
    class procedure Run;
  end;

implementation

class procedure Chain.Run;
begin
  getObj().Sub().Action();
end;
