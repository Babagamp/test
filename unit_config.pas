unit unit_config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, xmldom, XMLIntf, msxmldom, XMLDoc, StdCtrls, ExtCtrls;

type
  TFormConfig = class(TForm)
    XMLDoc: TXMLDocument;
    GroupBoxCash: TGroupBox;
    CheckBox10rub: TCheckBox;
    CheckBox50rub: TCheckBox;
    CheckBox100rub: TCheckBox;
    CheckBox500rub: TCheckBox;
    CheckBox1000rub: TCheckBox;
    CheckBox5000rub: TCheckBox;
    ButtonSave: TButton;
    ButtonClose: TButton;
    SaveDialog1: TSaveDialog;
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormConfig: TFormConfig;

implementation

{$R *.dfm}

procedure TFormConfig.ButtonCloseClick(Sender: TObject);
begin
 FormConfig.Close
end;

procedure TFormConfig.ButtonSaveClick(Sender: TObject);
begin
   XMLDoc.Active := true;
   XMLDoc.SaveToFile('config.xml');
end;

end.
