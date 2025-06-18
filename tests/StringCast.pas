namespace Demo;

interface

uses System.Data;

type
  CastExample = public class
  public
    class method Run(ds: DataSet);
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

end.
