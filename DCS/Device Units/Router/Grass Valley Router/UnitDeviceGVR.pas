unit UnitDeviceGVR;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows,
  UnitDeviceThread, UnitCommons,
  UnitBaseSerial, UnitLouth;

type
  TDevicceGVR = class(TDeviceThread)
  private
    FLouth: TLouth;
  protected
    procedure ControlReset; override;
    procedure ControlCommand; override;
    procedure ControlClear; override;
    procedure ControlChanged; override;
    procedure ControlStart; override;
    procedure ControlStop; override;
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

constructor TDevicceGVR.Create(ADevice: PDevice);
begin
  inherited Create(ADevice);

  FLouth := TLouth.Create(nil);
  FLouth.ControlType := ctSerial;
end;

destructor TDevicceGVR.Destroy;
begin
  FreeAndNil(FLouth);

  inherited Destroy;
end;

procedure TDevicceGVR.ControlReset;
begin
  inherited;
end;

procedure TDevicceGVR.ControlCommand;
begin
  inherited;
end;

procedure TDevicceGVR.ControlClear;
begin
  try
    if (EventCurr <> nil) and (FEventQueue.IndexOf(EventCurr) < 0) then
    begin
      try
        if (GV_DCSMine <> nil) and (GV_DCSMine^.Main) then
        begin
        end;
      finally
        EventCurr := nil;
      end;
    end;

    if (EventNext <> nil) and (FEventQueue.IndexOf(EventNext) < 0) then
    begin
      try
        if (GV_DCSMine <> nil) and (GV_DCSMine^.Main) then
        begin
        end;
      finally
        EventNext := nil;
      end;
    end;
  finally
    inherited;
  end;
end;

procedure TDevicceGVR.ControlChanged;
//var
//  ClipInfo: TOmPlrClipInfo;
//  ClipDuration: Cardinal;
//  PlrStatus: TOmPlrStatus;
begin
{  try
    if (GV_DCSMine <> nil) and (GV_DCSMine^.Main) then
    begin
      // If current event status is onair
      // If next event is manual event and status is cued then SetMaxPos set current duration time
      if (EventCurr <> nil) and (EventCurr^.Status = esOnAir) and
         (EventNext <> nil) {and (EventNext^.ManualEvent) }//and (EventNext^.Status = esCued) then
{      begin
        FillChar(PlrStatus, SizeOf(TOmPlrStatus), #0);
        FLastPlrError := OmPlrGetPlayerStatus(FPlrHandle, PlrStatus);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;

        if (PlrStatus.MaxPos > (PlrStatus.CurrClipStartPos + PlrStatus.CurrClipLen)) then
        begin
          FLastPlrError := OmPlrSetMaxPos(FPlrHandle, PlrStatus.CurrClipStartPos + PlrStatus.CurrClipLen);
          if (FLastPlrError <> omPlrOk) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;
        end;

  {      FillChar(ClipInfo, SizeOf(TOmPlrClipInfo), #0);
        FLastPlrError := OmPlrClipGetInfo(FPlrHandle, EventNext^.Player.ID.ID, ClipInfo);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;

        ClipDuration := ClipInfo.LastFrame - ClipInfo.FirstFrame;

        FillChar(PlrStatus, SizeOf(TOmPlrStatus), #0);
        FLastPlrError := OmPlrGetPlayerStatus(FPlrHandle, PlrStatus);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;

        if (PlrStatus.MaxPos > PlrStatus.ClipDuration) then
        begin
          FLastPlrError := OmPlrSetMaxPos(FPlrHandle, PlrStatus.MaxPos - ClipDuration);
          if (FLastPlrError <> omPlrOk) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;
        end;  }
{      end;
    end;
  finally
    inherited;
  end; }
end;

procedure TDevicceGVR.ControlStart;
var
  R: Integer;
begin
  try
    if (EventNext <> nil) and (EventNext^.Status.State = esCued) then
    begin
      if (GV_DCSMine <> nil) and (GV_DCSMine^.Main) then
      begin
        R := FLouth.Play;
        if (R <> D_OK) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;
      end;

      SetEventStatus(EventNext, esOnAir);
    end;
  finally
    inherited;
  end;
end;

procedure TDevicceGVR.ControlStop;
var
  R: Integer;
begin
  try
    if (EventCurr <> nil) and (EventCurr^.Status.State = esOnAir) then
    begin
      if (GV_DCSMine <> nil) and (GV_DCSMine^.Main) then
      begin
        SetEventStatus(EventCurr, esFinishing);

        // FinishAction에 의해 STOP or STILL 처리
        if (EventCurr^.Player.FinishAction = FA_STOP) then
        begin
          R := FLouth.Stop;
          if (R <> D_OK) then
          begin
            SetEventStatus(EventCurr, esError);
            exit;
          end;
        end;

        SetEventStatus(EventCurr, esFinished);
      end;

      SetEventStatus(EventCurr, esDone);
    end;
  finally
    inherited;
  end;
end;

procedure TDevicceGVR.ControlCue;
var
  R: Integer;
  Request: TIDRequest;
  CueingTime, CueTimeOut: Word;
  PortStateStatus: TPortStateStatus;
begin
  try
    if (EventNext <> nil) then
    begin
      SetEventStatus(EventNext, esCueing);

      if (GV_DCSMine <> nil) and (GV_DCSMine^.Main) then
      begin
        R := FLouth.CmdWhileBusy;
        if (R <> D_OK) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;

        R := FLouth.GetIDRequest(String(EventNext^.Player.ID.ID), Request);
        if (R <> D_OK) then exit;
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;

        if (not Request.InDisk) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;

        R := FLouth.PlayCueWithData(String(EventNext^.Player.ID.ID), TimecodeToString(EventNext^.Player.StartTC), TimecodeToString(EventNext^.DurTime));
        if (R <> D_OK) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;

        R := FLouth.CmdWhileBusy;
        if (R <> D_OK) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;

        CueTimeOut := TimecodeToMilliSec(GV_ConfigEventVS.CueTimeout);
        CueingTime := 0;
        while True do
        begin
          R := FLouth.GetPortStateStatus(PortStateStatus);
          if (R <> D_OK) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;

          if (PortStateStatus.CueDone) or (CueingTime >= CueTimeOut) then
            break;

          Sleep(30);
          Inc(CueingTime, 30);
        end;

        if (not PortStateStatus.CueDone) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;
      end;

      SetEventStatus(EventNext, esCued);
    end;
  finally
    inherited;
  end;
end;

procedure TDevicceGVR.ControlSchedule;
begin
  inherited;
end;

procedure TDevicceGVR.ControlGetStatus;
begin
  inherited;
end;

function TDevicceGVR.GetStatus: TDeviceStatus;
var
  R: Integer;
  PortStateStatus: TPortStateStatus;
  CurTC, RemainTC: String;
begin
  FillChar(Result, SizeOf(TDeviceStatus), #0);
  with Result do
  begin
    EventType := ET_PLAYER;

    FillChar(PortStateStatus, SizeOf(TPortStateStatus), #0);
    R := FLouth.GetPortStateStatus(PortStateStatus);
    if (R = D_OK) then
    begin
      Player.Connected := True;

      Player.Stop       := (PortStateStatus.Idle);

      Player.Cue        := (PortStateStatus.Cue);
      Player.Play       := (PortStateStatus.PlayRecord) and (FLouth.PortNumber >= 0);
      Player.Rec        := (PortStateStatus.PlayRecord) and (FLouth.PortNumber < 0);
      Player.Still      := (PortStateStatus.Still);

      Player.Jog        := (PortStateStatus.Jog);
      Player.Shuttle    := (PortStateStatus.Shuttle);
      Player.PortBusy   := (PortStateStatus.PortBusy);

      Player.CueDone    := (PortStateStatus.CueDone);

//      Player.DropFrame := FLOUDevice^.IsDropFrame;

      R := FLouth.GetPositionRequest(ptCurrent, CurTC);
      if (R = D_OK) then
        Player.CurTC := StringToTimecode(CurTC)
      else
        Player.CurTC := 0;

      R := FLouth.GetPositionRequest(ptRemain, RemainTC);
      if (R = D_OK) then
        Player.RemainTC := StringToTimecode(RemainTC)
      else
        Player.RemainTC := 0;
    end
    else
    begin
      Player.Connected := False;
{      if (not FOpened) then }DeviceOpen;
    end;
  end;

  Result := inherited GetStatus;
end;

function TDevicceGVR.DeviceOpen: Integer;
var
  R: Integer;
  PortStateStatus: TPortStateStatus;
begin
  Result := inherited DeviceOpen;

  with FDevice^.LOUTH do
  begin
    FLouth.ComPort         := PortConfig.PortNum;
    FLouth.ComPortBaudRate := PortConfig.BaudRate;
    FLouth.ComPortDataBits := PortConfig.DataBits;
    FLouth.ComPortStopBits := PortConfig.StopBits;
    FLouth.ComPortParity   := PortConfig.Parity;

    if (not FLouth.Connect) then
    begin
      Result := D_FALSE;
      exit;
    end;

    FillChar(PortStateStatus, SizeOf(TPortStateStatus), #0);
    R := FLouth.GetPortStateStatus(PortStateStatus);
    if (R <> D_OK) then
    begin
      Result := D_FALSE;
      exit;
    end;

    FLouth.PortNumber := PortNo;
  end;

  FOpened := True;
end;

function TDevicceGVR.DeviceClose: Integer;
begin
  Result := inherited DeviceClose;

  if (not FLouth.Connected) then
  begin
    Result := D_FALSE;
    exit;
  end;

  if (not FLouth.Disconnect) then
  begin
    Result := D_FALSE;
    exit;
  end;

  FOpened := False;

  Result := D_OK;
end;

function TDevicceGVR.DeviceInit: Integer;
begin
  Result := inherited DeviceInit;

  if (GV_DCSMine <> nil) and (GV_DCSMine^.Main) then
  begin
    Result := FLouth.Open(FLouth.PortNumber, $00);
    if (Result <> D_OK) then
    begin
      exit;
    end;

    Result := FLouth.SelectPort(FLouth.PortNumber);
    if (Result <> D_OK) then
    begin
      exit;
    end;
  end;
end;

{function TDevicceGVR.DCSGetStatus(ABuffer: String): Integer;
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
