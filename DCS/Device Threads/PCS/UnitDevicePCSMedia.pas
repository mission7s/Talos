unit UnitDevicePCSMedia;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows,
  UnitTypeConvert,
  UnitDeviceThread, UnitCommons, UnitPCSControl;

type
  TDevicePCSMediaMode = (
    MM_DEC = 0,
    MM_ENC
  );

  TDevicePCSMedia = class(TDeviceThread)
  private
    FMediaControl: TPCSMediaControl;
    FMode: TDevicePCSMediaMode;

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

constructor TDevicePCSMedia.Create(ADevice: PDevice);
begin
  inherited Create(ADevice);

  FMediaControl := TPCSMediaControl.Create;

  FMode := MM_DEC;
end;

destructor TDevicePCSMedia.Destroy;
begin
  if (FMediaControl <> nil) then
    FreeAndNil(FMediaControl);

  inherited Destroy;
end;

procedure TDevicePCSMedia.ControlReset;
begin
  inherited;
end;

procedure TDevicePCSMedia.ControlCommand;
var
  ClipIDLen: Cardinal;
  ClipID: String;

  ClipExist: Boolean;
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
            ClipExist := False;

            FCMDLastResult := FMediaControl.GetClipExist(ClipID, ClipExist);
            case ClipExist of
              True: FCMDResultBuffer := Chr($01);
              False: FCMDResultBuffer := Chr($00);
            end;

            if (FCMDLastResult = D_OK) then
              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('ControlCommand GetExist succeeded, mediaid = %s, exist = %s', [ClipID, BoolToStr(ClipExist, True)])))
            else
              Assert(False, GetLogDevice(lsError, FCMDControlBy, Format('ControlCommand GetExist failed, error = %d, mediaid = %s', [FCMDLastResult, ClipID])));
          end;
          $23: // Get Size
          begin
            if (Length(FCMDBuffer) < 2) then exit;

            ClipIDLen := PAnsiCharToWord(@FCMDBuffer[1]);
            ClipID := Copy(FCMDBuffer, 3, ClipIDLen);

            FCMDLastResult := FMediaControl.GetClipSize(ClipID, ClipSize);
            if (FCMDLastResult = D_OK) then
            begin
              FCMDResultBuffer := DWordToAnsiString(StringToTimecode(ClipSize));

              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('ControlCommand GetSize succeeded, mediaid = %s, size = %s', [ClipID, ClipSize])));
            end
            else
              Assert(False, GetLogDevice(lsError, FCMDControlBy, Format('ControlCommand GetSize failed, error = %d, mediaid = %s', [FCMDLastResult, ClipID])));
          end;
        end;
      end;
    end;
  finally
    inherited;
  end;
end;

procedure TDevicePCSMedia.ControlClear;
var
  R: Integer;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    FMode := MM_DEC;

    R := FMediaControl.Stop;
    if (R <> D_OK) then
    begin
      SetEventStatus(EventCurr, esError);
      exit;
    end;

//    EventCurr := nil;
//    EventNext := nil;
  finally
    inherited;
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSMedia.ControlChanged;
begin
  try
  finally
    inherited;
  end;
end;

procedure TDevicePCSMedia.ControlStart;
var
  R: Integer;

  SpliceID: String;
  SpliceDate: String;
  SpliceStart: String;
  SpliceDutration: String;
begin
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlStart Start', [])));

  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlStart 1111111. Error = %d,  ID = %s', [R, EventNext^.Player.ID.ID])));
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlStart 2222222. EventNext = %p, EventCurr = %p', [EventNext, EventCurr])));

//    if (EventNext <> nil) then
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlStart 3333333. Status = %s', [EventStatusNames[EventNext^.Status.State]])));

    if (EventNext <> nil) {and (EventNext^.Status.State = esCued)} then
    begin
      if (EventNext^.Player.PlayerAction in [PA_PLAY, PA_RECORD]) then
      begin
        R := FMediaControl.Play;
        if (R <> D_OK) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlStart Play failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

          exit;
        end;

        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlStart Play succeeded. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
      end
      else if (EventNext^.Player.PlayerAction in [PA_STOP]) then
      begin
        R := FMediaControl.Stop;
        if (R <> D_OK) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlStart Stop failed. error = %d,  id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

          exit;
        end;
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlStart Stop succeeded. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
      end
      else if (EventNext^.Player.PlayerAction in [PA_AD]) then
      begin
        // Set SCTE-35

        SpliceID        := Format('%d', [GenerateUniqueInteger]);  // int32 // EventIDToString(EventNext^.EventID);
//        SpliceDate      := FormatDateTime('yyyymmdd', EventTimeToDate(EventNext^.StartTime));
        SpliceDate      := '';
//        SpliceStart     := FormatDateTime('hh:nn:ss.zzz', EventTimeToTime(EventNext^.StartTime, ControlFrameRateType));
        SpliceStart     := '';
        SpliceDutration := FormatDateTime('hh:nn:ss.zzz', TimecodeToTime(EventNext^.DurTime, ControlFrameRateType));

        R := FMediaControl.SetSCTE35(SpliceID, SpliceDate, SpliceStart, SpliceDutration);
        if (R <> D_OK) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlStart SetSCTE35 failed. error = %d, id = %s, spliceid = %s, splicestart = %s, spliceduration = %s', [R, EventIDToString(EventNext^.EventID), SpliceID, SpliceStart, SpliceDutration])));

          exit;
        end;
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlStart SetSCTE35 succeeded. id = %s, spliceid = %s, splicestart = %s, spliceduration = %s', [EventIDToString(EventNext^.EventID), SpliceID, SpliceStart, SpliceDutration])));
      end;

      SetEventStatus(EventNext, esOnAir);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDevicePCSMedia.ControlStart succeeded, id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
    end;
  finally
    inherited;
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlStart End', [])));
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSMedia.ControlStop;
var
  R: Integer;
begin
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlStop Start', [])));
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventCurr <> nil) {and (EventCurr^.Status.State = esFinish)} then
    begin
      SetEventStatus(EventCurr, esFinish);

      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDevicePCSMedia.ControlStop succeeded, id = %s, mediaid = %s', [EventIDToString(EventCurr^.EventID), EventCurr^.Player.ID.ID])));
    end;
  finally
    inherited;
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlStop End', [])));
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSMedia.ControlFinish;
var
  R: Integer;
begin
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlFinish Start', [])));
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventFini <> nil) {and (EventFini^.Status.State = esFinish)} then
    begin
      SetEventStatus(EventFini, esFinishing);

      case EventFini^.Player.FinishAction of
        FA_STOP: // FinishAction捞 STOP 牢版快 Paused 贸府
        begin
          R := FMediaControl.Pause;
          if (R <> D_OK) then
          begin
            SetEventStatus(EventFini, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlFinish Pause failed. error = %d,  id = %s, mediaid = %s', [R, EventIDToString(EventFini^.EventID), EventFini^.Player.ID.ID])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlFinish Pause succeeded. id = %s, mediaid = %s', [EventIDToString(EventFini^.EventID), EventFini^.Player.ID.ID])));
        end;

        FA_EJECT: // FinishAction俊 EJECT牢 版快 Stop 贸府
        begin
          R := FMediaControl.Stop;
          if (R <> D_OK) then
          begin
            SetEventStatus(EventCurr, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlFinish Stop failed. error = %d,  id = %s, mediaid = %s', [R, EventIDToString(EventFini^.EventID), EventFini^.Player.ID.ID])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlFinish Stop succeeded. id = %s, mediaid = %s', [EventIDToString(EventFini^.EventID), EventFini^.Player.ID.ID])));
        end;
      end;

      SetEventStatus(EventFini, esFinished);

      SetEventStatus(EventFini, esDone);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDevicePCSMedia.ControlFinish succeeded, id = %s, mediaid = %s', [EventIDToString(EventFini^.EventID), EventFini^.Player.ID.ID])));
    end;
  finally
    FMode := MM_DEC;

    inherited;
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlFinish End', [])));
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSMedia.ControlCue;
var
  R: Integer;
  Exist: Boolean;

  CueTimeOut: Word;
  CueFrequency, CueStartCount, CueStopCount: Int64; // minimal stop watch
  Status: TPCSMediaStatus;

  SpliceID: String;
  SpliceDate: String;
  SpliceStart: String;
  SpliceDutration: String;
begin
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlCue Start', [])));
//            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue 111', [])));
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) then
    begin
      SetEventStatus(EventNext, esCueing);
//      why???
{      // If current event is nul then eject clip
      if (EventCurr = nil) then
      begin
        R := FMediaControl.Stop;
        if (R <> D_OK) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue Stop failed. error = %d', [R])));

          exit;
        end;
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlCue Stop succeeded.', [])));
      end; }

      if (EventNext^.Player.PlayerAction in [PA_PLAY]) then
      begin
        FMode := MM_DEC;

        // Clip exist check
        R := FMediaControl.GetClipExist(String(EventNext^.Player.ID.ID), Exist);
        if (R <> D_OK) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlCue GetClipExist failed. error = %d, id = %s, mediaid', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

          exit;
        end;

        Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDevicePCSMedia.ControlCue GetClipExist succeeded, id = %s, mediaid = %s, exist = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID, BoolToStr(Exist, True)])));

        if (not Exist) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlCue Clip not exist. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

          exit;
        end;

        // Change timoeut is cue timeout
        FMediaControl.Timeout := TimecodeToMilliSec(GV_ConfigEventVS.CueTimeout, FR_30);
        try
          // Play cue with data
          R := FMediaControl.PlayCueData(String(EventNext^.Player.ID.ID), TimecodeToString(EventNext^.Player.StartTC, ControlIsDropFrame), TimecodeToString(EventNext^.DurTime, ControlIsDropFrame));
        finally
          // Restor timoeut
          FMediaControl.Timeout := TimecodeToMilliSec(GV_ConfigEventVS.CommandTimeout, FR_30);
        end;
        if (R <> D_OK) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlCue PlayCueData failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

          exit;
        end;
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlCue PlayCueData succeeded. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

//        CueTimeOut := TimecodeToMilliSec(GV_ConfigEventVS.CueTimeout);
//
//        QueryPerformanceFrequency(CueFrequency); // this will never return 0 on Windows XP or later
//        if (CueFrequency = 0) then CueFrequency := 10000000;
//
//        QueryPerformanceCounter(CueStartCount);
//        repeat
//          R := FMediaControl.GetStatus(Status);
//          if (R <> D_OK) then
//          begin
//            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue GetStatus play cue done check failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
//          end;
//
//{          if (Status.CueDone) then
//          begin
//            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue GetStatus play cue done succeeded. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
//            break;
//          end; }
//
//          Sleep(30);
//
//          QueryPerformanceCounter(CueStopCount);
//        until ((1000 * (CueStopCount - CueStartCount) div CueFrequency) >= CueTimeOut) or (Status.CueDone);
//
//        if (not Status.CueDone) then
//        begin
//          SetEventStatus(EventNext, esError);
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue play cue done failed. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
//
//          exit;
//        end
//        else
//          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlCue play cue done succeeded. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
      end
      else if (EventNext^.Player.PlayerAction in [PA_RECORD]) then
      begin
        FMode := MM_ENC;

        // Record cue with data
        if (EventNext^.DurTime > 0) then
          R := FMediaControl.RecordCueData(String(EventNext^.Player.ID.ID), TimecodeToString(EventNext^.DurTime, ControlIsDropFrame))
        else
          R := FMediaControl.RecordCue(String(EventNext^.Player.ID.ID));

        if (R <> D_OK) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlCue RecordCue failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

          exit;
        end;
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlCue RecordCue succeeded. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
{      end
      else if (EventNext^.Player.PlayerAction in [PA_AD]) then
      begin
        // Set SCTE-35

        SpliceID        := Format('%d', [GenerateUniqueInteger]);  // int32 // EventIDToString(EventNext^.EventID);
        SpliceDate      := FormatDateTime('yyyymmdd', EventTimeToDate(EventNext^.StartTime));
        SpliceStart     := FormatDateTime('hh:nn:ss.zzz', EventTimeToTime(EventNext^.StartTime, ControlFrameRateType));
        SpliceDutration := FormatDateTime('hh:nn:ss.zzz', TimecodeToTime(EventNext^.DurTime, ControlFrameRateType));

        R := FMediaControl.SetSCTE35(SpliceID, SpliceDate, SpliceStart, SpliceDutration);
        if (R <> D_OK) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlCue SetSCTE35 failed. error = %d, id = %s, spliceid = %s, splicestart = %s, spliceduration = %s', [R, EventIDToString(EventNext^.EventID), SpliceID, SpliceStart, SpliceDutration])));

          exit;
        end;
        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlCue SetSCTE35 succeeded. id = %s, spliceid = %s, splicestart = %s, spliceduration = %s', [EventIDToString(EventNext^.EventID), SpliceID, SpliceStart, SpliceDutration])));
}      end;

      SetEventStatus(EventNext, esCued);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDevicePCSMedia.ControlCue succeeded, id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
    end;
  finally
//            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue 222', [])));
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.ControlCue End', [])));
    inherited;
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSMedia.ControlSchedule;
begin
  inherited;
end;

procedure TDevicePCSMedia.ControlGetStatus;
begin
  inherited;
end;

function TDevicePCSMedia.GetStatus: TDeviceStatus;
var
  R: Integer;
  Status: TPCSMediaStatus;
  Rate: Double;
  CurTC, RemainTC: String;
begin
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus Start', [])));
try
  FillChar(Result, SizeOf(TDeviceStatus), #0);
  with Result do
  begin
    EventType := ET_PLAYER;

//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus Start 1-1', [])));
    FillChar(Status, SizeOf(TPCSMediaStatus), #0);
    R := FMediaControl.GetStatus(Status);
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus Start 1-1-1', [])));
    if (R = D_OK) then
    begin
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus Start 1-2', [])));
      Connected := True;

      Player.Stop  := (Status.Idle);

      Player.Cue   := (Status.Cue);
      Player.Play  := (Status.Play) and (FMode = MM_DEC);// and (FLouth.PortNumber >= 0);
      Player.Rec   := (Status.Play) and (FMode = MM_ENC);// and (FLouth.PortNumber < 0);
      Player.Still := (Status.Paused);

//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus Start 1-3', [])));
      if (FMode = MM_DEC) then
      begin
        R := FMediaControl.GetRate(Rate);
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus Start 1-4', [])));
        if (R = D_OK) then
        begin
          Player.Jog     := (Status.Play) and (Rate < 1) and (Rate > -1);
          Player.Shuttle := (Status.Play) and ((Rate > 1) or (Rate < -1));
        end
        else
        begin
          Player.Jog     := False;
          Player.Shuttle := False;
        end;
      end
      else
      begin
        Player.Jog     := False;
        Player.Shuttle := False;
      end;

      Player.PortBusy := False;

      Player.CueDone    := (Status.CueDone);

//      Player.DropFrame := FLOUDevice^.IsDropFrame;

//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus Start 1-5', [])));
      R := FMediaControl.GetTimecode(ttCurrent, CurTC);
      if (R = D_OK) then
      begin
        Player.DropFrame := IsDropFrameTimecodeString(CurTC);
        Player.CurTC := StringToTimecode(CurTC);
      end
      else
      begin
        Player.DropFrame := False;
        Player.CurTC := 0;
      end;

//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus Start 1-6', [])));
      if (FMode = MM_DEC) then
      begin
        R := FMediaControl.GetTimecode(ttRemain, RemainTC);
        if (R = D_OK) then
          Player.RemainTC := StringToTimecode(RemainTC)
        else
          Player.RemainTC := 0;
      end
      else
        Player.RemainTC := 0;
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus Start 1-7', [])));
    end
    else
    begin
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus Start 1-8', [])));
      Connected := False;
      DeviceClose;
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus Start 1-9', [])));
{      if (not FOpened) then }DeviceOpen;
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus Start 1-10', [])));
    end;
  end;

  Result := inherited GetStatus;
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus End', [])));
except
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus error', [])));
    on E : Exception do
    begin
      Assert(False, GetLogDevice(lsError, Format('TDevicePCSMedia.GetStatus exception error. class name = %s, message = %s', [E.ClassName, E.Message])));
    end;
end;
end;

function TDevicePCSMedia.DeviceOpen: Integer;
var
  R: Integer;
begin
  Result := inherited DeviceOpen;

  with FDevice^.PCSMedia do
  begin
    FMediaControl.ServerIP   := String(HostIP);
    FMediaControl.ServerPort := HostPort;
    FMediaControl.Timeout    := TimecodeToMilliSec(GV_ConfigEventVS.CommandTimeout, FR_30);

    R := FMediaControl.Open(FOpened);
    if (R <> D_OK) then
    begin
      Result := D_FALSE;
      Assert(False, GetLogDevice(lsError, Format('DeviceOpen Open failed, Error = %d, ip = %s, port = %d', [Result, FMediaControl.ServerIP, FMediaControl.ServerPort])));
      exit;
    end;

    Assert(False, GetLogDevice(lsNormal, Format('DeviceOpen Open succeeded, ip = %s, port = %d', [FMediaControl.ServerIP, FMediaControl.ServerPort])));
  end;
end;

function TDevicePCSMedia.DeviceClose: Integer;
var
  Closed: Boolean;
begin
  Result := inherited DeviceClose;
  if (Result <> D_OK) then exit;

  Result := FMediaControl.Close(Closed);
  if (Result <> D_OK) then
  begin
    Result := D_FALSE;
    Assert(False, GetLogDevice(lsError, Format('DeviceClose Close failed, Error = %d, ip = %s, port = %d', [Result, FMediaControl.ServerIP, FMediaControl.ServerPort])));
    exit;
  end;

  FOpened := (not Closed);
  Assert(False, GetLogDevice(lsNormal, Format('DeviceClose Close succeeded, ip = %s, port = %d', [FMediaControl.ServerIP, FMediaControl.ServerPort])));
end;

function TDevicePCSMedia.DeviceInit: Integer;
begin
  Result := inherited DeviceInit;

  if (not HasMainControl) then exit;

  try
    Result := FMediaControl.Stop;
    if (Result <> D_OK) then
    begin
      exit;
    end;
  finally
    if (Result <> D_OK) then
    begin
      Assert(False, GetLogDevice(lsError, Format('DeviceInit Stop failed, Error = %d, ip = %s, port = %d', [Result, FMediaControl.ServerIP, FMediaControl.ServerPort])));
    end;
  end;

  Assert(False, GetLogDevice(lsNormal, Format('DeviceInit Stop succeeded, ip = %s, port = %d', [FMediaControl.ServerIP, FMediaControl.ServerPort])));
end;

end.
