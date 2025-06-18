namespace Demo;

type
  NewStmt = class
  public
    class method Make;
  end;

implementation

class method NewStmt.Make;
begin
  new Exception('fail');
end;

end.
