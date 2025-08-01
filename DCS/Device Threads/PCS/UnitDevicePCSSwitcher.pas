unit UnitDevicePCSSwitcher;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows,
  UnitDeviceThread, UnitCommons, UnitPCSControl, Forms;

type
  TDevicePCSSwitcher = class(TDeviceThread)
  private
    FSwitcherControl: TPCSSwitcherControl;
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

constructor TDevicePCSSwitcher.Create(ADevice: PDevice);
begin
  inherited Create(ADevice);

  FSwitcherControl := TPCSSwitcherControl.Create;
end;

destructor TDevicePCSSwitcher.Destroy;
begin
  if (FSwitcherControl <> nil) then
    FreeAndNil(FSwitcherControl);

  inherited Destroy;
end;

procedure TDevicePCSSwitcher.ControlReset;
begin
  inherited;
end;

procedure TDevicePCSSwitcher.ControlCommand;
begin
  inherited;
end;

procedure TDevicePCSSwitcher.ControlClear;
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
    inherited;
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSSwitcher.ControlChanged;
begin
  try
    if (not HasMainControl) then exit;

  finally
    inherited;
  end;
end;

procedure TDevicePCSSwitcher.ControlStart;
var
  R: Integer;

  KeyEnables: TPCSKeyBusEnables;
  BusEnables: TPCSSwitchBusEnables;

  I: Integer;
  KeyEnable: Boolean;
begin
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSSwitcher.ControlStart Start', [])));
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) {and (EventNext^.Status.State = esCued)} then
    begin
      with EventNext^.Switcher do
      begin
        // PGM/PST
        if (MainVideo >= 0) and (MainAudio >= 0) then
        begin
          R := FSwitcherControl.StartTransition;
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlStart StartTransition failed. error = %d,  id = %s', [R, EventIDToString(EventNext^.EventID)])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlStart StartTransition succeeded. id = %s', [EventIDToString(EventNext^.EventID)])));
        end
        else if (Key1 >= 0) or (Key2 >= 0) or (Key3 >= 0) or (Key4 >= 0) or
                (Key5 >= 0) or (Key6 >= 0) or (Key7 >= 0) or (Key8 >= 0) then
        begin
          KeyEnables := TPCSKeyBusEnables.Create;
          try
            for I := 0 to 8 - 1 do
            begin
              BusEnables := TPCSSwitchBusEnables.Create;

              case I of
                0: if (Key1 >= 0) then BusEnables.Add(TPCSSwitchBusEnable.Create(sbProgram, (Key1 > 0)));
                1: if (Key2 >= 0) then BusEnables.Add(TPCSSwitchBusEnable.Create(sbProgram, (Key2 > 0)));
                2: if (Key3 >= 0) then BusEnables.Add(TPCSSwitchBusEnable.Create(sbProgram, (Key3 > 0)));
                3: if (Key4 >= 0) then BusEnables.Add(TPCSSwitchBusEnable.Create(sbProgram, (Key4 > 0)));
                4: if (Key5 >= 0) then BusEnables.Add(TPCSSwitchBusEnable.Create(sbProgram, (Key5 > 0)));
                5: if (Key6 >= 0) then BusEnables.Add(TPCSSwitchBusEnable.Create(sbProgram, (Key6 > 0)));
                6: if (Key7 >= 0) then BusEnables.Add(TPCSSwitchBusEnable.Create(sbProgram, (Key7 > 0)));
                7: if (Key8 >= 0) then BusEnables.Add(TPCSSwitchBusEnable.Create(sbProgram, (Key8 > 0)));
              end;

//                  BusEnables.Add(TPCSSwitchBusEnable.Create(sbProgram, KeyEnable));
//                BusEnables.Add(TPCSSwitchBusEnable.Create(sbPreset, False));
//                BusEnables.Add(TPCSSwitchBusEnable.Create(sbOutput1, False));
//                BusEnables.Add(TPCSSwitchBusEnable.Create(sbOutput2, False));

              KeyEnables.Add(BusEnables);
            end;

{
            R := FSwitcherControl.KeyTake(KeyEnables);
            if (R <> D_OK) then
            begin
              SetEventStatus(EventNext, esError);
              Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlStart KeyTake failed. error = %d,  id = %s', [R, EventIDToString(EventNext^.EventID)])));

              exit;
            end;
            Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlStart KeyTake succeeded. id = %s', [EventIDToString(EventNext^.EventID)])));
}

            R := FSwitcherControl.KeyTransition(KeyEnables);
            if (R <> D_OK) then
            begin
              SetEventStatus(EventNext, esError);
              Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlStart KeyTransition failed. error = %d,  id = %s', [R, EventIDToString(EventNext^.EventID)])));

              exit;
            end;
            Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlStart KeyTransition succeeded. id = %s', [EventIDToString(EventNext^.EventID)])));
          finally
//              for I := 4 - 1 to 0 do
//                FreeAndNil(KeyEnables[I]);

            FreeAndNil(KeyEnables);
          end;
        end;
      end;

      SetEventStatus(EventNext, esOnAir);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStart succeeded, id = %s, starttime = %s', [EventIDToString(EventNext^.EventID), EventTimeToDateTimecodeStr(EventNext^.StartTime, ControlFrameRateType)])));
    end;
  finally
    inherited;
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSSwitcher.ControlStart End', [])));
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSSwitcher.ControlStop;
begin
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSSwitcher.ControlStop Start', [])));
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventCurr <> nil) {and (EventCurr^.Status.State = esOnAir)} then
    begin
      SetEventStatus(EventCurr, esFinish);

      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDevicePCSSwitcher.ControlStop succeeded, id = %s, starttime = %s', [EventIDToString(EventCurr^.EventID), EventTimeToDateTimecodeStr(EventCurr^.StartTime, ControlFrameRateType)])));
    end;
  finally
    inherited;
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSSwitcher.ControlStop End', [])));
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSSwitcher.ControlFinish;
begin
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSSwitcher.ControlFinish Start', [])));
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventFini <> nil) {and (EventFini^.Status.State = esFinish)} then
    begin
      SetEventStatus(EventFini, esDone);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDevicePCSSwitcher.ControlFinish succeeded, id = %s, starttime = %s', [EventIDToString(EventFini^.EventID), EventTimeToDateTimecodeStr(EventFini^.StartTime, ControlFrameRateType)])));
    end;
  finally
    inherited;
          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSSwitcher.ControlFinish End', [])));
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSSwitcher.ControlCue;
var
  R: Integer;
  TTName: String;
  TRName: String;

  BusEnables: TPCSSwitchBusEnables;
begin
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSSwitcher.ControlCue Start', [])));
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) then
    begin
      SetEventStatus(EventNext, esCueing);

      with EventNext^.Switcher do
      begin
        // PGM/PST
        if (MainVideo >= 0) and (MainAudio >= 0) then
        begin
          case VideoTransType of
            TT_CUT: TTName := 'fade';//'cut';
            TT_FADE: TTName := 'fade';
            TT_CUTFADE: TTName := 'cut-fade';
            TT_FADECUT: TTName := 'fade-cut';
            TT_MIX: TTName := 'pixelate';//'cut';
          else
            TTName := 'fade';//'cut';
          end;

//            if (TTName <> 'cut') then
          begin
            R := FSwitcherControl.SetTransitionType(TTName);
            if (R <> D_OK) then
            begin
              SetEventStatus(EventNext, esError);
              Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue SetTransitionType failed. error = %d, id = %s', [R, EventIDToString(EventNext^.EventID)])));

              exit;
            end;
            Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue SetTransitionType succeeded, id = %s, transitiontype = %s', [EventIDToString(EventNext^.EventID), TTName])));
          end;

          // if transition type is not cut then set transition rate
          if (VideoTransType <> TT_CUT) then
          begin
            case VideoTransRate of
              TR_CUT: TRName := '0';
              TR_FAST: TRName := 'fast';
              TR_MEDIUM: TRName := 'medium';
              TR_SLOW: TRName := 'slow';
            else
              TRName := '0';
            end;
          end
          else
            TRName := '0';

          R := FSwitcherControl.SetTransitionRate(TRName);
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue SetTransitionRate failed. error = %d, id = %s', [R, EventIDToString(EventNext^.EventID)])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue SetTransitionRate succeeded, id = %s, transitionrate = %s', [EventIDToString(EventNext^.EventID), TRName])));

          BusEnables := TPCSSwitchBusEnables.Create;
          try
//              BusEnables.Add(TPCSSwitchBusEnable.Create(sbProgram, False));
            BusEnables.Add(TPCSSwitchBusEnable.Create(sbPreset, True));
//              BusEnables.Add(TPCSSwitchBusEnable.Create(sbOutput1, False));
//              BusEnables.Add(TPCSSwitchBusEnable.Create(sbOutput2, False));

            R := FSwitcherControl.CrosspointTake(MainVideo, BusEnables);
            if (R <> D_OK) then
            begin
              SetEventStatus(EventNext, esError);
              Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue CrosspointTake failed. error = %d, id = %s', [R, EventIDToString(EventNext^.EventID)])));

              exit;
            end;
            Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue CrosspointTake succeeded, id = %s, crosspoint = %d', [EventIDToString(EventNext^.EventID), MainVideo])));
          finally
            FreeAndNil(BusEnables);
          end;

          R := FSwitcherControl.NextTransition(True, False);
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue NextTransition failed. error = %d, id = %s', [R, EventIDToString(EventNext^.EventID)])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue NextTransition succeeded, id = %s', [EventIDToString(EventNext^.EventID)])));
        end;
      end;

      SetEventStatus(EventNext, esCued);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue succeeded, id = %s, starttime = %s', [EventIDToString(EventNext^.EventID), EventTimeToDateTimecodeStr(EventNext^.StartTime, ControlFrameRateType)])));
    end;
  finally
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSSwitcher.ControlCue End', [])));
    inherited;
    FEventLock.Leave;
  end;
end;

procedure TDevicePCSSwitcher.ControlSchedule;
begin
  inherited;
end;

procedure TDevicePCSSwitcher.ControlGetStatus;
begin
  inherited;
end;

function TDevicePCSSwitcher.GetStatus: TDeviceStatus;
var
  R: Integer;
  Status: TSwitcherStatus;

  StatusStr: String;
  Crosspoint: Integer;
begin
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSSwitcher.GetStatus Start', [])));
          try
  FillChar(Result, SizeOf(TDeviceStatus), #0);
  with Result do
  begin
    EventType := ET_SWITCHER;

    FillChar(Status, SizeOf(TSwitcherStatus), #0);
    R := FSwitcherControl.GetStatus(StatusStr);
    if (R = D_OK) then
    begin
      Connected := True;

//      Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('Status = %s', [StatusStr])));


      R := FSwitcherControl.GetCrosspointTake(sbProgram, Crosspoint);
      if (R = D_OK) then
      begin
//        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('Success get crosspoint take. Program crosspoint = %d', [Crosspoint])));

        Switcher.PGMMainVideo := Crosspoint;
        Switcher.PGMMainAudio := Crosspoint;
      end;


      Switcher.PGMAudioType := 0;

      R := FSwitcherControl.GetCrosspointTake(sbPreset, Crosspoint);
      if (R = D_OK) then
      begin
//        Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('Success get crosspoint take. Preset crosspoint = %d', [Crosspoint])));

        Switcher.PSTMainVideo := Crosspoint;
        Switcher.PSTMainAudio := Crosspoint;
      end;

      Switcher.PSTAudioType := 0;
    end
    else
    begin
      Connected := False;
      DeviceClose;
{      if (not FOpened) then }DeviceOpen;
    end;

    Switcher.IsTransition := (StatusStr = 'transitional');
    Switcher.IsPreroll    := False;
    Switcher.IsRemoteOn   := True;
    Switcher.SMPTETime    := Now;
  end;

  Result := inherited GetStatus;
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSSwitcher.GetStatus End', [])));
except
//          Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDevicePCSMedia.GetStatus error', [])));
    on E : Exception do
    begin
      Assert(False, GetLogDevice(lsError, Format('TDevicePCSSwitcher.GetStatus exception error. class name = %s, message = %s', [E.ClassName, E.Message])));
    end;
end;
end;

function TDevicePCSSwitcher.DeviceOpen: Integer;
var
  R: Integer;
begin
  Result := inherited DeviceOpen;

  with FDevice^.PCSMedia do
  begin
    FSwitcherControl.ServerIP   := String(HostIP);
    FSwitcherControl.ServerPort := HostPort;
    FSwitcherControl.Timeout    := TimecodeToMilliSec(GV_ConfigEventMCS.CommandTimeout, FR_30);

    R := FSwitcherControl.Open(FOpened);
    if (R <> D_OK) then
    begin
      Result := D_FALSE;
      Assert(False, GetLogDevice(lsError, Format('DeviceOpen Open failed, Error = %d, ip = %s, port = %d', [Result, FSwitcherControl.ServerIP, FSwitcherControl.ServerPort])));
      exit;
    end;

    Assert(False, GetLogDevice(lsNormal, Format('DeviceOpen Open succeeded, ip = %s, port = %d', [FSwitcherControl.ServerIP, FSwitcherControl.ServerPort])));
  end;
end;

function TDevicePCSSwitcher.DeviceClose: Integer;
var
  Closed: Boolean;
begin
  Result := inherited DeviceClose;
  if (Result <> D_OK) then exit;

  Result := FSwitcherControl.Close(Closed);
  if (Result <> D_OK) then
  begin
    Result := D_FALSE;
    Assert(False, GetLogDevice(lsError, Format('DeviceClose Close failed, Error = %d, ip = %s, port = %d', [Result, FSwitcherControl.ServerIP, FSwitcherControl.ServerPort])));
    exit;
  end;

  FOpened := (not Closed);
  Assert(False, GetLogDevice(lsNormal, Format('DeviceClose Close succeeded, ip = %s, port = %d', [FSwitcherControl.ServerIP, FSwitcherControl.ServerPort])));
end;

function TDevicePCSSwitcher.DeviceInit: Integer;
begin
  Result := inherited DeviceInit;

  if (not HasMainControl) then exit;

  Assert(False, GetLogDevice(lsNormal, Format('Device init succeeded, IP = %s, Port = %d', [FSwitcherControl.ServerIP, FSwitcherControl.ServerPort])));
end;

end.
