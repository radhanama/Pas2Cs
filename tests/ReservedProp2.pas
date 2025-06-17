namespace Demo;

type
  ReservedProp2 = public class
  public
    method Send(mail: MailMessage; emailTo: String);
  end;

implementation

method ReservedProp2.Send(mail: MailMessage; emailTo: String);
begin
  mail.To := emailTo;
end;

end.
