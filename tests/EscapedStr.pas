namespace Demo;

type
  EscapedStr = public class
  public
    function GetSql(ano, mes: String): String;
  end;

implementation

function EscapedStr.GetSql(ano, mes: String): String;
begin
  Result := 'WHERE ANO = ''' + ano + ''' AND MES = ''' + mes + '''';
end;

