namespace Demo;

interface

type
  Foo = public class
  protected
    method Hidden;
  public
    method Visible;
  end;

implementation

method Foo.Hidden;
begin
  System.Console.WriteLine('hidden');
end;

method Foo.Visible;
begin
  System.Console.WriteLine('visible');
end;

