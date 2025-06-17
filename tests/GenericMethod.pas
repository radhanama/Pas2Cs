namespace Demo;

type
  GenClass = public class
  public
    class procedure DeSerialize<T>(json: String; var obj: T);
  end;

implementation

class procedure GenClass.DeSerialize<T>(json: String; var obj: T);
begin
end;

end.
