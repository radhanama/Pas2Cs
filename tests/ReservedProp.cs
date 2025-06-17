namespace Demo {
    public partial class ReservedProp {
        public void Send(MailMessage mail, string emailTo) {
            mail.To = emailTo;
        }
    }
}
