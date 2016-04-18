program Config;

uses
  Forms,
  unit_config in 'unit_config.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
