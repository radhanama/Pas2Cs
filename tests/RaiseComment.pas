namespace Demo;

type
  RaiseComment = public class
  public
    class method Test;
  end;

implementation

class method RaiseComment.Test;
begin
  raise new Exception('boom'); // oops
end;

end.
