namespace Demo;

type
  IfThenSemi = class
  public
    class method Demo(flag: Boolean);
  end;

implementation

class method IfThenSemi.Demo(flag: Boolean);
begin
  if flag then
  begin
    if flag then; // no-op
    begin
      System.Console.WriteLine('Hello');
    end;
  end;
end;

end.
