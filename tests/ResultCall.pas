namespace Demo;

type
  TRetornoZoom = public class
  public
    method definirMensagem(a: String; b: String);
  end;

  Foo = public class
  public
    method Response(body_string: String): TRetornoZoom;
  end;

implementation

method Foo.Response(body_string: String): TRetornoZoom;
begin
  result := new TRetornoZoom;
  result.definirMensagem("00", body_string);
end;

end.
