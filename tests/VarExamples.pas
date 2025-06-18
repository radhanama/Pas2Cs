namespace Demo;

interface

uses System;

type
  VarInfer = public class
  public
    method Example;
  end;

  VarStmt = public class
  public
    method Example;
  end;

  NamedArg = public class
  public
    procedure UseArgs;
  end;

  NotIn = public class
  public
    method Check(tipo: String);
  end;

implementation

method VarInfer.Example;
begin
  var cli := new WebClient();
end;

method VarStmt.Example;
begin
  var delimiter : String := ',';
end;

procedure NamedArg.UseArgs;
begin
  Console.WriteLine(value := 123, message := 'ok');
end;

method NotIn.Check(tipo: String);
begin
  if tipo not in ['Aluno', 'Funcionario'] then
    Console.WriteLine('nao');
end;

end.
