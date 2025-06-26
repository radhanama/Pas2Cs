namespace SGU.Infra.Properties;

interface

type
  [System.Runtime.CompilerServices.CompilerGeneratedAttribute]
  [System.CodeDom.Compiler.GeneratedCodeAttribute('Microsoft.VisualStudio.Editors.SettingsDesigner.SettingsSingleFileGenerator', '10.0.0.0')]
  Settings = partial sealed class(System.Configuration.ApplicationSettingsBase)
  private
    class var defaultInstance: Settings := (System.Configuration.ApplicationSettingsBase.Synchronized(new Settings()) as Settings);
    class method get_Default: Settings;
  public
    class property Default: Settings read get_Default;
  end;

implementation

class method Settings.get_Default: Settings;
begin
  exit(defaultInstance);
end;

end.
