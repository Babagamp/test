unit unit_config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, xmldom, XMLIntf, msxmldom, XMLDoc, StdCtrls, ExtCtrls, DB,
  DBClient;

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
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
   var i: integer;
begin
   XMLDoc.Active := true;

   XMLDoc.Version := '1.0';
   XMLDoc.Encoding := 'windows-1251';
   XMLDoc.AddChild('config_cash');
   For i:=0 to GroupBoxCash.ControlCount - 1 do
    Begin
     XMLDoc.ChildNodes['config_cash'].AddChild(GroupBoxCash.Controls[i].Name);
     XMLDoc.ChildNodes['config_cash'].ChildValues[GroupBoxCash.Controls[i].Name] := (GroupBoxCash.Controls[i] as TCheckBox).Checked;
    end;
   XMLDoc.SaveToFile('config.xml');
   XMLDoc.Active := false;
   //XMLDoc.CleanupInstance;
end;

procedure TFormConfig.FormCreate(Sender: TObject);
 var i: integer;

begin
  If FileExists('config.xml') then
  Begin
    XMLDoc.Active := true;
    XMLDoc.LoadFromFile('config.xml');
    For i := 0 to XMLDoc.ChildNodes['config_cash'].ChildNodes.Count-1 do
      Begin
        (GroupBoxCash.Controls[i] as TCheckBox).Checked := XMLDoc.ChildNodes['config_cash'].ChildNodes[(GroupBoxCash.Controls[i] as TCheckBox).Name].NodeValue;
      End;
    XMLDoc.Active := false;
    XMLDoc.CleanupInstance;
  end
  else
    FormConfig.ButtonSaveClick(Sender);
end;

end.
