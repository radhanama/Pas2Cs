namespace Demo;

type
  KeywordName = public class
  public
    method DoStuff(mail: MailMessage);
  end;

implementation
uses System, System.Net.Mail;

method KeywordName.DoStuff(mail: MailMessage);
var
  x : Object := Enum.Parse(typeof(Integer), '1');
begin
  mail.To.Clear();
end;

end.
