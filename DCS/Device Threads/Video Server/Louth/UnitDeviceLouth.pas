unit UnitDeviceLouth;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows,
  UnitDeviceThread, UnitCommons,
  UnitBaseSerial, UnitLouth;

type
  TDevicceLOUTH = class(TDeviceThread)
  private
    FLouth: TLouth;
  protected
    procedure ControlReset; override;
    procedure ControlCommand; override;
    procedure ControlClear; override;
    procedure ControlChanged; override;
    procedure ControlStart; override;
    procedure ControlStop; override;
    procedure ControlFinish; override;
    procedure ControlCue; override;
    procedure ControlSchedule; override;
    procedure ControlGetStatus; override;

    function GetStatus: TDeviceStatus; override;

//    function DCSGetStatus(ABuffer: String): Integer; override;
  public
    constructor Create(ADevice: PDevice); override;
    destructor Destroy; override;

    function DeviceOpen: Integer; override;
    function DeviceClose: Integer; override;
    function DeviceInit: Integer; override;
  end;

implementation

uses UnitConsts;

constructor TDevicceLOUTH.Create(ADevice: PDevice);
begin
  inherited Create(ADevice);

  FLouth := TLouth.Create(nil);
  FLouth.ControlType := ctSerial;
//  FLouth.TimeOut := 1000;

  FLouth.LogEnabled := ADevice^.PortLog;

  if (FLouth.LogEnabled) then
  begin
    FLouth.LogIsHexcode := True;
    FLouth.LogPath := GV_ConfigGeneral.PortLogPath + String(ADevice^.Name) + PathDelim;
    FLouth.LogExt  := GV_ConfigGeneral.PortLogExt;
  end;

end;

destructor TDevicceLOUTH.Destroy;
begin
  if (FLouth <> nil) then
    FreeAndNil(FLouth);

  inherited Destroy;
end;

procedure TDevicceLOUTH.ControlReset;
begin
  inherited;
end;

procedure TDevicceLOUTH.ControlCommand;
var
  ClipIDLen: Cardinal;
  ClipID: String;
  ClipIDRequest: TIDRequest;

  ClipSize: String;
begin
  try
    case FCMD1 of
      $40:
      begin
        case FCMD2 of
          $22: // Get Exist
          begin
            if (Length(FCMDBuffer) < 2) then exit;

            ClipIDLen := PAnsiCharToWord(@FCMDBuffer[1]);
            ClipID := Copy(FCMDBuffer, 3, ClipIDLen);

            FCMDLastResult := FLouth.GetIDRequest(ClipID, ClipIDRequest);
            case ClipIDRequest.InDisk of
              True: FCMDResultBuffer := Chr($01);
              False: FCMDResultBuffer := Chr($00);
            end;

            if (FCMDLastResult = D_OK) then
              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('ControlCommand GetIDRequest succeeded, id = %s, exist = %s', [ClipID, BoolToStr(ClipIDRequest.InDisk, True)])))
            else
              Assert(False, GetLogDevice(lsError, FCMDControlBy, Format('ControlCommand GetIDRequest failed, error = %d, id = %s', [FCMDLastResult, ClipID])));
          end;
          $23: // Get Size
          begin
            if (Length(FCMDBuffer) < 2) then exit;

            ClipIDLen := PAnsiCharToWord(@FCMDBuffer[1]);
            ClipID := Copy(FCMDBuffer, 3, ClipIDLen);

            FCMDLastResult := FLouth.GetSize(ClipID, ClipSize);
            if (FCMDLastResult = D_OK) then
            begin
              FCMDResultBuffer := DWordToAnsiString(StringToTimecode(ClipSize));

              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('ControlCommand GetSize succeeded, id = %s, size = %s', [ClipID, ClipSize])));
            end
            else
              Assert(False, GetLogDevice(lsError, FCMDControlBy, Format('ControlCommand GetSize failed, error = %d, id = %s', [FCMDLastResult, ClipID])));
          end;
        end;
      end;
    end;
  finally
    inherited;
  end;
end;

procedure TDevicceLOUTH.ControlClear;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventCurr <> nil) and (FEventQueue.IndexOf(EventCurr) < 0) then
    begin
      try
      finally
//        EventCurr := nil;
      end;
    end;

    if (EventNext <> nil) and (FEventQueue.IndexOf(EventNext) < 0) then
    begin
      try
      finally
//        EventNext := nil;
      end;
    end;
  finally
    FEventLock.Leave;
    inherited;
  end;
end;

procedure TDevicceLOUTH.ControlChanged;
//var
//  ClipInfo: TOmPlrClipInfo;
//  ClipDuration: Cardinal;
//  PlrStatus: TOmPlrStatus;
begin
  try
    if (not HasMainControl) then exit;

  finally
    inherited;
  end;

{  try
x
    if (HasMainControl) then
    begin
      // If current event status is onair
      // If next event is manual event and status is cued then SetMaxPos set current duration time
      if (EventCurr <> nil) and (EventCurr^.Status = esOnAir) and
         (EventNext <> nil) {and (EventNext^.ManualEvent) }//and (EventNext^.Status = esCued) then
{      begin
        FillChar(PlrStatus, SizeOf(TOmPlrStatus), #0);
        FLastPlrError := OmPlrGetPlayerStatus(FPlrHandle, PlrStatus);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;

        if (PlrStatus.MaxPos > (PlrStatus.CurrClipStartPos + PlrStatus.CurrClipLen)) then
        begin
          FLastPlrError := OmPlrSetMaxPos(FPlrHandle, PlrStatus.CurrClipStartPos + PlrStatus.CurrClipLen);
          if (FLastPlrError <> omPlrOk) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;
        end;

  {      FillChar(ClipInfo, SizeOf(TOmPlrClipInfo), #0);
        FLastPlrError := OmPlrClipGetInfo(FPlrHandle, EventNext^.Player.ID.ID, ClipInfo);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;

        ClipDuration := ClipInfo.LastFrame - ClipInfo.FirstFrame;

        FillChar(PlrStatus, SizeOf(TOmPlrStatus), #0);
        FLastPlrError := OmPlrGetPlayerStatus(FPlrHandle, PlrStatus);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;

        if (PlrStatus.MaxPos > PlrStatus.ClipDuration) then
        begin
          FLastPlrError := OmPlrSetMaxPos(FPlrHandle, PlrStatus.MaxPos - ClipDuration);
          if (FLastPlrError <> omPlrOk) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;
        end;  }
{      end;
    end;
  finally
    inherited;
  end; }
end;

procedure TDevicceLOUTH.ControlStart;
var
  R: Integer;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) and (EventNext^.Status.State = esCued) then
    begin
      R := FLouth.Play;
      if (R <> D_OK) then
      begin
        SetEventStatus(EventNext, esError);
        Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlStart Play failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

        exit;
      end;

      Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlStart Play succeeded. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

      SetEventStatus(EventNext, esOnAir);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStart succeeded, id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
    end;
  finally
    FEventLock.Leave;
    inherited;
  end;
end;

procedure TDevicceLOUTH.ControlStop;
var
  R: Integer;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventCurr <> nil) and (EventCurr^.Status.State = esOnAir) then
    begin
      SetEventStatus(EventCurr, esFinish);

      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStop succeeded, id = %s, mediaid = %s', [EventIDToString(EventCurr^.EventID), EventCurr^.Player.ID.ID])));
    end;
  finally
    FEventLock.Leave;
    inherited;
  end;
end;

procedure TDevicceLOUTH.ControlFinish;
var
  R: Integer;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventFini <> nil) and (EventFini^.Status.State = esFinish) then
    begin
      SetEventStatus(EventFini, esFinishing);

      // FinishAction俊 狼秦 STOP or STILL 贸府
      case EventFini^.Player.FinishAction of
        FA_STOP: // FinishAction捞 STOP老 版快 Pause 贸府
        begin
          R := FLouth.Pause;
          if (R <> D_OK) then
          begin
            SetEventStatus(EventFini, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlFinish Pause failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventFini^.EventID), EventFini^.Player.ID.ID])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlFinish Pause succeeded. id = %s, mediaid = %s', [EventIDToString(EventFini^.EventID), EventFini^.Player.ID.ID])));
        end;
        FA_EJECT:
        begin
          R := FLouth.Stop;
          if (R <> D_OK) then
          begin
            SetEventStatus(EventCurr, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlFinish Stop failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventFini^.EventID), EventFini^.Player.ID.ID])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlFinish Stop succeeded. id = %s, mediaid = %s', [EventIDToString(EventFini^.EventID), EventFini^.Player.ID.ID])));
        end;
      end;

      SetEventStatus(EventFini, esFinished);

      SetEventStatus(EventFini, esDone);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlFinish succeeded, id = %s, mediaid = %s', [EventIDToString(EventFini^.EventID), EventFini^.Player.ID.ID])));
    end;
  finally
    FEventLock.Leave;
    inherited;
  end;
end;

procedure TDevicceLOUTH.ControlCue;
var
  R: Integer;
  Request: TIDRequest;

  CueTimeOut: Word;
  CueFrequency, CueStartCount, CueStopCount: Int64; // minimal stop watch
  PortStateStatus: TPortStateStatus;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) then
    begin
      SetEventStatus(EventNext, esCueing);

      R := FLouth.CmdWhileBusy;
      if (R <> D_OK) then
      begin
        SetEventStatus(EventNext, esError);
        Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue CmdWhileBusy_1 failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

        exit;
      end;

      R := FLouth.GetIDRequest(String(EventNext^.Player.ID.ID), Request);
      if (R <> D_OK) then
      begin
        SetEventStatus(EventNext, esError);
        Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue GetIDRequest failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

        exit;
      end;

      if (not Request.InDisk) then
      begin
        SetEventStatus(EventNext, esError);
        Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue Clip not exist. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

        exit;
      end;

      R := FLouth.PlayCueWithData(String(EventNext^.Player.ID.ID), TimecodeToString(EventNext^.Player.StartTC, ControlIsDropFrame), TimecodeToString(EventNext^.DurTime, ControlIsDropFrame));
      if (R <> D_OK) then
      begin
        SetEventStatus(EventNext, esError);
        Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue PlayCueWithData failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

        exit;
      end;

      R := FLouth.CmdWhileBusy;
      if (R <> D_OK) then
      begin
        SetEventStatus(EventNext, esError);
        Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue CmdWhileBusy_2 failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

        exit;
      end;

      CueTimeOut := TimecodeToMilliSec(GV_ConfigEventVS.CueTimeout, FR_30);

      QueryPerformanceFrequency(CueFrequency); // this will never return 0 on Windows XP or later
      if (CueFrequency = 0) then CueFrequency := 10000000;

      QueryPerformanceCounter(CueStartCount);
      repeat
        R := FLouth.GetPortStateStatus(PortStateStatus);
        if (R <> D_OK) then
        begin
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue GetPortStateStatus play cue done check failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
        end;

        if (PortStateStatus.CueDone) then
          break;

        Sleep(30);

        QueryPerformanceCounter(CueStopCount);
      until ((1000 * (CueStopCount - CueStartCount) div CueFrequency) >= CueTimeOut);

      if (not PortStateStatus.CueDone) then
      begin
        SetEventStatus(EventNext, esError);
        Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue play cue done failed. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

        exit;
      end;

      SetEventStatus(EventNext, esCued);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue succeeded, id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
    end;
  finally
    FEventLock.Leave;
    inherited;
  end;
end;

procedure TDevicceLOUTH.ControlSchedule;
begin
  inherited;
end;

procedure TDevicceLOUTH.ControlGetStatus;
begin
  inherited;
end;

function TDevicceLOUTH.GetStatus: TDeviceStatus;
var
  R: Integer;
  PortStateStatus: TPortStateStatus;
  CurTC, RemainTC: String;
begin
  FillChar(Result, SizeOf(TDeviceStatus), #0);
  with Result do
  begin
    EventType := ET_PLAYER;

    FillChar(PortStateStatus, SizeOf(TPortStateStatus), #0);
    R := FLouth.GetPortStateStatus(PortStateStatus);
    if (R = D_OK) then
    begin
      Connected := True;

      Player.Stop       := (PortStateStatus.Idle);

      Player.Cue        := (PortStateStatus.Cue);
      Player.Play       := (PortStateStatus.PlayRecord) and (FLouth.PortNumber >= 0);
      Player.Rec        := (PortStateStatus.PlayRecord) and (FLouth.PortNumber < 0);
      Player.Still      := (PortStateStatus.Still);

      Player.Jog        := (PortStateStatus.Jog);
      Player.Shuttle    := (PortStateStatus.Shuttle);
      Player.PortBusy   := (PortStateStatus.PortBusy);

      Player.CueDone    := (PortStateStatus.CueDone);

      R := FLouth.GetPositionRequest(ptCurrent, CurTC);
      if (R = D_OK) then
      begin
        Player.DropFrame := IsDropFrameTimecodeString(CurTC);
        Player.CurTC := StringToTimecode(CurTC)
      end
      else
      begin
        Player.DropFrame := False;
        Player.CurTC := 0;
      end;

      R := FLouth.GetPositionRequest(ptRemain, RemainTC);
      if (R = D_OK) then
        Player.RemainTC := StringToTimecode(RemainTC)
      else
        Player.RemainTC := 0;
    end
    else
    begin
      Assert(False, GetLogDevice(lsError, Format('GetStatus GetPortStateStatus failed, Error = %d', [Integer(R)])));
      Connected := False;
      DeviceClose;
{      if (not FOpened) then }DeviceOpen;
    end;
  end;

  Result := inherited GetStatus;
end;

function TDevicceLOUTH.DeviceOpen: Integer;
var
  R: Integer;
  PortStateStatus: TPortStateStatus;
begin
  Result := inherited DeviceOpen;

  with FDevice^.LOUTH do
  begin
    if (FLouth.Connected) then
      FLouth.Disconnect;

    FLouth.ComPort         := PortConfig.PortNum;
    FLouth.ComPortBaudRate := PortConfig.BaudRate;
    FLouth.ComPortDataBits := PortConfig.DataBits;
    FLouth.ComPortStopBits := PortConfig.StopBits;
    FLouth.ComPortParity   := PortConfig.Parity;

    if (not FLouth.Connect) then
    begin
      Result := D_FALSE;
      Assert(False, GetLogDevice(lsError, Format('Device serial connect failed, comport = %d', [FLouth.ComPort])));

      exit;
    end;

    FLouth.PortNumber := PortNo;

    R := FLouth.Open(FLouth.PortNumber, $01);
    if (R <> D_OK) then
    begin
      Result := D_FALSE;
      Assert(False, GetLogDevice(lsError, Format('Device open failed, PortOpen failed, error = %d, portnumber = %d', [R, FLouth.PortNumber])));

      exit;
    end;

    R := FLouth.SelectPort(FLouth.PortNumber);
    if (R <> D_OK) then
    begin
      Result := D_FALSE;
      Assert(False, GetLogDevice(lsError, Format('Device open failed, SelectPort failed, error = %d, portnumber = %d', [R, FLouth.PortNumber])));

      exit;
    end;

    Assert(False, GetLogDevice(lsNormal, Format('Device open succeeded, portnumber = %d', [FLouth.PortNumber])));
  end;

  FOpened := True;
end;

function TDevicceLOUTH.DeviceClose: Integer;
begin
      Assert(False, GetLogDevice(lsError, Format('DeviceClose 111', [])));
  Result := inherited DeviceClose;
  if (Result <> D_OK) then exit;
      Assert(False, GetLogDevice(lsError, Format('DeviceClose 222', [])));

{  if (not FLouth.Connected) then
  begin
    Result := D_FALSE;
    Assert(False, GetLogDevice(lsError, Format('Device serial not connected, comport = %d', [FLouth.ComPort])));

    exit;
  end; }

  if (HasMainControl) then
  begin
    Result := FLouth.ClosePort(FLouth.PortNumber);
    if (Result = D_OK) then
    begin
      Assert(False, GetLogDevice(lsError, Format('Device ClosePort succeeded, portnumber = %d', [FLouth.PortNumber])));
    end
    else
    begin
      Assert(False, GetLogDevice(lsError, Format('Device ClosePort failed, error = %d, portnumber = %d', [Result, FLouth.PortNumber])));
    end;
  end;

  if (not FLouth.Disconnect) then
  begin
    Result := D_FALSE;
    Assert(False, GetLogDevice(lsError, Format('Device serial disconnect failed, comport = %d', [FLouth.ComPort])));

    exit;
  end;

  Assert(False, GetLogDevice(lsNormal, Format('Device close succeeded, portnumber = %d', [FLouth.PortNumber])));

  FOpened := False;

  Result := D_OK;
end;

function TDevicceLOUTH.DeviceInit: Integer;
begin
  Result := inherited DeviceInit;

  if (not HasMainControl) then exit;

  try
    Result := FLouth.Stop;
    if (Result <> D_OK) then
    begin
      exit;
    end;
  finally
    if (Result <> D_OK) then
    begin
      Assert(False, GetLogDevice(lsError, Format('Device init failed, error = %d, portnumber = %d', [Result, FLouth.PortNumber])));
    end;
  end;

  Assert(False, GetLogDevice(lsNormal, Format('Device init succeeded, portnumber = %d', [FLouth.PortNumber])));
end;

{function TDevicceLOUTH.DCSGetStatus(ABuffer: String): Integer;
const
  FrameRateValues: array[TOmFrameRate] of Double =
    (1, 24, 25, 29.97, 30, 50, 59.94, 60, 23.97);
var
  Status: TDeviceStatus;
begin
  Result := inherited DCSGetStatus(ABuffer);

  Status := GetStatus;

  SetLength(FSendBuffer, SizeOf(TDeviceStatus));
  Move(Status, FSendBuffer, SizeOf(FSendBuffer));
end;
}
end.
