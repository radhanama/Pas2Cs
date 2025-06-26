namespace Demo;

interface

uses System;

type
  RangeWords = public class
  public
    class function ConversaoRecursiva(N: LongWord): string;
  end;

implementation

class function RangeWords.ConversaoRecursiva(N: LongWord): string;
begin
  case N of
    1..19:
      Result := Unidades[N];
    20, 30, 40, 50, 60, 70, 80, 90:
      Result := Dezenas[N div 10] + ' ';
    21..29, 31..39, 41..49, 51..59, 61..69, 71..79, 81..89, 91..99:
      Result := Dezenas[N div 10] + ' e ' + ConversaoRecursiva(N mod 10);
    100, 200, 300, 400, 500, 600, 700, 800, 900:
      Result := Centenas[N div 100] + ' ';
    101..199:
      Result := ' cento e ' + ConversaoRecursiva(N mod 100);
    201..299, 301..399, 401..499, 501..599, 601..699, 701..799, 801..899, 901..999:
      Result := Centenas[N div 100] + ' e ' + ConversaoRecursiva(N mod 100);
    1000..999999:
      Result := ConversaoRecursiva(N div 1000) + ' mil ' +
        ConversaoRecursiva(N mod 1000);
    1000000..1999999:
      Result := ConversaoRecursiva(N div 1000000) + ' milhão '
                  + ConversaoRecursiva(N mod 1000000);
    2000000..999999999:
      Result := ConversaoRecursiva(N div 1000000) + ' milhoes '
                  + ConversaoRecursiva(N mod 1000000);
    1000000000..1999999999:
      Result := ConversaoRecursiva(N div 1000000000) + ' bilhão '
                  + ConversaoRecursiva(N mod 1000000000);
    2000000000..4294967295:
      Result := ConversaoRecursiva(N div 1000000000) + ' bilhoes '
                  + ConversaoRecursiva(N mod 1000000000);
  end;
end;

end.
