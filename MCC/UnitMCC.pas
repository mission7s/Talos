unit UnitMCC;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage,
  WMTools, WMControls, Vcl.ExtCtrls, System.Actions, Vcl.ActnList, System.SyncObjs,
  Vcl.XPStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ActnMenus,
  Vcl.ActnColorMaps, AdvOfficePager, AdvOfficePagerStylers, Vcl.StdCtrls,
  AdvSplitter, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  AdvCGrid, AdvScrollBox, Winapi.MMSystem,
  UnitCommons, UnitDCSDLL, UnitConsts,
  UnitNormalForm,
  UnitUDPIn, UnitUDPOut, UnitTypeConvert,
  UnitTimeline, UnitPlaylist, UnitDevice;

type
//  TTimerThread = class;

  TfrmMCC = class(TfrmNormal)
    aopStyler: TAdvOfficePagerOfficeStyler;
    XPColorMap: TXPColorMap;
    actMainMenuMCC: TActionMainMenuBar;
    actManager: TActionManager;
    actHelp: TAction;
    actAbout: TAction;
    actFileClose: TAction;
    actViewTruePeak: TAction;
    actViewMomentary: TAction;
    actViewShortTerm: TAction;
    actViewIntegrate: TAction;
    actSettingsDeviceAndMeasure: TAction;
    actSettingsChannelRouting: TAction;
    actEventInsertMainEvent: TAction;
    aoPagerDevice: TAdvOfficePager;
    aopDeviceMedia: TAdvOfficePage;
    aopDeviceCG: TAdvOfficePage;
    aopDeviceInput: TAdvOfficePage;
    AdvSplitter1: TAdvSplitter;
    aopDevice: TAdvOfficePage;
    actFileNewPlaylist: TAction;
    actFileOpenPlaylist: TAction;
    actControlStartOnair: TAction;
    actEventInsertJoinEvent: TAction;
    actEventInsertSubEvent: TAction;
    actEventInsertCommentEvent: TAction;
    actFileSavePlaylist: TAction;
    actEventUpdateEvent: TAction;
    actEventDeleteEvent: TAction;
    actFileOpenAddPlayList: TAction;
    actFileSaveAsPlayList: TAction;
    actControlFreezeOnAir: TAction;
    actControlFinishOnAir: TAction;
    actControlAssignNextEvent: TAction;
    actControlStartNextEventImmediately: TAction;
    actEditCopyEvent: TAction;
    actEditCutEvent: TAction;
    actEditPasteEvent: TAction;
    actEditClearClipboard: TAction;
    actEditFindEvent: TAction;
    actEditReplaceEvent: TAction;
    actEventInspectEvent: TAction;
    actControlIncrease1Second: TAction;
    actControlDecrease1Second: TAction;
    actControlAssignTargetEvent: TAction;
    actEditTimelineZoomIn: TAction;
    actEditTimelineZoomOut: TAction;
    actEventInsertProgram: TAction;
    actAllChannelsTimelineZoomIn: TAction;
    actAllChannelsTimelineZoomOut: TAction;
    actGotoCurrentEvent: TAction;
    WMPanel8: TWMPanel;
    pnlTimeline: TWMPanel;
    AdvSplitter2: TAdvSplitter;
    WMPanel1: TWMPanel;
    aoPagerPlaylist: TAdvOfficePager;
    Label8: TLabel;
    actEditTimelineMoveLeft: TAction;
    actEditTimelineMoveRight: TAction;
    actEditTimelineGotoCurrent: TAction;
    lblCurrentTime: TLabel;
    procedure actFileCloseExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure aoPagerPlaylistChange(Sender: TObject);
    procedure lblCurrentTimeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure actGotoCurrentEventExecute(Sender: TObject);
    procedure actEditTimelineZoomInExecute(Sender: TObject);
    procedure actEditTimelineZoomOutExecute(Sender: TObject);
    procedure actEditTimelineMoveLeftExecute(Sender: TObject);
    procedure actEditTimelineMoveRightExecute(Sender: TObject);
    procedure actEditTimelineGotoCurrentExecute(Sender: TObject);
  private
    { Private declarations }

    FSaveMenuFont: TFont; // will hold initial main menu bar's font settings
    FSaveColorMap: TXPColorMap;

    FUDPSysIn: TUDPIn;
    FUDPSysOut: TUDPOut;

    FSysRecvBuffer: AnsiString;
    FSysRecvData: AnsiString;

    FUDPIn: TUDPIn;
    FUDPOut: TUDPOut;

    FRecvBuffer: AnsiString;
    FRecvData: AnsiString;

    FSysInCritSec: TCriticalSection;
    FInCritSec: TCriticalSection;

    FTimerID: UINT;

//    FTimerThread: TTimerThread;

    FChannelTimelineHeight: Integer;

    function SendSysResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
    function SendSysAck(AHostIP: AnsiString; APort: Word): Integer;
    function SendSysNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function SendSysError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    function SendResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
    function SendAck(AHostIP: AnsiString; APort: Word): Integer;
    function SendNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function SendError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    procedure DisplayStartCheck(ACheckStr: String);

    procedure Initialize;
    procedure Finalize;

    procedure InitializeTimelinePage;
    procedure FinalizeTimelinePage;

    procedure InitializeChannelPage;
    procedure FinalizeChannelPage;

    procedure InitializeDevicePage;
    procedure FinalizeDevicePage;

    procedure DeviceOpen;
    procedure DeviceClose;

    procedure TimerThreadEvent(Sender: TObject);

    procedure TimelineZoomIn;
    procedure TimelineZoomOut;

    procedure ScreenOnActiveControlChange(Sender: TObject);

    procedure UDPSysInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
    procedure UDPInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
//    procedure WndProc(var Message: TMessage); override;

    procedure WMUpdateCurrentTime(var Message: TMessage); message WM_UPDATE_CURRENT_TIME;
  public
    { Public declarations }

    function GetChannelFormByID(AChannelID: Word): TfrmPlaylist;
    function GetDeviceForm: TfrmDevice;

    function TransmitSysResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
    function TransmitSysAck(AHostIP: AnsiString; APort: Word): Integer;
    function TransmitSysNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function TransmitSysError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;

    function TransmitResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
    function TransmitAck(AHostIP: AnsiString; APort: Word): Integer;
    function TransmitNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
    function TransmitError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;



//    function GetPlaylistFormByChannelID(AChannelID: Byte): TfrmPlaylist;

    // 0X00 System Control
{    function DCSIsAlive(var AIsAlive: Boolean): Integer;                    // 0X00.00
    function DCSIsMain(var AIsMain: Boolean): Integer;                      // 0X00.01
    function DCSSetMain(ABuffer: AnsiString): Integer;                         // 0X00.10
    function DCSGetEventCount(ABuffer: AnsiString; var AEventCount: Integer): Integer;         // 0X00.20
    function DCSGetEvent(ABuffer: AnsiString; var AEvent: TEvent): Integer;         // 0X00.21 }

    // 0X00 System Control
    function MCCOpen(ABuffer: AnsiString): Integer;                     // 0X00.00
    function MCCClose(ABuffer: AnsiString): Integer;                    // 0X00.01
//    function MCCIsAlive(ABuffer: AnsiString): Integer;                  // 0X00.02

    function MCCIsAlive(var AIsAlive: Boolean): Integer;                  // 0X00.00

    // 0X10 Immediate Control

    // 0X20 Preset/Select Commands

    // 0X30 Sense Queries

    // 0X30 CueSheet Control
    function MCCBeginUpdate(ABuffer: AnsiString): Integer;              // 0X40.00
    function MCCEndUpdate(ABuffer: AnsiString): Integer;                // 0X40.01

    function MCCSetDeviceCommError(ABuffer: AnsiString): Integer;       // 0X40.02
    function MCCSetDeviceStatus(ABuffer: AnsiString): Integer;          // 0X40.03

    function MCCSetOnAir(ABuffer: AnsiString): Integer;                 // 0X40.10
    function MCCSetEventStatus(ABuffer: AnsiString): Integer;           // 0X40.11
    function MCCSetMediaStatus(ABuffer: AnsiString): Integer;           // 0X40.12

    function MCCInputCueSheet(ABuffer: AnsiString): Integer;            // 0X40.20
    function MCCDeleteCueSheet(ABuffer: AnsiString): Integer;           // 0X40.21
    function MCCClearCueSheet(ABuffer: AnsiString): Integer;            // 0X40.22

    function MCCSetCueSheetCurr(ABuffer: AnsiString): Integer;          // 0X40.30
    function MCCSetCueSheetNext(ABuffer: AnsiString): Integer;          // 0X40.31
    function MCCSetCueSheetTarget(ABuffer: AnsiString): Integer;        // 0X40.32
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
  frmMCC: TfrmMCC;
  procedure DeviceStatusNotify(ADCSIP: PChar; AHandle: TDeviceHandle; AStatus: TDeviceStatus); stdcall;
  procedure EventStatusNotify(ADCSIP: PChar; AEventID: TEventID; AStatus: TEventStatus); stdcall;
  procedure EventOverallNotify(ADCSIP: PChar; AHandle: TDeviceHandle; AOverall: TEventOverall); stdcall;
  procedure MCCUpdateActnMenusProc;

  procedure TimerCallBack(uTimer, uMessage: UINT; dwUser, dw1, dw2: DWORD); stdcall;

implementation

uses UnitStartSplash;

{$R *.dfm}

procedure DeviceStatusNotify(ADCSIP: PChar; AHandle: TDeviceHandle; AStatus: TDeviceStatus);
var
  I, J: Integer;
  Source: PSource;
  SourceHandles: TSourceHandleList;

  DCSID: Word;
  DeviceForm: TfrmDevice;
begin
  if (not GV_SettingOption.OnAirCheckDeviceNotify) then exit;

  DeviceForm := frmMCC.GetDeviceForm;
  if (DeviceForm <> nil) then
    DeviceForm.SetDeviceStatus(String(ADCSIP), AHandle, AStatus);

exit;

{  Source := nil;
  for I := 0 to GV_SourceList.Count - 1 do
  begin
    SourceHandles := GV_SourceList[I]^.Handles;
    if (SourceHandles <> nil) then
    begin
      for J := 0 to SourceHandles.Count - 1 do
        if (SourceHandles[J].Handle = ADeviceHandle) then
        begin
          Source := GV_SourceList[I];
          DCSID := SourceHandles[J].DCSID;
          break;
        end;
    end;
    if (Source <> nil) then break;
  end;

  if (Source = nil) then exit;

  if (frmMCC <> nil) and (frmMCC.HandleAllocated) then
    with frmMCC do
    begin
      if (aopDevice.ControlCount > 0) then
      begin
        DeviceForm := TfrmDevice(aopDevice.Controls[0]);
        if (DeviceForm <> nil) then
          DeviceForm.SetDeviceStatus(I, Source, AStatus, DCSID);
      end;
    end;
  exit;

  // None broadcat
  Source := nil;
  for I := 0 to GV_SourceList.Count - 1 do
  begin
    SourceHandles := GV_SourceList[I]^.Handles;
    if (SourceHandles <> nil) then
    begin
      for J := 0 to SourceHandles.Count - 1 do
        if (String(SourceHandles[J].DCSIP) = String(ADCSIP)) and
           (SourceHandles[J].Handle = ADeviceHandle) then
        begin
          Source := GV_SourceList[I];
          DCSID := SourceHandles[J].DCSID;
          break;
        end;
    end;
    if (Source <> nil) then break;
  end;

  if (Source = nil) then exit;

  if (frmMCC <> nil) and (frmMCC.HandleAllocated) then
    with frmMCC do
    begin
      if (aopDevice.ControlCount > 0) then
      begin
        DeviceForm := TfrmDevice(aopDevice.Controls[0]);
        if (DeviceForm <> nil) then
          DeviceForm.SetDeviceStatus(I, Source, AStatus, DCSID);
      end;
    end; }
end;

procedure EventStatusNotify(ADCSIP: PChar; AEventID: TEventID; AStatus: TEventStatus);
//var
//  ChannelForm: TfrmPlaylist;
begin
{  if (frmMCC <> nil) and (frmMCC.HandleAllocated) then
    with frmMCC do
    begin
      ChannelForm := GetPlaylistFormByChannelID(AEventID.ChannelID);
      if (ChannelForm <> nil) then
        ChannelForm.SetEventStatus(AEventID, AStatus);
    end; }
end;

procedure EventOverallNotify(ADCSIP: PChar; AHandle: TDeviceHandle; AOverall: TEventOverall);
var
  I: Integer;
//  ChannelForm: TfrmPlaylist;
begin
{  if (frmMCC <> nil) and (frmMCC.HandleAllocated) then
    with frmMCC do
    begin
      ChannelForm := GetChannelFormByID(AOverall.ChannelID);
      if (ChannelForm <> nil) then
        ChannelForm.SetEventOverall(String(ADCSIP), ADeviceHandle, AOverall);
    end; }
end;

function TfrmMCC.SendSysResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
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

function TfrmMCC.SendSysAck(AHostIP: AnsiString; APort: Word): Integer;
begin
  Result := D_FALSE;

  FUDPSysOut.Send(AHostIP, APort, AnsiChar(D_ACK));

  Result := D_OK;
end;

function TfrmMCC.SendSysNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_NAK) + AnsiChar(ANakError);

  FUDPSysOut.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TfrmMCC.SendSysError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_ERR) + IntToAnsiString(AErrorCode);

  FUDPSysOut.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TfrmMCC.SendResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
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

function TfrmMCC.SendAck(AHostIP: AnsiString; APort: Word): Integer;
begin
  Result := D_FALSE;

  FUDPOut.Send(AHostIP, APort, AnsiChar(D_ACK));

  Result := D_OK;
end;

function TfrmMCC.SendNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_NAK) + AnsiChar(ANakError);

  FUDPOut.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TfrmMCC.SendError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
var
  Buffer: AnsiString;
begin
  Result := D_FALSE;

  Buffer := AnsiChar(D_ERR) + IntToAnsiString(AErrorCode);

  FUDPOut.Send(AHostIP, APort, Buffer);

  Result := D_OK;
end;

function TfrmMCC.TransmitSysResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
begin
  ACMD2 := ACMD2 + $80;
  Result := SendSysResponse(AHostIP, APort, ACMD1, ACMD2, AData, ADataSize);
end;

function TfrmMCC.TransmitSysAck(AHostIP: AnsiString; APort: Word): Integer;
begin
  Result := SendSysAck(AHostIP, APort);
end;

function TfrmMCC.TransmitSysNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
begin
  Result := SendSysNak(AHostIP, APort, ANakError);
end;

function TfrmMCC.TransmitSysError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
begin
  Result := SendSysError(AHostIP, APort, AErrorCode);
end;

function TfrmMCC.TransmitResponse(AHostIP: AnsiString; APort: Word; ACMD1, ACMD2: Byte; AData: AnsiString; ADataSize: Integer): Integer;
begin
  ACMD2 := ACMD2 + $80;
  Result := SendResponse(AHostIP, APort, ACMD1, ACMD2, AData, ADataSize);
end;

function TfrmMCC.TransmitAck(AHostIP: AnsiString; APort: Word): Integer;
begin
  Result := SendAck(AHostIP, APort);
end;

function TfrmMCC.TransmitNak(AHostIP: AnsiString; APort: Word; ANakError: Byte): Integer;
begin
  Result := SendNak(AHostIP, APort, ANakError);
end;

function TfrmMCC.TransmitError(AHostIP: AnsiString; APort: Word; AErrorCode: Integer): Integer;
begin
  Result := SendError(AHostIP, APort, AErrorCode);
end;

procedure TfrmMCC.ScreenOnActiveControlChange(Sender: TObject);
var
  I: Integer;
//  ChannelTimelineForm: TfrmPlaylistTimeline;
begin
{  if (Screen.ActiveControl = nil) then exit;
  if (Screen.ActiveControl.Owner = nil) then exit;
  if not (Screen.ActiveControl.Owner is TfrmPlaylistTimeline) then exit;

  for I := 0 to Screen.FormCount - 1 do
  begin
    if (Screen.Forms[I] is TfrmPlaylistTimeline) then
    begin
      with (Screen.Forms[I] as TfrmPlaylistTimeline) do
      begin
//        pnlDesc.Color := $00251C19;
        pnlDesc.ColorHighLight := $00694F44;
        pnlDesc.ColorShadow    := $00694F44;
      end;
    end;
  end;

  ChannelTimelineForm := (Screen.ActiveControl.Owner as TfrmPlaylistTimeline);
//  ChannelTimelineForm.WMPanel.Color:= $00AD5830;
  ChannelTimelineForm.pnlDesc.ColorHighLight := $00CC9933;//clRed;
  ChannelTimelineForm.pnlDesc.ColorShadow    := $00CC9933;//clRed; }
end;

procedure TfrmMCC.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  Params.Style := Params.Style or WS_MINIMIZEBOX;
end;

procedure TfrmMCC.WMUpdateCurrentTime(var Message: TMessage);
begin
  lblCurrentTime.Caption := FormatDateTime('YYYY-MM-DD hh:nn:ss:zzz', Now);
end;

{procedure TfrmMCC.WndProc(var Message: TMessage);
begin
  inherited;

  case Message.Msg of
    WM_UPDATE_CURRENT_TIME:
    begin
      lblCurrentTime.Caption := FormatDateTime('YYYY-MM-DD hh:nn:ss', Now);
    end;
  end;
end; }

{function TfrmMCC.GetPlaylistFormByChannelID(AChannelID: Byte): TfrmPlaylist;
var
  I: Integer;
begin
  Result := nil;
  for I := 1 to aoPagerPlaylist.AdvPageCount - 1 do
  begin
    if (aoPagerPlaylist.AdvPages[I].Tag = AChannelID) then
    begin
      if (aoPagerPlaylist.AdvPages[I].ControlCount > 0) then
        Result := TfrmPlaylist(aoPagerPlaylist.AdvPages[I].Controls[0]);
      break;
    end;
  end;
end; }

procedure TfrmMCC.actGotoCurrentEventExecute(Sender: TObject);
begin
  inherited;

{  if (aoPagerPlaylist.ActivePageIndex <= 0) then exit;

  ChannelForm := GetPlaylistFormByChannelID(aoPagerPlaylist.ActivePage.Tag);
  if (ChannelForm <> nil) then
  begin
    ChannelForm.GotoCurrentEvent;
  end; }
end;

procedure TfrmMCC.aoPagerPlaylistChange(Sender: TObject);
//var
//  ChannelForm: TfrmPlaylist;
begin
  inherited;

{  if (aoPagerPlaylist.ActivePageIndex <= 0) then exit;

  ChannelForm := GetPlaylistFormByChannelID(aoPagerPlaylist.ActivePage.Tag);
  if (ChannelForm <> nil) then
    ChannelForm.acgPlaylist.SetFocus; }
end;

procedure TfrmMCC.FormCreate(Sender: TObject);
begin
  inherited;
  frmStartSplash := TfrmStartSplash.Create(Self);
  frmStartSplash.Show;
  Application.ProcessMessages;
  try
    Initialize;
  finally
    frmStartSplash.Close;
    FreeAndNil(frmStartSplash);
  end;
end;

procedure TfrmMCC.FormDestroy(Sender: TObject);
begin
  inherited;
  Finalize;
end;

procedure MCCUpdateActnMenusProc;
begin
//  ShowMessage(frmMCC.ActionMainMenuBar1.ColorMap.Name);
  with frmMCC.XPColorMap do
  begin
    ShadowColor := cl3DDkShadow;
    Color := $00251C19;
    DisabledColor := clGray;
    DisabledFontColor := clMedGray;
    DisabledFontShadow := clBlack;
    FontColor := $00FFBDAD;
    HighlightColor := $00EEF6F7;
    HotColor := clWhite;
    HotFontColor := clWhite;
    MenuColor := $FFFFFFFF;
    FrameTopLeftInner := $005A453F;
    FrameTopLeftOuter := $00251C19;
    FrameBottomRightInner := $005A453F;
    FrameBottomRightOuter := $00251C19;
    BtnFrameColor := $005A453F;
    BtnSelectedColor := $00614A43;
    BtnSelectedFont := clWhite;
    SelectedColor := $00614A43;
    SelectedFontColor := clWhite;
    UnusedColor := $00EFD3C6;
  end;
  frmMCC.actMainMenuMCC.ColorMap := frmMCC.XPColorMap;
  frmMCC.actMainMenuMCC.Color := $00251C19;
  frmMCC.actMainMenuMCC.Font.Name := 'Century Gothic';
  frmMCC.actMainMenuMCC.Font.Color := $00FFBDAD;
  frmMCC.actMainMenuMCC.Font.Size := 9;
//  ShowMessage(Format('%x', [Integer(frmMCC.XPColorMap.FontColor)]));
end;

procedure TimerCallBack(uTimer, uMessage: UINT; dwUser, dw1, dw2: DWORD);
begin
  SetEvent(GV_TimerExecuteEvent);
  PostMessage(frmMCC.Handle, WM_UPDATE_CURRENT_TIME, 0, 0);
  ResetEvent(GV_TimerExecuteEvent);
end;

procedure TfrmMCC.DisplayStartCheck(ACheckStr: String);
begin
  if (frmStartSplash <> nil) and (frmStartSplash.HandleAllocated) then
    frmStartSplash.DisplayCheck(ACheckStr);
end;

procedure TfrmMCC.Initialize;
var
  R: Integer;
  I: Integer;
  OfficePage: TAdvOfficePage;
  Channel: PChannel;
//  ChannelForm: TfrmPlaylist;
begin
  DisplayStartCheck('Loading configuration...');

  FSaveMenuFont := TFont.Create;
  FSaveMenuFont.Assign(actMainMenuMCC.Font);
  FSaveColorMap := TXPColorMap.Create(Self);
  FSaveColorMap.Assign(actMainMenuMCC.ColorMap);

{  Screen.OnActiveControlChange := ScreenOnActiveControlChange;
  UpdateActnMenusProc := MCCUpdateActnMenusProc; }

  SetEventDeadlineHour(30);

  GV_LogCS := TCriticalSection.Create;

  GV_ChannelList := TChannelList.Create;
  GV_SECList := TSECList.Create;
  GV_DCSList := TDCSList.Create;
  GV_SourceList := TSourceList.Create;

  GV_ProgramTypeList := TProgramTypeList.Create;

  GV_TimerExecuteEvent := CreateEvent(nil, True, False, nil);
  GV_TimerCancelEvent  := CreateEvent(nil, True, False, nil);

  FSysRecvBuffer := '';
  FSysRecvData   := '';

  FRecvBuffer := '';
  FRecvData   := '';

  FSysInCritSec := TCriticalSection.Create;
  FInCritSec := TCriticalSection.Create;

  LoadConfig;

  Application.Title := Format('Multi Channel Controller %s - %s', [GetFileVersionStr(Application.ExeName), GV_SettingGeneral.Name]);
  WMTitleBar.Caption := Application.Title;

  DisplayStartCheck('Port opening...');

  with GV_SettingDCS do
  begin
    // System control
    R := DCSSysInitialize(SysInPort, SysOutPort, TimecodeToMilliSec(SysCheckTimeout));
    if (R <> D_OK) then
      Assert(False, GetMainLogStr(lsError, @LSE_DCSSysInitializeFailed, [R, SysInPort, SysOutPort]));

    if (SysLogInPortEnabled) then
    begin
      R := DCSSysLogInPortEnable(PChar(SysLogPath), PChar(SysLogExt));
      if (R <> D_OK) then
        Assert(False, GetMainLogStr(lsError, @LSE_DCSSysLogInPortEnableFailed, [R, SysLogPath, SysLogExt]));
    end;

    if (SysLogOutPortEnabled) then
    begin
      R := DCSSysLogOutPortEnable(PChar(SysLogPath), PChar(SysLogExt));
      if (R <> D_OK) then
        Assert(False, GetMainLogStr(lsError, @LSE_DCSSysLogOutPortEnableFailed, [R, SysLogPath, SysLogExt]));
    end;

    // Device control
    R := DCSInitialize(NotifyPort, InPort, OutPort, TimecodeToMilliSec(CommandTimeout));
    if (R <> D_OK) then
      Assert(False, GetMainLogStr(lsError, @LSE_DCSInitializeFailed, [R, NotifyPort, InPort, OutPort]));

    if (LogNotifyPortEnabled) then
    begin
      R := DCSLogNotifyPortEnable(PChar(LogPath), PChar(LogExt));
      if (R <> D_OK) then
        Assert(False, GetMainLogStr(lsError, @LSE_DCSLogNotifyPortEnableFailed, [R, LogPath, LogExt]));
    end;

    if (LogInPortEnabled) then
    begin
      R := DCSLogInPortEnable(PChar(LogPath), PChar(LogExt));
      if (R <> D_OK) then
        Assert(False, GetMainLogStr(lsError, @LSE_DCSLogInPortEnableFailed, [R, LogPath, LogExt]));
    end;

    if (LogOutPortEnabled) then
    begin
      R := DCSLogOutPortEnable(PChar(LogPath), PChar(LogExt));
      if (R <> D_OK) then
        Assert(False, GetMainLogStr(lsError, @LSE_DCSLogOutPortEnableFailed, [R, LogPath, LogExt]));
    end;

    R := DCSDeviceStatusNotify(@DeviceStatusNotify);
    if (R <> D_OK) then
      Assert(False, GetMainLogStr(lsError, @LSE_DCSSetDeviceStatusNotifyFailed, [R]));

    R := DCSEventStatusNotify(@EventStatusNotify);
    if (R <> D_OK) then
      Assert(False, GetMainLogStr(lsError, @LSE_DCSSetEventStatusNotifyFailed, [R]));

    R := DCSEventOverallNotify(@EventOverallNotify);
    if (R <> D_OK) then
      Assert(False, GetMainLogStr(lsError, @LSE_DCSSetEventOverallNotifyFailed, [R]));
  end;

  DisplayStartCheck('Device opening...');

  DeviceOpen;

  DisplayStartCheck('MCC system checking...');

  InitializeTimelinePage;
  InitializeChannelPage;
  InitializeDevicePage;

  with GV_SettingGeneral do
  begin
    FUDPSysIn  := TUDPIn.Create(SysInPort);
    FUDPSysOut := TUDPOut.Create(SysOutPort);

    FUDPIn     := TUDPIn.Create(InPort);
    FUDPOut    := TUDPOut.Create(OutPort);
  end;

  FUDPSysIn.OnUDPRead := UDPSysInRead;
  FUDPSysIn.AsyncMode := True;
  FUDPSysIn.Start;
  while not FUDPSysIn.Started do
    Sleep(30);

  FUDPSysOut.AsyncMode := True;
  FUDPSysOut.Start;
  while not FUDPSysOut.Started do
    Sleep(30);

  FUDPIn.OnUDPRead := UDPInRead;
  FUDPIn.AsyncMode := True;
  FUDPIn.Start;
  while not FUDPIn.Started do
    Sleep(30);

  FUDPOut.AsyncMode := True;
  FUDPOut.Start;
  while not FUDPOut.Started do
    Sleep(30);

{  FTimerThread := TTimerThread.Create;
  FTimerThread.Interval := 1000;
  FTimerThread.OnTimerEvent := TimerThreadEvent;
  FTimerThread.Enabled := True; }

  FTimerID := timeSetEvent(1000, 1, @TimerCallBack, 0, TIME_PERIODIC);

//  Maximize;
end;

procedure TfrmMCC.Finalize;
var
  R: Integer;
begin
  SetEvent(GV_TimerCancelEvent);

  if (FTimerID <> 0) then
  begin
    timeKillEvent(FTimerID); // 타이머를 해제한다.
    timeEndPeriod(0); // 타이머 주기를 해제한다.
  end;

{  FTimerThread.Terminate;
  FTimerThread.WaitFor;
  FreeAndNil(FTimerThread); }

  CloseHandle(GV_TimerExecuteEvent);
  CloseHandle(GV_TimerCancelEvent);

  DeviceClose;

  FinalizeDevicePage;
  FinalizeChannelPage;
  FinalizeTimelinePage;

  R := DCSFinalize;
  if (R <> D_OK) then
    Assert(False, GetMainLogStr(lsError, @LSE_DCSFinalizeFailed, [R]));

  SaveConfig;

  FUDPIn.Close;
  FUDPIn.Terminate;
  FUDPIn.WaitFor;
  FreeAndNil(FUDPIn);

  FUDPOut.Close;
  FUDPOut.Terminate;
  FUDPOut.WaitFor;
  FreeAndNil(FUDPOut);

  FUDPSysIn.Close;
  FUDPSysIn.Terminate;
  FUDPSysIn.WaitFor;
  FreeAndNil(FUDPSysIn);

  FUDPSysOut.Close;
  FUDPSysOut.Terminate;
  FUDPSysOut.WaitFor;
  FreeAndNil(FUDPSysOut);

  ClearProgramTypeList;

  ClearSourceList;
  ClearDCSList;
  ClearSECList;
  ClearChannelList;

  FreeAndNil(FSysInCritSec);
  FreeAndNil(FInCritSec);

  FreeAndNil(GV_ProgramTypeList);

  FreeAndNil(GV_SourceList);
  FreeAndNil(GV_DCSList);
  FreeAndNil(GV_SECList);
  FreeAndNil(GV_ChannelList);

  FreeAndNil(GV_LogCS);
end;

procedure TfrmMCC.InitializeTimelinePage;
begin
  frmTimeline := TfrmTimeline.Create(pnlTimeline, True, 0, 0, pnlTimeline.ClientWidth, pnlTimeline.ClientHeight);
  frmTimeline.Parent := pnlTimeline;
  frmTimeline.Align := alClient;
  frmTimeline.Show;
end;

procedure TfrmMCC.FinalizeTimelinePage;
begin
  if (frmTimeline <> nil) then
  begin
    FreeAndNil(frmTimeline);
  end;
end;

procedure TfrmMCC.InitializeChannelPage;
var
  I: Integer;
  OfficePage: TAdvOfficePage;
  Channel: PChannel;
  ChannelForm: TfrmPlaylist;
begin
  for I := 0 to GV_ChannelList.Count - 1 do
  begin
    Channel := GV_ChannelList[I];
    with aoPagerPlaylist do
    begin
      OfficePage := TAdvOfficePage.Create(Self);
      OfficePage.AdvOfficePager := aoPagerPlaylist;
      OfficePage.Caption := Channel^.Name;
      OfficePage.Tag := Channel^.ID;

      ChannelForm := TfrmPlaylist.Create(OfficePage, Channel^.ID, True, 0, 0, OfficePage.ClientWidth, OfficePage.ClientHeight);
      ChannelForm.Parent := OfficePage;
      ChannelForm.Align := alClient;
      ChannelForm.Show;
    end;
  end;

  if (GV_ChannelList.Count > 0) then
    aoPagerPlaylist.ActivePageIndex := 0;
end;

procedure TfrmMCC.FinalizeChannelPage;
var
  I: Integer;
  OfficePage: TAdvOfficePage;
  ChannelForm: TfrmPlaylist;
begin
  for I := aoPagerPlaylist.AdvPageCount - 1 downto 0 do
  begin
    if (I > 0) then
    begin
      OfficePage := aoPagerPlaylist.AdvPages[I];
      if (OfficePage <> nil) then
      begin
        if (OfficePage.ControlCount > 0) then
        begin
          ChannelForm := TfrmPlaylist(OfficePage.Controls[0]);
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

procedure TfrmMCC.InitializeDevicePage;
var
  DeviceForm: TfrmDevice;
begin
  with aopDevice do
  begin
    DeviceForm := TfrmDevice.Create(aopDevice, True, 0, 0, aopDevice.ClientWidth, aopDevice.ClientHeight);
    DeviceForm.Parent := aopDevice;
    DeviceForm.Align := alClient;
    DeviceForm.Show;
  end;
end;

procedure TfrmMCC.FinalizeDevicePage;
var
  DeviceForm: TfrmDevice;
begin
  DeviceForm := GetDeviceForm;
  if (DeviceForm <> nil) then
  begin
    FreeAndNil(DeviceForm);
  end;
end;

procedure TfrmMCC.DeviceOpen;
begin
  frmStartSplash.DeviceOpen;
end;

procedure TfrmMCC.DeviceClose;
var
  I, J: Integer;
  R: Integer;
  SourceHandle: PSourceHandle;
begin
//exit;
  for I := GV_SourceList.Count - 1 downto 0 do
  begin
    if (GV_SourceList[I]^.Handles <> nil) then
    begin
      for J := 0 to GV_SourceList[I]^.Handles.Count - 1 do
      begin
        SourceHandle := GV_SourceList[I]^.Handles[J];

        if (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
        begin
          R := DCSClose(SourceHandle^.DCS^.ID, SourceHandle^.Handle);
          if (R <> D_OK) then
//            ShowMessage(Format('Close Failed ID=%d, Handle=%d, Name=%s', [SourceHandle^.DCSID, SourceHandle^.Handle, GV_SourceList[I]^.Name]))
            Assert(False, GetMainLogStr(lsError, @LSE_DCSCloseDeviceFailed, [R, SourceHandle^.DCS^.ID, String(GV_SourceList[I]^.Name), SourceHandle^.Handle]))
          else
            Assert(False, GetMainLogStr(lsNormal, @LS_DCSCloseDeviceSuccess, [SourceHandle^.DCS^.ID, String(GV_SourceList[I]^.Name), SourceHandle^.Handle]));
        end;
      end;
    end;
  end;
end;

procedure TfrmMCC.actEditTimelineGotoCurrentExecute(Sender: TObject);
begin
  inherited;
  frmTimeline.TimelineGotoCurrent;
end;

procedure TfrmMCC.actEditTimelineMoveLeftExecute(Sender: TObject);
begin
  inherited;
  frmTimeline.TimelineMoveLeft;
end;

procedure TfrmMCC.actEditTimelineMoveRightExecute(Sender: TObject);
begin
  inherited;
  frmTimeline.TimelineMoveRight;
end;

procedure TfrmMCC.actEditTimelineZoomInExecute(Sender: TObject);
begin
  inherited;

  if (frmTimeline <> nil) then
    frmTimeline.TimelineZoomIn;
end;

procedure TfrmMCC.actEditTimelineZoomOutExecute(Sender: TObject);
begin
  inherited;

  if (frmTimeline <> nil) then
    frmTimeline.TimelineZoomOut;
end;

procedure TfrmMCC.actFileCloseExecute(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmMCC.TimerThreadEvent(Sender: TObject);
begin
  PostMessage(Handle, WM_UPDATE_CURRENT_TIME, 0, 0);
//  PostMessage(Handle, WM_UPDATE_DEVICESTATUS, 0, 0);
end;

procedure TfrmMCC.lblCurrentTimeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if (WMTitleBar.Active) and (WMTitleBar.MoveEnabled) then
  begin
    ReleaseCapture;
    SendMessage(Handle, WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfrmMCC.TimelineZoomIn;
//var
//  ChannelForm: TfrmPlaylist;
begin
  inherited;
{  if (aoPagerPlaylist.ActivePageIndex <= 0) then exit;

  ChannelForm := GetPlaylistFormByChannelID(aoPagerPlaylist.ActivePage.Tag);
  if (ChannelForm <> nil) then
  begin
    ChannelForm.TimelineZoomIn;
  end; }
end;

procedure TfrmMCC.TimelineZoomOut;
//var
//  ChannelForm: TfrmPlaylist;
begin
  inherited;
{  if (aoPagerPlaylist.ActivePageIndex <= 0) then exit;

  ChannelForm := GetPlaylistFormByChannelID(aoPagerPlaylist.ActivePage.Tag);
  if (ChannelForm <> nil) then
  begin
    ChannelForm.TimelineZoomOut;
  end;  }
end;

function TfrmMCC.GetChannelFormByID(AChannelID: Word): TfrmPlaylist;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to aoPagerPlaylist.AdvPageCount - 1 do
  begin
    if (aoPagerPlaylist.AdvPages[I].Tag = AChannelID) then
    begin
      if (aoPagerPlaylist.AdvPages[I].ControlCount > 0) then
        Result := TfrmPlaylist(aoPagerPlaylist.AdvPages[I].Controls[0]);
      break;
    end;
  end;
end;

function TfrmMCC.GetDeviceForm: TfrmDevice;
begin
  Result := nil;

  if (HandleAllocated) then
  begin
    if (aopDevice.ControlCount > 0) then
    begin
      Result := TfrmDevice(aopDevice.Controls[0]);
    end;
  end;
end;

procedure TfrmMCC.UDPSysInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
var
  SaveLen: Integer;
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
label
  GotoProcess;
begin
  FSysInCritSec.Enter;
  try
    if (ADataSize <= 0) then exit;

    SaveLen := Length(FSysRecvBuffer);
    SetLength(FSysRecvBuffer, SaveLen + ADataSize);
    Move(AData[1], FSysRecvBuffer[SaveLen + 1], ADataSize);

    if Length(FSysRecvBuffer) < 1 then exit;

    GotoProcess:

    case Ord(FSysRecvBuffer[1]) of
      $02:
      begin
        if (Length(FSysRecvBuffer) < 2) then exit;

        ByteCount := PAnsiCharToWord(@FSysRecvBuffer[2]);
        if (Length(FSysRecvBuffer) >= ByteCount + 4) then
        begin
          if CheckSum(FSysRecvBuffer) then
          begin
            CMD1 := Ord(FSysRecvBuffer[4]);
            CMD2 := Ord(FSysRecvBuffer[5]);

            FSysRecvData := System.Copy(FSysRecvBuffer, 6, ByteCount - 2);

            case CMD1 of
              $00: // 0X10 System Control
              begin
                case CMD2 of
                  $00: // Is Alive
                  begin
//                    R := MCCIsAlive(FSysRecvData);
                    R := MCCIsAlive(IsAlive);
                    if (R = D_OK) then
                      SendBuffer := BoolToAnsiString(IsAlive);
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
{                    $00:
                    begin
                      TransmitSysAck(ABindingIP, FUDPSysOut.Port);
                    end; }
                    $00: TransmitSysResponse(ABindingIP, FUDPSysOut.Port, CMD1, CMD2, SendBuffer, Length(SendBuffer));
                  end;
                end;
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

          if (Length(FSysRecvBuffer) > ByteCount + 4) then
          begin
            FSysRecvBuffer := Copy(FSysRecvBuffer, ByteCount + 5, Length(FSysRecvBuffer));
            Goto GotoProcess;
          end
          else
            FSysRecvBuffer := '';
        end;
      end;
      else
      begin
  //      FUDPOut.Send(ABindingIP, AnsiChar(D_ERR) + IntToAnsiString(E_UNDEFIND_COMMAND));
        TransmitSysError(ABindingIP, FUDPSysOut.Port, E_UNDEFIND_COMMAND);
        FSysRecvBuffer := '';
      end;
    end;
  finally
    FSysInCritSec.Leave;
  end;
end;

procedure TfrmMCC.UDPInRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
var
  SaveLen: Integer;
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
label
  GotoProcess;
begin
  FInCritSec.Enter;
  try
    if (ADataSize <= 0) then exit;

    SaveLen := Length(FRecvBuffer);
    SetLength(FRecvBuffer, SaveLen + ADataSize);
    Move(AData[1], FRecvBuffer[SaveLen + 1], ADataSize);

    if Length(FRecvBuffer) < 1 then exit;

    GotoProcess:

    case Ord(FRecvBuffer[1]) of
      $02:
      begin
        if (Length(FRecvBuffer) < 2) then exit;

        ByteCount := PAnsiCharToWord(@FRecvBuffer[2]);
        if (Length(FRecvBuffer) >= ByteCount + 4) then
        begin
          if CheckSum(FRecvBuffer) then
          begin
            CMD1 := Ord(FRecvBuffer[4]);
            CMD2 := Ord(FRecvBuffer[5]);

            FRecvData := System.Copy(FRecvBuffer, 6, ByteCount - 2);

            case CMD1 of
              $00: // 0X10 System Control
              begin
                case CMD2 of
  {                $00: // Device Open
                  begin
                    R := MCCOpen(FRecvData);
                  end;
                  $01: // Device Close
                  begin
                    R := MCCClose(FRecvData);
                  end;
                  $02: // Is Alive
                  begin
                    R := MCCIsAlive(FRecvData);
                  end; }
                  $00: // Is Alive
                  begin
//                    R := MCCIsAlive(FRecvData);
                    R := MCCIsAlive(IsAlive);
                    if (R = D_OK) then
                      SendBuffer := BoolToAnsiString(IsAlive);
                  end;
                end;
              end;
              $10: // 0X10 Immediate Control
              begin
              end;
              $20: // 0X20 Preset/Select Commands
              begin
              end;
              $30: // 0X30 Sense Queries
              begin
              end;
              $40: // 0X40 Event Control
              begin
                case CMD2 of
                  $00: // Begin Update
                  begin
                    R := MCCBeginUpdate(FRecvData);
                  end;
                  $01: // End Update
                  begin
                    R := MCCEndUpdate(FRecvData);
                  end;
                  $02: // Set DeviceCommError
                  begin
                    R := MCCSetDeviceCommError(FRecvData);
                  end;
                  $03: // Set DeviceStatus
                  begin
                    R := MCCSetDeviceStatus(FRecvData);
                  end;
                  $10: // Set OnAir
                  begin
                    R := MCCSetOnAir(FRecvData);
                  end;
                  $11: // Set EventStatus
                  begin
                    R := MCCSetEventStatus(FRecvData);
                  end;
                  $12: // Set MediaStatus
                  begin
                    R := MCCSetMediaStatus(FRecvData);
                  end;
                  $20: // Input CueSheet
                  begin
                    R := MCCInputCueSheet(FRecvData);
  //                  if R = D_OK then SendBuffer := AnsiChar($04);
                  end;
                  $21: // Delete CueSheet
                  begin
                    R := MCCDeleteCueSheet(FRecvData);
                  end;
                  $22: // Clear CueSheet
                  begin
                    R := MCCClearCueSheet(FRecvData);
                  end;
                  $30: // Set Current CueSheet
                  begin
                    R := MCCSetCueSheetCurr(FRecvData);
                  end;
                  $31: // Set Next CueSheet
                  begin
                    R := MCCSetCueSheetNext(FRecvData);
                  end;
                  $32: // Set Target CueSheet
                  begin
                    R := MCCSetCueSheetTarget(FRecvData);
                  end;
                end;
              end;
            end;

            if (R = D_OK) then
            begin
  //            TransmitResponse(ABindingIP, FUDPOut.Port, CMD1, CMD2, SendBuffer, Length(SendBuffer));
              case CMD1 of
                $00: // System Control (0X00)
                begin
                  case CMD2 of
{                    $00,
                    $01,
                    $02:
                    begin
                      TransmitAck(ABindingIP, FUDPOut.Port);
                    end; }
                    $00: TransmitSysResponse(ABindingIP, FUDPSysOut.Port, CMD1, CMD2, SendBuffer, Length(SendBuffer));
                  end;
                end;
                $10: // Immediate Control (0X10)
                begin
                  TransmitAck(ABindingIP, FUDPOut.Port);
                end;
                $20: // Preset/Select Commands (0X20)
                begin
                  TransmitAck(ABindingIP, FUDPOut.Port);
                end;
                $30: // Preset/Select Commands (0X20)
                begin
                  TransmitResponse(ABindingIP, FUDPOut.Port, CMD1, CMD2, SendBuffer, Length(SendBuffer));
                end;
                $40: // Event Control (0X40)
                begin
                  case CMD2 of
                    $00,
                    $01,
                    $02,
                    $03,
                    $10,
                    $11,
                    $12: TransmitAck(ABindingIP, FUDPOut.Port);
                    $20,
                    $21,
                    $22: TransmitAck(ABindingIP, FUDPOut.Port);
                    $30,
                    $31,
                    $32,
                    $34: TransmitAck(ABindingIP, FUDPOut.Port);
                  end;
                end;
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

          if (Length(FRecvBuffer) > ByteCount + 4) then
          begin
            FRecvBuffer := Copy(FRecvBuffer, ByteCount + 5, Length(FRecvBuffer));
            Goto GotoProcess;
          end
          else
            FRecvBuffer := '';
        end;
      end;
      else
      begin
  //      FUDPOut.Send(ABindingIP, AnsiChar(D_ERR) + IntToAnsiString(E_UNDEFIND_COMMAND));
        TransmitError(ABindingIP, FUDPOut.Port, E_UNDEFIND_COMMAND);
        FRecvBuffer := '';
      end;
    end;
  finally
    FInCritSec.Leave;
  end;
end;

// 0X00 System Control
function TfrmMCC.MCCOpen(ABuffer: AnsiString): Integer;
var
  AID: Word;
  AName: String;
begin
  Result := E_INVALID_ID;

  AID := PAnsiCharToWord(@ABuffer[1]);
  AName := Copy(ABuffer, 3, Length(ABuffer));
  if (GV_SettingGeneral.ID = AID) and
     (GV_SettingGeneral.Name = AName) then
  begin
    Result := D_OK;
  end;
end;

function TfrmMCC.MCCClose(ABuffer: AnsiString): Integer;
var
  AID: Word;
begin
  Result := E_INVALID_ID;

  AID := PAnsiCharToWord(@ABuffer[1]);
  if (GV_SettingGeneral.ID = AID) then
  begin
    Result := D_OK;
  end;
end;

//function TfrmMCC.MCCIsAlive(ABuffer: AnsiString): Integer;
function TfrmMCC.MCCIsAlive(var AIsAlive: Boolean): Integer;
var
  AID: Word;
begin
  Result := D_FALSE;

  AIsAlive := True;

  Result := D_OK;

{  Result := E_INVALID_ID;

  AID := PAnsiCharToWord(@ABuffer[1]);
  if (GV_SettingGeneral.ID = AID) then
  begin
    Result := D_OK;
  end; }
end;

// 0X40 CueSheet Control
function TfrmMCC.MCCBeginUpdate(ABuffer: AnsiString): Integer;
var
  ChannelID: Word;
  ChannelForm: TfrmPlaylist;
begin
  Result := D_FALSE;

  ChannelID := PAnsiCharToWord(@ABuffer[1]);

  ChannelForm := GetChannelFormByID(ChannelID);
  if (ChannelForm <> nil) then
  begin
    Result := ChannelForm.MCCBeginUpdate;
  end;
end;

function TfrmMCC.MCCEndUpdate(ABuffer: AnsiString): Integer;
var
  ChannelID: Word;
  ChannelForm: TfrmPlaylist;
begin
  Result := D_FALSE;

  ChannelID := PAnsiCharToWord(@ABuffer[1]);

  ChannelForm := GetChannelFormByID(ChannelID);
  if (ChannelForm <> nil) then
  begin
    Result := ChannelForm.MCCEndUpdate;
  end;
end;

function TfrmMCC.MCCSetDeviceCommError(ABuffer: AnsiString): Integer;
var
  DeviceStatus: TDeviceStatus;
  DeviceName: String;
  DeviceForm: TfrmDevice;
begin
  Result := D_FALSE;

  Move(ABuffer[1], DeviceStatus, SizeOf(TDeviceStatus));
  DeviceName := Copy(ABuffer, SizeOf(TDeviceStatus) + 1, Length(ABuffer));

  DeviceForm := frmMCC.GetDeviceForm;
  if (DeviceForm <> nil) then
    Result := DeviceForm.MCCSetDeviceCommError(DeviceStatus, DeviceName);
end;

function TfrmMCC.MCCSetDeviceStatus(ABuffer: AnsiString): Integer;
var
  DCSID: Word;
  DCS: PDCS;

  DeviceHandle: TDeviceHandle;
  DeviceStatus: TDeviceStatus;
  DeviceForm: TfrmDevice;
begin
  Result := D_FALSE;

  DCSID := PAnsiCharToWord(@ABuffer[1]);
  DeviceHandle := PAnsiCharToInt(@ABuffer[3]);
  Move(ABuffer[7], DeviceStatus, SizeOf(TDeviceStatus));

  DeviceForm := frmMCC.GetDeviceForm;
  if (DeviceForm <> nil) then
    Result := DeviceForm.MCCSetDeviceStatus(DCSID, DeviceHandle, DeviceStatus);
end;

function TfrmMCC.MCCSetOnAir(ABuffer: AnsiString): Integer;
var
  ChannelID: Word;
  IsOnAir: Boolean;
  ChannelForm: TfrmPlaylist;
begin
  Result := D_FALSE;

  ChannelID := PAnsiCharToWord(@ABuffer[1]);
  IsOnAir   := PAnsiCharToBool(@ABuffer[3]);

  ChannelForm := GetChannelFormByID(ChannelID);
  if (ChannelForm <> nil) then
  begin
    Result := ChannelForm.MCCSetOnAir(IsOnAir);
  end;
end;

function TfrmMCC.MCCSetEventStatus(ABuffer: AnsiString): Integer;
var
  EventID: TEventID;
  EventStatus: TEventStatus;
  ChannelForm: TfrmPlaylist;
begin
  Result := D_FALSE;

  Move(ABuffer[1], EventID, SizeOf(TEventID));
  Move(ABuffer[SizeOf(TEventID) + 1], EventStatus, SizeOf(TEventStatus));

  ChannelForm := GetChannelFormByID(EventID.ChannelID);
  if (ChannelForm <> nil) then
  begin
    Result := ChannelForm.MCCSetEventStatus(EventID, EventStatus);
  end;
end;

function TfrmMCC.MCCSetMediaStatus(ABuffer: AnsiString): Integer;
var
  EventID: TEventID;
  MediaStatus: TMediaStatus;
  ChannelForm: TfrmPlaylist;
begin
  Result := D_FALSE;

  Move(ABuffer[1], EventID, SizeOf(TEventID));
  Move(ABuffer[SizeOf(TEventID) + 1], MediaStatus, SizeOf(TMediaStatus));

  ChannelForm := GetChannelFormByID(EventID.ChannelID);
  if (ChannelForm <> nil) then
  begin
    Result := ChannelForm.MCCSetMediaStatus(EventID, MediaStatus);
  end;
end;

function TfrmMCC.MCCInputCueSheet(ABuffer: AnsiString): Integer;
var
  Index: Integer;
  CueSheetItem: TCueSheetItem;
  ChannelForm: TfrmPlaylist;
begin
  Result := D_FALSE;

  Index := PAnsiCharToInt(@ABuffer[1]);
  Move(ABuffer[5], CueSheetItem, SizeOf(TCueSheetItem));

  ChannelForm := GetChannelFormByID(CueSheetItem.EventID.ChannelID);
  if (ChannelForm <> nil) then
  begin
    Result := ChannelForm.MCCInputCueSheet(Index, CueSheetItem);
  end;
end;

function TfrmMCC.MCCDeleteCueSheet(ABuffer: AnsiString): Integer;
var
  EventID: TEventID;
  ChannelForm: TfrmPlaylist;
begin
  Result := D_FALSE;

  Move(ABuffer[1], EventID, SizeOf(TEventID));

  ChannelForm := GetChannelFormByID(EventID.ChannelID);
  if (ChannelForm <> nil) then
  begin
    Result := ChannelForm.MCCDeleteCueSheet(EventID);
  end;
end;

function TfrmMCC.MCCClearCueSheet(ABuffer: AnsiString): Integer;
var
  ChannelID: Word;
  ChannelForm: TfrmPlaylist;
begin
  Result := D_FALSE;

  ChannelID := PAnsiCharToWord(@ABuffer[1]);

  ChannelForm := GetChannelFormByID(ChannelID);
  if (ChannelForm <> nil) then
  begin
    Result := ChannelForm.MCCClearCueSheet;
  end;
end;

function TfrmMCC.MCCSetCueSheetCurr(ABuffer: AnsiString): Integer;
var
  EventID: TEventID;
  ChannelForm: TfrmPlaylist;
begin
  Result := D_FALSE;

  Move(ABuffer[1], EventID, SizeOf(TEventID));

//  ShowMessage(Format('MCCSetCueSheetCurr, EventID = %s', [EventIDToString(EventID)]));
  ChannelForm := GetChannelFormByID(EventID.ChannelID);
  if (ChannelForm <> nil) then
  begin
    Result := ChannelForm.MCCSetCueSheetCurr(EventID);
  end;
end;

function TfrmMCC.MCCSetCueSheetNext(ABuffer: AnsiString): Integer;
var
  EventID: TEventID;
  ChannelForm: TfrmPlaylist;
begin
  Result := D_FALSE;

  Move(ABuffer[1], EventID, SizeOf(TEventID));

//  ShowMessage(Format('MCCSetCueSheetNext, EventID = %s', [EventIDToString(EventID)]));
  ChannelForm := GetChannelFormByID(EventID.ChannelID);
  if (ChannelForm <> nil) then
  begin
    Result := ChannelForm.MCCSetCueSheetNext(EventID);
  end;
end;

function TfrmMCC.MCCSetCueSheetTarget(ABuffer: AnsiString): Integer;
var
  EventID: TEventID;
  ChannelForm: TfrmPlaylist;
begin
  Result := D_FALSE;

  Move(ABuffer[1], EventID, SizeOf(TEventID));

  ChannelForm := GetChannelFormByID(EventID.ChannelID);
  if (ChannelForm <> nil) then
  begin
    Result := ChannelForm.MCCSetCueSheetTarget(EventID);
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
