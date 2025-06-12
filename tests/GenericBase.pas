namespace Demo;

type
  MyList = public class(List<String>)
  public
    method Foo;
  end;

implementation

method MyList.Foo;
begin
end;

end.
