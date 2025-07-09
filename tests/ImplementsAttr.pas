namespace Demo;

type
  TestClass = public class(IMyInterface)
  private
    method IMyInterface_Foo(a: Integer): Integer; implements IMyInterface.Foo;
  end;

implementation

method TestClass.IMyInterface_Foo(a: Integer): Integer;
begin
  result := a;
end;

end.
