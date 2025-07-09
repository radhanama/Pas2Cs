program DemoProg;

type
  ProgramTypes = class
  public
    class method Run(b: Byte; w: Word; s: SmallInt; l: LongInt): Byte;
  end;

implementation

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

end.
