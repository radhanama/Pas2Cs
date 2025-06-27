namespace Demo;

type
  ExtraSemi = public class
  public
    class method Demo();
  end;

implementation

  class method ExtraSemi.Demo();
  var x: Integer;
  begin
  x := 1;;
  ;
  x := x + 1;;
  end;

end.
