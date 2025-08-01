unit UnitDeviceK3DAsyncEngine;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, System.IOUtils, Winapi.Windows,
  UnitDeviceThread, UnitCommons, UnitK3DAsyncEngine;

type
  TDeviceK3DAsyncEngine = class(TDeviceThread)
  private
    FEngine: TKAEngine;
    FScenePlayer: TKAScenePlayer;

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

constructor TDeviceK3DAsyncEngine.Create(ADevice: PDevice);
begin
  inherited Create(ADevice);

  FEngine := TKAEngine.Create;
  FEngine.TimeOut := 2000;
end;

destructor TDeviceK3DAsyncEngine.Destroy;
begin
  FreeAndNil(FEngine);

  inherited Destroy;
end;

procedure TDeviceK3DAsyncEngine.ControlReset;
begin
  inherited;
end;

procedure TDeviceK3DAsyncEngine.ControlCommand;
begin
  inherited;
end;

procedure TDeviceK3DAsyncEngine.ControlClear;
var
  R: HRESULT;
begin
  try
    if (not HasMainControl) then exit;

    if (EventCurr <> nil) and (FEventQueue.IndexOf(EventCurr) < 0) then
    begin
      try
        R := FEngine.UnloadScene(String(EventCurr^.Player.ID.ID));
        if (R <> S_OK) then
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
        R := FEngine.UnloadScene(String(EventNext^.Player.ID.ID));
        if (R <> S_OK) then
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

procedure TDeviceK3DAsyncEngine.ControlChanged;
begin
  try
    if (not HasMainControl) then exit;

  finally
    inherited;
  end;
end;

procedure TDeviceK3DAsyncEngine.ControlStart;
var
  R: HRESULT;
begin
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) and (EventNext^.Status.State = esCued) then
    begin
      R := FScenePlayer.Play(EventNext^.Player.Layer);
      if (R <> S_OK) then
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

procedure TDeviceK3DAsyncEngine.ControlStop;
var
  R: HRESULT;
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

procedure TDeviceK3DAsyncEngine.ControlFinish;
var
  R: HRESULT;
begin
  try
    if (not HasMainControl) then exit;

    if (EventFini <> nil) and (EventFini^.Status.State = esOnAir) then
    begin
      SetEventStatus(EventFini, esFinishing);

      case EventFini^.Player.FinishAction of
        FA_STOP:
        begin
          R := FScenePlayer.Stop(EventFini^.Player.Layer);
          if (R <> S_OK) then
          begin
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlFinish Stop failed. errorcode = %d, id = %s', [R, EventIDToString(EventFini^.EventID)])));

            SetEventStatus(EventFini, esError);
            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlFinish Stop succeeded. id = %s', [EventIDToString(EventFini^.EventID)])));
        end;
        FA_EJECT:
        begin
          R := FScenePlayer.Stop(EventFini^.Player.Layer);
          if (R <> S_OK) then
          begin
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlFinish Stop failed. errorcode = %d, id = %s', [R, EventIDToString(EventFini^.EventID)])));

            SetEventStatus(EventFini, esError);
            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlFinish Stop succeeded. id = %s', [EventIDToString(EventFini^.EventID)])));

          R := FEngine.UnloadScene(EventFini^.Player.ID.ID);
          if (R <> S_OK) then
          begin
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlFinish UnloadScene failed. errorcode = %d, id = %s', [R, EventIDToString(EventFini^.EventID)])));

            SetEventStatus(EventFini, esError);
            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlFinish UnloadScene succeeded. id = %s', [EventIDToString(EventFini^.EventID)])));
        end;
      end;

      FDevice^.Status.Player.Play := False;
      FDevice^.Status.Player.Stop := True;
      UpdateStatus;

      SetEventStatus(EventFini, esFinished);

      SetEventStatus(EventFini, esDone);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlFinish succeeded, id = %s, mediaid = %s', [EventIDToString(EventFini^.EventID), EventFini^.Player.ID.ID])));
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceK3DAsyncEngine.ControlCue;
var
  R: HRESULT;
  FileName: String;
  Scene: IKAScene;
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
          FileName := TPath.Combine(String(FDevice^.Tapi.TemplatePath), String(ID.ID));
          R := FEngine.LoadScene(FileName, ID.ID, Scene);
          if (R <> S_OK) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;

          R := FScenePlayer.Prepare(Layer, Scene);
          if (R <> S_OK) then
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

procedure TDeviceK3DAsyncEngine.ControlSchedule;
begin
  inherited;
end;

procedure TDeviceK3DAsyncEngine.ControlGetStatus;
begin
  inherited;
end;

function TDeviceK3DAsyncEngine.GetStatus: TDeviceStatus;
var
  R: Integer;
begin
//  FillChar(Result, SizeOf(TDeviceStatus), #0);
  Move(FDevice^.Status, Result, SizeOf(TDeviceStatus));
  with Result do
  begin
    EventType := ET_PLAYER;

    R := FEngine.HeartBeat;
    if (R = S_OK) then
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

function TDeviceK3DAsyncEngine.DeviceOpen: Integer;
var
  R: HRESULT;
begin
  Result := inherited DeviceOpen;

  with FDevice^.Tapi do
  begin
    R := FEngine.Connect(True, HostIP, HostPort, 0);
    if (R <> S_OK) then
    begin
      Result := D_FALSE;
      exit;
    end;
  end;

  FOpened := True;

  Result := D_OK;
end;

function TDeviceK3DAsyncEngine.DeviceClose: Integer;
var
  R: HRESULT;
begin
  Result := inherited DeviceClose;
  if (Result <> D_OK) then exit;

  R := FEngine.Disconnect;
  if (R <> S_OK) then
  begin
    Result := D_FALSE;
    exit;
  end;

  FOpened := False;

  Result := D_OK;
end;

function TDeviceK3DAsyncEngine.DeviceInit: Integer;
var
  R: HRESULT;
begin
  Result := inherited DeviceInit;

  if (not HasMainControl) then exit;

  try
    R := FScenePlayer.StopAll;
    if (R <> S_OK) then
    begin
      Result := D_FALSE;
      exit;
    end;

    R := FEngine.UnloadAll;
    if (R <> S_OK) then
    begin
      Result := D_FALSE;
      exit;
    end;
  finally
    if (R <> S_OK) then
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

{function TDeviceK3DAsyncEngine.DCSGetStatus(ABuffer: String): Integer;
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
