namespace N;

type
  TTest = public class
  public
    method Foo(x: Integer);
  end;

  EnumCase = public class
  public
    method WeekDay(day: DayOfWeek);
  end;

implementation

method TTest.Foo(x: Integer);
begin
  case x of
    1: exit;
    2: exit;
  end;
end;

method EnumCase.WeekDay(day: DayOfWeek);
begin
  case day of
    DayOfWeek.Friday: System.Console.WriteLine('fri');
    DayOfWeek.Monday: System.Console.WriteLine('mon');
  end;
end;

end.
