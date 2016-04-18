program Config;

uses
  Forms,
  unit_config in 'unit_config.pas' {FormConfig};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormConfig, FormConfig);
  Application.Run;
end.
