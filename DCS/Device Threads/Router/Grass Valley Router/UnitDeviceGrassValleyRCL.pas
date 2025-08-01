unit UnitDeviceGrassValleyRCL;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows,
  UnitDeviceThread, UnitCommons, UnitBaseSerial, UnitGrassValleyRCL;

type
  TDeviceGrassValleyRCL = class(TDeviceThread)
  private
    FGrassValleyRCL: TGrassValleyRCL;
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

constructor TDeviceGrassValleyRCL.Create(ADevice: PDevice);
begin
  inherited Create(ADevice);

  FGrassValleyRCL := TGrassValleyRCL.Create(nil);
  FGrassValleyRCL.ControlType := ADevice^.GvRCL.ControlType;
  FGrassValleyRCL.LogEnabled := ADevice^.PortLog;

  if (FGrassValleyRCL.LogEnabled) then
  begin
    FGrassValleyRCL.LogIsHexcode := True;
    FGrassValleyRCL.LogPath := GV_ConfigGeneral.PortLogPath + String(ADevice^.Name) + PathDelim;
    FGrassValleyRCL.LogExt  := GV_ConfigGeneral.PortLogExt;
  end;
end;

destructor TDeviceGrassValleyRCL.Destroy;
begin
  if (FGrassValleyRCL <> nil) then
    FreeAndNil(FGrassValleyRCL);

  inherited Destroy;
end;

procedure TDeviceGrassValleyRCL.ControlReset;
begin
  inherited;
end;

procedure TDeviceGrassValleyRCL.ControlCommand;
var
  DstEntry, SrcEntry: TFullQualEntry;
  DstLevel, SrcLevel: Integer;

  ChpEntry: TFullQualEntry;
  Protect, Chopping: Boolean;
begin
  try
    case FCMD1 of
      $30:
      begin
        case FCMD2 of
          $50: // Set Route
          begin
            if (Length(FCMDBuffer) < 16) then exit;

            DstEntry.AreaIndex := 1;
            DstEntry.Index     := PAnsiCharToInt(@FCMDBuffer[1]);

            DstLevel := PAnsiCharToInt(@FCMDBuffer[5]);

            SrcEntry.AreaIndex := 1;
            SrcEntry.Index     := PAnsiCharToInt(@FCMDBuffer[9]);

            SrcLevel := PAnsiCharToInt(@FCMDBuffer[13]);

            FCMDLastResult := FGrassValleyRCL.TakebyLevelIndex(DstEntry, DstLevel, SrcEntry);

            if (FCMDLastResult = D_OK) then
              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('Command TakebyLevelIndex succeeded, output = %d, output level = %d, input = %d', [DstEntry.Index, DstLevel, SrcEntry.Index])))
            else
              Assert(False, GetLogDevice(lsError, FCMDControlBy, Format('Command TakebyLevelIndex failed, error = %d, output = %d, output level = %d, input = %d', [FCMDLastResult, DstEntry.Index, DstLevel, SrcEntry.Index])));
          end;
        end;
      end;
      $40:
      begin
        case FCMD2 of
          $50: // Get Route
          begin
            if (Length(FCMDBuffer) < 8) then exit;

            DstEntry.AreaIndex := 1;
            DstEntry.Index     := PAnsiCharToInt(@FCMDBuffer[1]);

            DstLevel := PAnsiCharToInt(@FCMDBuffer[5]);

//            FCMDLastResult := FGrassValleyRCL.QueryDestinationStatusByIndex(DstEntry, Protect, Chopping, SrcEntry, ChpEntry);
            FCMDLastResult := FGrassValleyRCL.QueryDestinationStatusLevelByIndex(DstEntry, DstLevel, Protect, Chopping, SrcEntry, ChpEntry);
            if (FCMDLastResult = D_OK) then
            begin
//              FCMDResultBuffer := IntToAnsiString(SrcEntry.Index) + IntToAnsiString(0);
              FCMDResultBuffer := IntToAnsiString(SrcEntry.Index) + IntToAnsiString(DstLevel);

              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('Command QueryDestinationStatusLevelByIndex succeeded, output = %d, output level = %d, input = %d', [DstEntry.Index, DstLevel, SrcEntry.Index])))
            end
            else
              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('Command QueryDestinationStatusLevelByIndex failed, error = %d, output = %d, output level = %d', [FCMDLastResult, DstEntry.Index, DstLevel])));
          end;
        end;
      end;
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceGrassValleyRCL.ControlClear;
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

procedure TDeviceGrassValleyRCL.ControlChanged;
begin
  try
    if (not HasMainControl) then exit;

  finally
    inherited;
  end;
end;

procedure TDeviceGrassValleyRCL.ControlStart;
var
  R: Integer;
begin
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) and (EventNext^.Status.State = esCued) then
    begin
      with EventNext^.RSW do
      begin
        // Take

{          // PGM/PST
        if (MainVideo >= 0) and (MainAudio >= 0) then
        begin
          R := FGrassValleyRCL.StartTransition;
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;
        end; }
      end;

      SetEventStatus(EventNext, esOnAir);
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceGrassValleyRCL.ControlStop;
begin
  try
    if (not HasMainControl) then exit;

    if (EventCurr <> nil) and (EventCurr^.Status.State = esOnAir) then
    begin
      SetEventStatus(EventCurr, esFinish);
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceGrassValleyRCL.ControlFinish;
begin
  try
    if (not HasMainControl) then exit;

    if (EventFini <> nil) and (EventFini^.Status.State = esFinish) then
    begin
      SetEventStatus(EventFini, esDone);
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceGrassValleyRCL.ControlCue;
var
  R: Integer;
begin
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) then
    begin
      SetEventStatus(EventNext, esCueing);

      // Preset


{        with EventNext^.Switcher do
      begin
        // PGM/PST
        if (MainVideo >= 0) and (MainAudio >= 0) then
        begin
          case VideoTransType of
            TT_CUT: TTName := 'cut';
            TT_FADE: TTName := 'fade';
            TT_CUTFADE: TTName := 'cut-fade';
            TT_FADECUT: TTName := 'fade-cut';
            TT_MIX: TTName := 'cut';
          else
            TTName := 'cut';
          end;

          R := FGrassValleyRCL.SetTransitionType(TTName);
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
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

            R := FGrassValleyRCL.SetTransitionRate(TRName);
            if (R <> D_OK) then
            begin
              SetEventStatus(EventNext, esError);
              exit;
            end;
          end;

          BusEnables := TPCSSwitchBusEnables.Create;
          try
//              BusEnables.Add(TPCSSwitchBusEnable.Create(sbProgram, False));
            BusEnables.Add(TPCSSwitchBusEnable.Create(sbPreset, True));
//              BusEnables.Add(TPCSSwitchBusEnable.Create(sbOutput1, False));
//              BusEnables.Add(TPCSSwitchBusEnable.Create(sbOutput2, False));

            R := FGrassValleyRCL.CrosspointTake(MainVideo, BusEnables);
            if (R <> D_OK) then
            begin
              SetEventStatus(EventNext, esError);
              exit;
            end;
          finally
            FreeAndNil(BusEnables);
          end;

          R := FGrassValleyRCL.NextTransition(True, True);
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;
        end;
      end; }

      SetEventStatus(EventNext, esCued);
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceGrassValleyRCL.ControlSchedule;
begin
  inherited;
end;

procedure TDeviceGrassValleyRCL.ControlGetStatus;
begin
  inherited;
end;

function TDeviceGrassValleyRCL.GetStatus: TDeviceStatus;
var
  R: Integer;
  Status: TRSWStatus;

  SystemDateTime: TDateTime;
begin
  FillChar(Result, SizeOf(TDeviceStatus), #0);
  with Result do
  begin
    EventType := ET_RSW;

    // 추후 Status check 방안 검토 필요
    FillChar(Status, SizeOf(TRSWStatus), #0);

    R := FGrassValleyRCL.QueryDateTime(SystemDateTime);
    if (R = D_OK) then
    begin
      Connected := True;
    end
    else
    begin
      Connected := False;
      DeviceClose;
{      if (not FOpened) then }DeviceOpen;
    end; 

{    RSW.ErrorCode      := 0;
    RSW.ErrorLine      := 0;
    RSW.ExtraErrorCode := 0; }
  end;

  Result := inherited GetStatus;
end;

function TDeviceGrassValleyRCL.DeviceOpen: Integer;
var
  SessionID: Word;
begin
  Result := inherited DeviceOpen;

  with FDevice^.GvRCL do
  begin
    if (FGrassValleyRCL.SessionID > 0) then
      FGrassValleyRCL.RCLDisconnect;

    if (FGrassValleyRCL.Connected) then
      FGrassValleyRCL.Disconnect;

    FGrassValleyRCL.ControlIP   := String(HostIP);
    FGrassValleyRCL.ControlPort := HostPort;

    if (not FGrassValleyRCL.Connect) then
    begin
      Result := D_FALSE;
      exit;
    end;

    Result := FGrassValleyRCL.RCLConnect(SessionID);
    if (Result <> D_OK) then
    begin
      exit;
    end;
  end;

  FOpened := True;

  Result := D_OK;
end;

function TDeviceGrassValleyRCL.DeviceClose: Integer;
var
  Closed: Boolean;
begin
  Result := inherited DeviceClose;
  if (Result <> D_OK) then exit;

  Result := FGrassValleyRCL.RCLDisconnect;
  if (Result <> D_OK) then
    exit;

  if (not FGrassValleyRCL.Disconnect) then
  begin
    Result := D_FALSE;
    exit;
  end;

  FOpened := False;

  Result := D_OK;
end;

function TDeviceGrassValleyRCL.DeviceInit: Integer;
var
  R: Integer;
begin
  Result := inherited DeviceInit;

  if (not HasMainControl) then exit;

  FDevice^.Status.RSW.ErrorCode := 0;
  FDevice^.Status.RSW.ErrorLine := 0;
  FDevice^.Status.RSW.ExtraErrorCode := 0;
  UpdateStatus;

  Assert(False, GetLogDevice(lsNormal, Format('Device init succeeded.', [])));
end;

end.
