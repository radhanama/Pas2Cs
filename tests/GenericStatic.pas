namespace Demo;

type
  GenericStatic = public class
  public
    class method Use();
  end;

implementation

class method GenericStatic.Use();
begin
  System.Collections.Generic.List<String>.Sort(nil);
end;

end.
