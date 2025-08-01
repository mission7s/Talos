unit SECMgr;

interface

uses System.Classes, Winapi.Windows, System.SysUtils, Vcl.Dialogs, System.SyncObjs,
  Generics.Collections,
  UnitCommons, UnitTypeConvert,
  UnitUDPIn, UnitUDPOut;

type
  TSECMgr = class(TComponent)
  private
    FUDPSysIn: TUDPIn;

    FSysIsCommand: Boolean;
    FSysCMD1, FSysCMD2: Byte;
    FSysSyncMsgEvent: THandle;
    FSysRecvBuffer: AnsiString;
    FSysRecvData: AnsiString;
    FSysLastResult: Integer;
    FSysTimeout: Cardinal;

    FSysCommandCritSec: TCriticalSection;

    FSysInCritSec: TCriticalSection;

    FUDPIn: TUDPIn;

    FIsCommand: Boolean;
    FCMD1, FCMD2: Byte;
    FSyncMsgEvent: THandle;
    FRecvBuffer: AnsiString;
    FRecvData: AnsiString;
    FLastResult: Integer;
    FTimeout: Cardinal;

    FCommandCritSec: TCriticalSection;

    FInCritSec: TCriticalSection;

    function SendSysCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
    function SendCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;

    function SendSysResponse(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
    function SendSysAck(AIP: AnsiString; APort: Word): Integer;
    function SendSysNak(AIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function SendSysError(AIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    function SendResponse(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
    function SendAck(AIP: AnsiString; APort: Word): Integer;
    function SendNak(AIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function SendError(AIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    procedure UDPSysInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
    procedure UDPInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CheckSum(AValue: AnsiString): Boolean;

    function TransmitSysCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
    function TransmitCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;

    function TransmitSysResponse(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
    function TransmitSysAck(AIP: AnsiString; APort: Word): Integer;
    function TransmitSysNak(AIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function TransmitSysError(AIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    function TransmitResponse(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
    function TransmitAck(AIP: AnsiString; APort: Word): Integer;
    function TransmitNak(AIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function TransmitError(AIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    // 0X00 System Control
    function SysIsAlive(AIP: PChar; var AIsAlive: Boolean): Integer;                                                   // 0X00.00
    function SysIsMain(AIP: PChar; var AIsMain: Boolean): Integer;                                                     // 0X00.01

    // 0X10 Immediate Control

    // 0X20 Preset/Select Commands

    // 0X30 Sense Queries

    // 0X40 Cuesheet Control
    function BeginUpdate(AIP: PChar; AChannelID: Word): Integer;                                                       // 0X40.00
    function EndUpdate(AIP: PChar; AChannelID: Word): Integer;                                                         // 0X40.01

    function SetDeviceCommError(AIP: PChar; ADeviceStatus: TDeviceStatus; ADeviceName: PChar): Integer;                // 0X40.02
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

    function InputChannelCueSheet(AIP: PChar; ACueSheetFileName: PChar; AChannelID: Word; AOnairdate: PChar; AOnairFlag: TOnAirFlagType;
                                  AOniarNo, AEventCount, ALastSerialNo, ALastProgramNo, ALastGroupNo: Integer): Integer;         // 0X40.90
    function DeleteChannelCueSheet(AIP: PChar; AChannelID: Word; AOnairdate: PChar): Integer;                            // 0X40.91
    function ClearChannelCueSheet(AIP: PChar; AChannelID: Word): Integer;                                              // 0X40.92
    function FinishLoadCueSheet(AIP: PChar; AChannelID: Word; ACueSheetFileName: PChar): Integer;                      // 0X40.99

    property UDPIn: TUDPIn read FUDPIn write FUDPIn;

    property Timeout: Cardinal read FTimeout write FTimeout;

    property UDPSysIn: TUDPIn read FUDPSysIn write FUDPSysIn;
    property SysTimeout: Cardinal read FSysTimeout write FSysTimeout;
  end;

var
  VSECMgr: TSECMgr;

implementation

uses DLLConsts;

constructor TSECMgr.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // System control
  FSysCommandCritSec := TCriticalSection.Create;

  FSysInCritSec := TCriticalSection.Create;

  FUDPSysIn := TUDPIn.Create;
  FUDPSysIn.OnUDPRead := UDPSysInRead;

  FSysIsCommand := False;
  FSysCMD1 := $00;
  FSysCMD2 := $00;

  FSysSyncMsgEvent := CreateEvent(nil, True, False, nil);

  FSysTimeout := TIME_OUT;

  FCommandCritSec := TCriticalSection.Create;

  FInCritSec := TCriticalSection.Create;

  FUDPIn := TUDPIn.Create;
  FUDPIn.OnUDPRead := UDPInRead;

  FIsCommand := False;
  FCMD1 := $00;
  FCMD2 := $00;

  FSyncMsgEvent := CreateEvent(nil, True, False, nil);

  FTimeout := TIME_OUT;
end;

destructor TSECMgr.Destroy;
var
  I: Integer;
begin
  CloseHandle(FSyncMsgEvent);

  FreeAndNil(FUDPIn);

  FreeAndNil(FCommandCritSec);

  FreeAndNil(FInCritSec);

  inherited Destroy;
end;

function TSECMgr.SendSysCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
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

  FUDPSysIn.Send(AIP, APort, Buffer);

  Result := D_OK;
end;

function TSECMgr.SendCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
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
  FUDPIn.Send(AIP, APort, Buffer);

  Result := D_OK;
end;

function TSECMgr.SendSysResponse(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
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

  FUDPSysIn.Send(AIP, APort, Buffer);

  Result := D_OK;
end;

function TSECMgr.SendSysAck(AIP: AnsiString; APort: Word): Integer;
begin
  Result := D_FALSE;

  FUDPSysIn.Send(AIP, APort, AnsiChar(D_ACK));

  Result := D_OK;
end;

function TSECMgr.SendSysNak(AIP: AnsiString; APort: Word; ANakError: Byte): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_NAK) + AnsiChar(ANakError);

  FUDPSysIn.Send(AIP, APort, Buffer);

  Result := D_OK;
end;

function TSECMgr.SendSysError(AIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_ERR) + IntToAnsiString(AErrorCode);

  FUDPSysIn.Send(AIP, APort, Buffer);

  Result := D_OK;
end;

function TSECMgr.SendResponse(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
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

  FUDPIn.Send(AIP, APort, Buffer);

  Result := D_OK;
end;

function TSECMgr.SendAck(AIP: AnsiString; APort: Word): Integer;
begin
  Result := D_FALSE;

  FUDPIn.Send(AIP, APort, AnsiChar(D_ACK));

  Result := D_OK;
end;

function TSECMgr.SendNak(AIP: AnsiString; APort: Word; ANakError: Byte): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_NAK) + AnsiChar(ANakError);

  FUDPIn.Send(AIP, APort, Buffer);

  Result := D_OK;
end;

function TSECMgr.SendError(AIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_ERR) + IntToAnsiString(AErrorCode);

  FUDPIn.Send(AIP, APort, Buffer);

  Result := D_OK;
end;

function TSECMgr.CheckSum(AValue: AnsiString): Boolean;
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

function TSECMgr.TransmitSysCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
var
  R: DWORD;
begin
  Result := D_FALSE;

  ResetEvent(FSysSyncMsgEvent);
  FSysRecvBuffer := '';
  FSysRecvData := '';

  FSysIsCommand := True;
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

function TSECMgr.TransmitCommand(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
var
  R: DWORD;
begin
  Result := S_FALSE;

  ResetEvent(FSyncMsgEvent);
  FRecvBuffer := '';
  FRecvData := '';

  FIsCommand := True;
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

    FIsCommand := False;
  end;
end;

function TSECMgr.TransmitSysResponse(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
begin
  ACMD2 := ACMD2 + $80;
  Result := SendSysResponse(AIP, APort, ACMD1, ACMD2, ADataBuf, ADataSize);
end;

function TSECMgr.TransmitSysAck(AIP: AnsiString; APort: Word): Integer;
begin
  Result := SendSysAck(AIP, APort);
end;

function TSECMgr.TransmitSysNak(AIP: AnsiString; APort: Word; ANakError: Byte): Integer;
begin
  Result := SendSysNak(AIP, APort, ANakError);
end;

function TSECMgr.TransmitSysError(AIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
begin
  Result := SendSysError(AIP, APort, AErrorCode);
end;

function TSECMgr.TransmitResponse(AIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: AnsiString; ADataSize: Integer): Integer;
begin
  ACMD2 := ACMD2 + $80;
  Result := SendResponse(AIP, APort, ACMD1, ACMD2, ADataBuf, ADataSize);
end;

function TSECMgr.TransmitAck(AIP: AnsiString; APort: Word): Integer;
begin
  Result := SendAck(AIP, APort);
end;

function TSECMgr.TransmitNak(AIP: AnsiString; APort: Word; ANakError: Byte): Integer;
begin
  Result := SendNak(AIP, APort, ANakError);
end;

function TSECMgr.TransmitError(AIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
begin
  Result := SendError(AIP, APort, AErrorCode);
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

procedure TSECMgr.UDPSysInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
var
  ByteCount: Integer;
  CMD1, CMD2: Byte;
  Device: TDeviceHandle;
begin
  FSysInCritSec.Enter;
  try
    if (FSysIsCommand) then
    begin
      if (ADataSize <= 0) then exit;
      FSysRecvBuffer := FSysRecvBuffer + AData;

      if (Length(FSysRecvBuffer) < 1) then exit;

      case Ord(FSysRecvBuffer[1]) of
        $02:
          begin
            if (Length(FSysRecvBuffer) < 2) then exit;

            ByteCount := PAnsiCharToWord(@FSysRecvBuffer[2]);
            if (Length(FSysRecvBuffer) >= ByteCount + 4) then
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

              if (Length(FSysRecvBuffer) > ByteCount + 4) then
              begin
                FSysRecvBuffer := Copy(FSysRecvBuffer, ByteCount + 5, Length(FSysRecvBuffer));
  //              Goto GotoProcess;
              end
              else
                FSysRecvBuffer := '';
            end;
  {          else
            begin
              FLastResult := D_FALSE;
              SetEvent(FSysSyncMsgEvent);
              FSysRecvBuffer := '';
            end; }
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
    end
    else
    begin
      if Assigned(@ServerSysReadProc) then
      begin
        ServerSysReadProc(PAnsiChar(ABindingIP), PAnsiChar(AData), ADataSize);
      end;
    end;
  finally
    FSysInCritSec.Leave;
  end;
end;

procedure TSECMgr.UDPInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
var
  ByteCount: Integer;
  CMD1, CMD2: Byte;
  Device: TDeviceHandle;

//label
//  GotoProcess;
begin
  FInCritSec.Enter;
  try
    if (FIsCommand) then
    begin
      if (ADataSize <= 0) then exit;
      FRecvBuffer := FRecvBuffer + AData;

      if (Length(FRecvBuffer) < 1) then exit;

  //    GotoProcess:

      case Ord(FRecvBuffer[1]) of
        $02:
          begin
            if (Length(FRecvBuffer) < 2) then exit;

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
              begin
                FRecvBuffer := Copy(FRecvBuffer, ByteCount + 5, Length(FRecvBuffer));
  //              Goto GotoProcess;
              end
              else
                FRecvBuffer := '';
            end;
  {          else
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
    end
    else
    begin
      if Assigned(@ServerReadProc) then
      begin
        ServerReadProc(PAnsiChar(ABindingIP), PAnsiChar(AData), ADataSize);
      end;
    end;
  finally
    FInCritSec.Leave;
  end;
end;

// 0X00 System Control
function TSECMgr.SysIsAlive(AIP: PChar; var AIsAlive: Boolean): Integer;
var
  Buffer: AnsiString;
begin
  AIsAlive := False;

  Buffer := '';
  Result := TransmitSysCommand(AIP, FUDPSysIn.Port, $00, $00, Buffer, Length(Buffer));
  if (Result = D_OK) then
  begin
    if (Length(FSysRecvData) < 1) then exit;
    AIsAlive := PAnsiCharToBool(@FSysRecvData[1]);
  end;
end;

function TSECMgr.SysIsMain(AIP: PChar; var AIsMain: Boolean): Integer;
var
  Buffer: AnsiString;
begin
  AIsMain := False;

  Buffer := '';
  Result := TransmitSysCommand(AIP, FUDPSysIn.Port, $00, $01, Buffer, Length(Buffer));
  if (Result = D_OK) then
  begin
    if (Length(FSysRecvData) < 1) then exit;
    AIsMain := PAnsiCharToBool(@FSysRecvData[1]);
  end;
end;

// 0X10 Immediate Control

// 0X20 Preset/Select Commands

// 0X30 Sense Queries

// 0X40 Cuesheet Control
function TSECMgr.BeginUpdate(AIP: PChar; AChannelID: Word): Integer;
var
  Buffer: AnsiString;
begin
  Buffer := WordToAnsiString(AChannelID);
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $00, Buffer, Length(Buffer));
end;

function TSECMgr.EndUpdate(AIP: PChar; AChannelID: Word): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := WordToAnsiString(AChannelID);
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $01, Buffer, Length(Buffer));
end;

function TSECMgr.SetDeviceCommError(AIP: PChar; ADeviceStatus: TDeviceStatus; ADeviceName: PChar): Integer;
var
  Buffer, Data: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data, SizeOf(TDeviceStatus));
  Move(ADeviceStatus, Data[1], SizeOf(TDeviceStatus));

  Buffer := Data + AnsiString(ADeviceName);
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $02, Buffer, Length(Buffer));
end;

function TSECMgr.SetDeviceStatus(AIP: PChar; ADCSID: Word; ADeviceHandle: TDeviceHandle; ADeviceStatus: TDeviceStatus): Integer;
var
  Buffer, Data: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data, SizeOf(TDeviceStatus));
  Move(ADeviceStatus, Data[1], SizeOf(TDeviceStatus));

  Buffer := WordToAnsiString(ADCSID) + IntToAnsiString(ADeviceHandle) + Data;
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $03, Buffer, Length(Buffer));
end;

function TSECMgr.SetOnAir(AIP: PChar; AChannelID: Word; AIsOnAir: Boolean): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := WordToAnsiString(AChannelID) + BoolToAnsiString(AIsOnAir);
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $10, Buffer, Length(Buffer));
end;

function TSECMgr.SetEventStatus(AIP: PChar; AEventID: TEventID; AEventStatus: TEventStatus): Integer;
var
  Buffer, Data1, Data2: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data1, SizeOf(TEventID));
  Move(AEventID, Data1[1], SizeOf(TEventID));

  SetLength(Data2, SizeOf(TEventStatus));
  Move(AEventStatus, Data2[1], SizeOf(TEventStatus));

  Buffer := Data1 + Data2;
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $11, Buffer, Length(Buffer));
end;

function TSECMgr.SetMediaStatus(AIP: PChar; AEventID: TEventID; AMediaStatus: TMediaStatus): Integer;
var
  Buffer, Data1, Data2: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data1, SizeOf(TEventID));
  Move(AEventID, Data1[1], SizeOf(TEventID));

  SetLength(Data2, SizeOf(TMediaStatus));
  Move(AMediaStatus, Data2[1], SizeOf(TMediaStatus));

  Buffer := Data1 + Data2;
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $12, Buffer, Length(Buffer));
end;

function TSECMgr.SetTimelineRange(AIP: PChar; AChannelID: Word; AStartDate, AEndDate: TDateTime): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := WordToAnsiString(AChannelID) + DoubleToAnsiString(AStartDate) + DoubleToAnsiString(AEndDate);
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $13, Buffer, Length(Buffer));
end;

function TSECMgr.InputCueSheet(AIP: PChar; AIndex: Integer; ACueSheetItem: TCueSheetItem): Integer;
var
  Buffer, Data: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data, SizeOf(TCueSheetItem));
  Move(ACueSheetItem, Data[1], SizeOf(TCueSheetItem));

  Buffer := IntToAnsiString(AIndex) + Data;
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $20, Buffer, Length(Buffer));
end;

function TSECMgr.DeleteCueSheet(AIP: PChar; AEventID: TEventID): Integer;
var
  Buffer, Data: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data, SizeOf(TEventID));
  Move(AEventID, Data[1], SizeOf(TEventID));

  Buffer := Data;
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $21, Buffer, Length(Buffer));
end;

function TSECMgr.ClearCueSheet(AIP: PChar; AChannelID: Word): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := WordToAnsiString(AChannelID);
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $22, Buffer, Length(Buffer));
end;

function TSECMgr.SetCueSheetCurr(AIP: PChar; AEventID: TEventID): Integer;
var
  Buffer, Data: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data, SizeOf(TEventID));
  Move(AEventID, Data[1], SizeOf(TEventID));

  Buffer := Data;
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $30, Buffer, Length(Buffer));
end;

function TSECMgr.SetCueSheetNext(AIP: PChar; AEventID: TEventID): Integer;
var
  Buffer, Data: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data, SizeOf(TEventID));
  Move(AEventID, Data[1], SizeOf(TEventID));

  Buffer := Data;
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $31, Buffer, Length(Buffer));
end;

function TSECMgr.SetCueSheetTarget(AIP: PChar; AEventID: TEventID): Integer;
var
  Buffer, Data: AnsiString;
begin
  Result := D_FALSE;

  SetLength(Data, SizeOf(TEventID));
  Move(AEventID, Data[1], SizeOf(TEventID));

  Buffer := Data;
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $32, Buffer, Length(Buffer));
end;

function TSECMgr.InputChannelCueSheet(AIP: PChar; ACueSheetFileName: PChar; AChannelID: Word; AOnairdate: PChar; AOnairFlag: TOnAirFlagType;
                                      AOniarNo, AEventCount, ALastSerialNo, ALastProgramNo, ALastGroupNo: Integer): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := WordToAnsiString(Length(AnsiString(ACueSheetFileName))) + AnsiString(ACueSheetFileName) + WordToAnsiString(AChannelID) +
            AnsiString(AOnairdate) + AnsiChar(AOnairFlag) + IntToAnsiString(AOniarNo) + IntToAnsiString(AEventCount) + IntToAnsiString(ALastSerialNo) + IntToAnsiString(ALastProgramNo) + IntToAnsiString(ALastGroupNo);
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $90, Buffer, Length(Buffer));
end;

function TSECMgr.DeleteChannelCueSheet(AIP: PChar; AChannelID: Word; AOnairdate: PChar): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := WordToAnsiString(AChannelID) + AnsiString(AOnairdate);
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $91, Buffer, Length(Buffer));
end;

function TSECMgr.ClearChannelCueSheet(AIP: PChar; AChannelID: Word): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := WordToAnsiString(AChannelID);
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $92, Buffer, Length(Buffer));
end;

function TSECMgr.FinishLoadCueSheet(AIP: PChar; AChannelID: Word; ACueSheetFileName: PChar): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := WordToAnsiString(AChannelID) + WordToAnsiString(Length(AnsiString(ACueSheetFileName))) + AnsiString(ACueSheetFileName);
  Result := TransmitCommand(AIP, FUDPIn.Port, $40, $99, Buffer, Length(Buffer));
end;

end.
