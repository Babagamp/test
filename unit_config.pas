unit unit_config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, xmldom, XMLIntf, msxmldom, XMLDoc;

type
  TFormConfig = class(TForm)
    XMLDocument1: TXMLDocument;
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
