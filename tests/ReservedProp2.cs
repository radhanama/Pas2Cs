namespace Demo {
    public partial class ReservedProp2 {
        public void Send(MailMessage mail, string emailTo) {
            mail.To = emailTo;
        }
    }
}
