namespace Demo {
    public partial class PropAssign {
        public void Example(RecordData perm) {
            attachment.ContentDisposition.Inline = true;
            nvc.Add("texto", this.pMensagem.Trim);
            gMeta.Visible = perm.numeroRegistros > 0;
            CustomValidator(source).ErrorMessage = "Selecione um funcionario";
            CheckBox(e.Item.Cells[3].controls[0]).checked = (string)ds.Tables[0].DefaultView.Item[e.Item.ItemIndex]["IND_TRAMITACAO"] == "S";
        }
    }
    
    public partial class BaseService {
        // TODO: field UseDefaultCredentials: bool -> declare a field
        public bool UseDefaultCredentials;
        // TODO: field Url: string -> declare a field
        public string Url;
    }
    
    public partial class ServiceLogin : BaseService {
        public void SetUrl(string value) {
            base.UseDefaultCredentials = false;
            base.Url = value;
        }
    }
    
    public partial struct RecordData {
        // TODO: field numeroRegistros: int -> declare a field
        public int numeroRegistros;
    }
}
