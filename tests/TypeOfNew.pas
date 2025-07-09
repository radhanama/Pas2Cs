namespace Demo;

type
  TypeOfNew = class
  public
    class method MakeArray(len: Integer): array of Byte;
    class method Show;
  end;

implementation
uses System;

class method TypeOfNew.MakeArray(len: Integer): array of Byte;
begin
  result := new Byte[len];
end;

class method TypeOfNew.Show;
begin
  Console.WriteLine(typeof(Integer));
end;

end.
