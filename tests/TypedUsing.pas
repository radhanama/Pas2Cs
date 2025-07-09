namespace Demo;

type
  TypedUsing = class
  public
    class method GetRes: IDisposable;
    class method DoStuff;
  end;

implementation
uses System;

class method TypedUsing.GetRes: IDisposable;
begin
  result := nil;
end;

class method TypedUsing.DoStuff;
begin
  using res: IDisposable := GetRes() do
    Console.WriteLine(res);
end;

end.
