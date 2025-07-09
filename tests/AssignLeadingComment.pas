namespace Demo;

type
  AssignLeadingComment = class
  public
    class method Demo: Integer;
  end;

implementation

class method AssignLeadingComment.Demo: Integer;
var
  v: Integer;
begin
  v := { leading comment } 5;
  result := v;
end;

end.
