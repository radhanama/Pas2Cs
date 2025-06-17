namespace Demo;

type
  NotIn = public class
  public
    method Check(tipo: String);
  end;

implementation

method NotIn.Check(tipo: String);
begin
  if tipo not in ['Aluno', 'Funcionario'] then
    Console.WriteLine('nao');
end;

end.
