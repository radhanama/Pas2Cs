namespace Demo;

interface
uses System;

type
  RaiseExample = public class
  public
    class method DoRaise();
  end;

implementation

class method RaiseExample.DoRaise();
begin
  raise new Exception('fail');
end;

end.
