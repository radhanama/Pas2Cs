namespace Demo;

type
  ExtraSemi = public class
  public
    class method Demo();
  end;

implementation

  class method ExtraSemi.Demo();
  var
    x: Integer;
    y: Integer
    ;
    z: String
    ;
  begin
  x := 1;;
  ;
  x := x + 1;;
  end;

end.
