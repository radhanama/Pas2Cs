namespace Demo;

type
  VarNameComments = public class
  public
    class method Demo();
  end;

implementation

class method VarNameComments.Demo();
var
  a, // first variable
  b, // second variable
  c: String;
begin
  a := 'A';
  b := 'B';
  c := a + b;
end;

end.
