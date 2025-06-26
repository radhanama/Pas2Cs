namespace Demo;

type
  Foo = class
  public
    method Value: Integer;
  end;

implementation

method Foo.Value: Integer;
begin
  /* comment
     multiple lines */
  result := 123;
end;

end.
