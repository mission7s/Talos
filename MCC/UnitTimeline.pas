unit UnitTimeline;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitWorkForm, AdvUtil, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, AdvCGrid, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.StdCtrls, System.Generics.Collections,
  AdvOfficePager, AdvSplitter,
  WMTools, WMControls, WMTimeLine, WMUtils, {LibXmlParserU, }Xml.VerySimple,
  UnitCommons, UnitDCSDLL, UnitConsts, Vcl.ComCtrls,
  UnitTimelineChannel;

type
  TTimelineTimerThread = class;

  TfrmTimeline = class(TfrmWork)
    WMPanel8: TWMPanel;
    wmtlPlaylist: TWMTimeLine;
    pnlChannel: TWMPanel;
    WMPanel2: TWMPanel;
    Label8: TLabel;
    AdvSplitter2: TAdvSplitter;
    pnlChannelCaption: TWMPanel;
    pnlChannelList: TWMPanel;
    wmibTimelineZoomIn: TWMImageSpeedButton;
    wmtbTimelineZoom: TWMTrackBar;
    wmibTimelineZoomOut: TWMImageSpeedButton;
    wmibTimelineMoveRight: TWMImageSpeedButton;
    wmibTimelineMoveLeft: TWMImageSpeedButton;
    wmibTimelineGotoCurrent: TWMImageSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure wmtlPlaylistTrackHintEvent(Sender: TObject; Track: TTrack;
      var HintStr: string);
    procedure wmtlPlaylistMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure wmtbTimelineZoomChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure wmtlPlaylistDataGroupVertScrollEvent(Sender: TObject;
      Message: TWMScroll);
  private
    { Private declarations }
    FTimelineChannelList: TList<TfrmTimelineChannel>;

    FPanelInstance: Pointer;
    FDefPanelProc: Pointer;
    FPanelHandle: HWND;

    FPlayListFileName: String;

    FTimelineSpace: Integer;

    FTimelineStartDate: TDateTime;

    FTimeLineDaysPerFrames: Integer;
    FTimeLineMin: Integer;
    FTimeLineMax: Integer;

    FTimeLineZoomType: TTimelineZoomType;
    FTimeLineZoomPosition: Integer;

    FErrorDisplayEnabled: Boolean;

    FTimerThread: TTimelineTimerThread;

    function GetPositionByZoomType(AZoomType: TTimelineZoomType): Integer;
    function GetZoomTypeByPosition(APosition: Integer): TTimelineZoomType;
    procedure UpdateZoomPosition(APosition: Integer);
    procedure SetZoomPosition(Value: Integer);

    procedure Initialize;
    procedure Finalize;

    procedure InitializeTimeline;

    function GetTimelinChannelByChannelID(AChannelID: Word): TfrmTimelineChannel;

    function GetTimelineCompIndexByChannelID(AChannelID: Word): Integer;

    procedure DisplayChannelTime(AChannelID: Word);

    procedure PopulatePlayListTimeLine(AItem: PCuesheetItem);
    procedure PopulateEventStatusPlayListTimeLine(AIndex: Integer; AItem: PCueSheetItem);

    procedure UpdateChangeDatePlayListTimeLine(ADays: Integer);
    procedure RealtimeChangePlayListTimeLine;
    procedure DeletePlayListTimeLine(AItem: PCueSheetItem);

    procedure ClearPlayListTimeLine(AChannelID: Word);

    procedure PanelWndProc(var Message: TMessage);
  protected
//    procedure WndProc(var Message: TMessage); override;

    procedure WMUpdateChannelTime(var Message: TMessage); message WM_UPDATE_CHANNEL_TIME;
    procedure WMUpdateEventStatus(var Message: TMessage); message WM_UPDATE_EVENT_STATUS;
    procedure WMUpdateErrorDisplay(var Message: TMessage); message WM_UPDATE_ERROR_DISPLAY;
    procedure WMSetOnAir(var Message: TMessage); message WM_SET_ONAIR;

    procedure WMBeginUpdate(var Message: TMessage); message WM_BEGIN_UPDATE;
    procedure WMInsertCueSheet(var Message: TMessage); message WM_INSERT_CUESHEET;
    procedure WMUpdateCueSheet(var Message: TMessage); message WM_UPDATE_CUESHEET;
    procedure WMDeleteCueSheet(var Message: TMessage); message WM_DELETE_CUESHEET;
    procedure WMClearCueSheet(var Message: TMessage); message WM_CLEAR_CUESHEET;
    procedure WMEndUpdate(var Message: TMessage); message WM_END_UPDATE;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer); overload;
    procedure AdjustTimelineChannel;

    procedure TimelineGotoCurrent;
    procedure TimelineMoveLeft;
    procedure TimelineMoveRight;

    procedure TimelineZoomIn;
    procedure TimelineZoomOut;

    procedure SetChannelOnAir(AChannelID: Word; AOnAir: Boolean);
    procedure SetChannelTime(AChannelID: Word; APlayedTime, ARemainingTime: String);

    procedure SetEventStatus(AEventID: TEventID; AStatus: TEventStatus; AIsCurrEvent: Boolean = False);
    procedure SetEventOverall(ADCSIP: String; ADeviceHandle: TDeviceHandle; AOverall: TEventOverall);

    property TimelineZoomPosition: Integer read FTimelineZoomPosition write SetZoomPosition;
    property TimelineZoomType: TTimelineZoomType read FTimelineZoomType;
  end;

  TTimelineTimerThread = class(TThread)
  private
    FTimelineForm: TfrmTimeline;

    procedure DoCueSheetCheck;
  protected
    procedure Execute; override;
  public
    constructor Create(ATimelineForm: TfrmTimeline);
    destructor Destroy; override;
  end;

var
  frmTimeline: TfrmTimeline;

implementation

uses UnitMCC, System.DateUtils, System.Math;

{$R *.dfm}

procedure TfrmTimeline.WMUpdateChannelTime(var Message: TMessage);
begin
  RealtimeChangePlayListTimeLine;
end;

procedure TfrmTimeline.WMUpdateEventStatus(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item := PCueSheetItem(Message.LParam);

  if (Item <> nil) and (Item^.EventStatus.State = esSkipped) then
    DeletePlayListTimeline(Item)
  else
    PopulatePlayListTimeline(Item);
end;

procedure TfrmTimeline.WMUpdateErrorDisplay(var Message: TMessage);
begin
  FErrorDisplayEnabled := not FErrorDisplayEnabled;
end;

procedure TfrmTimeline.WMSetOnAir(var Message: TMessage);
var
  ChannelID: Word;
  IsOnAir: Boolean;
begin
  ChannelID := Message.WParam;
  IsOnAir := Boolean(Message.LParam);

  SetChannelOnAir(ChannelID, IsOnAir);
end;

procedure TfrmTimeline.WMBeginUpdate(var Message: TMessage);
begin
  wmtlPlaylist.BeginUpdateCompositions;
end;

procedure TfrmTimeline.WMInsertCueSheet(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item := PCueSheetItem(Message.LParam);

  PopulatePlayListTimeline(Item);
end;

procedure TfrmTimeline.WMUpdateCueSheet(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item := PCueSheetItem(Message.LParam);

  PopulatePlayListTimeline(Item);
end;

procedure TfrmTimeline.WMDeleteCueSheet(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item := PCueSheetItem(Message.LParam);

  DeletePlayListTimeline(Item);
end;

procedure TfrmTimeline.WMClearCueSheet(var Message: TMessage);
var
  ChannelID: Word;
begin
  ChannelID := Message.WParam;

  ClearPlayListTimeline(ChannelID);
end;

procedure TfrmTimeline.WMEndUpdate(var Message: TMessage);
begin
  wmtlPlaylist.EndUpdateCompositions;
end;

//procedure TfrmTimeline.WMEndUpdate(var Message: TMessage); message WM_END_UPDATE;
//begin
//  wmtlPlaylist.EndUpdateCompositions;
//end;
//
//procedure TfrmTimeline.WndProc(var Message: TMessage);
//var
//  Index: Integer;
//
//  Item: PCueSheetItem;
//  ChannelID: Word;
//
//  EventID: TEventID;
//
//  IsOnAir: Boolean;
//
//  NextStartTime: TDateTime;
//  NextIndex: Integer;
//  CurrIndex: Integer;
//  TargetIndex: Integer;
//
//  CurrentTime: TDateTime;
//  PlayedTime: TDateTime;
//  RemainTime: TDateTime;
//  RemainTargetTime: TDateTime;
//
//  PlayedTimeString: String;
//  RemainTimeString: String;
//  NextStartTimeString: String;
//  NextDurationString: String;
//  RemainTargetTimeString: String;
//
//  SaveStartTime: TEventTime;
//
//  EventStatus: TEventStatus;
//  MediaStatus: TMediaStatus;
//
//  C, R: Integer;
//begin
//  inherited;
//  case Message.Msg of
//    WM_UPDATE_CHANNEL_TIME:
//    begin
//      RealtimeChangePlayListTimeLine;
//    end;
//
//    WM_UPDATE_CURR_EVENT:
//    begin
//{      CurrIndex := GetCueSheetIndexByItem(CueSheetCurr);
//      if (CurrIndex >= 0) then
//      begin
//        if (GV_SettingOption.OnAirEventHighlight) then
//        begin
//          with acgPlaylist do
//          begin
//            R := DisplRowIndex(CurrIndex + CNT_CUESHEET_HEADER);
////            if (R >= FixedRows) or (R <= RowCount - 1) then
//            begin
//              TopRow := R - GV_SettingOption.OnAirEventFixedRow;
//
//              MouseActions.DisjunctRowSelect := False;
//              ClearRowSelect;
//              MouseActions.DisjunctRowSelect := True;
//              SelectRows(R, 1);
//              Row := R;
//            end;
//          end;
//        end;
//
//        CurrIndex := GetNextOnAirMainIndexByItem(CueSheetCurr);
//        OnAirInputEvents(CurrIndex, 1);
//      end;
//
//      if (FChannelTimelineForm <> nil) then
//        FChannelTimelineForm.SetCueSheetCurr(CueSheetCurr);  }
//    end;
//
//    WM_UPDATE_NEXT_EVENT:
//    begin
//{      if (CueSheetCurr <> nil) then
//        NextIndex := GetCueSheetIndexByItem(CueSheetCurr)
//      else
//        NextIndex := GetCueSheetIndexByItem(CueSheetNext);
//
//      if (NextIndex >= 0) then
//      begin
//        if (GV_SettingOption.OnAirEventHighlight) then
//        begin
//          with acgPlaylist do
//          begin
//            R := DisplRowIndex(NextIndex + CNT_CUESHEET_HEADER);
////            if (R >= FixedRows) or (R <= RowCount - 1) then
//            begin
//              TopRow := R - GV_SettingOption.OnAirEventFixedRow;
//
//              MouseActions.DisjunctRowSelect := False;
//              ClearRowSelect;
//              MouseActions.DisjunctRowSelect := True;
//              SelectRows(R, 1);
//              Row := R;
//            end;
//          end;
//        end;
//      end;
//
//      if (FChannelTimelineForm <> nil) then
//        FChannelTimelineForm.SetCueSheetNext(CueSheetNext);  }
//    end;
//
//    WM_UPDATE_TARGET_EVENT:
//    begin
//{      TargetIndex := GetCueSheetIndexByItem(CueSheetTarget);
////      if (TargetIndex >= 0) then
//      begin
//        acgPlaylist.Repaint;
//      end; }
//    end;
//
//    WM_UPDATE_EVENT_STATUS:
//    begin
//      Index := Message.WParam;
//      Item := PCueSheetItem(Message.LParam);
//
//      if (Item <> nil) and (Item^.EventStatus.State = esSkipped) then
//        DeletePlayListTimeLine(Item)
//      else
//        PopulatePlayListTimeLine(Item);
//    end;
//
//    WM_UPDATE_ERROR_DISPLAY:
//    begin
//      FErrorDisplayEnabled := not FErrorDisplayEnabled;
////      ErrorDisplayPlayListTimeLine;
//    end;
//
//    WM_SET_ONAIR:
//    begin
//      ChannelID := Message.WParam;
//      IsOnAir := Boolean(Message.LParam);
//
//      SetChannelOnAir(ChannelID, IsOnAir);
//    end;
//
//    WM_BEGIN_UPDATE:
//    begin
//      wmtlPlaylist.BeginUpdateCompositions;
//    end;
//
//    WM_INSERT_CUESHEET:
//    begin
//      Index := Message.WParam;
//      Item := PCueSheetItem(Message.LParam);
//
//      PopulatePlayListTimeLine(Item);
//    end;
//
//    WM_UPDATE_CUESHEET:
//    begin
//      Index := Message.WParam;
//      Item := PCueSheetItem(Message.LParam);
//
//      PopulatePlayListTimeLine(Item);
//    end;
//
//    WM_DELETE_CUESHEET:
//    begin
//      Index := Message.WParam;
//      Item := PCueSheetItem(Message.LParam);
//
//      DeletePlayListTimeLine(Item);
//    end;
//
//    WM_CLEAR_CUESHEET:
//    begin
//      ChannelID := Message.WParam;
//
//      ClearPlayListTimeLine(ChannelID);
//    end;
//
//    WM_END_UPDATE:
//    begin
//      wmtlPlaylist.EndUpdateCompositions;
//    end;
//  end;
//end;

constructor TfrmTimeline.Create(AOwner: TComponent; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited Create(AOwner, ACombine, ALeft, ATop, AWidth, AHeight);
end;

procedure TfrmTimeline.Initialize;
begin
  FTimelineChannelList := TList<TfrmTimelineChannel>.Create;

  wmtbTimelineZoom.Min := 0;
  wmtbTimelineZoom.Max := Round(SecsPerDay * wmtlPlaylist.TimeZoneProperty.FrameRate) + 1;
  wmtbTimelineZoom.Position := 6;//wmtbTimelineZoom.Max;
  FTimeLineZoomPosition := wmtbTimelineZoom.Position;

  FTimelineSpace := GV_SettingOption.TimelineSpace;

  FErrorDisplayEnabled := True;

  InitializeTimeline;

  FTimerThread := TTimelineTimerThread.Create(Self);
  FTimerThread.Resume;
end;

procedure TfrmTimeline.Finalize;
var
  I: Integer;
  ChannelForm: TfrmTimelineChannel;
begin
  if (FTimerThread <> nil) then
  begin
    FTimerThread.Terminate;
    FTimerThread.WaitFor;
    FreeAndNil(FTimerThread);
  end;

  for I := 0 to GV_ChannelList.Count - 1 do
    ClearPlayListTimeLine(GV_ChannelList[I]^.ID);

  for I := 0 to FTimelineChannelList.Count - 1 do
  begin
    ChannelForm := FTimelineChannelList[I];
    FreeAndNil(ChannelForm);
  end;

  if FPanelHandle <> 0 then
    SetWindowLong(FPanelHandle, GWL_WNDPROC, LongInt(FDefPanelProc));
  FreeObjectInstance(FPanelInstance);
end;

procedure TfrmTimeline.InitializeTimeline;
var
  I: Integer;
  Channel: PChannel;
  ChannelForm: TfrmTimelineChannel;
begin
  // Timeline
  with wmtlPlaylist do
  begin
    with TimeZoneProperty do
    begin
      FrameDayReset := True;
//      FrameRate := FrameRate29_97;
      FrameRate := FrameRate30_00;
      FrameSkip := 30;
      FrameStep := 15;
      RailBarColor := COLOR_BAR_TIMELINE_RAIL;
      RailBarVisible := True;

      FTimeLineDaysPerFrames := Round(SecsPerDay * TimeZoneProperty.FrameRate);
      FrameCount := FTimeLineDaysPerFrames;
    end;

    FrameSelectEnabled := False;
    TrackSelectEnabled := False;
    TrackTrimEnabled := False;

    VideoGroupProperty.Count := 0;
    AudioGroupProperty.Count := 0;

    DataGroupProperty.Count  := GV_ChannelList.Count;
    for I := 0 to DataGroupProperty.Count - 1 do
    begin
      DataCompositions[I].Height := GV_SettingOption.ChannelTimelineHeight;
    end;
  end;

  FTimelineStartDate := Date;

  FTimeLineMin := 0;
  FTimeLineMax := 0;

  UpdateZoomPosition(FTimeLineZoomPosition);

  // Channel panel
  pnlChannelCaption.Height := wmtlPlaylist.TimeZoneProperty.Height;

  for I := 0 to GV_ChannelList.Count - 1 do
  begin
    Channel := GV_ChannelList[I];

    ChannelForm := TfrmTimelineChannel.Create(pnlChannelList, Channel^.ID);
    ChannelForm.Parent := pnlChannelList;
    ChannelForm.Align := alNone;
    ChannelForm.Height := GV_SettingOption.ChannelTimelineHeight;
    ChannelForm.Tag := Channel^.ID;
    ChannelForm.Show;

    FTimelineChannelList.Add(ChannelForm);

    with wmtlPlaylist do
      DataCompositions[I].Tag := Channel^.ID;
  end;
end;

procedure TfrmTimeline.AdjustTimelineChannel;
var
  I: Integer;
  Panel: TfrmTimelineChannel;
  PanelTop: Integer;
  L, T, W, H: Integer;
begin
  inherited;

  if (FTimelineChannelList = nil) then exit;
  
  if (FTimelineChannelList.Count <= 0) then exit;

//  PanelHeight := 72;//(FVideoGroup.ClientHeight + FVideoCompositionList.Count - 1) div FVideoCompositionList.Count;
  PanelTop := {pnlChannelCaption.Height} - wmtlPlaylist.DataVertScrollPosition;

  for I := 0 to FTimelineChannelList.Count - 1 do
  begin
    if (FTimelineChannelList[I] = nil) then Continue;

    Panel := FTimelineChannelList[I];
    L := 0;
    T := PanelTop;
    W := pnlChannelList.ClientWidth;
    H := Panel.Height;
    Panel.SetBounds(L, T, W, H);
    PanelTop := Panel.Top + Panel.Height - 1;
  end;
//  UpdateWindow(Handle);
end;

function TfrmTimeline.GetPositionByZoomType(AZoomType: TTimelineZoomTYpe): Integer;
var
  RatePerFrame: Word;
begin
  Result := 0;

  with wmtlPlaylist.TimeZoneProperty do
  begin
    case AZoomType of
      zt1Second: Result := Round(1 * FrameRate);
      zt2Seconds: Result := Round(2 * FrameRate);
      zt5Seconds: Result := Round(5 * FrameRate);
      zt10Seconds: Result := Round(10 * FrameRate);
      zt15Seconds: Result := Round(15 * FrameRate);
      zt30Seconds: Result := Round(30 * FrameRate);
      zt1Minute: Result := Round(SecsPerMin * FrameRate);
      zt2Minutes: Result := Round(2 * SecsPerMin * FrameRate);
      zt5Minutes: Result := Round(5 * SecsPerMin * FrameRate);
      zt10Minutes: Result := Round(10 * SecsPerMin * FrameRate);
      zt15Minutes: Result := Round(15 * SecsPerMin * FrameRate);
      zt30Minutes: Result := Round(30 * SecsPerMin * FrameRate);
      zt1Hour: Result := Round(SecsPerHour * FrameRate);
      zt2Hours: Result := Round(2 * SecsPerHour * FrameRate);
      zt6Hours: Result := Round(6 * SecsPerHour * FrameRate);
      zt12Hours: Result := Round(12 * SecsPerHour * FrameRate);
      zt1Day: Result := Round(SecsPerDay * FrameRate);
      ztFit: Result := Round(SecsPerDay * FrameRate) + 1;
    end;
  end;
end;

function TfrmTimeline.GetZoomTypeByPosition(APosition: Integer): TTimelineZoomType;
begin
  Result := ztNone;
  with wmtlPlaylist.TimeZoneProperty do
  begin
    if (APosition <= Round(1 * FrameRate)) then
      Result := zt1Second
    else if (APosition <= Round(2 * FrameRate)) then
      Result := zt2Seconds
    else if (APosition <= Round(5 * FrameRate)) then
      Result := zt5Seconds
    else if (APosition <= Round(10 * FrameRate)) then
      Result := zt10Seconds
    else if (APosition <= Round(15 * FrameRate)) then
      Result := zt15Seconds
    else if (APosition <= Round(30 * FrameRate)) then
      Result := zt30Seconds
    else if (APosition <= Round(SecsPerMin * FrameRate)) then
      Result := zt1Minute
    else if (APosition <= Round(2 * SecsPerMin * FrameRate)) then
      Result := zt2Minutes
    else if (APosition <= Round(5 * SecsPerMin * FrameRate)) then
      Result := zt5Minutes
    else if (APosition <= Round(10 * SecsPerMin * FrameRate)) then
      Result := zt10Minutes
    else if (APosition <= Round(15 * SecsPerMin * FrameRate)) then
      Result := zt15Minutes
    else if (APosition <= Round(30 * SecsPerMin * FrameRate)) then
      Result := zt30Minutes
    else if (APosition <= Round(SecsPerHour * FrameRate)) then
      Result := zt1Hour
    else if (APosition <= Round(2 * SecsPerHour * FrameRate)) then
      Result := zt2Hours
    else if (APosition <= Round(6 * SecsPerHour * FrameRate)) then
      Result := zt6Hours
    else if (APosition <= Round(12 * SecsPerHour * FrameRate)) then
      Result := zt12Hours
    else if (APosition <= Round(SecsPerDay * FrameRate)) then
      Result := zt1Day
    else if (APosition <= Round(SecsPerDay * FrameRate) + 1) then
      Result := ztFit;
  end;
end;

procedure TfrmTimeline.UpdateZoomPosition(APosition: Integer);
var
  SampleTime: Double;
  Frames: Integer;
begin
  if (FTimelineZoomType = ztFit) then
  begin
    wmtlPlaylist.ZoomToFit;
  end
  else
  begin
    with wmtlPlaylist.TimeZoneProperty do
    begin
      BeginUpdate;
      try
//      SampleTime := FrameToSampleTime(APosition, Round(FrameRate));
//      SampleTime := Round(APosition / FrameRate);

        SampleTime := Round(APosition / FrameRate);
        if (SampleTime < 1) then SampleTime := 1;

        Frames := TimecodeToFrame(SecondToTimeCode(SampleTime, FrameRate), FrameRate);

        if (SampleTime >= 1) and (SampleTime < 15) then
        begin
          FrameGap := 12;
          FrameStep := 10;
          FrameSkip := Frames div 2;
        end
        else if (SampleTime >= 15) and (SampleTime < SecsPerMin) then
        begin
          FrameGap := 6;
          FrameStep := 20;
          FrameSkip := Frames div 5;
        end
        else if (SampleTime >= SecsPerMin) and (SampleTime < SecsPerMin * 15) then
        begin
          FrameGap := 24;
          FrameStep := 5;
          FrameSkip := Frames;
        end
        else if (SampleTime >= SecsPerMin * 15) and (SampleTime < SecsPerMin * 30) then
        begin
          FrameGap := 12;
          FrameStep := 12;
          FrameSkip := Frames div 3;
        end
        else if (SampleTime >= SecsPerMin * 30) and (SampleTime < SecsPerHour) then
        begin
          FrameGap := 8;
          FrameStep := 36;
          FrameSkip := Frames div 6;
        end
        else if (SampleTime >= SecsPerHour) then
        begin
          FrameGap := 4;
          FrameStep := 36;
          FrameSkip := Frames div 6;
        end;

        RealtimeChangePlayListTimeLine;
      finally
        EndUpdate;
      end;
  //    WMTimeLine.ViewSplitter;
  //    WMTimeLine.ViewAreaRepaint;
    end;
  end;
end;

procedure TfrmTimeline.SetZoomPosition(Value: Integer);
var
  Pos: Integer;
begin
//  if (FZoomPosition <> Value) then
  begin
    FTimelineZoomPosition := Value;
//    wmtlPlaylist.ZoomBarProperty.Position := Value;
    wmtbTimelineZoom.Position := Value;

    FTimelineZoomType := GetZoomTypeByPosition(Value);
    UpdateZoomPosition(Value);
  end;
end;

procedure TfrmTimeline.wmtbTimelineZoomChange(Sender: TObject);
begin
  inherited;
  TimelineZoomPosition := wmtbTimelineZoom.Position;
end;

procedure TfrmTimeline.wmtlPlaylistDataGroupVertScrollEvent(Sender: TObject;
  Message: TWMScroll);
begin
  inherited;
  AdjustTimelineChannel;
end;

procedure TfrmTimeline.wmtlPlaylistMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
  Zoom: Integer;
  Pos: Integer;
begin
  inherited;

  if (ssCtrl in Shift) then
  begin
    with wmtlPlaylist.ZoomBarProperty do
    begin
      Zoom := Integer(FTimelineZoomType);
      if (WheelDelta > 0) then Inc(Zoom)
      else if (WheelDelta < 0) then Dec(Zoom);

      if (Zoom > Integer(High(TTimelineZoomType))) then Zoom := Integer(High(TTimelineZoomType))
      else if (Zoom < Integer(Low(TTimelineZoomType))) then Zoom := Integer(Low(TTimelineZoomType));

      FTimelineZoomType := TTimelineZoomType(Zoom);
      TimelineZoomPosition := GetPositionByZoomType(FTimelineZoomType);
    end;
  end
  else
  begin
    with wmtlPlaylist do
    begin
      Pos := FrameNumber;
      if (WheelDelta > 0) then Dec(Pos)
      else if (WheelDelta < 0) then Inc(Pos);

      if (Pos > MaxFrameNumber) then Pos := MaxFrameNumber
      else if (Pos < 0) then Pos := 0;

      FrameNumber := Pos;
    end;
  end;
  Handled := True;
end;

procedure TfrmTimeline.wmtlPlaylistTrackHintEvent(Sender: TObject; Track: TTrack;
  var HintStr: string);
var
  ProgItem: PCueSheetItem;
  Item, ParentItem: PCueSheetItem;
  StartTime, EndTime: TEventTime;
begin
  inherited;
{  if (Track.Data <> nil) then
  begin
    Item := Track.Data;

    case Item^.EventMode of
      EM_PROGRAM:
      begin
        HintStr := String(Item^.Title);
        exit;
      end;
      EM_MAIN:
      begin
        StartTime := Item^.StartTime;
        EndTime   := GetEventEndTime(Item^.StartTime, Item^.DurationTC);
      end;
      EM_JOIN:
      begin
        ParentItem := GetParentCueSheetItemByItem(Item);
        if (ParentItem <> nil) then
        begin
          StartTime := ParentItem^.StartTime;
          EndTime   := GetEventEndTime(StartTime, Item^.DurationTC);
        end
        else
          exit;
      end;
      EM_SUB:
      begin
        ParentItem := GetParentCueSheetItemByItem(Item);
        if (ParentItem <> nil) then
        begin
          if (Item^.StartMode = SM_SUBBEGIN) then
          begin
            StartTime := GetEventTimeSubBegin(ParentItem^.StartTime, Item^.StartTime.T);
            EndTime   := GetEventEndTime(StartTime, Item^.DurationTC);
          end
          else
          begin
            StartTime := GetEventTimeSubEnd(ParentItem^.StartTime, ParentItem^.DurationTC, Item^.StartTime.T);
            EndTime   := GetEventEndTime(StartTime, Item^.DurationTC);
          end;
        end
        else
          exit;
      end;
      else
        exit;
    end;

    HintStr := Format('%s'#13#10'%s'#13#10'Start: %s'#13#10'End: %s'#13#10'Duration: %s',
                      [String(Item^.Title),
                       String(Item^.SubTitle),
                       TimecodeToString(StartTime.T),
                       TimecodeToString(EndTime.T),
                       TimecodeToString(Item^.DurationTC)]);

    ProgItem := GetProgramItemByItem(Item);
    if (ProgItem <> nil) then
      HintStr := String(ProgItem^.Title) + #13#10 + HintStr;
  end;  }
end;

procedure TfrmTimeline.TimelineGotoCurrent;
begin
  FTimelineSpace := GV_SettingOption.TimelineSpace;
//  PostMessage(Handle, WM_UPDATE_CHANNEL_TIME, 0, 0);
end;

procedure TfrmTimeline.TimelineMoveLeft;
begin
  Inc(FTimelineSpace, GV_SettingOption.TimelineSpaceInterval);
//  if (FTimelineSpace >= wmtlPlaylist.ClientWidth) then FTimelineSpace := wmtlPlaylist.ClientWidth - 19;

//  PostMessage(Handle, WM_UPDATE_CHANNEL_TIME, 0, 0);
end;

procedure TfrmTimeline.TimelineMoveRight;
begin
  Dec(FTimelineSpace, GV_SettingOption.TimelineSpaceInterval);
//  if (FTimelineSpace < 0) then FTimelineSpace := 0;

//  PostMessage(Handle, WM_UPDATE_CHANNEL_TIME, 0, 0);
end;

procedure TfrmTimeline.TimelineZoomIn;
var
  Zoom: Integer;
begin
  inherited;
  with wmtlPlayList.ZoomBarProperty do
  begin
    Zoom := Integer(FTimelineZoomType);
    Dec(Zoom);

    if (Zoom < Integer(Low(TTimelineZoomType)) + 1) then Zoom := Integer(Low(TTimelineZoomType)) + 1;

    FTimelineZoomType := TTimelineZoomType(Zoom);
    TimelineZoomPosition := GetPositionByZoomType(FTimelineZoomType);
  end;
end;

procedure TfrmTimeline.TimelineZoomOut;
var
  Zoom: Integer;
begin
  with wmtlPlayList.ZoomBarProperty do
  begin
    Zoom := Integer(FTimelineZoomType);
    Inc(Zoom);

    if (Zoom > Integer(High(TTimelineZoomType))) then Zoom := Integer(High(TTimelineZoomType));

    FTimelineZoomType := TTimelineZoomType(Zoom);
    TimelineZoomPosition := GetPositionByZoomType(FTimelineZoomType);
  end;
end;

function TfrmTimeline.GetTimelinChannelByChannelID(AChannelID: Word): TfrmTimelineChannel;
var
  I: Integer;
  ChannelForm: TfrmTimelineChannel;
begin
  Result := nil;

  for I := 0 to FTimelineChannelList.Count - 1 do
  begin
    ChannelForm := FTimelineChannelList[I];
    if (ChannelForm <> nil) and (ChannelForm.Tag = AChannelID) then
    begin
      Result := ChannelForm;
      break;
    end;
  end;
end;

function TfrmTimeline.GetTimelineCompIndexByChannelID(AChannelID: Word): Integer;
var
  I: Integer;
begin
  Result := -1;

  with wmtlPlaylist do
    for I := 0 to DataGroupProperty.Count - 1 do
      if (DataCompositions[I].Tag = AChannelID) then
      begin
        Result := I;
        break;
      end;
end;

procedure TfrmTimeline.DisplayChannelTime(AChannelID: Word);
var
  ChannelForm: TfrmTimelineChannel;
begin
  ChannelForm := GetTimelinChannelByChannelID(AChannelID);
  if (ChannelForm <> nil) then
  begin

  end;
end;

procedure TfrmTimeline.SetChannelOnAir(AChannelID: Word; AOnAir: Boolean);
var
  ChannelForm: TfrmTimelineChannel;
begin
  ChannelForm := GetTimelinChannelByChannelID(AChannelID);
  if (ChannelForm <> nil) then
  begin
    ChannelForm.SetChannelOnAir(AOnAir);
  end;
end;

procedure TfrmTimeline.SetChannelTime(AChannelID: Word; APlayedTime, ARemainingTime: String);
var
  ChannelForm: TfrmTimelineChannel;
begin
  ChannelForm := GetTimelinChannelByChannelID(AChannelID);
  if (ChannelForm <> nil) then
  begin
    ChannelForm.SetChannelTime(APlayedTime, ARemainingTime);
  end;
end;

procedure TfrmTimeline.PopulatePlayListTimeLine(AItem: PCuesheetItem);
var
  I: Integer;
  CompIndex: Integer;
  Track: TTrack;
begin
  if (AItem = nil) then exit;

  if (AItem^.EventMode <> EM_MAIN) then exit;
  if (AItem^.EventStatus.State = esSkipped) then exit;

  CompIndex := GetTimelineCompIndexByChannelID(AItem^.EventID.ChannelID);
  if (CompIndex < 0) then exit;

  with wmtlPlaylist do
  begin
    BeginUpdateCompositions;
    try
      Track := DataCompositions[CompIndex].Tracks.GetTrackByData(AItem);
      if (Track = nil) then
      begin
        Track := DataCompositions[CompIndex].Tracks.Add;
        Track.Data := AItem;
      end;

      Track.InPoint  := TimecodeToFrame(AItem^.StartTime.T) + Trunc(AItem^.StartTime.D - FTimelineStartDate) * FTimeLineDaysPerFrames; //TimecodeToFrame(AItem^.StartTime.T);// + Trunc(AItem^.StartTime.D - FTimelineStartDate) * FTimeLineDaysPerFrames - 1;
      Track.OutPoint := Track.InPoint + TimecodeToFrame(AItem^.DurationTC);
      Track.Duration := Track.OutPoint - Track.InPoint;

      Track.Color        := GetProgramTypeColorByCode(AItem^.ProgramType);
      Track.ColorCaption := GetProgramTypeColorByCode(AItem^.ProgramType);
    //          Track.ColorSelected  := Track.Color;
    //          Track.ColorHighLight := $000E0607;
    //          Track.ColorShadow    := $000E0607;

      Track.Caption := String(AItem^.Title);

      if (Track.InPoint < FTimeLineMin) then FTimeLineMin := Track.InPoint;
      if (Track.OutPoint > FTimeLineMax) then FTimeLineMax := Track.OutPoint;
    finally
      EndUpdateCompositions;
    end;
  end;
end;

procedure TfrmTimeline.PopulateEventStatusPlayListTimeLine(AIndex: Integer; AItem: PCueSheetItem);
var
  Item: PCueSheetItem;
  CompIndex: Integer;
  Track: TTrack;

  BackColor, FontColor: TColor;
begin
{  Item := GetCueSheetItemByIndex(AIndex);
  if (Item <> nil) then
  begin
    with wmtlPlaylist do
    begin
      BeginUpdateCompositions;
      try
        CompIndex := 0;
        case Item^.EventMode of
          EM_PROGRAM: CompIndex := 0;
          EM_MAIN: CompIndex := 1;
          EM_JOIN,
          EM_SUB: CompIndex := GetChildCueSheetIndexByItem(Item) + 1;
          else
            exit;
        end;

        if (CompIndex >= 0) and (CompIndex < DataGroupProperty.Count) then
        begin
          Track := DataCompositions[CompIndex].Tracks.GetTrackByData(Item);
          if (Track <> nil) then
          begin
            if (CueSheetNext <> nil) and (Item^.GroupNo = CueSheetNext^.GroupNo) and
               ((not FChannelOnAir) or ((CueSheetNext^.EventStatus.State in [esLoaded]) and (Item^.EventStatus.State in [esLoaded]))) then
            begin
              BackColor := COLOR_BK_EVENTSTATUS_NEXT;
              FontColor := COLOR_TX_EVENTSTATUS_NEXT;
            end
            else
            begin
              case Item^.EventStatus.State of
                esCueing..esPreroll:
                begin
                  BackColor := COLOR_BK_EVENTSTATUS_CUED;
                  FontColor := COLOR_TX_EVENTSTATUS_CUED;
                end;
                esOnAir:
                begin
                  BackColor := COLOR_BK_EVENTSTATUS_ONAIR;
                  FontColor := COLOR_TX_EVENTSTATUS_ONAIR;
                end;
                esSkipped,
                esFinish..esDone:
                begin
                  BackColor := COLOR_BK_EVENTSTATUS_DONE;
                  FontColor := COLOR_TX_EVENTSTATUS_DONE;
                end;
                esError:
                begin
                  BackColor := COLOR_BK_EVENTSTATUS_ERROR;
                  FontColor := COLOR_TX_EVENTSTATUS_ERROR;
                end;
                else
                begin
                  if (CueSheetTarget <> nil) and (Item^.GroupNo = CueSheetTarget^.GroupNo) then
                  begin
                    BackColor := COLOR_BK_EVENTSTATUS_TARGET;
                    FontColor := COLOR_TX_EVENTSTATUS_TARGET;
                  end
                  else
                  begin
                    BackColor := COLOR_BK_EVENTSTATUS_NORMAL;
                    FontColor := COLOR_TX_EVENTSTATUS_NORMAL;
                  end;
                end;
              end;
            end;

            Track.Color        := BackColor;
            Track.ColorCaption := FontColor;
          end;
        end;
      finally
        EndUpdateCompositions;
      end;
    end;
  end; }
end;

procedure TfrmTimeline.UpdateChangeDatePlayListTimeLine(ADays: Integer);
var
  I, J: Integer;
  Track: TTrack;
  Duration: Integer;
begin
  inherited;

  with wmtlPlaylist do
  begin
    BeginUpdateCompositions;
    try
      for I := 0 to DataGroupProperty.Count - 1 do
      begin
        for J := 0 to DataCompositions[I].Tracks.Count - 1 do
        begin
          Track := DataCompositions[I].Tracks[J];
          if (Track <> nil) then
          begin
            Duration := Track.Duration;

            Track.InPoint  := Track.InPoint - (ADays * FTimeLineDaysPerFrames);
            Track.OutPoint := Track.InPoint + Duration;
          end;
        end;
      end;
    finally
      EndUpdateCompositions;
    end;
  end;
end;

procedure TfrmTimeline.RealtimeChangePlayListTimeLine;
var
  I: Integer;
  F: Integer;

  Days: Integer;

  FirstItem: PCueSheetItem;
  LastMainItem: PCueSheetItem;
  LastEndTime: TEventTime;
  SideFrames: Integer;
begin
  inherited;

  if (FTimelineStartDate <> Date) then
  begin
    Days := Trunc(Date - FTimelineStartDate);
    FTimelineStartDate := Date;

    UpdateChangeDatePlayListTimeLine(Days);
  end;

//  wmtlPlaylist.TimeZoneProperty.BeginUpdate;

//  FTimelineStartDate := IncDay(Date, -1);
  with wmtlPlaylist.TimeZoneProperty do
    SideFrames := Round(FTimelineSpace / (FrameGap / FrameSkip)) - 1;

  with wmtlPlaylist.TimeZoneProperty do
  begin
    BeginUpdate;
    try
//    TimeZoneProperty.FrameStart := FTimeLineMin - SideFrames;
//    TimeZoneProperty.FrameCount := FTimeLineMax - FTimeLineMin + (SideFrames * 2);


//    FrameStart :=  Trunc(Trunc((Round(SecondOfTheDay(Now) * FrameRate) - SideFrames) / FrameRate) * FrameRate);
//    wmtlPlaylist.FrameNumber := Round((SecondOfTheDay(Now) * FrameRate));

    F := SampleTimeToFrame(SecondOfTheDay(Now), FrameRate);
    FrameStart :=  F - SideFrames;
    wmtlPlaylist.FrameNumber := F;




//    SetScrollPos(wmtlPlaylist.HorzScrollBar.Handle, SB_HORZ, 0, True);

//    SetScrollPos(wmtlPlaylist.HorzScrollBar.Handle, SB_HORZ, wmtlPlaylist.HorzScrollMin, True);
    SetScrollPos(wmtlPlaylist.HorzScrollBar.Handle, SB_HORZ, 0, True);
    finally
      EndUpdate;
    end;
  end;
//  wmtlPlaylist.TimeZoneProperty.RailBarVisible := True;
//  wmtlPlaylist.TimeZoneProperty.EndUpdate;
//  wmtlPlaylist.DataGroup.Visible := True;

//  wmtlPlaylist.MarkIn := FTimeLineMin + 1000;
//  wmtlPlaylist.MarkOut := FTimeLineMax - 1000;

//  UpdateZoomPosition(FTimelineZoomPosition);
end;

procedure TfrmTimeline.DeletePlayListTimeLine(AItem: PCueSheetItem);
var
  I: Integer;
  CompIndex: Integer;
  Track: TTrack;
begin
  if (AItem = nil) then exit;

  if (AItem^.EventMode <> EM_MAIN) then exit;

  CompIndex := GetTimelineCompIndexByChannelID(AItem^.EventID.ChannelID);
  if (CompIndex < 0) then exit;

  with wmtlPlaylist do
  begin
    Track := DataCompositions[CompIndex].Tracks.GetTrackByData(AItem);

    if (Track <> nil) then
    begin
      FreeAndNil(Track);
    end;
  end;
end;

procedure TfrmTimeline.SetEventStatus(AEventID: TEventID; AStatus: TEventStatus; AIsCurrEvent: Boolean = False);
var
  CItem: PCueSheetItem;
  Index: Integer;
  RRow: Integer;
begin
end;

procedure TfrmTimeline.SetEventOverall(ADCSIP: String; ADeviceHandle: TDeviceHandle; AOverall: TEventOverall);
var
  Item: PCueSheetItem;
  Source: PSource;
  SourceHandles: TSourceHandleList;
  I: Integer;
begin
end;

procedure TfrmTimeline.ClearPlayListTimeLine(AChannelID: Word);
var
  CompIndex: Integer;
begin
  inherited;

  CompIndex := GetTimelineCompIndexByChannelID(AChannelID);
  if (CompIndex < 0) then exit;

  with wmtlPlaylist do
  begin
    BeginUpdateCompositions;
    try
      DataCompositions[CompIndex].Tracks.Clear;
    finally
      EndUpdateCompositions;
    end;
  end;
end;

procedure TfrmTimeline.PanelWndProc(var Message: TMessage);
begin
  with Message do
  begin
    case Msg of
      WM_SIZE: AdjustTimelineChannel;
    end;
    Result := CallWindowProc(FDefPanelProc, FPanelHandle, Msg, WParam, LParam);
  end;
end;

procedure TfrmTimeline.FormCreate(Sender: TObject);
begin
  inherited;
  Initialize;

end;

procedure TfrmTimeline.FormDestroy(Sender: TObject);
begin
  inherited;
  Finalize;
end;

procedure TfrmTimeline.FormResize(Sender: TObject);
var
  Zoom: Integer;
begin
  inherited;
  with wmtlPlayList.ZoomBarProperty do
  begin
    TimelineZoomPosition := GetPositionByZoomType(FTimelineZoomType);

{    Zoom := Integer(FTimelineZoomType);
    Inc(Zoom);

    if (Zoom > Integer(High(TTimelineZoomType))) then Zoom := Integer(High(TTimelineZoomType));

    FTimelineZoomType := TTimelineZoomType(Zoom);
    TimelineZoomPosition := GetPositionByZoomType(FTimelineZoomType); }
  end;
end;

procedure TfrmTimeline.FormShow(Sender: TObject);
begin
  inherited;
  FPanelInstance := MakeObjectInstance(PanelWndProc);

  FPanelHandle := pnlChannel.Handle;
  FDefPanelProc := Pointer(GetWindowLong(FPanelHandle, GWL_WNDPROC));
  SetWindowLong(FPanelHandle, GWL_WNDPROC, LongInt(FPanelInstance));

  AdjustTimelineChannel;
end;

{ TTimelineTimerThread }

constructor TTimelineTimerThread.Create(ATimelineForm: TfrmTimeline);
begin
  FTimelineForm := ATimelineForm;

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TTimelineTimerThread.Destroy;
begin
  inherited Destroy;
end;

procedure TTimelineTimerThread.DoCueSheetCheck;
var
  NextStartTime: TDateTime;

  SaveCurr: PCueSheetItem;
  CurrItem: PCueSheetItem;
  CurrIndex: Integer;
  InputIndex: Integer;
begin
{  with FTimelineForm do
  begin
    if (not FChannelOnAir) then exit;

    // 다음 이벤트가 수동모드이고 남은 시작시각이 AutoIncreaseDurationBefore 보다 큰 경우는 대기
    if (CueSheetNext <> nil) and
       (CueSheetNext^.EventMode = EM_MAIN) and
       (CueSheetNext^.StartMode = SM_MANUAL) and
       (CueSheetNext^.EventStatus.State <= esCued) then
    begin
      NextStartTime := EventTimeToDateTime(CueSheetNext^.StartTime);
      if (CompareDateTime(NextStartTime, Now) > 0) then
        exit;
    end;

    if (CueSheetCurr <> nil) then
      CurrIndex := GetCueSheetIndexByItem(CueSheetCurr)
    else
      CurrIndex := 0;

    SaveCurr := CueSheetCurr;
    CurrItem := GetMainItemByInRangeTime(CurrIndex, Now);
    if (SaveCurr <> CurrItem) then
    begin
      CueSheetCurr := CurrItem;
//      InputIndex := GetNextOnAirMainIndexByItem(CueSheetCurr);
//      OnAirInputEvents(InputIndex, 1);
    end;

    if (CueSheetCurr <> nil) then
      CueSheetNext := GetNextMainItemByItem(CueSheetCurr)
    else if (CueSheetNext = nil) then
      CueSheetNext := GetStartOnAirMainItem;
  end;  }
end;

procedure TTimelineTimerThread.Execute;
var
  WaitList: array[0..1] of THandle;
begin
  WaitList[0] := GV_TimerExecuteEvent;
  WaitList[1] := GV_TimerCancelEvent;
  while not Terminated do
  begin
    if (WaitForMultipleObjects(2, @WaitList, False, INFINITE) <> WAIT_OBJECT_0) then
      break; // Terminate thread when GV_TimerCancelEvent is signaled

    DoCueSheetCheck;

    PostMessage(FTimelineForm.Handle, WM_UPDATE_CHANNEL_TIME, 0, 0);

{    if (GV_SettingOption.AutoLoadCuesheet) then
    begin
      Inc(FTimelineForm.FAutoLoadIntervalTime);
      if (FTimelineForm.FAutoLoadIntervalTime > (TimecodeToMilliSec(GV_SettingOption.AutoLoadCuesheetInterval) div 1000)) then
        FTimelineForm.FAutoLoadThread.AutoLoad;
    end;

    if (GV_SettingOption.AutoEjectCuesheet) then
    begin
      Inc(FTimelineForm.FAutoEjectIntervalTime);
      if (FTimelineForm.FAutoEjectIntervalTime > (TimecodeToMilliSec(GV_SettingOption.AutoEjectCuesheetInterval) div 1000)) then
        FTimelineForm.FAutoEjectThread.AutoEject;
    end;

    Inc(FTimelineForm.FMediaCheckIntervalTime);
    if (FTimelineForm.FMediaCheckIntervalTime > (TimecodeToMilliSec(GV_SettingOption.MediaCheckInterval) div 1000)) then
      FTimelineForm.FMediaCheckThread.MediaCheck; }
  end;
end;

end.
