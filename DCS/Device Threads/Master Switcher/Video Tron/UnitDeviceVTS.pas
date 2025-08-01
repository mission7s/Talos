unit UnitDeviceVTS;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows, Vcl.Forms,
  System.DateUtils,
  UnitDeviceThread, UnitCommons, UnitVideoTronSwitcher, UnitBaseSerial;

type
  TDevicceVTS = class(TDeviceThread)
  private
    FVideoTronSwitcher: TVideoTronSwitcher;
    FPresetDelayTake: Int64;
    FLastTakeTime: TDateTime;
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

constructor TDevicceVTS.Create(ADevice: PDevice);
begin
  inherited Create(ADevice);

  FVideoTronSwitcher := TVideoTronSwitcher.Create(nil);
  FVideoTronSwitcher.TimeOut := 2000;
  FVideoTronSwitcher.LogEnabled := ADevice^.PortLog;

  if (FVideoTronSwitcher.LogEnabled) then
  begin
    FVideoTronSwitcher.LogIsHexcode := True;
    FVideoTronSwitcher.LogPath := GV_ConfigGeneral.PortLogPath + String(ADevice^.Name) + PathDelim;
    FVideoTronSwitcher.LogExt  := GV_ConfigGeneral.PortLogExt;
  end;

  FPresetDelayTake := TimecodeToMilliSec(ADevice^.Vts.PresetDelayTake, FR_30);
  FLastTakeTime := 0;
end;

destructor TDevicceVTS.Destroy;
begin
  if (FVideoTronSwitcher <> nil) then
    FreeAndNil(FVideoTronSwitcher);

  inherited Destroy;
end;

procedure TDevicceVTS.ControlReset;
begin
  inherited;
end;

procedure TDevicceVTS.ControlCommand;
var
  XptInput: Integer;
  VtsMachineStatus: TVtsMachineStatus;
begin
  try
    case FCMD1 of
      $30:
      begin
        case FCMD2 of
          $60: // Set Xpt
          begin
            if (Length(FCMDBuffer) < 4) then exit;

            XptInput := PAnsiCharToInt(@FCMDBuffer[1]);

            FCMDLastResult := FVideoTronSwitcher.DirectProgramChange(XptInput, XptInput);

            if (FCMDLastResult = D_OK) then
              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('Command DirectProgramChange succeeded, input = %d', [XptInput])))
            else
              Assert(False, GetLogDevice(lsError, FCMDControlBy, Format('Command DirectProgramChange failed, error = %d, input = %d', [FCMDLastResult, XptInput])));
          end;
        end;
      end;
      $40:
      begin
        case FCMD2 of
          $60: // Get Xpt
          begin
            if (Length(FCMDBuffer) < 8) then exit;

            FillChar(VtsMachineStatus, SizeOf(TVtsStatus), #0);
            FCMDLastResult := FVideoTronSwitcher.GetMachineStatus(VtsMachineStatus);

            if (FCMDLastResult = D_OK) then
            begin
              XptInput := VtsMachineStatus.OnAirVideoChannel;
              FCMDResultBuffer := IntToAnsiString(XptInput);

              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('Command GetMachineStatus succeeded, input = %d', [XptInput])))
            end
            else
              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('Command GetMachineStatus failed, error = %d', [FCMDLastResult])));
          end;
        end;
      end;
    end;
  finally
    inherited;
  end;
end;

procedure TDevicceVTS.ControlClear;
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

procedure TDevicceVTS.ControlChanged;
begin
  try
    if (not HasMainControl) then exit;

  finally
    inherited;
  end;
end;

procedure TDevicceVTS.ControlStart;
var
  R: Integer;
  VtsKeyNumber: Integer;
  VtsKeyInOut: TVtsInOut;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) and (EventNext^.Status.State = esCued) then
    begin
      with EventNext^.Switcher do
      begin
        // PGM/PST
        if (MainVideo >= 0) and (MainAudio >= 0) then
        begin
          R := FVideoTronSwitcher.Take(VtsTtTransition);
          FLastTakeTime := Now;

          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlStart Take failed. error = %d,  id = %s', [R, EventIDToString(EventNext^.EventID)])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlStart Take succeeded. id = %s', [EventIDToString(EventNext^.EventID)])));
        end
        else if (Key1 >= 0) or (Key2 >= 0) or (Key3 >= 0) or (Key4 >= 0) then
        begin
          if (Key1 >= 0) then
          begin
            VtsKeyNumber := 1;
            if (Key1 = 0) then
              VtsKeyInOut := VtsOut
            else if (Key1 = 1) then
              VtsKeyInOut := vtsIn
            else
              exit;
          end
          else if (Key2 >= 0) then
          begin
            VtsKeyNumber := 2;
            if (Key2 = 0) then
              VtsKeyInOut := VtsOut
            else if (Key2 = 1) then
              VtsKeyInOut := vtsIn
            else
              exit;
          end
          else if (Key3 >= 0) then
          begin
            VtsKeyNumber := 3;
            if (Key3 = 0) then
              VtsKeyInOut := VtsOut
            else if (Key3 = 1) then
              VtsKeyInOut := vtsIn
            else
              exit;
          end
          else if (Key4 >= 0) then
          begin
            VtsKeyNumber := 4;
            if (Key4 = 0) then
              VtsKeyInOut := VtsOut
            else if (Key4 = 1) then
              VtsKeyInOut := vtsIn
            else
              exit;
          end
          else
            exit;

          R := FVideoTronSwitcher.KeyDirectInOut(VtsKeyInOut, VtsKeyNumber, VtsTrCut);
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlStart KeyDirectInOut failed. error = %d,  id = %s', [R, EventIDToString(EventNext^.EventID)])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('ControlStart KeyDirectInOut succeeded. id = %s', [EventIDToString(EventNext^.EventID)])));
        end;
      end;

      SetEventStatus(EventNext, esOnAir);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStart succeeded, id = %s, starttime = %s', [EventIDToString(EventNext^.EventID), EventTimeToDateTimecodeStr(EventNext^.StartTime, ControlFrameRateType)])));
    end;
  finally
    FEventLock.Leave;
    inherited;
  end;
end;

procedure TDevicceVTS.ControlStop;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventCurr <> nil) and (EventCurr^.Status.State = esOnAir) then
    begin
      SetEventStatus(EventCurr, esFinish);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStop succeeded, id = %s, starttime = %s', [EventIDToString(EventCurr^.EventID), EventTimeToDateTimecodeStr(EventCurr^.StartTime, ControlFrameRateType)])));
    end;
  finally
    FEventLock.Leave;
    inherited;
  end;
end;

procedure TDevicceVTS.ControlFinish;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventFini <> nil) and (EventFini^.Status.State = esFinish) then
    begin
      SetEventStatus(EventFini, esDone);
    end;
  finally
    FEventLock.Leave;
    inherited;
  end;
end;

procedure TDevicceVTS.ControlCue;
var
  R: Integer;

  VtsBetweenTakeAfter: Int64;
  VtsVideoChannel, VtsAudioChannel: Byte;
  VtsTT: TVtsTransitionType;
  VtsTR: TVtsTransitionRate;
begin
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

          VtsBetweenTakeAfter := MilliSecondsBetween(Now, FLastTakeTime);
          if (VtsBetweenTakeAfter < FPresetDelayTake) then
            Sleep(FPresetDelayTake - VtsBetweenTakeAfter);

          case EventNext^.Switcher.VideoTransType of
            TT_CUT: VtsTT := vtsTsCut;
            TT_FADE: VtsTT := VtsTsFade;
            TT_CUTFADE: VtsTT := VtsTsCutFade;
            TT_FADECUT: VtsTT := VtsTsFadeCut;
            TT_MIX: VtsTT := VtsTsMix;
          else
            VtsTT := VtsTsCut;
          end;

          case VideoTransRate of
            TR_CUT: VtsTR := VtsTrCut;
            TR_FAST: VtsTR := VtsTrFast;
            TR_MEDIUM: VtsTR := VtsTrMiddle;
            TR_SLOW: VtsTR := VtsTrSlow;
          else
            VtsTR := VtsTrCut;
          end;

          VtsVideoChannel := MainVideo;// + 1;
          VtsAudioChannel := MainAudio;// + 1;

          R := FVideoTronSwitcher.Preset(VtsVideoChannel, VtsAudioChannel, VtsTT, VtsTR);
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('ControlCue Preset failed. error = %d, id = %s', [R, EventIDToString(EventNext^.EventID)])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue Preset succeeded, id = %s, video = %d, audio = %d, transitiontype = %d, transitionrate = %d', [EventIDToString(EventNext^.EventID), VtsVideoChannel, VtsAudioChannel, Integer(VtsTT), Integer(VtsTR)])));
        end;
      end;

      SetEventStatus(EventNext, esCued);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue succeeded, id = %s, starttime = %s', [EventIDToString(EventNext^.EventID), EventTimeToDateTimecodeStr(EventNext^.StartTime, ControlFrameRateType)])));
    end;
  finally
    FEventLock.Leave;
    inherited;
  end;
end;

procedure TDevicceVTS.ControlSchedule;
begin
  inherited;
end;

procedure TDevicceVTS.ControlGetStatus;
begin
  inherited;
end;

function TDevicceVTS.GetStatus: TDeviceStatus;
var
  R: Integer;
  VtsMachineStatus: TVtsMachineStatus;
begin
  FillChar(Result, SizeOf(TDeviceStatus), #0);

  try
    with Result do
    begin
      EventType := ET_SWITCHER;

      FillChar(VtsMachineStatus, SizeOf(TVtsMachineStatus), #0);
      R := FVideoTronSwitcher.GetMachineStatus(VtsMachineStatus);
      if (R = D_OK) then
      begin
        Connected := True;

        Switcher.PGMMainVideo := VtsMachineStatus.OnAirVideoChannel;
        Switcher.PGMMainAudio := VtsMachineStatus.OnAirAudioChannel;

        if (VtsMachineStatus.KeyChannelNumber in [1, 4, 5, 7]) then
          Switcher.PGMKey1 := 1;
        if (VtsMachineStatus.KeyChannelNumber in [2, 4, 6, 7]) then
          Switcher.PGMKey2 := 2;
  //      if (VtsMachineStatus.KeyChannelNumber in [3, 5, 6, 7]) then
  //        Switcher.PGMKey3 := 3;

        if (VtsMachineStatus.AudioOverChannel in [3, 5, 7]) then
          Switcher.PGMMix1 := 1;
        if (VtsMachineStatus.AudioOverChannel in [4, 6, 8]) then
          Switcher.PGMMix2 := 2;

        Switcher.PGMAudioType := 0;

        if (VtsMachineStatus.TransitionType <> VtsTsDsk) then
        begin
          Switcher.PSTMainVideo := VtsMachineStatus.PresetVideoChannel;
          Switcher.PSTMainAudio := VtsMachineStatus.PresetAudioChannel;
        end
        else
        begin
          if (VtsMachineStatus.PresetVideoChannel in [1, 4, 5, 7]) then
            Switcher.PSTKey1 := 1;
          if (VtsMachineStatus.PresetVideoChannel in [2, 4, 6, 7]) then
            Switcher.PSTKey2 := 2;
  //        if (VtsMachineStatus.PresetVideoChannel in [3, 5, 6, 7]) then
  //          Switcher.PSTKey3 := 3;
        end;

        if (VtsMachineStatus.AudioOverChannel in [1, 5, 6]) then
          Switcher.PSTMix1 := 1;
        if (VtsMachineStatus.AudioOverChannel in [2, 7, 8]) then
          Switcher.PSTMix2 := 2;

        Switcher.PSTAudioType := 0;

        case VtsMachineStatus.TransitionType of
          VtsTsCut:
          begin
            Switcher.VideoTransType := 0;
            Switcher.AudioTransType := 0;
          end;
          VtsTsMix:
          begin
            Switcher.VideoTransType := 1;
            Switcher.AudioTransType := 1;
          end;
          VtsTsFade:
          begin
            Switcher.VideoTransType := 2;
            Switcher.AudioTransType := 2;
          end;
          VtsTsFadeCut:
          begin
            Switcher.VideoTransType := 3;
            Switcher.AudioTransType := 3;
          end;
          VtsTsCutFade:
          begin
            Switcher.VideoTransType := 4;
            Switcher.AudioTransType := 4;
          end;
          VtsTsWipe:
          begin
            Switcher.VideoTransType := 5;
            Switcher.AudioTransType := 5;
          end;
        end;

        case VtsMachineStatus.TransitionRate of
          VtsTrCut:
          begin
            Switcher.VideoTransRate := 0;
            Switcher.AudioTransRate := 0;
          end;
          VtsTrFast:
          begin
            Switcher.VideoTransRate := 1;
            Switcher.AudioTransRate := 1;
          end;
          VtsTrMiddle:
          begin
            Switcher.VideoTransRate := 2;
            Switcher.AudioTransRate := 2;
          end;
          VtsTrSlow:
          begin
            Switcher.VideoTransRate := 3;
            Switcher.AudioTransRate := 3;
          end;
        end;
      end
      else
      begin
        Assert(False, GetLogDevice(lsError, Format('GetStatus GetMachineStatus failed, Error = %d', [Integer(R)])));

        Connected := False;
        DeviceClose;
  {      if (not FOpened) then }DeviceOpen;
      end;

      Switcher.IsTransition := (FVideoTronSwitcher.Status.OnStartTransition);// and (not FVideoTronSwitcher.Status.OnEndTransition);
      Switcher.IsPreroll    := False;
      Switcher.IsRemoteOn   := (not FVideoTronSwitcher.Status.OnButtonInterrupt);
      Switcher.SMPTETime    := Now;
    end;

    Result := inherited GetStatus;
  except
    on E : Exception do
    begin
      Assert(False, GetLogDevice(lsError, Format('TDevicceVTS.GetStatus exception error. class name = %s, message = %s', [E.ClassName, E.Message])));
    end;
  end;
end;

function TDevicceVTS.DeviceOpen: Integer;
var
  R: Integer;
  VtsMachineStatus: TVtsMachineStatus;
begin
  Result := inherited DeviceOpen;

  with FDevice^.VTS do
  begin
    if (FVideoTronSwitcher.Connected) then
      FVideoTronSwitcher.Disconnect;

    FVideoTronSwitcher.ComPort         := PortConfig.PortNum;
    FVideoTronSwitcher.ComPortBaudRate := PortConfig.BaudRate;
    FVideoTronSwitcher.ComPortDataBits := PortConfig.DataBits;
    FVideoTronSwitcher.ComPortStopBits := PortConfig.StopBits;
    FVideoTronSwitcher.ComPortParity   := PortConfig.Parity;

    if (not FVideoTronSwitcher.Connect) then
    begin
      Result := D_FALSE;
      Assert(False, GetLogDevice(lsError, Format('Device open failed, Connect failed.', [])));

      exit;
    end;

    FillChar(VtsMachineStatus, SizeOf(TVtsStatus), #0);
    R := FVideoTronSwitcher.GetMachineStatus(VtsMachineStatus);
    if (R <> D_OK) then
    begin
      Result := D_FALSE;
      Assert(False, GetLogDevice(lsError, Format('Device open failed, GetMachineStatus failed, Error = %d.', [R])));

      exit;
    end;

    Assert(False, GetLogDevice(lsNormal, Format('Device open succeeded.', [])));
  end;

  FOpened := True;

//  Result := DeviceInit;
end;

function TDevicceVTS.DeviceClose: Integer;
begin
  Result := inherited DeviceClose;
  if (Result <> D_OK) then exit;

//  if (FVideoTronSwitcher.Connected) then
  begin
    if (not FVideoTronSwitcher.Disconnect) then
    begin
      Result := D_FALSE;
      Assert(False, GetLogDevice(lsError, Format('Device close failed, not disconnect.', [])));

      exit;
    end;

    Assert(False, GetLogDevice(lsNormal, Format('Device close succeeded, disconnect.', [])));
  end;

{  if (not FVideoTronSwitcher.Connected) then
  begin
    Result := D_FALSE;
    exit;
  end;

  if (not FVideoTronSwitcher.Disconnect) then
  begin
    Result := D_FALSE;
    exit;
  end; }

  FOpened := False;

  Result := D_OK;
end;

function TDevicceVTS.DeviceInit: Integer;
begin
  Result := inherited DeviceInit;

  if (HasMainControl) then
  begin
    Assert(False, GetLogDevice(lsNormal, Format('Device init succeeded', [])));
  end;
end;

end.
