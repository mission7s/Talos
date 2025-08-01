unit DLLConsts;

interface

uses System.Classes, Winapi.Windows, System.SysUtils, Dialogs,
  UnitCommons, UnitUDPIn, UnitUDPOut,
  SECMgr;

type
  // Notify function of status
  TServerReadProc = procedure (ABindingIP: PAnsiChar; AData: PAnsiChar; ADataSize: Integer); stdcall;
  PServerReadProc = ^TServerReadProc;

var
  ServerSysReadProc: TServerReadProc;
  ServerReadProc: TServerReadProc;

function SECSysInitialize(AInPort: Word; ATimeout: Cardinal = 1000): Integer; stdcall;
function SECSysFinalize: Integer; stdcall;

function SECSysLogInPortEnable(ALogPath: PChar; ALogExt: PChar): Integer; stdcall;
function SECSysLogInPortDisable: Integer; stdcall;

function SECSysSetServerReadProc(ReadFunc: Pointer): Integer; stdcall;
function SECSysTransmitResponse(AIP: PAnsiChar; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: PAnsiChar; ADataSize: Integer): Integer; stdcall;
function SECSysTransmitAck(AIP: PAnsiChar; APort: Word): Integer; stdcall;
function SECSysTransmitNak(AIP: PAnsiChar; APort: Word; ANakError: Byte): Integer; stdcall;
function SECSysTransmitError(AIP: PAnsiChar; APort: Word; AErrorCode: Integer): Integer; stdcall;

function SECInitialize(AInPort: Word; ATimeout: Cardinal = 1000; ABroadcast: Boolean = False): Integer; stdcall;
function SECFinalize: Integer; stdcall;

function SECLogInPortEnable(ALogPath: PChar; ALogExt: PChar): Integer; stdcall;
function SECLogInPortDisable: Integer; stdcall;

function SECSetServerReadProc(ReadFunc: Pointer): Integer; stdcall;
function SECTransmitResponse(AIP: PAnsiChar; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: PAnsiChar; ADataSize: Integer): Integer; stdcall;
function SECTransmitAck(AIP: PAnsiChar; APort: Word): Integer; stdcall;
function SECTransmitNak(AIP: PAnsiChar; APort: Word; ANakError: Byte): Integer; stdcall;
function SECTransmitError(AIP: PAnsiChar; APort: Word; AErrorCode: Integer): Integer; stdcall;

// 0X00 System Control
function SECSysIsAlive(AIP: PChar; var AIsAlive: Boolean): Integer; stdcall;
function SECSysIsMain(AIP: PChar; var AIsMain: Boolean): Integer; stdcall;

// 0X10 Immediate Control

// 0X20 Preset/Select Commands

// 0X30 Sense Queries

// 0X40 CueSheet Control
function SECBeginUpdate(AIP: PChar; AChannelID: Word): Integer; stdcall;
function SECEndUpdate(AIP: PChar; AChannelID: Word): Integer; stdcall;

function SECSetDeviceCommError(AIP: PChar; ADeviceStatus: TDeviceStatus; ADeviceName: PChar): Integer; stdcall;
function SECSetDeviceStatus(AIP: PChar; ADCSID: Word; ADeviceHandle: TDeviceHandle; ADeviceStatus: TDeviceStatus): Integer; stdcall;

function SECSetOnAir(AIP: PChar; AChannelID: Word; AIsOnAir: Boolean): Integer; stdcall;
function SECSetEventStatus(AIP: PChar; AEventID: TEventID; AEventStatus: TEventStatus): Integer; stdcall;
function SECSetMediaStatus(AIP: PChar; AEventID: TEventID; AMediaStatus: TMediaStatus): Integer; stdcall;
function SECSetTimelineRange(AIP: PChar; AChannelID: Word; AStartDate, AEndDate: TDateTime): Integer; stdcall;

function SECInputCueSheet(AIP: PChar; AIndex: Integer; ACueSheetItem: TCueSheetItem): Integer; stdcall;
function SECDeleteCueSheet(AIP: PChar; AEventID: TEventID): Integer; stdcall;
function SECClearCueSheet(AIP: PChar; AChannelID: Word): Integer; stdcall;

function SECSetCueSheetCurr(AIP: PChar; AEventID: TEventID): Integer; stdcall;
function SECSetCueSheetNext(AIP: PChar; AEventID: TEventID): Integer; stdcall;
function SECSetCueSheetTarget(AIP: PChar; AEventID: TEventID): Integer; stdcall;

function SECInputChannelCueSheet(AIP: PChar; ACueSheetFileName: PChar; AChannelID: Word; AOnairdate: PChar; AOnairFlag: TOnAirFlagType;
                                 AOniarNo, AEventCount, ALastSerialNo, ALastProgramNo, ALastGroupNo: Integer): Integer; stdcall;
function SECDeleteChannelCueSheet(AIP: PChar; AChannelID: Word; AOnairdate: PChar): Integer; stdcall;
function SECClearChannelCueSheet(AIP: PChar; AChannelID: Word): Integer; stdcall;
function SECFinishLoadCueSheet(AIP: PChar; AChannelID: Word; ACueSheetFileName: PChar): Integer; stdcall;

exports // exports 절이 추가된다.
  SECSysInitialize name 'SECSysInitialize',
  SECSysFinalize name 'SECSysFinalize',

  SECSysLogInPortEnable name 'SECSysLogInPortEnable',
  SECSysLogInPortDisable name 'SECSysLogInPortDisable',

  SECSysSetServerReadProc name 'SECSysSetServerReadProc',
  SECSysTransmitResponse name 'SECSysTransmitResponse',
  SECSysTransmitAck name 'SECSysTransmitAck',
  SECSysTransmitNak name 'SECSysTransmitNak',
  SECSysTransmitError name 'SECSysTransmitError',

  SECInitialize name 'SECInitialize',
  SECFinalize name 'SECFinalize',

  SECLogInPortEnable name 'SECLogInPortEnable',
  SECLogInPortDisable name 'SECLogInPortDisable',

  SECSetServerReadProc name 'SECSetServerReadProc',
  SECTransmitResponse name 'SECTransmitResponse',
  SECTransmitAck name 'SECTransmitAck',
  SECTransmitNak name 'SECTransmitNak',
  SECTransmitError name 'SECTransmitError',

  SECSysIsAlive name 'SECSysIsAlive',
  SECSysIsMain name 'SECSysIsMain',

  SECBeginUpdate name 'SECBeginUpdate',
  SECEndUpdate name 'SECEndUpdate',

  SECSetDeviceCommError name 'SECSetDeviceCommError',
  SECSetDeviceStatus name 'SECSetDeviceStatus',

  SECSetOnAir name 'SECSetOnAir',
  SECSetEventStatus name 'SECSetEventStatus',
  SECSetMediaStatus name 'SECSetMediaStatus',
  SECSetTimelineRange name 'SECSetTimelineRange',

  SECInputCueSheet name 'SECInputCueSheet',
  SECDeleteCueSheet name 'SECDeleteCueSheet',
  SECClearCueSheet name 'SECClearCueSheet',

  SECSetCueSheetCurr name 'SECSetCueSheetCurr',
  SECSetCueSheetNext name 'SECSetCueSheetNext',
  SECSetCueSheetTarget name 'SECSetCueSheetTarget',

  SECInputChannelCueSheet name 'SECInputChannelCueSheet',
  SECDeleteChannelCueSheet name 'SECDeleteChannelCueSheet',
  SECClearChannelCueSheet name 'SECClearChannelCueSheet',
  SECFinishLoadCueSheet name 'SECFinishLoadCueSheet';

implementation

function SECSysInitialize(AInPort: Word; ATimeout: Cardinal = 1000): Integer;
begin
  Result := D_FALSE;

  with VSECMgr do
  begin
    SysTimeout := ATimeout;

    if (WaitForSingleObject(UDPSysIn.Handle, 0) = WAIT_OBJECT_0) then exit;

    UDPSysIn.Port := AInPort;
    UDPSysIn.Broadcast := False;
    UDPSysIn.AsyncMode := True;
    UDPSysIn.Start;

    while not (UDPSysIn.Started) do
      Sleep(30);
  end;

  Result := D_OK;
end;

function SECSysFinalize: Integer;
begin
  Result := D_FALSE;

  with VSECMgr do
  begin
    @ServerSysReadProc := nil;

    if (WaitForSingleObject(UDPSysIn.Handle, 0) = WAIT_OBJECT_0) then
    begin
      UDPSysIn.Close;
      UDPSysIn.Terminate;
      UDPSysIn.WaitFor;
    end;
  end;

  Result := D_OK;
end;

function SECSysLogInPortEnable(ALogPath: PChar; ALogExt: PChar): Integer;
begin
  Result := D_FALSE;

  with VSECMgr do
  begin
    UDPSysIn.LogEnabled := True;
    UDPSysIn.LogPath    := String(ALogPath);
    UDPSysIn.LogExt     := Format('%d_%s', [UDPSysIn.Port, ALogExt]);
  end;

  Result := D_OK;
end;

function SECSysLogInPortDisable: Integer;
begin
  Result := D_FALSE;

  with VSECMgr do
  begin
    UDPSysIn.LogEnabled := False;
  end;

  Result := D_OK;
end;

function SECSysSetServerReadProc(ReadFunc: Pointer): Integer;
begin
  Result := D_FALSE;
  if (ReadFunc = nil) then exit;

  @ServerSysReadProc := ReadFunc;
  Result := D_OK;
end;

function SECSysTransmitResponse(AIP: PAnsiChar; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: PAnsiChar; ADataSize: Integer): Integer;
begin
  Result := VSECMgr.TransmitSysResponse(AnsiString(AIP), APort, ACMD1, ACMD2, AnsiString(ADataBuf), ADataSize);
end;

function SECSysTransmitAck(AIP: PAnsiChar; APort: Word): Integer;
begin
  Result := VSECMgr.TransmitSysAck(AnsiString(AIP), APort);
end;

function SECSysTransmitNak(AIP: PAnsiChar; APort: Word; ANakError: Byte): Integer;
begin
  Result := VSECMgr.TransmitSysNak(AnsiString(AIP), APort, ANakError);
end;

function SECSysTransmitError(AIP: PAnsiChar; APort: Word; AErrorCode: Integer): Integer;
begin
  Result := VSECMgr.TransmitSysError(AnsiString(AIP), APort, AErrorCode);
end;

function SECInitialize(AInPort: Word; ATimeout: Cardinal = 1000; ABroadcast: Boolean = False): Integer;
begin
  Result := D_FALSE;

  with VSECMgr do
  begin
    Timeout := ATimeout;

    if (WaitForSingleObject(UDPIn.Handle, 0) = WAIT_OBJECT_0) then exit;

    UDPIn.Port := AInPort;
    UDPIn.Broadcast := ABroadcast;
    UDPIn.AsyncMode := True;
    UDPIn.Start;

    while not (UDPIn.Started) do
      Sleep(30);

//    Sleep(2000);
  end;

  Result := D_OK;
end;

function SECFinalize: Integer;
begin
  Result := D_FALSE;

  with VSECMgr do
  begin
    @ServerReadProc := nil;

    if (WaitForSingleObject(UDPIn.Handle, 0) = WAIT_OBJECT_0) then
    begin
      UDPIn.Close;
      UDPIn.Terminate;
      UDPIn.WaitFor;
    end;

{    if (WaitForSingleObject(UDPNotify.Handle, 0) = WAIT_OBJECT_0) then
    begin
      UDPNotify.Close;
      UDPNotify.Terminate;
      UDPNotify.WaitFor;
    end
    else exit;

    if (WaitForSingleObject(UDPIn.Handle, 0) = WAIT_OBJECT_0) then
    begin
      UDPIn.Close;
      UDPIn.Terminate;
      UDPIn.WaitFor;
    end
    else exit;

    if (WaitForSingleObject(UDPOut.Handle, 0) = WAIT_OBJECT_0) then
    begin
      UDPOut.Close;
      UDPOut.Terminate;
      UDPOut.WaitFor;
    end
    else exit; }
  end;

  Result := D_OK;
end;

function SECLogInPortEnable(ALogPath: PChar; ALogExt: PChar): Integer;
begin
  Result := D_FALSE;

  with VSECMgr do
  begin
    UDPIn.LogEnabled := True;
    UDPIn.LogPath    := String(ALogPath);
    UDPIn.LogExt     := Format('%d_%s', [UDPIn.Port, ALogExt]);
  end;

  Result := D_OK;
end;

function SECLogInPortDisable: Integer;
begin
  Result := D_FALSE;

  with VSECMgr do
  begin
    UDPIn.LogEnabled := False;
  end;

  Result := D_OK;
end;

function SECSetServerReadProc(ReadFunc: Pointer): Integer;
begin
  Result := D_FALSE;
  if (ReadFunc = nil) then exit;

  @ServerReadProc := ReadFunc;
  Result := D_OK;
end;

function SECTransmitResponse(AIP: PAnsiChar; APort: Word; ACMD1, ACMD2: Byte; ADataBuf: PAnsiChar; ADataSize: Integer): Integer;
begin
  Result := VSECMgr.TransmitResponse(AnsiString(AIP), APort, ACMD1, ACMD2, AnsiString(ADataBuf), ADataSize);
end;

function SECTransmitAck(AIP: PAnsiChar; APort: Word): Integer;
begin
  Result := VSECMgr.TransmitAck(AnsiString(AIP), APort);
end;

function SECTransmitNak(AIP: PAnsiChar; APort: Word; ANakError: Byte): Integer;
begin
  Result := VSECMgr.TransmitNak(AnsiString(AIP), APort, ANakError);
end;

function SECTransmitError(AIP: PAnsiChar; APort: Word; AErrorCode: Integer): Integer;
begin
  Result := VSECMgr.TransmitError(AnsiString(AIP), APort, AErrorCode);
end;

// 0X00 System Control
function SECSysIsAlive(AIP: PChar; var AIsAlive: Boolean): Integer;
begin
  Result := VSECMgr.SysIsAlive(AIP, AIsAlive);
end;

function SECSysIsMain(AIP: PChar; var AIsMain: Boolean): Integer;
begin
  Result := VSECMgr.SysIsMain(AIP, AIsMain);
end;

// 0X10 Immediate Control

// 0X20 Preset/Select Commands

// 0X30 Sense Queries

// 0X40 CueSheet Control
function SECBeginUpdate(AIP: PChar; AChannelID: Word): Integer;
begin
  Result := VSECMgr.BeginUpdate(AIP, AChannelID);
end;

function SECEndUpdate(AIP: PChar; AChannelID: Word): Integer;
begin
  Result := VSECMgr.EndUpdate(AIP, AChannelID);
end;

function SECSetDeviceCommError(AIP: PChar; ADeviceStatus: TDeviceStatus; ADeviceName: PChar): Integer;
begin
  Result := VSECMgr.SetDeviceCommError(AIP, ADeviceStatus, ADeviceName);
end;

function SECSetDeviceStatus(AIP: PChar; ADCSID: Word; ADeviceHandle: TDeviceHandle; ADeviceStatus: TDeviceStatus): Integer;
begin
  Result := VSECMgr.SetDeviceStatus(AIP, ADCSID, ADeviceHandle, ADeviceStatus);
end;

function SECSetOnAir(AIP: PChar; AChannelID: Word; AIsOnAir: Boolean): Integer;
begin
  Result := VSECMgr.SetOnAir(AIP, AChannelID, AIsOnAir);
end;

function SECSetEventStatus(AIP: PChar; AEventID: TEventID; AEventStatus: TEventStatus): Integer;
begin
  Result := VSECMgr.SetEventStatus(AIP, AEventID, AEventStatus);
end;

function SECSetMediaStatus(AIP: PChar; AEventID: TEventID; AMediaStatus: TMediaStatus): Integer;
begin
  Result := VSECMgr.SetMediaStatus(AIP, AEventID, AMediaStatus);
end;

function SECSetTimelineRange(AIP: PChar; AChannelID: Word; AStartDate, AEndDate: TDateTime): Integer;
begin
  Result := VSECMgr.SetTimelineRange(AIP, AChannelID, AStartDate, AEndDate);
end;

function SECInputCueSheet(AIP: PChar; AIndex: Integer; ACueSheetItem: TCueSheetItem): Integer;
begin
  Result := VSECMgr.InputCueSheet(AIP, AIndex, ACueSheetItem);
end;

function SECDeleteCueSheet(AIP: PChar; AEventID: TEventID): Integer;
begin
  Result := VSECMgr.DeleteCueSheet(AIP, AEventID);
end;

function SECClearCueSheet(AIP: PChar; AChannelID: Word): Integer;
begin
  Result := VSECMgr.ClearCueSheet(AIP, AChannelID);
end;

function SECSetCueSheetCurr(AIP: PChar; AEventID: TEventID): Integer;
begin
  Result := VSECMgr.SetCueSheetCurr(AIP, AEventID);
end;

function SECSetCueSheetNext(AIP: PChar; AEventID: TEventID): Integer;
begin
  Result := VSECMgr.SetCueSheetNext(AIP, AEventID);
end;

function SECSetCueSheetTarget(AIP: PChar; AEventID: TEventID): Integer;
begin
  Result := VSECMgr.SetCueSheetTarget(AIP, AEventID);
end;

function SECInputChannelCueSheet(AIP: PChar; ACueSheetFileName: PChar; AChannelID: Word; AOnairdate: PChar; AOnairFlag: TOnAirFlagType;
                                 AOniarNo, AEventCount, ALastSerialNo, ALastProgramNo, ALastGroupNo: Integer): Integer;
begin
  Result := VSECMgr.InputChannelCueSheet(AIP, ACueSheetFileName, AChannelID, AOnairdate, AOnairFlag,
                                         AOniarNo, AEventCount, ALastSerialNo, ALastProgramNo, ALastGroupNo);
end;

function SECDeleteChannelCueSheet(AIP: PChar; AChannelID: Word; AOnairdate: PChar): Integer;
begin
  Result := VSECMgr.DeleteChannelCueSheet(AIP, AChannelID, AOnairdate);
end;

function SECClearChannelCueSheet(AIP: PChar; AChannelID: Word): Integer;
begin
  Result := VSECMgr.ClearChannelCueSheet(AIP, AChannelID);
end;

function SECFinishLoadCueSheet(AIP: PChar; AChannelID: Word; ACueSheetFileName: PChar): Integer;
begin
  Result := VSECMgr.FinishLoadCueSheet(AIP, AChannelID, ACueSheetFileName);
end;

end.
