namespace Demo;

type
  PostCallIndex = public class
  public
    class method Run(ds: DataSet);
  end;

implementation

class method PostCallIndex.Run(ds: DataSet);
begin
  get(ds).Tables[0];
end;

end.
