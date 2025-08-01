unit UnitDeviceThread;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows,
  System.DateUtils, System.Types, VCL.Forms,
  {UnitConsts, }UnitCommons, UnitTypeConvert;

const
  DEVICE_WAIT_TIMEOUT = 100;
//  DEVICE_COMMAND_TIMEOUT = 1000;
  DEVICE_STATUS_TIMEOUT = 1000;

type
//  TGetStatusThread = class;

  TEventOverallNotifyThread = class;
  TEventControlThread = class;

  TDeviceThread = class(TThread)
  private
  protected
    FDevice: PDevice;
    FOpened: Boolean;

    FControlBy: AnsiString;
    FControlChannel: Integer;
    FControlFrameRateType: TFrameRateType;
    FControlIsDropFrame: Boolean;

//    FControlChannel: Integer;

    FClearChannel: Integer;

    FCmdHostIP: AnsiString;
    FCmdEvent: TEvent;
    FCmdEventID: TEventID;

    FDeviceCommandTimeout: Cardinal;
    FCueTimeout: Cardinal;

    FFinishActionDelayTime: TTimecode;
    FFinishActionTimeOut: Cardinal;

    FEventLock: TCriticalSection;
    FEventQueue: TEventList;
    FEventOverall: TEventOverall;

    FEventClose: THandle;
    FEventReset: THandle;
    FEventClear: THandle;
    FEventCommand: THandle;
    FEventChanged: THandle;
    FEventStart: THandle;
    FEventStop: THandle;
    FEventCue: THandle;
    FEventFinish: THandle;
    FEventSchedule: THandle;
//    FEventGetStatus: THandle;

    FEventStartCompleted: THandle;
    FEventStopCompleted: THandle;
    FEventCueCompleted: THandle;
    FEventFinishCompleted: THandle;

    FEventCompleted: THandle;
    FEventCommandFinished: THandle;

    FSendBuffer: AnsiString;

    // Command Event
    FCMDControlBy: AnsiString;
    FCMD1, FCMD2: Byte;
    FCMDBuffer: AnsiString;
    FCMDResultBuffer: AnsiString;
    FCMDLastResult: Integer;

//    FGetStatusThread: TGetStatusThread;

    FNumCued: Integer;
    FCuedDurTime: TTimecode;

    FEventOverallNotifyThread: TEventOverallNotifyThread;
    FEventControlThread: TEventControlThread;

    FDestroying: Boolean;

    FLogForm: TCustomForm;

    function GetEventCurr: PEvent;
    function GetEventNext: PEvent;
    function GetEventFini: PEvent;

    procedure SetEventCurr(Value: PEvent);
    procedure SetEventNext(Value: PEvent);
    procedure SetEventFini(Value: PEvent);

    procedure SetControlBy(Value: AnsiString);
    procedure SetControlChannel(Value: Integer);

{    function SendCallback(AHost: String; APort: Integer; ACmd1, ACmd2: Byte; ADataBuf: String; ADataSize: Integer): Integer;
    function TransmitCallback(AHost: String; APort: Integer; ACmd1, ACmd2: Byte; ADataBuf: String; ADataSize: Integer): Integer;

    procedure SendStatus(AEventID: TEventID; ADeviceStatus: TDeviceStatus); virtual;
    procedure SendEventStatus(AEventID: TEventID; AStatus: TEventStatus); virtual; }

//    function SendCallback(AHost: String; APort: Integer; ACmd1, ACmd2: Byte; ADataBuf: String; ADataSize: Integer): Integer;
//    function TransmitCallback(AHost: AnsiString; APort: Integer; ACmd1, ACmd2: Byte; ADataBuf: String; ADataSize: Integer): Integer;

    procedure TransmitNotifyStatus(AHandle: TDeviceHandle; AStatus: TDeviceStatus); virtual;
    procedure TransmitNotifyEventStatus(AEventID: TEventID; AStatus: TEventStatus); virtual;
    procedure TransmitNotifyEventOverall(AHandle: TDeviceHandle; AOverall: TEventOverall); virtual;

    procedure TransmitDeviceStatusNotify(AHandle: TDeviceHandle; AStatus: TDeviceStatus); virtual;
    procedure TransmitEventStatusNotify(AEventID: TEventID; AStatus: TEventStatus); virtual;
    procedure TransmitEventCurrNotify(AEventID: TEventID); virtual;
    procedure TransmitEventNextNotify(AEventID: TEventID); virtual;
    procedure TransmitEventFiniNotify(AEventID: TEventID); virtual;
    procedure TransmitRemoveEventNotify(AEventID: TEventID); virtual;

    procedure ControlReset; virtual;
    procedure ControlCommand; virtual;
    procedure ControlClear; virtual;
    procedure ControlChanged; virtual;
    procedure ControlStart; virtual;
    procedure ControlStop; virtual;
    procedure ControlFinish; virtual;
    procedure ControlCue; virtual;
    procedure ControlSchedule; virtual;
    procedure ControlGetStatus; virtual;

    procedure DoEventControl;

    procedure Execute; override;

    procedure ClearEventQueueByChannelID(AChannelID: Word);
    procedure ClearEventQueueAll;

    function GetStatus: TDeviceStatus; virtual;

    procedure UpdateStatus;

//    function DCSGetStatus(ABuffer: String): Integer; virtual;

    function GetEventByID(AEventID: TEventID): PEvent;
    function GetEventByStartTime(AEventTime: TEventTime): PEvent;
    function GetEventByInRangeTime(AStartTime, AEndTime: TEventTime): PEvent;

    function GetNextEvent: PEvent;
    function GetCurrEvent: PEvent;

    procedure EventQueueQuickSort(L, R: Integer);

    procedure SetEventStatus(AEvent: PEvent; AState: TEventState; AErrorCode: Integer = E_NO_ERROR); virtual;
  protected
    FEventCurr: PEvent;
    FEventNext: PEvent;
    FEventFini: PEvent;

    FEventCurrID: TEventID;
    FEventNextID: TEventID;
    FEventFiniID: TEventID;
  public
    constructor Create(ADevice: PDevice); virtual;
    destructor Destroy; override;

    procedure Close; virtual;

    procedure WaitForEventCompleted(AWaitMillisec: Cardinal);

    function GetLogDevice(ALogState: TLogState; ALogStr: String): String; overload; virtual;
    function GetLogDevice(ALogState: TLogState; AHostIP: String; ALogStr: String): String; overload; virtual;
    function GetLogDevice(ALogState: TLogState; AHostIP: String; AChannelID: Integer; ALogStr: String): String; overload; virtual;

    function DeviceOpen: Integer; virtual;
    function DeviceClose: Integer; virtual;
    function DeviceInit: Integer; virtual;

    function DeviceReCue: Integer; virtual;

    function DeviceReset: Integer; overload; virtual;
    function DeviceReset(AHostIP: AnsiString; AChannelID: Word): Integer; overload; virtual;

    function DeviceReInputEvents(AHostIP: AnsiString): Integer; virtual;

    // 0X20, 30, 40 Command
    function DeviceCommand(AHostIP: AnsiString; ACMD1, ACMD2: Byte; ACMDBuffer: AnsiString; var AResultBuffer: AnsiString): Integer; virtual;

    // Sense Queries (0X40)
    function GetDeviceStatus(AStatus: TDeviceStatus): Integer; virtual;
    function GetExist(AExist: Boolean): Integer; virtual;

    // Event Control (0X50, 0XC0)
    function InputEvent(AHostIP: AnsiString; AEvent: TEvent): Integer; virtual;
    function DeleteEvent(AHostIP: AnsiString; AEventID: TEventID): Integer; virtual;
    function ClearEvent(AHostIP: AnsiString; AChannelID: Word): Integer; virtual;
    function TakeEvent(AHostIP: AnsiString; AEventID: TEventID; AStartTime: TEventTime): Integer; virtual;
    function HoldEvent(AHostIP: AnsiString; AEventID: TEventID): Integer; virtual;
    function ChangeDurationEvent(AHostIP: AnsiString; AEventID: TEventID; ADuration: TTimecode): Integer; virtual;
    function GetOnAirEventID(AHostIP: AnsiString; var AOnAirEventID, ANextEventID: TEventID): Integer; virtual;
    function GetEventInfo(AHostIP: AnsiString; AEventID: TEventID; var AStartTime: TEventTime; var ADurationTC: TTimecode): Integer; virtual;
    function GetEventStatus(AHostIP: AnsiString; AEventID: TEventID; var AEventStatus: TEventStatus): Integer; virtual;
    function GetEventOverall(AHostIP: AnsiString; var AEventOverall: TEventOverall): Integer; virtual;

    // Event Status Notify (0X60)
    function SetDeviceStatusNotify(AStatus: TDeviceStatus): Integer; virtual;
    function SetEventStatusNotify(AEventID: TEventID; AStatus: TEventStatus): Integer; virtual;
    function SetEventCurrNotify(AEventID: TEventID): Integer; virtual;
    function SetEventNextNotify(AEventID: TEventID): Integer; virtual;
    function SetEventFiniNotify(AEventID: TEventID): Integer; virtual;

    function RemoveEventNotify(AEventID: TEventID): Integer; virtual;

{    function GetEventByEventID(AEventID: TEventID): PEventInfo;
    function GetEventByEventTime(AEventTime: TEventTime): PEventInfo;
    function GetEventIndexByEventTime(AEventTime: TEventTime): Integer;

    procedure AddEvent(AECIP: String; AEvent: TEvent); virtual;
    procedure SetEventStatus(AEventStatus: TEventStatus; AEvent: PEventInfo); virtual;

    procedure Reset(ADeviceName: String); virtual;

    procedure PlayCue(ID: TID; CueTC, Duration: TTimecode); virtual;  }

    procedure EventQueueSort;

    procedure ResetStartTimePlus(AIndex: Integer; ADurEventTime: TEventTime; AFrameRateType: TFrameRateType);
    procedure ResetStartTimeMinus(AIndex: Integer; ADurEventTime: TEventTime; AFrameRateType: TFrameRateType);

    property Device: PDevice read FDevice;
    property ControlBy: AnsiString read FControlBy write SetControlBy;
    property ControlChannel: Integer read FControlChannel write SetControlChannel;
    property ControlFrameRateType: TFrameRateType read FControlFrameRateType;
    property ControlIsDropFrame: Boolean read FControlIsDropFrame;

//    property ControlChannel: Integer read FControlChannel write SetControlChannel;

//    property EventCurr: PEvent read FEventCurr write SetEventCurr;
//    property EventNext: PEvent read FEventNext write SetEventNext;

    property EventCurr: PEvent read GetEventCurr write SetEventCurr;
    property EventNext: PEvent read GetEventNext write SetEventNext;
    property EventFini: PEvent read GetEventFini write SetEventFini;

    property EventCurrID: TEventID read FEventCurrID;
    property EventNextID: TEventID read FEventNextID;
    property EventFiniID: TEventID read FEventFiniID;

    property EventQueue: TEventList read FEventQueue;

    property EventLock: TCriticalSection read FEventLock;

    property EventCue: THandle read FEventCue;

    property EventControlThread: TEventControlThread read FEventControlThread;

    property LogForm: TCustomForm read FLogForm write FLogForm;
  end;

{  TGetStatusThread = class(TThread)
  private
    FDeviceThread: TDeviceThread;
    FEventClose: THandle;
  protected
    procedure Execute; override;
  public
    constructor Create(ADeviceThread: TDeviceThread); virtual;
    destructor Destroy; override;

    procedure Close;
  end; }

  TEventOverallNotifyThread = class(TThread)
  private
    FDeviceThread: TDeviceThread;
    FEventExecute: THandle;
    FEventClose: THandle;
  protected
    procedure Execute; override;
  public
    constructor Create(ADeviceThread: TDeviceThread); virtual;
    destructor Destroy; override;

    procedure Close;
  end;

  TEventControlThread = class(TThread)
  private
    FDeviceThread: TDeviceThread;
    FEventExecute: THandle;
    FEventClose: THandle;

    FDelayMilliSec: Integer;

    procedure SetDelayMilliSec(AValue: Integer);

    procedure DoEventControl;
  protected
    procedure Execute; override;
  public
    constructor Create(ADeviceThread: TDeviceThread); virtual;
    destructor Destroy; override;

    procedure Close;

    procedure SetExecute;
    procedure ResetExecute;

    property DelayMilliSec: Integer read FDelayMilliSec write SetDelayMilliSec;
  end;

implementation

uses UnitDCS, UnitConsts, UnitChannelEvents, UnitDeviceList,
  UnitLogDevice;

constructor TDeviceThread.Create(ADevice: PDevice);
begin
  FDevice := ADevice;
  FDevice^.Handle := GetDeviceHandle;

  FLogForm := nil;

  FOpened := False;

  FControlBy      := '';
  FControlChannel := -1;

  FControlFrameRateType := FR_1;
  FControlIsDropFrame   := False;

  FClearChannel   := -1;

  FCmdHostIP := '';
  FillChar(FCmdEvent, SizeOf(TEvent), #0);
  FillChar(FCmdEventID, SizeOf(TEventID), #0);

  case FDevice^.DeviceType of
    DT_PCS_MEDIA,
    DT_LOUTH,
    DT_OMNEON,

    DT_LINE:
    begin
      with GV_ConfigEventVS do
      begin
        FDeviceCommandTimeout  := TimecodeToMilliSec(CommandTimeout, FR_30);

        FCueTimeout            := TimecodeToMilliSec(CueTimeout, FR_30);
        FFinishActionDelayTime := FinishActionDelayTime;
        FFinishActionTimeOut   := TimecodeToMilliSec(FinishActionTimeout, FR_30);
      end;
    end;

    DT_PCS_CG,
    DT_K3D,
    DT_TAPI:
    begin
      with GV_ConfigEventCG do
      begin
        FDeviceCommandTimeout  := TimecodeToMilliSec(CommandTimeout, FR_30);

        FCueTimeout            := TimecodeToMilliSec(CueTimeout, FR_30);
        FFinishActionDelayTime := FinishActionDelayTime;
        FFinishActionTimeOut   := TimecodeToMilliSec(FinishActionTimeout, FR_30);
      end;
    end;

    DT_PCS_SWITCHER,
    DT_VTS,
    DT_K2E_MCS,

    DT_IMG_LRC,   // Imagine Logical Router Control
    DT_GV_RCL,    // GrassValley Router Control Language
    DT_QUARTZ,    // Quartz Routing Switcher Remote Control Protocol
    DT_UTHA_RCP3, // Utha RCP-3 Remote Switcher Control Protocols


    DT_GVM,       // GVGM2100, Ross MDK keyer
    DT_GVR,       // Grass valley router
    DT_VIK:        // Vikin router
    begin
      with GV_ConfigEventMCS do
      begin
        FDeviceCommandTimeout  := TimecodeToMilliSec(CommandTimeout, FR_30);

        FCueTimeout            := TimecodeToMilliSec(CueTimeout, FR_30);
        FFinishActionDelayTime := 0;
        FFinishActionTimeOut   := 0;
      end;
    end;
    else
    begin
      FDeviceCommandTimeout  := 0;

      FCueTimeout            := 0;
      FFinishActionDelayTime := 0;
      FFinishActionTimeOut   := 0;
    end;
  end;

  FEventLock   := TCriticalSection.Create;
  FEventQueue  := TEventList.Create;

  FillChar(FEventOverall, SizeOf(TEventOverall), #0);
  FEventOverall.ChannelID := -1;

  FEventCurr := nil;
  FEventNext := nil;
  FEventFini := nil;

  FillChar(FEventCurrID, SizeOf(TEventID), #0);
  FillChar(FEventNextID, SizeOf(TEventID), #0);
  FillChar(FEventFiniID, SizeOf(TEventID), #0);

  FEventClose       := CreateEvent(nil, True, False, nil);
  FEventReset       := CreateEvent(nil, True, False, nil);
  FEventClear       := CreateEvent(nil, True, False, nil);
  FEventCommand     := CreateEvent(nil, True, False, nil);
  FEventChanged     := CreateEvent(nil, True, False, nil);
  FEventStart       := CreateEvent(nil, True, False, nil);
  FEventStop        := CreateEvent(nil, True, False, nil);
  FEventCue         := CreateEvent(nil, True, False, nil);
  FEventFinish      := CreateEvent(nil, True, False, nil);
  FEventSchedule    := CreateEvent(nil, True, False, nil);
//  FEventGetStatus   := CreateEvent(nil, True, False, nil);

  FEventStartCompleted    := CreateEvent(nil, True, True, nil);
  FEventStopCompleted     := CreateEvent(nil, True, True, nil);
  FEventCueCompleted      := CreateEvent(nil, True, True, nil);
  FEventFinishCompleted   := CreateEvent(nil, True, True, nil);

  FEventCompleted := CreateEvent(nil, True, True, nil);

  FEventCommandFinished := CreateEvent(nil, True, False, nil);

  FEventControlThread := TEventControlThread.Create(Self);

  FNumCued := 0;
  FCuedDurTime := 0;

  FDestroying := False;

  FreeOnTerminate := False;

  inherited Create(True);
end;

destructor TDeviceThread.Destroy;
var
  I: Integer;
begin
  if (FEventControlThread <> nil) then
  begin
    FEventControlThread.Close;
//    FEventControlThread.Terminate;
    FEventControlThread.WaitFor;
    FreeAndNil(FEventControlThread);
  end;

  FDestroying := True;

  CloseHandle(FEventClose);
  CloseHandle(FEventReset);
  CloseHandle(FEventClear);
  CloseHandle(FEventCommand);
  CloseHandle(FEventChanged);
  CloseHandle(FEventStart);
  CloseHandle(FEventStop);
  CloseHandle(FEventCue);
  CloseHandle(FEventFinish);
  CloseHandle(FEventSchedule);
//  CloseHandle(FEventGetStatus);


  CloseHandle(FEventStartCompleted);
  CloseHandle(FEventStopCompleted);
  CloseHandle(FEventCueCompleted);
  CloseHandle(FEventFinishCompleted);

  CloseHandle(FEventCompleted);

  CloseHandle(FEventCommandFinished);

  ClearEventQueueAll;
  FreeAndNil(FEventQueue);

  FreeAndNil(FEventLock);

  inherited Destroy;
end;

procedure TDeviceThread.Close;
begin
//  if (FGetStatusThread <> nil) then FGetStatusThread.Close;

  SetEvent(FEventClose);
  SetEvent(FEventCompleted);
  SetEvent(FEventCommandFinished);

  Terminate;
end;

function TDeviceThread.GetEventCurr: PEvent;
begin
  FEventLock.Enter;
  try
    Result := FEventCurr;
  finally
    FEventLock.Leave;
  end;
end;

function TDeviceThread.GetEventNext: PEvent;
begin
  FEventLock.Enter;
  try
    Result := FEventNext;
  finally
    FEventLock.Leave;
  end;
end;

function TDeviceThread.GetEventFini: PEvent;
begin
  FEventLock.Enter;
  try
    Result := FEventFini;
  finally
    FEventLock.Leave;
  end;
end;

procedure TDeviceThread.SetEventCurr(Value: PEvent);
begin
  if (HasMainControl) then
  begin
    Move(FEventCurrID, FEventOverall.LastAiredEventID, SizeOf(TEventID));
  end;

  FEventLock.Enter;
  try
    FEventCurr := Value;
  finally
    FEventLock.Leave;
  end;

    if (Value <> nil) then
      Move(Value^.EventID, FEventCurrID, SizeOf(TEventID))
    else
      FillChar(FEventCurrID, SizeOf(TEventID), #0);


  if (HasMainControl) then
  begin
    TransmitEventCurrNotify(FEventCurrID);

    Move(FEventCurrID, FEventOverall.OnAirEventID, SizeOf(TEventID));

    Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceThread.SetEventCurr, id=%s', [EventIDToString(FEventCurrID)])));
  end;
end;

procedure TDeviceThread.SetEventNext(Value: PEvent);
begin
  FEventLock.Enter;
  try
    FEventNext := Value;
  finally
    FEventLock.Leave;
  end;

    if (Value <> nil) then
    begin
      if (not (IsEqualEventID(Value^.EventID, FEventNextID))) then
        FNumCued := 0;

      Move(Value^.EventID, FEventNextID, SizeOf(TEventID))
    end
    else
    begin
      FNumCued := 0;
      FillChar(FEventNextID, SizeOf(TEventID), #0);
    end;

  if (HasMainControl) then
  begin
    TransmitEventNextNotify(FEventNextID);

    Move(FEventNextID, FEventOverall.PreparedEventID, SizeOf(TEventID));

    Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceThread.SetEventNext, id=%s', [EventIDToString(FEventNextID)])));
  end;
end;

procedure TDeviceThread.SetEventFini(Value: PEvent);
begin
  FEventLock.Enter;
  try
    FEventFini := Value;
  finally
    FEventLock.Leave;
  end;

    if (Value <> nil) then
      Move(Value^.EventID, FEventFiniID, SizeOf(TEventID))
    else
      FillChar(FEventFiniID, SizeOf(TEventID), #0);

  if (HasMainControl) then
  begin
    TransmitEventFiniNotify(FEventFiniID);

    Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceThread.SetEventFini, id=%s', [EventIDToString(FEventFiniID)])));
  end;
end;

procedure TDeviceThread.SetControlBy(Value: AnsiString);
begin
  FControlBy := Value;
//  PostMessage(frmDeviceList.Handle, WM_UPDATE_DEVICE_CONTROLBY, FDevice^.Handle, NativeInt(PChar(FControlBy)));
end;

procedure TDeviceThread.SetControlChannel(Value: Integer);
var
  MilliSec: Integer;
begin
  if (FControlChannel <> Value) then
  begin
    FControlChannel := Value;

    FControlFrameRateType := GetChannelFrameRateTypeByID(Value);
    FControlIsDropFrame   := GetChannelIsDropFrameByID(Value);

    FEventOverall.ChannelID := Value;

    if (FEventControlThread <> nil) then
    begin
      MilliSec := FrameToMilliSec(Abs(Device^.FrameDelay), FControlFrameRateType);
      if (Device^.FrameDelay > 0) then
        MilliSec := -MilliSec;

      FEventControlThread.DelayMilliSec := MilliSec;
    end;
  end;
end;

procedure TDeviceThread.TransmitNotifyStatus(AHandle: TDeviceHandle; AStatus: TDeviceStatus);
var
  Data: AnsiString;
  Buffer: AnsiString;
begin
  if (not HasMainControl) then exit;

//    if (FControlBy = '') then exit;

  SetLength(Data, SizeOf(TDeviceStatus));
  Move(AStatus, Data[1], Sizeof(AStatus));

  Buffer := IntToAnsiString(AHandle) + Data;

  if (GV_ConfigGeneral.NotifyBroadcast) then
    frmDCS.TransmitNotifyResponse('', GV_ConfigGeneral.NotifyPort, $00, $00, Buffer, Length(Buffer))
  else
    frmDCS.TransmitNotifyResponse(ControlBy, GV_ConfigGeneral.NotifyPort, $00, $00, Buffer, Length(Buffer));
end;

procedure TDeviceThread.TransmitNotifyEventStatus(AEventID: TEventID; AStatus: TEventStatus);
var
  Data1, Data2: AnsiString;
  Buffer: AnsiString;
begin
  if (not HasMainControl) then exit;

//    if (FControlBy = '') then exit;

  SetLength(Data1, SizeOf(TEventID));
  Move(AEventID, Data1[1], Sizeof(AEventID));

  SetLength(Data2, SizeOf(TEventStatus));
  Move(AStatus, Data2[1], Sizeof(AStatus));

  Buffer := IntToAnsiString(Device^.Handle) + Data1 + Data2;

  if (GV_ConfigGeneral.NotifyBroadcast) then
    frmDCS.TransmitNotifyResponse('', GV_ConfigGeneral.NotifyPort, $00, $01, Buffer, Length(Buffer))
  else
    frmDCS.TransmitNotifyResponse(ControlBy, GV_ConfigGeneral.NotifyPort, $00, $01, Buffer, Length(Buffer));
end;

procedure TDeviceThread.TransmitNotifyEventOverall(AHandle: TDeviceHandle; AOverall: TEventOverall);
var
  Data: AnsiString;
  Buffer: AnsiString;
begin
  if (not HasMainControl) then exit;

//    if (FControlBy = '') then exit;

  SetLength(Data, SizeOf(TEventOverall));
  Move(AOverall, Data[1], Sizeof(AOverall));

  Buffer := IntToAnsiString(AHandle) + Data;

  if (GV_ConfigGeneral.NotifyBroadcast) then
    frmDCS.TransmitNotifyResponse('', GV_ConfigGeneral.NotifyPort, $00, $02, Buffer, Length(Buffer))
  else
    frmDCS.TransmitNotifyResponse(FControlBy, GV_ConfigGeneral.NotifyPort, $00, $02, Buffer, Length(Buffer));
end;

procedure TDeviceThread.TransmitDeviceStatusNotify(AHandle: TDeviceHandle; AStatus: TDeviceStatus);
var
  Data: AnsiString;
  Buffer: AnsiString;
begin
  if (not HasMainControl) then exit;

  SetLength(Data, SizeOf(TDeviceStatus));
  Move(AStatus, Data[1], Sizeof(AStatus));

  Buffer := IntToAnsiString(AHandle) + Data;

  frmDCS.TransmitEventStatusNotify('', GV_ConfigGeneral.EventStatusNotifyPort, $60, $00, Buffer, Length(Buffer));
end;

procedure TDeviceThread.TransmitEventStatusNotify(AEventID: TEventID; AStatus: TEventStatus);
var
  Data1, Data2: AnsiString;
  Buffer: AnsiString;
begin
  if (not HasMainControl) then exit;

  SetLength(Data1, SizeOf(TEventID));
  Move(AEventID, Data1[1], Sizeof(AEventID));

  SetLength(Data2, SizeOf(TEventStatus));
  Move(AStatus, Data2[1], Sizeof(AStatus));

  Buffer := IntToAnsiString(Device^.Handle) + Data1 + Data2;

  frmDCS.TransmitEventStatusNotify('', GV_ConfigGeneral.EventStatusNotifyPort, $60, $01, Buffer, Length(Buffer));
end;

procedure TDeviceThread.TransmitEventCurrNotify(AEventID: TEventID);
var
  Data: AnsiString;
  Buffer: AnsiString;
begin
  if (not HasMainControl) then exit;

  SetLength(Data, SizeOf(TEventID));
  Move(AEventID, Data[1], Sizeof(AEventID));

  Buffer := IntToAnsiString(Device^.Handle) + Data;

  frmDCS.TransmitEventStatusNotify('', GV_ConfigGeneral.EventStatusNotifyPort, $60, $10, Buffer, Length(Buffer));
end;

procedure TDeviceThread.TransmitEventNextNotify(AEventID: TEventID);
var
  Data: AnsiString;
  Buffer: AnsiString;
begin
  if (not HasMainControl) then exit;

  SetLength(Data, SizeOf(TEventID));
  Move(AEventID, Data[1], Sizeof(AEventID));

  Buffer := IntToAnsiString(Device^.Handle) + Data;

  frmDCS.TransmitEventStatusNotify('', GV_ConfigGeneral.EventStatusNotifyPort, $60, $11, Buffer, Length(Buffer))
end;

procedure TDeviceThread.TransmitEventFiniNotify(AEventID: TEventID);
var
  Data: AnsiString;
  Buffer: AnsiString;
begin
  if (not HasMainControl) then exit;

  SetLength(Data, SizeOf(TEventID));
  Move(AEventID, Data[1], Sizeof(AEventID));

  Buffer := IntToAnsiString(Device^.Handle) + Data;

  frmDCS.TransmitEventStatusNotify('', GV_ConfigGeneral.EventStatusNotifyPort, $60, $12, Buffer, Length(Buffer))
end;

procedure TDeviceThread.TransmitRemoveEventNotify(AEventID: TEventID);
var
  Data: AnsiString;
  Buffer: AnsiString;
begin
  if (not HasMainControl) then exit;

  SetLength(Data, SizeOf(TEventID));
  Move(AEventID, Data[1], Sizeof(AEventID));

  Buffer := IntToAnsiString(Device^.Handle) + Data;

  frmDCS.TransmitEventStatusNotify('', GV_ConfigGeneral.EventStatusNotifyPort, $60, $20, Buffer, Length(Buffer))
end;

procedure TDeviceThread.ControlReset;
begin
  ResetEvent(FEventReset);
  try

  //  ClearEventQueueAll;

    DeviceClose;
    DeviceOpen;

    DeviceInit;

  finally
    SetEvent(FEventCompleted);
  end;
end;

procedure TDeviceThread.ControlCommand;
begin
  ResetEvent(FEventCommand);
  try

  finally
    SetEvent(FEventCommandFinished);
    SetEvent(FEventCompleted);
  end;
end;

procedure TDeviceThread.ControlClear;
var
  ChannelForm: TfrmChannelEvents;
begin
  ResetEvent(FEventClear);
  try

  {  ClearEventQueueByChannelID(FClearChannel);

    ChannelForm := frmDCS.GetChannelFormByID(FClearChannel);
    if (ChannelForm <> nil) then
    begin
      ChannelForm.ClearEvent(FDevice);
    end; }

//    FEventLock.Enter;
    try
      EventCurr := nil;
      EventNext := nil;
      EventFini := nil;
    finally
//      FEventLock.Leave;
    end;

  {  DeviceInit;

    ClearEventQueueAll; }
  finally
    SetEvent(FEventCompleted);
  end;
end;

procedure TDeviceThread.ControlChanged;
begin
  ResetEvent(FEventChanged);
  try

  finally
    SetEvent(FEventCompleted);
  end;
end;

procedure TDeviceThread.ControlStart;
var
  E: PEvent;
begin
//  Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceThread.ControlStart Begin', [])));
  ResetEvent(FEventStart);
  try
    FNumCued := 0;

//    FEventLock.Enter;
    try
      EventCurr := EventNext;
      EventNext := GetNextEvent;
    finally
//      FEventLock.Leave;
    end;
  finally
//    Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceThread.ControlStart End', [])));

    SetEvent(FEventCompleted);
    SetEvent(FEventStartCompleted);
  end;

//  FEventCurr := FEventNext;
//  FEventNext := nil;
end;

procedure TDeviceThread.ControlStop;
begin
  Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceThread.ControlStop Begin', [])));
  ResetEvent(FEventStop);
  try
//    FEventLock.Enter;
    try
//      if (EventCurr <> nil) then
      begin
        EventFini := EventCurr;
        EventCurr := nil;
      end;
    finally
//      FEventLock.Leave;
    end;

  finally
    Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceThread.ControlStop End', [])));

    SetEvent(FEventCompleted);
    SetEvent(FEventStopCompleted);
  end;
end;

procedure TDeviceThread.ControlFinish;
var
  E: PEvent;
begin
  Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceThread.ControlFinish Begin', [])));
  ResetEvent(FEventFinish);
  try
      if (EventFini <> nil) then
      begin
        E := EventFini;
        EventFini := nil;

    FEventLock.Enter;
    try
          FEventQueue.Remove(E);
          Assert(False, GetLogDevice(lsNormal, FControlBy, ControlChannel,
                                     Format('TDeviceThread.ControlFinish : Remove event of the event queue, id = %s, start = %s, duration = %s',
                                            [EventIDToString(E^.EventID),
                                             EventTimeToDateTimecodeStr(E^.StartTime, ControlFrameRateType, True),
                                             TimecodeToString(E^.DurTime, ControlIsDropFrame)])));

          TransmitRemoveEventNotify(E^.EventID);

          Dispose(E);
    finally
      FEventLock.Leave;
    end;
      end;
  finally
    Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceThread.ControlFinish End', [])));

    SetEvent(FEventCompleted);
    SetEvent(FEventFinishCompleted);
  end;
end;

procedure TDeviceThread.ControlCue;
begin
  Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceThread.ControlCue Start', [])));
  ResetEvent(FEventCue);
  try
    Inc(FNumCued);
  finally
    Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceThread.ControlCue Finish', [])));

    SetEvent(FEventCompleted);
    SetEvent(FEventCueCompleted);
  end;
end;

procedure TDeviceThread.ControlSchedule;
var
  E: PEvent;
  SaveState: TEventState;
  ChannelForm: TfrmChannelEvents;
begin
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlSchedule Start', [])));
  ResetEvent(FEventSchedule);
  try
  //  if (FEventCurr <> nil) or (FEventNext = nil) then

//    FEventLock.Enter;
    try
      if (EventNext = nil) or
         ((EventNext <> nil) and {(EventNext^.Status.State <> esError) and }(EventNext^.Status.State <= esLoaded)) then
      begin
//        FNumCued := 0;
        EventNext := GetNextEvent;
      end;
    finally
//      FEventLock.Leave;
    end;

    // 현재 시각 이전의 송출중이지 않은 이벤트는 삭제 - 추후 고려

    // 다음 송출 이벤트 찾기
  finally
    SetEvent(FEventCompleted);
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlSchedule Finish', [])));
  end;
end;

procedure TDeviceThread.ControlGetStatus;
begin
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDeviceThread.ControlGetStatus CheckStatus Start1111', [])));
  if (not HasMainControl) then exit;

//FEventLock.Enter;
try
  if (FDevice^.CheckStatus) then
  begin
  //  if (HasMainControl) then
    begin
  //    ResetEvent(FEventGetStatus);
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDeviceThread.ControlGetStatus CheckStatus Start', [])));
      GetStatus;
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDeviceThread.ControlGetStatus CheckStatus End', [])));
    end;
  end
  else
  begin
    FillChar(FDevice^.Status, SizeOf(TDeviceStatus), #0);
    FDevice^.Status.Connected := True;

    UpdateStatus;
  end;
finally
//  FEventLock.Leave;
end;
end;

procedure TDeviceThread.WaitForEventCompleted(AWaitMillisec: Cardinal);
begin
//  WaitForSingleObject(FEventStartCompleted, AWaitMillisec);
//  WaitForSingleObject(FEventStopCompleted, AWaitMillisec);
//  WaitForSingleObject(FEventCueCompleted, AWaitMillisec);
//  WaitForSingleObject(FEventFinishCompleted, AWaitMillisec);
end;

procedure TDeviceThread.DoEventControl;
var
  Curr, Next, Fini: PEvent;

  EventID: TEventID;

  CurrTime: TDateTime;
  StartTime, EndTime: TDateTime;

  FinishTime: TDateTime;

  CueTime: TConfigCueTimeList;
  ActCueTime: TDateTime;
begin
//  WaitForSingleObject(FEventExecute, INFINITE);

  if (not HasMainControl) then exit;

//  with FDeviceThread do
  begin
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start', [])));
//    WaitForSingleObject(FEventCompleted, INFINITE);

//    CurrTime := SystemTimeToDateTime(GV_TimeCurrent);
    CurrTime := Now;//SystemTimeToDateTime(GV_TimeCurrent);


//fEventLock.Enter;
try
  Curr := EventCurr;
  Next := EventNext;
  Fini := EventFini;

    if (Curr <> nil) then
    begin
            if (Curr^.Status.State <= esOnAir) then
//      if (Curr^.Status.State <= esOnAir) then
      begin
        EndTime := EventTimeToDateTime(GetEventEndTime(Curr^.StartTime, Curr^.DurTime, ControlFrameRateType), ControlFrameRateType);
        EndTime := IncMilliSecond(EndTime, -FrameToMilliSec(1, ControlFrameRateType));

        if (EndTime <= CurrTime) then
        begin
//          SetEventStatus(Curr, esFinish);
//            OutputDebugString(PChar(DateTimeToStr(EndTime)));
          ResetEvent(FEventStopCompleted);

          EventID := Curr^.EventID;
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Stop Start. id = %s, start = %s, end = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Curr^.StartTime, ControlFrameRateType), EventTimeToDateTimecodeStr(DateTimeToEventTime(EndTime, ControlFrameRateType), ControlFrameRateType)])));
          SetEvent(FEventStop);
          exit;
//          WaitForSingleObject(FEventStopCompleted, FDeviceCommandTimeout);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Stop End. id = %s, start = %s end = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Curr^.StartTime, ControlFrameRateType), EventTimeToDateTimecodeStr(DateTimeToEventTime(EndTime, ControlFrameRateType), ControlFrameRateType)])));
//  WaitForSingleObject(FEventExecute, INFINITE);
//          else
        end;
      end;
    end;

    if (Fini <> nil) then
    begin
      if (Fini^.Status.State <= esFinish) then
      begin
        EndTime := EventTimeToDateTime(GetEventEndTime(Fini^.StartTime, Fini^.DurTime, ControlFrameRateType), ControlFrameRateType);
        EndTime := IncMilliSecond(EndTime, TimecodeToMilliSec(FFinishActionDelayTime, ControlFrameRateType));
        EndTime := IncMilliSecond(EndTime, -FrameToMilliSec(1, ControlFrameRateType));

        if (EndTime <= CurrTime) then
        begin
//          SetEventStatus(Fini, esFinishing);

//            OutputDebugString(PChar(DateTimeToStr(EndTime)));
          ResetEvent(FEventFinishCompleted);

          EventID := Fini^.EventID;
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Finish Start. id = %s, start = %s, end = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Fini^.StartTime, ControlFrameRateType), EventTimeToDateTimecodeStr(DateTimeToEventTime(EndTime, ControlFrameRateType), ControlFrameRateType)])));
          SetEvent(FEventFinish);
          exit;
//          WaitForSingleObject(FEventFinishCompleted, FFinishActionTimeOut);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Finish End. id = %s, start = %s, end = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Fini^.StartTime, ControlFrameRateType), EventTimeToDateTimecodeStr(DateTimeToEventTime(EndTime, ControlFrameRateType), ControlFrameRateType)])));
//  WaitForSingleObject(FEventExecute, INFINITE);
//          else
        end;
      end;
    end;

//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start 1', [])));
    if (Next <> nil) then
    begin
      StartTime := EventTimeToDateTime(Next^.StartTime, ControlFrameRateType);
      if (FDevice^.DeviceType in [DT_PCS_MEDIA, DT_LOUTH]) then
        StartTime := IncMilliSecond(StartTime, -FrameToMilliSec(1, ControlFrameRateType));

//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start 1-1', [])));
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start 1-1, id = %s, start = %s, status %s', [EventIDToString(Next^.EventID), EventTimeToDateTimecodeStr(Next^.StartTime), EventStatusNames[Next^.Status.State]])));

      if (Next^.Status.State <= esLoaded) {and (StartTime > CurrTime)} then
      begin
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start 1-2', [])));
        // 장비 유형별 cue time 구함
        case FDevice^.DeviceType of
          DT_PCS_MEDIA,
          DT_LOUTH..DT_OMNEON,
          DT_LINE:
          begin
            CueTime := GV_ConfigEventVS.CueTime;
          end;
          DT_SBC:
          begin
            CueTime := GV_ConfigEventVCR.CueTime;
          end;
          DT_PCS_CG,
          DT_TAPI..DT_NSC:
          begin
            CueTime := GV_ConfigEventCG.CueTime;
          end;
          DT_PCS_SWITCHER,
          DT_VTS..DT_VIK:
          begin
            CueTime := GV_ConfigEventMCS.PSTSetTime;
          end;
        else
          CueTime := nil;
        end;

        // Default cue ready before 10 seconds
        ActCueTime := IncMilliSecond(CurrTime, 10000);

        if (CueTime <> nil) and (FNumCued >= 0) and (FNumCued < CueTime.Count) then
//           (Next^.Status.State < esCued) then
        begin
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start 1-3', [])));

          ActCueTime := IncMilliSecond(CurrTime, TimecodeToMilliSec(CueTime[FNumCued].CueTime, ControlFrameRateType));
          if {(Next^.ManualEvent) or }(StartTime <= ActCueTime) then
          begin
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start 1-4', [])));
//            SetEventStatus(Next, esCueing);

            ResetEvent(FEventCueCompleted);

          EventID := Next^.EventID;
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Cue Start. id = %s, start = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Next^.StartTime, ControlFrameRateType)])));
            SetEvent(FEventCue);
          exit;
//            WaitForSingleObject(FEventCueCompleted, FCueTimeout);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Cue End. id = %s, start = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Next^.StartTime, ControlFrameRateType)])));
//  WaitForSingleObject(FEventExecute, INFINITE);
          end;
        end;
      end;


//            if (Next^.Status.State in [esLoaded]) then
//            begin
//              if {(Curr = nil) or } (Next^.ManualEvent) or (StartTime <= IncSecond(CurrTime, 10)) then
//              begin
//                ResetEvent(FEventCompleted);
//                SetEvent(FEventCue);
//                WaitForSingleObject(FEventCompleted, INFINITE);
//              end;
//            end
//            else if {(FNext^.Status.State = esCued) and} (StartTime <= CurrTime) {and
//                    ((not FNext^.ManualEvent) or (FNext^.TakeEvent))} then
//            begin
////            OutputDebugString(PChar(DateTimeToStr(StartTime)));
//              ResetEvent(FEventCompleted);
//              SetEvent(FEventStart);
//              WaitForSingleObject(FEventCompleted, INFINITE);
//            end;

      // 다음 이벤트의 시작시간이 자났을때 Start에서 다음 이벤트를 가져오기 위해
      // 상태가 error, cued를 같이 비교함
      if (Next^.Status.State <= esCued) and (StartTime <= CurrTime) then
      begin
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start 1-5', [])));

////        if (Curr <> nil) and (Curr^.Status.State <= esOnAir) then
//        if (Curr <> nil) and (Curr^.Status.State = esOnAir) then
//        begin
////                if (Curr^.Status.State = esOnAir) then
////          if (Curr^.Status.State <= esOnAir) then
//          begin
////          SetEventStatus(Curr, esFinish);
//
//            ResetEvent(FEventStopCompleted);
//            SetEvent(FEventStop);
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Stop 2', [])));
////          exit;
//            WaitForSingleObject(FEventStopCompleted, INFINITE);
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Stop 2-1', [])));
//          end;
//        end;

//              Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('NextEvnt, Index = %d, ID = %s', [FEventQueue.IndexOf(FDeviceThread.Next), EventIDToString(FDeviceThread.Next^.EventID)])));


//          SetEventStatus(Next, esOnAir);
//            OutputDebugString(PChar(DateTimeToStr(StartTime)));
        ResetEvent(FEventStartCompleted);

          EventID := Next^.EventID;
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start Start. id = %s, start = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Next^.StartTime, ControlFrameRateType)])));
        SetEvent(FEventStart);
          exit;
//        WaitForSingleObject(FEventStartCompleted, FDeviceCommandTimeout);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start End. id = %s, start = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Next^.StartTime, ControlFrameRateType)])));
//  WaitForSingleObject(FEventExecute, INFINITE);
      end;

    end;

//          Sleep(30);
finally
//  fEventLock.Leave;
end;
  end;
end;

procedure TDeviceThread.Execute;
var
  WaitResult: Integer;
  WaitHandles: array[0..10] of THandle;
//  WaitHandles: array[0..9] of THandle;
begin
  if (FEventControlThread <> nil) then
    FEventControlThread.Start;

  WaitHandles[0] := FEventClose;
  WaitHandles[1] := FEventReset;
  WaitHandles[2] := FEventClear;
  WaitHandles[3] := FEventCommand;
  WaitHandles[4] := FEventChanged;
  WaitHandles[5] := FEventStart;
  WaitHandles[6] := FEventStop;
  WaitHandles[7] := FEventFinish;
  WaitHandles[8] := FEventCue;
  WaitHandles[9] := FEventSchedule;
  WaitHandles[10] := GV_TimerExecuteEvent;// FEventGetStatus;

  while not Terminated do
  begin
//    Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDeviceThread.Execute Start', [])));
    WaitResult := WaitForMultipleObjects(11, @WaitHandles, False, INFINITE);
//    WaitResult := WaitForMultipleObjects(10, @WaitHandles, False, DEVICE_STATUS_TIMEOUT);
//    Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDeviceThread.Execute WaitResult = %d', [WaitResult])));
    case WaitResult of
      WAIT_OBJECT_0: break;
      WAIT_OBJECT_0 + 1: ControlReset;
      WAIT_OBJECT_0 + 2: ControlClear;
      WAIT_OBJECT_0 + 3: ControlCommand;
      WAIT_OBJECT_0 + 4: ControlChanged;
      WAIT_OBJECT_0 + 5: ControlStart;
      WAIT_OBJECT_0 + 6: ControlStop;
      WAIT_OBJECT_0 + 7: ControlFinish;
      WAIT_OBJECT_0 + 8: ControlCue;
      WAIT_OBJECT_0 + 9: ControlSchedule;
      WAIT_OBJECT_0 + 10: ControlGetStatus;
//      else ControlGetStatus;
    end;
//    Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDeviceThread.Execute End', [])));
  end;
{var
  WaitResult: Integer;
  WaitHandles: array[0..11] of THandle;
//  WaitHandles: array[0..9] of THandle;
begin
//  if (FEventControlThread <> nil) then
//    FEventControlThread.Start;

  WaitHandles[0] := FEventClose;
  WaitHandles[1] := FEventReset;
  WaitHandles[2] := FEventClear;
  WaitHandles[3] := FEventCommand;
  WaitHandles[4] := FEventChanged;
  WaitHandles[5] := FEventStart;
  WaitHandles[6] := FEventStop;
  WaitHandles[7] := FEventFinish;
  WaitHandles[8] := FEventCue;
  WaitHandles[9] := FEventSchedule;
  WaitHandles[10] := GV_DeviceTimerExecuteEvent;
  WaitHandles[11] := GV_TimerExecuteEvent;// FEventGetStatus;

  while not Terminated do
  begin
    WaitResult := WaitForMultipleObjects(12, @WaitHandles, False, INFINITE);
//    WaitResult := WaitForMultipleObjects(10, @WaitHandles, False, 1000);
    case WaitResult of
      WAIT_OBJECT_0: break;
      WAIT_OBJECT_0 + 1: ControlReset;
      WAIT_OBJECT_0 + 2: ControlClear;
      WAIT_OBJECT_0 + 3: ControlCommand;
      WAIT_OBJECT_0 + 4: ControlChanged;
      WAIT_OBJECT_0 + 5: ControlStart;
      WAIT_OBJECT_0 + 6: ControlStop;
      WAIT_OBJECT_0 + 7: ControlFinish;
      WAIT_OBJECT_0 + 8: ControlCue;
      WAIT_OBJECT_0 + 9: ControlSchedule;
      WAIT_OBJECT_0 + 10: DoEventControl;
      WAIT_OBJECT_0 + 11: ControlGetStatus;
//      WAIT_TIMEOUT: ControlGetStatus;
    end;
  end;
}
{  WaitHandles[0] := FEventClose;
  WaitHandles[1] := FEventStart;
  WaitHandles[2] := FEventStop;
  WaitHandles[3] := FEventCue;
  WaitHandles[4] := FEventSchedule;
  WaitHandles[5] := FEventReset;
  WaitHandles[6] := FEventClear;
  WaitHandles[7] := FEventCommand;
  WaitHandles[8] := FEventChanged;
  WaitHandles[9] := GV_TimerExecuteEvent;// FEventGetStatus;

  while not Terminated do
  begin
    WaitResult := WaitForMultipleObjects(10, @WaitHandles, False, INFINITE);
    case WaitResult of
      WAIT_OBJECT_0: break;
      WAIT_OBJECT_0 + 1: ControlStart;
      WAIT_OBJECT_0 + 2: ControlStop;
      WAIT_OBJECT_0 + 3: ControlCue;
      WAIT_OBJECT_0 + 4: ControlSchedule;
      WAIT_OBJECT_0 + 5: ControlReset;
      WAIT_OBJECT_0 + 6: ControlClear;
      WAIT_OBJECT_0 + 7: ControlCommand;
      WAIT_OBJECT_0 + 8: ControlChanged;
      WAIT_OBJECT_0 + 9: ControlGetStatus;
//      else ControlGetStatus;
    end;
  end; }

end;

function TDeviceThread.GetStatus: TDeviceStatus;
begin
  if (not HasMainControl) then exit;

//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDeviceThread.GetStatus Start', [])));
          try
//  FDevice^.Status := Result;
  Move(Result, FDevice^.Status, SizeOf(TDeviceStatus));

  UpdateStatus;
          finally
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDeviceThread.GetStatus End', [])));
          end;
end;

procedure TDeviceThread.UpdateStatus;
begin
  if (not HasMainControl) then exit;

  PostMessage(frmDeviceList.Handle, WM_UPDATE_DEVICE_STATUS, FDevice^.Handle, NativeInt(@FDevice^.Status));
  TransmitNotifyStatus(FDevice^.Handle, FDevice^.Status);
  TransmitDeviceStatusNotify(FDevice^.Handle, FDevice^.Status);
end;

function TDeviceThread.GetEventByID(AEventID: TEventID): PEvent;
var
  I: Integer;
  E: PEvent;
begin
  Result := nil;

  FEventLock.Enter;
  try
    for I := 0 to FEventQueue.Count - 1 do
    begin
      E := FEventQueue[I];
      if (IsEqualEventID(E^.EventID, AEventID)) then
      begin
        Result := E;
        break;
      end;
    end;
  finally
    FEventLock.Leave;
  end;
end;

function TDeviceThread.GetEventByStartTime(AEventTime: TEventTime): PEvent;
var
  I: Integer;
  E: PEvent;
begin
  Result := nil;

  FEventLock.Enter;
  try
    for I := 0 to FEventQueue.Count - 1 do
    begin
      E := FEventQueue[I];
      if (CompareEventTime(E^.StartTime, AEventTime, ControlFrameRateType) >= 0) then
      begin
        Result := E;
        break;
      end;
    end;
  finally
    FEventLock.Leave;
  end;
end;

function TDeviceThread.GetEventByInRangeTime(AStartTime, AEndTime: TEventTime): PEvent;
var
  I: Integer;
  E: PEvent;
begin
//  Assert(False, GetLogDevice(lsNormal, 'TDeviceThread.GetEventByInRangeTime, Start'));
  Result := nil;

//  Assert(False, GetLogDevice(lsNormal, 'TDeviceThread.GetEventByInRangeTime, Start 111'));
  FEventLock.Enter;
  try
    for I := 0 to FEventQueue.Count - 1 do
    begin
      E := FEventQueue[I];
//  Assert(False, GetLogDevice(lsNormal, 'TDeviceThread.GetEventByInRangeTime, Start 222'));
      if (CompareEventTime(E^.StartTime, AStartTime, ControlFrameRateType) >= 0) and (CompareEventTime(E^.StartTime, AEndTime, ControlFrameRateType) < 0) then
      begin
        Result := E;
        break;
      end;
//  Assert(False, GetLogDevice(lsNormal, 'TDeviceThread.GetEventByInRangeTime, Start 333'));
    end;
  finally
    FEventLock.Leave;
  end;
end;

function TDeviceThread.GetNextEvent: PEvent;
var
  I: Integer;
  E: PEvent;
begin
  Result := nil;

//  if (FEventNext <> nil) and (FEventNext^.Status = esCued) then
//  begin
//    Result := FEventNext;
//    exit;
//  end;

  FEventLock.Enter;
  try
    if (FEventQueue.Count > 0) then
    begin
  {    for I := 0 to FEventQueue.Count - 1 do
      begin
        if (FEventQueue[I]^.Status = esLoaded) then
        begin
          Result := FEventQueue[I];
          break;
        end;
      end;



      exit;  }

  {    if (FEventQueue[0]^.Status in [esLoaded, esCued]) then
        Result := FEventQueue[0]
      else if (FEventQueue.Count > 1) and (FEventQueue[1]^.Status in [esLoaded, esCued]) then
          Result := FEventQueue[1]
      else if (FEventQueue.Count > 2) and (FEventQueue[2]^.Status in [esLoaded, esCued]) then
          Result := FEventQueue[2]; }

  //    if (FEventCurr <> nil) and (FEventQueue.Count > 1) and
  //       (FEventQueue[1]^.Status in [esLoaded, esCued, esError]) then
  //      Result := FEventQueue[1]
  //    else if (FEventQueue[0]^.Status in [esLoaded, esCued, esError]) then
  //      Result := FEventQueue[0]

        while True do
        begin
          Result := nil;
//          if (EventCurr <> nil) and (FEventQueue.Count > 1) then
//           Result := FEventQueue[1]
          if (EventCurr <> nil) then
          begin
            I := FEventQueue.IndexOf(EventCurr) + 1;
            if (I < FEventQueue.Count) then
              Result := FEventQueue[I];
          end
          else if (EventFini <> nil) then
          begin
            I := FEventQueue.IndexOf(EventFini) + 1;
            if (I < FEventQueue.Count) then
              Result := FEventQueue[I];
          end
          else if (FEventQueue.Count > 0) then //if (EventNext = nil) then
            Result := FEventQueue[0];

{          if (Result = nil) then break;
          if (CompareEventTime(GetEventEndTime(Result^.StartTime, Result^.DurTime), DateTimeToEventTime(Now)) < 0) then
          begin
            FEventQueue.Remove(Result);

            Assert(False, GetLogDevice(lsNormal, FControlBy, Result^.EventID.ChannelID,
                                       Format('TDeviceThread.GetNextEvent : Remove event of the event queue, id = %s, start = %s, duration = %s',
                                              [EventIDToString(Result^.EventID),
                                               EventTimeToDateTimecodeStr(Result^.StartTime, True),
                                               TimecodeToString(Result^.DurTime)])));

            Dispose(Result);
          end
          else }
            break;
        end;

        if (Result <> nil) then
          Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('GetNextEvent, index = %d, id = %s, start time = %s', [FEventQueue.IndexOf(Result), EventIDToString(Result^.EventID), EventTimeToString(Result^.StartTime, ControlFrameRateType)])))
        else
          Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('GetNextEvent nil', [])))


{        for I := 0 to FEventQueue.Count - 1 do
        begin
          E := FEventQueue[I];
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('GetN,extEvnt, Index = %d, ID = %s', [I, EventIDToString(E^.EventID)])));
        end; }

//        if (Result <> nil) then
//            Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('GetNextEvnt, Index = %d, ID = %s', [FEventQueue.IndexOf(Result), EventIDToString(Result^.EventID)])));



  //    if {(FEventCurr = nil) and }(FEventQueue[0]^.Status in [esLoaded, esCued]) then
  //      Result := FEventQueue[0]
  //    else if {(FEventCurr <> nil) and }(FEventQueue.Count > 1) and
  //       (FEventQueue[1]^.Status in [esLoaded, esCued]) then
  //      Result := FEventQueue[1];
  //    else if True then


  {    if (Result <> FEventNext) and
         (FEventNext <> nil) and (FEventNext^.Status >= esCued) then
      begin
        Result^.Status := esSkipped;
        Result := nil;
      end; }
    end;
  finally
    FEventLock.Leave;
  end;
end;

function TDeviceThread.GetCurrEvent: PEvent;
begin
  Result := nil;

  FEventLock.Enter;
  try
    if (FEventQueue.Count > 0) and (FEventQueue[0]^.TakeEvent) then
      Result := FEventQueue[0];
  finally
    FEventLock.Leave;
  end;
end;

procedure TDeviceThread.ClearEventQueueByChannelID(AChannelID: Word);
var
  I: Integer;
  E: PEvent;
  SaveNumEventInQueue: Integer;
begin
    if (not FDestroying) then
    begin
      if (EventCurr <> nil) then //and (FEventQueue.IndexOf(EventCurr) < 0) then
        EventCurr := nil;

      if (EventNext <> nil) then //and (FEventQueue.IndexOf(EventNext) < 0) then
        EventNext := nil;

      if (EventFini <> nil) then //and (FEventQueue.IndexOf(EventFini) < 0) then
        EventFini := nil;
    end;

  FEventLock.Enter;
  try
    for I := FEventQueue.Count - 1 downto 0 do
    begin
      E := FEventQueue[I];
      if (E <> nil) and (E^.EventID.ChannelID = AChannelID) then
      begin
        if (not FDestroying) then
          SetEventStatus(E, esIdle);

        FEventQueue.Remove(E);
        Dispose(E);
      end;
    end;
    SaveNumEventInQueue := FEventOverall.NumEventInQueue;

    FEventOverall.NumEventInQueue     := FEventQueue.Count;
    FEventOverall.NumFreeEntryInQueue := FEventOverall.NumFreeEntryInQueue - (SaveNumEventInQueue - FEventOverall.NumEventInQueue);
  finally
    FEventLock.Leave;
  end;
end;

procedure TDeviceThread.ClearEventQueueAll;
var
  I: Integer;
  E: PEvent;
begin
  FEventLock.Enter;
  try
    for I := FEventQueue.Count - 1 downto 0 do
    begin
      E := FEventQueue[I];
      if (E <> nil) then
      begin
// 정상적인 종료의 경우 이벤트의 상태를 변경하지 않음
        if (not FDestroying) then
          SetEventStatus(E, esIdle);

//        FEventLock.Enter;
//        try
          Dispose(E);
//        finally
//          FEventLock.Leave;
//        end;
      end;
    end;

    FEventQueue.Clear;
  finally
    FEventLock.Leave;
  end;

    // 정상적으로 종료했을 경우에는 백업 장비에 이벤트 정보를 전송하지 않기 위해서 FDestroying을 사용
    if (not FDestroying) then
    begin
      EventCurr := nil;
      EventNext := nil;
      EventFini := nil;
    end;

    FEventOverall.NumEventInQueue     := 0;
    FEventOverall.NumFreeEntryInQueue := 0;
end;

procedure TDeviceThread.EventQueueQuickSort(L, R: Integer);
var
  I, J, P: Integer;
  Save: PEvent;
  SortList: TEventList;

  function Compare(Item1, Item2: PEvent): Integer;
  var
    ID1, ID2: String;
  begin
    Result := CompareEventTime(Item1^.StartTime, Item2^.StartTime, ControlFrameRateType);
    if (Result = EqualsValue) then
    begin
      ID1 := EventIDToString(Item1^.EventID);
      ID2 := EventIDToString(Item2^.EventID);

      if (ID1 = ID2) then
        Result := EqualsValue
      else if (ID1 < ID2) then
        Result := LessThanValue
      else
        Result := GreaterThanValue;
    end;
  end;

begin
  FEventLock.Enter;
  try
    SortList := FEventQueue;
    repeat
      I := L;
      J := R;
      P := (L + R) shr 1;
      repeat
        while Compare(FEventQueue[I], FEventQueue[P]) < 0 do
          Inc(I);
        while Compare(FEventQueue[J], FEventQueue[P]) > 0 do
          Dec(J);
        if I <= J then
        begin
          Save        := SortList[I];
          SortList[I] := SortList[J];
          SortList[J] := Save;
          if P = I then
            P := J
          else if P = J then
            P := I;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then
        EventQueueQuickSort(L, J);
      L := I;
    until I >= R;
  finally
    FEventLock.Leave;
  end;
end;

procedure TDeviceThread.EventQueueSort;
begin
  if (FEventQueue.Count > 1) then EventQueueQuickSort(0, pred(FEventQueue.Count));
end;

procedure TDeviceThread.SetEventStatus(AEvent: PEvent; AState: TEventState; AErrorCode: Integer);
var
  ChannelForm: TfrmChannelEvents;
  Index: Integer;
begin
//  if (not HasMainControl) then exit;

//  if (HasMainControl) then
  begin
    FEventLock.Enter;
    try
      if (AEvent = nil) then exit;

  //    Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventStatus start, id = %s', [EventIDToString(AEvent^.EventID)])));

      AEvent^.Status.State      := AState;
      AEvent^.Status.ErrorCode  := AErrorCode;
      AEvent^.TakeEvent         := (AState = esOnAir);


//      ControlChannel := AEvent^.EventID.ChannelID;

      if (AEvent^.EventType = ET_PLAYER) then
      begin
        if (HasMainControl) then
        begin
          // 이벤트 상태의 전송은 Player만 처리함
          TransmitNotifyEventStatus(AEvent^.EventID, AEvent^.Status);
    //      Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventStatus TransmitNotifyEventStatus, id = %s', [EventIDToString(AEvent^.EventID)])));
        end;

        ChannelForm := frmDCS.GetChannelFormByID(AEvent^.EventID.ChannelID);
        if (ChannelForm <> nil) then
        begin
          ChannelForm.SetEventStatus(Self, AEvent, AState, AErrorCode);
  //        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventStatus ChannelForm.SetEventStatus, id = %s', [EventIDToString(AEvent^.EventID)])));
        end;
      end;

      if (HasMainControl) then
      begin
        TransmitEventStatusNotify(AEvent^.EventID, AEvent^.Status);
      end;
    finally
      FEventLock.Leave;
    end;

  //        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventStatus finish, id = %s', [EventIDToString(AEvent^.EventID)])));
    //  if (AEvent^.Status in [esError, esDone]) then
    //    FEventQueue.Remove(AEvent);
  end;
end;

procedure TDeviceThread.ResetStartTimePlus(AIndex: Integer; ADurEventTime: TEventTime; AFrameRateType: TFrameRateType);
var
  I: Integer;
  CEvent: PEvent;
  ChannelForm: TfrmChannelEvents;
begin
  if (FEventQueue = nil) then exit;
  if (AIndex >= FEventQueue.Count) then exit;

  FEventLock.Enter;
  try
    // Get next main event index
    for I := AIndex to FEventQueue.Count - 1 do
    begin
      CEvent := FEventQueue[I];
      if (CEvent <> nil) then
      begin
        CEvent^.StartTime := GetPlusEventTime(CEvent^.StartTime, ADurEventTime, AFrameRateType);

        if (CEvent^.EventType = ET_PLAYER) then
        begin
          ChannelForm := frmDCS.GetChannelFormByID(CEvent^.EventID.ChannelID);
          if (ChannelForm <> nil) then
          begin
            ChannelForm.ResetStartTime(CEvent, Device);
          end;
        end;
      end;
    end;
  finally
    FEventLock.Leave;
  end;
end;

procedure TDeviceThread.ResetStartTimeMinus(AIndex: Integer; ADurEventTime: TEventTime; AFrameRateType: TFrameRateType);
var
  I: Integer;
  CEvent: PEvent;
  ChannelForm: TfrmChannelEvents;
begin
  if (FEventQueue = nil) then exit;
  if (AIndex >= FEventQueue.Count) then exit;

  FEventLock.Enter;
  try
    for I := AIndex to FEventQueue.Count - 1 do
    begin
      CEvent := FEventQueue[I];
      if (CEvent <> nil) then
      begin
        CEvent^.StartTime := GetMinusEventTime(CEvent^.StartTime, ADurEventTime, AFrameRateType);

        if (CEvent^.EventType = ET_PLAYER) then
        begin
          ChannelForm := frmDCS.GetChannelFormByID(CEvent^.EventID.ChannelID);
          if (ChannelForm <> nil) then
          begin
            ChannelForm.ResetStartTime(CEvent, Device);
          end;
        end;
      end;
    end;
  finally
    FEventLock.Leave;
  end;
end;

function TDeviceThread.GetLogDevice(ALogState: TLogState; ALogStr: String): String;
var
  LogDateTime: TDateTime;
//  LogForm: TfrmLogDevice;
begin
  Result := '';

  if (Device = nil) then exit;

  LogDateTime := Now;

  case ALogState of
    lsError: ALogStr := Format('[Error] %s', [ALogStr]);
    lsWarning: ALogStr := Format('[Warning] %s', [ALogStr]);
  end;

  Result := Format('%d[%s] %s', [Device^.Handle, FormatDateTime('YYYY-MM-DD hh:nn:ss.zzz', LogDateTime), ALogStr]);

//  exit;
{  LogForm := frmDCS.GetLogDeviceFormByHandle(Device^.Handle);
  if (LogForm <> nil) then
  begin
    LogForm.AddLog('', -1, ALogState, LogDateTime, ALogStr);
  end; }

  if (FLogForm <> nil) then
  begin
    (FLogForm as TfrmLogDevice).AddLog('', -1, ALogState, LogDateTime, ALogStr);
  end;
end;

function TDeviceThread.GetLogDevice(ALogState: TLogState; AHostIP: String; ALogStr: String): String;
var
  LogDateTime: TDateTime;
//  LogForm: TfrmLogDevice;
begin
  Result := '';

  if (Device = nil) then exit;

  LogDateTime := Now;

  case ALogState of
    lsError: ALogStr := Format('[Error] %s', [ALogStr]);
    lsWarning: ALogStr := Format('[Warning] %s', [ALogStr]);
  end;

  Result := Format('%d[%s] %s, %s', [Device^.Handle, FormatDateTime('YYYY-MM-DD hh:nn:ss.zzz', LogDateTime), AHostIP, ALogStr]);

//  exit;
{  LogForm := frmDCS.GetLogDeviceFormByHandle(Device^.Handle);
  if (LogForm <> nil) then
  begin
    LogForm.AddLog(AHostIP, -1, ALogState, LogDateTime, ALogStr);
  end; }

  if (FLogForm <> nil) then
  begin
    (FLogForm as TfrmLogDevice).AddLog(AHostIP, -1, ALogState, LogDateTime, ALogStr);
  end;
end;

function TDeviceThread.GetLogDevice(ALogState: TLogState; AHostIP: String; AChannelID: Integer; ALogStr: String): String;
var
  LogDateTime: TDateTime;
//  LogForm: TfrmLogDevice;
begin
  Result := '';

  if (Device = nil) then exit;

  LogDateTime := Now;

  case ALogState of
    lsError: ALogStr := Format('[Error] %s', [ALogStr]);
    lsWarning: ALogStr := Format('[Warning] %s', [ALogStr]);
  end;

  Result := Format('%d[%s] %s, %d, %s', [Device^.Handle, FormatDateTime('YYYY-MM-DD hh:nn:ss.zzz', LogDateTime), AHostIP, AChannelID, ALogStr]);

//  exit;
{  LogForm := frmDCS.GetLogDeviceFormByHandle(Device^.Handle);
  if (LogForm <> nil) then
  begin
    LogForm.AddLog(AHostIP, AChannelID, ALogState, LogDateTime, ALogStr);
  end; }

  if (FLogForm <> nil) then
  begin
    (FLogForm as TfrmLogDevice).AddLog(AHostIP, AChannelID, ALogState, LogDateTime, ALogStr);
  end;
end;

function TDeviceThread.DeviceOpen: Integer;
begin
//  FGetStatusThread := TGetStatusThread.Create(Self);
//  FGetStatusThread.Start;

{  if (FEventOverallNotifyThread = nil) then
  begin
    FEventOverallNotifyThread := TEventOverallNotifyThread.Create(Self);
    FEventOverallNotifyThread.Start;
  end; }

{  if (FEventControlThread = nil) then
  begin
    FEventControlThread := TEventControlThread.Create(Self);
    FEventControlThread.Start;
  end; }

  FLogForm := frmDCS.GetLogDeviceFormByHandle(Device^.Handle);

  Result := D_OK;
end;

function TDeviceThread.DeviceClose: Integer;
begin
{  if (FEventOverallNotifyThread <> nil) then
  begin
    FEventOverallNotifyThread.Close;
    FEventOverallNotifyThread.Terminate;
    FEventOverallNotifyThread.WaitFor;
    FreeAndNil(FEventOverallNotifyThread);
  end; }

{  if (FEventControlThread <> nil) then
  begin
    FEventControlThread.Close;
    FEventControlThread.Terminate;
    FEventControlThread.WaitFor;
    FreeAndNil(FEventControlThread);
  end; }

//  FGetStatusThread.Close;
//  FGetStatusThread.Terminate;
//  FGetStatusThread.WaitFor;
//  FreeAndNil(FGetStatusThread);

//  EventCurr := nil;
//  EventNext := nil;

  if (FOpened) then
    Result := D_OK
  else
    Result := D_FALSE;

  FLogForm := nil;

//    Result := D_OK
end;

function TDeviceThread.DeviceInit: Integer;
begin
{  FEventCurr := nil;
  FEventNext := nil;

  FControlBy      := '';
  FControlChannel := -1; }

  FNumCued := 0;
  FCuedDurTime := 0;

//  FEventLock.Enter;
  try
    EventCurr := nil;
    EventNext := nil;
    EventFini := nil;
  finally
//    FEventLock.Leave;
  end;

  Result := D_OK;
end;

function TDeviceThread.DeviceReCue: Integer;
var
  StartIndex: Integer;
  I: Integer;
  E: PEvent;
begin
  Result := D_FALSE;

  // 현재 이벤트 이후의 모든 이벤트의 상태를 전송
  StartIndex := -1;
          Assert(False, GetLogDevice(lsError, ControlBy, Format('TDeviceThread.DeviceReCue Start. EventNext = %p, EventCurr = %p, EventFini = %p', [EventNext, EventCurr, EventFini])));

  FEventLock.Enter;
  try
    if (EventFini <> nil) then
      StartIndex := FEventQueue.IndexOf(EventFini)
    else if (EventCurr <> nil) then
      StartIndex := FEventQueue.IndexOf(EventCurr)
    else if (EventNext <> nil) then
      StartIndex := FEventQueue.IndexOf(EventNext);

    if (StartIndex < 0) then exit;

    for I := StartIndex to FEventQueue.Count - 1 do
    begin
      E := FEventQueue[I];
      if (E <> nil) then
      begin
       TransmitNotifyEventStatus(E^.EventID, E^.Status);
     end;
    end;
  finally
    FEventLock.Leave;
          Assert(False, GetLogDevice(lsError, ControlBy, Format('TDeviceThread.DeviceReCue End. EventNext = %p, EventCurr = %p, EventFini = %p', [EventNext, EventCurr, EventFini])));

  end;

  Result := D_OK;

  exit;


//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('DeviceReCue 2222222. EventNext = %p, EventCurr = %p', [EventNext, EventCurr])));
  if (EventNext <> nil) then
  begin
//    SetEvent(FEventCue);

    if (EventNext^.EventType = ET_PLAYER) then
    begin
      // 이벤트 상태의 전송은 Player만 처리함
      TransmitNotifyEventStatus(EventNext^.EventID, EventNext^.Status);
    end;

    Result := D_OK;
  end;

  if (EventCurr <> nil) then
  begin
    if (EventCurr^.EventType = ET_PLAYER) then
    begin
      // 이벤트 상태의 전송은 Player만 처리함
      TransmitNotifyEventStatus(EventCurr^.EventID, EventCurr^.Status);
    end;
  end;
end;

function TDeviceThread.DeviceReset: Integer;
begin
  Result := D_FALSE;

//  FEventControlThread.ResetExecute;
  try
    WaitForEventCompleted(INFINITE);

//    WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);
//    WaitForSingleObject(FEventCompleted, INFINITE);

//    DeviceClose;
//    DeviceOpen;
//
//    DeviceInit;
//
    Assert(False, GetLogCommonStr(lsNormal, Format('Self device reset. device name = %s, handle = %d', [String(Device^.Name), Device^.Handle])));

    SetEvent(FEventReset);
  finally
//    FEventControlThread.SetExecute;
  end;

  Result := D_OK;
end;

function TDeviceThread.DeviceReset(AHostIP: AnsiString; AChannelID: Word): Integer;
begin
  Result := D_FALSE;

//  FEventControlThread.ResetExecute;
  try
    WaitForEventCompleted(INFINITE);

//    WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);
//    WaitForSingleObject(FEventCompleted, INFINITE);

//    DeviceClose;
//    DeviceOpen;
//
//    DeviceInit;

    Assert(False, GetLogDevice(lsNormal, AHostIP, AChannelID, 'Device reset.'));

    SetEvent(FEventReset);
  finally
//    FEventControlThread.SetExecute;
  end;

  Result := D_OK;
end;

function TDeviceThread.DeviceReInputEvents(AHostIP: AnsiString): Integer;
var
  R: Integer;
  I: Integer;
  EventCount: Integer;
  Event: TEvent;
  E: PEvent;
  CurrEventID, NextEventID: TEventID;

  ChannelForm: TfrmChannelEvents;
begin
  Result := D_FALSE;

//  FEventControlThread.ResetExecute;
//  FEventLock.Enter;
  try
    WaitForEventCompleted(INFINITE);

//    WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);
//    WaitForSingleObject(FEventCompleted, INFINITE);

    R := frmDCS.CrossCheckThread.DCSGetEventCount(AHostIP, Device^.Handle, EventCount);
    if (R = D_OK) then
    begin
      for I := 0 to EventCount - 1 do
      begin
        R := frmDCS.CrossCheckThread.DCSGetEvent(AHostIP, Device^.Handle, I, Event);
        if (R = D_OK) then
        begin
          FEventLock.Enter;
          try
            E := GetEventByID(Event.EventID);
            if (E <> nil) then
            begin
              Move(Event, E^, SizeOf(TEvent));
            end
            else
            begin
              E := New(PEvent);
              Move(Event, E^, SizeOf(TEvent));
              FEventQueue.Add(E);
            end;

            if (E^.EventType = ET_PLAYER) then
            begin
              ChannelForm := frmDCS.GetChannelFormByID(E^.EventID.ChannelID);
              if (ChannelForm <> nil) then
              begin
                ChannelForm.InputEvent(AHostIP, E, Device);
              end;
            end;

            Assert(False, GetLogDevice(lsNormal, AHostIP, ControlChannel,
                                       Format('Main DCS received input event, id = %s, start = %s, duration = %s',
                                              [EventIDToString(E^.EventID),
                                               EventTimeToDateTimecodeStr(E^.StartTime, ControlFrameRateType, True),
                                               TimecodeToString(E^.DurTime, ControlIsDropFrame)])));

          finally
            FEventLock.Leave;
          end;
        end
        else
        begin
          Assert(False, GetLogDevice(lsError, AHostIP, 'Main DCS received input event failed.'));
          exit;
        end;
      end;

      // Sort
      EventQueueSort;

      R := frmDCS.CrossCheckThread.DCSGetEventCurrNext(AHostIP, Device^.Handle, CurrEventID, NextEventID);
      if (R = D_OK) then
      begin
        EventCurr := GetEventByID(CurrEventID);
        EventNext := GetEventByID(NextEventID);

//        if (EventCurr <> nil) then
//          ControlChannel := CurrEventID.ChannelID
//        else if (EventNext <> nil) then
//          ControlChannel := NextEventID.ChannelID
//        else
//          ControlChannel := -1;

        Assert(False, GetLogDevice(lsNormal, AHostIP,
                                   Format('Main DCS received current & next event, current=%s, next=%s',
                                          [EventIDToString(CurrEventID), EventIDToString(NextEventID)])));
      end
      else
      begin
        Assert(False, GetLogDevice(lsError, AHostIP, 'Main DCS received current & next event failed.'));
        exit;
      end;

//      SetEvent(FEventSchedule);
    end
    else
    begin
      Assert(False, GetLogDevice(lsError, AHostIP, 'Main DCS received event count failed.'));
      exit;
    end;
  finally
    Assert(False, GetLogDevice(lsNormal, AHostIP, 'Device re input events completed.'));

//    FEventControlThread.SetExecute;
//    FEventLock.Leave;
  end;

  Result := D_OK;
end;

{function TDeviceThread.DCSGetStatus(ABuffer: String): Integer;
begin

end;}

// 0X20, 30, 40 Command
function TDeviceThread.DeviceCommand(AHostIP: AnsiString; ACMD1, ACMD2: Byte; ACMDBuffer: AnsiString; var AResultBuffer: AnsiString): Integer;
begin
  Result := D_FALSE;

//  FEventControlThread.ResetExecute;
  try
    WaitForEventCompleted(INFINITE);

    // 전체를 INFINITE 변경해야되는지 고려 필요
    // Device Command는 INFINITE로 처리해야 연속 Command 시 제대로 동작함
//    WaitForSingleObject(FEventCompleted, INFINITE);
//    WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);

//    ResetEvent(FEventCompleted);

    ResetEvent(FEventCommandFinished);

    AResultBuffer := '';

    FCMDControlBy := AHostIP;

    FCMD1 := ACMD1;
    FCMD2 := ACMD2;

    FCMDBuffer := ACMDBuffer;

    FCMDResultBuffer := '';

    FCMDLastResult := E_UNDEFIND_COMMAND;

    SetEvent(FEventCommand);

//    if (WaitForSingleObject(FEventCompleted, DEVICE_COMMAND_TIMEOUT) = WAIT_OBJECT_0) then
    if (WaitForSingleObject(FEventCommandFinished, FDeviceCommandTimeout) = WAIT_OBJECT_0) then
    begin
      AResultBuffer := FCMDResultBuffer;
      Result := FCMDLastResult;
    end
    else
      Result := E_TIMEOUT;
  finally
//    FEventControlThread.SetExecute;
  end;
end;

function TDeviceThread.GetDeviceStatus(AStatus: TDeviceStatus): Integer;
begin
  AStatus := FDevice^.Status;
  Result := D_OK;
end;

function TDeviceThread.GetExist(AExist: Boolean): Integer;
begin
  SetEvent(FEventCommand);
end;

function TDeviceThread.InputEvent(AHostIP: AnsiString; AEvent: TEvent): Integer;
var
  BaseTime: TEventTime;
  E: PEvent;
//  SaveState: TEventState;
  ChannelForm: TfrmChannelEvents;
begin
  Result := D_FALSE;

//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('InputEvent Start', [])));
          try

  BaseTime := DateTimeToEventTime(SystemTimeToDateTime(GV_TimeCurrent), ControlFrameRateType);
  if (CompareEventTime(GetEventEndTime(AEvent.StartTime, AEvent.DurTime, ControlFrameRateType), BaseTime, ControlFrameRateType) < 0) then
  begin
    Result := E_INVALID_START_TIME;

    Assert(False, GetLogDevice(lsError, AHostIP, ControlChannel,
                               Format('InputEvent event start time less than now, id = %s, start = %s, duration = %s, now = %s',
                                      [EventIDToString(AEvent.EventID),
                                       EventTimeToDateTimecodeStr(AEvent.StartTime, ControlFrameRateType, True),
                                       TimecodeToString(AEvent.DurTime, ControlIsDropFrame),
                                       EventTimeToDateTimecodeStr(BaseTime, ControlFrameRateType, True)])));
    exit;
  end;



{      Assert(False, GetLogDevice(lsNormal, AHostIP, AEvent.EventID.ChannelID,
                                 Format('Input event start, count = %d, id = %s, start = %s, duration = %s',
                                        [FEventQueue.Count,
                                         EventIDToString(AEvent.EventID),
                                         EventTimeToDateTimecodeStr(AEvent.StartTime, True),
                                         TimecodeToString(AEvent.DurTime)]))); }
//  FEventControlThread.ResetExecute;
  FEventLock.Enter;
  try
    WaitForEventCompleted(INFINITE);

//    WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);
//    WaitForSingleObject(FEventCompleted, INFINITE);

{      Assert(False, GetLogDevice(lsNormal, AHostIP, AEvent.EventID.ChannelID,
                                 Format('Input event process 1, count = %d, id = %s, start = %s, duration = %s',
                                        [FEventQueue.Count,
                                         EventIDToString(AEvent.EventID),
                                         EventTimeToDateTimecodeStr(AEvent.StartTime, True),
                                         TimecodeToString(AEvent.DurTime)]))); }

      E := GetEventByID(AEvent.EventID);
      if (E <> nil) then
      begin
    {    // Event after cue state is ignored
        if (E^.Status > esCued) then
        begin
          exit;
        end; }

//        SaveState := E^.Status.State;

        Move(E^.Status, AEvent.Status, SizeOf(TEventStatus));
        Move(AEvent, E^, SizeOf(TEvent));

        Result := FEventQueue.IndexOf(E);

      Assert(False, GetLogDevice(lsNormal, AHostIP, ControlChannel,
                                 Format('Input event process 2-1, count = %d, id = %s, start = %s, duration = %s, state = %s',
                                        [FEventQueue.Count,
                                         EventIDToString(AEvent.EventID),
                                         EventTimeToDateTimecodeStr(AEvent.StartTime, ControlFrameRateType, True),
                                         TimecodeToString(AEvent.DurTime, ControlIsDropFrame),
                                         EventStatusNames[E^.Status.State]])));
      end
      else
      begin
//        FControlBy := AHostIP;

//        SaveState := esIdle;

        E := New(PEvent);
        Move(AEvent, E^, SizeOf(TEvent));

        if (HasMainControl) then
          SetEventStatus(E, esLoading);

        Result := FEventQueue.Add(E);

{      Assert(False, GetLogDevice(lsNormal, AHostIP, AEvent.EventID.ChannelID,
                                 Format('Input event process 2-2, count = %d, id = %s, start = %s, duration = %s',
                                        [FEventQueue.Count,
                                         EventIDToString(AEvent.EventID),
                                         EventTimeToDateTimecodeStr(AEvent.StartTime, True),
                                         TimecodeToString(AEvent.DurTime)]))); }

        FEventOverall.NumEventInQueue     := FEventOverall.NumEventInQueue + 1;
        FEventOverall.NumFreeEntryInQueue := FEventOverall.NumFreeEntryInQueue + 1;

{      Assert(False, GetLogDevice(lsNormal, AHostIP, AEvent.EventID.ChannelID,
                                 Format('Input event process 2-3, count = %d, id = %s, start = %s, duration = %s',
                                        [FEventQueue.Count,
                                         EventIDToString(AEvent.EventID),
                                         EventTimeToDateTimecodeStr(AEvent.StartTime, True),
                                         TimecodeToString(AEvent.DurTime)]))); }
      end;

//      FControlBy := AHostIP;

    //  E^.Status := esLoading;

//      if (SaveState = esIdle) then
//        SetEventStatus(E, esLoading);

{      Assert(False, GetLogDevice(lsNormal, AHostIP, AEvent.EventID.ChannelID,
                                 Format('Input event process 3, count = %d, id = %s, start = %s, duration = %s',
                                        [FEventQueue.Count,
                                         EventIDToString(AEvent.EventID),
                                         EventTimeToDateTimecodeStr(AEvent.StartTime, True),
                                         TimecodeToString(AEvent.DurTime)]))); }

      if (E^.EventType = ET_PLAYER) then
      begin
        ChannelForm := frmDCS.GetChannelFormByID(E^.EventID.ChannelID);
        if (ChannelForm <> nil) then
        begin
          ChannelForm.InputEvent(AHostIP, E, FDevice);

{      Assert(False, GetLogDevice(lsNormal, AHostIP, AEvent.EventID.ChannelID,
                                 Format('Input event process 4, count = %d, id = %s, start = %s, duration = %s',
                                        [FEventQueue.Count,
                                         EventIDToString(AEvent.EventID),
                                         EventTimeToDateTimecodeStr(AEvent.StartTime, True),
                                         TimecodeToString(AEvent.DurTime)]))); }
        end;
      end;

    //  E^.Status := esLoaded;
      if (HasMainControl) and
         (E^.Status.State = esLoading) then
        SetEventStatus(E, esLoaded)
      else
        SetEventStatus(E, E^.Status.State);

{      Assert(False, GetLogDevice(lsNormal, AHostIP, AEvent.EventID.ChannelID,
                                 Format('Input event process 5, count = %d, id = %s, start = %s, duration = %s',
                                        [FEventQueue.Count,
                                         EventIDToString(AEvent.EventID),
                                         EventTimeToDateTimecodeStr(AEvent.StartTime, True),
                                         TimecodeToString(AEvent.DurTime)]))); }
      // Sort
      EventQueueSort;

{      Assert(False, GetLogDevice(lsNormal, AHostIP, E^.EventID.ChannelID,
                                 Format('Input event, count = %d, id = %s, start = %s, duration = %s',
                                        [FEventQueue.Count,
                                         EventIDToString(E^.EventID),
                                         EventTimeToDateTimecodeStr(E^.StartTime, True),
                                         TimecodeToString(E^.DurTime)]))); }

      if (HasMainControl) then
        SetEvent(FEventSchedule)
      else
      begin
        SetEventCurrNotify(FEventCurrID);
        SetEventNextNotify(FEventNextID);
        SetEventFiniNotify(FEventFiniID);
      end;
  finally
//    FEventControlThread.SetExecute;
    FEventLock.Leave;
  end;

{      Assert(False, GetLogDevice(lsNormal, AHostIP, AEvent.EventID.ChannelID,
                                 Format('Input event finish, count = %d, id = %s, start = %s, duration = %s',
                                        [FEventQueue.Count,
                                         EventIDToString(AEvent.EventID),
                                         EventTimeToDateTimecodeStr(AEvent.StartTime, True),
                                         TimecodeToString(AEvent.DurTime)]))); }

  Assert(False, GetLogDevice(lsNormal, AHostIP, ControlChannel,
                             Format('Input event, count = %d, id = %s, start = %s, duration = %s',
                                    [FEventQueue.Count,
                                     EventIDToString(AEvent.EventID),
                                     EventTimeToDateTimecodeStr(AEvent.StartTime, ControlFrameRateType, True),
                                     TimecodeToString(AEvent.DurTime, ControlIsDropFrame)])));
          finally
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('InputEvent End', [])));
          end;

  Result := D_OK;
end;

function TDeviceThread.DeleteEvent(AHostIP: AnsiString; AEventID: TEventID): Integer;
var
  E: PEvent;
  ChannelForm: TfrmChannelEvents;
begin
  Result := D_FALSE;

    E := GetEventByID(AEventID);
    if (E <> nil) then
    begin
//      FEventControlThread.ResetExecute;
      try
        WaitForEventCompleted(INFINITE);
  FEventLock.Enter;
  try

//        WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);
//        WaitForSingleObject(FEventCompleted, INFINITE);

        if (E^.EventType = ET_PLAYER) then
        begin
          ChannelForm := frmDCS.GetChannelFormByID(E^.EventID.ChannelID);
          if (ChannelForm <> nil) then
          begin
            ChannelForm.DeleteEvent(E, Device);
          end;
        end;

        if (HasMainControl) then
        begin
          if (EventCurr = E) then EventCurr := nil;
          if (EventNext = E) then EventNext := nil;
          if (EventFini = E) then EventFini := nil;
        end;

        SetEventStatus(E, esIdle);

        Result := FEventQueue.Remove(E);

        Assert(False, GetLogDevice(lsNormal, AHostIP, E^.EventID.ChannelID,
                                   Format('Delete event, id = %s, start = %s, duration = %s',
                                          [EventIDToString(E^.EventID),
                                           EventTimeToDateTimecodeStr(E^.StartTime, ControlFrameRateType, True),
                                           TimecodeToString(E^.DurTime, ControlIsDropFrame)])));

        Dispose(E);

        FEventOverall.NumEventInQueue := FEventQueue.Count;
  finally
    FEventLock.Leave;
  end;
      finally
//        FEventControlThread.SetExecute;
      end;
    end;

  Result := D_OK;
end;

function TDeviceThread.ClearEvent(AHostIP: AnsiString; AChannelID: Word): Integer;
var
  I: Integer;
  ChannelForm: TfrmChannelEvents;
begin
  Result := D_FALSE;

//  FEventControlThread.ResetExecute;
  try
    WaitForEventCompleted(INFINITE);

//    WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);
//    WaitForSingleObject(FEventCompleted, INFINITE);

    FClearChannel := AChannelID;

    try
      ChannelForm := frmDCS.GetChannelFormByID(AChannelID);
      if (ChannelForm <> nil) then
      begin
        ChannelForm.ClearEvent(FDevice);
      end;

      ClearEventQueueByChannelID(AChannelID);

    //  DeviceInit;

      Assert(False, GetLogDevice(lsNormal, AHostIP, AChannelID, 'Clear event.'));

      SetEvent(FEventClear);
    finally
    end;
  finally
//    FEventControlThread.SetExecute;
  end;

////  // ResetEvent(FEventControlThread.FEventExecute);
//  try
////    WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);
//
//    FClearChannel := AChannelID;
//
//    SetEvent(FEventClear);
//
//{  //  ResetEvent(FEventGetStatus);
//    ResetEvent(FEventSchedule);
//    ResetEvent(FEventCue);
//    ResetEvent(FEventStop);
//    ResetEvent(FEventStart);
//    ResetEvent(FEventChanged);
//    ResetEvent(FEventCommand);
//    ResetEvent(FEventClear);
//    ResetEvent(FEventReset);
//
//    ResetEvent(FEventCompleted);
//
//{    for I := GV_ChannelList.Count - 1 downto 0 do
//    begin
//      ChannelForm := frmDCS.GetChannelFormByID(GV_ChannelList[I]^.ID);
//      if (ChannelForm <> nil) then
//      begin
//        ChannelForm.ClearEvent(FDevice);
//      end;
//    end; }
//
//{    ClearEventQueueByChannelID(AChannelID);
//
//    DeviceInit;
//
//    ChannelForm := frmDCS.GetChannelFormByID(AChannelID);
//    if (ChannelForm <> nil) then
//    begin
//      ChannelForm.ClearEvent(FDevice);
//    end;
//
////    SetEvent(FEventClear); }
//
//  finally
////    // SetEvent(FEventControlThread.FEventExecute);
//  end;

  Result := D_OK;
end;

function TDeviceThread.TakeEvent(AHostIP: AnsiString; AEventID: TEventID; AStartTime: TEventTime): Integer;
var
  E: PEvent;
//  CurrTime: TDateTime;
  NextStartTime: TEventTime;
  DurEventTime: TEventTime;
  ChannelForm: TfrmChannelEvents;

  LockList: TList;
  I: Integer;
  D: TDeviceThread;
  Index: Integer;
begin
  Result := D_FALSE;

  FEventLock.Enter;
  try
    E := GetEventByID(AEventID);
    if (E <> nil) then
    begin
      if (EventNext <> E) then exit;

//      FEventControlThread.ResetExecute;
      try
        WaitForEventCompleted(INFINITE);

//        WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);
//        WaitForSingleObject(FEventCompleted, INFINITE);

//        CurrTime := Now;

        NextStartTime := AStartTime;//GetPlusEventTime(DateTimeToEventTime(CurrTime), TimecodeToEventTime(ADelayTime));

        // 현재 송출 중인 이벤트가 있으면 길이 조정
        if (EventCurr <> nil) then
        begin
          EventCurr^.DurTime := EventTimeToTimecode(GetDurEventTime(EventCurr^.StartTime, NextStartTime, ControlFrameRateType));
        end;

        // 같은 채널의 다른 Device가 송출 중인 이벤트가 있으면 길이 조정
        LockList := GV_DeviceThreadList.LockList;
        try
          for I := 0 to LockList.Count - 1 do
          begin
            D := LockList[I];
            if (D <> nil) and (D <> Self) and
               (D.ControlChannel = ControlChannel) and
               (D.EventCurr <> nil) then
            begin
              D.EventCurr^.DurTime := EventTimeToTimecode(GetDurEventTime(D.EventCurr^.StartTime, NextStartTime, D.ControlFrameRateType));
            end;
          end;
        finally
          GV_DeviceThreadList.UnLockList;
        end;

        Index := FEventQueue.IndexOf(E);
        DurEventTime := GetDurEventTime(NextStartTime, E^.StartTime, ControlFrameRateType);
        if (CompareEventTime(NextStartTime, E^.StartTime, ControlFrameRateType) >= 0) then
        begin
          ResetStartTimePlus(Index, DurEventTime, ControlFrameRateType);
        end
        else
        begin
          ResetStartTimeMinus(Index, DurEventTime, ControlFrameRateType);
        end;

        E^.StartTime := NextStartTime;
        E^.TakeEvent := True;

        if (E^.EventType = ET_PLAYER) then
        begin
          ChannelForm := frmDCS.GetChannelFormByID(E^.EventID.ChannelID);
          if (ChannelForm <> nil) then
          begin
            ChannelForm.TakeEvent(E, EventCurr, Device);
          end;
        end;

        // 같은 채널의 다른 Device가 준비 중인 이벤트가 있으면 길이 조정
        LockList := GV_DeviceThreadList.LockList;
        try
          for I := 0 to LockList.Count - 1 do
          begin
            D := LockList[I];
//        Assert(False, GetLogDevice(lsNormal, AHostIP, D.EventNext^.EventID.ChannelID,
//                                   Format('Take event1, devicehandle = %d, id = %s, start = %s, duration = %s',
//                                          [D.Device^.Handle, EventIDToString(D.EventNext^.EventID),
//                                           EventTimeToDateTimecodeStr(D.EventNext^.StartTime, True),
//                                           TimecodeToString(D.EventNext^.DurTime)])));
            if (D <> nil) and (D <> Self) and
               (D.ControlChannel = ControlChannel) and
               (D.EventNext <> nil) then
            begin
              begin
//        Assert(False, GetLogDevice(lsNormal, AHostIP, D.EventNext^.EventID.ChannelID,
//                                   Format('Take event2, devicehandle = %d, id = %s, start = %s, duration = %s',
//                                          [D.Device^.Handle, EventIDToString(D.EventNext^.EventID),
//                                           EventTimeToDateTimecodeStr(D.EventNext^.StartTime, True),
//                                           TimecodeToString(D.EventNext^.DurTime)])));
              Index := D.EventQueue.IndexOf(D.EventNext);

//      D.EventControlThread.ResetExecute;
      D.FEventLock.Enter;
      try
        D.WaitForEventCompleted(INFINITE);

//        WaitForSingleObject(D.FEventCompleted, DEVICE_WAIT_TIMEOUT);
//        WaitForSingleObject(FEventCompleted, INFINITE);
              if (CompareEventTime(NextStartTime, D.EventNext^.StartTime, D.ControlFrameRateType) >= 0) then
              begin
                D.ResetStartTimePlus(Index, DurEventTime, D.ControlFrameRateType);
              end
              else
              begin
                D.ResetStartTimeMinus(Index, DurEventTime, D.ControlFrameRateType);
              end;

              if (D.EventNext^.EventType = ET_PLAYER) then
              begin
                ChannelForm := frmDCS.GetChannelFormByID(D.EventNext^.EventID.ChannelID);
                if (ChannelForm <> nil) then
                begin
                  ChannelForm.TakeEvent(D.EventNext, D.EventCurr, Device);
                end;
              end;
  //            D.EventNext^.TakeEvent := True;
      finally
//        D.EventControlThread.SetExecute;
        D.FEventLock.Leave;
      end;
              end;
            end;
          end;
        finally
          GV_DeviceThreadList.UnLockList;
        end;

        Assert(False, GetLogDevice(lsNormal, AHostIP, ControlChannel,
                                   Format('Take event, id = %s, start = %s, duration = %s',
                                          [EventIDToString(E^.EventID),
                                           EventTimeToDateTimecodeStr(E^.StartTime, ControlFrameRateType, True),
                                           TimecodeToString(E^.DurTime, ControlIsDropFrame)])));

      finally
//        FEventControlThread.SetExecute;
      end;

      Result := D_OK;
    end;

  finally
    FEventLock.Leave;
  end;
end;

function TDeviceThread.HoldEvent(AHostIP: AnsiString; AEventID: TEventID): Integer;
var
  E: PEvent;
  CurrTime: TDateTime;
  NextStartTime: TEventTime;
  ChannelForm: TfrmChannelEvents;
begin
  Result := D_FALSE;

  FEventLock.Enter;
  try
    E := GetEventByID(AEventID);
    if (E <> nil) then
    begin
      if (EventNext <> E) then exit;

//      FEventControlThread.ResetExecute;
      try
        WaitForEventCompleted(INFINITE);

//        WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);
//        WaitForSingleObject(FEventCompleted, INFINITE);

        E^.ManualEvent := True;

        if (E^.EventType = ET_PLAYER) then
        begin
          ChannelForm := frmDCS.GetChannelFormByID(E^.EventID.ChannelID);
          if (ChannelForm <> nil) then
          begin
            ChannelForm.HoldEvent(E, Device);
          end;
        end;

        Assert(False, GetLogDevice(lsNormal, AHostIP, E^.EventID.ChannelID,
                                   Format('Hold event, id = %s, start = %s, duration = %s',
                                          [EventIDToString(E^.EventID),
                                           EventTimeToDateTimecodeStr(E^.StartTime, ControlFrameRateType, True),
                                           TimecodeToString(E^.DurTime, ControlIsDropFrame)])));

        if (HasMainControl) then
          SetEvent(FEventChanged);
      finally
//        FEventControlThread.SetExecute;
      end;

      Result := D_OK;
    end;
  finally
    FEventLock.Leave;
  end;
end;

function TDeviceThread.ChangeDurationEvent(AHostIP: AnsiString; AEventID: TEventID; ADuration: TTimecode): Integer;
var
  E, P: PEvent;
  StartTime, EndTime: TEventTime;
  DurTC: TTimecode;
  DurEventTime: TEventTime;
  SavrDurTC: TTimecode;
  ChannelForm: TfrmChannelEvents;

  LockList: TList;
  I: Integer;
  D: TDeviceThread;
  Index: Integer;
begin
  Result := D_FALSE;

  FEventLock.Enter;
  try
    E := GetEventByID(AEventID);
    if (E <> nil) then
    begin
      if (E^.DurTime = ADuration) then exit;

//      FEventControlThread.ResetExecute;
      try
        WaitForEventCompleted(INFINITE);

//        WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);
//        WaitForSingleObject(FEventCompleted, INFINITE);

        // 현재 이벤트의 종료 시각을 구함
        StartTime := E^.StartTime;
        EndTime   := GetEventEndTime(E^.StartTime, E^.DurTime, ControlFrameRateType);

        // 현재 이벤트의 길이와 변경된 길이의 차이 길이를 구힘
        DurTc := GetDurTimecode(E^.DurTime, ADuration, ControlFrameRateType);
        DurEventTime := TimecodeToEventTime(DurTC);

        // 현재 이벤트의 다음 모든 이벤트의 길이를 조정
        Index := FEventQueue.IndexOf(E) + 1;
        if (E^.DurTime <= ADuration) then
        begin
          ResetStartTimePlus(Index, DurEventTime, ControlFrameRateType);
        end
        else
        begin
          ResetStartTimeMinus(Index, DurEventTime, ControlFrameRateType);
        end;

        // 현재 이벤트의 길이를 저장하고 변경된 길이로 적용
        SavrDurTC := E^.DurTime;
        E^.DurTime := ADuration;

//        if (E = EventCurr) and (EventCurr^.Status.State = esOnAir) then
//          SetEvent(FEventChanged);

        // 현재 이벤트의 채널 리프레쉬
        if (E^.EventType = ET_PLAYER) then
        begin
          ChannelForm := frmDCS.GetChannelFormByID(E^.EventID.ChannelID);
          if (ChannelForm <> nil) then
          begin
            ChannelForm.ChangeDurationEvent(E, Device);
          end;
        end;

        // 같은 채널의 다른 Device의 길이를 조정
        LockList := GV_DeviceThreadList.LockList;
        try
          for I := 0 to LockList.Count - 1 do
          begin
            D := LockList[I];
            if (D <> nil) and (D <> Self) and
               (D.ControlChannel = ControlChannel) then
            begin
              // 현재 이벤트의 종료시각 이후의 같은 채널의 다른 디바이스의 이벤트를 구함
              P := D.GetEventByStartTime(EndTime);
              if (P <> nil) then
              begin
                // 같은 채널의 다른 디바이스의 시작시각을 조정
                Index := D.FEventQueue.IndexOf(P);

                if (SavrDurTC <= ADuration) then
                begin
                  D.ResetStartTimePlus(Index, DurEventTime, ControlFrameRateType);
                end
                else
                begin
                  D.ResetStartTimeMinus(Index, DurEventTime, ControlFrameRateType);
                end;

                // 다른 디바이스의 이벤트 채널 리프레쉬
                if (P^.EventType = ET_PLAYER) then
                begin
                  ChannelForm := frmDCS.GetChannelFormByID(P^.EventID.ChannelID);
                  if (ChannelForm <> nil) then
                  begin
                    ChannelForm.ChangeDurationEvent(P, D.Device);
                  end;
                end;
              end;

//              Assert(False, GetLogDevice(lsNormal, Format('TDeviceThread.ChangeDurationEvent Start, Handle = %d, Start = %s, end = %s', [D.Device^.Handle, EventTimeToString(StartTime, ControlFrameRateType), EventTimeToString(EndTime, ControlFrameRateType)])));

              // 현재 이벤트의 시작시각과 종료시각 사이의 같은 채널의 다른 디바이스의 이벤트를 구함
              P := D.GetEventByInRangeTime(StartTime, EndTime);

              if (P <> nil) then
              begin
//              Assert(False, GetLogDevice(lsNormal, AHostIP, P^.EventID.ChannelID, Format('TDeviceThread.ChangeDurationEvent GetEventByInRangeTime, Start time = %s', [EventTimeToString(P^.StartTime, D.ControlFrameRateType)])));
                // 같은 채널의 다른 디바이스의 길이 조정
                if (SavrDurTC <= ADuration) then
                begin
//              Assert(False, GetLogDevice(lsNormal, AHostIP, P^.EventID.ChannelID, Format('TDeviceThread.ChangeDurationEvent Plus, DurTime = %s', [TimecodeToString(P^.DurTime, ControlIsDropFrame)])));
                  P^.DurTime := GetPlusTimecode(P^.DurTime, DurTC, D.ControlFrameRateType);
//              Assert(False, GetLogDevice(lsNormal, AHostIP, P^.EventID.ChannelID, Format('TDeviceThread.ChangeDurationEvent Plus, DurTime = %s, DurTC = %s', [TimecodeToString(P^.DurTime, ControlIsDropFrame), TimecodeToString(DurTC, ControlIsDropFrame)])));
//              Assert(False, GetLogDevice(lsNormal, 'TDeviceThread.ChangeDurationEvent Plus, Dur time = %s'));
                end
                else
                begin
                  P^.DurTime := GetMinusTimecode(P^.DurTime, DurTC, D.ControlFrameRateType);
//              Assert(False, GetLogDevice(lsNormal, AHostIP, P^.EventID.ChannelID, Format('TDeviceThread.ChangeDurationEvent Minus, Dur time = %s', [TimecodeToString(DurTC, ControlIsDropFrame)])));
                end;

                // 다른 디바이스의 이벤트 채널 리프레쉬
                if (P^.EventType = ET_PLAYER) then
                begin
                  ChannelForm := frmDCS.GetChannelFormByID(P^.EventID.ChannelID);
                  if (ChannelForm <> nil) then
                  begin
                    ChannelForm.ChangeDurationEvent(P, D.Device);
                  end;
                end;
              end;
            end;
          end;
        finally
          GV_DeviceThreadList.UnLockList;
        end;


        Assert(False, GetLogDevice(lsNormal, AHostIP, E^.EventID.ChannelID,
                                   Format('Change duration event, id = %s, start = %s, new duration = %s',
                                          [EventIDToString(E^.EventID),
                                           EventTimeToDateTimecodeStr(E^.StartTime, ControlFrameRateType, True),
                                           TimecodeToString(E^.DurTime, ControlIsDropFrame)])));

      finally
//        FEventControlThread.SetExecute;
      end;
    Result := D_OK;
    end;
  finally
    FEventLock.Leave;
  end;



exit;


  Result := D_FALSE;

  FEventLock.Enter;
  try
    E := GetEventByID(AEventID);
    if (E <> nil) then
    begin
//      FEventControlThread.ResetExecute;
      try
        WaitForEventCompleted(INFINITE);

//        WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);
//        WaitForSingleObject(FEventCompleted, INFINITE);

        if (E^.DurTime = ADuration) then exit;

        Index := FEventQueue.IndexOf(E) + 1;

        DurEventTime := TimecodeToEventTime(GetDurTimecode(E^.DurTime, ADuration, ControlFrameRateType));
        if (E^.DurTime <= ADuration) then
        begin
          ResetStartTimePlus(Index, DurEventTime, ControlFrameRateType);
        end
        else
        begin
          ResetStartTimeMinus(Index, DurEventTime, ControlFrameRateType);
        end;

        E^.DurTime := ADuration;

        if (E = EventCurr) and (EventCurr^.Status.State = esOnAir) then
          SetEvent(FEventChanged);

        if (E^.EventType = ET_PLAYER) then
        begin
          ChannelForm := frmDCS.GetChannelFormByID(E^.EventID.ChannelID);
          if (ChannelForm <> nil) then
          begin
            ChannelForm.ChangeDurationEvent(E, Device);
          end;
        end;

        Assert(False, GetLogDevice(lsNormal, AHostIP, E^.EventID.ChannelID,
                                   Format('Change duration event, id = %s, start = %s, new duration = %s',
                                          [EventIDToString(E^.EventID),
                                           EventTimeToDateTimecodeStr(E^.StartTime, ControlFrameRateType, True),
                                           TimecodeToString(E^.DurTime, ControlIsDropFrame)])));
      finally
//        FEventControlThread.SetExecute;
      end;

      Result := D_OK;
    end;
  finally
    FEventLock.Leave;
  end;
end;

function TDeviceThread.GetOnAirEventID(AHostIP: AnsiString; var AOnAirEventID, ANextEventID: TEventID): Integer;
var
  I: Integer;
  E: PEvent;
begin
  Result := D_FALSE;

//  FEventControlThread.ResetExecute;
//  FEventLock.Enter;
  try
    WaitForEventCompleted(INFINITE);

//    WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);
//    WaitForSingleObject(FEventCompleted, INFINITE);

    FEventLock.Enter;
    try
      FillChar(AOnAirEventID, SizeOf(TEventID), #0);
      FillChar(ANextEventID, SizeOf(TEventID), #0);

      if (EventCurr <> nil) {and (EventCurr^.Status.State = esOnAir)} then
      begin
        AOnAirEventID := EventCurr^.EventID;
      end;

      if (EventNext <> nil) {and (EventNext^.Status.State >= esLoading)} then
      begin
        ANextEventID := EventNext^.EventID;
      end;
    finally
      FEventLock.Leave;
    end;
  finally
//    FEventControlThread.SetExecute;
//    FEventLock.Leave;
  end;

  Result := D_OK;

{  for I := 0 to FEventQueue.Count - 1 do
  begin
    E := FEventQueue[I];
    if (E <> nil) and (E^.TakeEvent) then
    begin
      AEventID    := E^.EventID;

      Result := D_OK;
      break;
    end;
  end; }
end;

function TDeviceThread.GetEventInfo(AHostIP: AnsiString; AEventID: TEventID; var AStartTime: TEventTime; var ADurationTC: TTimecode): Integer;
var
  I: Integer;
  E: PEvent;
begin
  Result := D_FALSE;

//  FEventControlThread.ResetExecute;
  try
    WaitForEventCompleted(INFINITE);

//    WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);
//    WaitForSingleObject(FEventCompleted, INFINITE);

    FEventLock.Enter;
    try
      AStartTime.T := 0;
      AStartTime.D := 0;
      ADurationTC  := 0;

      E := GetEventByID(AEventID);
      if (E = nil) then exit;

      AStartTime  := E^.StartTime;
      ADurationTC := E^.DurTime;
    finally
      FEventLock.Leave;
    end;
  finally
//    FEventControlThread.SetExecute;
  end;

  Result := D_OK;

{  for I := 0 to FEventQueue.Count - 1 do
  begin
    E := FEventQueue[I];
    if (E <> nil) and (E^.TakeEvent) then
    begin
      AEventID    := E^.EventID;
      AStartTime  := E^.StartTime;
      ADurationTC := E^.DurTime;

      Result := D_OK;
      break;
    end;
  end; }
end;

function TDeviceThread.GetEventStatus(AHostIP: AnsiString; AEventID: TEventID; var AEventStatus: TEventStatus): Integer;
var
  I: Integer;
  E: PEvent;
begin
  Result := D_FALSE;

//  FEventControlThread.ResetExecute;
  try
    WaitForEventCompleted(INFINITE);

//    WaitForSingleObject(FEventCompleted, DEVICE_WAIT_TIMEOUT);
//    WaitForSingleObject(FEventCompleted, INFINITE);

    FEventLock.Enter;
    try
  //    AEventStatus := esIdle;

      E := GetEventByID(AEventID);
      if (E = nil) then exit;

  //    AEventStatus := E^.Status;
    finally
      FEventLock.Leave;
    end;
  finally
//    FEventControlThread.SetExecute;
  end;

  Result := D_OK;
end;

function TDeviceThread.GetEventOverall(AHostIP: AnsiString; var AEventOverall: TEventOverall): Integer;
begin
  Result := D_FALSE;

  Move(FEventOverall, AEventOverall, SizeOf(TEventOverall));

  Result := D_OK;
end;

function TDeviceThread.SetDeviceStatusNotify(AStatus: TDeviceStatus): Integer;
begin
  Result := D_FALSE;

  if (HasMainControl) then exit;

  Move(AStatus, FDevice^.Status, SizeOf(TDeviceStatus));
  PostMessage(frmDeviceList.Handle, WM_UPDATE_DEVICE_STATUS, FDevice^.Handle, NativeInt(@FDevice^.Status));
end;

function TDeviceThread.SetEventStatusNotify(AEventID: TEventID; AStatus: TEventStatus): Integer;
var
  Event: PEvent;
  ChannelForm: TfrmChannelEvents;
  Index: Integer;
begin
  Result := D_FALSE;

  if (HasMainControl) then exit;

  Event := GetEventByID(AEventID);
  if (Event = nil) then exit;

  FEventLock.Enter;
  try
    Move(AStatus, Event^.Status, SizeOf(TEventStatus));
    Event^.TakeEvent := (AStatus.State = esOnAir);

    ControlChannel := AEventID.ChannelID;

    if (Event^.EventType = ET_PLAYER) then
    begin
      ChannelForm := frmDCS.GetChannelFormByID(AEventID.ChannelID);
      if (ChannelForm <> nil) then
      begin
        ChannelForm.SetEventStatus(Self, Event, AStatus.State, AStatus.ErrorCode);
//        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventStatus ChannelForm.SetEventStatus, id = %s', [EventIDToString(AEvent^.EventID)])));
      end;
    end;

//        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventStatus finish, id = %s', [EventIDToString(AEvent^.EventID)])));
  //  if (AEvent^.Status in [esError, esDone]) then
  //    FEventQueue.Remove(AEvent);

{    if (AStatus.State = esDone) then
    begin
      FEventLock.Enter;
      try
        FEventQueue.Remove(Event);
        Dispose(Event);
        if (Event = EventCurr) then
          EventCurr := nil;
      finally
        FEventLock.Leave;
      end;
    end; }

  finally
    FEventLock.Leave;
  end;
end;

function TDeviceThread.SetEventCurrNotify(AEventID: TEventID): Integer;
var
  Event: PEvent;
begin
  Result := D_FALSE;

  if (HasMainControl) then exit;

        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventCurrNotify start, id = %s', [EventIDToString(AEventID)])));

  Move(AEventID, FEventCurrID, SizeOf(TEventID));

  FEventLock.Enter;
  try
    Event := GetEventByID(AEventID);
    if (EventCurr <> Event) then
    begin
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventCurrNotify ok, id = %s', [EventIDToString(AEventID)])));
      EventCurr := Event;
    end;
  finally
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventCurrNotify end, id = %s', [EventIDToString(AEventID)])));
    FEventLock.Leave;
  end;

  Result := D_OK;


exit;

  //  Move(AEventID, FEventCurrID, SizeOf(TEventID));

  FEventLock.Enter;
  try
    Event := GetEventByID(AEventID);
    if (EventCurr <> Event) then
    begin
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventCurrNotify ok, id = %s', [EventIDToString(AEventID)])));
      EventCurr := Event;
    end;
  finally
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventCurrNotify end, id = %s', [EventIDToString(AEventID)])));
    FEventLock.Leave;
  end;

  Result := D_OK;
end;

function TDeviceThread.SetEventNextNotify(AEventID: TEventID): Integer;
var
  Event: PEvent;
begin
  Result := D_FALSE;

  if (HasMainControl) then exit;

  Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventNextNotify start, id = %s', [EventIDToString(AEventID)])));

  Move(AEventID, FEventNextID, SizeOf(TEventID));

  FEventLock.Enter;
  try
    Event := GetEventByID(AEventID);
    if (EventNext <> Event) then
    begin
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventNextNotify ok, id = %s', [EventIDToString(AEventID)])));
      EventNext := Event;
    end;
  finally
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventNextNotify end, id = %s', [EventIDToString(AEventID)])));
    FEventLock.Leave;
  end;

  Result := D_OK;

exit;



  //  Move(AEventID, FEventNextID, SizeOf(TEventID));

  FEventLock.Enter;
  try
    Event := GetEventByID(AEventID);
    if (EventNext <> Event) then
    begin
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventNextNotify ok, id = %s', [EventIDToString(AEventID)])));
      EventNext := Event;
    end;
  finally
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventNextNotify end, id = %s', [EventIDToString(AEventID)])));
    FEventLock.Leave;
  end;

  Result := D_OK;
end;

function TDeviceThread.SetEventFiniNotify(AEventID: TEventID): Integer;
var
  Event, E: PEvent;
begin
  Result := D_FALSE;

  if (HasMainControl) then exit;

        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventFiniNotify start, id = %s', [EventIDToString(AEventID)])));

  Move(AEventID, FEventFiniID, SizeOf(TEventID));

  FEventLock.Enter;
  try
    Event := GetEventByID(AEventID);
    if (EventFini <> Event) then
    begin
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventFiniNotify ok, id = %s', [EventIDToString(AEventID)])));
      EventFini := Event;
    end;
  finally
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventFiniNotify end, id = %s', [EventIDToString(AEventID)])));
    FEventLock.Leave;
  end;

  Result := D_OK;


exit;
  //  Move(AEventID, FEventFiniID, SizeOf(TEventID));

  FEventLock.Enter;
  try
    Event := GetEventByID(AEventID);
    if (EventFini <> Event) then
    begin
      if (EventFini <> nil) then
      begin
//  FEventLock.Enter;
  try
        E := EventFini;
//        EventFini := nil;

        if (FEventQueue.IndexOf(E) >= 0) then
        begin
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventFiniNotify remove ok, id = %s', [EventIDToString(E^.EventID)])));
          FEventQueue.Remove(E);
          Dispose(E);
        end;
  finally
//    FEventLock.Leave;
  end;
      end;
      EventFini := Event;
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventFiniNotify ok, id = %s', [EventIDToString(AEventID)])));
    end;
  finally
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.SetEventFiniNotify end, id = %s', [EventIDToString(AEventID)])));
    FEventLock.Leave;
  end;

  Result := D_OK;
end;

function TDeviceThread.RemoveEventNotify(AEventID: TEventID): Integer;
var
  Event: PEvent;
begin
  Result := D_FALSE;

  if (HasMainControl) then exit;

        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.RemoveEventNotify start, id = %s', [EventIDToString(AEventID)])));

  FEventLock.Enter;
  try
    Event := GetEventByID(AEventID);
      if (Event <> nil) then
      begin
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.RemoveEventNotify remove ok, id = %s', [EventIDToString(AEventID)])));
          FEventQueue.Remove(Event);
          Dispose(Event);

      Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.RemoveEventNotify ok, id = %s', [EventIDToString(AEventID)])));
      end;
  finally
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceThread.RemoveEventNotify end, id = %s', [EventIDToString(AEventID)])));
    FEventLock.Leave;
  end;

  Result := D_OK;
end;

{ TGetStatusThread }

{constructor TGetStatusThread.Create(ADeviceThread: TDeviceThread);
begin
  FDeviceThread := ADeviceThread;

  FEventClose := CreateEvent(nil, True, False, nil);

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TGetStatusThread.Destroy;
begin
  CloseHandle(FEventClose);

  FDeviceThread := nil;

  inherited Destroy;
end;

procedure TGetStatusThread.Close;
begin
  SetEvent(FEventClose);
end;

procedure TGetStatusThread.Execute;
var
  WaitResult: Integer;
begin
  while not Terminated do
  begin
    WaitResult := WaitForSingleObject(FEventClose, DEVICE_STATUS_TIMEOUT);
    if (WaitResult = WAIT_OBJECT_0) then break;

    SetEvent(FDeviceThread.FEventGetStatus);
  end;
end; }

{ TEventOverallNotifyThread }

constructor TEventOverallNotifyThread.Create(ADeviceThread: TDeviceThread);
begin
  FDeviceThread := ADeviceThread;

  FEventClose   := CreateEvent(nil, True, False, nil);
  FEventExecute := CreateEvent(nil, True, True, nil);

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TEventOverallNotifyThread.Destroy;
begin
  CloseHandle(FEventClose);
  CloseHandle(FEventExecute);

  FDeviceThread := nil;

  inherited Destroy;
end;

procedure TEventOverallNotifyThread.Close;
begin
  SetEvent(FEventClose);
end;

procedure TEventOverallNotifyThread.Execute;
var
  WaitResult: Integer;
  WaitHandles: array[0..1] of THandle;
begin
  WaitHandles[0] := FEventClose;
  WaitHandles[1] := FEventExecute;

  while not Terminated do
  begin
    WaitResult := WaitForMultipleObjects(2, @WaitHandles, False, INFINITE);
    case WaitResult of
      WAIT_OBJECT_0: break;
      WAIT_OBJECT_0 + 1:
      begin
        with FDeviceThread do
        begin
          FEventOverall.Time := DateTimeToTimecode(SystemTimeToDateTime(GV_TimeCurrent), ControlFrameRateType);
          TransmitNotifyEventOverall(Device^.Handle, FEventOverall);

          Sleep(1000);
        end;
      end;
    end;
  end;
end;

{ TEventControlThread }

constructor TEventControlThread.Create(ADeviceThread: TDeviceThread);
begin
  FDeviceThread := ADeviceThread;

  FEventClose   := CreateEvent(nil, True, False, nil);
  FEventExecute := CreateEvent(nil, True, True, nil);

  FDelayMilliSec := 0;

  FreeOnTerminate := False;

  inherited Create(True);

  Priority := tpTimeCritical;
end;

destructor TEventControlThread.Destroy;
begin
  CloseHandle(FEventClose);
  CloseHandle(FEventExecute);

  FDeviceThread := nil;

  inherited Destroy;
end;

procedure TEventControlThread.SetDelayMilliSec(AValue: Integer);
begin
  if (FDelayMilliSec <> AValue) then
    FDelayMilliSec := AValue;
end;

procedure TEventControlThread.Close;
begin
  Terminate;
  SetEvent(FEventClose);
end;

procedure TEventControlThread.SetExecute;
begin
//  SetEvent(FEventExecute);
end;

procedure TEventControlThread.ResetExecute;
begin
//  ResetEvent(FEventExecute);
end;

procedure TEventControlThread.DoEventControl;
var
  Curr, Next, Fini: PEvent;

  EventID: TEventID;

  CurrTime: TDateTime;
  StartTime, EndTime: TDateTime;

  FinishTime: TDateTime;

  CueTime: TConfigCueTimeList;
  ActCueTime: TDateTime;

  PreFrames: Word;
begin
//  WaitForSingleObject(FEventExecute, INFINITE);

  if (not HasMainControl) then exit;

  with FDeviceThread do
  begin

//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start', [])));
//    WaitForSingleObject(FEventCompleted, INFINITE);

//    CurrTime := SystemTimeToDateTime(GV_TimeCurrent);
//    CurrTime := Now;//SystemTimeToDateTime(GV_TimeCurrent);

      CurrTime := IncMilliSecond(Now, FDelayMilliSec);

//fEventLock.Enter;
try
  Curr := EventCurr;

    if (Curr <> nil) then
    begin
//            if (Curr^.Status.State <= esOnAir) then
//      if (Curr^.Status.State <= esOnAir) then
      begin
        EndTime := EventTimeToDateTime(GetEventEndTime(Curr^.StartTime, Curr^.DurTime, ControlFrameRateType), ControlFrameRateType);
        EndTime := IncMilliSecond(EndTime, -FrameToMilliSec(1, ControlFrameRateType));

        if (EndTime <= CurrTime) then
        begin
//          SetEventStatus(Curr, esFinish);
//            OutputDebugString(PChar(DateTimeToStr(EndTime)));
          ResetEvent(FEventStopCompleted);

          EventID := Curr^.EventID;
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Stop Start. id = %s, start = %s, end = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Curr^.StartTime, ControlFrameRateType), EventTimeToDateTimecodeStr(DateTimeToEventTime(EndTime, ControlFrameRateType), ControlFrameRateType)])));
          SetEvent(FEventStop);
//          exit;
          WaitForSingleObject(FEventStopCompleted, FDeviceCommandTimeout);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Stop End. id = %s, start = %s end = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Curr^.StartTime, ControlFrameRateType), EventTimeToDateTimecodeStr(DateTimeToEventTime(EndTime, ControlFrameRateType), ControlFrameRateType)])));
//  WaitForSingleObject(FEventExecute, INFINITE);
//          else
        end;
      end;
    end;

  Fini := EventFini;

    if (Fini <> nil) then
    begin
//      if (Fini^.Status.State <= esFinish) then
      begin
        EndTime := EventTimeToDateTime(GetEventEndTime(Fini^.StartTime, Fini^.DurTime, ControlFrameRateType), ControlFrameRateType);
        EndTime := IncMilliSecond(EndTime, TimecodeToMilliSec(FFinishActionDelayTime, ControlFrameRateType));
        EndTime := IncMilliSecond(EndTime, -FrameToMilliSec(1, ControlFrameRateType));

        if (EndTime <= CurrTime) then
        begin
//          SetEventStatus(Fini, esFinishing);

//            OutputDebugString(PChar(DateTimeToStr(EndTime)));
          ResetEvent(FEventFinishCompleted);

          EventID := Fini^.EventID;
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Finish Start. id = %s, start = %s, end = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Fini^.StartTime, ControlFrameRateType), EventTimeToDateTimecodeStr(DateTimeToEventTime(EndTime, ControlFrameRateType), ControlFrameRateType)])));
          SetEvent(FEventFinish);
//          exit;
          WaitForSingleObject(FEventFinishCompleted, FFinishActionTimeOut);
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Finish End. id = %s, start = %s, end = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Fini^.StartTime), EventTimeToDateTimecodeStr(DateTimeToEventTime(EndTime))])));
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Finish End.', [])));
//  WaitForSingleObject(FEventExecute, INFINITE);
//          else
        end;
      end;
    end;

//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start 1', [])));
  Next := EventNext;

    if (Next <> nil) then
    begin
      StartTime := EventTimeToDateTime(Next^.StartTime, ControlFrameRateType);
//      StartTime := IncMilliSecond(StartTime, FrameToMilliSec(FDevice.FrameDelay, ControlFrameRateType));
//      if (FDevice^.DeviceType in [DT_PCS_MEDIA, DT_LOUTH]) then
//        StartTime := IncMilliSecond(StartTime, -FrameToMilliSec(1));

//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start 1-1', [])));
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start 1-1, id = %s, start = %s, status %s', [EventIDToString(Next^.EventID), EventTimeToDateTimecodeStr(Next^.StartTime), EventStatusNames[Next^.Status.State]])));

      if (Next^.Status.State <= esLoaded) {and (StartTime > CurrTime)} then
      begin
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start 1-2', [])));
        // 장비 유형별 cue time 구함
        case FDevice^.DeviceType of
          DT_PCS_MEDIA,
          DT_LOUTH..DT_OMNEON,
          DT_LINE:
          begin
            CueTime := GV_ConfigEventVS.CueTime;
          end;
          DT_SBC:
          begin
            CueTime := GV_ConfigEventVCR.CueTime;
          end;
          DT_PCS_CG,
          DT_TAPI..DT_NSC:
          begin
            CueTime := GV_ConfigEventCG.CueTime;
          end;
          DT_PCS_SWITCHER,
          DT_VTS..DT_VIK:
          begin
            CueTime := GV_ConfigEventMCS.PSTSetTime;
          end;
        else
          CueTime := nil;
        end;

        // Default cue ready before 10 seconds
        ActCueTime := IncMilliSecond(CurrTime, 10000);

        if (CueTime <> nil) and (FNumCued >= 0) and (FNumCued < CueTime.Count) then
//           (Next^.Status.State < esCued) then
        begin
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start 1-3', [])));

          ActCueTime := IncMilliSecond(CurrTime, TimecodeToMilliSec(CueTime[FNumCued].CueTime, ControlFrameRateType));
          if {(Next^.ManualEvent) or }(StartTime <= ActCueTime) then
          begin
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start 1-4', [])));
//            SetEventStatus(Next, esCueing);

            ResetEvent(FEventCueCompleted);

          EventID := Next^.EventID;
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Cue Start. id = %s, start = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Next^.StartTime, ControlFrameRateType)])));
            SetEvent(FEventCue);
//          exit;
            WaitForSingleObject(FEventCueCompleted, FCueTimeout);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Cue End. id = %s, start = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Next^.StartTime, ControlFrameRateType)])));
//  WaitForSingleObject(FEventExecute, INFINITE);
          end;
        end;
      end;

{      if (CurrTime >= IncMilliSecond(StartTime, -5000)) then
      begin
        FEventStartThread.StartAt(Next^.EventID, Next^.StartTime);
      end;  }


//            if (Next^.Status.State in [esLoaded]) then
//            begin
//              if {(Curr = nil) or } (Next^.ManualEvent) or (StartTime <= IncSecond(CurrTime, 10)) then
//              begin
//                ResetEvent(FEventCompleted);
//                SetEvent(FEventCue);
//                WaitForSingleObject(FEventCompleted, INFINITE);
//              end;
//            end
//            else if {(FNext^.Status.State = esCued) and} (StartTime <= CurrTime) {and
//                    ((not FNext^.ManualEvent) or (FNext^.TakeEvent))} then
//            begin
////            OutputDebugString(PChar(DateTimeToStr(StartTime)));
//              ResetEvent(FEventCompleted);
//              SetEvent(FEventStart);
//              WaitForSingleObject(FEventCompleted, INFINITE);
//            end;

      PreFrames := 0;
      case FDevice^.DeviceType of
{        DT_PCS_MEDIA:
        begin
          case Next^.Player.PlayerAction of
            PA_AD:
            begin
//              StartTime := IncMilliSecond(StartTime, -(TimecodeToMilliSec(FDevice^.PCSMedia.Scte35DelayTime, FR_30)));
              PreFrames := TimecodeToFrame(FDevice^.PCSMedia.Scte35DelayTime, FR_30);
            end;
          end;
        end; }
        DT_PCS_SWITCHER,
        DT_VTS..DT_VIK:
        begin
          case Next^.Switcher.VideoTransRate of
            TR_CUT:    PreFrames := GV_ConfigEventMCS.TrRateCutTime;
            TR_FAST:   PreFrames := GV_ConfigEventMCS.TrRateFastTime;
            TR_MEDIUM: PreFrames := GV_ConfigEventMCS.TrRateMediumTime;
            TR_SLOW:   PreFrames := GV_ConfigEventMCS.TrRateSlowTime;
          end;
        end;
      end;

      if (PreFrames > 0) then
      begin
        StartTime := IncMilliSecond(StartTime, -(FrameToMilliSec(PreFrames, FR_30)));
      end;


      // 다음 이벤트의 시작시간이 자났을때 Start에서 다음 이벤트를 가져오기 위해
      // 상태가 error, cued를 같이 비교함
      if {(Next^.Status.State <= esCued) and} (StartTime <= CurrTime) then
      begin
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start 1-5', [])));

////        if (Curr <> nil) and (Curr^.Status.State <= esOnAir) then
//        if (Curr <> nil) and (Curr^.Status.State = esOnAir) then
//        begin
////                if (Curr^.Status.State = esOnAir) then
////          if (Curr^.Status.State <= esOnAir) then
//          begin
////          SetEventStatus(Curr, esFinish);
//
//            ResetEvent(FEventStopCompleted);
//            SetEvent(FEventStop);
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Stop 2', [])));
////          exit;
//            WaitForSingleObject(FEventStopCompleted, INFINITE);
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Stop 2-1', [])));
//          end;
//        end;

//              Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('NextEvnt, Index = %d, ID = %s', [FEventQueue.IndexOf(FDeviceThread.Next), EventIDToString(FDeviceThread.Next^.EventID)])));


//          SetEventStatus(Next, esOnAir);
//            OutputDebugString(PChar(DateTimeToStr(StartTime)));
        ResetEvent(FEventStartCompleted);

          EventID := Next^.EventID;
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start Start. id = %s, start = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Next^.StartTime, ControlFrameRateType)])));
        SetEvent(FEventStart);
//          exit;
        WaitForSingleObject(FEventStartCompleted, FDeviceCommandTimeout);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start End. id = %s, start = %s', [EventIDToString(EventID), EventTimeToDateTimecodeStr(Next^.StartTime, ControlFrameRateType)])));
//  WaitForSingleObject(FEventExecute, INFINITE);
      end;

    end;

//          Sleep(30);
finally
//  fEventLock.Leave;
end;
  end;
end;

procedure TEventControlThread.Execute;
var
  WaitResult: Integer;
//  WaitHandles: array[0..1] of THandle;
  WaitHandles: array[0..0] of THandle;
begin
  WaitHandles[0] := FEventClose;
//  WaitHandles[1] := GV_DeviceTimerExecuteEvent;//FEventExecute;

  while not Terminated do
  begin
//    WaitResult := WaitForMultipleObjects(2, @WaitHandles, False, INFINITE);
//    WaitResult := WaitForMultipleObjects(1, @WaitHandles, False, 30);
    WaitResult := WaitForSingleObject(FEventClose, 1);
    case WaitResult of
      WAIT_OBJECT_0: break;
//      WAIT_OBJECT_0 + 1: DoEventControl;
      WAIT_TIMEOUT:
      begin
//        with FDeviceThread do
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl Start', [])));
      DoEventControl;
//        with FDeviceThread do
//          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('DoEventControl End', [])));
      end;
    end;
  end;
end;

end.
