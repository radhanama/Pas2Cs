namespace Demo;

interface

uses LogManager;

type
  Example = public class
  public
    class method Test;
  end;

implementation

class method Example.Test;
begin
  LogManager.GetLogger(typeof(Example).ToString);
end;

end.
