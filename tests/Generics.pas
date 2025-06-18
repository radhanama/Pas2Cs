namespace Demo;

interface

uses System.Collections.Generic, Newtonsoft.Json.Linq, System.Collections;

type
  MyList = public class(List<String>)
  public
    method Foo;
  end;

  GenExample = public class
  public
    method UseList(l: List<String>);
    method Parse(ret: JObject);
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

method GenExample.Parse(ret: JObject);
var
  aux: Hashtable;
begin
  aux := (ret as JObject).ToObject<Hashtable>();
end;

class method GenericStatic.Use();
begin
  System.Collections.Generic.List<String>.Sort(nil);
end;

class procedure GenClass.DeSerialize<T>(json: String; var obj: T);
begin
end;

end.

