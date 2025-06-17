namespace Demo;

interface

uses System.Collections.Generic;

type
  MyList = public class(List<String>)
  public
    method Foo;
  end;

  GenExample = public class
  public
    method UseList(l: List<String>);
  end;

  GenericStatic = public class
  public
    class method Use();
  end;

  GenClass = public class
  public
    class procedure DeSerialize<T>(json: String; var obj: T);
  end;

implementation

method MyList.Foo;
begin
end;

method GenExample.UseList(l: List<String>);
var
  v: List<Integer>;
begin
  v := new List<Integer>;
  l.AddRange(v);
end;

class method GenericStatic.Use();
begin
  System.Collections.Generic.List<String>.Sort(nil);
end;

class procedure GenClass.DeSerialize<T>(json: String; var obj: T);
begin
end;

end.

