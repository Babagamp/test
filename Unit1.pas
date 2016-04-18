unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UCashCode, StdCtrls;

type
  TMainform = class(TForm)
    GBMainInput: TGroupBox;
    BtnPay1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnPay1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Mainform: TMainform;

implementation

uses Unit2;

{$R *.dfm}

procedure TMainform.FormCreate(Sender: TObject);
var x,y:integer;
begin
    // Сделаем окно во весь экран
    MainForm.BorderStyle:= bsNone;
    MainForm.WindowState:= wsMaximized;

    //Выровняем Бокс с кнопками по центру
    y:=(MainForm.ClientHeight - GBMainInput.Height) div 2;
    x:=(MainForm.ClientWidth - GBMainInput.Width) div 2;
    GBMainInput.Left := x;
    GBMainInput.Top := y;

end;

procedure TMainform.BtnPay1Click(Sender: TObject);
begin
  FormPay.ShowModal;
end;

end.
