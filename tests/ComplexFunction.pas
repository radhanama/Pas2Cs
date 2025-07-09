namespace Demo;

interface

uses System.Data;

type
  MyClass = public static class
  public
    function myfunction(idAutor, idLicit, situacao,
      dtIniEmissao, dtFimEmissao, idCC, idMetaFase: string): DataSet;
  end;

implementation

function MyClass.myfunction(idAutor, idLicit, situacao,
  dtIniEmissao, dtFimEmissao, idCC, idMetaFase: string): DataSet;
var
  strSql: TStringList;
  dtIni, dtFim : DateTime;
begin
  strSql := new TStringList;
  strSql.Add('my sql');
  if (not String.isNullOrEmpty(idAutor)) and (idAutor <> '-1') then
    strSql.Add('my sql ' + idAutor.ToString );
  if not String.isNullOrEmpty(idLicit) then
    strSql.Add('my sql' + idLicit + ')');
  if (not String.isNullOrEmpty(idCC)) and (idCC <> '-1') then
    strSql.Add('my sql ' + idCC );
  if not String.isNullOrEmpty(idMetaFase) then
    strSql.Add('my sql' + idMetaFase );
  if not String.isNullOrEmpty(situacao) then
    strSql.Add('my sql ''' + situacao + '''');
  if not String.isNullOrEmpty(dtIniEmissao) then
  begin
    dtIni := StrToDate(dtIniEmissao);
    strSql.Add('my sql ''' + dtIni.Tostring('yyyy-MM-dd') + '''');
  end;
  if not String.isNullOrEmpty(dtFimEmissao) then
  begin
    dtFim := StrToDate(dtFimEmissao);
    strSql.Add('my sql ''' + dtFim.Tostring('yyyy-MM-dd') + '''');
  end;
  strSql.Add('my sql');
  result := helper.openSQL(strSql.Text);
end;

end.
