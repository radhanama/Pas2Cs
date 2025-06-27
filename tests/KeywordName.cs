using System;
using System.Net.Mail;

namespace Demo {
    public partial class KeywordName {
        public void DoStuff(MailMessage mail) {
            object x = Enum.Parse(typeof(int), "1");
            mail.To.Clear();
        }
    }
}
