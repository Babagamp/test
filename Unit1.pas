unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UCashCode, StdCtrls;

type
  TMainform = class(TForm)
    GBMainInput: TGroupBox;
    BtnPay1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Mainform: TMainform;

implementation

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
    label1.Caption := IntToStr(MainForm.ClientHeight );
    label2.Caption := IntToStr(MainForm.ClientWidth);
    label3.Caption := IntToStr(GBMainInput.Height);
    label4.Caption := IntToStr(GBMainInput.Width);



end;

end.
