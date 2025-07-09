namespace Demo;

type
  AttrSample = public class
  public
    class method Foo: Integer; static;
    [Obsolete]
    class method Bar(x: Integer): Integer; static;
  end;

  WebService = public class
  public
    [WebMethod(EnableSession := true)]
    [ScriptMethod]
    class function SalvarCadastro(natrend, prestserv, data, base_calculo, vl_imposto: String): String;
function DescricaoNatRend(natrend: Object): String;
  end;

implementation

class method AttrSample.Foo: Integer;
begin
  Result := 0;
end;

class method AttrSample.Bar(x: Integer): Integer;
begin
  Result := x;
end;

class function WebService.SalvarCadastro(natrend, prestserv, data, base_calculo, vl_imposto: String): String;
begin
  Result := '';
end;

[WebMethod]
function WebService.DescricaoNatRend(natrend: Object): String;
begin
  Result := '';
end;

end.
