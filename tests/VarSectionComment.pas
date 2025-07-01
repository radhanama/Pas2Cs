namespace Demo;

type
  VarSectionComment = public class
  public
    method Demo;
  end;

implementation

method VarSectionComment.Demo;
var
  // comment before var declaration
  i: Integer;
begin
  i := 1;
end;

end.
