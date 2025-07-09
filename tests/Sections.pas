namespace Demo;

interface

type
  Foo = public class
  protected
    method Hidden;
  public
    method Visible;
  strict private
    method ReallyHidden;
  published
    method PublishedMethod;
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

method Foo.ReallyHidden;
begin
  System.Console.WriteLine('really hidden');
end;

method Foo.PublishedMethod;
begin
  System.Console.WriteLine('published');
end;

