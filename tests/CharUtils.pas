namespace Demo;

type
  CharCodeExample = public class
  public
    class method GetNewline: String;
  end;

  CharSeq = public class
  public
    class method GetCRLF: String;
  end;

implementation

class method CharCodeExample.GetNewline: String;
begin
  result := #13 + #10;
end;

class method CharSeq.GetCRLF: String;
begin
  result := #13#10;
end;

end.
