program DemoProg;

type
  Example = public class
  public
    method SayHi;
  end;

  ProgramTypes = class
  public
    class method Run(b: Byte; w: Word; s: SmallInt; l: LongInt): Byte;
  end;

  Dummy = class
  end;

implementation

method Example.SayHi;
begin
  System.Console.WriteLine('Hi');
end;

class method ProgramTypes.Run(b: Byte; w: Word; s: SmallInt; l: LongInt): Byte;
var
  x: Byte;
  y: Word;
  z: SmallInt;
  m: LongInt;
begin
  x := b;
  y := w;
  z := s;
  m := l;
  result := x;
end;

initialization
  System.Console.WriteLine('init');
finalization
  System.Console.WriteLine('fini');
end.
