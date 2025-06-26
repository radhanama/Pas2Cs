namespace Demo;

interface

uses System;

type
  DateParseCompare = class
  public
    method Check(numDias: Integer);
  end;

implementation

method DateParseCompare.Check(numDias: Integer);
begin
  if (DateTime.Now < DateTime.parse('22/05/2025')) and (numDias > 9955) then
    Console.WriteLine('ok');
end;

end.
