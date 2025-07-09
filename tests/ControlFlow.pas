namespace Demo;

interface

uses System.Collections.Generic, System;

type
  BasicIf = public class
  public
    class method Check(x: Integer);
  end;

  IfElse = public class
  public
    class method Check(x: Integer);
  end;

  LongIf = public class
  public
    class method Check(a, b, c, d, e, x, y: Boolean);
  end;

  ComplexIf = public class
  public
    class method Check(v: Object; dict: Dictionary<String,Integer>; arr: array of Integer);
  end;

  ShortCircuit = public class
  public
    method Check(a: Boolean; b: Boolean);
  end;

implementation

class method BasicIf.Check(x: Integer);
begin
  if x = 5 then
    Console.WriteLine('Hi');
end;

class method IfElse.Check(x: Integer);
begin
  if x >= 0 then
    Console.WriteLine('pos')
  else
    Console.WriteLine('neg');
end;

class method LongIf.Check(a, b, c, d, e, x, y: Boolean);
begin
  if (a and b and c and d and e) or (x and y) then
    Console.WriteLine('ok');
end;

class method ComplexIf.Check(v: Object; dict: Dictionary<String,Integer>; arr: array of Integer);
begin
  if (Integer(v) > dict['foo']) and (arr[0] < dict.Count) and (dict.ContainsKey('bar') or arr.Length > 0) then
    Console.WriteLine('ok');
end;

method ShortCircuit.Check(a: Boolean; b: Boolean);
begin
  if a or else b then
    Console.WriteLine('yes');
  if a and then b then
    Console.WriteLine('and');
end;

end.
