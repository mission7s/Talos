unit UnitTestTCPClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.SyncObjs,
  UnitTCPCommons, UnitTCPOut;

const
  CRLF = #13#10;
	ID_LEN = MAX_PATH;// 20;
	HOSTIP_LEN = 20;

type
  TSerialGate = packed record
    HostIP: array[0..HOSTIP_LEN] of Char;
    Port: Word;
    Mine: Boolean;
    Id: array[0..ID_LEN] of Char;
    Password: array[0..ID_LEN] of Char;
  end;

  TForm1 = class(TForm)
    mmRecv: TMemo;
    btn422: TButton;
    btnLoginID: TButton;
    btn485e: TButton;
    btnConnect: TButton;
    btnReadBufferSize: TButton;
    btnPassword: TButton;
    btnDefApply: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLoginIDClick(Sender: TObject);
    procedure btn422Click(Sender: TObject);
    procedure btn485eClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnReadBufferSizeClick(Sender: TObject);
    procedure btnPasswordClick(Sender: TObject);
    procedure btnDefApplyClick(Sender: TObject);
  private
    { Private declarations }
    FTCPOut: TTCPOut;

    FRecvCritSec: TCriticalSection;
    FRecvBuffer: AnsiString;

    FSerialGate: TSerialGate;

    FStrConnect: AnsiString;
    FStrLogin: AnsiString;
    FStrPrompt: AnsiString;

    procedure TCPOutRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.TCPOutRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
begin
  FRecvCritSec.Enter;
  try
    mmRecv.Lines.Add(AData);
    mmRecv.Lines.Add(Format('Data size = %d', [ADataSize]));
//    mmRecv.Lines.Add(Format('Data size = %d', [ADataSize]));
//  mmRecv.Lines.Add(Format('Remain size = %d', [FTCPOut.ReadBufferSize]));
//  exit;
    if (ADataSize <= 0) then exit;

    FRecvBuffer := FRecvBuffer + AData;
//    if Length(FRecvBuffer) < 1 then exit;

//    mmRecv.Lines.Add(FRecvBuffer);
//    mmRecv.Lines.Add(Format('Data size = %d', [ADataSize]));

      if (CompareStr(FRecvBuffer, FStrConnect) = 0) then
      begin
        FRecvBuffer := '';
      end
      else if (CompareStr(FRecvBuffer, FStrLogin) = 0) then
      begin
        FRecvBuffer := '';
      end
      else if (CompareStr(Copy(FRecvBuffer, Length(FRecvBuffer) - Length(FStrPrompt) + 1,  Length(FStrPrompt)), FStrPrompt) = 0) then
      begin
        FRecvBuffer := '';
//      end
//      else if (CompareStr(FRecvBuffer, FStrSave) = 0) then
//      begin
//        FRecvBuffer := '';
//        end;
      end;
  finally
    FRecvCritSec.Leave;
  end;
//  Sleep(1000);
//  mmRecv.Lines.Add(Format('Remain size = %d', [FTCPOut.ReadBufferSize]));
end;

procedure TForm1.btn485eClick(Sender: TObject);
begin
  FTCPOut.Send('def porrt all interface rs485e' + CRLF);
end;

procedure TForm1.btn422Click(Sender: TObject);
begin
  FTCPOut.Send('def porrt all interface rs422' + CRLF);
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  FTCPOut := TTCPOut.Create;
  FTCPOut.HostIP := String(FSerialGate.HostIP);
  FTCPOut.Port := FSerialGate.Port;
  FTCPOut.AsyncMode := True;
  FTCPOut.OnTCPRead := TCPOutRead;
  FTCPOut.Start;
end;

procedure TForm1.btnDefApplyClick(Sender: TObject);
begin
  FTCPOut.Send('def apply' + CRLF);
end;

procedure TForm1.btnLoginIDClick(Sender: TObject);
begin
  FTCPOut.Send(FSerialGate.Id + CRLF);
end;

procedure TForm1.btnPasswordClick(Sender: TObject);
begin
  FTCPOut.Send(FSerialGate.Password + CRLF);
end;

procedure TForm1.btnReadBufferSizeClick(Sender: TObject);
begin
  mmRecv.Lines.Add(Format('%d', [FTCPOut.ReadBufferSize]));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FRecvCritSec := TCriticalSection.Create;

  StrPCopy(FSerialGate.HostIP, '10.40.10.13');
  FSerialGate.Port := 23;
  StrPCopy(FSerialGate.Id, 'serialgate');
  StrPCopy(FSerialGate.Password, '99999999');

  FStrConnect := #$FF'?'#$FF'?'#$FF'?'#$FF'?'#$D#$D#$A'SerialGate login: ';
  FStrLogin   := AnsiString(FSerialGate.Id) + #$D#$A'Password: ';
  FStrPrompt := '# ';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if (FTCPOut <> nil)  then
  begin
    FTCPOut.Close;
    FreeAndNil(FTCPOut);
  end;

  FreeAndNil(FRecvCritSec);
end;

end.
