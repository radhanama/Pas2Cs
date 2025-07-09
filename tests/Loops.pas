namespace Demo;

type
  ForDownToDemo = public class
  public
    class method Test();
  end;

  ForEachExample = public class
  public
    class method Sum(arr: array of Integer): Integer;
  end;

  StepExample = public class
  public
    class method Sum(): Integer;
  end;

  LoopExample = public class
  public
    class method CountThree();
  end;

  RepeatExample = public class
  public
    class method LoopIt();
  end;

  BreakExample = public class
  public
    class method DoBreak(arr: array of Integer);
  end;

  WhileDemo = public class
  public
    class method Test(arr: Array of Integer);
  end;

  WhileEmptyDemo = public class
  public
    class method DoNothing();
  end;

  WhileNoStmtDemo = public class
  public
    class method Skip();
  end;

  TypedForEach = public class
  public
    class method Sum(arr: array of Integer): Integer;
  end;

  ForEachIndexExample = public class
  public
    class method Sum(arr: array of Integer): Integer;
  end;

  TypedForLoop = public class
  public
    class method Sum(arr: array of Integer): Integer;
  end;

implementation

class method ForDownToDemo.Test();
begin
  for i := 3 downto 1 do
    System.Console.WriteLine(i);
end;

class method ForEachExample.Sum(arr: array of Integer): Integer;
var
  total: Integer;
begin
  total := 0;
  for each item in arr do
    total := total + item;
  result := total;
end;

class method StepExample.Sum(): Integer;
var
  i: Integer;
  total: Integer;
begin
  total := 0;
  for i := 1 to 5 step 2 do
    total := total + i;
  result := total;
end;

class method LoopExample.CountThree();
var
  i: Integer;
begin
  i := 0;
  loop
  begin
    i := i + 1;
    if i = 3 then break;
  end;
end;

class method RepeatExample.LoopIt();
var
  i: Integer;
begin
  i := 0;
  repeat
    i := i + 1;
  until i > 3;
end;

class method BreakExample.DoBreak(arr: array of Integer);
var
  i: Integer;
begin
  for i := 0 to arr.Length - 1 do
  begin
    if arr[i] = 0 then break;
    if arr[i] < 0 then continue;
  end;
end;

class method WhileDemo.Test(arr: Array of Integer);
var
  i: Integer := 0;
begin
  while (i <= 2) do
    i := i + arr[0];
end;

class method WhileEmptyDemo.DoNothing();
var
  i: Integer := 0;
begin
  while i < 3 do;
end;

class method WhileNoStmtDemo.Skip();
var
  i: Integer := 0;
begin
  while i < 3 do
end;

class method TypedForEach.Sum(arr: array of Integer): Integer;
var
  total: Integer;
begin
  total := 0;
  for each item: Integer in arr do
    total := total + item;
  result := total;
end;

class method ForEachIndexExample.Sum(arr: array of Integer): Integer;
var
  total: Integer;
begin
  total := 0;
  for each item in arr index idx do
    total := total + item * idx;
  result := total;
end;

class method TypedForLoop.Sum(arr: array of Integer): Integer;
var
  total: Integer;
begin
  total := 0;
  for i: Integer := 0 to length(arr) - 1 do
    total := total + arr[i];
  result := total;
end;

end.

