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
  CustomValidator(source).ErrorMessage := 'Selecione um funcionario';
  CheckBox(e.Item.Cells[3].controls[0]).checked := string(ds.Tables[0].DefaultView.Item[e.Item.ItemIndex]['IND_TRAMITACAO']) = 'S';
end;

end.
