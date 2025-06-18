namespace Demo;

type
  OverloadExample = public class
  public
    class method Rename(pathOriginal: String); overload;
    class method Rename(pathOriginal, pathNova: String); overload;
  end;

implementation

class method OverloadExample.Rename(pathOriginal: String);
begin
end;

class method OverloadExample.Rename(pathOriginal, pathNova: String);
begin
end;

end.
