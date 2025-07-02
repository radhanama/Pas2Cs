namespace Test;
interface

type
  Foo = public class
    function Bar : Integer;
    function TipoFonte: String;
  end;

implementation

function Foo.Bar : Integer;
begin
  result := 1;
end;

function Foo.TipoFonte: String;
begin
  if fonteAux.tipo.trim = '0' then
    result := 'P' //Fonte PUC
  else
    if fonteAux.tipo.trim = '1' then
      result := 'C' //Fonte Convênio
    else
      result := 'J'; //Fonte Projeto
end;

end.
