namespace Demo {
    public partial class BugFixes {
        public void CastIndex(Hashtable ret, Hashtable aux, object k) {
            (ret as Hashtable)[k] = ToHashtable((aux as Hashtable)[k]);
        }
        public void PathJoin(string nome_arquivo) {
            string path;
            path = U.Business.TSguUtils.PathRaizAbsoluto + "\\arquivos\\" + nome_arquivo;
        }
        public void CaseRange(int x) {
            switch (x)
            {
                case 1:
                case 2:
                case 3: System.Console.WriteLine("low"); break;
                case 4: System.Console.WriteLine("four"); break;
            }
        }
        public void Underscore(object ds) {
            if (ds.Tables[0].Rows.Count > 10000) System.Console.WriteLine("big");
        }
        public void CommaNumber(object ds) {
            if (ds.Tables[0].Rows.Count > 10000) System.Console.WriteLine("big");
        }
        public void Backslash(string src) {
            src = src.Replace("\\", "\\\\");
        }
    }
}
