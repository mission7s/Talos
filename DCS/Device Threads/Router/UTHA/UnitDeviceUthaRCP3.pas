unit UnitDeviceUthaRCP3;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows, Vcl.Forms,
  UnitDeviceThread, UnitCommons, UnitBaseSerial, UnitUthaRCP3;

type
  TDeviceUthaRCP3 = class(TDeviceThread)
  private
    FUthaRCP3: TUthaRCP3;
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

constructor TDeviceUthaRCP3.Create(ADevice: PDevice);
begin
  inherited Create(ADevice);

  FUthaRCP3 := TUthaRCP3.Create(nil);
  FUthaRCP3.ControlType := ADevice^.UthaRCP3.ControlType;
  FUthaRCP3.LogEnabled := ADevice^.PortLog;

  if (FUthaRCP3.LogEnabled) then
  begin
    FUthaRCP3.LogIsHexcode := True;
    FUthaRCP3.LogPath := GV_ConfigGeneral.PortLogPath + String(ADevice^.Name) + PathDelim;
    FUthaRCP3.LogExt  := GV_ConfigGeneral.PortLogExt;
  end;
end;

destructor TDeviceUthaRCP3.Destroy;
begin
  if (FUthaRCP3 <> nil) then
    FreeAndNil(FUthaRCP3);

  inherited Destroy;
end;

procedure TDeviceUthaRCP3.ControlReset;
begin
  inherited;
end;

procedure TDeviceUthaRCP3.ControlCommand;
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

            FCMDLastResult := FUthaRCP3.Take(XptInput, XptOutput, XptOutputLevel);

            if (FCMDLastResult = D_OK) then
              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('Command Take succeeded, input = %d, output = %d, output level = %d', [XptInput, XptOutput, XptOutputLevel])))
            else
            begin
              Assert(False, GetLogDevice(lsError, FCMDControlBy, Format('Command Take failed, error = %d, input = %d, output = %d, output level = %d', [FCMDLastResult, XptInput, XptOutput, XptOutputLevel])));

              if (FDevice^.UthaRCP3.CommandErrorReset) then
              begin
                Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('Command error, device reset.', [])));
                DeviceReset;
              end;
            end;
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

            FCMDLastResult := FUthaRCP3.GetMatrix(XptOutput, XptOutputLevel, XptInput);
            if (FCMDLastResult = D_OK) then
            begin
              FCMDResultBuffer := IntToAnsiString(XptInput) + IntToAnsiString(XptOutputLevel);

              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('Command GetMatrix succeeded, oputput = %d, level = %d, input = %d', [XptOutput, XptOutputLevel, XptInput])))
            end
            else
              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('Command GetMatrix failed, error = %d, output = %d, level = %d', [FCMDLastResult, XptOutput, XptOutputLevel])));
          end;
        end;
      end;
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceUthaRCP3.ControlClear;
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

procedure TDeviceUthaRCP3.ControlChanged;
begin
  try
  finally
    inherited;
  end;
end;

procedure TDeviceUthaRCP3.ControlStart;
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
          R := FUthaRCP3.StartTransition;
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

procedure TDeviceUthaRCP3.ControlStop;
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

procedure TDeviceUthaRCP3.ControlFinish;
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

procedure TDeviceUthaRCP3.ControlCue;
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

          R := FUthaRCP3.SetTransitionType(TTName);
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

            R := FUthaRCP3.SetTransitionRate(TRName);
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

            R := FUthaRCP3.CrosspointTake(MainVideo, BusEnables);
            if (R <> D_OK) then
            begin
              SetEventStatus(EventNext, esError);
              exit;
            end;
          finally
            FreeAndNil(BusEnables);
          end;

          R := FUthaRCP3.NextTransition(True, True);
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

procedure TDeviceUthaRCP3.ControlSchedule;
begin
  inherited;
end;

procedure TDeviceUthaRCP3.ControlGetStatus;
begin
  inherited;
end;

function TDeviceUthaRCP3.GetStatus: TDeviceStatus;
var
  R: Integer;
  Status: TRSWStatus;
begin
  FillChar(Result, SizeOf(TDeviceStatus), #0);
  with Result do
  begin
    EventType := ET_RSW;

    // 추후 Status check 방안 검토 필요
    FillChar(Status, SizeOf(TRSWStatus), #0);

    Connected := FUthaRCP3.Connected;

    R := FUthaRCP3.Ping;
    if (R = D_OK) then
    begin
      Connected := True;
    end
    else
    begin
      Assert(False, GetLogDevice(lsError, Format('GetStatus ping failed, Error = %d', [Integer(R)])));

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

function TDeviceUthaRCP3.DeviceOpen: Integer;
begin
  Result := inherited DeviceOpen;

  with FDevice^.UthaRCP3 do
  begin
    if (FUthaRCP3.Connected) then
      FUthaRCP3.Disconnect;

    FUthaRCP3.ControlIP   := String(HostIP);
    FUthaRCP3.ControlPort := HostPort;

    if (not FUthaRCP3.Connect) then
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

function TDeviceUthaRCP3.DeviceClose: Integer;
var
  Closed: Boolean;
begin
  Result := inherited DeviceClose;
  if (Result <> D_OK) then exit;

  if (not FUthaRCP3.Disconnect) then
  begin
    Result := D_FALSE;
    Assert(False, GetLogDevice(lsError, Format('Device close failed.', [])));

    exit;
  end;

  Assert(False, GetLogDevice(lsNormal, Format('Device close succeeded.', [])));

  FOpened := False;

  Result := D_OK;
end;

function TDeviceUthaRCP3.DeviceInit: Integer;
var
  R: Integer;
  Conn: Boolean;
begin
  Result := inherited DeviceInit;

  if (not HasMainControl) then exit;

  try
    R := FUthaRCP3.Ping;
    if (R <> D_OK) then
    begin
      Result := D_FALSE;
      exit;
    end;
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
