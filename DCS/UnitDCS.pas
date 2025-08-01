unit UnitDCS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.SyncObjs, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, WMTools, WMControls,
  Vcl.ExtCtrls, Vcl.Grids, AdvObj, BaseGrid, Vcl.StdCtrls,
  AdvOfficePager, AdvOfficePagerStylers, AdvGrid, AdvCGrid, AdvUtil, Vcl.Imaging.pngimage,
  AdvSplitter, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.ActnMan, Vcl.Menus, Winapi.MMSystem,
  UnitCommons, UnitTypeConvert, UnitConsts,
  UnitNormalForm,
  UnitUDPIn, UnitUDPOut, UnitTCPOut,
  UnitDeviceThread,
  UnitChannelEvents, UnitLogCommon, UnitLogDevice;

type
  TCrossCheckThread = class;
//  TTimerThread = class;

  TfrmDCS = class(TfrmNormal)
    aoPagerMain: TAdvOfficePager;
    aopEventAndDeviceStatus: TAdvOfficePage;
    aopLogDevice: TAdvOfficePage;
    aoPagerLogDevice: TAdvOfficePager;
    aoPagerEvent: TAdvOfficePager;
    WMPanel4: TWMPanel;
    WMPanel1: TWMPanel;
    lblCurrentTime: TLabel;
    WMPanel2: TWMPanel;
    lblActivate: TLabel;
    WMPanel3: TWMPanel;
    lblDCSName: TLabel;
    pnlDeviceList: TWMPanel;
    AdvSplitter1: TAdvSplitter;
    aopCommonLog: TAdvOfficePage;
    actManager: TActionManager;
    actFileMainChange: TAction;
    actDeviceReset: TAction;
    actDeviceResetAll: TAction;
    wmtiDCS: TWMTrayIcon;
    pmTray: TPopupMenu;
    pmFileShow: TMenuItem;
    actApply1: TMenuItem;
    pmFileExit: TMenuItem;
    actFileShow: TAction;
    actFileExit: TAction;
    aopStyler: TAdvOfficePagerOfficeStyler;
    aopStyleSmall: TAdvOfficePagerOfficeStyler;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    wmibReset: TWMImageSpeedButton;
    procedure acgEventListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure acgDeviceListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actDeviceResetExecute(Sender: TObject);
    procedure actDeviceResetAllExecute(Sender: TObject);
    procedure actFileShowExecute(Sender: TObject);
    procedure actFileExitExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure aoPagerLogDeviceMouseWheel(Sender: TObject;
      Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
    procedure actFileMainChangeExecute(Sender: TObject);
  private
    { Private declarations }
    FUDPSysIn: TUDPIn;
    FUDPSysOut: TUDPOut;

    FSysRecvBuffer: AnsiString;
    FSysRecvData: AnsiString;

    FUDPNotify: TUDPOut;
    FUDPIn: TUDPIn;
    FUDPOut: TUDPOut;
    FUDPEventStatusNotify: TUDPIn;

    FRecvBuffer: AnsiString;
    FRecvData: AnsiString;

    FEventStatusRecvBuffer: AnsiString;
    FEventStatusRecvData: AnsiString;

    FSysInCritSec: TCriticalSection;
    FInCritSec: TCriticalSection;
    FEventStatusCritSec: TCriticalSection;

    FCrossCheckThread: TCrossCheckThread;
//    FTimerThread: TTimerThread;

    FTimerID: UINT;
    FDeviceTimerID: UINT;

    FIsTerminate: Boolean;

    function SendSysResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
    function SendSysAck(AHostIP: AnsiString; APort: Word): Integer;
    function SendSysNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function SendSysError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    function SendNotifyResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
    function SendNotifyAck(AHostIP: AnsiString; APort: Word): Integer;
    function SendNotifyNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function SendNotifyError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    function SendResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
    function SendAck(AHostIP: AnsiString; APort: Word): Integer;
    function SendNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function SendError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    function SendEventStatusNotify(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;

    procedure InitializeChannelEventPage;
    procedure FinalizeChannelEventPage;

    procedure InitializeDeviceList;
    procedure FinalizeDeviceList;

    procedure InitializeLogCommonGrid;
    procedure FinalizeLogCommonGrid;

    procedure InitializeLogDeviceGrid;
    procedure FinalizeLogDeviceGrid;

    procedure DisplayActivate;

    procedure TimerThreadEvent(Sender: TObject);

    procedure UDPSysInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
    procedure UDPInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
    procedure UDPEventStatusNotifyRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
//    procedure WndProc(var Message: TMessage); override;

    procedure WMUpdateCurrentTime(var Message: TMessage); message WM_UPDATE_CURRENT_TIME;
    procedure WMUpdateActivate(var Message: TMessage); message WM_UPDATE_ACTIVATE;
  public
    { Public declarations }
    function GetChannelFormByID(AChannelID: Byte): TfrmChannelEvents;
    function GetLogCommonForm: TfrmLogCommon;
    function GetLogDeviceFormByHandle(ADeviceHandle: TDeviceHandle): TfrmLogDevice;

    procedure DisplayStartCheck(ACheckStr: String; AProgress: Integer = 0);
    procedure DisplayStartStatus(AStatusStr: String; AProgress: Integer = 0);

    procedure Initialize;
    procedure Finalize;

    function TransmitSysResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
    function TransmitSysAck(AHostIP: AnsiString; APort: Word): Integer;
    function TransmitSysNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function TransmitSysError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    function TransmitNotifyResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
    function TransmitNotifyAck(AHostIP: AnsiString; APort: Word): Integer;
    function TransmitNotifyNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function TransmitNotifyError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    function TransmitResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
    function TransmitAck(AHostIP: AnsiString; APort: Word): Integer;
    function TransmitNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function TransmitError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    function TransmitEventStatusNotify(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;

    // 0X00 System Control
    function DCSIsAlive(var AIsAlive: Boolean): Integer;                    // 0X00.00
    function DCSIsMain(var AIsMain: Boolean): Integer;                      // 0X00.01
    function DCSSetMain(ABuffer: AnsiString): Integer;                         // 0X00.10
    function DCSGetEventCount(ABuffer: AnsiString; var AEventCount: Integer): Integer;         // 0X00.20
    function DCSGetEvent(ABuffer: AnsiString; var AEvent: TEvent): Integer;         // 0X00.21
    function DCSGetEventCurrNext(ABuffer: AnsiString; var ACurrEventID, ANextEventID: TEventID): Integer;         // 0X00.22

    // 0X10 Device Control
    function DCSOpen(AHostIP, ABuffer: AnsiString; var ADeviceHandle: TDeviceHandle): Integer;  // 0X10.00
    function DCSClose(ABuffer: AnsiString): Integer;                                            // 0X10.01
    function DCSReset(AHostIP, ABuffer: AnsiString): Integer;                                   // 0X10.02
    function DCSSetControlBy(AHostIP, ABuffer: AnsiString): Integer;                            // 0X10.03
    function DCSSetControlChannel(AHostIP, ABuffer: AnsiString): Integer;                       // 0X10.04

    // 0X20, 30, 40 Command
    function DCSCommand(AHostIP: AnsiString; ACMD1, ACMD2: Byte; ACMDBuffer: AnsiString; var AResultBuffer: AnsiString): Integer;

    // 0X40 Sense Queries
    function DCSGetDeviceStatus(ABuffer: AnsiString; var AStatus: TDeviceStatus): Integer;  // 0X40.00

    // 0X50 Event Control
    function DCSInputEvent(AHostIP, ABuffer: AnsiString): Integer;      // 0X50.00
    function DCSDeleteEvent(AHostIP, ABuffer: AnsiString): Integer;     // 0X50.01
    function DCSClearEvent(AHostIP, ABuffer: AnsiString): Integer;      // 0X50.02
    function DCSTakeEvent(AHostIP, ABuffer: AnsiString): Integer;       // 0X50.10
    function DCSHoldEvent(AHostIP, ABuffer: AnsiString): Integer;       // 0X50.11
    function DCSChangeEventDuration(AHostIP, ABuffer: AnsiString): Integer; // 0X04.12
    function DCSGetOnAirEventID(AHostIP, ABuffer: AnsiString; var AOnAirEventID, ANextEventID: TEventID): Integer; // 0X50.20
    function DCSGetEventInfo(AHostIP, ABuffer: AnsiString; var AStartTime: TEventTime; var ADurationTC: TTimecode): Integer; // 0X50.21
    function DCSGetEventStatus(AHostIP, ABuffer: AnsiString; var AEventStatus: TEventStatus): Integer; // 0X50.22
    function DCSGetEventOverall(AHostIP, ABuffer: AnsiString; var AEventOverall: TEventOverall): Integer; // 0X50.24

    // 0X60 Event Status Notify
    function DCSSetDeviceStatusNotify(ABuffer: AnsiString): Integer; // 0X60.00
    function DCSSetEventStatusNotify(ABuffer: AnsiString): Integer; // 0X60.01
    function DCSSetEventCurrNotify(ABuffer: AnsiString): Integer; // 0X60.10
    function DCSSetEventNextNotify(ABuffer: AnsiString): Integer; // 0X60.11
    function DCSSetEventFiniNotify(ABuffer: AnsiString): Integer; // 0X60.12
    function DCSRemoveEventNotify(ABuffer: AnsiString): Integer; // 0X60.20

    property CrossCheckThread: TCrossCheckThread read FCrossCheckThread;
  end;

  TCrossCheckThread = class(TThread)
  private
    { Private declarations }
    FDCSForm: TfrmDCS;

    FUDPIn: TUDPIn;

    FIsCommand: Boolean;
    FCMD1, FCMD2: Byte;

    FSyncMsgEvent: THandle;
    FRecvBuffer: AnsiString;
    FRecvData: AnsiString;
    FLastResult: Integer;

    FSGCommand: AnsiString;

    FSGStrConnect: AnsiString;
    FSGStrLogin: AnsiString;
    FSGStrPrompt: AnsiString;

    FSGSyncMsgEvent: THandle;
    FSGRecvBuffer: AnsiString;
    FSGRecvData: AnsiString;
    FSGLastResult: Integer;

    FCommandCritSec: TCriticalSection;
    FInCritSec: TCriticalSection;
    FSGCommandCritSec: TCriticalSection;
    FSGInCritSec: TCriticalSection;

    FEventMainChange: THandle;
    FEventClose: THandle;

    FNumCrossCheck: Word;

    function SendCommand(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
    function SendResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
    function SendAck(AHostIP: AnsiString; APort: Word): Integer;
    function SendNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function SendError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    function SendSGCommand(ATCPOut: TTCPOut; AData: AnsiString): Integer;

    procedure UDPInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);

    procedure TCPOutRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);

    procedure SetSerialGate;
    procedure MainChange;

    procedure DoMainCheck;
    procedure DoMainChange;
    procedure DoCrossCheck;
  protected
    procedure Execute; override;
  public
    constructor Create(ADCSForm: TfrmDCS);
    destructor Destroy; override;

    procedure Terminate;

    procedure ExecuteMainChange;

    function TransmitCommand(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
    function TransmitResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
    function TransmitAck(AHostIP: AnsiString; APort: Word): Integer;
    function TransmitNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function TransmitError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    function TransmitSGCommand(ATCPOut: TTCPOut; AData: AnsiString): Integer;

    function DCSIsAlive(AHostIP: AnsiString; var AIsAlive: Boolean): Integer;
    function DCSIsMain(AHostIP: AnsiString; var AIsMain: Boolean): Integer;
    function DCSSetMain(AHostIP: AnsiString; AMainDCSID: Word): Integer;

    function DCSGetEventCount(AHostIP: AnsiString; ADeviceHandle: TDeviceHandle; var AEventCount: Integer): Integer;
    function DCSGetEvent(AHostIP: AnsiString; ADeviceHandle: TDeviceHandle; ANum: Integer; var AEvent: TEvent): Integer;
    function DCSGetEventCurrNext(AHostIP: AnsiString; ADeviceHandle: TDeviceHandle; var ACurrEventID, ANextEventID: TEventID): Integer;
  end;

{  TTimerThread = class(TThread)
  private
    FTimerEnabledFlag: THandle;
    FCancelFlag: THandle;
    FTimerProc: TNotifyEvent; // method to call
    FInterval: Cardinal;
    procedure SetEnabled(AEnable: Boolean);
    function GetEnabled: Boolean;
    procedure SetInterval(AInterval: Cardinal);
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Terminate;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Interval: Cardinal read FInterval write SetInterval;
    // Note: OnTimerEvent is executed in TTimerThread thread
    property OnTimerEvent: TNotifyEvent read FTimerProc write FTimerProc;
  end; }

var
  frmDCS: TfrmDCS;

  procedure TimerCallBack(uTimer, uMessage: UINT; dwUser, dw1, dw2: DWORD); stdcall;
  procedure DeviceTimerCallBack(uTimer, uMessage: UINT; dwUser, dw1, dw2: DWORD); stdcall;

implementation

uses Math, UnitDeviceList, UnitStartSplash;

{$R *.dfm}

procedure TimerCallBack(uTimer, uMessage: UINT; dwUser, dw1, dw2: DWORD);
var
  T: TSystemTime;
begin
  GetLocalTime(T);

  if (GV_TimeBefore.wSecond <> T.wSecond) then
  begin
    GV_TimeCurrent := T;
    GV_TimeCurrent.wMilliseconds := 0; // Frame to set 0. Because milli seconds is not 0

    SetEvent(GV_TimerExecuteEvent);
    if (frmDCS <> nil) and (frmDCS.HandleAllocated) then
      PostMessage(frmDCS.Handle, WM_UPDATE_CURRENT_TIME, 0, 0);
    ResetEvent(GV_TimerExecuteEvent);

{    if (GV_TimeCurrent.wMilliseconds <> 0) then
    begin
      Inc(GV_NotZeroCount);
      Form18.Caption := Format('%d', [GV_NotZeroCount]);
    end; }

    GV_TimeBefore := T;
  end;
end;

procedure DeviceTimerCallBack(uTimer, uMessage: UINT; dwUser, dw1, dw2: DWORD);
begin
  SetEvent(GV_DeviceTimerExecuteEvent);
  ResetEvent(GV_DeviceTimerExecuteEvent);
end;

procedure TfrmDCS.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  Params.Style := Params.Style or WS_MINIMIZEBOX;
end;

procedure TfrmDCS.WMUpdateCurrentTime(var Message: TMessage);
begin
  with GV_TimeCurrent do
    lblCurrentTime.Caption := Format('%0.4d-%0.2d-%0.2d %0.2d:%0.2d:%0.2d', [wYear, wMonth, wDay, wHour, wMinute, wSecond]);

//  with GV_TimeCurrent do
//    WMTitleBar.Caption := Format('%0.4d-%0.2d-%0.2d %0.2d:%0.2d:%0.2d.%0.3d', [wYear, wMonth, wDay, wHour, wMinute, wSecond, wMilliseconds]);
end;

procedure TfrmDCS.WMUpdateActivate(var Message: TMessage);
begin
  DisplayActivate;
end;

{procedure TfrmDCS.WndProc(var Message: TMessage);
begin
  inherited;
  case Message.Msg of
    WM_UPDATE_CURRENT_TIME:
    begin
      lblCurrentTime.Caption := FormatDateTime('YYYY-MM-DD hh:nn:ss', Now);
    end;
    WM_UPDATE_ACTIVATE:
    begin
      DisplayActivate;
    end;
    WM_INSERT_EVENT:
    begin
    end;
  end;
end;}

function TfrmDCS.GetChannelFormByID(AChannelID: Byte): TfrmChannelEvents;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to aoPagerEvent.AdvPageCount - 1 do
  begin
    if (aoPagerEvent.AdvPages[I].Tag = AChannelID) then
    begin
      if (aoPagerEvent.AdvPages[I].ControlCount > 0) then
        Result := TfrmChannelEvents(aoPagerEvent.AdvPages[I].Controls[0]);
      break;
    end;
  end;
end;

function TfrmDCS.GetLogCommonForm: TfrmLogCommon;
begin
  Result := nil;

  if (aopCommonLog.ControlCount > 0) then
    Result := TfrmLogCommon(aopCommonLog.Controls[0]);
end;

function TfrmDCS.GetLogDeviceFormByHandle(ADeviceHandle: TDeviceHandle): TfrmLogDevice;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to aoPagerLogDevice.AdvPageCount - 1 do
  begin
    if (aoPagerLogDevice.AdvPages[I].Tag = ADeviceHandle) then
    begin
      if (aoPagerLogDevice.AdvPages[I].ControlCount > 0) then
        Result := TfrmLogDevice(aoPagerLogDevice.AdvPages[I].Controls[0]);
      break;
    end;
  end;
end;

procedure TfrmDCS.Initialize;
//var
//  TimeCaps: TTimeCaps;
begin
  DisplayStartCheck('Loading configuration...', 0);

  FIsTerminate := False;
  FTimerID := 0;
  FDeviceTimerID := 0;


  GV_LogWriteLock := TCriticalSection.Create;
  GV_LogCommonLock := TCriticalSection.Create;

  GV_DCSCritSec := TCriticalSection.Create;

  GV_DCSList := TDCSList.Create;

  GV_ChannelList := TChannelList.Create;

  GV_DeviceList := TDeviceList.Create;
  GV_DeviceThreadList := TThreadList.Create;

  GV_LogCommonList := TLogCommonList.Create;

  GV_TimerExecuteEvent := CreateEvent(nil, True, False, nil);
  GV_TimerCancelEvent  := CreateEvent(nil, True, False, nil);

  GV_DeviceTimerExecuteEvent := CreateEvent(nil, True, False, nil);

  LoadConfig;

  Application.Title := Format('Device Control Server %s - %s', [GetFileVersionStr(Application.ExeName), GV_DCSMine^.Name]);
  WMTitleBar.Caption := Application.Title;
  wmtiDCS.Hint := Application.Title;

  DisplayStartCheck('Device creating...', 10);

  DeviceCreate;

  InitializeChannelEventPage;
  InitializeDeviceList;

  InitializeLogCommonGrid;

  InitializeLogDeviceGrid;

{  DisplayStartCheck('Device opening...', 20);

  DeviceOpen;
}
  FSysRecvBuffer := '';
  FSysRecvData   := '';

  FRecvBuffer := '';
  FRecvData   := '';

  FEventStatusRecvBuffer := '';
  FEventStatusRecvData   := '';

  FSysInCritSec := TCriticalSection.Create;
  FInCritSec := TCriticalSection.Create;
  FEventStatusCritSec := TCriticalSection.Create;

  DisplayStartCheck('Port opening...', 20);

  with GV_ConfigGeneral do
  begin
    FUDPSysIn                := TUDPIn.Create(SysInPort);
    FUDPSysIn.LogEnabled     := UDPLogEnable;
    FUDPSysIn.LogPath        := UDPLogPath;
    FUDPSysIn.LogExt         := Format('%d_%s', [FUDPSysIn.Port, UDPLogExt]);

    FUDPSysOut               := TUDPOut.Create(SysOutPort);
    FUDPSysOut.LogEnabled    := UDPLogEnable;
    FUDPSysOut.LogPath       := UDPLogPath;
    FUDPSysOut.LogExt        := Format('%d_%s', [FUDPSysOut.Port, UDPLogExt]);

    FUDPNotify            := TUDPOut.Create(NotifyPort);
    FUDPNotify.Broadcast  := NotifyBroadcast;
    FUDPNotify.LogEnabled := UDPLogEnable;
    FUDPNotify.LogPath    := UDPLogPath;
    FUDPNotify.LogExt     := Format('%d_%s', [FUDPNotify.Port, UDPLogExt]);

    FUDPIn                := TUDPIn.Create(InPort);
    FUDPIn.LogEnabled     := UDPLogEnable;
    FUDPIn.LogPath        := UDPLogPath;
    FUDPIn.LogExt         := Format('%d_%s', [FUDPIn.Port, UDPLogExt]);

    FUDPOut               := TUDPOut.Create(OutPort);
    FUDPOut.LogEnabled    := UDPLogEnable;
    FUDPOut.LogPath       := UDPLogPath;
    FUDPOut.LogExt        := Format('%d_%s', [FUDPOut.Port, UDPLogExt]);

    FUDPEventStatusNotify            := TUDPIn.Create(EventStatusNotifyPort);
    FUDPEventStatusNotify.Broadcast  := True;
    FUDPEventStatusNotify.LogEnabled := UDPLogEnable;
    FUDPEventStatusNotify.LogPath    := UDPLogPath;
    FUDPEventStatusNotify.LogExt     := Format('%d_%s', [FUDPEventStatusNotify.Port, UDPLogExt]);
  end;

  FUDPNotify.AsyncMode := True;
  FUDPNotify.Start;
  while not FUDPNotify.Started do
    Sleep(30);

  FUDPIn.AsyncMode := True;
  FUDPIn.OnUDPRead := UDPInRead;
  FUDPIn.Start;
  while not FUDPIn.Started do
    Sleep(30);

  FUDPOut.AsyncMode := True;
  FUDPOut.Start;
  while not FUDPOut.Started do
    Sleep(30);

  FUDPEventStatusNotify.AsyncMode := True;
  FUDPEventStatusNotify.OnUDPRead := UDPEventStatusNotifyRead;
  FUDPEventStatusNotify.Start;
  while not FUDPEventStatusNotify.Started do
    Sleep(30);

{  FUDPSysIn.AsyncMode := True;
  FUDPSysIn.OnUDPRead := UDPSysInRead;
  FUDPSysIn.Start;
  while not FUDPSysIn.Started do
    Sleep(30);

  FUDPSysOut.AsyncMode := True;
  FUDPSysOut.Start;
  while not FUDPSysOut.Started do
    Sleep(30); }

  DisplayStartCheck('Main dcs system checking...', 40);

  FCrossCheckThread := TCrossCheckThread.Create(Self);

{  FTimerThread := TTimerThread.Create;
  FTimerThread.Interval := 1000;
  FTimerThread.OnTimerEvent := TimerThreadEvent;
  FTimerThread.Enabled := True; }

  FillChar(GV_TimeBefore, SizeOf(TSystemTime), #0);
  FillChar(GV_TimeCurrent, SizeOf(TSystemTime), #0);

  GetLocalTime(GV_TimeBefore);
  GetLocalTime(GV_TimeCurrent);

//  timeGetDevCaps(@TimeCaps, SizeOf(TTimeCaps));
//
//  FTimerID := timeSetEvent(1, TimeCaps.wPeriodMin, @TimerCallBack, 0, TIME_PERIODIC);
//
//  FDeviceTimerID := timeSetEvent(1, TimeCaps.wPeriodMin, @DeviceTimerCallBack, 0, TIME_PERIODIC);

//  DisplayActivate;

//  DisplayStartCheck('System check completed.', 100);

  wmtiDCS.PopupMenu := pmTray;
end;

procedure TfrmDCS.Finalize;
begin
  SetEvent(GV_TimerCancelEvent);

  if (FDeviceTimerID <> 0) then
  begin
    timeKillEvent(FDeviceTimerID); // 타이머를 해제한다.
//    timeEndPeriod(0); // 타이머 주기를 해제한다.
  end;

  if (FTimerID <> 0) then
  begin
    timeKillEvent(FTimerID); // 타이머를 해제한다.
//    timeEndPeriod(0); // 타이머 주기를 해제한다.
  end;

{  FTimerThread.Terminate;
  FTimerThread.WaitFor;
  FreeAndNil(FTimerThread); }

  FCrossCheckThread.Terminate;
  FCrossCheckThread.WaitFor;
  FreeAndNil(FCrossCheckThread);

  CloseHandle(GV_DeviceTimerExecuteEvent);

  CloseHandle(GV_TimerExecuteEvent);
  CloseHandle(GV_TimerCancelEvent);

  DeviceClose;

 Assert(False, GetLogCommonStr(lsNormal, 'Succeeded DeviceClose.'));
  FinalizeChannelEventPage;
 Assert(False, GetLogCommonStr(lsNormal, 'Succeeded FinalizeChannelEventPage.'));
  FinalizeDeviceList;
 Assert(False, GetLogCommonStr(lsNormal, 'Succeeded FinalizeDeviceList.'));

  FinalizeLogCommonGrid;
 Assert(False, GetLogCommonStr(lsNormal, 'Succeeded FinalizeLogCommonGrid.'));

  FinalizeLogDeviceGrid;
 Assert(False, GetLogCommonStr(lsNormal, 'Succeeded FinalizeLogDeviceGrid.'));

  DeviceDestroy;
 Assert(False, GetLogCommonStr(lsNormal, 'Succeeded DeviceDestroy.'));

  FUDPSysIn.Close;
  FUDPSysIn.Terminate;
  FUDPSysIn.WaitFor;
  FreeAndNil(FUDPSysIn);

  Assert(False, GetLogCommonStr(lsNormal, 'Succeeded UDPSysIn thread destroy.'));

  FUDPSysOut.Close;
  FUDPSysOut.Terminate;
  FUDPSysOut.WaitFor;
  FreeAndNil(FUDPSysOut);

  Assert(False, GetLogCommonStr(lsNormal, 'Succeeded UDPSysOut thread destroy.'));

  FUDPEventStatusNotify.Close;
  FUDPEventStatusNotify.Terminate;
  FUDPEventStatusNotify.WaitFor;
  FreeAndNil(FUDPEventStatusNotify);

  Assert(False, GetLogCommonStr(lsNormal, 'Succeeded UDPEventStatusNotify thread destroy.'));

  FUDPIn.Close;
  FUDPIn.Terminate;
  FUDPIn.WaitFor;
  FreeAndNil(FUDPIn);

  Assert(False, GetLogCommonStr(lsNormal, 'Succeeded UDPIn thread destroy.'));

  FUDPOut.Close;
  FUDPOut.Terminate;
  FUDPOut.WaitFor;
  FreeAndNil(FUDPOut);

  Assert(False, GetLogCommonStr(lsNormal, 'Succeeded UDPOut thread destroy.'));

  FUDPNotify.Close;
  FUDPNotify.Terminate;
  FUDPNotify.WaitFor;
  FreeAndNil(FUDPNotify);

  Assert(False, GetLogCommonStr(lsNormal, 'Succeeded UDPNotify thread destroy.'));

  ClearConfigEvent;
  Assert(False, GetLogCommonStr(lsNormal, 'Succeeded ClearConfigEvent.'));

  ClearConfigSerialGate;
  Assert(False, GetLogCommonStr(lsNormal, 'Succeeded ClearConfigSerialGate.'));

  ClearDeviceList;
  Assert(False, GetLogCommonStr(lsNormal, 'Succeeded ClearDeviceList.'));

  ClearChannelList;
  Assert(False, GetLogCommonStr(lsNormal, 'Succeeded ClearChannelList.'));

  ClearDCSList;
  Assert(False, GetLogCommonStr(lsNormal, 'Succeeded ClearDCSList.'));

  Assert(False, GetLogCommonStr(lsNormal, 'Succeeded finalize.'));

  ClearLogCommonList;
//  ShowMessage('1');

  FreeAndNil(FSysInCritSec);
  FreeAndNil(FInCritSec);
  FreeAndNil(FEventStatusCritSec);
//  ShowMessage('2');

  FreeAndNil(GV_DeviceThreadList);
  FreeAndNil(GV_DeviceList);

  FreeAndNil(GV_ChannelList);

  FreeAndNil(GV_DCSCritSec);

  FreeAndNil(GV_DCSList);

  FreeAndNil(GV_LogCommonList);
//  ShowMessage('3');

  FreeAndNil(GV_LogCommonLock);
  FreeAndNil(GV_LogWriteLock);
//  ShowMessage('4');
end;

function TfrmDCS.SendSysResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
var
  Buffer: AnsiString;
  CheckSum: Byte;
  I: integer;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_STX) + WordToAnsiString($02 + ADataSize) + AnsiChar(ACMD1) + AnsiChar(ACMD2) + AData;

  CheckSum := ACMD1 + ACMD2;
  for I := 1 to ADataSize do
    CheckSum := CheckSum + Ord(AData[I]);

  CheckSum := 0 - CheckSum;
  Buffer := Buffer + AnsiChar(CheckSum);

  FUDPSysOut.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TfrmDCS.SendSysAck(AHostIP: AnsiString; APort: Word): Integer;
begin
  Result := D_FALSE;

  FUDPSysOut.Send(AHostIP, APort, AnsiChar(D_ACK));

  Result := D_OK;
end;

function TfrmDCS.SendSysNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_NAK) + AnsiChar(ANakError);

  FUDPSysOut.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TfrmDCS.SendSysError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_ERR) + IntToAnsiString(AErrorCode);

  FUDPSysOut.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TfrmDCS.SendNotifyResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
var
  Buffer: AnsiString;
  CheckSum: Byte;
  I: integer;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_STX) + WordToAnsiString($02 + ADataSize) + AnsiChar(ACMD1) + AnsiChar(ACMD2) + AData;

  CheckSum := ACMD1 + ACMD2;
  for I := 1 to ADataSize do
    CheckSum := CheckSum + Ord(AData[I]);

  CheckSum := 0 - CheckSum;
  Buffer := Buffer + AnsiChar(CheckSum);

  FUDPNotify.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TfrmDCS.SendNotifyAck(AHostIP: AnsiString; APort: Word): Integer;
begin
  Result := D_FALSE;

  FUDPNotify.Send(AHostIP, APort, AnsiChar(D_ACK));

  Result := D_OK;
end;

function TfrmDCS.SendNotifyNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_NAK) + AnsiChar(ANakError);

  FUDPNotify.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TfrmDCS.SendNotifyError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_ERR) + IntToAnsiString(AErrorCode);

  FUDPNotify.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TfrmDCS.SendResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
var
  Buffer: AnsiString;
  CheckSum: Byte;
  I: integer;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_STX) + WordToAnsiString($02 + ADataSize) + AnsiChar(ACMD1) + AnsiChar(ACMD2) + AData;

  CheckSum := ACMD1 + ACMD2;
  for I := 1 to ADataSize do
    CheckSum := CheckSum + Ord(AData[I]);

  CheckSum := 0 - CheckSum;
  Buffer := Buffer + AnsiChar(CheckSum);

  FUDPOut.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TfrmDCS.SendAck(AHostIP: AnsiString; APort: Word): Integer;
begin
  Result := D_FALSE;

  FUDPOut.Send(AHostIP, APort, AnsiChar(D_ACK));

  Result := D_OK;
end;

function TfrmDCS.SendNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_NAK) + AnsiChar(ANakError);

  FUDPOut.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TfrmDCS.SendError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_ERR) + IntToAnsiString(AErrorCode);

  FUDPOut.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TfrmDCS.SendEventStatusNotify(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
var
  Buffer: AnsiString;
  CheckSum: Byte;
  I: integer;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_STX) + WordToAnsiString($02 + ADataSize) + AnsiChar(ACMD1) + AnsiChar(ACMD2) + AData;

  CheckSum := ACMD1 + ACMD2;
  for I := 1 to ADataSize do
    CheckSum := CheckSum + Ord(AData[I]);

  CheckSum := 0 - CheckSum;
  Buffer := Buffer + AnsiChar(CheckSum);

  FUDPEventStatusNotify.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TfrmDCS.TransmitSysResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
begin
  ACMD2 := ACMD2 + $80;
  Result := SendSysResponse(AHostIP, APort, ACMD1, ACMD2, AData, ADataSize);
end;

function TfrmDCS.TransmitSysAck(AHostIP: AnsiString; APort: Word): Integer;
begin
  Result := SendSysAck(AHostIP, APort);
end;

function TfrmDCS.TransmitSysNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
begin
  Result := SendSysNak(AHostIP, APort, ANakError);
end;

function TfrmDCS.TransmitSysError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
begin
  Result := SendSysError(AHostIP, APort, AErrorCode);
end;

function TfrmDCS.TransmitNotifyResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
begin
  ACMD2 := ACMD2 + $80;
  Result := SendNotifyResponse(AHostIP, APort, ACMD1, ACMD2, AData, ADataSize);
end;

function TfrmDCS.TransmitNotifyAck(AHostIP: AnsiString; APort: Word): Integer;
begin
  Result := SendNotifyAck(AHostIP, APort);
end;

function TfrmDCS.TransmitNotifyNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
begin
  Result := SendNotifyNak(AHostIP, APort, ANakError);
end;

function TfrmDCS.TransmitNotifyError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
begin
  Result := SendNotifyError(AHostIP, APort, AErrorCode);
end;

function TfrmDCS.TransmitResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
begin
  ACMD2 := ACMD2 + $80;
  Result := SendResponse(AHostIP, APort, ACMD1, ACMD2, AData, ADataSize);
end;

function TfrmDCS.TransmitAck(AHostIP: AnsiString; APort: Word): Integer;
begin
  Result := SendAck(AHostIP, APort);
end;

function TfrmDCS.TransmitNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
begin
  Result := SendNak(AHostIP, APort, ANakError);
end;

function TfrmDCS.TransmitError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
begin
  Result := SendError(AHostIP, APort, AErrorCode);
end;

function TfrmDCS.TransmitEventStatusNotify(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
begin
  ACMD2 := ACMD2 + $80;
  Result := SendEventStatusNotify(AHostIP, APort, ACMD1, ACMD2, AData, ADataSize);
end;

procedure TfrmDCS.DisplayStartCheck(ACheckStr: String; AProgress: Integer);
begin
  if (frmStartSplash <> nil) and (frmStartSplash.HandleAllocated) then
    frmStartSplash.DisplayCheck(ACheckStr, AProgress);
end;

procedure TfrmDCS.DisplayStartStatus(AStatusStr: String; AProgress: Integer);
begin
  if (frmStartSplash <> nil) and (frmStartSplash.HandleAllocated) then
    frmStartSplash.DisplayStatus(AStatusStr, AProgress);
end;

procedure TfrmDCS.InitializeChannelEventPage;
var
  I: Integer;
  OfficePage: TAdvOfficePage;
  Channel: PChannel;
  ChannelForm: TfrmChannelEvents;
begin
  for I := 0 to GV_ChannelList.Count - 1 do
  begin
    Channel := GV_ChannelList[I];
    with aoPagerEvent do
    begin
      OfficePage := TAdvOfficePage.Create(Self);
      OfficePage.AdvOfficePager := aoPagerEvent;
      OfficePage.Caption := Channel^.Name;
      OfficePage.Tag := Channel^.ID;

      ChannelForm := TfrmChannelEvents.Create(OfficePage, Channel, True, 0, 0, OfficePage.ClientWidth, OfficePage.ClientHeight);
      ChannelForm.Parent := OfficePage;
      ChannelForm.Align := alClient;
      ChannelForm.Show;
    end;
  end;

  if (aoPagerEvent.AdvPageCount > 0) then
    aoPagerEvent.ActivePageIndex := 0;
end;

procedure TfrmDCS.FinalizeChannelEventPage;
var
  I: Integer;
  OfficePage: TAdvOfficePage;
  ChannelForm: TfrmChannelEvents;
begin
  for I := aoPagerEvent.AdvPageCount - 1 downto 0 do
  begin
    if (I > 0) then
    begin
      OfficePage := aoPagerEvent.AdvPages[I];
      if (OfficePage <> nil) then
      begin
        if (OfficePage.ControlCount > 0) then
        begin
          ChannelForm := TfrmChannelEvents(OfficePage.Controls[0]);
          if (ChannelForm <> nil) then
          begin
            FreeAndNil(ChannelForm);
          end;
        end;
        FreeAndNil(OfficePage);
      end;
    end;
  end;
end;

procedure TfrmDCS.InitializeDeviceList;
begin
  frmDeviceList := TfrmDeviceList.Create(pnlDeviceList, True, 0, 0, pnlDeviceList.ClientWidth, pnlDeviceList.ClientHeight);
  frmDeviceList.Parent := pnlDeviceList;
  frmDeviceList.Align := alClient;
  frmDeviceList.Show;
end;

procedure TfrmDCS.FinalizeDeviceList;
begin
  if (frmDeviceList <> nil) then
    FreeAndNil(frmDeviceList);
end;

procedure TfrmDCS.InitializeLogCommonGrid;
begin
  // Common log
  frmLogCommon := TfrmLogCommon.Create(aopCommonLog, True, 0, 0, aopCommonLog.ClientWidth, aopCommonLog.ClientHeight);
  frmLogCommon.Parent := aopCommonLog;
  frmLogCommon.Align := alClient;
  frmLogCommon.Show;
end;

procedure TfrmDCS.FinalizeLogCommonGrid;
var
  LogCommonForm: TfrmLogCommon;
begin
  if (aopCommonLog.ControlCount > 0) then
  begin
    LogCommonForm := TfrmLogCommon(aopCommonLog.Controls[0]);
    if (LogCommonForm <> nil) then
    begin
      FreeAndNil(LogCommonForm);
    end;
  end;
end;

procedure TfrmDCS.InitializeLogDeviceGrid;
var
  I: Integer;
  OfficePage: TAdvOfficePage;
  Device: PDevice;
  LogForm: TfrmLogDevice;

  LockList: TList;
begin
  with aoPagerLogDevice do
  begin
    for I := 0 to GV_DeviceList.Count - 1 do
    begin
      Device := GV_DeviceList[I];

      if (Device <> nil) then
      begin
        OfficePage := TAdvOfficePage.Create(Self);
        OfficePage.AdvOfficePager := aoPagerLogDevice;
        OfficePage.Caption := Device^.Name;
        OfficePage.Tag := Device^.Handle;

        LogForm := TfrmLogDevice.Create(OfficePage, Device, True, 0, 0, OfficePage.ClientWidth, OfficePage.ClientHeight);
        LogForm.Parent := OfficePage;
        LogForm.Align := alClient;
        LogForm.Show;

        LockList := GV_DeviceThreadList.LockList;
        try
          if (Device^.Handle >= 0) and (Device^.Handle < LockList.Count) then
            TDeviceThread(LockList[Device^.Handle]).LogForm := LogForm;
        finally
          GV_DeviceThreadList.UnLockList;
        end;
      end;
    end;

    aoPagerLogDevice.OnMouseWheel := aoPagerLogDeviceMouseWheel;
  end;

  if (aoPagerLogDevice.AdvPageCount > 0) then
    aoPagerLogDevice.ActivePageIndex := 0;
end;

procedure TfrmDCS.FinalizeLogDeviceGrid;
var
  I: Integer;
  OfficePage: TAdvOfficePage;
  LogForm: TfrmLogDevice;
begin
  for I := aoPagerLogDevice.AdvPageCount - 1 downto 0 do
  begin
    if (I > 0) then
    begin
      OfficePage := aoPagerLogDevice.AdvPages[I];
      if (OfficePage <> nil) then
      begin
        if (OfficePage.ControlCount > 0) then
        begin
          LogForm := TfrmLogDevice(OfficePage.Controls[0]);
          if (LogForm <> nil) then
          begin
            FreeAndNil(LogForm);
          end;
        end;
        FreeAndNil(OfficePage);
      end;
    end;
  end;
end;

procedure TfrmDCS.DisplayActivate;
begin
  if (HasMainControl) then
    lblActivate.Caption := 'Main'
  else
    lblActivate.Caption := 'Sub';

  GV_DCSCritSec.Enter;
  try
    if (GV_DCSMine <> nil) then
      lblDCSName.Caption := String(GV_DCSMine^.Name)
    else
      lblDCSName.Caption := '';
  finally
    GV_DCSCritSec.Leave;
  end;

  actFileMainChange.Enabled := (not HasMainControl);
end;

procedure TfrmDCS.TimerThreadEvent(Sender: TObject);
begin
  PostMessage(Handle, WM_UPDATE_CURRENT_TIME, 0, 0);
end;

procedure TfrmDCS.UDPSysInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
var
  ByteCount: Integer;
  CMD1, CMD2: Byte;
  R: Integer;
  SendBuffer: AnsiString;

  DeviceHandle: TDeviceHandle;

  IsAlive: Boolean;
  IsMain: Boolean;
  DeviceStatus: TDeviceStatus;

  OnAirEventID, CuedEventID: TEventID;
  StartTime: TEventTime;
  DurationTC: TTimecode;
  EventStatus: TEventStatus;
  EventOverall: TEventOverall;
//label UndefinedCommand;
//label ReParsing;
begin
//  FSysInCritSec.Enter;
  try
    if (ADataSize <= 0) then exit;

    FSysRecvBuffer := FSysRecvBuffer + AData;
    if Length(FSysRecvBuffer) < 1 then exit;

  //  ReParsing:
    case Ord(FSysRecvBuffer[1]) of
      $02:
      begin
        if (Length(FSysRecvBuffer) < 3) then exit;

        ByteCount := PAnsiCharToWord(@FSysRecvBuffer[2]);
        if (ByteCount > 0) and (Length(FSysRecvBuffer) = ByteCount + 4) then
        begin
          if CheckSum(FSysRecvBuffer) then
          begin
            CMD1 := Ord(FSysRecvBuffer[4]);
            CMD2 := Ord(FSysRecvBuffer[5]);

            FSysRecvData := System.Copy(FSysRecvBuffer, 6, ByteCount - 2);

            case CMD1 of
              $00: // System Control (0X00)
              begin
                case CMD2 of
                  $00: // Is Alive
                  begin
                    R := DCSIsAlive(IsAlive);
                    if (R = D_OK) then
                      SendBuffer := BoolToAnsiString(IsAlive);
                  end;
                  $01: // Is Main
                  begin
                    R := DCSIsMain(IsMain);
                    if (R = D_OK) then
                      SendBuffer := BoolToAnsiString(IsMain);
                  end;
  //              else
  //                Goto UndefinedCommand;
                end;
              end;
  //              else
  //                Goto UndefinedCommand;
  //          else
  //            Goto UndefinedCommand;
            end;

            if (R = D_OK) then
            begin
              case CMD1 of
                $00: // System Control (0X00)
                begin
                  case CMD2 of
                    $00,
                    $01: TransmitSysResponse(ABindingIP, FUDPSysOut.Port, CMD1, CMD2, SendBuffer, Length(SendBuffer));
  //                else
  //                  Goto UndefinedCommand;
                  end;
                end;
  //            else
  //              Goto UndefinedCommand;
              end;
            end
            else
            begin
              // Sending error code
  //            SendBuffer := AnsiChar(D_ERR) + IntToAnsiString(R);
  //            FUDPOut.Send(ABindingIP, FUDPOut.Port, SendBuffer);
              TransmitSysError(ABindingIP, FUDPSysOut.Port, R);
            end;
          end
          else
          begin
  //          FUDPOut.Send(ABindingIP, AnsiChar(D_NAK) + IntToAnsiString(E_NAK_CHECKSUM));
            TransmitSysNak(ABindingIP, FUDPSysOut.Port, E_NAK_CHECKSUM);
          end;

  {        if (Length(FRecvBuffer) > ByteCount + 3) then
          begin
            FRecvBuffer := Copy(FRecvBuffer, ByteCount + 4, Length(FRecvBuffer));
  //          Goto ReParsing;
          end
          else }
            FSysRecvBuffer := '';
        end
        else if (ByteCount <= 0) or (Length(FSysRecvBuffer) > ByteCount + 4) then
        begin
          FSysRecvBuffer := '';
        end;
      end;
      else
      begin
    //    UndefinedCommand:
    //    FUDPOut.Send(ABindingIP, AnsiChar(D_ERR) + IntToAnsiString(E_UNDEFIND_COMMAND));
        TransmitSysError(ABindingIP, FUDPSysOut.Port, E_UNDEFIND_COMMAND);
        FSysRecvBuffer := '';
      end;
    end;
  finally
//    FSysInCritSec.Leave;
  end;
end;

procedure TfrmDCS.UDPInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
var
  ByteCount: Integer;
  CMD1, CMD2: Byte;
  R: Integer;
  SendBuffer: AnsiString;

  DeviceHandle: TDeviceHandle;

  IsAlive: Boolean;
  IsMain: Boolean;
  DeviceStatus: TDeviceStatus;

  OnAirEventID, CuedEventID: TEventID;
  StartTime: TEventTime;
  DurationTC: TTimecode;
  EventStatus: TEventStatus;
  EventOverall: TEventOverall;
//label UndefinedCommand;
//label ReParsing;
begin
  FInCritSec.Enter;
  try
    if (ADataSize <= 0) then exit;

    FRecvBuffer := FRecvBuffer + AData;
    if Length(FRecvBuffer) < 1 then exit;

  //  ReParsing:
    case Ord(FRecvBuffer[1]) of
      $02:
      begin
        if (Length(FRecvBuffer) < 3) then exit;

        ByteCount := PAnsiCharToWord(@FRecvBuffer[2]);
        if (ByteCount > 0) and (Length(FRecvBuffer) = ByteCount + 4) then
        begin
          if CheckSum(FRecvBuffer) then
          begin
            CMD1 := Ord(FRecvBuffer[4]);
            CMD2 := Ord(FRecvBuffer[5]);

            FRecvData := System.Copy(FRecvBuffer, 6, ByteCount - 2);

            case CMD1 of
              $00: // System Control (0X00)
              begin
                case CMD2 of
                  $00: // Is Alive
                  begin
                    R := DCSIsAlive(IsAlive);
                    if (R = D_OK) then
                      SendBuffer := BoolToAnsiString(IsAlive);
                  end;
                  $01: // Is Main
                  begin
                    R := DCSIsMain(IsMain);
                    if (R = D_OK) then
                      SendBuffer := BoolToAnsiString(IsMain);
                  end;
  //              else
  //                Goto UndefinedCommand;
                end;
              end;
              $10: // 0X10 Device Control
              begin
                case CMD2 of
                  $00: // Device Open
                  begin
                    R := DCSOpen(ABindingIP, FRecvData, DeviceHandle);
                    if (R = D_OK) then
                      SendBuffer := IntToAnsiString(DeviceHandle);
                  end;
                  $01: // Device Close
                  begin
                    R := DCSClose(FRecvData);
  //                    if (R = D_OK) then
  //                      SendBuffer := AnsiChar(D_ACK);
                  end;
                  $02: // Device Reset
                  begin
                    R := DCSReset(ABindingIP, FRecvData);
                  end;
                  $03: // Device Set ControlBy
                  begin
                    R := DCSSetControlBy(ABindingIP, FRecvData);
                  end;
                  $04: // Device Set Control Channel
                  begin
                    R := DCSSetControlChannel(ABindingIP, FRecvData);
                  end;
  //              else
  //                Goto UndefinedCommand;
                end;
              end;
              $20, $30: // Command
              begin
//                if (HasMainControl) then
                begin
                  R := DCSCommand(ABindingIP, CMD1, CMD2, FRecvData, SendBuffer);
                end;
              end;
              $40: // 0X40 Sense Queries
              begin
                case CMD2 of
                  $00: // Get Device Status
                  begin
                    R := DCSGetDeviceStatus(FRecvData, DeviceStatus);
                    if (R = D_OK) then
                    begin
                      SetLength(SendBuffer, SizeOf(TDeviceStatus));
                      Move(DeviceStatus, SendBuffer[1], SizeOf(TDeviceStatus));
                    end;
                  end
                  else
                  begin
//                    if (HasMainControl) then
                    begin
                      R := DCSCommand(ABindingIP, CMD1, CMD2, FRecvData, SendBuffer);
                    end;
                  end;
                end;
              end;
              $50: // 0X50 Event Control
              begin
                case CMD2 of
                  $00: // Input Event
                  begin
                    R := DCSInputEvent(ABindingIP, FRecvData);
  //                  if R = D_OK then SendBuffer := AnsiChar($04);
                  end;
                  $01: // Delete Event
                  begin
                    R := DCSDeleteEvent(ABindingIP, FRecvData);
                  end;
                  $02: // Clear Event
                  begin
                    R := DCSClearEvent(ABindingIP, FRecvData);
                  end;
                  $10: // Take Event
                  begin
                    R := DCSTakeEvent(ABindingIP, FRecvData);
                  end;
                  $11: // Hold Event
                  begin
                    R := DCSHoldEvent(ABindingIP, FRecvData);
                  end;
                  $12: // OnAir Event Change Duration
                  begin
                    R := DCSChangeEventDuration(ABindingIP, FRecvData);
                  end;
                  $20: // Get OnAir EventID
                  begin
                    R := DCSGetOnAirEventID(ABindingIP, FRecvData, OnAirEventID, CuedEventID);
                    if (R = D_OK) then
                    begin
                      SetLength(SendBuffer, SizeOf(TEventID) * 2);
                      Move(OnAirEventID, SendBuffer[1], SizeOf(TEventID));
                      Move(CuedEventID, SendBuffer[SizeOf(TEventID) + 1], SizeOf(TEventID));
                    end;
                  end;
                  $21: // Get Event Info
                  begin
                    R := DCSGetEventInfo(ABindingIP, FRecvData, StartTime, DurationTC);
                    if (R = D_OK) then
                    begin
                      SendBuffer := DWordToAnsiString(StartTime.T) + DoubleToAnsiString(StartTime.D) +
                                    DWordToAnsiString(DurationTC);
                    end;
                  end;
                  $22: // Get Event Status
                  begin
                    R := DCSGetEventStatus(ABindingIP, FRecvData, EventStatus);
                    if (R = D_OK) then
                    begin
                      SetLength(SendBuffer, SizeOf(TEventStatus));
                      Move(EventStatus, SendBuffer[1], SizeOf(TEventStatus));
                    end;
                  end;
                  $24: // Get Event Overall
                  begin
                    R := DCSGetEventOverall(ABindingIP, FRecvData, EventOverall);
                    if (R = D_OK) then
                    begin
                      SetLength(SendBuffer, SizeOf(TEventOverall));
                      Move(EventOverall, SendBuffer[1], SizeOf(TEventOverall));
                    end;
                  end;
  //              else
  //                Goto UndefinedCommand;
                end;
              end;
  //          else
  //            Goto UndefinedCommand;
            end;

            if (R = D_OK) then
            begin
  //            TransmitResponse(ABindingIP, FUDPOut.Port, CMD1, CMD2, SendBuffer, Length(SendBuffer));
              case CMD1 of
                $00: // System Control (0X00)
                begin
                  case CMD2 of
                    $00,
                    $01: TransmitResponse(ABindingIP, FUDPOut.Port, CMD1, CMD2, SendBuffer, Length(SendBuffer));
  //                else
  //                  Goto UndefinedCommand;
                  end;
                end;
                $10: // Device Control (0X10)
                begin
                  case CMD2 of
                    $00: TransmitResponse(ABindingIP, FUDPOut.Port, CMD1, CMD2, SendBuffer, Length(SendBuffer));
                    $01,
                    $02,
                    $03,
                    $04: TransmitAck(ABindingIP, FUDPOut.Port);
  //                else
  //                  Goto UndefinedCommand;
                  end;
                end;
                $20, $30: // Command
                begin
//                  if (HasMainControl) then
                  begin
                    TransmitResponse(ABindingIP, FUDPOut.Port, CMD1, CMD2, SendBuffer, Length(SendBuffer));
                  end;
                end;
                $40: // Sense Queries (0X40)
                begin
                  case CMD2 of
                    $00: TransmitResponse(ABindingIP, FUDPOut.Port, CMD1, CMD2, SendBuffer, Length(SendBuffer));
                    else
                    begin
//                      if (HasMainControl) then
                      begin
                        TransmitResponse(ABindingIP, FUDPOut.Port, CMD1, CMD2, SendBuffer, Length(SendBuffer));
                      end;
                    end;
                  end;
                end;
                $50: // Event Control (0X50)
                begin
                  case CMD2 of
                    $00,
                    $01,
                    $02,
                    $10,
                    $12,
                    $11: TransmitAck(ABindingIP, FUDPOut.Port);
                    $20,
                    $21,
                    $22,
                    $24: TransmitResponse(ABindingIP, FUDPOut.Port, CMD1, CMD2, SendBuffer, Length(SendBuffer));
  //                else
  //                  Goto UndefinedCommand;
                  end;
                end;
  //            else
  //              Goto UndefinedCommand;
              end;
            end
            else
            begin
              // Sending error code
  //            SendBuffer := AnsiChar(D_ERR) + IntToAnsiString(R);
  //            FUDPOut.Send(ABindingIP, FUDPOut.Port, SendBuffer);
              TransmitError(ABindingIP, FUDPOut.Port, R);
            end;
          end
          else
          begin
  //          FUDPOut.Send(ABindingIP, AnsiChar(D_NAK) + IntToAnsiString(E_NAK_CHECKSUM));
            TransmitNak(ABindingIP, FUDPOut.Port, E_NAK_CHECKSUM);
          end;

  {        if (Length(FRecvBuffer) > ByteCount + 3) then
          begin
            FRecvBuffer := Copy(FRecvBuffer, ByteCount + 4, Length(FRecvBuffer));
  //          Goto ReParsing;
          end
          else }
            FRecvBuffer := '';
        end
        else if (ByteCount <= 0) or (Length(FRecvBuffer) > ByteCount + 4) then
        begin
          FRecvBuffer := '';
        end;
      end;
      else
      begin
    //    UndefinedCommand:
    //    FUDPOut.Send(ABindingIP, AnsiChar(D_ERR) + IntToAnsiString(E_UNDEFIND_COMMAND));
        TransmitError(ABindingIP, FUDPOut.Port, E_UNDEFIND_COMMAND);
        FRecvBuffer := '';
      end;
    end;
  finally
    FInCritSec.Leave;
  end;
end;

procedure TfrmDCS.UDPEventStatusNotifyRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
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
  if (HasMainControl) then exit;

  FEventStatusCritSec.Enter;
  try
    if (ADataSize <= 0) then exit;
    FEventStatusRecvBuffer := FEventStatusRecvBuffer + AData;

    if (Length(FEventStatusRecvBuffer) < 1) then exit;

    case Ord(FEventStatusRecvBuffer[1]) of
      $02:
      begin
        if (Length(FEventStatusRecvBuffer) < 3) then exit;

        ByteCount := PAnsiCharToWord(@FEventStatusRecvBuffer[2]);
        if (ByteCount > 0) and (Length(FEventStatusRecvBuffer) = ByteCount + 4) then
        begin
          if (CheckSum(FEventStatusRecvBuffer)) then
          begin
            CMD1 := Ord(FEventStatusRecvBuffer[4]);
            CMD2 := Ord(FEventStatusRecvBuffer[5]);
            FEventStatusRecvData := System.Copy(FEventStatusRecvBuffer, 6, ByteCount - 2);

            case CMD1 of
              $60:
                case CMD2 of
                  $80:
                    begin
                      DCSSetDeviceStatusNotify(FEventStatusRecvData);
//                      DeviceHandle := PAnsiCharToInt(@FEventStatusRecvData[1]);
//                      FEventStatusRecvData := Copy(FEventStatusRecvData, 5, Length(FEventStatusRecvData));

//                      Move(FEventStatusRecvData[1], DeviceStatus, SizeOf(TDeviceStatus));
//                      if (Assigned(@DeviceStatusNotifyProc)) then
//                        DeviceStatusNotifyProc(PChar(String(ABindingIP)), DeviceHandle, DeviceStatus);
                    end;
                  $81:
                    begin
                      DCSSetEventStatusNotify(FEventStatusRecvData);
//                      Move(FEventStatusRecvData[1], EventID, SizeOf(TEventID));
//                      Move(FEventStatusRecvData[SizeOf(TEventID) + 1], EventStatus, Sizeof(TEventStatus));
//                      if (Assigned(@EventStatusNotifyProc)) then
//                        EventStatusNotifyProc(PChar(String(ABindingIP)), EventID, EventStatus);
                    end;
                  $82:
                    begin
                      DeviceHandle := PAnsiCharToWord(@FEventStatusRecvData[1]);
                      FEventStatusRecvData := Copy(FEventStatusRecvData, 5, Length(FEventStatusRecvData));

                      Move(FEventStatusRecvData[1], EventOverall, SizeOf(TEventOverall));
//                      if (Assigned(@EventOverallNotifyProc)) then
//                        EventOverallNotifyProc(PChar(String(ABindingIP)), DeviceHandle, EventOverall);
                    end;
                  $90:
                    begin
                      DCSSetEventCurrNotify(FEventStatusRecvData);
                    end;
                  $91:
                    begin
                      DCSSetEventNextNotify(FEventStatusRecvData);
                    end;
                  $92:
                    begin
                      DCSSetEventFiniNotify(FEventStatusRecvData);
                    end;
                  $A0:
                    begin
                      DCSRemoveEventNotify(FEventStatusRecvData);
                    end;
                end;
            end;
          end;

          FEventStatusRecvBuffer := '';
        end
        else if ((ByteCount <= 0) or (Length(FEventStatusRecvBuffer) > ByteCount + 4)) then
        begin
          FEventStatusRecvBuffer := '';
        end;
      end;
      else
      begin
        FEventStatusRecvBuffer := '';
      end;
    end;
  finally
    FEventStatusCritSec.Leave;
  end;
end;

// 0X00 System Control
function TfrmDCS.DCSIsAlive(var AIsAlive: Boolean): Integer;
begin
  Result := D_FALSE;

  AIsAlive := True;

  Result := D_OK;

//  Assert(False, GetLogCommonStr(lsNormal, Format('TfrmDCS.DCSIsAlive is alive?, alive = %s', [BoolToStr(AIsAlive, True)])));
end;

function TfrmDCS.DCSIsMain(var AIsMain: Boolean): Integer;
begin
  Result := D_FALSE;

  GV_DCSCritSec.Enter;
  try
    if (GV_DCSMine <> nil) then
      AIsMain := GV_DCSMine^.Main
    else
      AIsMain := False;
  finally
    GV_DCSCritSec.Leave;
  end;

  Result := D_OK;

//  Assert(False, GetLogCommonStr(lsNormal, Format('TfrmDCS.DCSIsMain is main?, main = %s', [BoolToStr(AIsMain, True)])));
end;

function TfrmDCS.DCSSetMain(ABuffer: AnsiString): Integer;
var
  DCSID: Word;
  DCS: PDCS;
begin
  Result := D_FALSE;

  DCSID := PAnsiCharToWord(@ABuffer[1]);

  DCS := GetDCSByID(DCSID);
  if (DCS <> nil) then
  begin
    GV_DCSCritSec.Enter;
    try
      GV_DCSMain := DCS;
      GV_DCSMain^.Main := True;

      GV_DCSMine^.Main := False;
    finally
      GV_DCSCritSec.Leave;
    end;

    DeviceClose;

    SaveDCSConfig;

    // Device re active
    PostMessage(Handle, WM_UPDATE_ACTIVATE, 0, 0);

    Result := D_OK;

//    Assert(False, GetLogCommonStr(lsNormal, Format('TfrmDCS.DCSSetMain Main DCS changed, name = %s, id = %d',
//                                                   [String(DCS^.Name), DCS^.ID])));
  end;
  FCrossCheckThread.FNumCrossCheck := 0;
end;

function TfrmDCS.DCSGetEventCount(ABuffer: AnsiString; var AEventCount: Integer): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    AEventCount := D.EventQueue.Count;
    Result := D_OK;
  end;
end;

function TfrmDCS.DCSGetEvent(ABuffer: AnsiString; var AEvent: TEvent): Integer;         
var
  DeviceHandle: TDeviceHandle;
  Num: Integer;
  D: TDeviceThread;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  Num          := PAnsiCharToInt(@ABuffer[5]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) and (Num < D.EventQueue.Count) then
  begin
    Move(D.EventQueue[Num]^, AEvent, SizeOf(TEvent));
//    FillChar(AEvent, SizeOf(TEvent), #0);
    Result := D_OK;
  end;
end;

function TfrmDCS.DCSGetEventCurrNext(ABuffer: AnsiString; var ACurrEventID, ANextEventID: TEventID): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
begin
  Result := D_FALSE;

  FillChar(ACurrEventID, SizeOf(TEventID), #0);
  FillChar(ANextEventID, SizeOf(TEventID), #0);

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    if (D.EventCurr <> nil) then
      ACurrEventID := D.EventCurr^.EventID;

    if (D.EventNext <> nil) then
      ANextEventID := D.EventNext^.EventID;

    Result := D_OK;
  end;
end;

// 0X10 Device Control
function TfrmDCS.DCSOpen(AHostIP, ABuffer: AnsiString; var ADeviceHandle: TDeviceHandle): Integer;
var
  D: TDeviceThread;
begin
  Result := E_INVALID_DEVICE_NAME;

  ADeviceHandle := GetDeviceHandleByName(ABuffer);
  if (ADeviceHandle >= 0) then
  begin
    D := GetDeviceThreadByHandle(ADeviceHandle);
    if (D <> nil) then
    begin
//      D.ControlBy := AHostIP;
      Result := D_OK;
    end;
  end;
end;

function TfrmDCS.DCSClose(ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Result := D_OK;
  end;
end;

function TfrmDCS.DCSReset(AHostIP, ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  ChannelID: Word;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    ChannelID := PAnsiCharToWord(@ABuffer[5]);
    Result := D.DeviceReset(AHostIP, ChannelID);
  end;
end;

function TfrmDCS.DCSSetControlBy(AHostIP, ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  ChannelID: Word;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    D.ControlBy := AHostIP;
    Result := D_OK;
  end;
end;

function TfrmDCS.DCSSetControlChannel(AHostIP, ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  ChannelID: Word;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    D.ControlChannel := PAnsiCharToWord(@ABuffer[5]);
    Result := D_OK;
  end;
end;

// 0X20, 30, 40 Command
function TfrmDCS.DCSCommand(AHostIP: AnsiString; ACMD1, ACMD2: Byte; ACMDBuffer: AnsiString; var AResultBuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
begin
  Result := D_FALSE;

  AResultBuffer := '';

  DeviceHandle := PAnsiCharToInt(@ACMDBuffer[1]);
  if (DeviceHandle < 0) then
  begin
    Result := E_INVALID_DEVICE_NAME;
    exit;
  end;

  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    if (D.Device <> nil) then
    begin
      ACMDBuffer := Copy(ACMDBuffer, SizeOf(Integer) + 1, Length(ACMDBuffer));
      Result := D.DeviceCommand(AHostIP, ACMD1, ACMD2, ACMDBuffer, AResultBuffer);
    end
    else
      Result := E_NOT_OPENED;
  end
  else
    Result := E_INVALID_DEVICE;
end;

// 0X40 Sense Queries
function TfrmDCS.DCSGetDeviceStatus(ABuffer: AnsiString; var AStatus: TDeviceStatus): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
begin
  Result := D_FALSE;

  FillChar(AStatus, SizeOf(TDeviceStatus), #0);

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    if (D.Device <> nil) then
    begin
      AStatus := D.Device.Status;
      Result := D_OK;
    end;
  end;
end;

// 0X50 Event Control
function TfrmDCS.DCSInputEvent(AHostIP, ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  Event: TEvent;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Move(ABuffer[5], Event, SizeOf(TEvent));
    Result := D.InputEvent(AHostIP, Event);
  end;
end;

function TfrmDCS.DCSDeleteEvent(AHostIP, ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  EventID: TEventID;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Move(ABuffer[5], EventID, SizeOf(TEventID));
    Result := D.DeleteEvent(AHostIP, EventID);
  end;
end;

function TfrmDCS.DCSClearEvent(AHostIP, ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  ChannelID: Word;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    ChannelID := PAnsiCharToWord(@ABuffer[5]);
    Result := D.ClearEvent(AHostIP, ChannelID);
  end;
end;

function TfrmDCS.DCSTakeEvent(AHostIP, ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  EventID: TEventID;
  StartTime: TEventTime;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Move(ABuffer[5], EventID, SizeOf(TEventID));
    StartTime.T := PAnsiCharToDWord(@ABuffer[5 + SizeOf(TEventID)]);
    StartTime.D := PAnsiCharToDouble(@ABuffer[5 + SizeOf(TEventID) + SizeOf(TTimecode)]);
    Result := D.TakeEvent(AHostIP, EventID, StartTime);
  end;
end;

function TfrmDCS.DCSHoldEvent(AHostIP, ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  EventID: TEventID;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Move(ABuffer[5], EventID, SizeOf(TEventID));
    Result := D.HoldEvent(AHostIP, EventID);
  end;
end;

function TfrmDCS.DCSChangeEventDuration(AHostIP, ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  EventID: TEventID;
  DurTime: TTimecode;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Move(ABuffer[5], EventID, SizeOf(TEventID));
    DurTime := PAnsiCharToDWord(@ABuffer[5 + SizeOf(TEventID)]);
    Result := D.ChangeDurationEvent(AHostIP, EventID, DurTime);
  end;
end;

function TfrmDCS.DCSGetOnAirEventID(AHostIP, ABuffer: AnsiString; var AOnAirEventID, ANextEventID: TEventID): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
begin
  Result := D_FALSE;

  FillChar(AOnAirEventID, SizeOf(TEventID), #0);
  FillChar(ANextEventID, SizeOf(TEventID), #0);

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Result := D.GetOnAirEventID(AHostIP, AOnAirEventID, ANextEventID);
  end;
end;

function TfrmDCS.DCSGetEventInfo(AHostIP, ABuffer: AnsiString; var AStartTime: TEventTime; var ADurationTC: TTimecode): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  EventID: TEventID;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Move(ABuffer[5], EventID, SizeOf(TEventID));
    Result := D.GetEventInfo(AHostIP, EventID, AStartTime, ADurationTC);
  end;
end;

function TfrmDCS.DCSGetEventStatus(AHostIP, ABuffer: AnsiString; var AEventStatus: TEventStatus): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  EventID: TEventID;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Move(ABuffer[5], EventID, SizeOf(TEventID));
    Result := D.GetEventStatus(AHostIP, EventID, AEventStatus);
  end;
end;

function TfrmDCS.DCSGetEventOverall(AHostIP, ABuffer: AnsiString; var AEventOverall: TEventOverall): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Result := D.GetEventOverall(AHostIP, AEventOverall);
  end;
end;

function TfrmDCS.DCSSetDeviceStatusNotify(ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  DeviceStatus: TDeviceStatus;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Move(ABuffer[5], DeviceStatus, SizeOf(TDeviceStatus));

    Result := D.SetDeviceStatusNotify(DeviceStatus);
  end;
end;

function TfrmDCS.DCSSetEventStatusNotify(ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  EventID: TEventID;
  EventStatus: TEventStatus;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Move(ABuffer[5], EventID, SizeOf(TEventID));
    Move(ABuffer[SizeOf(TEventID) + 5], EventStatus, Sizeof(TEventStatus));

    Result := D.SetEventStatusNotify(EventID, EventStatus);
  end;
end;

function TfrmDCS.DCSSetEventCurrNotify(ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  EventID: TEventID;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Move(ABuffer[5], EventID, SizeOf(TEventID));

    Result := D.SetEventCurrNotify(EventID);
  end;
end;

function TfrmDCS.DCSSetEventNextNotify(ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  EventID: TEventID;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Move(ABuffer[5], EventID, SizeOf(TEventID));

    Result := D.SetEventNextNotify(EventID);
  end;
end;

function TfrmDCS.DCSSetEventFiniNotify(ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  EventID: TEventID;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Move(ABuffer[5], EventID, SizeOf(TEventID));

    Result := D.SetEventFiniNotify(EventID);
  end;
end;

function TfrmDCS.DCSRemoveEventNotify(ABuffer: AnsiString): Integer;
var
  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  EventID: TEventID;
begin
  Result := D_FALSE;

  DeviceHandle := PAnsiCharToInt(@ABuffer[1]);
  D := GetDeviceThreadByHandle(DeviceHandle);
  if (D <> nil) then
  begin
    Move(ABuffer[5], EventID, SizeOf(TEventID));

    Result := D.RemoveEventNotify(EventID);
  end;
end;

procedure TfrmDCS.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  CanClose := FIsTerminate;
  if not FIsTerminate then
  begin
    Hide;
    ShowWindow(Application.Handle, SW_HIDE);
  end;
end;

procedure TfrmDCS.FormCreate(Sender: TObject);
begin
  inherited;

//  ShowMessage(IntToStr(SizeOf(TPlayerEvent)));
  frmStartSplash := TfrmStartSplash.Create(Self);
  frmStartSplash.Show;
//  Application.ProcessMessages;
//  try
    Initialize;
//  finally
//    frmStartSplash.Close;
//    FreeAndNil(frmStartSplash);
//  end;
end;

procedure TfrmDCS.FormDestroy(Sender: TObject);
begin
  inherited;
  Finalize;
end;

procedure TfrmDCS.FormShow(Sender: TObject);
var
  TimeCaps: TTimeCaps;
begin
  inherited;

//  Initialize;

  // 정상적으로 초기화후 크로스 체킹 시작
  if (FCrossCheckThread <> nil) and (FCrossCheckThread.Suspended) then
  begin
    FCrossCheckThread.DoMainCheck;
    FCrossCheckThread.Start;
  end;

  DisplayStartCheck('Device opening...', 80);

  GV_DCSCritSec.Enter;
  try
    if (GV_DCSMain = GV_DCSMine) then
    begin
  //    ShowMessage(Format('%s, %s', [GV_DCSMain^.Name, GV_DCSMine^.Name]));
      DeviceOpen;
    end;
  finally
    GV_DCSCritSec.Leave;
  end;

  FUDPSysIn.AsyncMode := True;
  FUDPSysIn.OnUDPRead := UDPSysInRead;
  FUDPSysIn.Start;
  while not FUDPSysIn.Started do
    Sleep(30);

  FUDPSysOut.AsyncMode := True;
  FUDPSysOut.Start;
  while not FUDPSysOut.Started do
    Sleep(30);

  timeGetDevCaps(@TimeCaps, SizeOf(TTimeCaps));

  if (FTimerID = 0) then
    FTimerID := timeSetEvent(1, TimeCaps.wPeriodMin, @TimerCallBack, 0, TIME_PERIODIC);

  if (FDeviceTimerID = 0) then
    FDeviceTimerID := timeSetEvent(1, TimeCaps.wPeriodMin, @DeviceTimerCallBack, 0, TIME_PERIODIC);

  DeviceStart;

  DisplayStartCheck('System check completed.', 100);

  if (frmStartSplash <> nil) then
  begin
    frmStartSplash.Close;
    FreeAndNil(frmStartSplash);
  end;
end;

procedure TfrmDCS.acgDeviceListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  (Sender as TAdvColumnGrid).SetFocus;
end;

procedure TfrmDCS.acgEventListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  (Sender as TAdvColumnGrid).SetFocus;
end;

procedure TfrmDCS.actDeviceResetAllExecute(Sender: TObject);
begin
  inherited;
  frmDeviceList.DeviceInitAll;
end;

procedure TfrmDCS.actDeviceResetExecute(Sender: TObject);
begin
  inherited;
  frmDeviceList.SelectDeviceInit;
end;

procedure TfrmDCS.actFileMainChangeExecute(Sender: TObject);
var
  I: Integer;
  DCS: PDCS;
begin
  inherited;

  if (HasMainControl) then exit;

  FCrossCheckThread.ExecuteMainChange;
end;

procedure TfrmDCS.actFileExitExecute(Sender: TObject);
begin
  inherited;
  FIsTerminate := True;
  Close;
end;

procedure TfrmDCS.actFileShowExecute(Sender: TObject);
begin
  inherited;
  if (IsIconic(Application.Handle)) or (WindowState = wsMinimized) then
    ShowWindow(Application.Handle, SW_RESTORE);
  SetForeGroundWindow(Application.Handle);
  Show;
end;

procedure TfrmDCS.aoPagerLogDeviceMouseWheel(Sender: TObject;
      Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
var
  P: TPoint;
  Pos: Integer;
begin
//  ShowMessage(IntToStr(WheelDelta));
  with aoPagerLogDevice do
  begin
    P := ScreenToClient(MousePos);
    if (PtInRect(TabsArea, P)) then
    begin
      Pos := TabScroller.Position;

      Dec(Pos, (WheelDelta div TabSettings.Height));

      if (Pos < TabScroller.Min) then Pos := TabScroller.Min
      else if (Pos > TabScroller.Max) then Pos := TabScroller.Max;

      TabScroller.Position := Pos;

      Handled := True;
    end;
  end;
end;

{ TCrossCheckThread }

constructor TCrossCheckThread.Create(ADCSForm: TfrmDCS);
begin
  FDCSForm := ADCSForm;

  FCommandCritSec := TCriticalSection.Create;
  FInCritSec := TCriticalSection.Create;

  FSGCommandCritSec := TCriticalSection.Create;
  FSGInCritSec := TCriticalSection.Create;

  with GV_ConfigGeneral do
  begin
    FUDPIn  := TUDPIn.Create(CrossCheckPort);
    FUDPIn.LogEnabled     := UDPLogEnable;
    FUDPIn.LogPath        := UDPLogPath;
    FUDPIn.LogExt         := Format('%d_%s', [FUDPIn.Port, UDPLogExt]);
  end;

  FUDPIn.OnUDPRead := UDPInRead;
  FUDPIn.Start;
  while not FUDPIn.Started do
    Sleep(30);

  FIsCommand := False;
  FCMD1 := $00;
  FCMD2 := $00;

  FSyncMsgEvent := CreateEvent(nil, True, False, nil);

  FSGCommand := '';

  FSGStrConnect := #$FF'?'#$FF'?'#$FF'?'#$FF'?'#$D#$D#$A'SerialGate login: ';
  FSGStrLogin   := '';
  FSGStrPrompt := '# ';

  FSGSyncMsgEvent := CreateEvent(nil, True, False, nil);

  FEventMainChange := CreateEvent(nil, True, False, nil);
  FEventClose := CreateEvent(nil, True, False, nil);

  FNumCrossCheck := 0;

  FreeOnTerminate := False;

  inherited Create(True);
end;

destructor TCrossCheckThread.Destroy;
begin
  CloseHandle(FEventMainChange);
  CloseHandle(FEventClose);

  CloseHandle(FSyncMsgEvent);

  CloseHandle(FSGSyncMsgEvent);

  FUDPIn.Close;
  FUDPIn.Terminate;
  FUDPIn.WaitFor;
  FreeAndNil(FUDPIn);

  FreeAndNil(FCommandCritSec);

  FreeAndNil(FInCritSec);

  FreeAndNil(FSGCommandCritSec);

  FreeAndNil(FSGInCritSec);

  inherited Destroy;
end;

procedure TCrossCheckThread.Terminate;
begin
  inherited Terminate;

  SetEvent(FEventClose);
end;

procedure TCrossCheckThread.ExecuteMainChange;
begin
  SetEvent(FEventMainChange);
end;

procedure TCrossCheckThread.UDPInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
var
  ByteCount: Integer;
  CMD1, CMD2: Byte;
  Device: TDeviceHandle;

  R: Integer;
  IsAlive: Boolean;
  IsMain: Boolean;
  EventCount: Integer;
  Event: TEvent;
  CurrEventID, NextEventID: TEventID;
  SendBuffer: AnsiString;
begin
  FInCritSec.Enter;
  try
    if (ADataSize <= 0) then exit;
    FRecvBuffer := FRecvBuffer + AData;

    if (Length(FRecvBuffer) < 1) then exit;

  //  if (HasMainControl) then
    if (not FIsCommand) then
    begin
      case Ord(FRecvBuffer[1]) of
        $02:
        begin
          if (Length(FRecvBuffer) < 3) then exit;

          ByteCount := PAnsiCharToWord(@FRecvBuffer[2]);
          if (ByteCount > 0) and (Length(FRecvBuffer) >= ByteCount + 4) then
          begin
            if (CheckSum(FRecvBuffer)) then
            begin
              CMD1 := Ord(FRecvBuffer[4]);
              CMD2 := Ord(FRecvBuffer[5]);

              FRecvData := System.Copy(FRecvBuffer, 6, ByteCount - 2);

              case CMD1 of
                $00: // System Control (0X00)
                begin
                  case CMD2 of
                    $00: // Is Alive
                    begin
                      R := FDCSForm.DCSIsAlive(IsAlive);
//                      Assert(False, GetLogCommonStr(lsNormal, Format('TCrossCheckThread.UDPInRead DCSIsAlive, alive = %s', [BoolToStr(IsAlive, True)])));
                      if (R = D_OK) then
                        SendBuffer := BoolToAnsiString(IsAlive);
                    end;
                    $01: // Is Main
                    begin
                      R := FDCSForm.DCSIsMain(IsMain);
//                      Assert(False, GetLogCommonStr(lsNormal, Format('TCrossCheckThread.UDPInRead DCSIsMain, main = %s', [BoolToStr(IsMain, True)])));
                      if (R = D_OK) then
                        SendBuffer := BoolToAnsiString(IsMain);
                    end;
                    $10: // Set Main
                    begin
                      R := FDCSForm.DCSSetMain(FRecvData);
                    end;
                    $20: // Get Device Event Count
                    begin
                      R := FDCSForm.DCSGetEventCount(FRecvData, EventCount);
                      if (R = D_OK) then
                        SendBuffer := IntToAnsiString(EventCount);
                    end;
                    $21: // Get Device Event
                    begin
                      R := FDCSForm.DCSGetEvent(FRecvData, Event);
                      if (R = D_OK) then
                      begin
                        SetLength(SendBuffer, SizeOf(TEvent));
                        Move(Event, SendBuffer[1], SizeOf(TEvent));
                      end;
                    end;
                    $22: // Get Device Curr & Next EventID
                    begin
                      R := FDCSForm.DCSGetEventCurrNext(FRecvData, CurrEventID, NextEventID);
                      if (R = D_OK) then
                      begin
                        SetLength(SendBuffer, SizeOf(TEventID) * 2);
                        Move(CurrEventID, SendBuffer[1], SizeOf(TEventID));
                        Move(NextEventID, SendBuffer[SizeOf(TEventID) + 1], SizeOf(TEventID));
                      end;
                    end;
                  end;
                end;
              end;

              if (R = D_OK) then
              begin
                case CMD1 of
                  $00: // System Control (0X00)
                  begin
                    case CMD2 of
                      $00,
                      $01: TransmitResponse(ABindingIP, FUDPIn.Port, CMD1, CMD2, SendBuffer, Length(SendBuffer));
                      $10: TransmitAck(ABindingIP, FUDPIn.Port);
                      $20,
                      $21,
                      $22: TransmitResponse(ABindingIP, FUDPIn.Port, CMD1, CMD2, SendBuffer, Length(SendBuffer));
                      $30,
                      $31: TransmitAck(ABindingIP, FUDPIn.Port);
                    end;
                  end;
                end;
              end
              else
              begin
                // Sending error code
    //            SendBuffer := AnsiChar(D_ERR) + IntToAnsiString(R);
    //            FUDPOut.Send(ABindingIP, FUDPOut.Port, SendBuffer);
                TransmitError(ABindingIP, FUDPIn.Port, R);
              end;
            end
            else
            begin
    //          FUDPOut.Send(ABindingIP, AnsiChar(D_NAK) + IntToAnsiString(E_NAK_CHECKSUM));
              TransmitNak(ABindingIP, FUDPIn.Port, E_NAK_CHECKSUM);
            end;
          end;

          if (Length(FRecvBuffer) > ByteCount + 4) then
            FRecvBuffer := Copy(FRecvBuffer, ByteCount + 5, Length(FRecvBuffer))
          else
            FRecvBuffer := '';
        end;
        $04: // ACK
        begin
          FRecvBuffer := '';
        end;
      else
  //      FUDPOut.Send(ABindingIP, AnsiChar(D_ERR) + IntToAnsiString(E_UNDEFIND_COMMAND));
        TransmitError(ABindingIP, FUDPIn.Port, E_UNDEFIND_COMMAND);
        FRecvBuffer := '';
      end;
    end
    else
    begin
      case Ord(FRecvBuffer[1]) of
        $02:
        begin
          if (Length(FRecvBuffer) < 2) then exit;

          ByteCount := PAnsiCharToWord(@FRecvBuffer[2]);
          if (ByteCount > 0) and (Length(FRecvBuffer) = ByteCount + 4) then
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
            FRecvBuffer := '';
          end
          else if ((ByteCount <= 0) or (Length(FRecvBuffer) > ByteCount + 4)) then
          begin
            FLastResult := D_FALSE;
            SetEvent(FSyncMsgEvent);
            FRecvBuffer := '';
          end;
        end;
        $04: // ACK
        begin
          FLastResult := D_OK;
          SetEvent(FSyncMsgEvent);
          FRecvBuffer := '';
        end;
      else
        FLastResult := D_FALSE;
        SetEvent(FSyncMsgEvent);
        FRecvBuffer := '';
      end;
    end;
  finally
    FInCritSec.Leave;
  end;
end;

procedure TCrossCheckThread.TCPOutRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
var
  Buffer: AnsiString;
begin
  FSGInCritSec.Enter;
  try
    if (ADataSize <= 0) then exit;

// AData를 로그에 남기면 로그인 성골 스트링 들어오면서 Access Violation error 발생함,
//    Assert(False, GetLogCommonStr(lsNormal, Format('TCPOutRead data = %s, size = %d', [AData, ADataSize])));
//    Assert(False, GetLogCommonStr(lsNormal, Format('TCPOutRead data = %s', [AData])));
//    Assert(False, GetLogCommonStr(lsNormal, Format('TCPOutRead size = %d', [ADataSize])));

    FSGRecvBuffer := FSGRecvBuffer + AData;

    if (CompareStr(FSGRecvBuffer, FSGStrConnect) = 0) then
    begin
      FSGLastResult := D_OK;
      SetEvent(FSGSyncMsgEvent);
      FSGRecvBuffer := '';
    end
    else if (CompareStr(FSGRecvBuffer, FSGStrLogin) = 0) then
    begin
      FSGLastResult := D_OK;
      SetEvent(FSGSyncMsgEvent);
      FSGRecvBuffer := '';
    end
    else if (CompareStr(Copy(FSGRecvBuffer, Length(FSGRecvBuffer) - Length(FSGStrPrompt) + 1,  Length(FSGStrPrompt)), FSGStrPrompt) = 0) then
    begin
      FSGLastResult := D_OK;
      SetEvent(FSGSyncMsgEvent);
      FSGRecvBuffer := '';
    end;
finally
    FSGInCritSec.Leave;
  end;
end;

function TCrossCheckThread.SendCommand(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
var
  Buffer: AnsiString;
  CheckSum: Byte;
  I: integer;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_STX) + WordToAnsiString($02 + ADataSize) + AnsiChar(ACMD1) + AnsiChar(ACMD2) + AData;

  CheckSum := ACMD1 + ACMD2;
  for I := 1 to ADataSize do
    CheckSum := CheckSum + Ord(AData[I]);

  CheckSum := 0 - CheckSum;
  Buffer := Buffer + AnsiChar(CheckSum);

  FUDPIn.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TCrossCheckThread.SendResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
var
  Buffer: AnsiString;
  CheckSum: Byte;
  I: integer;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_STX) + WordToAnsiString($02 + ADataSize) + AnsiChar(ACMD1) + AnsiChar(ACMD2) + AData;

  CheckSum := ACMD1 + ACMD2;
  for I := 1 to ADataSize do
    CheckSum := CheckSum + Ord(AData[I]);

  CheckSum := 0 - CheckSum;
  Buffer := Buffer + AnsiChar(CheckSum);

  FUDPIn.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TCrossCheckThread.SendAck(AHostIP: AnsiString; APort: Word): Integer;
begin
  Result := D_FALSE;

  FUDPIn.Send(AHostIP, APort, AnsiChar(D_ACK));

  Result := D_OK;
end;

function TCrossCheckThread.SendNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_NAK) + AnsiChar(ANakError);

  FUDPIn.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TCrossCheckThread.SendError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_ERR) + IntToAnsiString(AErrorCode);

  FUDPIn.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TCrossCheckThread.TransmitCommand(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
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
    if (SendCommand(AHostIP, APort, ACMD1, ACMD2, AData, ADataSize) = NOERROR) then
    begin
      R := WaitForSingleObject(FSyncMsgEvent, TimecodeToMilliSec(GV_ConfigCrossCheck.CrossCheckTimeout, FR_30));
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

function TCrossCheckThread.TransmitResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
begin
  ACMD2 := ACMD2 + $80;
  Result := SendResponse(AHostIP, APort, ACMD1, ACMD2, AData, ADataSize);
end;

function TCrossCheckThread.TransmitAck(AHostIP: AnsiString; APort: Word): Integer;
begin
  Result := SendAck(AHostIP, APort);
end;

function TCrossCheckThread.TransmitNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
begin
  Result := SendNak(AHostIP, APort, ANakError);
end;

function TCrossCheckThread.TransmitError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
begin
  Result := SendError(AHostIP, APort, AErrorCode);
end;

function TCrossCheckThread.SendSGCommand(ATCPOut: TTCPOut; AData: AnsiString): Integer;
begin
  Result := D_FALSE;

  if (ATCPOut = nil) then exit;
  if (not ATCPOut.IsConnected) then exit;

  ATCPOut.Send(AData);

  Result := D_OK;
end;

function TCrossCheckThread.TransmitSGCommand(ATCPOut: TTCPOut; AData: AnsiString): Integer;
var
  R: DWORD;
begin
  Result := S_FALSE;

  ResetEvent(FSGSyncMsgEvent);
  FSGRecvBuffer := '';
  FSGRecvData := '';

  FSGCommand := AData;

  FSGCommandCritSec.Enter;
  try
    if (SendSGCommand(ATCPOut, AData) = NOERROR) then
    begin
      R := WaitForSingleObject(FSGSyncMsgEvent, TimecodeToMilliSec(GV_ConfigSerialGate.CommandTimeout, FR_30));//TIME_OUT);
      case R of
        WAIT_OBJECT_0:
          begin
            Result := FSGLastResult;
          end;
        else Result := E_TIMEOUT;
       end;
    end;
  finally
    FSGCommandCritSec.Leave;
  end;
end;

function TCrossCheckThread.DCSIsAlive(AHostIP: AnsiString; var AIsAlive: Boolean): Integer;
var
  Buffer: AnsiString;
begin
  AIsAlive := False;

  Buffer := '';
  Result := TransmitCommand(AHostIP, FUDPIn.Port, $00, $00, Buffer, Length(Buffer));
  if (Result = D_OK) then
  begin
    if (Length(FRecvData) < 1) then exit;
    AIsAlive := PAnsiCharToBool(@FRecvData[1]);
  end;
end;

function TCrossCheckThread.DCSIsMain(AHostIP: AnsiString; var AIsMain: Boolean): Integer;
var
  Buffer: AnsiString;
begin
  AIsMain := False;

  Buffer := '';
  Result := TransmitCommand(AHostIP, FUDPIn.Port, $00, $01, Buffer, Length(Buffer));
  if (Result = D_OK) then
  begin
    if (Length(FRecvData) < 1) then exit;
    AIsMain := PAnsiCharToBool(@FRecvData[1]);
  end;
end;

function TCrossCheckThread.DCSSetMain(AHostIP: AnsiString; AMainDCSID: Word): Integer;
var
  Buffer: AnsiString;
begin
  Buffer := WordToAnsiString(AMainDCSID);
  Result := TransmitCommand(AHostIP, FUDPIn.Port, $00, $10, Buffer, Length(Buffer));
end;

function TCrossCheckThread.DCSGetEventCount(AHostIP: AnsiString; ADeviceHandle: TDeviceHandle; var AEventCount: Integer): Integer;
var
  Buffer: AnsiString;
begin
  AEventCount := 0;

  Buffer := IntToAnsiString(ADeviceHandle);
  Result := TransmitCommand(AHostIP, FUDPIn.Port, $00, $20, Buffer, Length(Buffer));
  if (Result = D_OK) then
  begin
    if (Length(FRecvData) < 4) then exit;
    AEventCount := PAnsiCharToInt(@FRecvData[1]);
  end;
end;

function TCrossCheckThread.DCSGetEvent(AHostIP: AnsiString; ADeviceHandle: TDeviceHandle; ANum: Integer; var AEvent: TEvent): Integer;
var
  Buffer: AnsiString;
  D: TDeviceThread;
begin
  FillChar(AEvent, SizeOf(TEvent), #0);

  Buffer := IntToAnsiString(ADeviceHandle) + IntToAnsiString(ANum);
  Result := TransmitCommand(AHostIP, FUDPIn.Port, $00, $21, Buffer, Length(Buffer));
  if (Result = D_OK) then
  begin
    if (Length(FRecvData) < SizeOf(TEvent)) then exit;
    Move(FRecvData[1], AEvent, SizeOf(TEvent));
  end;
end;

function TCrossCheckThread.DCSGetEventCurrNext(AHostIP: AnsiString; ADeviceHandle: TDeviceHandle; var ACurrEventID, ANextEventID: TEventID): Integer;
var
  Buffer: AnsiString;
begin
  FillChar(ACurrEventID, SizeOf(TEventID), #0);
  FillChar(ANextEventID, SizeOf(TEventID), #0);

  Buffer := IntToAnsiString(ADeviceHandle);
  Result := TransmitCommand(AHostIP, FUDPIn.Port, $00, $22, Buffer, Length(Buffer));
  if (Result = D_OK) then
  begin
    if (Length(FRecvData) < SizeOf(TEventID)) then exit;
    Move(FRecvData[1], ACurrEventID, SizeOf(TEventID));

    if (Length(FRecvData) < SizeOf(TEventID) * 2) then exit;
    Move(FRecvData[SizeOf(TEventID) + 1], ANextEventID, SizeOf(TEventID));
  end;
end;

procedure TCrossCheckThread.Execute;
var
  R: Cardinal;
  WaitList: array[0..1] of THandle;
begin
  { Place thread code here }

//  DoMainCheck;

  WaitList[0] := FEventClose;
  WaitList[1] := FEventMainChange;

  while not Terminated do
  begin
    R := WaitForMultipleObjects(2, @WaitList, False, TimecodeToMilliSec(GV_ConfigCrossCheck.CrossCheckInterval, FR_30));
    case R of
      WAIT_OBJECT_0: break;
      WAIT_OBJECT_0 + 1: DoMainChange;
      else
      begin
        DoCrossCheck;
      end;
    end;
  end;
end;

procedure TCrossCheckThread.SetSerialGate;
const
  CRLF = #13#10;
var
  I: Integer;
  S: PSerialGate;
  TCPOut: TTCPOut;

  function Login: Integer;
  begin
    Assert(False, GetLogCommonStr(lsNormal, Format('SetSerialGate Login, Serial gate login start.', [])));

    Result := TransmitSGCommand(TCPOut, AnsiString(S^.Id) + CRLF);
    if (Result <> D_OK) then exit;


    Assert(False, GetLogCommonStr(lsNormal, Format('SetSerialGate Login, password = %s', [AnsiString(S^.Password)])));

    Result := TransmitSGCommand(TCPOut, AnsiString(S^.Password) + CRLF);
    if (Result <> D_OK) then exit;

    Assert(False, GetLogCommonStr(lsNormal, Format('SetSerialGate Login, Serial gate login succeeded.', [])));
  end;

  function Set422: Integer;
  begin
    Assert(False, GetLogCommonStr(lsNormal, Format('SetSerialGate, Set422, Serial gate set 422 start.', [])));

    Result := TransmitSGCommand(TCPOut, 'def port all interface rs422' + CRLF);
    if (Result <> D_OK) then exit;

    Result := TransmitSGCommand(TCPOut, 'def apply' + CRLF);
    if (Result <> D_OK) then exit;

    Assert(False, GetLogCommonStr(lsNormal, Format('SetSerialGate, Set422, Serial gate set 422 succeeded.', [])));
  end;

  function Set485e: Integer;
  begin
    Assert(False, GetLogCommonStr(lsNormal, Format('SetSerialGate, Set485e, Serial gate set 485e start.', [])));

    Result := TransmitSGCommand(TCPOut, 'def port all interface rs485e' + CRLF);
    if (Result <> D_OK) then exit;

    Result := TransmitSGCommand(TCPOut, 'def apply' + CRLF);
    if (Result <> D_OK) then exit;

    Assert(False, GetLogCommonStr(lsNormal, Format('SetSerialGate, Set485e, Serial gate set 485e succeeded.', [])));
  end;

  procedure SetTCPOut(ASerialGate: PSerialGate);
  begin
    TCPOut := TTCPOut.Create;
          Assert(False, GetLogCommonStr(lsNormal, Format('0', [])));
    try
      FSGStrLogin   := AnsiString(ASerialGate^.Id) + #$D#$A'Password: ';

      TCPOut.HostIP := StrPas(ASerialGate^.HostIP);
      TCPOut.Port := ASerialGate^.Port;
      TCPOut.AsyncMode := True;
      TCPOut.Timeout := 4000;
      TCPOut.OnTCPRead := TCPOutRead;
      Assert(False, GetLogCommonStr(lsNormal, Format('3', [])));
      TCPOut.Start;
      while not TCPOut.IsConnected do
        Sleep(30);

      Assert(False, GetLogCommonStr(lsNormal, Format('111', [])));
      Login;

      if (ASerialGate^.Mine) then
      begin
//        Set485e;
        Set422;
      end
      else
      begin
//        Set422;
        Set485e;
      end;
    finally
      TCPOut.Close;
      TCPOut.Terminate;
      TCPOut.WaitFor;
      FreeAndNil(TCPOut);
      Assert(False, GetLogCommonStr(lsNormal, Format('222', [])));
    end;
  end;
begin
  // Serial Gate Port 설정 전환
  if (GV_ConfigSerialGate.Use) then
  begin
    Assert(False, GetLogCommonStr(lsNormal, Format('SetSerialGate, count = %d', [GV_ConfigSerialGate.SerialGateList.Count])));

    // set other
    Assert(False, GetLogCommonStr(lsNormal, Format('SetSerialGate, set other.', [])));
    for I := 0 to GV_ConfigSerialGate.SerialGateList.Count - 1 do
    begin
      S := GV_ConfigSerialGate.SerialGateList[I];
      if (S <> nil) then
      begin
        if (not S^.Mine) then
        begin
          Assert(False, GetLogCommonStr(lsNormal, Format('SetSerialGate, set other start, ip = %s, port = %d', [S^.HostIP, S^.Port])));
          SetTCPOut(S);
          Sleep(1000);
          Assert(False, GetLogCommonStr(lsNormal, Format('SetSerialGate, set other finish, ip = %s, port = %d', [S^.HostIP, S^.Port])));
        end;
      end;
    end;

    // set mine
    Assert(False, GetLogCommonStr(lsNormal, Format('SetSerialGate, set mine.', [])));
    for I := 0 to GV_ConfigSerialGate.SerialGateList.Count - 1 do
    begin
      S := GV_ConfigSerialGate.SerialGateList[I];
      if (S <> nil) then
      begin
        if (S^.Mine) then
        begin
          Assert(False, GetLogCommonStr(lsNormal, Format('SetSerialGate, set mine start, ip = %s, port = %d', [S^.HostIP, S^.Port])));
          SetTCPOut(S);
          Sleep(1000);
          Assert(False, GetLogCommonStr(lsNormal, Format('SetSerialGate, set mine finish, ip = %s, port = %d', [S^.HostIP, S^.Port])));
        end;
      end;
    end;

  end;
end;

procedure TCrossCheckThread.MainChange;
var
  LockList: TList;
  I: Integer;
  D: TDeviceThread;
begin
  // Serial Gate Port 설정 전환
  if (GV_ConfigSerialGate.Use) then
  begin
    SetSerialGate;
  end;

  GV_DCSCritSec.Enter;
  try
    GV_DCSMine^.Main := True;

    // Main/Sub 전환
    if (GV_DCSMain <> nil) then
    begin
      GV_DCSMain^.Main := False;
    end;

    GV_DCSMain := GV_DCSMine;
  finally
    GV_DCSCritSec.Leave;
  end;

  SaveDCSConfig;

  // Device re cue
  LockList := GV_DeviceThreadList.LockList;
  try
    // Device thread list
    for I := LockList.Count - 1 downto 0 do
    begin
      D := LockList[I];
      if (D <> nil) then
      begin
        D.DeviceOpen;
        D.DeviceReCue;
      end;
    end;
  finally
    GV_DeviceThreadList.UnLockList;
  end;

  // Device re active
  PostMessage(FDCSForm.Handle, WM_UPDATE_ACTIVATE, 0, 0);

  GV_DCSCritSec.Enter;
  try
    Assert(False, GetLogCommonStr(lsNormal, Format('Switch main DCS succeded, name = %s, id = %d',
                                                   [String(GV_DCSMine^.Name), GV_DCSMine^.ID])));
  finally
    GV_DCSCritSec.Leave;
  end;
end;

procedure TCrossCheckThread.DoMainCheck;
var
  I, J, K: Integer;
  DCS: PDCS;

  R: Integer;
  IsMain: Boolean;

  DeviceHandle: TDeviceHandle;
  D: TDeviceThread;
  EventCount: Integer;
  Event: TEvent;
begin
//  GV_DCSMain := nil;

  // DCS 실행 시 현재 운행중인 Main DCS가 있으면
  // 현재 DCS를 Sub로 전환하고 Main DCS로 부터 이벤트를 수신한다.

  GV_DCSCritSec.Enter;
  try
    Assert(False, GetLogCommonStr(lsNormal, Format('DCS Main/sub state, name = %s, main = %s, mine = %s',
                                                   [String(GV_DCSMine^.Name), BoolToStr(GV_DCSMine^.Main, True), BoolToStr(GV_DCSMine^.Mine, True)])));

    // Another DCS main check
    for I := 0 to GV_DCSList.Count - 1 do
    begin
      DCS := GV_DCSList[I];
      if (GV_DCSMine <> DCS) then
      begin
        R := DCSIsMain(DCS^.HostIP, IsMain);

        Assert(False, GetLogCommonStr(lsNormal, Format('Check main DCS, name = %s, ismain = %s',
                                                       [String(DCS^.Name), BoolToStr(IsMain, True)])));

        if (R = D_OK) and (IsMain) then
        begin
          GV_DCSCritSec.Enter;
          try
            GV_DCSMain := DCS;
            GV_DCSMain^.Main := IsMain;

            GV_DCSMine^.Main := False;
          finally
            GV_DCSCritSec.Leave;
          end;

          SaveDCSConfig;

          // 이벤트를 수신
          for J := 0 to GV_DeviceList.Count - 1 do
          begin
           frmDCS.DisplayStartStatus(Format('%s receiving events from main DCS.', [String(GV_DeviceList[J]^.Name)]), 40 + Round((J + 1) / GV_DeviceList.Count * 40));

           DeviceHandle := GV_DeviceList[J]^.Handle;

            D := GetDeviceThreadByHandle(DeviceHandle);
            if (D <> nil) then
              D.DeviceReInputEvents(DCS^.HostIP);

  {          R := DCSGetEventCount(DCS^.HostIP, DeviceHandle, EventCount);
            if (R = D_OK) and (EventCount > 0) then
            begin
              D := GetDeviceThreadByHandle(DeviceHandle);
              if (D <> nil) then
              begin
                for K := 0 to EventCount - 1 do
                begin
                  R := DCSGetEvent(DCS^.HostIP, DeviceHandle, K, Event);
                  if (R = D_OK) then
                    D.InputEvent(GV_DCSMine^.HostIP, Event);
                end;
              end;
            end; }
          end;

          break;
        end;
      end;
    end;

    if (GV_DCSMain <> nil) and (GV_DCSMain = GV_DCSMine) and
       (GV_ConfigSerialGate.Use) then
      SetSerialGate;

    if (GV_DCSMain = nil) then
      MainChange;
  //  else
  //  DeviceInit;

    // Device re active
    PostMessage(FDCSForm.Handle, WM_UPDATE_ACTIVATE, 0, 0);
  finally
    GV_DCSCritSec.Leave;
  end;
end;

procedure TCrossCheckThread.DoMainChange;
var
  I: Integer;
  DCS: PDCS;

  R: Integer;
begin
  ResetEvent(FEventMainChange);

  if (HasMainControl) then exit;

  GV_DCSCritSec.Enter;
  try
    for I := 0 to GV_DCSList.Count - 1 do
    begin
      DCS := GV_DCSList[I];
      if (GV_DCSMine <> DCS) then
      begin
        R := DCSSetMain(DCS^.HostIP, GV_DCSMine^.ID);

        Assert(False, GetLogCommonStr(lsNormal, Format('Set main DCS, name = %s, id = %d',
                                                       [String(GV_DCSMine^.Name), GV_DCSMine^.ID])));
      end;
    end;

  finally
    GV_DCSCritSec.Leave;
  end;

  MainChange;
end;

procedure TCrossCheckThread.DoCrossCheck;
var
  I: Integer;
  DCS: PDCS;

  R: Integer;
  IsAlive: Boolean;

  NextIndex: Integer;
  NextDCS: PDCS;

  T: TDeviceThread;
  LockList: TList;
begin
  if (HasMainControl) then exit;

  GV_DCSCritSec.Enter;
  try
    // Main DCS alive check
    for I := 0 to GV_DCSList.Count - 1 do
    begin
      DCS := GV_DCSList[I];
      if (GV_DCSMine <> DCS) and (DCS^.Main) then
      begin
        R := DCSIsAlive(DCS^.HostIP, IsAlive);

        Assert(False, GetLogCommonStr(lsNormal, Format('Alive check main DCS, name = %s, alive = %s',
                                                       [String(DCS^.Name), BoolToStr(IsAlive, True)])));


        if (R <> D_OK) or (not IsAlive) then
        begin
          Inc(FNumCrossCheck);
        end
        else
          FNumCrossCheck := 0;

        break;
      end;
    end;

    if (FNumCrossCheck >= GV_ConfigCrossCheck.NumCrossCheck) then
    begin
      NextIndex := GV_DCSList.IndexOf(GV_DCSMain) + 1;
      if (NextIndex < 0) or (NextIndex > GV_DCSList.Count - 1) then
        NextIndex := 0;

      // 다음 메인 DCS를 설정
      NextDCS := GV_DCSList[NextIndex];

      // 다른 DCS에 NextDCS가 Main DCS임을 통보
      for I := 0 to GV_DCSList.Count - 1 do
      begin
        DCS := GV_DCSList[I];
        if {(GV_DCSMain <> DCS) and }
           (GV_DCSMine <> DCS) then
        begin
          R := DCSSetMain(DCS^.HostIP, NextDCS^.ID);

          Assert(False, GetLogCommonStr(lsNormal, Format('Set main DCS, name = %s, id = %d',
                                                         [String(NextDCS^.Name), NextDCS^.ID])));
        end;
      end;

      if (GV_DCSMine = NextDCS) then
      begin
        MainChange;
  //      ExecuteMainChange;

  {      GV_DCSMine^.Main := True;

        // Main/Sub 전환
        if (GV_DCSMain <> nil) then
        begin
          GV_DCSMain^.Main := False;
          GV_DCSMain := GV_DCSMine;
        end;

        SaveDCSConfig;

        // Device re active

        PostMessage(FDCSForm.Handle, WM_UPDATE_ACTIVATE, 0, 0);

        // Device re cue
        LockList := GV_DeviceThreadList.LockList;
        try
          // Device thread list
          for I := LockList.Count - 1 downto 0 do
          begin
            T := LockList[I];
            if (T <> nil) then
            begin
              T.DeviceReCue;
            end;
          end;
        finally
          GV_DeviceThreadList.UnLockList;
        end;

        Assert(False, GetLogCommonStr(lsNormal, Format('Switch main DCS succeded, name = %s, id = %d',
                                                       [String(DCS^.Name), DCS^.ID])));  }
      end;

      FNumCrossCheck := 0;
    end;
  finally
    GV_DCSCritSec.Leave;
  end;
end;

{ TTimerThread }

//constructor TTimerThread.Create;
//begin
//  FTimerEnabledFlag := CreateEvent(nil, True, False, nil);
//  FCancelFlag := CreateEvent(nil, True, False, nil);
//  FTimerProc := nil;
//  FInterval := 1000;
//  FreeOnTerminate := False; // Main thread controls for thread destruction
//  inherited Create(False);
//end;
//
//destructor TTimerThread.Destroy; // Call TTimerThread.Free to cancel the thread
//begin
//  Terminate;
//  if GetCurrentThreadID = MainThreadID then
//  begin
//    OutputDebugString('TTimerThread.Destroy :: MainThreadID (Waitfor)');
//    Waitfor; // Synchronize
//  end;
//  CloseHandle(FCancelFlag);
//  CloseHandle(FTimerEnabledFlag);
//  OutputDebugString('TTimerThread.Destroy');
//  inherited;
//end;
//
//procedure TTimerThread.Terminate;
//begin
//  inherited Terminate;
//  ResetEvent(FTimerEnabledFlag); // Stop timer event
//  SetEvent(FCancelFlag); // Set cancel flag
//end;
//
//procedure TTimerThread.SetEnabled(AEnable: Boolean);
//begin
//  if AEnable then
//    SetEvent(FTimerEnabledFlag)
//  else
//    ResetEvent(FTimerEnabledFlag);
//end;
//
//function TTimerThread.GetEnabled: Boolean;
//begin
//  Result := WaitForSingleObject(FTimerEnabledFlag, 0) = WAIT_OBJECT_0 // Signaled
//end;
//
//procedure TTimerThread.SetInterval(AInterval: Cardinal);
//begin
//  FInterval := AInterval;
//end;
//
//procedure TTimerThread.Execute;
//var
//  WaitList: array[0..1] of THandle;
//  WaitInterval, LastProcTime: Int64;
//  Frequency, StartCount, StopCount: Int64; // minimal stop watch
//begin
//  QueryPerformanceFrequency(Frequency); // this will never return 0 on Windows XP or later
//  if (Frequency = 0) then Frequency := 1;
//
//  WaitList[0] := FTimerEnabledFlag;
//  WaitList[1] := FCancelFlag;
//  LastProcTime := 0;
//
//  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
//
//  if (Enabled) and (Assigned(FTimerProc)) then
//    FTimerProc(Self);
//
//  while not Terminated do
//  begin
//    ResetEvent(GV_TimerExecuteEvent);
//    if (WaitForMultipleObjects(2, @WaitList[0], False, INFINITE) <> WAIT_OBJECT_0) then
//      break; // Terminate thread when FCancelFlag is signaled
//
//
//    WaitInterval := FInterval - LastProcTime;
//    if (WaitInterval < 0) then
//    begin
//      WaitInterval := 0;
//    end;
////    if (WaitForSingleObject(FCancelFlag, WaitInterval) <> WAIT_TIMEOUT) then
////      break;
//
//    QueryPerformanceCounter(StartCount);
//    repeat
//      QueryPerformanceCounter(StopCount);
////      Sleep(0);
//    until ((1000 * (StopCount - StartCount) div Frequency) >= WaitInterval);
//
//    if (Enabled) then
//    begin
//      QueryPerformanceCounter(StartCount);
//      if not Terminated then
//      begin
//        if (Assigned(FTimerProc)) then
//          FTimerProc(Self);
//        SetEvent(GV_TimerExecuteEvent);
//      end;
//      QueryPerformanceCounter(StopCount);
//      // Interval adjusted for FTimerProc execution time
//      LastProcTime := 1000 * (StopCount - StartCount) div Frequency; // ElapsedMilliSeconds
//    end;
//  end;
//
//  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_NORMAL);
//
//exit;
//  QueryPerformanceFrequency(Frequency); // this will never return 0 on Windows XP or later
//  WaitList[0] := FTimerEnabledFlag;
//  WaitList[1] := FCancelFlag;
//  LastProcTime := 0;
//
//  if (Enabled) then
//    FTimerProc(Self);
//
//  while not Terminated do
//  begin
//    ResetEvent(GV_TimerExecuteEvent);
//    if (WaitForMultipleObjects(2, @WaitList[0], False, INFINITE) <> WAIT_OBJECT_0) then
//      break; // Terminate thread when FCancelFlag is signaled
//
//    WaitInterval := FInterval - LastProcTime;
//    if (WaitInterval < 0) then
//      WaitInterval := 0;
//    if (WaitForSingleObject(FCancelFlag, WaitInterval) <> WAIT_TIMEOUT) then
//      break;
//
//    if (Enabled) then
//    begin
//      QueryPerformanceCounter(StartCount);
//      if not Terminated then
//      begin
//        if Assigned(FTimerProc) then
//          FTimerProc(Self);
//        SetEvent(GV_TimerExecuteEvent);
//      end;
//      QueryPerformanceCounter(StopCount);
//      // Interval adjusted for FTimerProc execution time
//      LastProcTime := 1000 * (StopCount - StartCount) div Frequency; // ElapsedMilliSeconds
//    end;
//  end;
//end;

end.
