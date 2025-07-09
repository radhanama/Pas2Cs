namespace Demo;

type
  InterpolatedStr = public class
  public
    function Quote(month: string): string;
  end;

implementation

function InterpolatedStr.Quote(month: string): string;
begin
  Result := $'''{month}''';
end;

end.
