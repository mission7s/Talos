unit UnitDeviceLINE;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows,
  UnitDeviceThread, UnitCommons;

type
  TDevicceLINE = class(TDeviceThread)
  private
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

constructor TDevicceLINE.Create(ADevice: PDevice);
begin
  inherited Create(ADevice);
end;

destructor TDevicceLINE.Destroy;
begin
  inherited Destroy;
end;

procedure TDevicceLINE.ControlReset;
begin
  inherited;
end;

procedure TDevicceLINE.ControlCommand;
begin
  inherited;
end;

procedure TDevicceLINE.ControlClear;
begin
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
    inherited;
  end;
end;

procedure TDevicceLINE.ControlChanged;
begin
  inherited;
end;

procedure TDevicceLINE.ControlStart;
begin
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) and (EventNext^.Status.State = esCued) then
    begin
      SetEventStatus(EventNext, esOnAir);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStart succeeded, id = %s, starttime = %s', [EventIDToString(EventNext^.EventID), EventTimeToDateTimecodeStr(EventNext^.StartTime, ControlFrameRateType)])));
    end;
  finally
    inherited;
  end;
end;

procedure TDevicceLINE.ControlStop;
begin
  try
    if (not HasMainControl) then exit;

    if (EventCurr <> nil) and (EventCurr^.Status.State = esOnAir) then
    begin
      SetEventStatus(EventCurr, esFinish);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStop succeeded, id = %s, starttime = %s', [EventIDToString(EventCurr^.EventID), EventTimeToDateTimecodeStr(EventCurr^.StartTime, ControlFrameRateType)])));
    end;
  finally
    inherited;
  end;
end;

procedure TDevicceLINE.ControlFinish;
begin
  try
    if (not HasMainControl) then exit;

    if (EventFini <> nil) and (EventFini^.Status.State = esFinish) then
    begin
      SetEventStatus(EventFini, esDone);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlFinish succeeded, id = %s, mediaid = %s', [EventIDToString(EventFini^.EventID), EventFini^.Player.ID.ID])));
    end;
  finally
    inherited;
  end;
end;

procedure TDevicceLINE.ControlCue;
begin
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) then
    begin
      SetEventStatus(EventNext, esCueing);

      SetEventStatus(EventNext, esCued);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue succeeded, id = %s, starttime = %s', [EventIDToString(EventNext^.EventID), EventTimeToDateTimecodeStr(EventNext^.StartTime, ControlFrameRateType)])));
    end;
  finally
    inherited;
  end;
end;

procedure TDevicceLINE.ControlSchedule;
begin
  inherited;
end;

procedure TDevicceLINE.ControlGetStatus;
begin
  inherited;
end;

function TDevicceLINE.GetStatus: TDeviceStatus;
begin
  FillChar(Result, SizeOf(TDeviceStatus), #0);
  with Result do
  begin
    EventType := ET_PLAYER;

    Connected := True;

    Player.Play := (EventCurr <> nil) and (EventCurr^.TakeEvent);
    Player.Stop := (not Player.Play);

    Player.CurTC    := 0;
    Player.RemainTC := 0;
  end;

//  Assert(False, GetLogDevice(lsError, FCMDControlBy, Format('GetStatus, Handle = %d', [Integer(Device^.Handle)])));
  Result := inherited GetStatus;
end;

function TDevicceLINE.DeviceOpen: Integer;
begin
  Result := inherited DeviceOpen;

  FOpened := True;

//  Result := DeviceInit;

  Assert(False, GetLogDevice(lsNormal, Format('DeviceOpen Open succeeded', [])));
end;

function TDevicceLINE.DeviceClose: Integer;
begin
  Result := inherited DeviceClose;
  if (Result <> D_OK) then exit;

  FOpened := False;

  Result := D_OK;
  Assert(False, GetLogDevice(lsNormal, Format('DeviceClose Close succeeded', [])));
end;

function TDevicceLINE.DeviceInit: Integer;
begin
  Result := inherited DeviceInit;

  if (not HasMainControl) then exit;

  Assert(False, GetLogDevice(lsNormal, Format('Device init succeeded.', [])));
end;

end.
