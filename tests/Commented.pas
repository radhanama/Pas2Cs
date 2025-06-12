namespace Demo;

type
  Commented = public class
  public
    procedure SayHello();
  end;

implementation

procedure Commented.SayHello();
begin
  { region Hello }
  System.Console.WriteLine('Hello');
  { endregion }
end;
