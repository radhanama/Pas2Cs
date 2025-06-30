namespace Demo;

type
  PropAssign = public class
  public
    method Example(perm: RecordData);
  end;

  BaseService = public class
  public
    UseDefaultCredentials: Boolean;
    Url: String;
  end;

  ServiceLogin = public class(BaseService)
  public
    method SetUrl(value: String);
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

method ServiceLogin.SetUrl(value: String);
begin
  inherited UseDefaultCredentials := false;
  inherited Url := value;
end;

end.
