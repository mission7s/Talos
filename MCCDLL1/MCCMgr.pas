unit MCCMgr;

interface

uses System.Classes, Winapi.Windows, System.SysUtils, Vcl.Dialogs, System.SyncObjs,
  Generics.Collections,
  UnitCommons, UnitTypeConvert,
  UnitUDPIn, UnitUDPOut;

type
  TMCCEventNotifyThread = class;

  TMCCMgr = class(TComponent)
  private
    FUDPSysIn: TUDPIn;
    FUDPSysOut: TUDPOut;

    FSysCMD1, FSysCMD2: Byte;
    FSysSyncMsgEvent: THandle;
    FSysRecvBuffer: AnsiString;
    FSysRecvData: AnsiString;
    FSysLastResult: Integer;
    FSysTimeout: Cardinal;

    FUDPNotify: TUDPIn;
    FUDPIn: TUDPIn;
    FUDPOut: TUDPOut;

    FCMD1, FCMD2: Byte;
    FSyncMsgEvent: THandle;
    FRecvBuffer: AnsiString;
    FRecvData: AnsiString;
    FLastResult: Integer;
    FTimeout: Cardinal;

    FNotifyBuffer: AnsiString;
    FNotifyData: AnsiString;

    FSysCommandCritSec: TCriticalSection;

    FSysInCritSec: TCriticalSection;

    FCommandCritSec: TCriticalSection;

    FNotifyCritSec: TCriticalSection;
    FInCritSec: TCriticalSection;

    FEventNotifyThread: TMCCEventNotifyThread;

    function SendSysCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
    function SendCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;

    procedure UDPSysInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
    procedure UDPNotifyRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
    procedure UDPInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CheckSum(AValue: AnsiString): Boolean;

    function TransmitSysCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
    function TransmitCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;

    // 0X00 System Control
    function SysIsAlive(AIP: PChar; var AIsAlive: Boolean): Integer;                                                 // 0X00.00

    // 0X10 Immediate Control

    // 0X20 Preset/Select Commands

    // 0X30 Sense Queries

    // 0X40 Cuesheet Control
    function BeginUpdate(AIP: PChar; AChannelID: Word): Integer;                                                       // 0X40.00
    function EndUpdate(AIP: PChar; AChannelID: Word): Integer;                                                         // 0X40.01

    function SetDeviceCommError(AIP: PChar; ADeviceStatus: TDeviceStatus; ADeviceName: PChar): Integer;                                              // 0X40.02
    function SetDeviceStatus(AIP: PChar; ADCSID: Word; ADeviceHandle: TDeviceHandle; ADeviceStatus: TDeviceStatus): Integer; // 0X40.03

    function SetOnAir(AIP: PChar; AChannelID: Word; AIsOnAir: Boolean): Integer;                                       // 0X40.10
    function SetEventStatus(AIP: PChar; AEventID: TEventID; AEventStatus: TEventStatus): Integer;                      // 0X40.11
    function SetMediaStatus(AIP: PChar; AEventID: TEventID; AMediaStatus: TMediaStatus): Integer;                       // 0X40.12
    function SetTimelineRange(AIP: PChar; AChannelID: Word; AStartDate, AEndDate: TDateTime): Integer;                 // 0X40.13

    function InputCueSheet(AIP: PChar; AIndex: Integer; ACueSheetItem: TCueSheetItem): Integer;                        // 0X40.20
    function DeleteCueSheet(AIP: PChar; AEventID: TEventID): Integer;                                                  // 0X40.21
    function ClearCueSheet(AIP: PChar; AChannelID: Word): Integer;                                                     // 0X40.22

    function SetCueSheetCurr(AIP: PChar; AEventID: TEventID): Integer;                                                 // 0X40.30
    function SetCueSheetNext(AIP: PChar; AEventID: TEventID): Integer;                                                 // 0X40.31
    function SetCueSheetTarget(AIP: PChar; AEventID: TEventID): Integer;                                               // 0X40.32

    property UDPNotify: TUDPIn read FUDPNotify write FUDPNotify;
    property UDPIn: TUDPIn read FUDPIn write FUDPIn;
    property UDPOut: TUDPOut read FUDPOut write FUDPOut;

    property Timeout: Cardinal read FTimeout write FTimeout;

    property UDPSysIn: TUDPIn read FUDPSysIn write FUDPSysIn;
    property UDPSysOut: TUDPOut read FUDPSysOut write FUDPSysOut;
    property SysTimeout: Cardinal read FSysTimeout write FSysTimeout;
  end;

  TMCCEventNotifyThread = class(TThread)
  private
    FMCCMgr: TMCCMgr;
    FExecuteEvent: THandle;
    FEventID: TEventID;
    FEventStatus: TEventStatus;

    procedure DoControl;
  protected
    procedure Execute; override;
  public
    constructor Create(AMCCMgr: TMCCMgr); virtual;
    destructor Destroy; override;

    procedure SetEventStatus(AEventID: TEventID; AEventStatus: TEventStatus);
  end;

var
  VMCCMgr: TMCCMgr;

implementation

uses DLLConsts;

constructor TMCCMgr.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // System control
  FSysCommandCritSec := TCriticalSection.Create;

  FSysInCritSec := TCriticalSection.Create;

  FUDPSysIn := TUDPIn.Create;
  FUDPSysIn.OnUDPRead := UDPSysInRead;

  FUDPSysOut := TUDPOut.Create;

  FSysCMD1 := $00;
  FSysCMD2 := $00;

  FSysSyncMsgEvent := CreateEvent(nil, True, False, nil);

  FSysTimeout := TIME_OUT;

  // Event control
  FCommandCritSec := TCriticalSection.Create;

  FNotifyCritSec := TCriticalSection.Create;
  FInCritSec := TCriticalSection.Create;

  FUDPNotify := TUDPIn.Create;
  FUDPNotify.OnUDPRead := UDPNotifyRead;

  FUDPIn := TUDPIn.Create;
  FUDPIn.OnUDPRead := UDPInRead;

  FUDPOut := TUDPOut.Create;

  FCMD1 := $00;
  FCMD2 := $00;

  FSyncMsgEvent := CreateEvent(nil, True, False, nil);

  FTimeout := TIME_OUT;

  FEventNotifyThread := TMCCEventNotifyThread.Create(Self);
  FEventNotifyThread.Start;
end;

destructor TMCCMgr.Destroy;
var
  I: Integer;
begin
  if Assigned(FEventNotifyThread) then
  begin
    FEventNotifyThread.Terminate;
    FreeAndNil(FEventNotifyThread);
  end;

  CloseHandle(FSyncMsgEvent);

  FreeAndNil(FUDPNotify);
  FreeAndNil(FUDPIn);
  FreeAndNil(FUDPOut);

  CloseHandle(FSysSyncMsgEvent);

  FreeAndNil(FUDPSysIn);
  FreeAndNil(FUDPSysOut);

  FreeAndNil(FCommandCritSec);

  FreeAndNil(FNotifyCritSec);
  FreeAndNil(FInCritSec);

  FreeAndNil(FSysCommandCritSec);

  FreeAndNil(FSysInCritSec);

  inherited Destroy;
end;

function TMCCMgr.SendSysCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
var
  Buffer: AnsiString;
  CheckSum: Byte;
  I: integer;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_STX) + WordToAnsiString($02 + ADataSize) + AnsiChar(ACMD1) + AnsiChar(ACMD2) + ADataBuf;

  CheckSum := ACMD1 + ACMD2;
  for I := 1 to ADataSize do
    CheckSum := CheckSum + Ord(ADataBuf[I]);

  CheckSum := 0 - CheckSum;
  Buffer := Buffer + AnsiChar(CheckSum);

  FUDPSysOut.Send(AIP, APort, Buffer);

  Result := D_OK;
end;

function TMCCMgr.SendCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
var
  Buffer: AnsiString;
  CheckSum: Byte;
  I: integer;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_STX) + WordToAnsiString($02 + ADataSize) + AnsiChar(ACMD1) + AnsiChar(ACMD2) + ADataBuf;

  CheckSum := ACMD1 + ACMD2;
  for I := 1 to ADataSize do
    CheckSum := CheckSum + Ord(ADataBuf[I]);

  CheckSum := 0 - CheckSum;
  Buffer := Buffer + AnsiChar(CheckSum);

//  FUDPOut.Send(AHost, APort, Buffer);
  FUDPOut.Send(AIP, APort, Buffer);

  Result := D_OK;
end;

function TMCCMgr.CheckSum(AValue: AnsiString): Boolean;
var
  I, Len: Integer;
  CRC: Byte;
begin
  Result := False;

  Len := Length(AValue);
  CRC := 0;

  if (Len >= 5) then
  begin
    for I := 4 to Len - 1 do
      CRC := CRC + Ord(AValue[I]);
    CRC := not (CRC) + 1;

    Result := (CRC = Ord(AValue[Len]));
  end;
end;

function TMCCMgr.TransmitSysCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
var
  R: DWORD;
begin
  Result := D_FALSE;

  ResetEvent(FSysSyncMsgEvent);
  FSysRecvBuffer := '';
  FSysRecvData := '';

  FSysCMD1 := ACMD1;
  FSysCMD2 := ACMD2;

  FSysCommandCritSec.Enter;
  try
    if (SendSysCommand(AIP, APort, ACMD1, ACMD2, ADataBuf, ADataSize) = NOERROR) then
    begin
      R := WaitForSingleObject(FSysSyncMsgEvent, FSysTimeout);
      case R of
        WAIT_OBJECT_0:
          begin
            Result := FSysLastResult;
          end;
        else Result := E_TIMEOUT;
       end;
    end;
  finally
    FSysCommandCritSec.Leave;
  end;
end;

function TMCCMgr.TransmitCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
var
  R: DWORD;
begin
  Result := S_FALSE;

  ResetEvent(FSyncMsgEvent);
  FRecvBuffer := '';
  FRecvData := '';

  FCMD1 := ACMD1;
  FCMD2 := ACMD2;

  FCommandCritSec.Enter;
  try
    if (SendCommand(AIP, APort, ACMD1, ACMD2, ADataBuf, ADataSize) = NOERROR) then
    begin
      R := WaitForSingleObject(FSyncMsgEvent, FTimeout);
      case R of
        WAIT_OBJECT_0:
          begin
            Result := FLastResult;
          end;
        else Result := E_TIMEOUT;
       end;
    end;
  finally
    FCommandCritSec.Leave;
  end;
end;

function WriteLog(Log: AnsiString): Integer;
var
  FilePath, FileName: AnsiString;
  FileStream: TFileStream;
  S: AnsiString;
  F: TextFile;
begin
  Result := -1;

  FilePath := 'C:\01';
  FileName := FilePath + '\' + '01.log';

  // 디렉토리 있는지 확인 없으면 생성
  if not DirectoryExists(FilePath) then ForceDirectories(FilePath);

  S := FormatDateTime('[hh:nn:ss:zzz]', Now);
  S := S + ' ' + Log;
  try
    AssignFile(F, FileName);
    if FileExists(FileName) then Append(F)
    else Rewrite(F);
    Writeln(F, S);
  finally
    Closefile(F);
  end;
end;

procedure TMCCMgr.UDPSysInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
var
  ByteCount: Integer;
  CMD1, CMD2: Byte;
  Device: TDeviceHandle;
begin
  FSysInCritSec.Enter;
  try
    if (ADataSize <= 0) then exit;
    FSysRecvBuffer := FSysRecvBuffer + AData;

    if (Length(FSysRecvBuffer) < 1) then exit;

    case Ord(FSysRecvBuffer[1]) of
      $02:
        begin
          if (Length(FSysRecvBuffer) < 3) then exit;

          ByteCount := PAnsiCharToWord(@FSysRecvBuffer[2]);
          if (Length(FSysRecvBuffer) = ByteCount + 4) then
          begin
            if (CheckSum(FSysRecvBuffer)) then
            begin
              CMD1 := Ord(FSysRecvBuffer[4]);
              CMD2 := Ord(FSysRecvBuffer[5]);

              FSysRecvData := System.Copy(FSysRecvBuffer, 6, ByteCount - 2);

              if (CMD1 = FSysCMD1) and (CMD2 = FSysCMD2 + $80)  then
                FSysLastResult := D_OK
              else
                FSysLastResult := D_FALSE;
            end
            else
              FSysLastResult := E_NAK_CHECKSUM;

            SetEvent(FSysSyncMsgEvent);

  //          if (Length(FSysRecvBuffer) > ByteCount + 4) then
  //            FSysRecvBuffer := Copy(FSysRecvBuffer, ByteCount + 5, Length(FSysRecvBuffer))
  //          else
              FSysRecvBuffer := '';
          end
          else if (ByteCount <= 0) or (Length(FSysRecvBuffer) > ByteCount + 4) then
          begin
            FSysLastResult := D_FALSE;
            SetEvent(FSysSyncMsgEvent);
            FSysRecvBuffer:= '';
          end;
        end;
      $04: // ACK
        begin
          FSysLastResult := D_OK;
          SetEvent(FSysSyncMsgEvent);
          FSysRecvBuffer := '';
        end;
      $05: // NAK
        begin
          if Length(FSysRecvBuffer) < 2 then exit;
          if (Ord(FSysRecvBuffer[2]) and E_NAK_UNDEFINED) > 0 then FSysLastResult := E_NAK_UNDEFINED
          else if (Ord(FSysRecvBuffer[2]) and E_NAK_SYNTAX) > 0 then FSysLastResult := E_NAK_SYNTAX
          else if (Ord(FSysRecvBuffer[2]) and E_NAK_CHECKSUM) > 0 then FSysLastResult := E_NAK_CHECKSUM
          else if (Ord(FSysRecvBuffer[2]) and E_NAK_PARITY) > 0 then FSysLastResult := E_NAK_PARITY
          else if (Ord(FSysRecvBuffer[2]) and E_NAK_OVERRUN) > 0 then FSysLastResult := E_NAK_OVERRUN
          else if (Ord(FSysRecvBuffer[2]) and E_NAK_FRAMING) > 0 then FSysLastResult := E_NAK_FRAMING
          else if (Ord(FSysRecvBuffer[2]) and E_NAK_TIMEOUT) > 0 then FSysLastResult := E_NAK_TIMEOUT
          else FSysLastResult := E_NAK_IGNORED;
          SetEvent(FSysSyncMsgEvent);
          FSysRecvBuffer := '';
        end;
      $06: // Error
        begin
          if Length(FSysRecvBuffer) < 5 then exit;
          FSysLastResult := PAnsiCharToInt(@FSysRecvBuffer[2]);
          SetEvent(FSysSyncMsgEvent);
          FSysRecvBuffer := '';
        end;
      else
        begin
          FSysLastResult := D_FALSE;
          SetEvent(FSysSyncMsgEvent);
          FSysRecvBuffer := '';
        end;
    end;
  finally
    FSysInCritSec.Leave;
  end;
end;

procedure TMCCMgr.UDPNotifyRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
{const
  EventStatusNames: array[TEventStatus] of AnsiString =
    ('', 'Error', 'Skipped', 'Idle', 'Loading', 'Loaded', 'Cueing', 'Cued',
     'StandByOff', 'StandByOn', 'Preroll', 'OnAir',
     'Finish', 'Finishing', 'Finished', 'Done'); }
var
  ByteCount: Integer;
  CMD1, CMD2: Byte;
  NameLen: Integer;
  DeviceHandle: TDeviceHandle;
  EventID: TEventID;
  DeviceStatus: TDeviceStatus;
  EventStatus: TEventStatus;

  ChannelID: Word;
  EventOverall: TEventOverall;
begin
  FNotifyCritSec.Enter;
  try
    if (ADataSize <= 0) then exit;
    FNotifyBuffer := FNotifyBuffer + AData;

    if (Length(FNotifyBuffer) < 1) then exit;

    case Ord(FNotifyBuffer[1]) of
      $02:
      begin
        if (Length(FNotifyBuffer) < 3) then exit;

        ByteCount := PAnsiCharToWord(@FNotifyBuffer[2]);
        if (Length(FNotifyBuffer) = ByteCount + 4) then
        begin
          if (CheckSum(FNotifyBuffer)) then
          begin
            CMD1 := Ord(FNotifyBuffer[4]);
            CMD2 := Ord(FNotifyBuffer[5]);
            FNotifyData := System.Copy(FNotifyBuffer, 6, ByteCount - 2);

            case CMD1 of
              $00:
            end;
          end
          else
            FLastResult := E_NAK_CHECKSUM;

          FNotifyBuffer := '';
        end
        else if ((ByteCount <= 0) or (Length(FNotifyBuffer) > ByteCount + 4)) then
        begin
          FNotifyBuffer := '';
        end;
      end;
      else
      begin
        FNotifyBuffer := '';
      end;
    end;
  finally
    FNotifyCritSec.Leave;
  end;
end;

procedure TMCCMgr.UDPInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
var
  ByteCount: Integer;
  CMD1, CMD2: Byte;
  Device: TDeviceHandle;
begin
  FInCritSec.Enter;
  try
    if (ADataSize <= 0) then exit;
    FRecvBuffer := FRecvBuffer + AData;

    if (Length(FRecvBuffer) < 1) then exit;

    case Ord(FRecvBuffer[1]) of
      $02:
        begin
          if (Length(FRecvBuffer) < 3) then exit;

          ByteCount := PAnsiCharToWord(@FRecvBuffer[2]);
          if (Length(FRecvBuffer) >= ByteCount + 4) then
          begin
            if (CheckSum(FRecvBuffer)) then
            begin
              CMD1 := Ord(FRecvBuffer[4]);
              CMD2 := Ord(FRecvBuffer[5]);

              FRecvData := System.Copy(FRecvBuffer, 6, ByteCount - 2);

              if (CMD1 = FCMD1) and (CMD2 = FCMD2 + $80)  then
                FLastResult := D_OK
              else
                FLastResult := D_FALSE;
            end
            else
              FLastResult := E_NAK_CHECKSUM;

            SetEvent(FSyncMsgEvent);

            if (Length(FRecvBuffer) > ByteCount + 4) then
              FRecvBuffer := Copy(FRecvBuffer, ByteCount + 5, Length(FRecvBuffer))
            else
              FRecvBuffer := '';
          end;
  {        else
          begin
            FLastResult := D_FALSE;
            SetEvent(FSyncMsgEvent);
            FRecvBuffer := '';
          end; }
        end;
      $04: // ACK
        begin
          FLastResult := D_OK;
          SetEvent(FSyncMsgEvent);
          FRecvBuffer := '';
        end;
      $05: // NAK
        begin
          if Length(FRecvBuffer) < 2 then exit;
          if (Ord(FRecvBuffer[2]) and E_NAK_UNDEFINED) > 0 then FLastResult := E_NAK_UNDEFINED
          else if (Ord(FRecvBuffer[2]) and E_NAK_SYNTAX) > 0 then FLastResult := E_NAK_SYNTAX
          else if (Ord(FRecvBuffer[2]) and E_NAK_CHECKSUM) > 0 then FLastResult := E_NAK_CHECKSUM
          else if (Ord(FRecvBuffer[2]) and E_NAK_PARITY) > 0 then FLastResult := E_NAK_PARITY
          else if (Ord(FRecvBuffer[2]) and E_NAK_OVERRUN) > 0 then FLastResult := E_NAK_OVERRUN
          else if (Ord(FRecvBuffer[2]) and E_NAK_FRAMING) > 0 then FLastResult := E_NAK_FRAMING
          else if (Ord(FRecvBuffer[2]) and E_NAK_TIMEOUT) > 0 then FLastResult := E_NAK_TIMEOUT
          else FLastResult := E_NAK_IGNORED;
          SetEvent(FSyncMsgEvent);
          FRecvBuffer := '';
        end;
      $06: // Error
        begin
          if Length(FRecvBuffer) < 5 then exit;
          FLastResult := PAnsiCharToInt(@FRecvBuffer[2]);
          SetEvent(FSyncMsgEvent);
          FRecvBuffer := '';
        end;
      else
      begin
        FLastResult := D_FALSE;
        SetEvent(FSyncMsgEvent);
        FRecvBuffer := '';
      end;
    end;
  finally
    FInCritSec.Leave;
  end;
end;

// 0X00 System Control
function TMCCMgr.SysIsAlive(AIP: PChar; var AIsAlive: Boolean): Integer;
var
  Buffer: AnsiString;
begin
  AIsAlive := False;

  Buffer := '';
  Result := TransmitSysCommand(AIP, FUDPSysOut.Port, $00, $00, Buffer, Length(Buffer));
  if (Result = D_OK) then
  begin
    if (Length(FSysRecvData) < 1) then exit;
    AIsAlive := PAnsiCharToBool(@FSysRecvData[1]);
  end;
end;

// 0X10 Immediate Control

// 0X20 Preset/Select Commands

// 0X30 Sense Queries

// 0X40 Event Control
function TMCCMgr.BeginUpdate(AIP: PChar; AChannelID: Word): Integer;
var
  Buffer: AnsiString;
begin
  Buffer := WordToAnsiString(AChannelID);
  Result := TransmitCommand(AIP, FUDPOut.Port, $40, $00, Buffer, Length(Buffer));
end;

function TMCCMgr.EndUpdate(AIP: PChar; AChannelID: Word): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := WordToAnsiString(AChannelID);
  Result := TransmitCommand(AIP, FUDPOut.Port, $40, $01, Buffer, Length(Buffer));
end;

function TMCCMgr.SetDeviceCommError(AIP: PChar; ADeviceStatus: TDeviceStatus; ADeviceName: PChar): Integer;
var
  Buffer, Data: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data, SizeOf(TDeviceStatus));
  Move(ADeviceStatus, Data[1], SizeOf(TDeviceStatus));

  Buffer := Data + AnsiString(ADeviceName);
  Result := TransmitCommand(AIP, FUDPOut.Port, $40, $02, Buffer, Length(Buffer));
end;

function TMCCMgr.SetDeviceStatus(AIP: PChar; ADCSID: Word; ADeviceHandle: TDeviceHandle; ADeviceStatus: TDeviceStatus): Integer;
var
  Buffer, Data: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data, SizeOf(TDeviceStatus));
  Move(ADeviceStatus, Data[1], SizeOf(TDeviceStatus));

  Buffer := WordToAnsiString(ADCSID) + IntToAnsiString(ADeviceHandle) + Data;
  Result := TransmitCommand(AIP, FUDPOut.Port, $40, $03, Buffer, Length(Buffer));
end;

function TMCCMgr.SetOnAir(AIP: PChar; AChannelID: Word; AIsOnAir: Boolean): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := WordToAnsiString(AChannelID) + BoolToAnsiString(AIsOnAir);
  Result := TransmitCommand(AIP, FUDPOut.Port, $40, $10, Buffer, Length(Buffer));
end;

function TMCCMgr.SetEventStatus(AIP: PChar; AEventID: TEventID; AEventStatus: TEventStatus): Integer;
var
  Buffer, Data1, Data2: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data1, SizeOf(TEventID));
  Move(AEventID, Data1[1], SizeOf(TEventID));

  SetLength(Data2, SizeOf(TEventStatus));
  Move(AEventStatus, Data2[1], SizeOf(TEventStatus));

  Buffer := Data1 + Data2;
  Result := TransmitCommand(AIP, FUDPOut.Port, $40, $11, Buffer, Length(Buffer));
end;

function TMCCMgr.SetMediaStatus(AIP: PChar; AEventID: TEventID; AMediaStatus: TMediaStatus): Integer;
var
  Buffer, Data1, Data2: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data1, SizeOf(TEventID));
  Move(AEventID, Data1[1], SizeOf(TEventID));

  SetLength(Data2, SizeOf(TMediaStatus));
  Move(AMediaStatus, Data2[1], SizeOf(TMediaStatus));

  Buffer := Data1 + Data2;
  Result := TransmitCommand(AIP, FUDPOut.Port, $40, $12, Buffer, Length(Buffer));
end;

function TMCCMgr.SetTimelineRange(AIP: PChar; AChannelID: Word; AStartDate, AEndDate: TDateTime): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := WordToAnsiString(AChannelID) + DoubleToAnsiString(AStartDate) + DoubleToAnsiString(AEndDate);
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $13, Buffer, Length(Buffer));
end;

function TMCCMgr.InputCueSheet(AIP: PChar; AIndex: Integer; ACueSheetItem: TCueSheetItem): Integer;
var
  Buffer, Data: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data, SizeOf(TCueSheetItem));
  Move(ACueSheetItem, Data[1], SizeOf(TCueSheetItem));

  Buffer := IntToAnsiString(AIndex) + Data;
  Result := TransmitCommand(AIP, FUDPOut.Port, $40, $20, Buffer, Length(Buffer));
end;

function TMCCMgr.DeleteCueSheet(AIP: PChar; AEventID: TEventID): Integer;
var
  Buffer, Data: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data, SizeOf(TEventID));
  Move(AEventID, Data[1], SizeOf(TEventID));

  Buffer := Data;
  Result := TransmitCommand(AIP, FUDPOut.Port, $40, $21, Buffer, Length(Buffer));
end;

function TMCCMgr.ClearCueSheet(AIP: PChar; AChannelID: Word): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := WordToAnsiString(AChannelID);
  Result := TransmitCommand(AIP, FUDPOut.Port, $40, $22, Buffer, Length(Buffer));
end;

function TMCCMgr.SetCueSheetCurr(AIP: PChar; AEventID: TEventID): Integer;
var
  Buffer, Data: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data, SizeOf(TEventID));
  Move(AEventID, Data[1], SizeOf(TEventID));

  Buffer := Data;
  Result := TransmitCommand(AIP, FUDPOut.Port, $40, $30, Buffer, Length(Buffer));
end;

function TMCCMgr.SetCueSheetNext(AIP: PChar; AEventID: TEventID): Integer;
var
  Buffer, Data: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data, SizeOf(TEventID));
  Move(AEventID, Data[1], SizeOf(TEventID));

  Buffer := Data;
  Result := TransmitCommand(AIP, FUDPOut.Port, $40, $31, Buffer, Length(Buffer));
end;

function TMCCMgr.SetCueSheetTarget(AIP: PChar; AEventID: TEventID): Integer;
var
  Buffer, Data: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data, SizeOf(TEventID));
  Move(AEventID, Data[1], SizeOf(TEventID));

  Buffer := Data;
  Result := TransmitCommand(AIP, FUDPOut.Port, $40, $32, Buffer, Length(Buffer));
end;

{ TMCCEventNotifyThread }

constructor TMCCEventNotifyThread.Create(AMCCMgr: TMCCMgr);
begin
  FMCCMgr := AMCCMgr;

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TMCCEventNotifyThread.Destroy;
begin
  FMCCMgr := nil;

  inherited Destroy;
end;

procedure TMCCEventNotifyThread.SetEventStatus(AEventID: TEventID; AEventStatus: TEventStatus);
begin
  FEventID := AEventID;
  FEventStatus := AEventStatus;
  SetEvent(FExecuteEvent);
end;

procedure TMCCEventNotifyThread.DoControl;
begin
//  if Assigned(@EventStatusNotifyProc) then EventStatusNotifyProc(FEventID, FEventStatus);
//  ResetEvent(FExecuteEvent);
end;

procedure TMCCEventNotifyThread.Execute;
var
  R: Integer;
begin
  FExecuteEvent := CreateEvent(nil, True, False, nil);

  while not Terminated do
  begin
        R := WaitForSingleObject(FExecuteEvent, INFINITE);
        if R = WAIT_OBJECT_0 then
        (DoControl);
  end;
  CloseHandle(FExecuteEvent);
end;

end.
