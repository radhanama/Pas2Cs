namespace Demo;

type
  ExitComment = public class
  public
    class method Test(flag: Boolean): Integer;
  end;

implementation

class method ExitComment.Test(flag: Boolean): Integer;
begin
  if not flag then
    exit -1; // fail
  exit 0;
end;

end.
