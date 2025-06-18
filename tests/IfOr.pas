namespace Demo;

type
  Foo = class
  private
    ehVazio: Boolean;
    indUltimaPos: Integer;
  public
    method Check(frowInd: Integer): Boolean;
  end;

implementation

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
