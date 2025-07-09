namespace Demo;
// comment after namespace

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
    {$REGION 'extra'}
    method ValueBrace: Integer;
    {$ENDREGION}
  method ValueCStyle: Integer;
  method HeaderLineComment;
  end;

  /// <remarks>
  /// comment before class
  /// </remarks>
  PreComment = class
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

method Foo.HeaderLineComment; // header comment
var
  i: Integer;
begin
  i := 1;
end;

end.
