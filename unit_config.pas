unit unit_config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, xmldom, XMLIntf, msxmldom, XMLDoc, StdCtrls, ExtCtrls;

type
  TFormConfig = class(TForm)
    XMLDocument1: TXMLDocument;
    GroupBoxCash: TGroupBox;
    CheckBox10rub: TCheckBox;
    CheckBox50rub: TCheckBox;
    CheckBox100rub: TCheckBox;
    CheckBox500rub: TCheckBox;
    CheckBox1000rub: TCheckBox;
    CheckBox5000rub: TCheckBox;
    ButtonSave: TButton;
    ButtonClose: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormConfig: TFormConfig;

implementation

{$R *.dfm}

end.
