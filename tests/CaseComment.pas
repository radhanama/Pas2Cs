namespace Demo;

uses System;

type
  CaseComment = public class
  public
    method Test(val: Char);
  end;

implementation

method CaseComment.Test(val: Char);
begin
  case val of
    //A
    'A': Console.WriteLine('a');
    //B
    'B': Console.WriteLine('b');
  end;
end;

end.

