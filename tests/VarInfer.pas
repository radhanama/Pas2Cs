namespace Demo;

type
  VarInfer = public class
  public
    method Example;
  end;

implementation

method VarInfer.Example;
begin
  var cli := new WebClient();
end;

end.
