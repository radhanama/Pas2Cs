namespace Demo;

type
  ShortIf = class
  public
    class method AddBr(msg: String): String;
  end;

implementation

class method ShortIf.AddBr(msg: String): String;
begin
  msg := msg + (if msg <> '' then '<br />');
  result := msg;
end;

end.
