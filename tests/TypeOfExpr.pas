namespace Demo;

type
  TypeOfExpr = class
  public
    method AddCol(dt: DataTable);
  end;

implementation

method TypeOfExpr.AddCol(dt: DataTable);
begin
  dt.Columns.Add('Count', typeof(1));
end;

end.
