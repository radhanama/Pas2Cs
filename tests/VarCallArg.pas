namespace Demo;

type
  ExceptionDemo = class
  private
    class var _unhandledExceptionCount: Integer;
  public
    class procedure Check;
  end;

implementation

class procedure ExceptionDemo.Check;
begin
  if (Interlocked.Exchange(var _unhandledExceptionCount, 1) <> 0) then
    exit;
end;

end.
