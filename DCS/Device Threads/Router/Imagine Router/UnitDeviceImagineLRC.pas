unit UnitDeviceImagineLRC;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows, Vcl.Forms,
  UnitDeviceThread, UnitCommons, UnitBaseSerial, UnitImagineLRC;

type
  TDeviceImagineLRC = class(TDeviceThread)
  private
    FImagineLRC: TImagineLRC;
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

constructor TDeviceImagineLRC.Create(ADevice: PDevice);
begin
  inherited Create(ADevice);

  FImagineLRC := TImagineLRC.Create(nil);
  FImagineLRC.ControlType := ADevice^.ImgLRC.ControlType;
  FImagineLRC.LogEnabled := ADevice^.PortLog;

  if (FImagineLRC.LogEnabled) then
  begin
    FImagineLRC.LogIsHexcode := False;
    FImagineLRC.LogPath := GV_ConfigGeneral.PortLogPath + String(ADevice^.Name) + PathDelim;
    FImagineLRC.LogExt  := GV_ConfigGeneral.PortLogExt;
  end;
end;

destructor TDeviceImagineLRC.Destroy;
begin
  if (FImagineLRC <> nil) then
    FreeAndNil(FImagineLRC);

  inherited Destroy;
end;

procedure TDeviceImagineLRC.ControlReset;
begin
  inherited;
end;

procedure TDeviceImagineLRC.ControlCommand;
var
  XptOutput: Integer;
  XptOutputLevel: Integer;
  XptInput: Integer;
  XptInputLevel: Integer;

  ClipExist: Boolean;
  ClipSize: String;
begin
  try
    case FCMD1 of
      $30:
      begin
        case FCMD2 of
          $50: // Set Route
          begin
            if (Length(FCMDBuffer) < 16) then exit;

            XptOutput      := PAnsiCharToInt(@FCMDBuffer[1]);
            XptOutputLevel := PAnsiCharToInt(@FCMDBuffer[5]);
            XptInput       := PAnsiCharToInt(@FCMDBuffer[9]);
            XptInputLevel  := PAnsiCharToInt(@FCMDBuffer[13]);

            FCMDLastResult := FImagineLRC.ChangeXPoint(XptOutput, XptOutputLevel, XptInput, XptInputLevel);

            if (FCMDLastResult = D_OK) then
              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('Command ChangeXPoint succeeded, output = %d, output level = %d, input = %d, input level = %d', [XptOutput, XptOutputLevel, XptInput, XptInputLevel])))
            else
              Assert(False, GetLogDevice(lsError, FCMDControlBy, Format('Command ChangeXPoint failed, error = %d, output = %d, output level = %d, input = %d, input level = %d', [FCMDLastResult, XptOutput, XptOutputLevel, XptInput, XptInputLevel])));
          end;
        end;
      end;
      $40:
      begin
        case FCMD2 of
          $50: // Get Route
          begin
            if (Length(FCMDBuffer) < 8) then exit;

            XptOutput      := PAnsiCharToInt(@FCMDBuffer[1]);
            XptOutputLevel := PAnsiCharToInt(@FCMDBuffer[5]);

            FCMDLastResult := FImagineLRC.QueryXPoint(XptOutput, XptOutputLevel, XptInput, XptInputLevel);
            if (FCMDLastResult = D_OK) then
            begin
//              FCMDLastResult := FImagineLRC.GetXPoint(XptOutput, XptOutputLevel, XptInput, XptInputLevel);
              FCMDResultBuffer := IntToAnsiString(XptInput) + IntToAnsiString(XptInputLevel);

              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('Command QueryXPoint succeeded, oputput = %d, output level = %d, input = %d, input level = %d', [XptOutput, XptOutputLevel, XptInput, XptInputLevel])))
            end
            else
              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('Command QueryXPoint failed, error = %d, output = %d, output level = %d', [FCMDLastResult, XptOutput, XptOutputLevel])));
          end;
        end;
      end;
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceImagineLRC.ControlClear;
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

procedure TDeviceImagineLRC.ControlChanged;
begin
  try
    if (not HasMainControl) then exit;

  finally
    inherited;
  end;
end;

procedure TDeviceImagineLRC.ControlStart;
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
          R := FImagineLRC.StartTransition;
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

procedure TDeviceImagineLRC.ControlStop;
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

procedure TDeviceImagineLRC.ControlFinish;
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

procedure TDeviceImagineLRC.ControlCue;
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

          R := FImagineLRC.SetTransitionType(TTName);
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

            R := FImagineLRC.SetTransitionRate(TRName);
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

            R := FImagineLRC.CrosspointTake(MainVideo, BusEnables);
            if (R <> D_OK) then
            begin
              SetEventStatus(EventNext, esError);
              exit;
            end;
          finally
            FreeAndNil(BusEnables);
          end;

          R := FImagineLRC.NextTransition(True, True);
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

procedure TDeviceImagineLRC.ControlSchedule;
begin
  inherited;
end;

procedure TDeviceImagineLRC.ControlGetStatus;
begin
  inherited;
end;

function TDeviceImagineLRC.GetStatus: TDeviceStatus;
var
  R: Integer;
  Status: TRSWStatus;

  ProtocolName: AnsiString;
begin
  FillChar(Result, SizeOf(TDeviceStatus), #0);
  with Result do
  begin
    EventType := ET_RSW;

    // 추후 Status check 방안 검토 필요
    FillChar(Status, SizeOf(TRSWStatus), #0);

    Connected := FImagineLRC.Connected;

    R := FImagineLRC.ProtocolName(ProtocolName);
    if (R = D_OK) then
    begin
      Connected := True;
//      Assert(False, GetLogDevice(lsNormal, Format('Get status in ''ProtocolName'' command succeeded.', [])));
    end
    else
    begin
      Connected := False;
      Assert(False, GetLogDevice(lsError, Format('GetStatus ProtocolName failed, Error = %d', [Integer(R)])));

      DeviceClose;
{      if (not FOpened) then }DeviceOpen;
    end;

{    RSW.ErrorCode      := 0;
    RSW.ErrorLine      := 0;
    RSW.ExtraErrorCode := 0; }
  end;

  Result := inherited GetStatus;
end;

function TDeviceImagineLRC.DeviceOpen: Integer;
begin
  Result := inherited DeviceOpen;

  with FDevice^.ImgLRC do
  begin
    if (FImagineLRC.Connected) then
      FImagineLRC.Disconnect;

    FImagineLRC.ControlIP   := String(HostIP);
    FImagineLRC.ControlPort := HostPort;

    if (not FImagineLRC.Connect) then
    begin
      Result := D_FALSE;
      Assert(False, GetLogDevice(lsError, Format('Device open failed.', [])));

      exit;
    end;
  end;

  Assert(False, GetLogDevice(lsNormal, Format('Device open succeeded.', [])));

  FOpened := True;

  Result := D_OK;
end;

function TDeviceImagineLRC.DeviceClose: Integer;
var
  Closed: Boolean;
begin
  Result := inherited DeviceClose;
  if (Result <> D_OK) then exit;

  if (not FImagineLRC.Disconnect) then
  begin
    Result := D_FALSE;
    Assert(False, GetLogDevice(lsError, Format('Device close failed.', [])));

    exit;
  end;

  Assert(False, GetLogDevice(lsNormal, Format('Device close succeeded.', [])));

  FOpened := False;

  Result := D_OK;
end;

function TDeviceImagineLRC.DeviceInit: Integer;
var
  R: Integer;
begin
  Result := inherited DeviceInit;

  if (not HasMainControl) then exit;

  try
    FImagineLRC.ClearXPointList;

{      R := FImagineLRC.QueryXPoint(1);
    if (R <> D_OK) then
    begin
      Result := D_FALSE;
      exit;
    end; }
  finally
    if (R <> D_OK) then
    begin
      Assert(False, GetLogDevice(lsError, Format('Device init failed, error = %d', [R])));
    end;
  end;

  FDevice^.Status.RSW.ErrorCode := 0;
  FDevice^.Status.RSW.ErrorLine := 0;
  FDevice^.Status.RSW.ExtraErrorCode := 0;
  UpdateStatus;

  Assert(False, GetLogDevice(lsNormal, Format('Device init succeeded.', [])));
end;

end.
