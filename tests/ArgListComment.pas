namespace Demo;

type
  ArgListComment = public class
  public
    class method ThreeArgs(a, b, c: Integer);
    class method Run;
  end;

implementation

class method ArgListComment.ThreeArgs(a, b, c: Integer);
begin
end;

class method ArgListComment.Run;
begin
  ThreeArgs(1, // first
            2, // second
            3);
end;

end.
