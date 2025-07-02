namespace Demo;

uses System;

type
  CaseEndComment = public class
  public
    method Test(val: String);
  end;

implementation

method CaseEndComment.Test(val: String);
begin
  case val of
    'A': Console.WriteLine('a');
//    'B':
//      Console.WriteLine('b');
  end;
end;

end.
