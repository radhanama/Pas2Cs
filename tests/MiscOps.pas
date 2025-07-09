namespace Demo;

interface

uses System.Data;

type
  CastExample = public class
  public
    class method Run(ds: DataSet);
  end;

  RoundDouble = public class
  public
    class method Adjust(qt_quebra: Integer);
  end;

implementation

class method CastExample.Run(ds: DataSet);
begin
  string(ds.Tables[0].Rows[1].Item['COD']).Trim();
  if ds.Tables[0].Rows.Count > 10000 then
  begin
    log.Error('QUERY COM LINHAS ACIMA DO NORMAL');
    log.Error('QUERY STRING:' + sql);
    log.Error('LINHAS DA QUERY: "' + ds.Tables[0].Rows.Count.ToString + '"');
  end;
end;

class method RoundDouble.Adjust(qt_quebra: Integer);
begin
  if qt_quebra > 10 then
    qt_quebra := Round(double(qt_quebra / 3))-1;
end;

end.
