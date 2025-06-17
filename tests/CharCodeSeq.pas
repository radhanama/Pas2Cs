namespace Demo;

type
  CharSeq = class
  public
    class method GetCRLF: String;
  end;

implementation

class method CharSeq.GetCRLF: String;
begin
  result := #13#10;
end;

end.
