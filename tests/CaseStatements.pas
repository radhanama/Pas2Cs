namespace N;

interface

uses System;

type
  TTest = public class
  public
    method SimpleCase(x: Integer);
    method WithElse(x: Integer);
    method Empty(x: Integer);
  method UpperCase(val: String): String;
  method CommentBranch(val: String);
  method TrailingComment(x: Integer);
  end;

  EnumCase = public class
  public
    method WeekDay(day: DayOfWeek);
  end;

implementation

method TTest.SimpleCase(x: Integer);
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

method TTest.WithElse(x: Integer);
begin
  case x of
    1: Console.WriteLine('one');
  else
    Console.WriteLine('other');
  end;
end;

method TTest.Empty(x: Integer);
begin
  case x of
    1: Console.WriteLine('one');
  else;
  end;
end;

method TTest.UpperCase(val: String): String;
begin
  Case val of
    'S': result := 'one';
    'B': result := 'two';
  end;
end;

method TTest.CommentBranch(val: String);
begin
  case val of
    'FIRST':
    begin
      Console.WriteLine('one');
    end;
    'SECOND': // after colon comment
    begin
      Console.WriteLine('two');
    end;
  end;
end;

method TTest.TrailingComment(x: Integer);
begin
  case x of
    1: Console.WriteLine('one'); // trailing
    2: Console.WriteLine('two');
  end;
end;

end.
