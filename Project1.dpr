program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Mainform};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainform, Mainform);
  Application.Run;
end.
