namespace Demo;

type
  Service = public class
  public
    method GetData(nip: System.String): [System.ServiceModel.MessageParameterAttribute(Name := 'situacao')] Integer;
  end;

implementation

method Service.GetData(nip: System.String): [System.ServiceModel.MessageParameterAttribute(Name := 'situacao')] Integer;
begin
  result := 0;
end;

end.
