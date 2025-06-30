using System.Data;

namespace Demo {
    public partial class Controller {
        public static void Check(DataSet ds, object r) {
            if (getControlador.getDocDespesa.sitDoc == "AGUARD APROV DOC") {
                u = TUSUArio(session["usuario"]);
                ds = u.buscarUsuarioPrograma(u.idUsuario, TPrograma.codProgramaAprovacaoDocumento);
                r.Visible = ds.Tables[0].Rows.Count > 0;
                if (TSGUUtils.testarStrNulo(getControlador.getDocDespesa.chaveAcesso) == "") detDoc.exibeLinkReceita();
            }
        }
    }
}
