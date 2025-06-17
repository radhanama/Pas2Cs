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
end;

end.
