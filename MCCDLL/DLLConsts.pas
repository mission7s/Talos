unit DLLConsts;

interface

uses System.Classes, Winapi.Windows, System.SysUtils, Dialogs,
  UnitCommons, UnitUDPIn, UnitUDPOut,
  MCCMgr;

function MCCSysInitialize(AInPort, AOutPort: Word; ATimeout: Cardinal = 1000): Integer; stdcall;
function MCCSysFinalize: Integer; stdcall;

function MCCSysLogInPortEnable(ALogPath: PChar; ALogExt: PChar): Integer; stdcall;
function MCCSysLogInPortDisable: Integer; stdcall;

function MCCSysLogOutPortEnable(ALogPath: PChar; ALogExt: PChar): Integer; stdcall;
function MCCSysLogOutPortDisable: Integer; stdcall;

function MCCInitialize(ANotifyPort, AInPort, AOutPort: Word; ATimeout: Cardinal = 1000; ABroadcast: Boolean = False): Integer; stdcall;
function MCCFinalize: Integer; stdcall;

function MCCLogNotifyPortEnable(ALogPath: PChar; ALogExt: PChar): Integer; stdcall;
function MCCLogNotifyPortDisable: Integer; stdcall;

function MCCLogInPortEnable(ALogPath: PChar; ALogExt: PChar): Integer; stdcall;
function MCCLogInPortDisable: Integer; stdcall;

function MCCLogOutPortEnable(ALogPath: PChar; ALogExt: PChar): Integer; stdcall;
function MCCLogOutPortDisable: Integer; stdcall;

// 0X00 System Control
function MCCSysIsAlive(AIP: PChar; var AIsAlive: Boolean): Integer; stdcall;

// 0X10 Immediate Control

// 0X20 Preset/Select Commands

// 0X30 Sense Queries

// 0X40 CueSheet Control
function MCCBeginUpdate(AIP: PChar; AChannelID: Word): Integer; stdcall;
function MCCEndUpdate(AIP: PChar; AChannelID: Word): Integer; stdcall;

function MCCSetDeviceCommError(AIP: PChar; ADeviceStatus: TDeviceStatus; ADeviceName: PChar): Integer; stdcall;
function MCCSetDeviceStatus(AIP: PChar; ADCSID: Word; ADeviceHandle: TDeviceHandle; ADeviceStatus: TDeviceStatus): Integer; stdcall;

function MCCSetOnAir(AIP: PChar; AChannelID: Word; AIsOnAir: Boolean): Integer; stdcall;
function MCCSetEventStatus(AIP: PChar; AEventID: TEventID; AEventStatus: TEventStatus): Integer; stdcall;
function MCCSetMediaStatus(AIP: PChar; AEventID: TEventID; AMediaStatus: TMediaStatus): Integer; stdcall;
function MCCSetTimelineRange(AIP: PChar; AChannelID: Word; AStartDate, AEndDate: TDateTime): Integer; stdcall;

function MCCInputCueSheet(AIP: PChar; AIndex: Integer; ACueSheetItem: TCueSheetItem): Integer; stdcall;
function MCCDeleteCueSheet(AIP: PChar; AEventID: TEventID): Integer; stdcall;
function MCCClearCueSheet(AIP: PChar; AChannelID: Word): Integer; stdcall;

function MCCSetCueSheetCurr(AIP: PChar; AEventID: TEventID): Integer; stdcall;
function MCCSetCueSheetNext(AIP: PChar; AEventID: TEventID): Integer; stdcall;
function MCCSetCueSheetTarget(AIP: PChar; AEventID: TEventID): Integer; stdcall;

exports // exports 절이 추가된다.
  MCCSysInitialize name 'MCCSysInitialize',
  MCCSysFinalize name 'MCCSysFinalize',

  MCCSysLogInPortEnable name 'MCCSysLogInPortEnable',
  MCCSysLogInPortDisable name 'MCCSysLogInPortDisable',

  MCCSysLogOutPortEnable name 'MCCSysLogOutPortEnable',
  MCCSysLogOutPortDisable name 'MCCSysLogOutPortDisable',

  MCCInitialize name 'MCCInitialize',
  MCCFinalize name 'MCCFinalize',

  MCCLogNotifyPortEnable name 'MCCLogNotifyPortEnable',
  MCCLogNotifyPortDisable name 'MCCLogNotifyPortDisable',

  MCCLogInPortEnable name 'MCCLogInPortEnable',
  MCCLogInPortDisable name 'MCCLogInPortDisable',

  MCCLogOutPortEnable name 'MCCLogOutPortEnable',
  MCCLogOutPortDisable name 'MCCLogOutPortDisable',

  MCCSysIsAlive name 'MCCSysIsAlive',

  MCCBeginUpdate name 'MCCBeginUpdate',
  MCCEndUpdate name 'MCCEndUpdate',

  MCCSetDeviceCommError name 'MCCSetDeviceCommError',
  MCCSetDeviceStatus name 'MCCSetDeviceStatus',

  MCCSetOnAir name 'MCCSetOnAir',
  MCCSetEventStatus name 'MCCSetEventStatus',
  MCCSetMediaStatus name 'MCCSetMediaStatus',
  MCCSetTimelineRange name 'MCCSetTimelineRange',

  MCCInputCueSheet name 'MCCInputCueSheet',
  MCCDeleteCueSheet name 'MCCDeleteCueSheet',
  MCCClearCueSheet name 'MCCClearCueSheet',

  MCCSetCueSheetCurr name 'MCCSetCueSheetCurr',
  MCCSetCueSheetNext name 'MCCSetCueSheetNext',
  MCCSetCueSheetTarget name 'MCCSetCueSheetTarget';

implementation

function MCCSysInitialize(AInPort, AOutPort: Word; ATimeout: Cardinal = 1000): Integer;
begin
  Result := D_FALSE;

  with VMCCMgr do
  begin
    SysTimeout := ATimeout;

    if (WaitForSingleObject(UDPSysIn.Handle, 0) = WAIT_OBJECT_0) then exit;
    if (WaitForSingleObject(UDPSysOut.Handle, 0) = WAIT_OBJECT_0) then exit;

    UDPSysIn.Port := AInPort;
    UDPSysIn.Broadcast := False;
    UDPSysIn.AsyncMode := True;
    UDPSysIn.Start;

    while not (UDPSysIn.Started) do
      Sleep(30);

    UDPSysOut.Port := AOutPort;
    UDPSysOut.Broadcast := False;
    UDPSysOut.AsyncMode := True;
    UDPSysOut.Start;

    while not (UDPSysOut.Started) do
      Sleep(30);
  end;

  Result := D_OK;
end;

function MCCSysFinalize: Integer;
begin
  Result := D_FALSE;

  with VMCCMgr do
  begin
    if (WaitForSingleObject(UDPSysIn.Handle, 0) = WAIT_OBJECT_0) then
    begin
      UDPSysIn.Close;
      UDPSysIn.Terminate;
      UDPSysIn.WaitFor;
    end;

    if (WaitForSingleObject(UDPSysOut.Handle, 0) = WAIT_OBJECT_0) then
    begin
      UDPSysOut.Close;
      UDPSysOut.Terminate;
      UDPSysOut.WaitFor;
    end;
  end;

  Result := D_OK;
end;


function MCCSysLogInPortEnable(ALogPath: PChar; ALogExt: PChar): Integer;
begin
  Result := D_FALSE;

  with VMCCMgr do
  begin
    UDPSysIn.LogEnabled := True;
    UDPSysIn.LogPath    := String(ALogPath);
    UDPSysIn.LogExt     := Format('%d_%s', [UDPSysIn.Port, ALogExt]);
  end;

  Result := D_OK;
end;

function MCCSysLogInPortDisable: Integer;
begin
  Result := D_FALSE;

  with VMCCMgr do
  begin
    UDPSysIn.LogEnabled := False;
  end;

  Result := D_OK;
end;

function MCCSysLogOutPortEnable(ALogPath: PChar; ALogExt: PChar): Integer;
begin
  Result := D_FALSE;

  with VMCCMgr do
  begin
    UDPSysOut.LogEnabled := True;
    UDPSysOut.LogPath    := String(ALogPath);
    UDPSysOut.LogExt     := Format('%d_%s', [UDPSysOut.Port, ALogExt]);
  end;

  Result := D_OK;
end;

function MCCSysLogOutPortDisable: Integer;
begin
  Result := D_FALSE;

  with VMCCMgr do
  begin
    UDPSysOut.LogEnabled := False;
  end;

  Result := D_OK;
end;

function MCCInitialize(ANotifyPort, AInPort, AOutPort: Word; ATimeout: Cardinal = 1000; ABroadcast: Boolean = False): Integer;
begin
  Result := D_FALSE;

  with VMCCMgr do
  begin
    Timeout := ATimeout;

    if (WaitForSingleObject(UDPNotify.Handle, 0) = WAIT_OBJECT_0) then exit;
    if (WaitForSingleObject(UDPIn.Handle, 0) = WAIT_OBJECT_0) then exit;
    if (WaitForSingleObject(UDPOut.Handle, 0) = WAIT_OBJECT_0) then exit;

    UDPNotify.Port := ANotifyPort;
    UDPNotify.Broadcast := ABroadcast;
    UDPNotify.AsyncMode := True;
    UDPNotify.Start;

    while not (UDPNotify.Started) do
      Sleep(30);

    UDPIn.Port := AInPort;
    UDPIn.Broadcast := ABroadcast;
    UDPIn.AsyncMode := True;
    UDPIn.Start;

    while not (UDPIn.Started) do
      Sleep(30);

//    Sleep(2000);

    UDPOut.Port := AOutPort;
    UDPOut.Broadcast := ABroadcast;
    UDPOut.AsyncMode := True;
    UDPOut.Start;

    while not (UDPOut.Started) do
      Sleep(30);

//    Sleep(2000);
  end;

  Result := D_OK;
end;

function MCCFinalize: Integer;
begin
  Result := D_FALSE;

  with VMCCMgr do
  begin
    if (WaitForSingleObject(UDPNotify.Handle, 0) = WAIT_OBJECT_0) then
    begin
      UDPNotify.Close;
      UDPNotify.Terminate;
      UDPNotify.WaitFor;
    end;

    if (WaitForSingleObject(UDPIn.Handle, 0) = WAIT_OBJECT_0) then
    begin
      UDPIn.Close;
      UDPIn.Terminate;
      UDPIn.WaitFor;
    end;

    if (WaitForSingleObject(UDPOut.Handle, 0) = WAIT_OBJECT_0) then
    begin
      UDPOut.Close;
      UDPOut.Terminate;
      UDPOut.WaitFor;
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

function MCCLogNotifyPortEnable(ALogPath: PChar; ALogExt: PChar): Integer;
begin
  Result := D_FALSE;

  with VMCCMgr do
  begin
    UDPNotify.LogEnabled := True;
    UDPNotify.LogPath    := String(ALogPath);
    UDPNotify.LogExt     := Format('%d_%s', [UDPNotify.Port, ALogExt]);
  end;

  Result := D_OK;
end;

function MCCLogNotifyPortDisable: Integer;
begin
  Result := D_FALSE;

  with VMCCMgr do
  begin
    UDPNotify.LogEnabled := False;
  end;

  Result := D_OK;
end;

function MCCLogInPortEnable(ALogPath: PChar; ALogExt: PChar): Integer;
begin
  Result := D_FALSE;

  with VMCCMgr do
  begin
    UDPIn.LogEnabled := True;
    UDPIn.LogPath    := String(ALogPath);
    UDPIn.LogExt     := Format('%d_%s', [UDPIn.Port, ALogExt]);
  end;

  Result := D_OK;
end;

function MCCLogInPortDisable: Integer;
begin
  Result := D_FALSE;

  with VMCCMgr do
  begin
    UDPIn.LogEnabled := False;
  end;

  Result := D_OK;
end;

function MCCLogOutPortEnable(ALogPath: PChar; ALogExt: PChar): Integer;
begin
  Result := D_FALSE;

  with VMCCMgr do
  begin
    UDPOut.LogEnabled := True;
    UDPOut.LogPath    := String(ALogPath);
    UDPOut.LogExt     := Format('%d_%s', [UDPOut.Port, ALogExt]);
  end;

  Result := D_OK;
end;

function MCCLogOutPortDisable: Integer;
begin
  Result := D_FALSE;

  with VMCCMgr do
  begin
    UDPOut.LogEnabled := False;
  end;

  Result := D_OK;
end;

// 0X00 System Control
function MCCSysIsAlive(AIP: PChar; var AIsAlive: Boolean): Integer;
begin
  Result := VMCCMgr.SysIsAlive(AIP, AIsAlive);
end;

// 0X10 Immediate Control

// 0X20 Preset/Select Commands

// 0X30 Sense Queries

// 0X40 CueSheet Control
function MCCBeginUpdate(AIP: PChar; AChannelID: Word): Integer;
begin
  Result := VMCCMgr.BeginUpdate(AIP, AChannelID);
end;

function MCCEndUpdate(AIP: PChar; AChannelID: Word): Integer;
begin
  Result := VMCCMgr.EndUpdate(AIP, AChannelID);
end;

function MCCSetDeviceCommError(AIP: PChar; ADeviceStatus: TDeviceStatus; ADeviceName: PChar): Integer; stdcall;
begin
  Result := VMCCMgr.SetDeviceCommError(AIP, ADeviceStatus, ADeviceName);
end;

function MCCSetDeviceStatus(AIP: PChar; ADCSID: Word; ADeviceHandle: TDeviceHandle; ADeviceStatus: TDeviceStatus): Integer;
begin
  Result := VMCCMgr.SetDeviceStatus(AIP, ADCSID, ADeviceHandle, ADeviceStatus);
end;

function MCCSetOnAir(AIP: PChar; AChannelID: Word; AIsOnAir: Boolean): Integer;
begin
  Result := VMCCMgr.SetOnAir(AIP, AChannelID, AIsOnAir);
end;

function MCCSetEventStatus(AIP: PChar; AEventID: TEventID; AEventStatus: TEventStatus): Integer;
begin
  Result := VMCCMgr.SetEventStatus(AIP, AEventID, AEventStatus);
end;

function MCCSetMediaStatus(AIP: PChar; AEventID: TEventID; AMediaStatus: TMediaStatus): Integer;
begin
  Result := VMCCMgr.SetMediaStatus(AIP, AEventID, AMediaStatus);
end;

function MCCSetTimelineRange(AIP: PChar; AChannelID: Word; AStartDate, AEndDate: TDateTime): Integer;
begin
  Result := VMCCMgr.SetTimelineRange(AIP, AChannelID, AStartDate, AEndDate);
end;

function MCCInputCueSheet(AIP: PChar; AIndex: Integer; ACueSheetItem: TCueSheetItem): Integer;
begin
  Result := VMCCMgr.InputCueSheet(AIP, AIndex, ACueSheetItem);
end;

function MCCDeleteCueSheet(AIP: PChar; AEventID: TEventID): Integer;
begin
  Result := VMCCMgr.DeleteCueSheet(AIP, AEventID);
end;

function MCCClearCueSheet(AIP: PChar; AChannelID: Word): Integer;
begin
  Result := VMCCMgr.ClearCueSheet(AIP, AChannelID);
end;

function MCCSetCueSheetCurr(AIP: PChar; AEventID: TEventID): Integer;
begin
  Result := VMCCMgr.SetCueSheetCurr(AIP, AEventID);
end;

function MCCSetCueSheetNext(AIP: PChar; AEventID: TEventID): Integer;
begin
  Result := VMCCMgr.SetCueSheetNext(AIP, AEventID);
end;

function MCCSetCueSheetTarget(AIP: PChar; AEventID: TEventID): Integer;
begin
  Result := VMCCMgr.SetCueSheetTarget(AIP, AEventID);
end;

end.
