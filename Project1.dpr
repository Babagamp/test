program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Mainform},
  Unit2 in 'Unit2.pas' {FormPay};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainform, Mainform);
  Application.CreateForm(TFormPay, FormPay);
  Application.Run;
end.
