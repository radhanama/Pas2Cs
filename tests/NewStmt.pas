namespace Demo;

type
  NewStmt = class
  public
    class method Make;
  end;

implementation
uses System;

class method NewStmt.Make;
begin
  new Exception('fail');
end;

end.
