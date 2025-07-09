namespace Demo;

interface

uses System.Data;

type
  Controller = public class
  public
    class method Check(ds: DataSet; r: Object);
  end;

implementation

class method Controller.Check(ds: DataSet; r: Object);
begin
  if (getControlador.getDocDespesa.sitDoc = 'AGUARD APROV DOC') then
  begin
    u := TUSUArio(session['usuario']);
    ds := u.buscarUsuarioPrograma(u.idUsuario, TPrograma.codProgramaAprovacaoDocumento);
    r.Visible := (ds.Tables[0].Rows.Count > 0);
    if (TSGUUtils.testarStrNulo(getControlador.getDocDespesa.chaveAcesso)='') then
      detDoc.exibeLinkReceita;
  end;
end;

end.
