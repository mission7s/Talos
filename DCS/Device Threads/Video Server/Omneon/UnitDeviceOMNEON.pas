unit UnitDeviceOMNEON;

interface

uses System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows,
  UnitDeviceThread, UnitCommons, UnitTypeConvert,
  UnitOmPlrDefs, UnitOmPlrClnt, UnitOmMediaDefs;

const
  OmFrameRateValues: array[TOmFrameRate] of Double =
    (1, 24, 25, 29.97, 30, 50, 59.94, 60, 23.97);

type
  TDeviceOMNEON = class(TDeviceThread)
  private
    FPlrHandle: TOmPlrHandle;
    FPlrStatus: TOmPlrStatus3;
    FPlayRate: Double;

    FClipHandleCurr: TOmPlrClipHandle;
    FClipHandleNext: TOmPlrClipHandle;
    FClipHandleFini: TOmPlrClipHandle;

    FCueing: Boolean;
    FCueDone: Boolean;

    FLastPlrError: TOmPlrError;

    function TimecodeToFrame(AValue: TTimecode; AFrameRate: Double): Cardinal;
    function FrameToTimecode(AFrames: Integer; AFrameRate: Double): TTimecode;
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
    procedure SetEventStatus(AEvent: PEvent; AState: TEventState; AErrorCode: Integer = E_NO_ERROR); override;
  public
    constructor Create(ADevice: PDevice); override;
    destructor Destroy; override;

    function DeviceOpen: Integer; override;
    function DeviceClose: Integer; override;
    function DeviceInit: Integer; override;
  end;

implementation

uses UnitConsts;

constructor TDeviceOMNEON.Create(ADevice: PDevice);
begin
  inherited Create(ADevice);

  FPlrHandle := nil;

  FPlayRate := 1.0;

  FClipHandleCurr := 0;
  FClipHandleNext := 0;
  FClipHandleFini := 0;

  FCueing  := False;
  FCueDone := False;
end;

destructor TDeviceOMNEON.Destroy;
begin
  inherited Destroy;
end;

procedure TDeviceOMNEON.ControlReset;
begin
  inherited;
end;

procedure TDeviceOMNEON.ControlCommand;
var
  ClipIDLen: Cardinal;
  ClipID: String;

  ClipExist: Boolean;
  ClipInfo: TOmPlrClipInfo;
  ClipSize: TTimecode;
begin
  try
    case FCMD1 of
      $40:
      begin
        case FCMD2 of
          $22: // Get Exist
          begin
            if (Length(FCMDBuffer) < 0) then exit;

            ClipIDLen := PAnsiCharToWord(@FCMDBuffer[1]);
            ClipID := Copy(FCMDBuffer, 3, ClipIDLen);
            ClipExist := False;

            Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('ControlCommand GetExist Start, ID = %s', [ClipID])));

            FLastPlrError := OmPlrClipExists(FPlrHandle, TOmPlrChar(ClipID), ClipExist);
            case ClipExist of
              True: FCMDResultBuffer := Chr($01);
              False: FCMDResultBuffer := Chr($00);
            end;

            if (FLastPlrError = omPlrOk) then
            begin
              FCMDLastResult := D_OK;
              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('ControlCommand GetExist succeeded, ID = %s, Exist = %s', [ClipID, BoolToStr(ClipExist, True)])));
            end
            else
            begin
              FCMDLastResult := D_FALSE;
              Assert(False, GetLogDevice(lsError, FCMDControlBy, Format('ControlCommand GetExist failed, Error = %d, ID = %s', [Integer(FLastPlrError), ClipID])));
            end;

            Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('ControlCommand GetExist End, ID = %s', [ClipID])));
          end;
          $23: // Get Size
          begin
            if (Length(FCMDBuffer) < 0) then exit;

            ClipIDLen := PAnsiCharToWord(@FCMDBuffer[1]);
            ClipID := Copy(FCMDBuffer, 3, ClipIDLen);

            FillChar(ClipInfo, SizeOf(TOmPlrClipInfo), #0);
            FLastPlrError := OmPlrClipGetInfo(FPlrHandle, TOmPlrChar(ClipID), ClipInfo);

            if (FLastPlrError = omPlrOk) then
            begin
              ClipSize := FrameToTimecode(ClipInfo.DefaultOut - ClipInfo.DefaultIn, OmFrameRateValues[ClipInfo.FrameRate]);
              FCMDResultBuffer := DWordToAnsiString(ClipSize);

              FCMDLastResult := D_OK;
              Assert(False, GetLogDevice(lsNormal, FCMDControlBy, Format('ControlCommand GetSize succeeded, ID = %s, Size = %s', [ClipID, TimecodeToString(ClipSize, ControlIsDropFrame)])));
            end
            else
            begin
              FCMDLastResult := D_FALSE;
              Assert(False, GetLogDevice(lsError, FCMDControlBy, Format('ControlCommand GetSize failed, Error = %d, ID = %s', [Integer(FLastPlrError), ClipID])));
            end;
          end;
        end;
      end;
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceOMNEON.ControlClear;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventCurr <> nil) then
    begin
      try
        FLastPlrError := OmPlrStop(FPlrHandle);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventCurr, esError);
          exit;
        end;

        if (FClipHandleCurr <> 0) then
        begin
          FLastPlrError := OmPlrDetach(FPlrHandle, FClipHandleCurr, omPlrShiftModeBefore);
          if (FLastPlrError <> omPlrOk) then
          begin
            SetEventStatus(EventCurr, esError);
            exit;
          end;
          FClipHandleCurr := 0;
        end;

        FLastPlrError := OmPlrSetMaxPosMax(FPlrHandle);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventCurr, esError);
          exit;
        end;

        FLastPlrError := OmPlrSetMinPosMin(FPlrHandle);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventCurr, esError);
          exit;
        end;
      finally
//        EventCurr := nil;
      end;
    end;

    if (EventNext <> nil) then
    begin
      try
        if (FClipHandleNext <> 0) then
        begin
          FLastPlrError := OmPlrDetach(FPlrHandle, FClipHandleNext, omPlrShiftModeBefore);
          if (FLastPlrError <> omPlrOk) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;
          FClipHandleNext := 0;
        end;

        FLastPlrError := OmPlrSetMaxPosMax(FPlrHandle);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;

        FLastPlrError := OmPlrSetMinPosMin(FPlrHandle);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventNext, esError);
          exit;
        end;
      finally
//        EventNext := nil;
      end;
    end;

    if (EventFini <> nil) then
    begin
      try
        if (FClipHandleFini <> 0) then
        begin
          FLastPlrError := OmPlrDetach(FPlrHandle, FClipHandleFini, omPlrShiftModeBefore);
          if (FLastPlrError <> omPlrOk) then
          begin
            SetEventStatus(EventFini, esError);
            exit;
          end;
          FClipHandleFini := 0;
        end;

        FLastPlrError := OmPlrSetMaxPosMax(FPlrHandle);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventFini, esError);
          exit;
        end;

        FLastPlrError := OmPlrSetMinPosMin(FPlrHandle);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventFini, esError);
          exit;
        end;
      finally
//        EventFini := nil;
      end;
    end;
  finally
    FEventLock.Leave;
    inherited;
  end;


{    exit;
  if (EventCurr <> nil) and (EventCurr^.EventID.ChannelID = FClearChannel) then
  begin
    FClipHandleCurr := 0;
  end;

  if (EventNext <> nil) and (EventNext^.EventID.ChannelID = FClearChannel) then
    FClipHandleNext := 0; }

  inherited;
end;

procedure TDeviceOMNEON.ControlChanged;
var
  ClipInfo: TOmPlrClipInfo;
  ClipDuration: Cardinal;
  PlrStatus: TOmPlrStatus3;
begin
  try
    if (not HasMainControl) then exit;

    // If current event status is onair
    // If next event is manual event and status is cued then SetMaxPos set current duration time -> pause
    if (EventCurr <> nil) and (EventCurr^.Status.State = esOnAir) and
       (EventNext <> nil) {and (EventNext^.ManualEvent) }and (EventNext^.Status.State = esCued) then
    begin
      FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
      FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
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
      FLastPlrError := OmPlrClipGetInfo(FPlrHandle, FEventNext^.Player.ID.ID, ClipInfo);
      if (FLastPlrError <> omPlrOk) then
      begin
        SetEventStatus(FEventNext, esError);
        exit;
      end;

      ClipDuration := ClipInfo.LastFrame - ClipInfo.FirstFrame;

      FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
      FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
      if (FLastPlrError <> omPlrOk) then
      begin
        SetEventStatus(FEventNext, esError);
        exit;
      end;

      if (PlrStatus.MaxPos > PlrStatus.ClipDuration) then
      begin
        FLastPlrError := OmPlrSetMaxPos(FPlrHandle, PlrStatus.MaxPos - ClipDuration);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(FEventNext, esError);
          exit;
        end;
      end;  }
    end;
  finally
    inherited;
  end;
end;

procedure TDeviceOMNEON.ControlStart;
var
  PlrStatus: TOmPlrStatus3;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) then
    begin
      if (EventNext^.Status.State = esCued) then
      begin
        FLastPlrError := OmPlrSetMaxPosMax(FPlrHandle);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlStart SetMaxPosMax failed, Error = %d', [Integer(FLastPlrError)])));

          exit;
        end;
        Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStart SetMaxPosMax succeeded', [])));

        FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
        FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlStart GetPlayerStatus_1 failed, Error = %d', [Integer(FLastPlrError)])));

          exit;
        end;

        // Take 명령에 의해 현재 송출 중인 이벤트의 길이가 줄어 들었을 경우
        // Player의 시작위치를 Take 이벤트의 위치로 조정
        if (EventCurr <> nil) and
           (PlrStatus.CurrClipNum = 0) and (PlrStatus.Pos < PlrStatus.CurrClipStartPos + PlrStatus.CurrClipLen) and
           (TimecodeToFrame(EventCurr^.DurTime, OmFrameRateValues[PlrStatus.FrameRate]) < PlrStatus.CurrClipLen) then
        begin
          FLastPlrError := OmPlrSetPos(FPlrHandle, PlrStatus.CurrClipStartPos + PlrStatus.CurrClipLen);
          if (FLastPlrError <> omPlrOk) then
          begin
      //      EventNext^.Status := esError;
            SetEventStatus(EventNext, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlStart SetPos failed, Error = %d', [Integer(FLastPlrError)])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStart SetPos succeeded, Pos = %d', [PlrStatus.CurrClipStartPos + PlrStatus.CurrClipLen])));
        end;

        if (PlrStatus.State <> omPlrStatePlay) then
        begin
          if (PlrStatus.State = omPlrStateStopped) then
          begin
            FLastPlrError := OmPlrCuePlay(FPlrHandle, FPlayRate);
            if (FLastPlrError <> omPlrOk) then
            begin
              SetEventStatus(EventNext, esError);
              Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlStart CuePlay failed, Error = %d', [Integer(FLastPlrError)])));

              exit;
            end;
            Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStart CuePlay succeeded, PlayRate = %f', [FPlayRate])));
          end;

          FLastPlrError := OmPlrPlay(FPlrHandle, FPlayRate);
          if (FLastPlrError <> omPlrOk) then
          begin
    //        FEventNext^.Status := esError;
            SetEventStatus(EventNext, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlStart Play failed, Error = %d, ID = %s', [Integer(FLastPlrError), EventNext^.Player.ID.ID])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStart Play succeeded, ID = %s', [EventNext^.Player.ID.ID])));
        end;

        if (PlrStatus.NumClips >= 2) then
//          if (EventCurr <> nil) then
        begin
          FLastPlrError := OmPlrGetClipAtNum(FPlrHandle, 0, FClipHandleCurr);
          if (FLastPlrError <> omPlrOk) then
          begin
  //          EventCurr^.Status := esError;
            SetEventStatus(EventNext, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlStart GetClipAtNum failed, Error = %d', [Integer(FLastPlrError)])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStart GetClipAtNum succeeded, ClipHandle = %d', [FClipHandleCurr])));

          if (FClipHandleCurr <> 0) then
          begin
            FLastPlrError := OmPlrDetach(FPlrHandle, FClipHandleCurr, omPlrShiftModeBefore);
            if (FLastPlrError <> omPlrOk) then
            begin
    //          EventCurr^.Status := esError;
              SetEventStatus(EventNext, esError);
              Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlStart Detach failed, Error = %d, ClipHandle = %d', [Integer(FLastPlrError), FClipHandleCurr])));

              exit;
            end;
            Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStart Detach succeeded, ClipHandle = %d', [FClipHandleCurr])));
            FClipHandleCurr := 0;

            FLastPlrError := OmPlrSetMinPosMin(FPlrHandle);
            if (FLastPlrError <> omPlrOk) then
            begin
              SetEventStatus(EventNext, esError);
              Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlStart SetMinPosMin failed, Error = %d', [Integer(FLastPlrError)])));

              exit;
            end;
            Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStart SetMinPosMin succeeded', [])));

  {      FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
        FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(FEventNext, esError);
          exit;
        end;

            FLastPlrError := OmPlrSetMaxPosMax(FPlrHandle);
            if (FLastPlrError <> omPlrOk) then
            begin
              SetEventStatus(FEventNext, esError);
              exit;
            end; }
          end;
  //        FEventQueue.Remove(FEventCurr);
  //        FEventCurr := nil;
        end;

//          FClipHandleCurr := FClipHandleNext;
{        if (PlrStatus.NumClips >= 1) then
        begin
          FLastPlrError := OmPlrGetClipAtNum(FPlrHandle, 0, FClipHandleCurr);
          if (FLastPlrError <> omPlrOk) then
          begin
  //          EventCurr^.Status := esError;
            SetEventStatus(EventNext, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlStart GetClipAtNum failed, Error = %d', [Integer(FLastPlrError)])));

            exit;
          end;
        end; }

  //      FEventCurr^.Status := esOnAir;
        SetEventStatus(EventNext, esOnAir);
      end
      else
      begin
        // Clip이 존재하지 않거나 큐가 정상적으로 되지 않았을 경우
        // 일시정지 시킴
        FLastPlrError := OmPlrCuePlay(FPlrHandle, FPlayRate);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlStart CuePlay failed, Error = %d', [Integer(FLastPlrError)])));

          exit;
        end;
        Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStart CuePlay succeeded, PlayRate = %f', [FPlayRate])));
      end;
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStart succeeded, ID = %s', [EventNext^.Player.ID.ID])));
    end;
  finally
//    if (FEventCurr <> nil) and (FEventCurr^.Status <> esOnAir) then
//    begin
//      FEventQueue.Remove(FEventCurr);
//      FEventCurr := nil;
//    end;

//    if (HasMainControl) then
    begin
      FClipHandleNext := 0;
    end;

    FEventLock.Leave;
    inherited;
  end;
end;

procedure TDeviceOMNEON.ControlStop;
var
  PlrStatus: TOmPlrStatus3;
  MaxPos: Integer;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventCurr <> nil) and (EventCurr^.Status.State = esOnAir) then
    begin
      SetEventStatus(EventCurr, esFinish);

{      FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
      FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
      if (FLastPlrError <> omPlrOk) then
      begin
        SetEventStatus(EventCurr, esError);
        Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceOMNEON.ControlStop GetPlayerStatus3 failed, Error = %d', [Integer(FLastPlrError)])));

        exit;
      end;

      if (PlrStatus.NumClips >= 1) then
      begin
        FLastPlrError := OmPlrGetClipAtNum(FPlrHandle, 0, FClipHandleFini);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventCurr, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceOMNEON.ControlStop GetClipAtNum failed, Error = %d', [Integer(FLastPlrError)])));

          exit;
        end;
      end;
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDeviceOMNEON.ControlStop GetClipAtNum succeeded, ClipHandle = %d', [FClipHandleFini])));
}
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDeviceOMNEON.ControlStop succeeded, ID = %s', [EventCurr^.Player.ID.ID])));
    end;
  finally
    FEventLock.Leave;
    inherited;
  end;
end;

procedure TDeviceOMNEON.ControlFinish;
var
  PlrStatus: TOmPlrStatus3;
  I: Integer;
  ClipHansle: TOmPlrClipHandle;
begin
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventFini <> nil) and (EventFini^.Status.State = esFinish) then
    begin
      SetEventStatus(EventFini, esFinishing);

//--- begin, sb, lee. 2024.04.14
// 다음이벤트가 없거나 Cued상태가 아닐 경우 Pause 처리
      case EventFini^.Player.FinishAction of
        FA_STOP: // FinishAction이 STOP일 경우 Pause 처리
        begin
          FLastPlrError := OmPlrCuePlay(FPlrHandle, FPlayRate);
          if (FLastPlrError <> omPlrOk) then
          begin
            SetEventStatus(EventFini, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDeviceOMNEON.ControlFinish CuePlay Failed. Error = %d,  ID = %s', [Integer(FLastPlrError), EventFini^.Player.ID.ID])));

  //            Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlStop Stop failed, Error = %d', [Integer(FLastPlrError)])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceOMNEON.ControlFinish CuePlay succeeded. ID = %s', [EventFini^.Player.ID.ID])));
  //          Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStop Stop succeeded', [])));
        end;
        FA_EJECT:
        begin
          FLastPlrError := OmPlrStop(FPlrHandle);
          if (FLastPlrError <> omPlrOk) then
          begin
            SetEventStatus(EventFini, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDeviceOMNEON.ControlFinish Stop Failed. Error = %d,  ID = %s', [Integer(FLastPlrError), EventFini^.Player.ID.ID])));

  //            Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlStop Stop failed, Error = %d', [Integer(FLastPlrError)])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceOMNEON.ControlFinish Stop succeeded. ID = %s', [EventFini^.Player.ID.ID])));
  //          Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlStop Stop succeeded', [])));
        end;
      end;

      SetEventStatus(EventFini, esFinished);

{      FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
      FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
      if (FLastPlrError <> omPlrOk) then
      begin
        SetEventStatus(EventFini, esError);
        Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceOMNEON.ControlStop GetPlayerStatus3 failed, Error = %d', [Integer(FLastPlrError)])));

        exit;
      end;

      if (PlrStatus.NumClips >= 2) and (PlrStatus.CurrClipNum >= 1) then
      begin
        for I := 0 to PlrStatus.CurrClipNum - 1 do
        begin
          FLastPlrError := OmPlrGetClipAtNum(FPlrHandle, 0, ClipHansle);
          if (FLastPlrError <> omPlrOk) then
          begin
            SetEventStatus(EventFini, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceOMNEON.ControlFinish GetClipAtNum failed, Error = %d', [Integer(FLastPlrError)])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDeviceOMNEON.ControlFinish GetClipAtNum succeeded, ClipHandle = %d', [ClipHansle])));

          if (ClipHansle <> 0) then
          begin
            FLastPlrError := OmPlrDetach(FPlrHandle, ClipHansle, omPlrShiftModeBefore);
            if (FLastPlrError <> omPlrOk) then
            begin
              SetEventStatus(EventFini, esError);
              Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDeviceOMNEON.ControlFinish Detach Failed. Error = %d, ClipHandle = %d, ID = %s', [Integer(FLastPlrError), ClipHansle, EventFini^.Player.ID.ID])));
              exit;
            end;
            Assert(False, GetLogDevice(lsNormal, ControlBy, FControlChannel, Format('TDeviceOMNEON.ControlFinish Detach succeeded. ClipHandle = %d, ID = %s', [ClipHansle, EventFini^.Player.ID.ID])));
            ClipHansle := 0;
          end;
        end;

        FLastPlrError := OmPlrSetMinPosMin(FPlrHandle);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventFini, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('TDeviceOMNEON.ControlFinish SetMinPosMin failed, Error = %d', [Integer(FLastPlrError)])));

          exit;
        end;
        Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDeviceOMNEON.ControlFinish SetMinPosMin succeeded', [])));
      end;

{        // 다음 이벤트가 없는 경우에는 Stop에서 현재 이벤트를 삭제
      if (EventNext = nil) then
      begin
        FLastPlrError := OmPlrGetClipAtNum(FPlrHandle, 0, FClipHandleCurr);

        if (FClipHandleCurr <> 0) then
        begin
          FLastPlrError := OmPlrDetach(FPlrHandle, FClipHandleCurr, omPlrShiftModeBefore);
          if (FLastPlrError <> omPlrOk) then
          begin
  //          EventCurr^.Status := esError;
            SetEventStatus(EventCurr, esError);
            exit;
          end;
          FClipHandleCurr := 0;
        end;
      end;
}
//--- end


  {    FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
      FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
      if (FLastPlrError <> omPlrOk) then
      begin
        FEventNext^.Status := esError;
        exit;
      end;

      if (FEventNext = nil) or
         ((FEventNext <> nil) and (FEventNext^.Status <= esLoaded)) then
      begin
        if (PlrStatus.NumClips > 0) and (PlrStatus.CurrClipNum < PlrStatus.NumClips - 1) then
        begin
          FLastPlrError := OmPlrStop(FPlrHandle);
          if (FLastPlrError <> omPlrOk) then
          begin
            FEventCurr^.Status := esError;
            exit;
          end;
        end
        else
        begin
          FLastPlrError := OmPlrStep(FPlrHandle, 0);
          if (FLastPlrError <> omPlrOk) then
          begin
            FEventCurr^.Status := esError;
            exit;
          end;
        end;
      end;

      if (FClipHandleCurr <> 0) then
      begin
        if (PlrStatus.NumClips > 0) and (PlrStatus.CurrClipNum < PlrStatus.NumClips - 1) then
        begin
          FLastPlrError := OmPlrDetach(FPlrHandle, FClipHandleCurr, omPlrShiftModeBefore);
          if (FLastPlrError <> omPlrOk) then
          begin
            FEventCurr^.Status := esError;
            exit;
          end;
          FClipHandleCurr := 0;
        end;
      end; }

      // If no next event or next event is not cuedone state then paused
{      if (FEventNext = nil) or
         ((FEventNext <> nil) and (FEventNext^.Status <= esLoaded)) then
      begin
        // Waiting for playback to the out point
        repeat
          FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
          FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
          if (FLastPlrError <> omPlrOk) then
          begin
  //          FEventCurr^.Status := esError;
            SetEventStatus(FEventCurr, esError);
            exit;
          end;
        until (Terminated) or (PlrStatus.Pos >= PlrStatus.MaxPos - 1);

        FLastPlrError := OmPlrCuePlay(FPlrHandle, FPlayRate);
        if (FLastPlrError <> omPlrOk) then
        begin
  //        FEventCurr^.Status := esError;
          SetEventStatus(FEventCurr, esError);
          exit;
        end;
      end;

      // If next event start time greater then current event end time, paused
      if (FEventNext <> nil) and (FEventNext^.Status = esCued) and
         (CompareEventTime(FEventNext^.StartTime, GetEventEndTime(FEventCurr^.StartTime, FEventCurr^.DurTime)) > 0) then
      begin
        FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
        FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
        if (FLastPlrError <> omPlrOk) then
        begin
//          FEventCurr^.Status := esError;
          SetEventStatus(FEventCurr, esError);
          exit;
        end;

        // Waiting for playback to the out point
        MaxPos := PlrStatus.MaxPos - TimecodeToFrame(FEventNext^.DurTime);
        while (not Terminated) and (PlrStatus.Pos <= MaxPos - 1) do
        begin
          FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
          FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
          if (FLastPlrError <> omPlrOk) then
          begin
            SetEventStatus(FEventCurr, esError);
            exit;
          end;
        end;

        FLastPlrError := OmPlrCuePlay(FPlrHandle, FPlayRate);
        if (FLastPlrError <> omPlrOk) then
        begin
  //        FEventCurr^.Status := esError;
          SetEventStatus(FEventCurr, esError);
          exit;
        end;
      end;

      if (FEventCurr^.EventID.SerialNo = 5) then
      begin
        FEventCurr^.EventID.SerialNo := 5;
      end; }

//      FEventCurr^.Status := esDone;
      SetEventStatus(EventFini, esDone);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('TDeviceOMNEON.ControlFinish succeeded, ID = %s', [EventFini^.Player.ID.ID])));
    end;
  finally
{    FEventQueue.Remove(FEventCurr);
    FEventCurr := nil; }

    FEventLock.Leave;
    inherited;
  end;
end;

procedure TDeviceOMNEON.ControlCue;
var
  ClipID: TOmPlrChar;
  ClipExist: Boolean;
  ClipIn, ClipOut: Cardinal;
  ClipAttachHandle: TOmPlrClipHandle;

  PlrStatus: TOmPlrStatus3;
  I: Integer;
begin
            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDeviceOMNEON.ControlCue Start.', [])));
  FEventLock.Enter;
  try
    if (not HasMainControl) then exit;

    if (EventNext <> nil) then
    begin
  //    EventNext^.Status := esCueing;
      SetEventStatus(EventNext, esCueing);

      FDevice^.Status.Player.Cue := True;
  //    FDevice^.Status.Player.CueDone := False;
  //    FCueing  := True;
//        FCueDone := False;
      UpdateStatus;

      FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
      FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
      if (FLastPlrError <> omPlrOk) then
      begin
  //      EventNext^.Status := esError;
        SetEventStatus(EventNext, esError);
        Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlCue GetPlayerStatus_1 failed, Error = %d', [Integer(FLastPlrError)])));

        exit;
      end;

{        if //(FClipHandleNext <> 0) and
         (((EventCurr <> nil) and (PlrStatus.NumClips >= 2)) or ((EventCurr = nil) and (PlrStatus.NumClips >= 1))) then
      begin
        FLastPlrError := OmPlrGetClipAtNum(FPlrHandle, PlrStatus.NumClips - 1, FClipHandleNext);
        if (FClipHandleNext <> 0) then
        begin
          FLastPlrError := OmPlrDetach(FPlrHandle, FClipHandleNext, omPlrShiftModeAfter);
          if (FLastPlrError <> omPlrOk) then
          begin
            SetEventStatus(EventNext, esError);
            exit;
          end;
          FClipHandleNext := 0;
        end;
      end; }

      if (PlrStatus.NumClips >= 2) then
      begin
//          for I := 0 to PlrStatus.NumClips - 2 do
        for I := PlrStatus.NumClips - 1 downto 1 do
        begin
          FLastPlrError := OmPlrGetClipAtNum(FPlrHandle, I, FClipHandleNext);
          if (FLastPlrError <> omPlrOk) then
          begin
            SetEventStatus(EventNext, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlCue GetClipAtNum failed, Error = %d', [Integer(FLastPlrError)])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue GetClipAtNum succeeded, ClipNum = %d, ClipHandle = %d', [I, FClipHandleNext])));

          if (FClipHandleNext <> 0) then
          begin
//              FLastPlrError := OmPlrDetach(FPlrHandle, FClipHandleNext, omPlrShiftModeBefore);
            FLastPlrError := OmPlrDetach(FPlrHandle, FClipHandleNext, omPlrShiftModeAfter);
            if (FLastPlrError <> omPlrOk) then
            begin
              SetEventStatus(EventNext, esError);
              Assert(False, GetLogDevice(lsError, Format('ControlCue Detach failed, Error = %d', [Integer(FLastPlrError)])));

              exit;
            end;
            Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue Detach succeeded, ClipNum = %d, ClipHandle = %d', [I, FClipHandleNext])));

            FLastPlrError := OmPlrSetMaxPosMax(FPlrHandle);
            if (FLastPlrError <> omPlrOk) then
            begin
              SetEventStatus(EventNext, esError);
              Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlCue SetMaxPosMax failed, Error = %d', [Integer(FLastPlrError)])));

              exit;
            end;
            Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue SetMaxPosMax succeeded', [])));

            FClipHandleNext := 0;
          end;
        end;
      end;

      FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
      FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
      if (FLastPlrError <> omPlrOk) then
      begin
  //      EventNext^.Status := esError;
        SetEventStatus(EventNext, esError);
        Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlCue GetPlayerStatus_2 failed, Error = %d', [Integer(FLastPlrError)])));

        exit;
      end;

      Assert(False, GetLogCommonStr(lsNormal, format('%d : %d : sub = %d', [PlrStatus.Pos, PlrStatus.MaxPos, PlrStatus.MaxPos - PlrStatus.Pos])));
      if ((PlrStatus.MaxPos - PlrStatus.Pos) < (TimecodeToFrame(FCuedDurTime, OmFrameRateValues[PlrStatus.FrameRate]) + 1)) then
      begin
        FLastPlrError := OmPlrStop(FPlrHandle);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlCue Stop failed, Error = %d, ID = %s', [Integer(FLastPlrError), EventNext^.Player.ID.ID])));

          exit;
        end;
        Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue Stop succeeded, ID = %s', [EventNext^.Player.ID.ID])));
      end;

//        if ((EventCurr <> nil) and (PlrStatus.NumClips <= 1)) or
//           ((EventCurr = nil) and (PlrStatus.NumClips <= 0)) then
      begin

        ClipID := EventNext^.Player.ID.ID;
        ClipExist := False;
        FLastPlrError := OmPlrClipExists(FPlrHandle, EventNext^.Player.ID.ID, ClipExist);
        if (FLastPlrError <> omPlrOk) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlCue ClipExists failed, Error = %d, ID = %s', [Integer(FLastPlrError), EventNext^.Player.ID.ID])));

          exit;
        end;

        Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue ClipExists succeeded, ID = %s, Exist = %s', [EventNext^.Player.ID.ID, BoolToStr(ClipExist, True)])));

        if (not ClipExist) then
        begin
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlCue clip not exist, No more work can be done, ID = %s', [EventNext^.Player.ID.ID])));

          exit;
        end;

        ClipIn  := TimecodeToFrame(EventNext^.Player.StartTC, OmFrameRateValues[PlrStatus.FrameRate]);
        ClipOut := TimecodeToFrame(GetPlusTimecode(EventNext^.Player.StartTC, EventNext^.DurTime, ControlFrameRateType), OmFrameRateValues[PlrStatus.FrameRate]);
        FLastPlrError := OmPlrAttach(FPlrHandle, ClipID, ClipIn, ClipOut, 0, omPlrShiftModeAfter, ClipAttachHandle);
        if (FLastPlrError <> omPlrOk) then
        begin
    //      EventNext^.Status := esError;
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlCue Attach failed, Error = %d', [Integer(FLastPlrError)])));

          exit;
        end;
        Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue Attach succeeded, ID = %s, ClipIn = %d, ClipOut = %d', [EventNext^.Player.ID.ID, ClipIn, ClipOut])));
        FClipHandleNext := ClipAttachHandle;

        // If current event end time smaller then next event start time, set maxposmax
//          if (EventCurr = nil) or
//             ((EventCurr <> nil) {and (not EventCurr^.ManualEvent)} and
//              (CompareEventTime(EventNext^.StartTime, GetEventEndTime(EventCurr^.StartTime, EventCurr^.DurTime)) <= 0)) then
//          begin
//            FLastPlrError := OmPlrSetMaxPosMax(FPlrHandle);
//            if (FLastPlrError <> omPlrOk) then
//            begin
//        //      EventNext^.Status := esError;
//              SetEventStatus(EventNext, esError);
//              Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlCue SetMaxPosMax failed, Error = %d', [Integer(FLastPlrError)])));
//
//              exit;
//            end;
//            Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue SetMaxPosMax succeeded', [])));
//          end;

        FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
        FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
        if (FLastPlrError <> omPlrOk) then
        begin
    //      EventNext^.Status := esError;
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlCue GetPlayerStatus_3 failed, Error = %d', [Integer(FLastPlrError)])));

          exit;
        end;

        if (PlrStatus.State = omPlrStateStopped) then
        begin
          FLastPlrError := OmPlrCuePlay(FPlrHandle, FPlayRate);
          if (FLastPlrError <> omPlrOk) then
          begin
    //        EventNext^.Status := esError;
            SetEventStatus(EventNext, esError);
            Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlCue CuePlay failed, Error = %d', [Integer(FLastPlrError)])));

            exit;
          end;
          Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue CuePlay succeeded, PlayRate = %f', [FPlayRate])));
        end;

        FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
        FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
        if (FLastPlrError <> omPlrOk) then
        begin
    //      EventNext^.Status := esError;
          SetEventStatus(EventNext, esError);
          Assert(False, GetLogDevice(lsError, ControlBy, ControlChannel, Format('ControlCue GetPlayerStatus_4 failed, Error = %d', [Integer(FLastPlrError)])));

          exit;
        end;
      end;

      FDevice^.Status.Player.Cue := False;
  //    FDevice^.Status.Player.CueDone := True;
//        FCueDone := True;
  //    UpdateStatus;

//      FEventNext^.Status := esCued;
      SetEventStatus(EventNext, esCued);
      Assert(False, GetLogDevice(lsNormal, ControlBy, ControlChannel, Format('ControlCue succeeded, ID = %s', [EventNext^.Player.ID.ID])));
    end;
  finally
{    if (FEventNext <> nil) and (FEventNext^.Status <> esCued) then
    begin
      FEventQueue.Remove(FEventNext);
//      FEventNext := nil;
      FEventNext := GetNextEvent;
//      FClipHandleNext := 0;
    end; }

            Assert(False, GetLogDevice(lsError, ControlBy, FControlChannel, Format('TDeviceOMNEON.ControlCue End.', [])));
    FEventLock.Leave;
    inherited;
  end;
end;

procedure TDeviceOMNEON.ControlSchedule;
begin
  inherited;
end;

procedure TDeviceOMNEON.ControlGetStatus;
begin
  inherited;
end;

function TDeviceOMNEON.GetStatus: TDeviceStatus;
var
  PlrStatus: TOmPlrStatus3;
begin
  FillChar(Result, SizeOf(TDeviceStatus), #0);

  try
  with Result do
  begin
    EventType := ET_PLAYER;

    FillChar(PlrStatus, SizeOf(TOmPlrStatus3), #0);
    FLastPlrError := OmPlrGetPlayerStatus3(FPlrHandle, PlrStatus);
    if (FLastPlrError = omPlrOk) then
    begin
      Connected := True;

      Player.Stop       := (PlrStatus.NumClips = 0) or (PlrStatus.State = omPlrStateStopped);

//      Player.Cue        := (PlrStatus.Status.State in [omPlrStateCuePlay, omPlrStateCueRecord]);
      Player.Play       := (PlrStatus.State = omPlrStatePlay) and (PlrStatus.Pos < PlrStatus.MaxPos - 1);
      Player.Rec        := (PlrStatus.State = omPlrStateRecord) and (PlrStatus.Pos < PlrStatus.MaxPos - 1);
//      Player.Still      := (PlrStatus.Status.State in [omPlrStatePlay, omPlrStateRecord]) and (PlrStatus.Rate = 0.0);
//      Player.Still      := (PlrStatus.Status.State in [omPlrStatePlay, omPlrStateRecord]) and (PlrStatus.Pos = (PlrStatus.MaxPos - 1));

{      if (FCueDone) and
         (PlrStatus.Pos - PlrStatus.CurrClipStartPos = 0) and
         (PlrStatus.NumClips > 0) and (PlrStatus.CurrClipNum = PlrStatus.NumClips - 1) then
        Player.Still := False
      else  }
        Player.Still      := (PlrStatus.NumClips > 0) and
                             ((PlrStatus.Rate = 0.0) or
                              (PlrStatus.State in [{omPlrStateStopped, }omPlrStateCuePlay]) or
                              ((PlrStatus.State in [omPlrStatePlay, omPlrStateRecord]) and (PlrStatus.Pos = PlrStatus.MaxPos - 1)));

      Player.Jog        := (PlrStatus.State in [omPlrStatePlay, omPlrStateRecord]) and (PlrStatus.Rate < 1) and (PlrStatus.Rate > -1);
      Player.Shuttle    := (PlrStatus.State in [omPlrStatePlay, omPlrStateRecord]) and ((PlrStatus.Rate > 1) or (PlrStatus.Rate < -1));
      Player.PortBusy   := False;

{      if ((PlrStatus.Pos = PlrStatus.MinPos) or
          (PlrStatus.Pos - PlrStatus.CurrClipStartPos > 0)) and  //(PlrStatus.Status.State in [omPlrStatePlay, omPlrStateRecord]) and
         (PlrStatus.NumClips > 0) and (PlrStatus.CurrClipNum = PlrStatus.NumClips - 1) then
        FCueDone := False;  }

      if ((PlrStatus.NumClips = 1) and (PlrStatus.Pos = PlrStatus.MinPos) and (PlrStatus.CurrClipNum = 0)) or
         ((PlrStatus.NumClips > 1) and (PlrStatus.Pos - PlrStatus.CurrClipStartPos > 0))then
        FCueDone := True
      else
        FCueDone := False;

//      if (FCueDone) then FCueing := False;
//
//      Player.Cue     := FCueing;
      Player.CueDone := FCueDone;

//      Player.CueDone    := (PlrStatus.Status.State in [omPlrStateCuePlay, omPlrStateCueRecord]) and (PlrStatus.MaxPos > 0);

      Player.DropFrame := (PlrStatus.FrameRate in [omFrmRate29_97Hz, omFrmRate59_94Hz, omFrmRate23_976Hz]);
      Player.PortDown  := (PlrStatus.PortDown);

      if (Player.Stop) then
      begin
        Player.CurTC    := 0;
        Player.RemainTC := 0;
      end
      else
      begin
        Player.CurTC    := FrameToTimecode(PlrStatus.Pos - PlrStatus.CurrClipStartPos, OmFrameRateValues[PlrStatus.FrameRate]);
        Player.RemainTC := FrameToTimecode(PlrStatus.CurrClipLen - (PlrStatus.Pos - PlrStatus.CurrClipStartPos), OmFrameRateValues[PlrStatus.FrameRate]);
      end;
    end
    else
    begin
      Assert(False, GetLogDevice(lsError, Format('GetStatus GetPlayerStatus failed, Error = %d', [Integer(FLastPlrError)])));

      Connected := False;
      DeviceClose;
{      if (not FOpened) then }DeviceOpen;

//      if (FLastPlrError = omPlrBadRemoteHandle) then
//        if (DCSOpen = D_OK) then
//          Result := GetStatus;
    end;
  end;

  Result := inherited GetStatus;
  except
    on E : Exception do
    begin
      Assert(False, GetLogDevice(lsError, Format('TDeviceOMNEON.GetStatus exception error. class name = %s, message = %s', [E.ClassName, E.Message])));
    end;
  end;
end;

procedure TDeviceOMNEON.SetEventStatus(AEvent: PEvent; AState: TEventState; AErrorCode: Integer = E_NO_ERROR);
begin
  inherited;

  if (AState = esError) and
     (FPlrStatus.State = omPlrStatePlay) then
  begin
    FLastPlrError := OmPlrCuePlay(FPlrHandle, FPlayRate);
    if (FLastPlrError <> omPlrOk) then
    begin
      exit;
    end;
  end;
end;

function TDeviceOMNEON.DeviceOpen: Integer;
begin
  Result := inherited DeviceOpen;

  FPlrHandle := nil;

  with FDevice^.Omneon do
  begin
    FLastPlrError := OmPlrOpen(DirectorName, PlayerName, FPlrHandle);
    if (FLastPlrError <> omPlrOk) then
    begin
      FOpened := False;
      Result := D_FALSE;
      Assert(False, GetLogDevice(lsError, Format('Device open failed, Error = %d, DirectorName = %s, PlayerName = %s', [Integer(FLastPlrError), DirectorName, PlayerName])));

      exit;
    end;

    Assert(False, GetLogDevice(lsNormal, Format('Device open succeeded, DirectorName = %s, PlayerName = %s, PlrHandle = %p', [DirectorName, PlayerName, FPlrHandle])));
  end;

  FOpened := True;
end;

function TDeviceOMNEON.DeviceClose: Integer;
begin
  Result := inherited DeviceClose;
  if (Result <> D_OK) then exit;

//  if (FPlrHandle <> nil) then
  begin
    FLastPlrError := OmPlrClose(FPlrHandle);
    if (FLastPlrError <> omPlrOk) then
    begin
      Result := D_FALSE;
      Assert(False, GetLogDevice(lsError, Format('Device close failed, Error = %d, PlrHandle = %p', [Integer(FLastPlrError), FPlrHandle])));

      exit;
    end;

    Assert(False, GetLogDevice(lsNormal, Format('Device close succeeded, PlrHandle = %p', [FPlrHandle])));
  end;

  FPlrHandle := nil;
  FOpened := False;

  Result := D_OK;
end;

function TDeviceOMNEON.DeviceInit: Integer;
begin
  Result := inherited DeviceInit;

  FCueing  := False;
  FCueDone := False;

  FClipHandleCurr := 0;
  FClipHandleNext := 0;
  FClipHandleFini := 0;

  if (not HasMainControl) then exit;

  try
//      if (FPlrHandle <> nil) then
    begin
      // Omneon device initialize
      FLastPlrError := OmPlrStop(FPlrHandle);
      if (FLastPlrError <> omPlrOk) then
      begin
        Result := D_FALSE;
        exit;
      end;

      FLastPlrError := OmPlrDetachAllClips(FPlrHandle);
      if (FLastPlrError <> omPlrOk) then
      begin
        Result := D_FALSE;
        exit;
      end;

      FLastPlrError := OmPlrSetMaxPosMax(FPlrHandle);
      if (FLastPlrError <> omPlrOk) then
      begin
        Result := D_FALSE;
        exit;
      end;

      FLastPlrError := OmPlrSetMinPosMin(FPlrHandle);
      if (FLastPlrError <> omPlrOk) then
      begin
        Result := D_FALSE;
        exit;
      end;
    end;
  finally
    if (FLastPlrError <> omPlrOk) then
    begin
      Assert(False, GetLogDevice(lsError, Format('Device init failed, Error = %d, PlrHandle = %p', [Integer(FLastPlrError), FPlrHandle])));
    end;
  end;

  Assert(False, GetLogDevice(lsNormal, Format('Device init succeeded, PlrHandle = %p', [FPlrHandle])));
end;

{function TDeviceOMNEON.DCSGetStatus(ABuffer: String): Integer;
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

function TDeviceOMNEON.TimecodeToFrame(AValue: TTimecode; AFrameRate: Double): Cardinal;
var
  T: TTypeConvTime;
  RatePerFrame: Word;
  MS: Word;
begin
  Result := 0;

  RatePerFrame := Round(AFrameRate);
  if (RatePerFrame <= 0) then RatePerFrame := 1;

  T.vtDWord := AValue;

  if (AFrameRate = 29.97) then
  begin
    if ((T.Frame in [0..1]) and (T.Second = 0) and ((T.Minute mod 10) <> 0)) then
      T.Frame := 2
    else if (T.Frame >= 30) then
      T.Frame := 29;

    Result := (T.Hour * 107892) + ((T.Minute * 1800) - ((T.Minute - (T.Minute div 10)) * 2)) + (T.Second * RatePerFrame) + T.Frame;
  end
  else if (AFrameRate = 59.94) then
  begin
    if ((T.Frame in [0..3]) and (T.Second = 0) and ((T.Minute mod 10) <> 0)) then
      T.Frame := 4
    else if (T.Frame >= 60) then
      T.Frame := 59;

    Result := (T.Hour * 215784) + ((T.Minute * 3600) - ((T.Minute - (T.Minute div 10)) * 4)) + (T.Second * RatePerFrame) + T.Frame;
  end
  else
  begin
    if (T.Frame >= RatePerFrame) then
      T.Frame := RatePerFrame - 1;

    if (AFrameRate = 23.976) then
      Result := Round(((T.Hour * 3600) + (T.Minute * 60) + T.Second) * RatePerFrame) + T.Frame
    else
      Result := Round(((T.Hour * 3600) + (T.Minute * 60) + T.Second) * AFrameRate) + T.Frame;//Format('%.2d:%.2d:%.2d:%.2d', [HH, MI, SS, FF]);
  end;
end;

function TDeviceOMNEON.FrameToTimecode(AFrames: Integer; AFrameRate: Double): TTimecode;
var
  HH, MI, SS, FF: Integer;
  F: Integer;
  RatePerFrame: Word;
  SampleTime: Double;
  T: TTypeConvTime;
begin
  F := AFrames;

  if (F <= 0) then
  begin
    Result := 0;
    exit;
  end;

  RatePerFrame := Round(AFrameRate);
  if (RatePerFrame <= 0) then RatePerFrame := 1;

  if (AFrameRate = 29.97) then
  begin
    HH := (F div 107892);
    F  := (F mod 107892);
    MI := (F div 1800);
    F  := (F mod 1800) + (((MI - (MI div 10)) * 2));
    if (F >= 1800) then
    begin
      Inc(MI);
      Dec(F, 1800);
      if (MI >= 60) then
      begin
        Inc(HH);
        Dec(MI, 60);
      end;

      if ((MI mod 10) <> 0) then F := F + 2;
    end;

    SS := (F div RatePerFrame);
    F  := (F mod RatePerFrame);
    FF := (F);
  end
  else if (AFrameRate = 59.94) then
  begin
    HH := (F div 215784);
    F  := (F mod 215784);
    MI := (F div 3600);
    F  := (F mod 3600) + (((MI - (MI div 10)) * 4));
    if (F >= 3600) then
    begin
      Inc(MI);
      Dec(F, 3600);
      if (MI >= 60) then
      begin
        Inc(HH);
        Dec(MI, 60);
      end;

      if ((MI mod 10) <> 0) then F := F + 4;
    end;

    SS := (F div RatePerFrame);
    F  := (F mod RatePerFrame);
    FF := (F);
  end
  else
  begin
    if (AFrameRate = 23.976) then
      SampleTime := F / RatePerFrame
    else
      SampleTime := F / AFrameRate;

    HH := (Trunc(SampleTime) div 3600);
    SampleTime := (SampleTime - (HH * 3600));
    MI := (Trunc(SampleTime) div 60);
    SampleTime := (SampleTime - (MI * 60));
    SS := (Trunc(SampleTime));
    SampleTime := (SampleTime - SS);
    FF := Round(SampleTime * RatePerFrame);

    if (FF >= RatePerFrame) then
    begin
      FF := 0;
      Inc(SS);

      if (SS >= 60) then
      begin
        Inc(MI);
        SS := 0;
      end;

      if (MI >= 60) then
      begin
        Inc(HH);
        MI := 0;
      end;
    end;
  end;

  T.Frame  := FF;
  T.Second := SS;
  T.Minute := MI;
  T.Hour   := HH;

  Result := T.vtDWord;
end;

end.
