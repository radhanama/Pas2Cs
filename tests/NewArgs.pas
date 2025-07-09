namespace Demo;

type
  Foo = public class
  public
    class method Make;
    class method Named;
  end;

implementation

class method Foo.Make;
var t : System.Collections.Generic.List<Integer>;
begin
  t := new System.Collections.Generic.List<Integer>(5);
end;

class method Foo.Named;
var v : Demo.Bar;
begin
  v := new Demo.Bar(value := 1, name := 'a');
end;

end.
