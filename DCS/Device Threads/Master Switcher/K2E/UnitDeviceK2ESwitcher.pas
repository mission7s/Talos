unit UnitDeviceK2ESwitcher;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows,
  UnitDeviceThread, UnitCommons, UnitK2ESwitcher, Forms;

type
  TDeviceK2ESwitcher = class(TDeviceThread)
  private
    FK2ESwitcher: TK2ESwitcher;
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

constructor TDeviceK2ESwitcher.Create(ADevice: PDevice);
begin
  inherited Create(ADevice);

  FK2ESwitcher := TK2ESwitcher.Create(nil);
end;

destructor TDeviceK2ESwitcher.Destroy;
begin
  if (FK2ESwitcher <> nil) then
    FreeAndNil(FK2ESwitcher);

  inherited Destroy;
end;

procedure TDeviceK2ESwitcher.ControlReset;
begin
  inherited;
end;

procedure TDeviceK2ESwitcher.ControlCommand;
begin
  inherited;
end;

procedure TDeviceK2ESwitcher.ControlClear;
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

procedure TDeviceK2ESwitcher.ControlChanged;
begin
  try
    if (not HasMainControl) then exit;

  finally
    inherited;
  end;
end;

procedure TDeviceK2ESwitcher.ControlStart;
var
  R: Integer;
begin
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) and (EventNext^.Status.State = esCued) then
    begin
      with EventNext^.Switcher do
      begin
        // PGM/PST
        if (MainVideo >= 0) and (MainAudio >= 0) then
        begin
          R := FK2ESwitcher.Take;
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;
        end
        else if (Key1 >= 0) or (Key2 >= 0) then
        begin
          R := FK2ESwitcher.TakeKey((Key1 >= 0), (Key2 >= 0), False);
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;
        end;
      end;

      SetEventStatus(EventNext, esOnAir);
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceK2ESwitcher.ControlStop;
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

procedure TDeviceK2ESwitcher.ControlFinish;
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

procedure TDeviceK2ESwitcher.ControlCue;
var
  R: Integer;
  Channel: Byte;
  K2eTM: TK2E_TransitionMode;
  K2eTS: TK2E_TransitionSpeed;
begin
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
          case EventNext^.Switcher.VideoTransType of
            TT_CUT: K2eTM := K2E_TM_CUT;
            TT_FADE: K2eTM := K2E_TM_V_CUT;
            TT_CUTFADE: K2eTM := K2E_TM_CUT_TO_UP;
            TT_FADECUT: K2eTM := K2E_TM_DOWN_TO_CUT;
            TT_MIX: K2eTM := K2E_TM_MIX;
          else
            K2eTM := K2E_TM_CUT;
          end;

          R := FK2ESwitcher.SetTransitionMode(K2eTM);
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;

          case VideoTransRate of
            TR_CUT: K2eTS := K2E_TS_NORMAL;
            TR_FAST: K2eTS := K2E_TS_FAST;
            TR_MEDIUM: K2eTS := K2E_TS_NORMAL;
            TR_SLOW: K2eTS := K2E_TS_SLOW;
          else
            K2eTS := K2E_TS_NORMAL;
          end;

          R := FK2ESwitcher.SetTransitionSpeed(K2eTS);
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;

          Channel := MainVideo;// + 1;

          R := FK2ESwitcher.AssignInputPST(Channel);
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;
        end;

        // Key
        if (Key1 >= 0) or (Key2 >= 0) then
        begin
          case EventNext^.Switcher.VideoTransType of
            TT_CUT: K2eTM := K2E_TM_MIX;    // Protocol bug
{              TT_CUT: K2eTM := K2E_TM_CUT;
            TT_FADE: K2eTM := K2E_TM_V_CUT;
            TT_CUTFADE: K2eTM := K2E_TM_CUT_TO_UP;
            TT_FADECUT: K2eTM := K2E_TM_DOWN_TO_CUT;
            TT_MIX: K2eTM := K2E_TM_MIX; }
          else
            K2eTM := K2E_TM_CUT;
          end;

          R := FK2ESwitcher.SetKeyTransitionMode(K2eTM);
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;

          R := FK2ESwitcher.SetKeyToPST((Key1 >= 0), (Key2 >= 0), (Key1 > 0), (Key2 > 0));
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;
        end;
      end;

      SetEventStatus(EventNext, esCued);
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceK2ESwitcher.ControlSchedule;
begin
  inherited;
end;

procedure TDeviceK2ESwitcher.ControlGetStatus;
begin
  inherited;
end;

function TDeviceK2ESwitcher.GetStatus: TDeviceStatus;
var
  R: Integer;
  Matrix: TK2E_Matrix;
begin
  FillChar(Result, SizeOf(TDeviceStatus), #0);
  with Result do
  begin
    EventType := ET_SWITCHER;

    FillChar(Matrix, SizeOf(TK2E_Matrix), #0);
    R := FK2ESwitcher.GetMatrix(Matrix);
    if (R = D_OK) then
    begin
      Connected := True;

      Switcher.PGMMainVideo := Matrix.PGM;
      Switcher.PGMMainAudio := Matrix.PGM;

      Switcher.PGMKey1 := Ord(Matrix.MixPGM.Key1);
      Switcher.PGMKey2 := Ord(Matrix.MixPGM.Key2);
      Switcher.PGMMix1 := 0;
      Switcher.PGMMix2 := 0;
      Switcher.PGMAudioType := 0;

      Switcher.PSTMainVideo := Matrix.PST;
      Switcher.PSTMainAudio := Matrix.PST;

      Switcher.PSTKey1 := Ord(Matrix.MixPst.Key1);
      Switcher.PSTKey2 := Ord(Matrix.MixPst.Key2);
      Switcher.PstMix1 := 0;
      Switcher.PstMix2 := 0;

      Switcher.PSTAudioType := 0;
    end
    else
    begin
      Connected := False;
      DeviceClose;
{      if (not FOpened) then }DeviceOpen;
    end;

    Switcher.IsTransition := False;
    Switcher.IsPreroll    := False;
    Switcher.IsRemoteOn   := True;
    Switcher.SMPTETime    := Now;
  end;

  Result := inherited GetStatus;
end;

function TDeviceK2ESwitcher.DeviceOpen: Integer;
var
  R: Integer;
begin
  Result := inherited DeviceOpen;

  with FDevice^.VTS do
  begin
    if (FK2ESwitcher.Connected) then
      FK2ESwitcher.Disconnect;

    FK2ESwitcher.ComPort         := PortConfig.PortNum;
    FK2ESwitcher.ComPortBaudRate := PortConfig.BaudRate;
    FK2ESwitcher.ComPortDataBits := PortConfig.DataBits;
    FK2ESwitcher.ComPortStopBits := PortConfig.StopBits;
    FK2ESwitcher.ComPortParity   := PortConfig.Parity;

//    FK2ESwitcher.LogEnabled := True;
//    FK2ESwitcher.LogPath := ExtractFilePath(Application.ExeName);

    if (not FK2ESwitcher.Connect) then
    begin
      Result := D_FALSE;
      exit;
    end;

    R := FK2ESwitcher.SetRemoteMode(K2E_RM_APS);
    if (R <> D_OK) then
    begin
      Result := D_FALSE;
      exit;
    end;
  end;

  FOpened := True;

//  Result := DeviceInit;
end;

function TDeviceK2ESwitcher.DeviceClose: Integer;
begin
  Result := inherited DeviceClose;
  if (Result <> D_OK) then exit;

  if (not FK2ESwitcher.Connected) then
  begin
    Result := D_FALSE;
    exit;
  end;

  if (not FK2ESwitcher.Disconnect) then
  begin
    Result := D_FALSE;
    exit;
  end;

  FOpened := False;

  Result := D_OK;
end;

function TDeviceK2ESwitcher.DeviceInit: Integer;
begin
  Result := inherited DeviceInit;

  if (not HasMainControl) then exit;

  Assert(False, GetLogDevice(lsNormal, Format('Device init succeeded', [])));
end;

end.
