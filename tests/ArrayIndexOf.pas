namespace Demo;

type
  Utils = class
  public
    method Sanitize(ch: Char; invalidChars: array of Char; sanitizedInput: StringBuilder);
  end;

implementation

uses System.Text;

method Utils.Sanitize(ch: Char; invalidChars: array of Char; sanitizedInput: StringBuilder);
begin
  if Array.IndexOf(invalidChars, ch) = -1 then
    sanitizedInput.Append(ch)
  else
    sanitizedInput.Append('_');
end;

end.
