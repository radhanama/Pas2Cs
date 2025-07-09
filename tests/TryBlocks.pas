namespace Demo;

interface

uses System;

type
  TryExceptExample = public class
  public
    class method DoStuff();
  end;

  TryExceptOnType = public class
  public
    class method DoStuff();
  end;

  TryExceptOnEmpty = public class
  public
    class method DoStuff();
    class method DoNothingNoSemi();
  end;

  TryExceptEmptyExample = public class
  public
    class method DoNothing();
  end;

  TryExceptEmptySemiExample = public class
  public
    class method DoNothing();
    class method DoHandle();
  end;

  TryFinallyEmptyExample = public class
  public
    class method DoNothing();
  end;

implementation

class method TryExceptExample.DoStuff();
begin
  try
    Console.WriteLine('A');
  except
    on E: Exception do
      Console.WriteLine(E.Message);
  end;
end;

class method TryExceptOnType.DoStuff();
begin
  try
    Console.WriteLine('A');
  except
    on Exception do
      Console.WriteLine('Error');
  end;
end;

class method TryExceptOnEmpty.DoStuff();
begin
  try
    Console.WriteLine('A');
  except
    on E: Exception do;
  end;
end;

class method TryExceptOnEmpty.DoNothingNoSemi();
begin
  try
    Console.WriteLine('B');
  except
    on E: Exception do
  end;
end;

class method TryExceptEmptyExample.DoNothing();
begin
  try
    Console.WriteLine('A');
  except
  end;
end;

class method TryExceptEmptySemiExample.DoNothing();
begin
  try
    Console.WriteLine('A');
  except;
  end;
end;

class method TryExceptEmptySemiExample.DoHandle();
begin
  try
    Console.WriteLine('B');
  except;
    Console.WriteLine('Error');
  end;
end;

class method TryFinallyEmptyExample.DoNothing();
begin
  try
    Console.WriteLine('A');
  finally
  end;
end;

end.
