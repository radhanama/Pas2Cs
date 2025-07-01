namespace Demo;

interface

type
  Foo = class
  public
    method Test;
  end;

implementation

method Foo.Test;
begin
    // leading comment
    var i := 1;
end;

end.
