namespace Demo;

interface

uses System;

type
  Commented = public class
  public
    procedure SayHello();
  end;

  Foo = class
  public
    method ValueParen: Integer;
    method ValueBrace: Integer;
    method ValueCStyle: Integer;
  end;

implementation

procedure Commented.SayHello();
begin
  { region Hello }
  System.Console.WriteLine('Hello');
  { endregion }
end;

method Foo.ValueParen: Integer;
begin
  (* comment with *** inside
     multiple lines *)
  result := 123;
end;

method Foo.ValueBrace: Integer;
begin
  { comment
    multiple lines }
  result := 123;
end;

method Foo.ValueCStyle: Integer;
begin
  /* comment
     multiple lines */
  result := 123;
end;

end.
