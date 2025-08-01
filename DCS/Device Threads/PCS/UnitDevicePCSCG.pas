unit UnitDevicePCSCG;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows,
  UnitTypeConvert,
  UnitDeviceThread, UnitCommons, UnitPCSControl;

type
  TDevicePCSCG = class(TDeviceThread)
  private
    FCGControl: TPCSCGControl;
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

constructor TDevicePCSCG.Create(ADevice: PDevice);
begin
  inherited Create(ADevice);

  FCGControl := TPCSCGControl.Create;
end;

destructor TDevicePCSCG.Destroy;
begin
  if (FCGControl <> nil) then
    FreeAndNil(FCGControl);

  inherited Destroy;
end;

procedure TDevicePCSCG.ControlReset;
begin
  inherited;
end;

procedure TDevicePCSCG.ControlCommand;
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

            FCMDLastResult := FCGControl.GetClipExist(ClipID, ClipExist);
            case ClipExist of
              True: FCMDResultBuffer := Chr($01);
              False: FCMDResultBuffer := Chr($00);
            end;

            if (FCMDLastResult = D_OK) then
              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('ControlCommand GetExist succeeded, id = %s, exist = %s', [ClipID, BoolToStr(ClipExist, True)])))
            else
              Assert(False, GetLogDevice(lsError, FCMDControlBy, Format('ControlCommand GetExist failed, error = %d, id = %s', [FCMDLastResult, ClipID])));
          end;
  {        $23: // Get Size
          begin
            if (Length(FCMDBuffer) < 2) then exit;

            ClipIDLen := PAnsiCharToWord(@FCMDBuffer[1]);
            ClipID := Copy(FCMDBuffer, 3, ClipIDLen);

            FCMDLastResult := FCGControl.GetClipSize(ClipID, ClipSize);
            if (FCMDLastResult = D_OK) then
            begin
              FCMDResultBuffer := DWordToAnsiString(StringToTimecode(ClipSize));

              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('ControlCommand GetSize succeeded, id = %s, size = %s', [ClipID, ClipSize])));
            end
            else
              Assert(False, GetLogDevice(lsError, FCMDControlBy, Format('ControlCommand GetSize failed, error = %d, id = %s', [FCMDLastResult, ClipID])));
          end;  }
        end;
      end;
    end;
  finally
    inherited;
  end;
end;

procedure TDevicePCSCG.ControlClear;
var
  R: Integer;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    R := FCGControl.Stop;
    if (R <> D_OK) then
    begin
      SetEventStatus(EventCurr, esError);
      Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlClear Stop failed. error = %d', [R])));
      exit;
    end;

    Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlClear succeeded.', [])));

//    EventCurr := nil;
//    EventNext := nil;
  finally
    inherited;
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSCG.ControlChanged;
begin
  try
  finally
    inherited;
  end;
end;

procedure TDevicePCSCG.ControlStart;
var
  R: Integer;

  I: Integer;
  ObjectIDs, Contents: TStrings;
//  ObjectID, Contents: String;

  CueTimeOut: Word;
  Status: TPCSMediaStatus;
  CueFrequency, CueStartCount, CueStopCount: Int64; // minimal stop watch
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) {and (EventNext^.Status.State = esCued)} then
    begin
      // Play cue
      R := FCGControl.PlayCue(String(EventNext^.Player.ID.ID));
      if (R <> D_OK) then
      begin
        SetEventStatus(EventNext, esError);
        Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSCG.ControlStart PlayCue failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

        exit;
      end;
      Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDevicePCSCG.ControlStart PlayCue succeeded. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

      // If exist ExtraInfo then set contect of cg object
      if (StrLen(EventNext^.Player.ExtraInfo1) > 0) then
      begin
        ObjectIDs := TStringList.Create;
        try
          ExtractStrings([';'], [], EventNext^.Player.ExtraInfo1, ObjectIDs);

          if (ObjectIDs.Count > 1) then
          begin
            Contents := TStringList.Create;
            try
              ExtractStrings([';'], [], EventNext^.Player.ExtraInfo2, Contents);

              for I := 0 to ObjectIDs.Count - 1 do
              begin
                if (I < Contents.Count) then
                begin
                  R := FCGControl.SetContent(ObjectIDs[I], Contents[I]);
                  if (R <> D_OK) then
                  begin
                    SetEventStatus(EventNext, esError);
                    Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSCG.ControlStart SetContent failed. error = %d, objecid = %s, content = %s', [R, ObjectIDs[I], Contents[I]])));

                    exit;
                  end;
                  Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDevicePCSCG.ControlStart SetContent succeeded. id = %s, mediaid = %s', [ObjectIDs[I], Contents[I]])));
                end;
              end;
            finally
              FreeAndNil(Contents);
            end;
          end;
        finally
          FreeAndNil(ObjectIDs);
        end;
      end;




//        CueTimeOut := TimecodeToMilliSec(GV_ConfigEventCG.CueTimeout);
//
//        QueryPerformanceFrequency(CueFrequency); // this will never return 0 on Windows XP or later
//        if (CueFrequency = 0) then CueFrequency := 10000000;
//
//        QueryPerformanceCounter(CueStartCount);
//        repeat
//          R := FCGControl.GetStatus(Status);
//          if (R <> D_OK) then
//          begin
//            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlStart GetStatus play cue done check failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
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
//        until ((1000 * (CueStopCount - CueStartCount) div CueFrequency) >= CueTimeOut) or (Status.Paused);
//{        CueingTime := 0;
//        while True do
//        begin
//          R := FCGControl.GetStatus(Status);
//          if (R <> D_OK) then
//          begin
//            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlStart GetStatus play cue done check failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
//          end;
//
////          if (Status.CueDone) or (CueingTime >= CueTimeOut) then
//          if (Status.Paused) or (CueingTime >= CueTimeOut) then
//            break;
//
//          Sleep(30);
//          Inc(CueingTime, 30);
//        end; }
//
////        if (not Status.CueDone) then
//        if (not Status.Paused) then
//        begin
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlStart Play cue done failed. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
//
//          SetEventStatus(EventNext, esError);
//          exit;
//        end;

      R := FCGControl.Play;
      if (R <> D_OK) then
      begin
        Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSCG.ControlStart Play failed. error = %d,  id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

        SetEventStatus(EventNext, esError);
        exit;
      end;

      Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDevicePCSCG.ControlStart Play succeeded. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
    end;

    SetEventStatus(EventNext, esOnAir);
    Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDevicePCSCG.ControlStart succeeded, id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
  finally
    inherited;
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSCG.ControlStop;
var
  R: Integer;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventCurr <> nil) and (EventCurr^.Status.State = esOnAir) then
    begin
      SetEventStatus(EventCurr, esFinish);

      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDevicePCSCG.ControlStop succeeded, id = %s, mediaid = %s', [EventIDToString(EventCurr^.EventID), EventCurr^.Player.ID.ID])));
    end;
  finally
    inherited;
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSCG.ControlFinish;
var
  R: Integer;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventFini <> nil) and (Eventfini^.Status.State = esFinish) then
    begin
      SetEventStatus(Eventfini, esFinishing);

      case Eventfini^.Player.FinishAction of
        FA_STOP: // FinishAction에 의해 STOP or STILL 처리
        begin
          R := FCGControl.Stop;
          if (R <> D_OK) then
          begin
            SetEventStatus(Eventfini, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSCG.ControlFinish Stop failed. error = %d,  id = %s, mediaid = %s', [R, EventIDToString(Eventfini^.EventID), Eventfini^.Player.ID.ID])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDevicePCSCG.ControlFinish Stop succeeded. id = %s, mediaid = %s', [EventIDToString(Eventfini^.EventID), Eventfini^.Player.ID.ID])));
        end;
      end;

      SetEventStatus(Eventfini, esFinished);

      SetEventStatus(Eventfini, esDone);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDevicePCSCG.ControlFinish succeeded, id = %s, mediaid = %s', [EventIDToString(Eventfini^.EventID), Eventfini^.Player.ID.ID])));
    end;
  finally
    inherited;
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSCG.ControlCue;
var
  R: Integer;
  Exist: Boolean;
  CueingTime, CueTimeOut: Word;
  Status: TPCSMediaStatus;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) then
    begin
      SetEventStatus(EventNext, esCueing);

      // If current event is nul then eject clip
      if (EventCurr = nil) then
      begin
        R := FCGControl.Stop;
        if (R <> D_OK) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;
      end;

      // Clip exist check
      R := FCGControl.GetClipExist(String(EventNext^.Player.ID.ID), Exist);
      if (R <> D_OK) then
      begin
        SetEventStatus(EventNext, esError);
        Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue GetClipExist failed. error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

        exit;
      end;

      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue GetClipExist succeeded, id = %s, mediaid = %s, exist = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID, BoolToStr(Exist, True)])));

      if (not Exist) then
      begin
        SetEventStatus(EventNext, esError);
        Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue Clip not exist. id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));

        exit;
      end;

{        // Play cue
      R := FCGControl.PlayCue(String(EventNext^.Player.ID.ID));
      if (R <> D_OK) then
      begin
        Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('Failed play cue. errorcode = %d, id = %s', [R, EventIDToString(EventNext^.EventID)])));

        SetEventStatus(EventNext, esError);
        exit;
      end;
      Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('Success play cue. id = %s', [EventIDToString(EventNext^.EventID)])));

      CueTimeOut := TimecodeToMilliSec(GV_ConfigEventCG.CueTimeout);
      CueingTime := 0;
      while True do
      begin
        R := FCGControl.GetStatus(Status);
        if (R <> D_OK) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;

//          if (Status.CueDone) or (CueingTime >= CueTimeOut) then
        if (Status.Paused) or (CueingTime >= CueTimeOut) then
          break;

        Sleep(30);
        Inc(CueingTime, 30);
      end;

//        if (not Status.CueDone) then
      if (not Status.Paused) then
      begin
        Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('Failed play cue done. id = %s', [EventIDToString(EventNext^.EventID)])));

        SetEventStatus(EventNext, esError);
        exit;
      end; }

      SetEventStatus(EventNext, esCued);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue succeeded, id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), EventNext^.Player.ID.ID])));
    end;
  finally
    inherited;
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSCG.ControlSchedule;
begin
  inherited;
end;

procedure TDevicePCSCG.ControlGetStatus;
begin
  inherited;
end;

function TDevicePCSCG.GetStatus: TDeviceStatus;
var
  R: Integer;
  Status: TPCSMediaStatus;
  Rate: Double;
  CurTC, RemainTC: String;
begin
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSCG.GetStatus Start', [])));
          try
  FillChar(Result, SizeOf(TDeviceStatus), #0);
  with Result do
  begin
    EventType := ET_PLAYER;

    FillChar(Status, SizeOf(TPCSMediaStatus), #0);
    R := FCGControl.GetStatus(Status);
    if (R = D_OK) then
    begin
      Connected := True;

      Player.Stop  := (Status.Idle);

      Player.Cue      := (Status.Cue);
      Player.Play     := (Status.Play);
      Player.Rec      := (Status.Play);
      Player.Still    := (Status.Paused);
      Player.CueDone  := (Status.CueDone);

      Player.CurTC := 0;
      Player.RemainTC := 0;
    end
    else
    begin
      Connected := False;
      DeviceClose;
{      if (not FOpened) then }DeviceOpen;
    end;
  end;

  Result := inherited GetStatus;
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSCG.GetStatus End', [])));
except
    on E : Exception do
    begin
      Assert(False, GetLogDevice(lsError, Format('TDevicePCSCG.GetStatus exception error. class name = %s, message = %s', [E.ClassName, E.Message])));
    end;
end;
end;

function TDevicePCSCG.DeviceOpen: Integer;
var
  R: Integer;
begin
  Result := inherited DeviceOpen;

  with FDevice^.PCSCG do
  begin
    FCGControl.ServerIP   := String(HostIP);
    FCGControl.ServerPort := HostPort;
    FCGControl.Timeout    := TimecodeToMilliSec(GV_ConfigEventCG.CommandTimeout, FR_30);

    R := FCGControl.Open(FOpened);
    if (R <> D_OK) then
    begin
      Result := D_FALSE;
      Assert(False, GetLogDevice(lsError, Format('DeviceOpen Open failed, Error = %d, ip = %s, port = %d', [Result, FCGControl.ServerIP, FCGControl.ServerPort])));
      exit;
    end;

    Assert(False, GetLogDevice(lsNormal, Format('DeviceOpen Open succeeded, ip = %s, port = %d', [FCGControl.ServerIP, FCGControl.ServerPort])));
  end;
end;

function TDevicePCSCG.DeviceClose: Integer;
var
  Closed: Boolean;
begin
  Result := inherited DeviceClose;
  if (Result <> D_OK) then exit;

  Result := FCGControl.Close(Closed);
  if (Result <> D_OK) then
  begin
    Result := D_FALSE;
    Assert(False, GetLogDevice(lsError, Format('DeviceClose Close failed, Error = %d, ip = %s, port = %d', [Result, FCGControl.ServerIP, FCGControl.ServerPort])));
    exit;
  end;

  FOpened := (not Closed);
  Assert(False, GetLogDevice(lsNormal, Format('DeviceClose Close succeeded, ip = %s, port = %d', [FCGControl.ServerIP, FCGControl.ServerPort])));
end;

function TDevicePCSCG.DeviceInit: Integer;
begin
  Result := inherited DeviceInit;

  if (not HasMainControl) then exit;

  try
    Result := FCGControl.Stop;
    if (Result <> D_OK) then
    begin
      exit;
    end;
  finally
    if (Result <> D_OK) then
    begin
      Assert(False, GetLogDevice(lsError, Format('Device init failed, error = %d, ip = %s, port = %d', [Result, FCGControl.ServerIP, FCGControl.ServerPort])));
    end;
  end;

  Assert(False, GetLogDevice(lsNormal, Format('Device init succeeded, ip = %s, port = %d', [FCGControl.ServerIP, FCGControl.ServerPort])));
end;

end.
