[assembly: AssemblyTitle('demo')]
namespace Demo;

interface

uses
  System.Reflection;

[assembly: AssemblyDescription('desc')]

type
  AttrDemo = public class
  public
    method DoIt;
  end;

implementation

method AttrDemo.DoIt;
begin
end;

end.
