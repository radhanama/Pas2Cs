namespace Demo;

type
  PropAssign = public class
  public
    method Example(perm: RecordData);
  end;

  RecordData = public record
    numeroRegistros: Integer;
  end;

implementation

method PropAssign.Example(perm: RecordData);
begin
  attachment.ContentDisposition.Inline := true;
  nvc.Add('texto', self.pMensagem.Trim);
  gMeta.Visible := perm.numeroRegistros > 0;
end;

end.
