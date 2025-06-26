namespace Demo;

type
  BugFixes = public class
  public
    method CastIndex(ret, aux: Hashtable; k: Object);
    method PathJoin(nome_arquivo: String);
    method CaseRange(x: Integer);
    method Underscore(ds: Object);
  method CommaNumber(ds: Object);
  method Backslash(src: String);
  method PascalIf(flag: Boolean);
  end;

implementation

method BugFixes.CastIndex(ret, aux: Hashtable; k: Object);
begin
  (ret as Hashtable)[k] := ToHashtable((aux as Hashtable)[k]);
end;

method BugFixes.PathJoin(nome_arquivo: String);
var path: String;
begin
  path := U.Business.TSguUtils.PathRaizAbsoluto + "\arquivos\" + nome_arquivo;
end;

method BugFixes.CaseRange(x: Integer);
begin
  case x of
    1..3: System.Console.WriteLine('low');
    4:    System.Console.WriteLine('four');
  end;
end;

method BugFixes.Underscore(ds: Object);
begin
  if ds.Tables[0].Rows.Count > 10_000 then
    System.Console.WriteLine('big');
end;

method BugFixes.CommaNumber(ds: Object);
begin
  if ds.Tables[0].Rows.Count > 10,000 then
    System.Console.WriteLine('big');
end;

method BugFixes.Backslash(src: String);
begin
  src := src.Replace("\", "\\");
end;
method BugFixes.PascalIf(flag: Boolean);
begin
  If flag then
    System.Console.WriteLine('ok');
end;

method BugFixes.SQPath;
begin
  System.Console.WriteLine('C:\temp\file.txt');
end;

end.
