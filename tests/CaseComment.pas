namespace Demo;

uses System;

type
  CaseComment = public class
  public
    method Test(val: Char);
    method CommentedBranch(val: Char);
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

method CaseComment.CommentedBranch(val: Char);
begin
  case val of
    'A': Console.WriteLine('a');
//    'B':
//      Console.WriteLine('b');
    'C': Console.WriteLine('c');
  end;
end;

end.

