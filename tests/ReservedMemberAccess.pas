namespace Demo;

type
  Tnulo = public class
  private
    fInt: Integer;
  public
    property int: Integer read fInt write fInt;
  end;

  TUse = public class
  public
    method DoIt(n: Tnulo);
  end;

implementation

method TUse.DoIt(n: Tnulo);
begin
  n.int := 5;
end;

end.
