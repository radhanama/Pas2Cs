namespace Demo;

interface

uses System;

type
  Ternary = class
  public
    class method Select(flag: Boolean): Integer;
  end;

  ShortIf = class
  public
    class method AddBr(msg: String): String;
  end;

  IfThenSemi = class
  public
    class method Demo(flag: Boolean);
  end;

  IfElseEmptyExample = public class
  public
    class method Check(flag: Boolean);
  end;

  Foo = class
  private
    ehVazio: Boolean;
    indUltimaPos: Integer;
  public
    method Check(frowInd: Integer): Boolean;
  end;

implementation

class method Ternary.Select(flag: Boolean): Integer;
var
  val: Integer;
begin
  val := if flag then 1 else 0;
  result := val;
end;

class method ShortIf.AddBr(msg: String): String;
begin
  msg := msg + (if msg <> '' then '<br />');
  result := msg;
end;

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

class method IfElseEmptyExample.Check(flag: Boolean);
begin
  if flag then
    Console.WriteLine('yes')
  else
    // nothing
end;

method Foo.Check(frowInd: Integer): Boolean;
begin
  if ( self.ehVazio ) or
     ( frowInd > self.indUltimaPos) or
     ( frowInd = -1 )   then
    result := true
  else
    result := false;
end;

end.
