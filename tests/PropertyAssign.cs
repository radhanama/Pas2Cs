namespace Demo {
    public partial class PropAssign {
        public void Example(RecordData perm) {
            attachment.ContentDisposition.Inline = true;
            nvc.Add("texto", self.pMensagem.Trim);
            gMeta.Visible = perm.numeroRegistros > 0;
        }
    }
    
    public partial struct RecordData {
        // TODO: field numeroRegistros: int -> declare a field
        public int numeroRegistros;
    }
}
