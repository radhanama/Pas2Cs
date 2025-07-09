namespace Demo;

type
  TIndexed = public class
  public
    property Items[index: Integer]: String read GetItem write SetItem;
  end;
