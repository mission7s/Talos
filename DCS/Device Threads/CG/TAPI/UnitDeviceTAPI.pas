unit UnitDeviceTAPI;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, System.IOUtils, Winapi.Windows,
  UnitDeviceThread, UnitCommons, UnitTAPI;

type
  TDeviceTAPI = class(TDeviceThread)
  private
    FTAP: TTAP;

    FPageMode: String;
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

constructor TDeviceTAPI.Create(ADevice: PDevice);
begin
  inherited Create(ADevice);
  FTAP := TTAP.Create;
  FTAP.TimeOut := 2000;
end;

destructor TDeviceTAPI.Destroy;
begin
  FreeAndNil(FTAP);

  inherited Destroy;
end;

procedure TDeviceTAPI.ControlReset;
begin
  inherited;
end;

procedure TDeviceTAPI.ControlCommand;
begin
  inherited;
end;

procedure TDeviceTAPI.ControlClear;
var
  R: Integer;
begin
  try
    if (not HasMainControl) then exit;

    if (EventCurr <> nil) and (FEventQueue.IndexOf(EventCurr) < 0) then
    begin
      try
        R := FTAP.UnloadPage(String(EventCurr^.Player.ID.ID));
        if (R <> T3D_TRUE) then
        begin
          SetEventStatus(EventCurr, esError);
          exit;
        end;
      finally
//        EventCurr := nil;
      end;
    end;

    if (EventNext <> nil) and (FEventQueue.IndexOf(EventNext) < 0) then
    begin
      try
        R := FTAP.UnloadPage(String(EventNext^.Player.ID.ID));
        if (R <> T3D_TRUE) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;
      finally
//        EventNext := nil;
      end;
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceTAPI.ControlChanged;
begin
  try
    if (not HasMainControl) then exit;

  finally
    inherited;
  end;
end;

procedure TDeviceTAPI.ControlStart;
var
  R: Integer;
begin
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) and (EventNext^.Status.State = esCued) then
    begin
      R := FTAP.Play(LAYER_BASE);
      if (R <> T3D_TRUE) then
      begin
        SetEventStatus(EventNext, esError);
        exit;
      end;

      FDevice^.Status.Player.CueDone := False;
      FDevice^.Status.Player.Play    := True;
      FDevice^.Status.Player.Stop    := False;
      UpdateStatus;

      SetEventStatus(EventNext, esOnAir);
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceTAPI.ControlStop;
var
  R: Integer;
begin
  try
    if (not HasMainControl) then exit;

    if (EventCurr <> nil) and (EventCurr^.Status.State = esOnAir) then
    begin
      SetEventStatus(EventCurr, esFinish);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStop succeeded, id = %s, mediaid = %s', [EventIDToString(EventCurr^.EventID), EventCurr^.Player.ID.ID])));
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceTAPI.ControlFinish;
var
  R: Integer;
begin
  try
    if (not HasMainControl) then exit;

    if (EventFini <> nil) and (EventFini^.Status.State = esOnAir) then
    begin
      SetEventStatus(EventFini, esFinishing);

      case EventFini^.Player.FinishAction of
        FA_STOP:
        begin
          R := FTAP.Stop;
          if (R <> T3D_TRUE) then
          begin
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlFinish Stop failed. errorcode = %d, id = %s', [R, EventIDToString(EventFini^.EventID)])));

            SetEventStatus(EventFini, esError);
            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlFinish Stop succeeded. id = %s', [EventIDToString(EventFini^.EventID)])));
        end;
        FA_EJECT:
        begin
          R := FTAP.Stop;
          if (R <> T3D_TRUE) then
          begin
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlFinish Stop failed. errorcode = %d, id = %s', [R, EventIDToString(EventFini^.EventID)])));

            SetEventStatus(EventFini, esError);
            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlFinish Stop succeeded. id = %s', [EventIDToString(EventFini^.EventID)])));

          R := FTAP.UnloadPage(EventFini^.Player.ID.ID);
          if (R <> T3D_TRUE) then
          begin
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlFinish UnloadPage failed. errorcode = %d, id = %s', [R, EventIDToString(EventFini^.EventID)])));

            SetEventStatus(EventFini, esError);
            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlFinish UnloadPage succeeded. id = %s', [EventIDToString(EventFini^.EventID)])));
        end;
      end;

      FDevice^.Status.Player.Play := False;
      FDevice^.Status.Player.Stop := True;
      UpdateStatus;

      SetEventStatus(EventCurr, esFinished);

      SetEventStatus(EventCurr, esDone);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlFinish succeeded, id = %s, mediaid = %s', [EventIDToString(EventFini^.EventID), EventFini^.Player.ID.ID])));
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceTAPI.ControlCue;
var
  R: Integer;
  FileName: String;
begin
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) then
    begin
      SetEventStatus(EventNext, esCueing);

      FDevice^.Status.Player.Cue     := True;
      FDevice^.Status.Player.CueDone := False;
      UpdateStatus;

      try
        with EventNext^.Player do
        begin
          if (not FOpened) then
          begin
            SetEventStatus(EventNext, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlCue device not opened, id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), ID.ID])));
            exit;
          end;

          FileName := TPath.Combine(String(FDevice^.Tapi.TemplatePath), String(ID.ID));
          R := FTAP.LoadPage(FileName, ID.ID);
          if (R <> T3D_TRUE) then
          begin
            SetEventStatus(EventNext, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlCue LoadPage failed, error = %d, id = %s, mediaid = %s', [R, EventIDToString(EventNext^.EventID), ID.ID])));
            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue LoadPage succeeded, id = %s, mediaid = %s', [EventIDToString(EventNext^.EventID), ID.ID])));

          R := FTAP.PreparePage(ID.ID, LAYER_BASE, True);
          if (R <> T3D_TRUE) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;

          R := FTAP.QueryPageMode(ID.ID, FPageMode);
          if (R <> T3D_TRUE) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;
        end;

        FDevice^.Status.Player.CueDone := True;
      finally
        FDevice^.Status.Player.Cue     := False;
      end;
      UpdateStatus;

      SetEventStatus(EventNext, esCued);
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceTAPI.ControlSchedule;
begin
  inherited;
end;

procedure TDeviceTAPI.ControlGetStatus;
begin
  inherited;
end;

function TDeviceTAPI.GetStatus: TDeviceStatus;
var
  R: Integer;
begin
  // 임시로 막음
  FillChar(Result, SizeOf(TDeviceStatus), #0);
  with Result do
  begin
    EventType := ET_PLAYER;

    Connected := False;

    Player.CurTC    := 0;
    Player.RemainTC := 0;
  end;

  Result := inherited GetStatus;

  exit;

//  FillChar(Result, SizeOf(TDeviceStatus), #0);
//  Move(FDevice^.Status, Result, SizeOf(TDeviceStatus));
  with Result do
  begin
    EventType := ET_PLAYER;

    R := FTAP.Hello(True);
    if (R = T3D_TRUE) then
    begin
      Connected := True;
    end
    else
    begin
      Connected := False;
      DeviceClose;
{      if (not FOpened) then }DeviceOpen;
    end;

    Player.CurTC    := 0;
    Player.RemainTC := 0;
  end;

  Result := inherited GetStatus;
end;

function TDeviceTAPI.DeviceOpen: Integer;
var
  R: Integer;
begin
  // FTAP.Connect시 Handle이 계속 추가됨, 임시적으러 호출하지 않도록 처리
  Result := inherited DeviceOpen;
  FOpened := False;
  exit;

  with FDevice^.Tapi do
  begin
    R := FTAP.Connect(True, HostIP, HostPort);
    if (R <> T3D_TRUE) then
    begin
      Result := D_FALSE;
      Assert(False, GetLogDevice(lsError, Format('Device open failed, Error = %d, IP = %s, Port = %d', [R, HostIP, HostPort])));

      exit;
    end;

    Assert(False, GetLogDevice(lsNormal, Format('Device open succeeded, IP = %s, Port = %d', [HostIP, HostPort])));
  end;

  FOpened := True;

  Result := D_OK;
end;

function TDeviceTAPI.DeviceClose: Integer;
var
  R: Integer;
begin
  Result := inherited DeviceClose;
  if (Result <> D_OK) then exit;
  exit;

  R := FTAP.Destroys;
  if (R <> T3D_TRUE) then
  begin
    Result := D_FALSE;
    Assert(False, GetLogDevice(lsError, Format('Device close failed, Error = %d', [R])));

    exit;
  end;

  Assert(False, GetLogDevice(lsNormal, Format('Device close succeeded', [])));

  FOpened := False;

  Result := D_OK;
end;

function TDeviceTAPI.DeviceInit: Integer;
var
  R: Integer;
begin
  Result := inherited DeviceInit;
//  exit;

  if (not HasMainControl) then exit;

  try
    R := FTAP.Stop;
    if (R <> T3D_TRUE) then
    begin
      Result := D_FALSE;
      exit;
    end;

    R := FTAP.UnloadAllPages;
    if (R <> T3D_TRUE) then
    begin
      Result := D_FALSE;
      exit;
    end;
  finally
    if (R <> T3D_TRUE) then
    begin
      Assert(False, GetLogDevice(lsError, Format('Device init failed, error = %d', [R])));
    end;
  end;

  FDevice^.Status.Player.CueDone := False;
  FDevice^.Status.Player.Play    := False;
  FDevice^.Status.Player.Stop    := True;
  UpdateStatus;

  Assert(False, GetLogDevice(lsNormal, Format('Device init succeeded.', [])));
end;

{function TDeviceTAPI.DCSGetStatus(ABuffer: String): Integer;
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
