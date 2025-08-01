unit UnitConsts;

interface

uses Winapi.Windows, System.Classes, System.SysUtils, Vcl.Forms, System.IniFiles,
  System.SyncObjs, System.DateUtils, Winapi.Messages, Vcl.Graphics, Generics.Collections,
  UnitCommons, UnitBaseSerial, UnitDeviceThread,
  UnitDevicePCSMedia, UnitDevicePCSCG, UnitDevicePCSSwitcher,
  UnitDeviceLOUTH,
  UnitDeviceOMNEON,
  UnitDeviceLINE,
  UnitDeviceK3DAsyncEngine, UnitDeviceTAPI,
  UnitDeviceVTS, UnitDeviceK2ESwitcher,
  UnitDeviceImagineLRC, UnitDeviceGrassValleyRCL, UnitDeviceQuartz, UnitDeviceUthaRCP3;

const
  // Window message
  WM_UPDATE_CURRENT_TIME  = WM_USER + $1001;
  WM_UPDATE_ACTIVATE      = WM_USER + $1002;

  WM_UPDATE_CHANNEL_TIME  = WM_USER + $2001;
  WM_UPDATE_CHANNEL_ONAIR = WM_USER + $2101;

  WM_UPDATE_CURR_EVENT    = WM_USER + $3001;
  WM_UPDATE_NEXT_EVENT    = WM_USER + $3002;
  WM_UPDATE_TARGET_EVENT  = WM_USER + $3003;

  WM_UPDATE_DEVICE_COMM_ERROR = WM_USER + $4001;
  WM_UPDATE_DEVICE_STATUS     = WM_USER + $4002;
  WM_UPDATE_DEVICE_CONTROLBY  = WM_USER + $4003;

  WM_EXECUTE_EVENT_LIST_CHECK = WM_USER + $5001;
  WM_EXECUTE_LOG_COMMON_LIST_CHECK = WM_USER + $5011;
  WM_EXECUTE_LOG_DEVICE_LIST_CHECK = WM_USER + $5021;

  WM_INSERT_EVENT = WM_USER + $7011;
  WM_UPDATE_EVENT = WM_USER + $7012;
  WM_DELETE_EVENT = WM_USER + $7013;
  WM_CLEAR_EVENT  = WM_USER + $7014;
  WM_UPDATE_EVENT_STATUS = WM_USER + $7021;

  WM_ADD_LOG_COMMON                = WM_USER + $8001;

  WM_ADD_LOG_DEVICE                = WM_USER + $8011;

  // Event List
  CNT_EVENT_HEADER            = 1;
  CNT_EVENT_COLUMNS           = 9;

  // Device Control & Status
  CNT_DEVICE_HEADER           = 1;
  CNT_DEVICE_COLUMNS          = 7;

  // Common Log
  CNT_LOG_COMMON_HEADER   = 1;
  CNT_LOG_COMMON_COLUMNS  = 2;

  // Device Control Log
  CNT_LOG_DEVICE_HEADER  = 1;
  CNT_LOG_DEVICE_COLUMNS = 4;

var
  // Event List Column Index
  IDX_COL_EVENT_NO: Word            = 0;
  IDX_COL_EVENT_START_TYPE: Word    = 1;
  IDX_COL_EVENT_START_TIME: Word    = 2;
  IDX_COL_EVENT_DURATON: Word       = 3;
  IDX_COL_EVENT_STATUS: Word        = 4;
  IDX_COL_EVENT_SOURCE: Word        = 5;
  IDX_COL_EVENT_MEADIA_ID: Word     = 6;
  IDX_COL_EVENT_START_TC: Word      = 7;
  IDX_COL_EVENT_NOTES: Word         = 8;

  // Event List Column Name
  NAM_COL_EVENT_NO: String              = 'No';
  NAM_COL_EVENT_START_TYPE: String      = 'Type';
  NAM_COL_EVENT_START_TIME: String      = 'Start Time';
  NAM_COL_EVENT_DURATON: String         = 'Duration';
  NAM_COL_EVENT_STATUS: String          = 'Status';
  NAM_COL_EVENT_SOURCE: String          = 'Source';
  NAM_COL_EVENT_MEDIA_ID: String        = 'Media ID';
  NAM_COL_EVENT_START_TC: String        = 'Start TC';
  NAM_COL_EVENT_NOTES: String           = 'Notes';

  // Event List Column Width
  WIDTH_COL_EVENT_NO: Integer            = 30;
  WIDTH_COL_EVENT_START_TYPE: Integer    = 60;
  WIDTH_COL_EVENT_START_TIME: Integer    = 164;
  WIDTH_COL_EVENT_DURATON: Integer       = 84;
  WIDTH_COL_EVENT_STATUS: Integer        = 70;
  WIDTH_COL_EVENT_SOURCE: Integer        = 180;
  WIDTH_COL_EVENT_MEADIA_ID: Integer     = 200;
  WIDTH_COL_EVENT_START_TC: Integer      = 84;
  WIDTH_COL_EVENT_NOTES: Integer         = 160;

  // Event select
  COLOR_ROW_SELECT_EVENT: TColor = $00FFAB1D;//$00FFBDAD;

  // Event Status Color
  COLOR_BK_EVENTSTATUS_NORMAL: TColor = $00261B1B;//$003A2C28;
  COLOR_BK_EVENTSTATUS_NEXT: TColor = $00D4807A;//clSkyBlue;
  COLOR_BK_EVENTSTATUS_CUED: TColor = $000BA9B8;
  COLOR_BK_EVENTSTATUS_ONAIR: TColor = $0090BD4A;//clMoneyGreen;
  COLOR_BK_EVENTSTATUS_DONE: TColor = $00392F2D;//clDkGray;
  COLOR_BK_EVENTSTATUS_ERROR: TColor = $003817A5;//clRed;
  COLOR_BK_EVENTSTATUS_TARGET: TColor = $00AB7F53;//clAqua;

  COLOR_TX_EVENTSTATUS_NORMAL: TColor = $00B8B8B8;//clSilver;
  COLOR_TX_EVENTSTATUS_NEXT: TColor = clBlack;
  COLOR_TX_EVENTSTATUS_CUED: TColor = clBlack;
  COLOR_TX_EVENTSTATUS_ONAIR: TColor = clBlack;
  COLOR_TX_EVENTSTATUS_DONE: TColor = $006F6261;//clSilver;
  COLOR_TX_EVENTSTATUS_ERROR: TColor = clWhite;
  COLOR_TX_EVENTSTATUS_TARGET: TColor = clBlack;

  // Device List Column Index
  IDX_COL_DEVICE_NO: Word        = 0;
  IDX_COL_DEVICE_NAME: Word      = 1;
  IDX_COL_DEVICE_STATUS: Word    = 2;
  IDX_COL_DEVICE_TIMECODE: Word  = 3;
  IDX_COL_DEVICE_CONTROLBY: Word = 4;
  IDX_COL_DEVICE_CHANNEL: Word   = 5;
  IDX_COL_DEVICE_EVENT: Word     = 6;

  // Device List Column Name
  NAM_COL_DEVICE_NO: String         = 'No';
  NAM_COL_DEVICE_NAME: String       = 'Device';
  NAM_COL_DEVICE_STATUS: String     = 'Status';
  NAM_COL_DEVICE_TIMECODE: String   = 'Timecode';
  NAM_COL_DEVICE_CONTROLBY: String  = 'Control By';
  NAM_COL_DEVICE_CHANNEL: String    = 'Channel';
  NAM_COL_DEVICE_EVENT: String      = 'Event';

  // Device List Column Width
  WIDTH_COL_DEVICE_NO: Integer        = 30;
  WIDTH_COL_DEVICE_NAME: Integer      = 100;
  WIDTH_COL_DEVICE_STATUS: Integer    = 130;
  WIDTH_COL_DEVICE_TIMECODE: Integer  = 84;
  WIDTH_COL_DEVICE_CONTROLBY: Integer = 100;
  WIDTH_COL_DEVICE_CHANNEL: Integer   = 130;
  WIDTH_COL_DEVICE_EVENT: Integer     = 400;

  // Device Status Color
  COLOR_BK_DEVICESTATUS_NORMAL: TColor = $00261B1B;
  COLOR_BK_DEVICESTATUS_ERROR: TColor = $003817A5;

  COLOR_TX_DEVICESTATUS_NORMAL: TColor = $00B8B8B8;
  COLOR_TX_DEVICESTATUS_ERROR: TColor = clWhite;

  // Common Log List Column Index
  IDX_COL_LOG_COMMON_TIME: Word       = 0;
  IDX_COL_LOG_COMMON_LOG: Word        = 1;

  // Common Log List Column Name
  NAM_COL_LOG_COMMON_TIME: String       = 'Time';
  NAM_COL_LOG_COMMON_LOG: String        = 'Log';

  // Common Log List Column Width
  WIDTH_COL_LOG_COMMON_TIME: Integer      = 184;
  WIDTH_COL_LOG_COMMON_LOG: Integer       = 700;

  // Common Log List Color
  COLOR_BK_LOG_COMMON_NORMAL: TColor = $00261B1B;
  COLOR_BK_LOG_COMMON_ERROR: TColor = $003817A5;

  COLOR_TX_LOG_COMMON_NORMAL: TColor = $00B8B8B8;
  COLOR_TX_LOG_COMMON_ERROR: TColor = clWhite;

  // Device Control Log
  IDX_COL_LOG_DEVICE_TIME: Word           = 0;
  IDX_COL_LOG_DEVICE_CONTROLBY: Word      = 1;
  IDX_COL_LOG_DEVICE_CHANNEL: Word        = 2;
  IDX_COL_LOG_DEVICE_LOG: Word            = 3;

  // Device Control Log Column Name
  NAM_COL_LOG_DEVICE_TIME: String       = 'Time';
  NAM_COL_LOG_DEVICE_CONTROLBY: String  = 'Control By';
  NAM_COL_LOG_DEVICE_CHANNEL: String    = 'Channel';
  NAM_COL_LOG_DEVICE_LOG: String        = 'Log';

  // Device Control Log Column Width
  WIDTH_COL_LOG_DEVICE_TIME: Integer      = 184;
  WIDTH_COL_LOG_DEVICE_CONTROLBY: Integer = 120;
  WIDTH_COL_LOG_DEVICE_CHANNEL: Integer   = 150;
  WIDTH_COL_LOG_DEVICE_LOG: Integer       = 700;

  // Device Control Log Each Color
  COLOR_BK_LOG_DEVICE_NORMAL: TColor = $00261B1B;
  COLOR_BK_LOG_DEVICE_ERROR: TColor = $003817A5;

  COLOR_TX_LOG_DEVICE_NORMAL: TColor = $00B8B8B8;
  COLOR_TX_LOG_DEVICE_ERROR: TColor = clWhite;

type
  TConfigGeneral = record
    HostIP: String;
    SysInPort: Word;
    SysOutPort: Word;
    NotifyPort: Word;
    NotifyBroadcast: Boolean;
    InPort: Word;
    OutPort: Word;
    EventStatusNotifyPort: Word;
    CrossCheckPort: Word;
    LogPath: String;
    LogExt: String;
    PortLogPath: String;
    PortLogExt: String;
    UDPLogEnable: Boolean;
    UDPLogPath: String;
    UDPLogExt: String;
  end;

  TConfigOption = record
    EventListCheckInterval: TTimecode;
    EventListCheckTime: TTimecode;
    LogListCheckInterval: TTimecode;
    MaxLogListHasCount: Integer;
    OnAirEventHighlight: Boolean;
    OnAirEventFixedRow: Word;
  end;

  TConfigCrossCheck = record
    NumCrossCheck: Word;
    CrossCheckInterval: TTimecode;
    CrossCheckTimeout: TTimecode;
  end;

  TSerialGate = packed record
    HostIP: array[0..HOSTIP_LEN] of Char;
    Port: Word;
    Mine: Boolean;
    Id: array[0..USERID_LEN] of Char;
    Password: array[0..PASSWORD_LEN] of Char;
  end;
  PSerialGate = ^TSerialGate;
  TSerialGateList = TList<PSerialGate>;

  TConfigSerialGate = record
    Use: Boolean;
    CommandTimeout: TTimecode;
    SerialGateList: TSerialGateList;
  end;

  TConfigCueTime = record
    CueTime: TTimecode;
  end;
  PConfigCueTime = ^TConfigCueTime;
  TConfigCueTimeList = TList<PConfigCueTime>;

  TConfigEventMCS = record
    NumPSTSet: Integer;
    PSTSetTime: TConfigCueTimeList;
    PSTSetDelayTime: TTimecode;
    CommandTimeout: TTimecode;
    CueTimeout: TTimecode;
    TrRateCutTime: Integer;
    TrRateFastTime: Integer;
    TrRateMediumTime: Integer;
    TrRateSlowTime: TTimecode;
  end;

  TConfigEventVCR = record
    NumCue: Integer;
    CueTime: TConfigCueTimeList;
    StandbyOffAfterCue: Boolean;
    StandbyOffDelayTime: TTimecode;
    StandbyOnTime: TTimecode;
    PrerollTime: TTimecode;
    BackgroundEventPreparation: Boolean;
    CommandTimeout: TTimecode;
    CueTimeout: TTimecode;
    FinishActionDelayTime: TTimecode;
    FinishActionTimeout: TTimecode;
  end;

  TConfigEventVS = record
    NumCue: Integer;
    CueTime: TConfigCueTimeList;
    AdvancedStartTime: TTimecode;
    BackgroundEventPreparation: Boolean;
    CommandTimeout: TTimecode;
    CueTimeout: TTimecode;
    FinishActionDelayTime: TTimecode;
    FinishActionTimeout: TTimecode;
  end;

  TConfigEventCG = record
    NumCue: Integer;
    CueTime: TConfigCueTimeList;
    AdvancedStartTime: TTimecode;
    BackgroundEventPreparation: Boolean;
    CommandTimeout: TTimecode;
    CueTimeout: TTimecode;
    FinishActionDelayTime: TTimecode;
    FinishActionTimeout: TTimecode;
  end;

  TEventItem = record
    Event: TEvent;
    Device: PDevice;
    ControlIP: array[0..HOSTIP_LEN] of Char;
  end;
  PEventItem = ^TEventItem;
  TEventItemList = TList<PEventItem>;

  TLogCommon = record
    LogState: TLogState;
    LogDateTime: TDateTime;
    LogStr: array[0..MAX_PATH] of Char;
  end;
  PLogCommon = ^TLogCommon;
  TLogCommonList = TList<PLogCommon>;

  TLogDevice = record
    ControlBy: array[0..HOSTIP_LEN] of Char;
    ControlChannel: Integer;
    LogState: TLogState;
    LogDateTime: TDateTime;
    LogStr: array[0..MAX_PATH] of Char;
  end;
  PLogDevice = ^TLogDevice;
  TLogDeviceList = TList<PLogDevice>;

var
  GV_ConfigGeneral: TConfigGeneral;
  GV_ConfigOption: TConfigOption;
  GV_ConfigCrossCheck: TConfigCrossCheck;

  GV_ConfigSerialGate: TConfigSerialGate;

  GV_ConfigEventMCS: TConfigEventMCS;
  GV_ConfigEventVCR: TConfigEventVCR;
  GV_ConfigEventVS: TConfigEventVS;
  GV_ConfigEventCG: TConfigEventCG;

  GV_DCSList: TDCSList;
  GV_DCSMain: PDCS;
  GV_DCSMine: PDCS;

  GV_DCSCritSec: TCriticalSection;

  GV_ChannelList: TChannelList;

  GV_DeviceList: TDeviceList;
  GV_DeviceThreadList: TThreadList;
  GV_DeviceHandleValue: TDeviceHandle = 0;

  GV_LogWriteLock: TCriticalSection;

  GV_LogCommonLock: TCriticalSection;
  GV_LogCommonList: TLogCommonList;

  GV_TimeBefore, GV_TimeCurrent: TSystemTime;
  GV_TimerExecuteEvent: THandle;
  GV_TimerCancelEvent: THandle;

  GV_DeviceTimerExecuteEvent: THandle;

  GV_UniqueCounter: Integer = 0;
  GV_CounterLock: TCriticalSection;


  procedure AssertProc(const AMessage, AFileName: String; ALineNumber: Integer; AErrorAddr: Pointer);

  function GetLogCommonStr(ALogState: TLogState; ALogStr: String): String;

  function WriteAssertLog(const ALogStr: String): Integer;

  procedure LoadConfig;
  procedure SaveDCSConfig;

  function GetPortConfig(AIniFile: TIniFile; ASectionName: String): TPortConfig;
  function CheckSum(AValue: AnsiString): Boolean;

  function HasMainControl: Boolean;

  function GetDCSByID(AID: Word): PDCS;

  function GetPortTypeByName(AName: String): TComPortType;
  function GetBaudRateByValue(AValue: Integer): TComPortBaudRate;
  function GetParityByName(AName: String): TComPortParity;

  function GetDeviceByHandle(AHandle: TDeviceHandle): PDevice;

  function GetDeviceHandle: TDeviceHandle;
  function GetDeviceTypeByName(AName: String): TDeviceType;
  function GetDeviceControlByName(AName: String): TControlType;
  function GetDeviceHandleByName(ADeviceName: String): TDeviceHandle;

  function GetDeviceThreadByHandle(AHandle: TDeviceHandle): TDeviceThread;

  function GetLogCommonByIndex(AIndex: Integer): PLogCommon;

  function GetChannelByID(AChannelID: Integer): PChannel;
  function GetChannelNameByID(AChannelID: Integer): String;
  function GetChannelNameByChannel(AChannel: PChannel): String;
  function GetChannelFrameRateTypeByID(AChannelID: Integer): TFrameRateType;
  function GetChannelIsDropFrameByID(AChannelID: Integer): Boolean;

  function GenerateUniqueInteger: Integer;

  procedure DeviceCreate;

  procedure DeviceOpen;
  procedure DeviceStart;
  procedure DeviceClose;

  procedure DeviceInit;

  procedure DeviceDestroy;

  procedure ClearDCSList;
  procedure ClearChannelList;
  procedure ClearDeviceList;

  procedure ClearLogCommonList;

  procedure ClearConfigEvent;
  procedure ClearConfigSerialGate;

const
  DeviceTypeNames: array[TDeviceType] of String =
    ('NONE',
     'PCS_MEDIA', 'PCS_CG', 'PCS_SWITCHER',
     'LOUTH', 'OMNEON',
     'SBC',
     'K3D', 'TAPI', 'NSC',
     'LINE',
     'VTS', 'K2E_MCS',
     'IMG_LRC', 'GV_RCL', 'QUARTZ', 'UTHA_RCP3',
     'GVM', 'GVR', 'VIK');

  ControlTypeNames: array[TControlType] of String =
    ('SERIAL', 'TCP', 'UDP');

  PortTypeNames: array[TComPortType] of String =
    ('232', '422', '485');

  BaudRates: array[TComPortBaudRate] of DWORD =
    (CBR_2400, CBR_4800, CBR_9600, CBR_14400, CBR_19200,
     CBR_38400, CBR_56000, CBR_57600, CBR_115200);

  ParityNames: array[TComPortParity] of String =
    ('None', 'Odd', 'Even', 'Mark', 'Space');

{  EventStatusNames: array[TEventStatus] of String =
    ('None', 'Error', 'Skipped', 'Idle', 'Loading', 'Loaded', 'Cueing', 'Cued',
     'StandByOff', 'StandByOn', 'Preroll', 'OnAir',
     'Finish', 'Finishing', 'Finished', 'Done'); }

implementation

uses UnitDCS, UnitLogCommon;

procedure AssertProc(const AMessage, AFileName: String; ALineNumber: Integer; AErrorAddr: Pointer);
var
  LogFilePath: String;
  LogFileName: String;
  LogStr: String;
//  DateStr, LogStr: String;

  FS: TFileStream;
  PBuffer: Pointer;
begin
  OutputDebugString(PChar(Format('%s(%dLine $%x) %s', [ExtractFileName(AFileName),
                                                       ALineNumber,
                                                       Integer(AErrorAddr),
                                                       AMessage])));

  LogStr := Format('%s %s(%dLine $%x)'#13#10, [AMessage, ExtractFileName(AFileName), ALineNumber, Integer(AErrorAddr)]);

  WriteAssertLog(LogStr);
end;

function GetLogCommonStr(ALogState: TLogState; ALogStr: String): String;
var
  LogDateTime: TDateTime;
  LogCommonForm: TfrmLogCommon;
begin
  LogDateTime := Now;

  case ALogState of
    lsError: ALogStr := Format('[Error] %s', [ALogStr]);
    lsWarning: ALogStr := Format('[Warning] %s', [ALogStr]);
  end;

  Result := Format('[%s] %s', [FormatDateTime('YYYY-MM-DD hh:nn:ss.zzz', LogDateTime), ALogStr]);

  LogCommonForm := frmDCS.GetLogCommonForm;
  if (LogCommonForm <> nil) then
  begin
    LogCommonForm.AddLog(ALogState, LogDateTime, ALogStr);
  end;
end;

function WriteAssertLog(const ALogStr: String): Integer;
var
  DivPos: Integer;
  LogDivStr: String;
  FilePath: String;
  FileName: String;
  DateStr, LogStr: String;

  FS: TFileStream;
  PBuffer: Pointer;
  byteorder_marker: Word;
begin
  GV_LogWriteLock.Enter;
  try
    FilePath := Format('%s%s%s', [GV_ConfigGeneral.LogPath,
                                  FormatDateTime('YYYY-MM', Date),
                                  PathDelim]);

    DivPos := Pos('[', ALogStr);
    if (DivPos > 0) then
    begin
      LogDivStr := Trim(Copy(ALogStr, 1, DivPos - 1));
      LogStr    := Copy(ALogStr, DivPos, Length(ALogStr));
    end;

    if (LogDivStr = '') then
    begin
      LogDivStr := GV_ConfigGeneral.LogExt;
      LogStr    := ALogStr;
    end
    else
      LogDivStr := Format('%s_%s', [LogDivStr, GV_ConfigGeneral.LogExt]);

    FileName := Format('%s%s_%s', [FilePath,
                                   FormatDateTime('YYYY-MM-DD', System.SysUtils.Date),
                                   LogDivStr]);

    // Log directory
    if (not DirectoryExists(FilePath)) then
      if (not ForceDirectories(FilePath)) then
      begin
//        MessageBeep(MB_ICONERROR);
//        MessageBox(Application.Handle, PChar(Format('Cannot create log directory %s', [FilePath])), PChar(Application.Title), MB_OK or MB_ICONERROR);
        exit;
      end;

    try
      if (not FileExists(FileName)) then
      begin
        FS := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
        FS.Size := 0;
        FS.Position := 0;

        byteorder_marker := $FEFF;
        FS.Write(byteorder_marker, sizeof(byteorder_marker));
      end
      else FS := TFileStream.Create(FileName, fmOpenWrite or fmShareDenyNone);

      try
        FS.Position := FS.Size;
        FS.Write(PWideChar(LogStr)^, SizeOf(WideChar) * Length(LogStr));
//        FS.Write(PAnsiChar(AnsiString(LogStr))^, Length(AnsiString(LogStr)));
//        FS.Write(PChar(LogStr)^, Length(LogStr));
      finally
        if (FS <> nil) then FreeAndNil(FS);
      end;
    except
//      MessageBeep(MB_ICONERROR);
//      MessageBox(Application.Handle, PChar(Format('Cannot create or open log file %s', [FileName])), PChar(Application.Title), MB_OK or MB_ICONERROR);
      exit;
    end;
  finally
    GV_LogWriteLock.Leave;
  end;
end;

function GetPortConfig(AIniFile: TIniFile; ASectionName: String): TPortConfig;
var
  PortConfigStrings: TStrings;
begin
  FillChar(Result, SizeOf(TPortConfig), #0);
  with Result do
  begin
    PortConfigStrings := TStringList.Create;
    try
      ExtractStrings([','], [' '], PChar(AIniFile.ReadString(ASectionName, 'ComPortConfig', '3,422,38400,odd,8,1')), PortConfigStrings);

      PortNum  := StrToIntDef(PortConfigStrings[0], 0);
      PortType := GetPortTypeByName(PortConfigStrings[1]);
      BaudRate := GetBaudRateByValue(StrToIntDef(PortConfigStrings[2], 0));
      Parity   := GetParityByName(PortConfigStrings[3]);
      DataBits := TComPortDataBits(StrToIntDef(PortConfigStrings[4], 0) - 5);
      StopBits := TComPortStopBits(StrToIntDef(PortConfigStrings[5], 0) - 1);
    finally
      FreeAndNil(PortConfigStrings);
    end;
  end;
end;

procedure LoadConfig;
var
  I: Integer;
  IniFile: TIniFile;
  Section, Ident: String;
  NumSerialGate: Word;
  NumDCS, NumDevice, NumChannel: Word;
  DataStrings: TStrings;

  DCS: PDCS;
  SerialGate: PSerialGate;
  Device: PDevice;
  Channel: PChannel;
  ConfigCueTime: PConfigCueTime;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'DCS.ini');
  try
    // General
    Section := 'General';
    FillChar(GV_ConfigGeneral, SizeOf(TConfigGeneral), #0);
    with GV_ConfigGeneral do
    begin
      HostIP          := IniFile.ReadString(Section, 'HostIP', '127.0.0.1');
      SysInPort       := IniFile.ReadInteger(Section, 'SysInPort', 8011);
      SysOutPort      := IniFile.ReadInteger(Section, 'SysOutPort', 8012);

      NotifyPort      := IniFile.ReadInteger(Section, 'NotifyPort', 8000);
      NotifyBroadcast := StrToBoolDef(IniFile.ReadString(Section, 'NotifyBroadcast', 'True'), False);
      InPort          := IniFile.ReadInteger(Section, 'InPort', 8001);
      OutPort         := IniFile.ReadInteger(Section, 'OutPort', 8002);
      EventStatusNotifyPort := IniFile.ReadInteger(Section, 'EventStatusNotifyPort', 8003);
      CrossCheckPort  := IniFile.ReadInteger(Section, 'CrossCheckPort', 8004);
      LogPath         := IniFile.ReadString(Section, 'LogPath', ExtractFilePath(Application.ExeName) + 'Log') + PathDelim;
      LogExt          := IniFile.ReadString(Section, 'LogExt', 'DCS.log');
      PortLogPath     := IniFile.ReadString(Section, 'PortLogPath', ExtractFilePath(Application.ExeName) + 'PortLog') + PathDelim;
      PortLogExt      := IniFile.ReadString(Section, 'PortLogExt', 'Port.log');
      UDPLogEnable    := StrToBoolDef(IniFile.ReadString(Section, 'UDPLogEnable', 'False'), False);
      UDPLogPath      := IniFile.ReadString(Section, 'UDPLogPath', ExtractFilePath(Application.ExeName) + 'UDPLog') + PathDelim;
      UDPLogExt       := IniFile.ReadString(Section, 'UDPLogExt', 'UDP.log');
    end;

    // Option
    Section := 'Option';
    FillChar(GV_ConfigOption, SizeOf(TConfigOption), #0);
    with GV_ConfigOption do
    begin
      EventListCheckInterval := StringToTimecode(IniFile.ReadString(Section, 'EventListCheckInterval', '01:00:00:00'));
      EventListCheckTime     := StringToTimecode(IniFile.ReadString(Section, 'EventListCheckTime', '06:00:00:00'));
      LogListCheckInterval   := StringToTimecode(IniFile.ReadString(Section, 'LogListCheckInterval', '01:00:00:00'));
      MaxLogListHasCount     := IniFile.ReadInteger(Section, 'MaxLogListHasCount', 1000);
      OnAirEventHighlight    := StrToBoolDef(IniFile.ReadString(Section, 'OnAirEventHighlight', 'True'), False);
      OnAirEventFixedRow     := IniFile.ReadInteger(Section, 'OnAirEventFixedRow', 0);
    end;

    // Cross Check
    Section := 'CrossCheck';
    FillChar(GV_ConfigCrossCheck, SizeOf(TConfigCrossCheck), #0);
    with GV_ConfigCrossCheck do
    begin
      NumCrossCheck       := IniFile.ReadInteger(Section, 'NumCrossCheck', 3);
      CrossCheckInterval  := StringToTimecode(IniFile.ReadString(Section, 'CrossCheckInterval', '00:00:01:00'));
      CrossCheckTimeout   := StringToTimecode(IniFile.ReadString(Section, 'CrossCheckTimeout', '00:00:01:00'));
    end;

    // Config Serial Gate
    Section := 'SerialGate';
    FillChar(GV_ConfigSerialGate, SizeOf(TConfigSerialGate), #0);
    with GV_ConfigSerialGate do
    begin
      Use := StrToBoolDef(IniFile.ReadString(Section, 'Use', 'False'), False);
      CommandTimeout  := StringToTimecode(IniFile.ReadString(Section, 'CommandTimeout', '00:00:10:00'));

      NumSerialGate := IniFile.ReadInteger(Section, 'NumSerialGate', 0);
      SerialGateList := TSerialGateList.Create;
      for I := 0 to NumSerialGate - 1 do
      begin
        Ident := Format('SerialGate%d', [I + 1]);

        SerialGate := New(PSerialGate);
        FillChar(SerialGate^, SizeOf(TSerialGate), #0);

        DataStrings := TStringList.Create;
        try
          ExtractStrings([','], [' '], PChar(IniFile.ReadString(Section, Ident, '127.0.0.1,1')), DataStrings);
          StrPLCopy(SerialGate^.HostIP, DataStrings[0], HOSTIP_LEN);
          SerialGate^.Port := StrToIntDef(DataStrings[1], 23);
          SerialGate^.Mine := StrToBoolDef(DataStrings[2], False);
          StrPLCopy(SerialGate^.Id, DataStrings[3], USERID_LEN);
          StrPLCopy(SerialGate^.Password, DataStrings[4], PASSWORD_LEN);
        finally
          FreeAndNil(DataStrings);
        end;

        SerialGateList.Add(SerialGate);
      end;
    end;

    // DCS
    // Num DCS
    Section := 'DCS';
    NumDCS := IniFile.ReadInteger(Section, 'NumDCS', 0);
    for I := 0 to NumDCS - 1 do
    begin
      Ident := Format('DCS%d', [I + 1]);

      DCS := New(PDCS);
      FillChar(DCS^, SizeOf(TDCS), #0);

      DataStrings := TStringList.Create;
      try
        ExtractStrings([','], [' '], PChar(IniFile.ReadString(Section, Ident, '0,DCS1,127.0.0.1,0,0')), DataStrings);
        DCS^.ID := StrToIntDef(DataStrings[0], 0);
        StrPLCopy(DCS^.Name, DataStrings[1], DCSNAME_LEN);
        StrPLCopy(DCS^.HostIP, DataStrings[2], HOSTIP_LEN);
        DCS^.Main := StrToBoolDef(DataStrings[3], False);
        DCS^.Mine := StrToBoolDef(DataStrings[4], False);

        if (DCS^.Main) then
          GV_DCSMain := DCS;

        if (DCS^.Mine) then
        begin
          GV_DCSMine := DCS;
        end;
      finally
        FreeAndNil(DataStrings);
      end;

      GV_DCSList.Add(DCS);
    end;

    // Device
    // Num Device
    Section := 'Device';
    NumDevice := IniFile.ReadInteger(Section, 'NumDevice', 0);

    for I := 0 to NumDevice - 1 do
    begin
      Section := Format('Device%d', [I + 1]);

      Device := New(PDevice);
      FillChar(Device^, SizeOf(TDevice), #0);

      Device^.Handle := INVALID_DEVICE_HANDLE;
      StrPLCopy(Device^.Name, IniFile.ReadString(Section, 'Name', ''), DEVICENAME_LEN);
      Device^.FrameDelay := IniFile.ReadInteger(Section, 'FrameDelay', 0);
      Device^.PortLog := StrToBoolDef(IniFile.ReadString(Section, 'PortLog', 'False'), False);
      Device^.CheckStatus := StrToBoolDef(IniFile.ReadString(Section, 'CheckStatus', 'True'), True);
      Device^.DeviceType := GetDeviceTypeByName(IniFile.ReadString(Section, 'Type', ''));
      case Device.DeviceType of
        DT_PCS_MEDIA:
        begin
          StrPLCopy(Device^.PCSMedia.HostIP, IniFile.ReadString(Section, 'HostIP', '127.0.0.1'), HOSTIP_LEN);
          Device^.PCSMedia.HostPort := IniFile.ReadInteger(Section, 'HostPort', 1000);
          Device^.PCSMedia.Scte35DelayTime := StringToTimecode(IniFile.ReadString(Section, 'Scte35DelayTime', '00:00:10:00'));
        end;
        DT_PCS_CG:
        begin
          StrPLCopy(Device^.PCSCG.HostIP, IniFile.ReadString(Section, 'HostIP', '127.0.0.1'), HOSTIP_LEN);
          Device^.PCSCG.HostPort := IniFile.ReadInteger(Section, 'HostPort', 1100);
        end;
        DT_PCS_SWITCHER:
        begin
          StrPLCopy(Device^.PCSSwitcher.HostIP, IniFile.ReadString(Section, 'HostIP', '127.0.0.1'), HOSTIP_LEN);
          Device^.PCSSwitcher.HostPort := IniFile.ReadInteger(Section, 'HostPort', 2000);
        end;
        DT_LOUTH:
        begin
          Device^.Louth.ControlType := GetDeviceControlByName(IniFile.ReadString(Section, 'Control', ''));
          case Device^.Louth.ControlType of
            ctSerial:
            begin
              Device^.Louth.PortConfig  := GetPortConfig(IniFile, Section);
              Device^.Louth.PortNo      := IniFile.ReadInteger(Section, 'PortNo', 0);
            end;
            ctTCP, ctUDP:
            begin
              StrPLCopy(Device^.Louth.HostIP, IniFile.ReadString(Section, 'HostIP', ''), HOSTIP_LEN);
              Device^.Louth.HostPort := IniFile.ReadInteger(Section, 'HostPort', 6001);
            end;
          end;
        end;
        DT_LINE: ;
        DT_OMNEON:
        begin
          StrPLCopy(Device^.Omneon.DirectorName, IniFile.ReadString(Section, 'DirectorName', ''), MAX_PATH);
          StrPLCopy(Device^.Omneon.PlayerName, IniFile.ReadString(Section, 'PlayerName', ''), MAX_PATH);
        end;
        DT_TAPI:
        begin
          StrPLCopy(Device^.Tapi.HostIP, IniFile.ReadString(Section, 'HostIP', ''), HOSTIP_LEN);
          Device^.Tapi.HostPort := IniFile.ReadInteger(Section, 'HostPort', 6001);
          StrPLCopy(Device^.Tapi.TemplatePath, IniFile.ReadString(Section, 'TemplatePath', ''), MAX_PATH);
        end;
        DT_VTS:
        begin
          Device^.Vts.PortConfig      := GetPortConfig(IniFile, Section);
          Device^.Vts.PresetDelayTake := StringToTimecode(IniFile.ReadString(Section, 'PresetDelayTake', '00:00:04:00'));
          Device^.Vts.InputChannels   := IniFile.ReadInteger(Section, 'InputChannels', 0);
          Device^.Vts.PGM             := IniFile.ReadInteger(Section, 'PGM', 0);
          Device^.Vts.PST             := IniFile.ReadInteger(Section, 'PST', 1);
          Device^.Vts.SupportKey      := StrToBoolDef(IniFile.ReadString(Section, 'SupportKey', 'False'), False);
          Device^.Vts.Key1            := IniFile.ReadInteger(Section, 'Key1', 2);
          Device^.Vts.Key2            := IniFile.ReadInteger(Section, 'Key2', 3);
          Device^.Vts.Key3            := IniFile.ReadInteger(Section, 'Key3', 4);
        end;
        DT_IMG_LRC:
        begin
          Device^.ImgLRC.ControlType := GetDeviceControlByName(IniFile.ReadString(Section, 'Control', ''));
          case Device^.ImgLRC.ControlType of
            ctSerial:
            begin
              Device^.ImgLRC.PortConfig := GetPortConfig(IniFile, Section);
            end;
            ctTCP, ctUDP:
            begin
              StrPLCopy(Device^.ImgLRC.HostIP, IniFile.ReadString(Section, 'HostIP', ''), HOSTIP_LEN);
              Device^.ImgLRC.HostPort := IniFile.ReadInteger(Section, 'HostPort', 52116);
            end;
          end;
        end;
        DT_GV_RCL:
        begin
          Device^.GvRCL.ControlType := GetDeviceControlByName(IniFile.ReadString(Section, 'Control', ''));
          case Device^.GvRCL.ControlType of
            ctSerial:
            begin
              Device^.GvRCL.PortConfig := GetPortConfig(IniFile, Section);
            end;
            ctTCP, ctUDP:
            begin
              StrPLCopy(Device^.GvRCL.HostIP, IniFile.ReadString(Section, 'HostIP', ''), HOSTIP_LEN);
              Device^.GvRCL.HostPort := IniFile.ReadInteger(Section, 'HostPort', 12345);
            end;
          end;
        end;
        DT_QUARTZ:
        begin
          Device^.Quartz.CommandErrorReset := StrToBoolDef(IniFile.ReadString(Section, 'CommandErrorReset', 'False'), False);
          Device^.Quartz.ControlType := GetDeviceControlByName(IniFile.ReadString(Section, 'Control', ''));
          case Device^.Quartz.ControlType of
            ctSerial:
            begin
              Device^.Quartz.PortConfig := GetPortConfig(IniFile, Section);
            end;
            ctTCP, ctUDP:
            begin
              StrPLCopy(Device^.Quartz.HostIP, IniFile.ReadString(Section, 'HostIP', ''), HOSTIP_LEN);
              Device^.Quartz.HostPort := IniFile.ReadInteger(Section, 'HostPort', 52116);
            end;
          end;
        end;
        DT_UTHA_RCP3:
        begin
          Device^.UthaRCP3.CommandErrorReset := StrToBoolDef(IniFile.ReadString(Section, 'CommandErrorReset', 'False'), False);
          Device^.UthaRCP3.ControlType := GetDeviceControlByName(IniFile.ReadString(Section, 'Control', ''));
          case Device^.UthaRCP3.ControlType of
            ctSerial:
            begin
              Device^.UthaRCP3.PortConfig := GetPortConfig(IniFile, Section);
            end;
            ctTCP, ctUDP:
            begin
              StrPLCopy(Device^.UthaRCP3.HostIP, IniFile.ReadString(Section, 'HostIP', ''), HOSTIP_LEN);
              Device^.UthaRCP3.HostPort := IniFile.ReadInteger(Section, 'HostPort', 5001);
            end;
          end;
        end;
        DT_GVR:
        begin
          Device^.Gvr.ControlType := GetDeviceControlByName(IniFile.ReadString(Section, 'Control', ''));
          case Device^.Gvr.ControlType of
            ctSerial:
            begin
              Device^.Gvr.PortConfig := GetPortConfig(IniFile, Section);
            end;
            ctTCP, ctUDP:
            begin
              StrPLCopy(Device^.Gvr.HostIP, IniFile.ReadString(Section, 'HostIP', ''), HOSTIP_LEN);
              Device^.Gvr.HostPort := IniFile.ReadInteger(Section, 'HostPort', 6001);
            end;
          end;
        end;
      end;

      GV_DeviceList.Add(Device);
    end;

    // Config Event MCS
    Section := 'EventMCS';
    FillChar(GV_ConfigEventMCS, SizeOf(TConfigEventMCS), #0);
    with GV_ConfigEventMCS do
    begin
      NumPSTSet := IniFile.ReadInteger(Section, 'NumPSTSet', 1);

      PSTSetTime := TConfigCueTimeList.Create;
      for I := 0 to NumPSTSet - 1 do
      begin
        Ident := Format('PSTSetTime%d', [I + 1]);

        ConfigCueTime := New(PConfigCueTime);
        FillChar(ConfigCueTime^, SizeOf(TConfigCueTime), #0);
        ConfigCueTime^.CueTime := StringToTimecode(IniFile.ReadString(Section, Ident, '23:59:59:29'));

        PSTSetTime.Add(ConfigCueTime);
      end;

      PSTSetDelayTime   := StringToTimecode(IniFile.ReadString(Section, 'PSTSetDelayTime', '00:00:05:00'));
      CommandTimeout    := StringToTimecode(IniFile.ReadString(Section, 'CommandTimeout', '00:00:04:00'));
      CueTimeout        := StringToTimecode(IniFile.ReadString(Section, 'CueTimeout', '00:00:04:00'));
      TrRateCutTime     := IniFile.ReadInteger(Section, 'TrRateCutTime', 0);
      TrRateFastTime    := IniFile.ReadInteger(Section, 'TrRateFastTime', 0);
      TrRateMediumTime  := IniFile.ReadInteger(Section, 'TrRateMediumTime', 0);
      TrRateSlowTime    := IniFile.ReadInteger(Section, 'TrRateSlowTime', 0);
     end;

    // Config Event VCR
    Section := 'EventVCR';
    FillChar(GV_ConfigEventVCR, SizeOf(TConfigEventVCR), #0);
    with GV_ConfigEventVCR do
    begin
      NumCue := IniFile.ReadInteger(Section, 'NumCue', 1);

      CueTime := TConfigCueTimeList.Create;
      for I := 0 to NumCue - 1 do
      begin
        Ident := Format('CueTime%d', [I + 1]);

        ConfigCueTime := New(PConfigCueTime);
        FillChar(ConfigCueTime^, SizeOf(TConfigCueTime), #0);
        ConfigCueTime^.CueTime := StringToTimecode(IniFile.ReadString(Section, Ident, '23:59:59:29'));

        CueTime.Add(ConfigCueTime);
      end;

      StandbyOffAfterCue          := StrToBoolDef(IniFile.ReadString(Section, 'StandbyOffAfterCue', 'True'), False);
      StandbyOffDelayTime         := StringToTimecode(IniFile.ReadString(Section, 'StandbyOffDelayTime', '00:00:00:00'));
      StandbyOnTime               := StringToTimecode(IniFile.ReadString(Section, 'StandbyOnTime', '00:00:00:00'));
      PrerollTime                 := StringToTimecode(IniFile.ReadString(Section, 'PrerollTime', '00:00:00:00'));
      BackgroundEventPreparation  := StrToBoolDef(IniFile.ReadString(Section, 'BackgroundEventPreparation', 'False'), False);
      CommandTimeout              := StringToTimecode(IniFile.ReadString(Section, 'CommandTimeout', '00:00:04:00'));
      CueTimeout                  := StringToTimecode(IniFile.ReadString(Section, 'CueTimeout', '00:00:05:00'));
      FinishActionDelayTime       := StringToTimecode(IniFile.ReadString(Section, 'FinishActionDelayTime', '00:00:00:00'));
      FinishActionTimeout         := StringToTimecode(IniFile.ReadString(Section, 'FinishActionTimeout', '00:00:02:00'));
     end;

    // Config Event VS
    Section := 'EventVS';
    FillChar(GV_ConfigEventVS, SizeOf(TConfigEventVS), #0);
    with GV_ConfigEventVS do
    begin
      NumCue := IniFile.ReadInteger(Section, 'NumCue', 1);

      CueTime := TConfigCueTimeList.Create;
      for I := 0 to NumCue - 1 do
      begin
        Ident := Format('CueTime%d', [I + 1]);

        ConfigCueTime := New(PConfigCueTime);
        FillChar(ConfigCueTime^, SizeOf(TConfigCueTime), #0);
        ConfigCueTime^.CueTime := StringToTimecode(IniFile.ReadString(Section, Ident, '23:59:59:29'));

        CueTime.Add(ConfigCueTime);
      end;

      AdvancedStartTime           := StringToTimecode(IniFile.ReadString(Section, 'AdvancedStartTime', '00:00:00:00'));
      BackgroundEventPreparation  := StrToBoolDef(IniFile.ReadString(Section, 'BackgroundEventPreparation', 'True'), False);
      CommandTimeout              := StringToTimecode(IniFile.ReadString(Section, 'CommandTimeout', '00:00:04:00'));
      CueTimeout                  := StringToTimecode(IniFile.ReadString(Section, 'CueTimeout', '00:00:05:00'));
      FinishActionDelayTime       := StringToTimecode(IniFile.ReadString(Section, 'FinishActionDelayTime', '00:00:00:00'));
      FinishActionTimeout         := StringToTimecode(IniFile.ReadString(Section, 'FinishActionTimeout', '00:00:02:00'));
     end;

    // Config Event CG
    Section := 'EventCG';
    FillChar(GV_ConfigEventCG, SizeOf(TConfigEventCG), #0);
    with GV_ConfigEventCG do
    begin
      NumCue := IniFile.ReadInteger(Section, 'NumCue', 1);

      CueTime := TConfigCueTimeList.Create;
      for I := 0 to NumCue - 1 do
      begin
        Ident := Format('CueTime%d', [I + 1]);

        ConfigCueTime := New(PConfigCueTime);
        FillChar(ConfigCueTime^, SizeOf(TConfigCueTime), #0);
        ConfigCueTime^.CueTime := StringToTimecode(IniFile.ReadString(Section, Ident, '23:59:59:29'));

        CueTime.Add(ConfigCueTime);
      end;

      AdvancedStartTime           := StringToTimecode(IniFile.ReadString(Section, 'AdvancedStartTime', '00:00:00:00'));
      BackgroundEventPreparation  := StrToBoolDef(IniFile.ReadString(Section, 'BackgroundEventPreparation', 'False'), False);
      CommandTimeout              := StringToTimecode(IniFile.ReadString(Section, 'CommandTimeout', '00:00:04:00'));
      CueTimeout                  := StringToTimecode(IniFile.ReadString(Section, 'CueTimeout', '00:00:05:00'));
      FinishActionDelayTime       := StringToTimecode(IniFile.ReadString(Section, 'FinishActionDelayTime', '00:00:00:00'));
      FinishActionTimeout         := StringToTimecode(IniFile.ReadString(Section, 'FinishActionTimeout', '00:00:02:00'));
     end;
  finally
    FreeAndNil(IniFile);
  end;

  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Channel.ini');
  try
    // Channel
    // Num Channel
    Section := 'Channel';
    NumChannel := IniFile.ReadInteger(Section, 'NumChannel', 0);

    for I := 0 to NumChannel - 1 do
    begin
      Section := Format('Channel%d', [I + 1]);

      Channel := New(PChannel);
      FillChar(Channel^, SizeOf(TChannel), #0);

      Channel^.ID := IniFile.ReadInteger(Section, 'ID', 0);
      StrPLCopy(Channel^.Name, IniFile.ReadString(Section, 'Name', ''), CHANNELNAME_LEN);
      Channel^.FrameRateType := GetFrameRateTypeByName(IniFile.ReadString(Section, 'FrameRateType', '29.97 DF'));

      GV_ChannelList.Add(Channel);
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

procedure SaveDCSConfig;
var
  IniFile: TIniFile;
  I: Integer;

  Section: String;
  DCS: PDCS;
begin
  // DCS
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'DCS.ini');
  try
    // DCS
    Section := 'DCS';

    IniFile.WriteInteger(Section, 'NumDCS', GV_DCSList.Count);

    for I := 0 to GV_DCSList.Count - 1 do
    begin
      DCS := GV_DCSList[I];
      if (DCS <> nil) then
      begin
        IniFile.WriteString(Section, Format('DCS%d', [I + 1]), Format('%d,%s,%s,%d,%d', [DCS^.ID, String(DCS^.Name), String(DCS^.HostIP), Integer(DCS^.Main), Integer(DCS^.Mine)]));
      end;
    end;
  finally
    FreeAndNil(IniFile);
  end;
end;

function CheckSum(AValue: AnsiString): Boolean;
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

function HasMainControl: Boolean;
begin
  GV_DCSCritSec.Enter;
  try
    Result := (GV_DCSMine <> nil) and (GV_DCSMine^.Main);
  finally
    GV_DCSCritSec.Leave;
  end;
end;

function GetDCSByID(AID: Word): PDCS;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to GV_DCSList.Count - 1 do
  begin
    if (GV_DCSList[I]^.ID = AID) then
    begin
      Result := GV_DCSList[I];
      break;
    end;
  end;
end;

function GetPortTypeByName(AName: String): TComPortType;
var
  I: TComPortType;
begin
  Result := ptRS422;

  for I := ptRS232 to ptRS485 do
    if (UpperCase(PortTypeNames[I]) = UpperCase(AName)) then
    begin
      Result := I;
      break;
    end;
end;

function GetBaudRateByValue(AValue: Integer): TComPortBaudRate;
var
  I: TComPortBaudRate;
begin
  Result := br38400;

  for I := br2400 to br115200 do
    if (BaudRates[I] = AValue) then
    begin
      Result := I;
      break;
    end;
end;

function GetParityByName(AName: String): TComPortParity;
var
  I: TComPortParity;
begin
  Result := ptOdd;

  for I := ptOdd to ptSpace do
    if (UpperCase(ParityNames[I]) = UpperCase(AName)) then
    begin
      Result := I;
      break;
    end;
end;

function GetDeviceByHandle(AHandle: TDeviceHandle): PDevice;
var
  I: Integer;
  D: PDevice;
begin
  Result := nil;

  for I := 0 to GV_DeviceList.Count - 1 do
  begin
    D := GV_DeviceList[I];
    if (D^.Handle = AHandle) then
    begin
      Result := D;
      break;
    end;
  end;
end;

function GetDeviceHandle: TDeviceHandle;
begin
  Result := GV_DeviceHandleValue;
  Inc(GV_DeviceHandleValue);
end;

function GetDeviceTypeByName(AName: String): TDeviceType;
var
  I: TDeviceType;
begin
  Result := DT_NONE;

  for I := Low(TDeviceType) to High(TDeviceType) do
    if (UpperCase(DeviceTypeNames[I]) = UpperCase(AName)) then
    begin
      Result := I;
      break;
    end;
end;

function GetDeviceControlByName(AName: String): TControlType;
var
  I: TControlType;
begin
  Result := ctSerial;

  for I := Low(TControlType) to High(TControlType) do
    if (UpperCase(ControlTypeNames[I]) = UpperCase(AName)) then
    begin
      Result := I;
      break;
    end;
end;

function GetDeviceHandleByName(ADeviceName: String): TDeviceHandle;
var
  I: Integer;
  D: PDevice;
begin
  Result := -1;

  for I := 0 to GV_DeviceList.Count - 1 do
  begin
    D := GV_DeviceList[I];
    if (String(D^.Name) = ADeviceName) then
    begin
      Result := D^.Handle;
      break;
    end;
  end;
end;

function GetDeviceThreadByHandle(AHandle: TDeviceHandle): TDeviceThread;
var
  LockList: TList;
begin
  Result := nil;

  LockList := GV_DeviceThreadList.LockList;
  try
    if (AHandle >= 0) and (AHandle < LockList.Count) then
      Result := LockList[AHandle];
  finally
    GV_DeviceThreadList.UnLockList;
  end;
end;

function GetLogCommonByIndex(AIndex: Integer): PLogCommon;
begin
  Result := nil;

  GV_LogCommonLock.Enter;
  try
    if (GV_LogCommonList = nil) then exit;
    if (AIndex < 0) or (AIndex > GV_LogCommonList.Count - 1) then exit;

    Result := GV_LogCommonList[AIndex];
  finally
    GV_LogCommonLock.Leave;
  end;
end;

function GetChannelByID(AChannelID: Integer): PChannel;
var
  I: Integer;
  C: PChannel;
begin
  Result := nil;

  for I := 0 to GV_ChannelList.Count - 1 do
  begin
    C := GV_ChannelList[I];
    if (C^.ID = AChannelID) then
    begin
      Result := C;
      break;
    end;
  end;
end;

function GetChannelNameByChannel(AChannel: PChannel): String;
var
  I: Integer;
  C: PChannel;
begin
  Result := '';

  if (AChannel = nil) then exit;

  for I := 0 to GV_ChannelList.Count - 1 do
  begin
    C := GV_ChannelList[I];
    if (C = AChannel) then
    begin
      Result := String(C^.Name);
      break;
    end;
  end;
end;

function GetChannelNameByID(AChannelID: Integer): String;
var
  I: Integer;
  C: PChannel;
begin
  Result := '';

  for I := 0 to GV_ChannelList.Count - 1 do
  begin
    C := GV_ChannelList[I];
    if (C^.ID = AChannelID) then
    begin
      Result := String(C^.Name);
      break;
    end;
  end;
end;

function GetChannelFrameRateTypeByID(AChannelID: Integer): TFrameRateType;
var
  I: Integer;
  C: PChannel;
begin
  Result := FR_1;

  for I := 0 to GV_ChannelList.Count - 1 do
  begin
    C := GV_ChannelList[I];
    if (C^.ID = AChannelID) then
    begin
      Result := C^.FrameRateType;
      break;
    end;
  end;
end;

function GetChannelIsDropFrameByID(AChannelID: Integer): Boolean;
var
  I: Integer;
  C: PChannel;
begin
  Result := False;

  for I := 0 to GV_ChannelList.Count - 1 do
  begin
    C := GV_ChannelList[I];
    if (C^.ID = AChannelID) then
    begin
      Result := (C^.FrameRateType in [FR_29_97_DF, FR_59_94_DF]);
      break;
    end;
  end;
end;

function GenerateUniqueInteger: Integer;
begin
  GV_CounterLock.Acquire;
  try
    Inc(GV_UniqueCounter);
    Result := (Integer(DateTimeToUnix(Now)) * 1000) + (GV_UniqueCounter mod 1000);
  finally
    GV_CounterLock.Release;
  end;
end;

procedure DeviceCreate;
var
  I, R: Integer;
  D: PDevice;
  T: TDeviceThread;
begin
  // Device thread active
  for I := 0 to GV_DeviceList.Count - 1 do
  begin
    D := GV_DeviceList[I];
    T := nil;
    case D^.DeviceType of
      DT_PCS_MEDIA: T := TDevicePCSMedia.Create(D);
      DT_PCS_CG: T := TDevicePCSCG.Create(D);
      DT_PCS_SWITCHER: T := TDevicePCSSwitcher.Create(D);

      DT_LOUTH: T := TDevicceLouth.Create(D);
      DT_OMNEON: T := TDeviceOMNEON.Create(D);

      DT_K3D: T := TDeviceK3DAsyncEngine.Create(D);
      DT_TAPI: T := TDeviceTAPI.Create(D);

      DT_LINE: T := TDevicceLINE.Create(D);

      DT_VTS: T := TDevicceVTS.Create(D);
      DT_K2E_MCS: T := TDeviceK2ESwitcher.Create(D);

      DT_IMG_LRC: T := TDeviceImagineLRC.Create(D);
      DT_GV_RCL: T := TDeviceGrassValleyRCL.Create(D);
      DT_QUARTZ: T := TDeviceQuartz.Create(D);
      DT_UTHA_RCP3: T := TDeviceUthaRCP3.Create(D);
    end;

    if (T <> nil) then
    begin
      GV_DeviceThreadList.Add(T);

      Assert(False, GetLogCommonStr(lsNormal, Format('Succeeded device create, name = %s, handle = %d',
                                                     [String(T.Device^.Name), T.Device^.Handle])));
    end;
  end;
end;

procedure DeviceOpen;
var
  I, R: Integer;
  T: TDeviceThread;
  LockList: TList;
begin
  LockList := GV_DeviceThreadList.LockList;
  try
    for I := 0 to LockList.Count - 1 do
    begin
      T := LockList[I];
      if (T <> nil) then
      begin
        frmDCS.DisplayStartStatus(String(T.Device^.Name), 80 + Round((I + 1) / LockList.Count * 20));

        R := T.DeviceOpen;
        if (R <> D_OK) then
          Assert(False, GetLogCommonStr(lsError, Format('Failed device open, errorcode = %d, name = %s, handle = %d',
                                                         [R, String(T.Device^.Name), T.Device^.Handle])))
        else
          Assert(False, GetLogCommonStr(lsNormal, Format('Succeeded device open, name = %s, handle = %d',
                                                         [String(T.Device^.Name), T.Device^.Handle])));
      end;
    end;
  finally
    GV_DeviceThreadList.UnLockList;
  end;
end;

procedure DeviceStart;
var
  I, R: Integer;
  T: TDeviceThread;
  LockList: TList;
begin
  LockList := GV_DeviceThreadList.LockList;
  try
    for I := 0 to LockList.Count - 1 do
    begin
      T := LockList[I];
      if (T <> nil) then
      begin
        if (T.Suspended) then
        begin
          T.Start;
          Assert(False, GetLogCommonStr(lsNormal, Format('Succeeded device start, name = %s, handle = %d',
                                                         [String(T.Device^.Name), T.Device^.Handle])));
        end;
      end;
    end;
  finally
    GV_DeviceThreadList.UnLockList;
  end;
end;

procedure DeviceClose;
var
  I, R: Integer;
  T: TDeviceThread;
  LockList: TList;
begin
  LockList := GV_DeviceThreadList.LockList;
  try
    // Device thread list free
    for I := LockList.Count - 1 downto 0 do
    begin
      T := LockList[I];
      if (T <> nil) then
      begin
        R := T.DeviceClose;
        if (R <> D_OK) then
          Assert(False, GetLogCommonStr(lsError, Format('Failed device close, errorcode = %d, name = %s, handle = %d',
                                                         [R, String(T.Device^.Name), T.Device^.Handle])))
        else
          Assert(False, GetLogCommonStr(lsNormal, Format('Succeeded device close, name = %s, handle = %d',
                                                         [String(T.Device^.Name), T.Device^.Handle])));
      end;
    end;
  finally
    GV_DeviceThreadList.UnLockList;
  end;
end;

procedure DeviceInit;
var
  I: Integer;
  T: TDeviceThread;
  LockList: TList;
begin
  LockList := GV_DeviceThreadList.LockList;
  try
    // Device thread list free
    for I := 0 to LockList.Count - 1 do
    begin
      T := LockList[I];
      if (T <> nil) then
      begin
        T.DeviceInit;
      end;
    end;
  finally
    GV_DeviceThreadList.UnLockList;
  end;
end;

procedure DeviceDestroy;
var
  I: Integer;
  T: TDeviceThread;
  LockList: TList;
begin
  LockList := GV_DeviceThreadList.LockList;
  try
    // Device thread list free
    for I := LockList.Count - 1 downto 0 do
    begin
      T := LockList[I];
      if (T <> nil) then
      begin
        T.Close;
//        T.Terminate;
        T.WaitFor;

        Assert(False, GetLogCommonStr(lsNormal, Format('Succeeded device destroy, name = %s, handle = %d',
                                                       [String(T.Device^.Name), T.Device^.Handle])));

        FreeAndNil(T);
      end;
    end;
    LockList.Clear;
  finally
    GV_DeviceThreadList.UnLockList;
  end;
end;

procedure ClearDCSList;
var
  I: Integer;
begin
  // DCS
  for I := GV_DCSList.Count - 1 downto 0 do
  begin
    Dispose(GV_DCSList[I]);
  end;

  GV_DCSList.Clear;
end;

procedure ClearChannelList;
var
  I: Integer;
begin
  // Channel
  for I := GV_ChannelList.Count - 1 downto 0 do
  begin
    Dispose(GV_ChannelList[I]);
  end;

  GV_ChannelList.Clear;
end;

procedure ClearDeviceList;
var
  I: Integer;
begin
  // Device
  for I := GV_DeviceList.Count - 1 downto 0 do
  begin
    Dispose(GV_DeviceList[I]);
  end;

  GV_DeviceList.Clear;
end;

procedure ClearLogCommonList;
var
  I: Integer;
begin
  GV_LogCommonLock.Enter;
  try
    // Log common
    for I := GV_LogCommonList.Count - 1 downto 0 do
    begin
      Dispose(GV_LogCommonList[I]);
    end;

    GV_LogCommonList.Clear;
  finally
    GV_LogCommonLock.Leave;
  end;
end;

procedure ClearConfigEvent;
var
  I: Integer;
  L: TConfigCueTimeList;
begin
  // Config Event MCS
  L := GV_ConfigEventMCS.PSTSetTime;
  if (L <> nil) then
  begin
    for I := L.Count - 1 downto 0 do
    begin
      Dispose(L[I]);
    end;
    L.Clear;
    FreeAndNil(L);
  end;

  // Config Event VCR
  L := GV_ConfigEventVCR.CueTime;
  if (L <> nil) then
  begin
    for I := L.Count - 1 downto 0 do
    begin
      Dispose(L[I]);
    end;
    L.Clear;
    FreeAndNil(L);
  end;

  // Config Event VS
  L := GV_ConfigEventVS.CueTime;
  if (L <> nil) then
  begin
    for I := L.Count - 1 downto 0 do
    begin
      Dispose(L[I]);
    end;
    L.Clear;
    FreeAndNil(L);
  end;

  // Config Event CG
  L := GV_ConfigEventCG.CueTime;
  if (L <> nil) then
  begin
    for I := L.Count - 1 downto 0 do
    begin
      Dispose(L[I]);
    end;
    L.Clear;
    FreeAndNil(L);
  end;
end;

procedure ClearConfigSerialGate;
var
  I: Integer;
  L: TSerialGateList;
begin
  // Config Serial Gate
  L := GV_ConfigSerialGate.SerialGateList;
  if (L <> nil) then
  begin
    for I := L.Count - 1 downto 0 do
    begin
      Dispose(L[I]);
    end;
    L.Clear;
    FreeAndNil(L);
  end;
end;

initialization
  AssertErrorProc := AssertProc;
  GV_CounterLock := TCriticalSection.Create;

finalization
  FreeAndNil(GV_CounterLock);

end.
