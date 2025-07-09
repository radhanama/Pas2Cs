namespace Demo;

type
  Extra = public class sealed
  public
    method InlineProc; inline;
    method ExternalProc; cdecl; external;
  end;


implementation

method Extra.InlineProc;
begin
end;

method Extra.ExternalProc;
begin
end;
