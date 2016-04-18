{*******************************************************}
{                                                       }
{           ������ ��� ������ � ����������������        }
{            �� ��������� CCNET                         }
{                                                       }
{           ����� : ������� �.�. ����� 11.12.2010       }
{            �� ��� �������� info@youfreedom.ru         }
{                                                       }
{*******************************************************}

unit UCashCode;

interface

//���� ������ ������� �� 100 �� 199
//100 - ������ ��� �����
//101 - ������ ������ ����������
//102 - ������ �������������
//103 - ������ ��������� �������
//104 - ������ ��������� ������ ����������� �����
//105 - ������ ��������� �����������
//106 - ������ ������ ������
//107 - ������ ��������� ������
//108 - ������ ASC
//109 - ������ NSC
//110 - ������ ������ ����������

//���� ��������������� ��������� �������� �� 200 �� 299
//201 - �����
//202 - NSC
//203 - ASC
//204 - �����
//205 - �������
//206 - ��������� ���������� �����
//207 - ������ ����� ������
//208 - ������� ������
//209 - �������������
//210 - ������ ����������
//211 - �������� ASC
//212 - �������� NSC
//213 - ��������� ������� ����� ������
//214 - �������������
//215 - �������� ������ ������
//216 - ������
//217 - ����������, ������ �������������
//218 - ������ �������
//219 - ������� �����������
//220 - ������ ������
//221 - ������ ������
//222 - ������ !!!! ������ !!!
//223 - ���� ������������
//224 - Stack_motor_falure
//225 - Transport_speed_motor_falure
//226 - Transport-motor_falure
//227 - Aligning_motor_falure
//228 - Initial_cassete_falure
//229 - Optical_canal_falure
//230 - Magnetical_canal_falure
//231 - Capacitance_canal_falure
//232 - ����� �� ������
//233 - Insertion_error
//234 - Dielectric_error
//235 - Previously_inserted_bill_remains_in_head
//236 - Compensation__factor_error
//237 - Bill_transport_error
//238 - Identification_error
//239 - Verification_error
//240 - Optic_sensor_error
//241 - Return_by_inhibit_error
//242 - Capacistance_error
//243 - Operation_error
//244 - Length_error
//245 - �������
//246 - �������
//247 - ������� ������ �����
//248 - ������� ������
//249 - ��������� ������ �� �������� ������ ������


const
  POLYNOM = $08408;

  //2 ��� - 10 ������
  //3 ��� - 50 ������
  //4 ��� - 100 ������
  //5 ��� - 500 ������
  //6 ��� - 1000 ������
  //7 ��� - 5000 ������

  B10   =   4;  //00000100
  B50   =   8;  //00001000
  B100  =   16; //00010000
  B500  =   32; //00100000
  B1000 =   64; //01000000
  B5000 =   128;//10000000

type

  Tnominal = record
    B10:Boolean;
    B50:Boolean;
    B100:Boolean;
    B500:Boolean;
    B1000:Boolean;
    B5000:Boolean;
  end;

  TProcessMessage = procedure(Error:integer;Mess:string) of object;
  TPollingBill    = procedure(Nominal:word;var CanLoop:boolean) of object;

  TCashCodeBillValidatorCCNET = class(TObject)
    constructor Create();
    destructor Destroy(); override;
  private
    FComFile  : THandle;  // ��������� �� com ����
    FProcessMesage:TProcessMessage;
    FPolingBill:TPollingBill;
    FCanPollingLoop:Boolean; // ������� ����� ������
    FNamberComPort:Byte;
    FComConnected:Boolean;
    FCommand:Array[0..255] of Byte; //�������
    FLengthCommand:Byte;
    FAnswer:Array[0..255] of Byte;  //�����
    FLengthAnswer:Byte;
    FData:Array[0..255] of Byte;    //������ ������
    FLengthData:Byte;
    procedure ProcessMessage(CodeMess:integer;Mess:string);
    procedure PolingBill(Nominal:word;var CanLoop:boolean);
    //���������� �������������� �������
    procedure ProcessComand();
    // ������������ �������
    procedure SendPacket(Command:Byte;Data:Array of Byte);
    //������ �������
    procedure ParseAnswer();
    // ������� �������
    procedure ClearCommand();
    // ������� ������
    procedure ClearAnswer();
    // ������� ������
    procedure ClearData();
  public
    //������������� com �����
    function OpenComPort:Boolean;
    // ��������� ��� ����
    procedure CloseComPort();

    // �������� ������� ����������
    function Reset():Boolean; // ����� ������-���������
    function Identification(var Name,Namber:string):Boolean;   //����� � �������� ���������������
    function GetStatus(var Nominal,Security:TNominal):Boolean; //��������� ������ ����������� �����
    function EnableBillTypes(Nominal:TNominal):Boolean;        //��������� ���������� �����
    function SetSecurity(Nominal:TNominal):Boolean;            //��������� ����������� �������� ��� ������������ �����
    function Stack():Boolean;                                  //��������� ������ ESCROW �����
    function Return():Boolean;                                 //������� ������   ESCROW �����
    function SendASC():Boolean;                                //������������ ���������
    function SendNSC():Boolean;                                //�� ������������� ���������
    function Poll():boolean;                                   //����� ����������
    function PollingLoop(Sum:word;TimeLoop:LongWord):Word;

    // �������� ��� ��������� ������ ��� �����
    property NamberComPort:Byte read FNamberComPort write FNamberComPort;
    // ������� ��� ����� ����������
    property OnProcessMessage:TProcessMessage read FProcessMesage write FProcessMesage;
    // ������� ��������� ���������� � ��� ������
    property ComConnected:Boolean read FComConnected;
    // ������� ����������� ��� ������ ������, ����� ���������� CanLoop ����� �������� ������
    property OnPolingBill:TPollingBill read FPolingBill write FPolingBill;
    // �������� �����������/��������������� ���� ������
    property CanPollingLoop:Boolean read FCanPollingLoop write FCanPollingLoop;
  end;

function GetCRC16(InData: array of byte; DataLng: word): word;

// �������� ��������� ���� �� 1
function IsBitSet(Value: Byte; BitNum : byte): boolean;

// ��������� ��������� ���� � 1
function BitOn(const val: Byte; const TheBit: byte): Byte;

// ��������� ��������� ���� � 0
function BitOff(const val: Byte; const TheBit: byte): Byte;

implementation

{ TCashCodeBillValiddator }

Uses SysUtils,Windows,DateUtils;

procedure TCashCodeBillValidatorCCNET.ClearAnswer;
begin
  FillChar(FAnswer, SizeOf(FAnswer),0);
  FLengthAnswer:=0;
end;

procedure TCashCodeBillValidatorCCNET.ClearCommand;
begin
  FillChar(FCommand, SizeOf(FCommand),0);
  FLengthCommand:=0;
end;

procedure TCashCodeBillValidatorCCNET.ClearData;
begin
  FillChar(FData, SizeOf(FData),0);
  FLengthData:=0;
end;

procedure TCashCodeBillValidatorCCNET.CloseComPort();
begin
  if FComFile <> INVALID_HANDLE_VALUE
  then CloseHandle(FComFile);
  FComFile := INVALID_HANDLE_VALUE;
  FComConnected:=false;
end;

constructor TCashCodeBillValidatorCCNET.Create;
begin
  inherited;
end;

destructor TCashCodeBillValidatorCCNET.Destroy;
begin
  inherited;
  CloseComPort;
end;

function TCashCodeBillValidatorCCNET.OpenComPort: Boolean;
const
  RxBufferSize = 256;
  TxBufferSize = 256;
var
  DeviceName: array[0..80] of Char;
  DCB: TDCB;
  CommTimeouts: TCommTimeouts;
begin
  try
    result:=true; // ������� �� ������
    FComConnected:=True;

    if FNamberComPort = 0
    then raise Exception.Create('�� ����� ����� COM �����');

    StrPCopy(DeviceName, 'Com'+IntToStr(FNamberComPort)+':');
    FComFile := CreateFile(DeviceName, GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

    if FComFile = INVALID_HANDLE_VALUE
    then raise Exception.Create('�� ������� ������� COM ����');

    if not SetupComm(FComFile, RxBufferSize, TxBufferSize)
    then raise Exception.Create('�� ������� ������ ����� COM �����');

    if not GetCommState(FComFile, DCB)
    then raise Exception.Create('�� ������� ��������� ��������� COM �����');

    // ������ ��������� �����
    DCB.BaudRate:=9600;
    DCB.ByteSize:=8;
    DCB.Parity:=noparity;
    DCB.StopBits:=ONESTOPBIT;
    DCB.Flags:=DTR_CONTROL_ENABLE;

    if not SetCommState(FComFile, DCB)
    then raise Exception.Create('�� ������� ���������� ��������� COM �����');

    CommTimeouts.ReadIntervalTimeout         := 400;
    CommTimeouts.ReadTotalTimeoutMultiplier  := 0;
    CommTimeouts.ReadTotalTimeoutConstant    := 400;
    CommTimeouts.WriteTotalTimeoutMultiplier := 0;
    CommTimeouts.WriteTotalTimeoutConstant   := 400;

    if not SetCommTimeouts(FComFile, CommTimeouts)
    then raise Exception.Create('�� ������� ���������� �������� COM �����');

  except
    on E:Exception do
    begin
      result:=False;
      FComConnected:=False;
      ProcessMessage(100,E.Message);
    end;
  end;
end;

procedure TCashCodeBillValidatorCCNET.ParseAnswer;
var
  CRC16:array[0..1] of Byte;
  CRCWord:Word;
begin
  ClearData();
  if FLengthAnswer >= 6 then // ����������� ����� 6 �������� ��� ��� ������ �� ������ ������
  begin
    CRCWord:=GetCRC16(FAnswer,FLengthAnswer-2);   // ������� CRC ������
    CopyMemory(@CRC16,@CRCWord,2);
    if (CRC16[0] = FAnswer[FLengthAnswer-2]) and (CRC16[1] = FAnswer[FLengthAnswer-1])
    //����� ������ � CRC ������ � ������ 100 % ��� ������ �����, ������� �� � ����
    then
      begin
        // 5 ��� 1 ���� �������������, 1 ���� ������ �������, 1 ���� - ����� ������, 2 ���� - CRC
        CopyMemory(@FData,@FAnswer[3],FLengthAnswer-5);
        FLengthData:=FLengthAnswer-5;
      end
    else begin
           SendNSC(); // ������ ���� ��� �� �������� �������� �����
           raise Exception.Create('�� ������ CRC ������.');
         end;
  end
  else raise Exception.Create('�� ������ �����');
end;

procedure TCashCodeBillValidatorCCNET.PolingBill(Nominal: word;
  var CanLoop: boolean);
begin
  if Assigned(FPolingBill) then FPolingBill(Nominal, CanLoop);
end;

function TCashCodeBillValidatorCCNET.Poll: boolean;
begin
  try
   if not FComConnected then raise Exception.Create('COM ���� ������, ���������� ������� RESET �� ��������');
   SendPacket($33,[]);
   ProcessMessage(201,'->POLL');
   ProcessComand();
   result:=true;
  except
    on E:Exception do
    begin
      ProcessMessage(110,E.Message);
      result:=false;
    end;
  end;
end;

function TCashCodeBillValidatorCCNET.PollingLoop(Sum: word;
  TimeLoop: LongWord): Word;
var
  StartTime:TDateTime;
  FirsByte,SEcondByte:Byte;
  BillNominal:word;
begin
  result:= 0;
  StartTime:=Now(); // �������� ������� �����
  FCanPollingLoop:=true;
  while FCanPollingLoop do
  begin
    if Poll() then  // ���� ����� ������ �������
    begin
      FirsByte  :=FData[0];
      SEcondByte:=FData[1];

      case FirsByte of
        $10,$11,$12 : begin
                        ProcessMessage(213,'��������� ������� ����� ������');
                        FCanPollingLoop:=false;
                      end;
        $13:begin
              ProcessMessage(214,'�������������');
            end;
        $14:begin
              ProcessMessage(215,'�������� ������ ������');
            end;
        $15:begin
              ProcessMessage(216,'������');
            end;
        $19:begin
              ProcessMessage(217,'����������, ������ �������������');
            end;
        $41:begin
              ProcessMessage(218,'������ �������');
              Reset();
              FCanPollingLoop:=false;
            end;
        $42:begin
              ProcessMessage(219,'������� �����������');
              Reset();
              FCanPollingLoop:=false;
            end;
        $43:begin
              ProcessMessage(220,'������ ������');
              Reset();
              FCanPollingLoop:=false;
            end;
        $44:begin
              ProcessMessage(221,'������ ������ 0_o');
              Reset();
              FCanPollingLoop:=false;
            end;
        $45:begin
              ProcessMessage(222,'������ !!!! ������ !!!');
              Reset();
              FCanPollingLoop:=false;
            end;
        $47:begin
              ProcessMessage(223,'���� ������������');
              case SEcondByte of
                $50:ProcessMessage(224,'Stack_motor_falure');
                $51:ProcessMessage(225,'Transport_speed_motor_falure');
                $52:ProcessMessage(226,'Transport-motor_falure');
                $53:ProcessMessage(227,'Aligning_motor_falure');
                $54:ProcessMessage(228,'Initial_cassete_falure');
                $55:ProcessMessage(229,'Optical_canal_falure');
                $56:ProcessMessage(230,'Magnetical_canal_falure');
                $5F:ProcessMessage(231,'Capacitance_canal_falure');
              end;
            end;
        $1C:begin
              ProcessMessage(232,'����� �� ������');
              case SEcondByte of
                $60:ProcessMessage(233,'Insertion_error');
                $61:ProcessMessage(234,'Dielectric_error');
                $62:ProcessMessage(235,'Previously_inserted_bill_remains_in_head');
                $63:ProcessMessage(236,'Compensation__factor_error');
                $64:ProcessMessage(237,'Bill_transport_error');
                $65:ProcessMessage(238,'Identification_error');
                $66:ProcessMessage(239,'Verification_error');
                $67:ProcessMessage(240,'Optic_sensor_error');
                $68:ProcessMessage(241,'Return_by_inhibit_error');
                $69:ProcessMessage(242,'Capacistance_error');
                $6A:ProcessMessage(243,'Operation_error');
                $6C:ProcessMessage(244,'Length_error');
              end;
            end;
        $80:begin
              ProcessMessage(245,'�������'); // ������������ �� ����, ��� ��� �� ���� ������������� ����������, � ����� ���� ���� ��� �������
            end;
        $81:begin
              ProcessMessage(246,'�������');
              case SEcondByte of
                2:BillNominal:=10;
                3:BillNominal:=50;
                4:BillNominal:=100;
                5:BillNominal:=500;
                6:BillNominal:=1000;
                7:BillNominal:=5000;
              end;
              StartTime:=Now(); // ������� ����� �� �������� ��������� ������
              SendASC();        // ���������� �����
              result:=result+BillNominal;
              PolingBill(BillNominal,FCanPollingLoop);  // ����� ��������� � �������� ������
              if result>=Sum then
              begin
                FCanPollingLoop:=False;  //����� ���������, ����������� ��������
                ProcessMessage(247,'������� ������ �����');
              end;
            end;
        $82:begin
              ProcessMessage(248,'������� ������');
            end;
      end;
      Sleep(100);
    end;

    if SecondsBetween(Now(),StartTime)> TimeLoop then
    begin
      FCanPollingLoop:=false;
      ProcessMessage(249,'��������� ������ �� �������� ������ ������');
    end;
  end;
end;

procedure TCashCodeBillValidatorCCNET.ProcessComand;
var
  BytesWritten:Dword;
  BytesRead:Dword;
  Errs:Dword;
  ComStat:TComStat;   //��������� �����
begin
  //����� �������
  ClearCommError(FComFile,Errs,@ComStat);       //��������� ��������� �����
  if ComStat.cbInQue > 0 then  //� ����� ����� ��������� , ���������� ��������
  begin
    if not PurgeComm(FComFile, PURGE_TXCLEAR or PURGE_RXCLEAR) then
    raise Exception.Create('�� ������� �������� ����');
  end;

  if not WriteFile(FComFile, FCommand, FLengthCommand, BytesWritten, nil)
  then Exception.Create('�� ������� �������� ������� � ����');

  if BytesWritten <> FLengthCommand
  then Exception.Create('�� ������� �������� ������� � ���� �� �����');

  //������ �����
  if not ClearCommError(FComFile,Errs,@ComStat)
  then Exception.Create('�� ������� �������� ������ COM �����'); //��������� ��������� �����

  ClearAnswer();
  if not ReadFile(FComFile, FAnswer, SizeOf(FAnswer), BytesRead, nil)
  then Exception.Create('�� ������� ��������� ����� �� �����')
  else
    begin
      FLengthAnswer:=BytesRead;
      ParseAnswer();
    end;
end;

procedure TCashCodeBillValidatorCCNET.ProcessMessage(CodeMess: integer; Mess: string);
begin
  if Assigned(FProcessMesage) then FProcessMesage(CodeMess, Mess);
end;

function TCashCodeBillValidatorCCNET.Reset():Boolean;
begin
  try
   if not FComConnected then raise Exception.Create('COM ���� ������, ���������� ������� RESET �� ��������');
   SendPacket($30,[]);
   ProcessMessage(204,'->RESET');
   ProcessComand();

   if FData[0] = $FF then
   begin
     ProcessMessage(202,'<-NSC');
     raise Exception.Create('������� ������������� ����� (NAK)')
   end;

   if FData[0] = $00
   then ProcessMessage(203,'<-ASC');

   result:=true;
  except
    on E:Exception do
    begin
      ProcessMessage(101,E.Message);
      result:=false;
    end;
  end;
end;

function TCashCodeBillValidatorCCNET.Return: Boolean;
begin
  try
   if not FComConnected then raise Exception.Create('COM ���� ������, ���������� ������� RESET �� ��������');
   SendPacket($36,[]);
   ProcessMessage(205,'->RETURN');
   ProcessComand();
   result:=true;
  except
    on E:Exception do
    begin
      ProcessMessage(107,E.Message);
      result:=false;
    end;
  end;
end;

function TCashCodeBillValidatorCCNET.EnableBillTypes(
  Nominal: TNominal): Boolean;
var
  BillTypesByte:Byte;
begin
  try
   if not FComConnected then raise Exception.Create('COM ���� ������, ���������� ������� RESET �� ��������');

   BillTypesByte:=0;

   // ��������� ���� �����
   if Nominal.B10 then BillTypesByte:=BillTypesByte+B10;
   if Nominal.B50 then BillTypesByte:=BillTypesByte+B50;
   if Nominal.B100 then BillTypesByte:=BillTypesByte+B100;
   if Nominal.B500 then BillTypesByte:=BillTypesByte+B500;
   if Nominal.B1000 then BillTypesByte:=BillTypesByte+B1000;
   if Nominal.B5000 then BillTypesByte:=BillTypesByte+B5000;

   //����� �������� � ������� �����

   SendPacket($34,[0,0,BillTypesByte,0,0,0]);
   ProcessMessage(206,'->ENABLE BILL TYPES');
   ProcessComand();

   if FData[0] = $FF then
   begin
     ProcessMessage(202,'<-NSC');
     raise Exception.Create('������� ������������� ����� (NAK)')
   end;

   if FData[0] = $00
   then ProcessMessage(203,'<-ASC');

   result:=true;
  except
    on E:Exception do
    begin
      ProcessMessage(104,E.Message);
      result:=false;
    end;
  end;
end;

function TCashCodeBillValidatorCCNET.SetSecurity(Nominal: TNominal): Boolean;
var
  BillTypesByte:Byte;
begin
  try
   if not FComConnected then raise Exception.Create('COM ���� ������, ���������� ������� RESET �� ��������');

   BillTypesByte:=0;

   // ��������� ���� �����
   if Nominal.B10 then BillTypesByte:=BillTypesByte+B10;
   if Nominal.B50 then BillTypesByte:=BillTypesByte+B50;
   if Nominal.B100 then BillTypesByte:=BillTypesByte+B100;
   if Nominal.B500 then BillTypesByte:=BillTypesByte+B500;
   if Nominal.B1000 then BillTypesByte:=BillTypesByte+B1000;
   if Nominal.B5000 then BillTypesByte:=BillTypesByte+B5000;

   //����� �������� � ������� �����

   SendPacket($32,[0,0,BillTypesByte]);
   ProcessMessage(207,'->SET SECURITY');
   ProcessComand();

   if FData[0] = $FF then
   begin
     ProcessMessage(202,'<-NSC');
     raise Exception.Create('������� ������������� ����� (NAK)')
   end;

   if FData[0] = $00
   then ProcessMessage(203,'<-ASC');

   result:=true;
  except
    on E:Exception do
    begin
      ProcessMessage(105,E.Message);
      result:=false;
    end;
  end;
end;

function TCashCodeBillValidatorCCNET.Stack: Boolean;
begin
  try
   if not FComConnected then raise Exception.Create('COM ���� ������, ���������� ������� RESET �� ��������');
   SendPacket($35,[]);
   ProcessMessage(208,'->STACK');
   ProcessComand();
   result:=true;
  except
    on E:Exception do
    begin
      ProcessMessage(106,E.Message);
      result:=false;
    end;
  end;
end;

function TCashCodeBillValidatorCCNET.Identification(var Name,Namber:string):Boolean;
var
  i:integer;
begin
  try
   if not FComConnected then raise Exception.Create('COM ���� ������, ���������� ������� RESET �� ��������');
   SendPacket($37,[]);
   ProcessComand();
   ProcessMessage(209,'->IDENTIFICATION');
   //������� ���� �������� �� ������
   //15 ���� - ��������
   //12 ���� - �������� �����
   for I := 0 to FLengthData - 1 do
   begin
     if (I>=0) and (i<15) then Name:=Name+Chr(FData[I]);
     if (I>=15) and (i<27) then Namber:=Namber+Chr(FData[I]);
   end;
   result:=true;
  except
    on E:Exception do
    begin
      ProcessMessage(102,E.Message);
      result:=false;
    end;
  end;
end;

function TCashCodeBillValidatorCCNET.GetStatus(var Nominal,Security: Tnominal): Boolean;
begin
  try
   if not FComConnected then raise Exception.Create('COM ���� ������, ���������� ������� RESET �� ��������');
   SendPacket($31,[]);
   ProcessComand();
   ProcessMessage(210,'->GET STATUS');
   // �������� ������ ����������� �����
   // ����� �������� � ������� ����� � ��������� �������
   //2 ��� - 10 ������
   //3 ��� - 50 ������
   //4 ��� - 100 ������
   //5 ��� - 500 ������
   //6 ��� - 1000 ������
   //7 ��� - 5000 ������

   Nominal.B10 := IsBitSet(FData[2],2);
   Nominal.B50 := IsBitSet(FData[2],3);
   Nominal.B100 := IsBitSet(FData[2],4);
   Nominal.B500 := IsBitSet(FData[2],5);
   Nominal.B1000 := IsBitSet(FData[2],6);
   Nominal.B5000 := IsBitSet(FData[2],7);

   // �������� ������ ����� � ���������� ��������� ��� ������
   // ����� �������� � ������ ����� � ��������� �������
   //2 ��� - 10 ������
   //3 ��� - 50 ������
   //4 ��� - 100 ������
   //5 ��� - 500 ������
   //6 ��� - 1000 ������
   //7 ��� - 5000 ������

   Security.B10 := IsBitSet(FData[5],2);
   Security.B50 := IsBitSet(FData[5],3);
   Security.B100 := IsBitSet(FData[5],4);
   Security.B500 := IsBitSet(FData[5],5);
   Security.B1000 := IsBitSet(FData[5],6);
   Security.B5000 := IsBitSet(FData[5],7);

   result:=true;
  except
    on E:Exception do
    begin
      ProcessMessage(103,E.Message);
      result:=false;
    end;
  end;
end;

function TCashCodeBillValidatorCCNET.SendASC: Boolean;
begin
  try
   if not FComConnected then raise Exception.Create('COM ���� ������, ���������� ������� RESET �� ��������');
   SendPacket(0,[]);
   ProcessMessage(211,'->ASC');
   try
     ProcessComand();
   except
   end;
   result:=true;
  except
    on E:Exception do
    begin
      ProcessMessage(108,E.Message);
      result:=false;
    end;
  end;
end;

function TCashCodeBillValidatorCCNET.SendNSC: Boolean;
begin
  try
   if not FComConnected then raise Exception.Create('COM ���� ������, ���������� ������� RESET �� ��������');
   SendPacket($FF,[]);
   ProcessMessage(212,'->NSC');
   try
     ProcessComand();
   except
   end;

   result:=true;
  except
    on E:Exception do
    begin
      ProcessMessage(109,E.Message);
      result:=false;
    end;
  end;
end;

procedure TCashCodeBillValidatorCCNET.SendPacket(Command: Byte; Data: array of Byte);
var
  CRC16:array[0..1] of Byte;
  CRCWord:Word;
begin
  ClearCommand();

  FLengthCommand:=6+Length(Data);

  FCommand[0] := $02; // ����������������� ����
  FCommand[1] := $03; // ������ ����������
  FCommand[2] := FLengthCommand; //����� ����� ������ ������� CRC
  FCommand[3] := Command;   // �������

  if Length(Data) <> 0 // ���� ���� ������ ��� ��������
  then CopyMemory(@FCommand[4],@Data,Length(Data)); // ��������� �� ��� ������� � 5 �����

  CRCWord:=GetCRC16(FCommand,FLengthCommand-2);   // ������� CRC
  CopyMemory(@CRC16,@CRCWord,2);             // �������� CRC �� �����

  FCommand[FLengthCommand-2]:=CRC16[0];           // �������� ���� �������
  FCommand[FLengthCommand-1]:=CRC16[1];
end;

function GetCRC16(InData: array of byte; DataLng: word): word;
var
  i,TmpCRC: word;
  j: byte;
begin
  result:=0;
  for i:=0 to (DataLng-1) do
  begin
    TmpCRC:=result xor InData[i];
    for j:=0 to 7 do
    begin
      if (TmpCRC and $0001)<>0 then
      begin
        TmpCRC:=TmpCRC shr 1;
        TmpCRC:=TmpCRC xor POLYNOM;
      end
      else TmpCRC:=TmpCRC shr 1;
    end;
    result:=TmpCRC;
  end;
end;

function IsBitSet(Value: Byte; BitNum : byte): boolean;
begin
  result:=((Value shr BitNum) and 1) = 1
end;

function BitOn(const val: Byte; const TheBit: byte): Byte;
begin
  Result := val or (1 shl TheBit);
end;

function BitOff(const val: Byte; const TheBit: byte): Byte;
begin
  Result := val and ((1 shl TheBit) xor $FF);
end;

end.
