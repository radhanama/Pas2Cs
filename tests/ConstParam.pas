namespace Demo;

type
  ConstParam = class
  public
    class method Echo(const s: String): String;
  end;

implementation

class method ConstParam.Echo(const s: String): String;
begin
  result := s;
end;

end.
