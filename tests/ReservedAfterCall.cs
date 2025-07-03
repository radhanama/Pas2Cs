using System.Windows.Forms;

namespace Demo {
    public partial class Caller {
        public void SetState(CheckBox cb) {
            CheckBox(cb).@checked = true;
        }
    }
}
