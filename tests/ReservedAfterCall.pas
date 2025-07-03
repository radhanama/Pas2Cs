namespace Demo;

type
  Caller = public class
  public
    method SetState(cb: CheckBox);
  end;

implementation
uses System.Windows.Forms;

method Caller.SetState(cb: CheckBox);
begin
  CheckBox(cb).checked := true;
end;

end.
