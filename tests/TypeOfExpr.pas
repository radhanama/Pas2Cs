namespace Demo;

type
  TypeOfExpr = class
  public
    method AddCol(dt: DataTable);
  end;

implementation
uses System.Data;

method TypeOfExpr.AddCol(dt: DataTable);
begin
  dt.Columns.Add('Count', typeof(1));
end;

end.
