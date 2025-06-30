namespace Demo;

type
  StrayBrace = public class
  public
    class method Demo();
  end;

implementation

class method StrayBrace.Demo();
begin
  System.Console.WriteLine('hi');  };
  System.Console.WriteLine('there');
  {System.Console.WriteLine('ignored');}
  ;
end;

end.
