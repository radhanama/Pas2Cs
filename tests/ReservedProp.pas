namespace Demo;

type
  ReservedProp = public class
  public
    method Send(mail: MailMessage; emailTo: String);
  end;

implementation
uses System.Net.Mail;

method ReservedProp.Send(mail: MailMessage; emailTo: String);
begin
  mail.&To := emailTo;
end;

end.
