namespace Demo;

interface

uses System.Collections.Generic;

type
  ComplexIf = public class
  public
    class method Check(v: Object; dict: Dictionary<String,Integer>; arr: array of Integer);
  end;

implementation

class method ComplexIf.Check(v: Object; dict: Dictionary<String,Integer>; arr: array of Integer);
begin
  if (Integer(v) > dict['foo']) and (arr[0] < dict.Count) and (dict.ContainsKey('bar') or arr.Length > 0) then
    Console.WriteLine('ok');
end;

end.
