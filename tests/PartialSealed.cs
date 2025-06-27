namespace SGU.Infra.Properties {
    [System.Runtime.CompilerServices.CompilerGeneratedAttribute]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.Editors.SettingsDesigner.SettingsSingleFileGenerator", "10.0.0.0")]
    public partial class Settings : System.Configuration.ApplicationSettingsBase {
        // TODO: field defaultInstance: Settings -> declare a field
        public static Settings defaultInstance = System.Configuration.ApplicationSettingsBase.Synchronized(new Settings()) as Settings;
        public Settings Default { get => get_Default(); }
        public static Settings get_Default() {
            return defaultInstance;
        }
    }
}
