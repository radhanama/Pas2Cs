namespace Demo;

interface

uses System.ComponentModel;

type
  MyClass = public class
  public
    event PropertyChanged: System.ComponentModel.PropertyChangedEventHandler protected raise; virtual;
  end;

implementation

end.
