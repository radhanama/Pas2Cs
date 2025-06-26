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
    
    public partial struct RecordData {
        // TODO: field numeroRegistros: int -> declare a field
        public int numeroRegistros;
    }
}
