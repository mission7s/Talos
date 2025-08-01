unit UnitPlaylist;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitWorkForm, AdvUtil, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, AdvCGrid, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.StdCtrls, System.Generics.Collections, 
  AdvOfficePager, AdvSplitter,
  WMTools, WMControls, WMTimeLine, {LibXmlParserU, }Xml.VerySimple,
  UnitCommons, UnitDCSDLL, UnitConsts, Vcl.ComCtrls;

type
  TTimelineTimerThread = class;

  TfrmPlaylist = class(TfrmWork)
    acgPlaylist: TAdvColumnGrid;
    AdvSplitter1: TAdvSplitter;
    lblChannel: TLabel;
    Label2: TLabel;
    lblPlayedTime: TLabel;
    Label3: TLabel;
    lblRemainingTime: TLabel;
    Label5: TLabel;
    lblNextStart: TLabel;
    Label1: TLabel;
    lblPlayingInfo: TLabel;
    Label6: TLabel;
    lblNextInfo: TLabel;
    lblOnAirFlag: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acgPlaylistClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure acgPlaylistDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure acgPlaylistGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure acgPlaylistGetCellBorder(Sender: TObject; ARow, ACol: Integer;
      APen: TPen; var Borders: TCellBorders);
    procedure acgPlaylistGetCellBorderProp(Sender: TObject; ARow, ACol: Integer;
      LeftPen, TopPen, RightPen, BottomPen: TPen);
    procedure acgPlaylistGetDisplText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure acgPlaylistBeforeContractNode(Sender: TObject; ARow,
      ARowReal: Integer; var Allow: Boolean);
    procedure acgPlaylistBeforeExpandNode(Sender: TObject; ARow,
      ARowReal: Integer; var Allow: Boolean);
  private
    { Private declarations }
    FChannelID: Word;
    FChannelOnAir: Boolean;
    FCueSheetList: TCueSheetList;

    FCueSheetCurr: PCueSheetItem;
    FCueSheetNext: PCueSheetItem;
    FCueSheetTarget: PCueSheetItem;

    FCueSheetCurrEventID: TEventID;
    FCueSheetNextEventID: TEventID;
    FCueSheetTargetEventID: TEventID;

    FPlayedTimeStr: String;
    FRemainingTimeStr: String;
    FNextStartTimeStr: String;

    FErrorDisplayEnabled: Boolean;

    FTimerThread: TTimelineTimerThread;

    function GetCueSheetItemByIndex(AIndex: Integer): PCueSheetItem;
    function GetCueSheetItemByID(AEventID: TEventID): PCueSheetItem;
    function GetCueSheetIndexByItem(AItem: PCueSheetItem): Integer;

    // 큐시트의 정보 구함(Title/Subtitle/MediaID)
    function GetCueSheetInfoByItem(AItem: PCueSheetItem): String;

    function GetParentCueSheetItemByIndex(AIndex: Integer): PCueSheetItem;
    function GetParentCueSheetItemByItem(AItem: PCueSheetItem): PCueSheetItem;

    // Program 이벤트를 구함
    function GetProgramItemByIndex(AIndex: Integer): PCueSheetItem;
    function GetProgramItemByItem(AItem: PCueSheetItem): PCueSheetItem;

    // Program의 첫번째 Main 이벤트를 구함
    function GetProgramMainItemByIndex(AIndex: Integer): PCueSheetItem;
    function GetProgramMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;

    // Program의 자식 이벤트 개수를 구함
    function GetProgramChildCountByItem(AItem: PCueSheetItem): Integer;

    // Program의 전체 길이를 구함
    function GetProgramDurationByItem(AItem: PCueSheetItem): TTimecode;

    procedure SetCueSheetCurr(AValue: PCueSheetItem);
    procedure SetCueSheetNext(AValue: PCueSheetItem);
    procedure SetCueSheetTarget(AValue: PCueSheetItem);

    procedure Initialize;
    procedure Finalize;

    procedure InitializePlayListGrid;

    procedure DisplayPlayListGrid(AIndex: Integer; AItem: PCueSheetItem); overload;

    procedure DeletePlayListGridMain(AIndex: Integer);

    procedure PopulatePlayListGrid(AIndex: Integer);
    procedure PopulateEventStatusPlayListGrid(AIndex: Integer; AItem: PCueSheetItem);
    procedure PopulateMediaCheckPlayListGrid(AIndex: Integer; AItem: PCueSheetItem);

    procedure ErrorDisplayPlayListGrid;

    procedure SelectRowPlayListGrid(AIndex: Integer);

    procedure ClearCueSheetList;
    procedure ClearPlayListGrid;

    procedure CueSheetListQuickSort(L, R: Integer; ACueSheetList: TCueSheetList);

    procedure SetChannelOnAir(AOnAir: Boolean);
  protected
//    procedure WndProc(var Message: TMessage); override;

    procedure WMUpdateChannelTime(var Message: TMessage); message WM_UPDATE_CHANNEL_TIME;
    procedure WMUpdateCurrEvent(var Message: TMessage); message WM_UPDATE_CURR_EVENT;
    procedure WMUpdateNextEvent(var Message: TMessage); message WM_UPDATE_NEXT_EVENT;
    procedure WMUpdateTargetEvent(var Message: TMessage); message WM_UPDATE_TARGET_EVENT;

    procedure WMUpdateEventStatus(var Message: TMessage); message WM_UPDATE_EVENT_STATUS;

    procedure WMUpdateErrorDisplay(var Message: TMessage); message WM_UPDATE_ERROR_DISPLAY;

    procedure WMUpdateMediaCheck(var Message: TMessage); message WM_UPDATE_MEDIA_CHECK;

    procedure WMBeginUpdate(var Message: TMessage); message WM_BEGIN_UPDATE;
    procedure WMEndUpdate(var Message: TMessage); message WM_END_UPDATE;
    procedure WMSetOnAir(var Message: TMessage); message WM_SET_ONAIR;
    procedure WMInsertCueWheet(var Message: TMessage); message WM_INSERT_CUESHEET;
    procedure WMUpdateCueWheet(var Message: TMessage); message WM_UPDATE_CUESHEET;
    procedure WMDeleteCueWheet(var Message: TMessage); message WM_DELETE_CUESHEET;
    procedure WMClearCueWheet(var Message: TMessage); message WM_CLEAR_CUESHEET;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AChannelID: Word; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer); overload;

    function MCCBeginUpdate: Integer;
    function MCCEndUpdate: Integer;

    function MCCSetOnAir(AIsOnAir: Boolean): Integer;
    function MCCSetEventStatus(AEventID: TEventID; AStatus: TEventStatus): Integer;
    function MCCSetMediaStatus(AEventID: TEventID; AStatus: TMediaStatus): Integer;

    function MCCInputCueSheet(AIndex: Integer; ACueSheetItem: TCueSheetItem): Integer;
    function MCCDeleteCueSheet(AEventID: TEventID): Integer;
    function MCCClearCueSheet: Integer;

    function MCCSetCueSheetCurr(AEventID: TEventID): Integer;
    function MCCSetCueSheetNext(AEventID: TEventID): Integer;
    function MCCSetCueSheetTarget(AEventID: TEventID): Integer;

    procedure NewPlayList;

    procedure GotoCurrentEvent;

    procedure SetEventOverall(ADCSIP: String; ADeviceHandle: TDeviceHandle; AOverall: TEventOverall);

    property ChannelID: Word read FChannelID;
    property ChannelOnAir: Boolean read FChannelOnAir;

    property CueSheetCurr: PCueSheetItem read FCueSheetCurr write SetCueSheetCurr;
    property CueSheetNext: PCueSheetItem read FCueSheetNext write SetCueSheetNext;
    property CueSheetTarget: PCueSheetItem read FCueSheetTarget write SetCueSheetTarget;
  end;

  TTimelineTimerThread = class(TThread)
  private
    FPlaylistForm: TfrmPlaylist;
  protected
    procedure Execute; override;
  public
    constructor Create(APlaylistForm: TfrmPlaylist);
    destructor Destroy; override;
  end;

var
  frmPlaylist: TfrmPlaylist;

implementation

uses UnitMCC, System.DateUtils, System.Math, UnitTimeline;

{$R *.dfm}

procedure TfrmPlaylist.WMUpdateChannelTime(var Message: TMessage);
var
  ChannelID: Word;
  ChannelEventCount: Integer;

  Index, ParentIndex: Integer;

  IsOnAir: Boolean;

  Item, ParentItem: PCueSheetItem;

  EventID: TEventID;

  NextStartTime: TDateTime;
  NextIndex: Integer;
  CurrIndex: Integer;
  TargetIndex: Integer;

  CurrentTime: TDateTime;
  PlayedTime: TDateTime;
  RemainTime: TDateTime;
  RemainTargetTime: TDateTime;

  PlayedTimeString: String;
  RemainTimeString: String;
  NextStartTimeString: String;
  RemainTargetTimeString: String;

  SaveStartTime: TEventTime;
begin
  // Next Start, Duration time
  if (CueSheetNext <> nil) then
  begin
    NextStartTimeString := TimecodeToString(CueSheetNext^.StartTime.T);
//        NextDurationString  := TimecodeToString(CueSheetNext^.DurationTC);
  end
  else
  begin
    NextStartTimeString := IDLE_TIMECODE;
//        NextDurationString  := IDLE_TIMECODE;
  end;

  lblNextStart.Caption    := NextStartTimeString;
//      lblNextDuration.Caption := NextDurationString;

  // Played, Remaining time
  CurrentTime := Now;

  if (CueSheetCurr <> nil) then
  begin
    PlayedTime := CurrentTime - EventTimeToDateTime(CueSheetCurr^.StartTime);
    RemainTime := IncSecond(EventTimeToDateTime(GetEventEndTime(CueSheetCurr^.StartTime, CueSheetCurr^.DurationTC)) - CurrentTime);

    PlayedTimeString := FormatDateTime('hh:nn:ss', PlayedTime);
    RemainTimeString := FormatDateTime('hh:nn:ss', RemainTime);
  end
  else
  begin
    if (CueSheetNext <> nil) then
    begin
      RemainTime := IncSecond(EventTimeToDateTime(CueSheetNext^.StartTime) - CurrentTime);
      RemainTimeString := FormatDateTime('hh:nn:ss', RemainTime);
    end
    else
    begin
      RemainTimeString := IDLE_TIME;
    end;
    PlayedTimeString := IDLE_TIME;
  end;

  lblPlayedTime.Caption    := PlayedTimeString;
  lblRemainingTime.Caption := RemainTimeString;

  // Target event
  if (CueSheetTarget <> nil) then
  begin
//        lblTargetEventNo.Caption := Format('%d', [CueSheetTarget^.DisplayNo + 1]);
    RemainTargetTime := IncSecond(EventTimeToDateTime(CueSheetTarget^.StartTime) - CurrentTime);
    RemainTargetTimeString := FormatDateTime('hh:nn:ss', RemainTargetTime)
  end
  else
  begin
//        lblTargetEventNo.Caption := '';
    RemainTargetTimeString := IDLE_TIME;
  end;

//      lblRemainingTargetTime.Caption := RemainTargetTimeString;

  frmTimeline.SetChannelTime(Self.ChannelID, PlayedTimeString, RemainTimeString);
end;

procedure TfrmPlaylist.WMUpdateCurrEvent(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
  R, T: Integer;
begin
  Index := Message.WParam;
  Item  := PCueSheetItem(Message.LParam);
  if (Index >= 0) then
  begin
    lblPlayingInfo.Caption := GetCueSheetInfoByItem(Item);
    if (GV_SettingOption.OnAirEventHighlight) then
    begin
      with acgPlaylist do
      begin
        R := DisplRowIndex(Index + CNT_CUESHEET_HEADER);
//            if (R >= FixedRows) or (R <= RowCount - 1) then
        begin
          T := R - GV_SettingOption.OnAirEventFixedRow;
          if (T >= FixedRows) then
            TopRow := T
          else
            TopRow := FixedRows;

          MouseActions.DisjunctRowSelect := False;
          ClearRowSelect;
          MouseActions.DisjunctRowSelect := True;
          SelectRows(R, 1);
          Row := R;
        end;
      end;
    end;
  end;
end;

procedure TfrmPlaylist.WMUpdateNextEvent(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
  R, T: Integer;
begin
  Index := Message.WParam;
  Item  := PCueSheetItem(Message.LParam);

  if (CueSheetCurr <> nil) then
    Index := GetCueSheetIndexByItem(CueSheetCurr)
  else
    Index := GetCueSheetIndexByItem(Item);

  lblNextInfo.Caption := GetCueSheetInfoByItem(Item);

  if (Index >= 0) then
  begin
    if (GV_SettingOption.OnAirEventHighlight) then
    begin
      with acgPlaylist do
      begin
        R := DisplRowIndex(Index + CNT_CUESHEET_HEADER);
//            if (R >= FixedRows) or (R <= RowCount - 1) then
        begin
          T := R - GV_SettingOption.OnAirEventFixedRow;
          if (T >= FixedRows) then
            TopRow := T
          else
            TopRow := FixedRows;

          MouseActions.DisjunctRowSelect := False;
          ClearRowSelect;
          MouseActions.DisjunctRowSelect := True;
          SelectRows(R, 1);
          Row := R;
        end;
      end;
    end;
  end;
end;

procedure TfrmPlaylist.WMUpdateTargetEvent(var Message: TMessage);
begin
  with acgPlaylist do
    Repaint;
end;

procedure TfrmPlaylist.WMUpdateEventStatus(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item := PCueSheetItem(Message.LParam);

  PopulateEventStatusPlayListGrid(Index, Item);

//  PopulateEventStatusPlayListTimeLine(Index, Item);
end;

procedure TfrmPlaylist.WMUpdateErrorDisplay(var Message: TMessage);
begin
  FErrorDisplayEnabled := not FErrorDisplayEnabled;

  ErrorDisplayPlayListGrid;
//  ErrorDisplayPlayListTimeLine;
end;

procedure TfrmPlaylist.WMUpdateMediaCheck(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item := PCueSheetItem(Message.LParam);

  PopulateMediaCheckPlayListGrid(Index, Item);
end;

procedure TfrmPlaylist.WMBeginUpdate(var Message: TMessage);
begin
  if (not (acgPlaylist.IsUpdating)) then
    acgPlaylist.BeginUpdate;
end;

procedure TfrmPlaylist.WMEndUpdate(var Message: TMessage);
begin
  if (acgPlaylist.IsUpdating) then
    acgPlaylist.EndUpdate;
end;

procedure TfrmPlaylist.WMSetOnAir(var Message: TMessage);
var
  ChannelID: Word;
  IsOnAir: Boolean;
begin
  ChannelID := Message.WParam;
  IsOnAir := Boolean(Message.LParam);

  SetChannelOnAir(IsOnAir);
end;

procedure TfrmPlaylist.WMInsertCueWheet(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item := PCueSheetItem(Message.LParam);

  DisplayPlayListGrid(Index, Item);
  PopulatePlayListGrid(Index);
end;

procedure TfrmPlaylist.WMUpdateCueWheet(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item := PCueSheetItem(Message.LParam);

  PopulatePlayListGrid(Index);
end;

procedure TfrmPlaylist.WMDeleteCueWheet(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item := PCueSheetItem(Message.LParam);

  DeletePlayListGridMain(Index);
end;

procedure TfrmPlaylist.WMClearCueWheet(var Message: TMessage);
var
  ChannelID: Word;
begin
  ChannelID := Message.WParam;

  ClearPlayListGrid;
end;

{procedure TfrmPlaylist.WndProc(var Message: TMessage);
var
  ChannelID: Word;
  ChannelEventCount: Integer;

  Index, ParentIndex: Integer;

  IsOnAir: Boolean;

  Item, ParentItem: PCueSheetItem;

  EventID: TEventID;

  NextStartTime: TDateTime;
  NextIndex: Integer;
  CurrIndex: Integer;
  TargetIndex: Integer;

  CurrentTime: TDateTime;
  PlayedTime: TDateTime;
  RemainTime: TDateTime;
  RemainTargetTime: TDateTime;

  PlayedTimeString: String;
  RemainTimeString: String;
  NextStartTimeString: String;
  RemainTargetTimeString: String;

  SaveStartTime: TEventTime;

  EventStatus: TEventStatus;
  MediaStatus: TMediaStatus;

  C, R, T: Integer;
begin
  inherited;
  case Message.Msg of
    WM_UPDATE_CHANNEL_TIME:
    begin
      // Next Start, Duration time
      if (CueSheetNext <> nil) then
      begin
        NextStartTimeString := TimecodeToString(CueSheetNext^.StartTime.T);
//        NextDurationString  := TimecodeToString(CueSheetNext^.DurationTC);
      end
      else
      begin
        NextStartTimeString := IDLE_TIMECODE;
//        NextDurationString  := IDLE_TIMECODE;
      end;

      lblNextStart.Caption    := NextStartTimeString;
//      lblNextDuration.Caption := NextDurationString;

      // Played, Remaining time
      CurrentTime := Now;

      if (CueSheetCurr <> nil) then
      begin
        PlayedTime := CurrentTime - EventTimeToDateTime(CueSheetCurr^.StartTime);
        RemainTime := IncSecond(EventTimeToDateTime(GetEventEndTime(CueSheetCurr^.StartTime, CueSheetCurr^.DurationTC)) - CurrentTime);

        PlayedTimeString := FormatDateTime('hh:nn:ss', PlayedTime);
        RemainTimeString := FormatDateTime('hh:nn:ss', RemainTime);
      end
      else
      begin
        if (CueSheetNext <> nil) then
        begin
          RemainTime := IncSecond(EventTimeToDateTime(CueSheetNext^.StartTime) - CurrentTime);
          RemainTimeString := FormatDateTime('hh:nn:ss', RemainTime);
        end
        else
        begin
          RemainTimeString := IDLE_TIME;
        end;
        PlayedTimeString := IDLE_TIME;
      end;

      lblPlayedTime.Caption    := PlayedTimeString;
      lblRemainingTime.Caption := RemainTimeString;

      // Target event
      if (CueSheetTarget <> nil) then
      begin
//        lblTargetEventNo.Caption := Format('%d', [CueSheetTarget^.DisplayNo + 1]);
        RemainTargetTime := IncSecond(EventTimeToDateTime(CueSheetTarget^.StartTime) - CurrentTime);
        RemainTargetTimeString := FormatDateTime('hh:nn:ss', RemainTargetTime)
      end
      else
      begin
//        lblTargetEventNo.Caption := '';
        RemainTargetTimeString := IDLE_TIME;
      end;

//      lblRemainingTargetTime.Caption := RemainTargetTimeString;

      frmTimeline.SetChannelTime(Self.ChannelID, PlayedTimeString, RemainTimeString);
    end;

    WM_UPDATE_CURR_EVENT:
    begin
      Index := Message.WParam;
      Item  := PCueSheetItem(Message.LParam);
      if (Index >= 0) then
      begin
        lblPlayingInfo.Caption := GetCueSheetInfoByItem(Item);
        if (GV_SettingOption.OnAirEventHighlight) then
        begin
          with acgPlaylist do
          begin
            R := DisplRowIndex(Index + CNT_CUESHEET_HEADER);
//            if (R >= FixedRows) or (R <= RowCount - 1) then
            begin
              T := R - GV_SettingOption.OnAirEventFixedRow;
              if (T >= FixedRows) then
                TopRow := T
              else
                TopRow := FixedRows;

              MouseActions.DisjunctRowSelect := False;
              ClearRowSelect;
              MouseActions.DisjunctRowSelect := True;
              SelectRows(R, 1);
              Row := R;
            end;
          end;
        end;
      end;
    end;

    WM_UPDATE_NEXT_EVENT:
    begin
      Index := Message.WParam;
      Item  := PCueSheetItem(Message.LParam);

      if (CueSheetCurr <> nil) then
        Index := GetCueSheetIndexByItem(CueSheetCurr)
      else
        Index := GetCueSheetIndexByItem(Item);

      lblNextInfo.Caption := GetCueSheetInfoByItem(Item);

      if (Index >= 0) then
      begin
        if (GV_SettingOption.OnAirEventHighlight) then
        begin
          with acgPlaylist do
          begin
            R := DisplRowIndex(Index + CNT_CUESHEET_HEADER);
//            if (R >= FixedRows) or (R <= RowCount - 1) then
            begin
              T := R - GV_SettingOption.OnAirEventFixedRow;
              if (T >= FixedRows) then
                TopRow := T
              else
                TopRow := FixedRows;

              MouseActions.DisjunctRowSelect := False;
              ClearRowSelect;
              MouseActions.DisjunctRowSelect := True;
              SelectRows(R, 1);
              Row := R;
            end;
          end;
        end;
      end;
    end;

    WM_UPDATE_TARGET_EVENT:
    begin
      Index := Message.WParam;
      Item  := PCueSheetItem(Message.LParam);

      acgPlaylist.Repaint;
    end;

    WM_UPDATE_EVENT_STATUS:
    begin
      Index := Message.WParam;
      Item := PCueSheetItem(Message.LParam);

      PopulateEventStatusPlayListGrid(Index, Item);
    end;

    WM_UPDATE_MEDIA_CHECK:
    begin
      Item := PCueSheetItem(Message.LParam);
      Index := GetCueSheetIndexByItem(Item);

      PopulateMediaCheckPlayListGrid(Index, Item);
    end;

    WM_UPDATE_ERROR_DISPLAY:
    begin
      FErrorDisplayEnabled := not FErrorDisplayEnabled;
      ErrorDisplayPlayListGrid;
    end;

    WM_BEGIN_UPDATE:
    begin
      if (not (acgPlaylist.IsUpdating)) then
        acgPlaylist.BeginUpdate;
    end;

    WM_SET_ONAIR:
    begin
      ChannelID := Message.WParam;
      IsOnAir := Boolean(Message.LParam);
      SetChannelOnAir(IsOnAir);
    end;
    WM_INSERT_CUESHEET:
    begin
      Index := Message.WParam;
      Item := PCueSheetItem(Message.LParam);

      DisplayPlayListGrid(Index, Item);
      PopulatePlayListGrid(Index);
    end;
    WM_UPDATE_CUESHEET:
    begin
      Index := Message.WParam;
      Item := PCueSheetItem(Message.LParam);

      PopulatePlayListGrid(Index);
    end;
    WM_DELETE_CUESHEET:
    begin
      Index := Message.WParam;
      Item := PCueSheetItem(Message.LParam);

      DeletePlayListGridMain(Index);
    end;
    WM_CLEAR_CUESHEET:
    begin
      ChannelID := Message.WParam;
      ClearPlayListGrid;
    end;
    WM_END_UPDATE:
    begin
      if (acgPlaylist.IsUpdating) then
        acgPlaylist.EndUpdate;
    end;
  end;
end; }

procedure TfrmPlaylist.acgPlaylistBeforeContractNode(Sender: TObject; ARow,
  ARowReal: Integer; var Allow: Boolean);
var
  Level: Integer;
  I: Integer;
  NodeSpan: Integer;
  SubNodeState: Boolean;

  CellGraphic: TCellGraphic;
  O: TObject;
  C: TCellType;
begin
  inherited;
  exit;
  with acgPlaylist do
  begin
    Level := GetNodeLevel(ARow);
    if (Level = 1) then
    begin
      NodeSpan := GetNodeSpan(ARow);
      for I := ARow + 1 to ARow + NodeSpan - 1 do
      begin
        C := CellTypes[CellNode.NodeColumn, RealRowIndex(I)];
        if (C = ctNode) then
          ShowMessage(IntToStr(RealRowIndex(I)) + 'Node')
        else
          ShowMessage('nil');

//        CellGraphic := TCellGraphic(TCellProperties(AllObjects[CellNode.NodeColumn, RealRowIndex(I)]).GraphicObject);
//        if (CellGraphic.CellType = ctNode) then
//        begin
//          ShowMessage(IntToStr(RealRowIndex(I)));
//        end;
      end;
    end;
  end;
end;

procedure TfrmPlaylist.acgPlaylistBeforeExpandNode(Sender: TObject; ARow,
  ARowReal: Integer; var Allow: Boolean);
var
  Level: Integer;
  I: Integer;
  NodeSpan: Integer;
  SubNodeState: Boolean;

  CellGraphic: TCellGraphic;
  O: TObject;
  C: TCellType;
begin
  inherited;
  exit;
  with acgPlaylist do
  begin
    Level := GetNodeLevel(ARow);
    if (Level = 1) then
    begin
      NodeSpan := GetNodeSpan(ARow);
      for I := ARow + 1 to ARow + NodeSpan - 1 do
      begin
        C := CellTypes[CellNode.NodeColumn, RealRowIndex(I)];
        if (C = ctNode) then
          ShowMessage(IntToStr(RealRowIndex(I)) + 'Node')
        else
          ShowMessage('nil');

//        CellGraphic := TCellGraphic(TCellProperties(AllObjects[CellNode.NodeColumn, RealRowIndex(I)]).GraphicObject);
//        if (CellGraphic.CellType = ctNode) then
//        begin
//          ShowMessage(IntToStr(RealRowIndex(I)));
//        end;
      end;
    end;
  end;
end;

procedure TfrmPlaylist.acgPlaylistClickCell(Sender: TObject; ARow,
  ACol: Integer);
var
  R, C: Integer;
  CurrItem, NextItem: PCueSheetItem;
  NextIndex: Integer;
begin
  inherited;

  with (Sender as TAdvColumnGrid) do
  begin
    if (ACol = IDX_COL_CUESHEET_NO) and (IsNode(ARow)) then
    begin
//      ARow := GetRealRow;

      SetNodeState(Arow, not GetNodeState(ARow));
    end;
  end;
end;

procedure TfrmPlaylist.acgPlaylistDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  R: TRect;
  RRow: Integer;
  Item: PCueSheetItem;
begin
  inherited;
//  exit;
  with (Sender as TAdvColumnGrid) do
  begin
    if not (gdFixed in State) and
       (((gdSelected in State) or (gdRowSelected in State)) or
        (RowSelect[ARow])) then
    begin
      Canvas.Brush.Style := bsClear;
      Canvas.Pen.Color := clRed;

      Canvas.MoveTo(Rect.Left, Rect.Top);
      Canvas.LineTo(Rect.Right + 1, Rect.Top);

      Canvas.MoveTo(Rect.Left, Rect.Bottom - 1);
      Canvas.LineTo(Rect.Right + 1, Rect.Bottom - 1);

      SetTextColor(Canvas.Handle, clWhite);

{      if (ACol = 0) then
      begin
        Canvas.MoveTo(Rect.Left, Rect.Top);
        Canvas.LineTo(Rect.Left, Rect.Bottom);
      end
      else if (ACol = ColCount - 1) or (IsMergedCell(ACol, ARow)) then
      begin
        Canvas.MoveTo(Rect.Right, Rect.Top);
        Canvas.LineTo(Rect.Right, Rect.Bottom);
      end; }
    end
    else
    begin
      SetTextColor(Canvas.Handle, Font.Color);
    end;
  end;
end;

procedure TfrmPlaylist.acgPlaylistGetCellBorder(Sender: TObject; ARow,
  ACol: Integer; APen: TPen; var Borders: TCellBorders);
var
  RCol, RRow: Integer;
begin
  inherited;
end;

procedure TfrmPlaylist.acgPlaylistGetCellBorderProp(Sender: TObject; ARow,
  ACol: Integer; LeftPen, TopPen, RightPen, BottomPen: TPen);
var
  RCol, RRow: Integer;
begin
  inherited;
end;

procedure TfrmPlaylist.acgPlaylistGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  RCol, RRow: Integer;
  Item: PCueSheetItem;
  Index: Integer;
begin
  inherited;

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if (FCueSheetList = nil) then exit;

    Item := GetCueSheetItemByIndex(RRow - CNT_CUESHEET_HEADER);
    if (Item <> nil) then
    begin
      if (Item^.EventMode = EM_PROGRAM) then
      begin
        ABrush.Color := COLOR_BK_EVENTSTATUS_NORMAL;
        AFont.Color  := COLOR_TX_EVENTSTATUS_NORMAL;
        if (CueSheetCurr <> nil) then
        begin
          if (CueSheetCurr^.ProgramNo = Item^.ProgramNo) then
          begin
            ABrush.Color := COLOR_BK_EVENTSTATUS_ONAIR;
            AFont.Color  := COLOR_TX_EVENTSTATUS_ONAIR;
          end
          else
          begin
            Index := GetCueSheetIndexByItem(CueSheetCurr);
            if ((RRow - CNT_CUESHEET_HEADER) < Index) then
            begin
              ABrush.Color := COLOR_BK_EVENTSTATUS_DONE;
              AFont.Color  := COLOR_TX_EVENTSTATUS_DONE;
            end;
          end;
        end
        else if (CueSheetNext <> nil) then
        begin
          if (CueSheetNext^.ProgramNo = Item^.ProgramNo) then
          begin
            ABrush.Color := COLOR_BK_EVENTSTATUS_NEXT;
            AFont.Color  := COLOR_TX_EVENTSTATUS_NEXT;
          end
          else
          begin
            Index := GetCueSheetIndexByItem(CueSheetNext);
            if ((RRow - CNT_CUESHEET_HEADER) < Index) then
            begin
              ABrush.Color := COLOR_BK_EVENTSTATUS_DONE;
              AFont.Color  := COLOR_TX_EVENTSTATUS_DONE;
            end;
          end;
        end
        else
        begin
          if (GetProgramMainItemByItem(Item) = nil) then
          begin
            ABrush.Color := COLOR_BK_EVENTSTATUS_DONE;
            AFont.Color  := COLOR_TX_EVENTSTATUS_DONE;
          end;
        end;
      end
      else if (CueSheetNext <> nil) and (Item^.GroupNo = CueSheetNext^.GroupNo) and
              ((not FChannelOnAir) or ((CueSheetNext^.EventStatus.State in [esLoaded]) and (Item^.EventStatus.State in [esLoaded]))) then
      begin
        ABrush.Color := COLOR_BK_EVENTSTATUS_NEXT;
        AFont.Color  := COLOR_TX_EVENTSTATUS_NEXT;
      end
      else if (CueSheetCurr <> nil) and (Item^.GroupNo = CueSheetCurr^.GroupNo) and
              (Item^.EventStatus.State in [esLoaded]) then
      begin
        ABrush.Color := COLOR_BK_EVENTSTATUS_NEXT;
        AFont.Color  := COLOR_TX_EVENTSTATUS_NEXT;
      end
      else
      begin
        case Item^.EventStatus.State of
          esCueing..esPreroll:
          begin
            ABrush.Color := COLOR_BK_EVENTSTATUS_CUED;
            AFont.Color  := COLOR_TX_EVENTSTATUS_CUED;
          end;
          esOnAir:
          begin
            ABrush.Color := COLOR_BK_EVENTSTATUS_ONAIR;
            AFont.Color  := COLOR_TX_EVENTSTATUS_ONAIR;
          end;
          esSkipped,
          esFinish..esDone:
          begin
            ABrush.Color := COLOR_BK_EVENTSTATUS_DONE;
            AFont.Color  := COLOR_TX_EVENTSTATUS_DONE;
          end;
          esError:
          begin
            if (FErrorDisplayEnabled) and (RCol = IDX_COL_CUESHEET_SOURCE) then
            begin
              ABrush.Color := COLOR_BK_EVENTSTATUS_ERROR;
              AFont.Color  := COLOR_TX_EVENTSTATUS_ERROR;
            end;
          end;
          else
          begin
            if (CueSheetTarget <> nil) and (Item^.GroupNo = CueSheetTarget^.GroupNo) then
            begin
              ABrush.Color := COLOR_BK_EVENTSTATUS_TARGET;
              AFont.Color  := COLOR_TX_EVENTSTATUS_TARGET;
            end
            else
            begin
              ABrush.Color := COLOR_BK_EVENTSTATUS_NORMAL;
              AFont.Color  := COLOR_TX_EVENTSTATUS_NORMAL;
            end;
          end;
        end;
      end;

      if (RCol = IDX_COL_CUESHEET_MEDIA_ID) or (RCol = IDX_COL_CUESHEET_MEDIA_STATUS) then
      begin
        if (FErrorDisplayEnabled) and (Item^.MediaStatus in [msNotExist, msShort]) then
        begin
          ABrush.Color := COLOR_BK_MEDIASTATUS_NOT_EXIST;
          AFont.Color  := COLOR_TX_MEDIASTATUS_NOT_EXIST;
        end;
      end;
    end;
  end;
end;

procedure TfrmPlaylist.acgPlaylistGetDisplText(Sender: TObject; ACol,
  ARow: Integer; var Value: string);
var
  Item, ProgramMainItem: PCueSheetItem;
  RCol, RRow: Integer;
begin
  inherited;
  with (Sender as TAdvColumnGrid) do
  begin
//    if (ARow = 7) then
//    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if (RRow < AllRowCount - CNT_CUESHEET_FOOTER) then
    begin
      Item := GetCueSheetItemByIndex(RRow - CNT_CUESHEET_HEADER);
      if (Item <> nil) then
      begin
        with Item^ do
        begin
{          if (RCol = IDX_COL_CUESHEET_GROUP) then
          begin
            if (EventMode = EM_MAIN) then
            begin
              if (not IsNode(ARow)) then
                AddNode(ARow, ARow + 1)
            end
            else
              CellProperties[0, ARow].NodeLevel := 0; // Because of node show tree bug
          end; }

          if (RCol = IDX_COL_CUESHEET_NO) then
          begin
            if (EventMode = EM_COMMENT) then
            begin
              Value := String(Title);
            end
            else if (EventMode in [EM_MAIN]) then
            begin
//              FLastDisplayNo := GetBeforeMainCountByIndex(RRow);
//                Value := Format('%d', [FLastDisplayNo + 1]);
              Value := Format('%d', [DisplayNo + 1]);
//                Inc(FLastDisplayNo);
//              end
//              else
//              begin
//                Value := '';
            end
            else if (EventMode in [EM_PROGRAM]) then
            begin
              ProgramMainItem := GetProgramMainItemByItem(Item);
              if (ProgramMainItem <> nil) then
                Value := Format('%d', [ProgramMainItem^.DisplayNo + 1])
              else
                Value := '';
            end
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_EVENT_MODE) then
          begin
            Value := EventModeShortNames[EventMode];
          end
          else if (RCol = IDX_COL_CUESHEET_START_MODE) then
          begin
            if (EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
              Value := StartModeNames[StartMode]
            else if (EventMode in [EM_PROGRAM]) then
            begin
              ProgramMainItem := GetProgramMainItemByItem(Item);
              if (ProgramMainItem <> nil) then
                Value := StartModeNames[ProgramMainItem^.StartMode]
              else
                Value := '';
            end
            else
               Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_START_DATE) then
          begin
            if (EventMode in [EM_MAIN]) and (EventStatus.State <> esSkipped) then
              Value := FormatDateTime(FORMAT_DATE, StartTime.D)
            else if (EventMode in [EM_PROGRAM]) and (EventStatus.State <> esSkipped) then
            begin
              ProgramMainItem := GetProgramMainItemByItem(Item);
              if (ProgramMainItem <> nil) then
                Value := FormatDateTime(FORMAT_DATE, ProgramMainItem^.StartTime.D)
              else
                Value := '';
            end
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_START_TIME) then
          begin
            if (EventMode in [EM_MAIN, EM_SUB]) and (EventStatus.State <> esSkipped) then
              Value := TimecodeToString(StartTime.T)
            else if (EventMode in [EM_PROGRAM]) and (EventStatus.State <> esSkipped) then
            begin
              ProgramMainItem := GetProgramMainItemByItem(Item);
              if (ProgramMainItem <> nil) then
                Value := TimecodeToString(ProgramMainItem^.StartTime.T)
              else
                Value := '';
            end
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_INPUT) then
          begin
            if (EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
              Value := InputTypeNames[Input]
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_OUTPUT) then
          begin
            if (EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
            begin
              if (Input in [IT_MAIN, IT_BACKUP]) then
                Value := OutputBkgndTypeNames[TOutputBkgndType(Output)]
              else
                Value := OutputKeyerTypeNames[TOutputKeyerType(Output)];
            end
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_EVENT_STATUS) then
          begin
            Value := EventStatusNames[EventStatus.State];
          end
          else if (RCol = IDX_COL_CUESHEET_TITLE) then
          begin
            Value := String(Title);
          end
          else if (RCol = IDX_COL_CUESHEET_SUB_TITLE) then
          begin
            Value := String(SubTitle);
          end
          else if (RCol = IDX_COL_CUESHEET_SOURCE) then
          begin
            if (EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
              Value := String(Source)
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_MEDIA_ID) then
          begin
            if (EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
              Value := String(MediaId)
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_MEDIA_Status) then
          begin
            if (EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
              Value := MediaStatusNames[MediaStatus]
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_DURATON) then
          begin
            if (EventMode in [EM_MAIN, EM_SUB]) then
              Value := TimecodeToString(DurationTC)
            else if (EventMode in [EM_PROGRAM]) then
              Value := TimecodeToString(GetProgramDurationByItem(Item))
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_IN_TC) then
          begin
            if (EventMode in [EM_MAIN, EM_SUB]) then
              Value := TimecodeToString(InTC)
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_OUT_TC) then
          begin
            if (EventMode in [EM_MAIN, EM_SUB]) then
              Value := TimecodeToString(OutTC)
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_VIDEO_TYPE) then
          begin
            if (EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
              Value := VideoTypeNames[VideoType]
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_AUDIO_TYPE) then
          begin
            if (EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
              Value := AudioTypeNames[AudioType]
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_CLOSED_CAPTION) then
          begin
            if (EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
              Value := ClosedCaptionNames[ClosedCaption]
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_VOICE_ADD) then
          begin
            if (EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
              Value := VoiceAddNames[VoiceAdd]
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_TR_TYPE) then
          begin
            if (EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
              Value := TRTypeNames[TransitionType]
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_TR_RATE) then
          begin
            if (EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
              Value := TRRateNames[TransitionRate]
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_PROGRAM_TYPE) then
          begin
            if (EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
              Value := GetProgramTypeNameByCode(ProgramType)
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_NOTES) then
          begin
            Value := String(Notes);
          end;
        end;
      end
      else
        Value := '';
    end
    else
    begin
      if (RCol = IDX_COL_CUESHEET_NO) then
      begin
        Value := 'End of event';
      end
      else
        Value := '';
    end;
  end;
end;

constructor TfrmPlaylist.Create(AOwner: TComponent; AChannelID: Word; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited Create(AOwner, ACombine, ALeft, ATop, AWidth, AHeight);

  FChannelID := AChannelId;
end;

procedure TfrmPlaylist.Initialize;
begin
  FChannelOnAir := False;

  FCueSheetList := TCueSheetList.Create;

  FErrorDisplayEnabled := True;

  FCueSheetCurr   := nil;
  FCueSheetNext   := nil;
  FCueSheetTarget := nil;

  lblChannel.Caption := GetChannelNameByID(FChannelID);

  FPlayedTimeStr    := IDLE_TIME;
  FRemainingTimeStr := IDLE_TIME;
  FNextStartTimeStr := IDLE_TIMECODE;

  lblPlayedTime.Caption     := FPlayedTimeStr;
  lblRemainingTime.Caption  := FRemainingTimeStr;
  lblNextStart.Caption      := FNextStartTimeStr;

  lblPlayingInfo.Caption := '-';
  lblNextInfo.Caption    := '-';

  SetChannelOnAir(FChannelOnAir);

  InitializePlayListGrid;

  FTimerThread := TTimelineTimerThread.Create(Self);
  FTimerThread.Resume;
end;

procedure TfrmPlaylist.Finalize;
begin
  if (FTimerThread <> nil) then
  begin
    FTimerThread.Terminate;
    FTimerThread.WaitFor;
    FreeAndNil(FTimerThread);
  end;

  ClearPlayListGrid;
  ClearCueSheetList;

  FreeAndNil(FCueSheetList);

  // If exist hide rows bug
{  with acgPlaylist do
  begin
    acgPlaylist.RowCount := 0;
  end;  }
end;

procedure TfrmPlaylist.SetCueSheetCurr(AValue: PCueSheetItem);
var
  Index: Integer;
begin
  if (FCueSheetCurr <> AValue) then
  begin
    FCueSheetCurr := AValue;
    Index := GetCueSheetIndexByItem(AValue);

    PostMessage(Handle, WM_UPDATE_CURR_EVENT, Index, NativeInt(FCueSheetCurr));

    if (FCueSheetCurr = CueSheetTarget) then
      CueSheetTarget := nil;
  end;
end;

procedure TfrmPlaylist.SetCueSheetNext(AValue: PCueSheetItem);
var
  Index: Integer;
begin
  if (FCueSheetNext <> AValue) then
  begin
    FCueSheetNext := AValue;
    Index := GetCueSheetIndexByItem(AValue);

    PostMessage(Handle, WM_UPDATE_NEXT_EVENT, Index, NativeInt(FCueSheetNext));
  end;
end;

procedure TfrmPlaylist.SetCueSheetTarget(AValue: PCueSheetItem);
var
  Index: Integer;
begin
//  if (FCueSheetTarget <> AValue) then
  begin
    FCueSheetTarget := AValue;
    Index := GetCueSheetIndexByItem(AValue);

    PostMessage(Handle, WM_UPDATE_TARGET_EVENT, Index, NativeInt(FCueSheetTarget));
  end;
end;

function TfrmPlaylist.GetCueSheetItemByIndex(AIndex: Integer): PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  Result := FCueSheetList[AIndex];
end;

function TfrmPlaylist.GetCueSheetItemByID(AEventID: TEventID): PCueSheetItem;
var
  I, CurrIndex: Integer;
  CurrItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;

  for I := 0 to FCueSheetList.Count - 1 do
  begin
    CurrItem := FCueSheetList[I];
    if (CurrItem <> nil) then
    begin
      if (IsEqualEventID(CurrItem^.EventID, AEventID)) then
      begin
        Result := CurrItem;
        break;
      end;
    end;
  end;
end;

function TfrmPlaylist.GetCueSheetIndexByItem(AItem: PCueSheetItem): Integer;
begin
  Result := -1;

  if (FCueSheetList = nil) then exit;

  Result := FCueSheetList.IndexOf(AItem);
end;

function TfrmPlaylist.GetCueSheetInfoByItem(AItem: PCueSheetItem): String;
begin
  Result := '';

  if (AItem = nil) then exit;

  Result := Format('%s/%s/%s', [String(AItem^.Title), String(AItem^.SubTitle), String(AItem^.MediaId)]);
end;

function TfrmPlaylist.GetParentCueSheetItemByIndex(AIndex: Integer): PCueSheetItem;
var
  I, CurrIndex: Integer;
  CurrItem, ParentItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  CurrItem := FCueSheetList[AIndex];

  if (CurrItem <> nil) then
  begin
    for I := AIndex downto 0 do
    begin
      ParentItem := FCueSheetList[I];
      if (ParentItem <> nil) and
         (ParentItem^.GroupNo = CurrItem^.GroupNo) and (ParentItem^.EventMode = EM_MAIN) then
      begin
        Result := ParentItem;
        break;
      end;
    end;
  end;
end;

function TfrmPlaylist.GetParentCueSheetItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I, CurrIndex: Integer;
  ParentItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  CurrIndex := FCueSheetList.IndexOf(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex downto 0 do
  begin
    ParentItem := FCueSheetList[I];
    if (ParentItem^.EventMode = EM_COMMENT) then continue;

    if (ParentItem^.GroupNo = AItem^.GroupNo) and (ParentItem^.EventMode = EM_MAIN) then
    begin
      Result := ParentItem;
      break;
    end;
//    else if (P^.GroupNo > C^.GroupNo) then break;
  end;
end;

function TfrmPlaylist.GetProgramItemByIndex(AIndex: Integer): PCueSheetItem;
var
  I: Integer;
  ProgItem, CurrItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  CurrItem := GetCueSheetItemByIndex(AIndex);

  if (CurrItem <> nil) then
  begin
    for I := AIndex downto 0 do
    begin
      ProgItem := GetCueSheetItemByIndex(I);
      if (ProgItem <> nil) and (ProgItem^.ProgramNo = CurrItem^.ProgramNo) then
      begin
        if (ProgItem^.EventMode = EM_PROGRAM) then
        begin
          Result := ProgItem;
          break;
        end;
      end
      else break;
    end;
  end;
end;

function TfrmPlaylist.GetProgramItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I, ProgIndex: Integer;
  ProgItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  ProgIndex := FCueSheetList.IndexOf(AItem);
  if (ProgIndex < 0) then exit;

  for I := ProgIndex downto 0 do
  begin
    ProgItem := GetCueSheetItemByIndex(I);
    if (ProgItem^.ProgramNo = AItem^.ProgramNo) then
    begin
      if (ProgItem^.EventMode = EM_PROGRAM) then
      begin
        Result := ProgItem;
        break;
      end;
    end
    else break;
  end;
end;

function TfrmPlaylist.GetProgramMainItemByIndex(AIndex: Integer): PCueSheetItem;
var
  I: Integer;
  PItem, Item: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  PItem := GetCueSheetItemByIndex(AIndex);
  if (PItem <> nil) then
  begin
    for I := AIndex + 1 to FCueSheetList.Count - 1 do
    begin
      Item := FCueSheetList[I];
      if (Item^.ProgramNo = PItem^.ProgramNo) then
      begin
        if (PItem^.EventMode = EM_MAIN) and (PItem^.EventStatus.State <> esSkipped) then
        begin
          Result := PItem;
          break;
        end;
      end
      else
        break;
    end;
  end;
end;

function TfrmPlaylist.GetProgramMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I, CurrIndex: Integer;
  Item: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  CurrIndex := FCueSheetList.IndexOf(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex + 1 to FCueSheetList.Count - 1 do
  begin
    Item := FCueSheetList[I];
    if (Item^.ProgramNo = AItem^.ProgramNo) then
    begin
      if (Item^.EventMode = EM_MAIN) and (Item^.EventStatus.State <> esSkipped) then
      begin
        Result := Item;
        break;
      end;
    end
    else
      break;
  end;
end;

// Program의 Main 이벤트 개수를 구함
function TfrmPlaylist.GetProgramChildCountByItem(AItem: PCueSheetItem): Integer;
var
  I, CurrIndex: Integer;
  Item: PCueSheetItem;
begin
  Result := 0;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;
  if (AItem^.EventMode <> EM_PROGRAM) then exit;

  CurrIndex := FCueSheetList.IndexOf(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex + 1 to FCueSheetList.Count - 1 do
  begin
    Item := FCueSheetList[I];
    if (Item^.ProgramNo = AItem^.ProgramNo) then
    begin
      Inc(Result);
    end
    else
      break;
  end;
end;

function TfrmPlaylist.GetProgramDurationByItem(AItem: PCueSheetItem): TTimecode;
var
  I, CurrIndex: Integer;
  Item: PCueSheetItem;
begin
  Result := 0;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  if (AItem^.EventMode <> EM_PROGRAM) then exit;

  CurrIndex := FCueSheetList.IndexOf(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex + 1 to FCueSheetList.Count - 1 do
  begin
    Item := FCueSheetList[I];
    if (Item^.ProgramNo = AItem^.ProgramNo) then
    begin
      if (Item^.EventMode = EM_MAIN) then
      begin
        Result := GetPlusTimecode(Result, Item^.DurationTC);
      end;
    end
    else
      break;
  end;
end;

procedure TfrmPlaylist.NewPlayList;
var
  ChannelCueSheet: PChannelCueSheet;
begin
  if (FCueSheetList = nil) then exit;

  ClearPlayListGrid;
  ClearCueSheetList;

  CueSheetCurr := nil;
  CueSheetNext := nil;
end;

procedure TfrmPlaylist.DisplayPlayListGrid(AIndex: Integer; AItem: PCueSheetItem);
var
  PItem: PCueSheetItem;
  PIndex: Integer;
  R: Integer;
begin
  inherited;

  if (AIndex < 0) then exit;
  if (AItem = nil) then exit;

  if (FCueSheetList = nil) then exit;

  with acgPlaylist do
  begin
    if (AItem^.EventMode = EM_PROGRAM) then
    begin
      R := RealRowIndex(AIndex + CNT_CUESHEET_HEADER);
      InsertNormalRow(R);
    end
    else if (AItem^.EventMode = EM_MAIN) then
    begin
      PItem := GetProgramItemByIndex(AIndex);
      if (PItem <> nil) then
      begin
        PIndex := GetCueSheetIndexByItem(PItem);
        R := RealRowIndex(PIndex + CNT_CUESHEET_HEADER);

        if (not IsNode(DisplRowIndex(R))) then
          AddNode(R, 1);

        InsertChildRow(R, AIndex - PIndex);
  //      PopulatePlayListTimeLine(ProgIndex);
      end
      else
      begin
        R := RealRowIndex(AIndex + CNT_CUESHEET_HEADER);
        InsertNormalRow(R);
      end;
    end
    else
    begin
      PItem := GetParentCueSheetItemByIndex(AIndex);
      if (PItem <> nil) then
      begin
        PIndex := GetCueSheetIndexByItem(PItem);
        R := RealRowIndex(PIndex + CNT_CUESHEET_HEADER);

        if (not IsNode(DisplRowIndex(R))) then
          AddNode(R, 1);

        InsertChildRow(R, AIndex - PIndex);// + 1);
  //      PopulatePlayListTimeLine(ParentIndex);

  //      PopulatePlayListGrid(AIndex);
      end;
    end;
  end;
end;

procedure TfrmPlaylist.DeletePlayListGridMain(AIndex: Integer);
var
  ProgItem: PCueSheetItem;
  ProgIndex: Integer;

  RRow, DRow: Integer;
  PRow: Integer;
  NodeSpan: Integer;
begin
  with acgPlaylist do
  begin
    RRow := AIndex + CNT_CUESHEET_HEADER;
    if (IsHiddenRow(RRow)) then exit;

//    ShowMessage(IntToStr(RowCount));
    DRow := DisplRowIndex(RRow);
    PRow := GetParentRow(DRow);

    NodeSpan := GetNodeSpan(DRow);
    if (NodeSpan > 1) then
    begin
      ExpandNode(RRow);

      while (NodeSpan > 1)  do
      begin
        RemoveChildRow(RRow + NodeSpan - 1);
        NodeSpan := GetNodeSpan(DRow);
      end;

    end;

    if (PRow >= 0) and (PRow < DRow)then
    RemoveChildRow(RRow)
    else
    RemoveNormalRow(DRow);
//    ShowMessage(IntToStr(RowCount));

    if (PRow >= 0) and (PRow < DRow)then
    begin
      NodeSpan := GetNodeSpan(PRow);
      if (NodeSpan <= 1) then
        RemoveNode(RealRowIndex(PRow));
    end;
  end;
end;

procedure TfrmPlaylist.PopulatePlayListGrid(AIndex: Integer);
var
  R: Integer;
  Item: PCueSheetItem;

  
  CueSheetItem: PCueSheetItem;
begin
  inherited;

  with acgPlaylist do
  begin
    R := DisplRowIndex(AIndex + CNT_CUESHEET_HEADER);

    if (R < FixedRows) then exit;

    Item := GetCueSheetItemByIndex(AIndex);
    if (Item <> nil) then
    begin
      with Item^ do
      begin
        if (EventMode = EM_COMMENT) then
        begin
          if (not IsMergedCell(IDX_COL_CUESHEET_NO, R)) then
            MergeCells(IDX_COL_CUESHEET_NO, R, ColCount - IDX_COL_CUESHEET_NO, 1);
        end
        else
        begin
//          if (not IsMergedCell(IDX_COL_CUESHEET_NO, R)) then
            SplitCells(IDX_COL_CUESHEET_NO, R);
        end;
      end;
    end;
  end;
end;

procedure TfrmPlaylist.PopulateEventStatusPlayListGrid(AIndex: Integer; AItem: PCueSheetItem);
var
  R: Integer;
  CueSheetItem: PCueSheetItem;
begin
  inherited;

  with acgPlaylist do
  begin
    R := DisplRowIndex(AIndex + CNT_CUESHEET_HEADER);

    if (R < FixedRows) or (R > RowCount - 1) then exit;

    if (InRange(R, TopRow, TopRow + VisibleRowCount - 1)) then
      RepaintRow(R)
  end;
end;

procedure TfrmPlaylist.PopulateMediaCheckPlayListGrid(AIndex: Integer; AItem: PCueSheetItem);
var
  R: Integer;
begin
  inherited;

  with acgPlaylist do
  begin
    R := DisplRowIndex(AIndex + CNT_CUESHEET_HEADER);

    if (R < FixedRows) or (R > RowCount - 1) then exit;

    if (InRange(R, TopRow, TopRow + VisibleRowCount - 1)) then
      RepaintRow(R);
  end;
end;

procedure TfrmPlaylist.ErrorDisplayPlayListGrid;
var
  I: Integer;
  Item: PCueSheetItem;
begin
  with acgPlaylist do
  begin
    for I := TopRow to TopRow + VisibleRowCount - 1 do
    begin
      Item := GetCueSheetItemByIndex(RealRowIndex(I) - CNT_CUESHEET_HEADER);
      if (Item <> nil) then
      begin
        if (Item^.EventStatus.State in [esError]) then
        begin
          RepaintCell(IDX_COL_CUESHEET_SOURCE, I);
        end;

        if (Item^.MediaStatus in [msNotExist, msShort]) then
        begin
          RepaintCell(IDX_COL_CUESHEET_MEDIA_ID, I);
          RepaintCell(IDX_COL_CUESHEET_MEDIA_STATUS, I);
        end;
      end;
    end;
  end;
end;

procedure TfrmPlaylist.SelectRowPlayListGrid(AIndex: Integer);
var
  DispRow: Integer;
begin
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  with acgPlaylist do
  begin
    DispRow := DisplRowIndex(AIndex + CNT_CUESHEET_HEADER);

//    MouseActions.DisjunctRowSelect := False;
    ClearRowSelect;
//    MouseActions.DisjunctRowSelect := True;
//    SelectRows(DispRow, 1);
    Row := DispRow;
  end;
end;

procedure TfrmPlaylist.CueSheetListQuickSort(L, R: Integer; ACueSheetList: TCueSheetList);
var
  I, J, P: Integer;
  Save: PCueSheetItem;
  SortList: TCueSheetList;

  function Compare(Item1, Item2: PCueSheetItem): Integer;
  begin
    Result := CompareEventTime(Item1^.StartTime, Item2^.StartTime);
  end;

begin
  SortList := ACueSheetList;
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while Compare(ACueSheetList[I], ACueSheetList[P]) < 0 do
        Inc(I);
      while Compare(ACueSheetList[J], ACueSheetList[P]) > 0 do
        Dec(J);
      if I <= J then
      begin
        Save        := SortList[I];
        SortList[I] := SortList[J];
        SortList[J] := Save;
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      CueSheetListQuickSort(L, J, ACueSheetList);
    L := I;
  until I >= R;
end;

procedure TfrmPlaylist.SetChannelOnAir(AOnAir: Boolean);
begin
  SetChannelOnAirByID(FChannelID, AOnAir);
  FChannelOnAir := AOnAir;

  lblOnAirFlag.Caption := OnAirFlagNames[FChannelOnAir];
  if (FChannelOnAir) then
  begin
    lblOnAirFlag.Font.Color := clLime;
  end
  else
  begin
    lblOnAirFlag.Font.Color := clRed;

    CueSheetCurr   := nil;
    CueSheetNext   := nil;
    CueSheetTarget := nil;
  end;
end;

procedure TfrmPlaylist.GotoCurrentEvent;
var
  SelectIndex: Integer;
  ParentItem: PCueSheetItem;
  ParentIndex: Integer;
  CurrIndex: Integer;

//  ParentRow: Integer;
begin
  if (not FChannelOnAir) then exit;
  if (CueSheetCurr = nil) then exit;

  PostMessage(Handle, WM_UPDATE_CURR_EVENT, 0, NativeInt(CueSheetCurr));
end;

function TfrmPlaylist.MCCSetEventStatus(AEventID: TEventID; AStatus: TEventStatus): Integer;
var
  Item: PCueSheetItem;
  Index: Integer;
begin
  Result := D_FALSE;

//  if (not FChannelOnAir) then exit;

  Item := GetCueSheetItemByID(AEventID);
  if (Item <> nil) then
  begin
    Item^.EventStatus := AStatus;
    Index := GetCueSheetIndexByItem(Item);
    if (Index >= 0) then
    begin
      PostMessage(Handle, WM_UPDATE_EVENT_STATUS, Index, NativeInt(Item));
      PostMessage(frmTimeline.Handle, WM_UPDATE_EVENT_STATUS, Index, NativeInt(Item));
    end;
  end;

  Result := D_OK;
end;

function TfrmPlaylist.MCCSetMediaStatus(AEventID: TEventID; AStatus: TMediaStatus): Integer;
var
  Item: PCueSheetItem;
  Index: Integer;
begin
  Result := D_FALSE;

//  if (not FChannelOnAir) then exit;

  Item := GetCueSheetItemByID(AEventID);
  if (Item <> nil) then
  begin
    Item^.MediaStatus := AStatus;
    Index := GetCueSheetIndexByItem(Item);
    if (Index >= 0) then
    begin
      PostMessage(Handle, WM_UPDATE_MEDIA_CHECK, Index, NativeInt(Item));
      PostMessage(frmTimeline.Handle, WM_UPDATE_MEDIA_CHECK, Index, NativeInt(Item));
    end;
  end;

  Result := D_OK;
end;

procedure TfrmPlaylist.SetEventOverall(ADCSIP: String; ADeviceHandle: TDeviceHandle; AOverall: TEventOverall);
var
  Item: PCueSheetItem;
  Source: PSource;
  SourceHandles: TSourceHandleList;
  I: Integer;
begin
  Item := GetCueSheetItemByID(AOverall.OnAirEventID);
  if ((Item <> nil) and (Item^.EventMode = EM_MAIN)) then
    CueSheetCurr := Item
  else if (Item = nil) and (CueSheetCurr <> nil) then
  begin
    Source := GetSourceByName(CueSheetCurr^.Source);
    SourceHandles := Source^.Handles;
    if (SourceHandles <> nil) then
    begin
      for I := 0 to SourceHandles.Count - 1 do
      begin
        if (String(SourceHandles[I]^.DCS^.HostIP) = ADCSIP) and
           (SourceHandles[I].Handle = ADeviceHandle) then
        begin
          CueSheetCurr := nil;
          break;
        end;
      end;
    end;
  end;

  Item := GetCueSheetItemByID(AOverall.PreparedEventID);
  if ((Item <> nil) and (Item^.EventMode = EM_MAIN)) then
    CueSheetNext := Item
  else if (Item = nil) and (CueSheetNext <> nil) then
  begin
    Source := GetSourceByName(CueSheetNext^.Source);
    SourceHandles := Source^.Handles;
    if (SourceHandles <> nil) then
    begin
      for I := 0 to SourceHandles.Count - 1 do
      begin
        if (String(SourceHandles[I]^.DCS^.HostIP) = ADCSIP) and
           (SourceHandles[I].Handle = ADeviceHandle) then
        begin
          CueSheetNext := nil;
          break;
        end;
      end;
    end;
  end;
end;

procedure TfrmPlaylist.ClearCueSheetList;
var
  I: Integer;
begin
  if (FCueSheetList = nil) then exit;

  for I := FCueSheetList.Count - 1 downto 0 do
    Dispose(FCueSheetList[I]);

  FCueSheetList.Clear;
end;

procedure TfrmPlaylist.ClearPlayListGrid;
begin
  with acgPlaylist do
  begin
    BeginUpdate;
    try
      MouseActions.DisjunctRowSelect := False;
      ClearRowSelect;
      RemoveAllNodes;
      RowCount := CNT_CUESHEET_HEADER + CNT_CUESHEET_FOOTER;
      MouseActions.DisjunctRowSelect := True;
      SelectRows(CNT_CUESHEET_HEADER, 1);
      Row := CNT_CUESHEET_HEADER;
    finally
      acgPlaylist.EndUpdate;
    end;
  end;
end;

procedure TfrmPlaylist.FormCreate(Sender: TObject);
begin
  inherited;
  Initialize;

//  NewPlayList;
end;

procedure TfrmPlaylist.FormDestroy(Sender: TObject);
begin
  inherited;
  Finalize;
end;

procedure TfrmPlaylist.InitializePlayListGrid;
var
  I, J: Integer;
  Column: TGridColumnItem;
  E: TEventMode;
  S: TStartMode;
  IType: TInputType;
  VideoType: TVideoType;
  AudioType: TAudioType;
  ClosedCaption: TClosedCaption;
  VoiceAdd: TVoiceAdd;
  TrType: TTRType;
  TrRate: TTRRate;
begin
  with acgPlaylist do
  begin
    BeginUpdate;
    try
      RowCount  := CNT_CUESHEET_HEADER + CNT_CUESHEET_FOOTER;
      ColCount  := CNT_CUESHEET_COLUMNS;
      FixedRows := CNT_CUESHEET_HEADER;
//      FixedFooters := CNT_CUESHEET_FOOTER;

      Columns.BeginUpdate;
      try
        Columns.Clear;
        for I := 0 to CNT_CUESHEET_COLUMNS - 1 do
        begin
          Column := Columns.Add;
          with Column do
          begin
            HeaderFont.Assign(acgPlaylist.FixedFont);
            Font.Assign(acgPlaylist.Font);

            // Column : Group
            if (I = IDX_COL_CUESHEET_GROUP) then
            begin
              BorderPen.Color := GridLineColor;
              Borders  := [cbRight];
              Header   := NAM_COL_CUESHEET_GROUP;
              ReadOnly := True;
              Width    := WIDTH_COL_CUESHEET_GROUP;
            end
            // Column : No
            else if (I = IDX_COL_CUESHEET_NO) then
            begin
              Alignment := taLeftJustify;
              Borders   := [];
              Header    := NAM_COL_CUESHEET_NO;
              HeaderAlignment := taCenter;
              ReadOnly  := True;
              Width     := WIDTH_COL_CUESHEET_NO;
            end
            // Column Dropdown List : Event Mode
            else if (I = IDX_COL_CUESHEET_EVENT_MODE) then
            begin
              Alignment := taCenter;
              Header    := NAM_COL_CUESHEET_EVENT_MODE;
              ReadOnly  := True;
              Width     := WIDTH_COL_CUESHEET_EVENT_MODE;

  {            Editor := edComboList;
              for E := EM_MAIN to EM_JOIN do
              begin
                ComboItems.AddObject(EventModeNames[E], TObject(E));
              end; }
            end
            // Column : Event Status
            else if (I = IDX_COL_CUESHEET_EVENT_STATUS) then
            begin
              Alignment := taLeftJustify;
              Header    := NAM_COL_CUESHEET_EVENT_STATUS;
              ReadOnly  := True;
              Width     := WIDTH_COL_CUESHEET_EVENT_STATUS;
            end
            // Column Dropdown List : Start Mode
            else if (I = IDX_COL_CUESHEET_START_MODE) then
            begin
              Header := NAM_COL_CUESHEET_START_MODE;
              Width  := WIDTH_COL_CUESHEET_START_MODE;
              Editor := edComboList;
              for S := SM_ABSOLUTE to SM_SUBEND do
              begin
                ComboItems.AddObject(StartModeNames[S], TObject(S));
              end;
            end
            // Column : Start Date
            else if (I = IDX_COL_CUESHEET_START_DATE) then
            begin
              Header := NAM_COL_CUESHEET_START_DATE;
              Width  := WIDTH_COL_CUESHEET_START_DATE;
  //            Editor := edComboList;
              Editor := edDateEdit;
            end
            // Column : Start Time
            else if (I = IDX_COL_CUESHEET_START_TIME) then
            begin
              Header := NAM_COL_CUESHEET_START_TIME;
              Width  := WIDTH_COL_CUESHEET_START_TIME;
              Editor := edNormal;
  //            EditMask := '!0000-!90-90 !90:00:00:00;1;';
              EditMask := '!99:99:99:99;1; ';
            end
            // Column Dropdown List : Input Type
            else if (I = IDX_COL_CUESHEET_INPUT) then
            begin
              Header := NAM_COL_CUESHEET_INPUT;
              Width  := WIDTH_COL_CUESHEET_INPUT;
              Editor := edComboList;
              for IType := IT_MAIN to IT_AMIXER2 do
              begin
                ComboItems.AddObject(InputTypeNames[IType], TObject(IType));
              end;
            end
            // Column Dropdown List : Output Type
            else if (I = IDX_COL_CUESHEET_OUTPUT) then
            begin
              Header := NAM_COL_CUESHEET_OUTPUT;
              Width  := WIDTH_COL_CUESHEET_OUTPUT;
              Editor := edComboList;
              ComboItems.Clear;
            end
            // Column : Title
            else if (I = IDX_COL_CUESHEET_TITLE) then
            begin
              Header  := NAM_COL_CUESHEET_TITLE;
              Width  := WIDTH_COL_CUESHEET_TITLE;
              Editor := edNormal;
              EditMask := '';
            end
            // Column : Sub Title
            else if (I = IDX_COL_CUESHEET_SUB_TITLE) then
            begin
              Header  := NAM_COL_CUESHEET_SUB_TITLE;
              Width  := WIDTH_COL_CUESHEET_SUB_TITLE;
              Editor := edNormal;
            end
            // Column Dropdown List : Source
            else if (I = IDX_COL_CUESHEET_SOURCE) then
            begin
              Header := NAM_COL_CUESHEET_SOURCE;
              Width  := WIDTH_COL_CUESHEET_SOURCE;
              Editor := edComboList;
              for J := 0 to GV_SourceList.Count - 1 do
              begin
                if (not (GV_SourceList[J]^.SourceType in [ST_ROUTER, ST_MCS])) then
  //                if (GV_SourceList[I]^.DCS <> nil) and (GV_SourceList[I]^.DCS^.Main) then
  //                 ComboItems.AddObject(String(GV_SourceList[I]^.Name), TObject(GV_SourceList[I]^.Handle));
                    ComboItems.Add(String(GV_SourceList[J]^.Name));
              end;
            end
            // Column Dropdown List : Media ID
            else if (I = IDX_COL_CUESHEET_MEDIA_ID) then
            begin
              Header := NAM_COL_CUESHEET_MEDIA_ID;
              Width  := WIDTH_COL_CUESHEET_MEDIA_ID;
              Editor := edEditBtn;
            end
            // Column Dropdown List : Media Status
            else if (I = IDX_COL_CUESHEET_MEDIA_STATUS) then
            begin
              Header := NAM_COL_CUESHEET_MEDIA_STATUS;
              Width  := WIDTH_COL_CUESHEET_MEDIA_STATUS;
              Editor := edNormal;
              ReadOnly := True;
            end
            // Column : Duration TC
            else if (I = IDX_COL_CUESHEET_DURATON) then
            begin
              Header := NAM_COL_CUESHEET_DURATON;
              Width  := WIDTH_COL_CUESHEET_DURATON;
              Editor := edNormal;
              EditMask := '!99:99:99:99;1; ';
            end
            // Column : In TC
            else if (I = IDX_COL_CUESHEET_IN_TC) then
            begin
              Header := NAM_COL_CUESHEET_IN_TC;
              Width  := WIDTH_COL_CUESHEET_IN_TC;
              Editor := edNormal;
              EditMask := '!99:99:99:99;1; ';
            end
            // Column : Out TC
            else if (I = IDX_COL_CUESHEET_OUT_TC) then
            begin
              Header := NAM_COL_CUESHEET_OUT_TC;
              Width  := WIDTH_COL_CUESHEET_OUT_TC;
              Editor := edNormal;
              EditMask := '!99:99:99:99;1; ';
            end
            // Column Dropdown List : Video Type
            else if (I = IDX_COL_CUESHEET_VIDEO_TYPE) then
            begin
              Header := NAM_COL_CUESHEET_VIDEO_TYPE;
              Width  := WIDTH_COL_CUESHEET_VIDEO_TYPE;
              Editor := edComboList;
              for VideoType := VT_NONE to VT_3D do
              begin
                ComboItems.AddObject(VideoTypeNames[VideoType], TObject(VideoType));
              end;
            end
            // Column Dropdown List : Audio Type
            else if (I = IDX_COL_CUESHEET_AUDIO_TYPE) then
            begin
              Header := NAM_COL_CUESHEET_AUDIO_TYPE;
              Width  := WIDTH_COL_CUESHEET_AUDIO_TYPE;
              Editor := edComboList;
              for AudioType := AT_NONE to AT_MONO do
              begin
                ComboItems.AddObject(AudioTypeNames[AudioType], TObject(AudioType));
              end;
            end
            // Column Dropdown List : Closed Caption
            else if (I = IDX_COL_CUESHEET_CLOSED_CAPTION) then
            begin
              Header := NAM_COL_CUESHEET_CLOSED_CAPTION;
              Width  := WIDTH_COL_CUESHEET_CLOSED_CAPTION;
              Editor := edComboList;
              for ClosedCaption := CC_NONE to CC_EXIST do
              begin
                ComboItems.AddObject(ClosedCaptionNames[ClosedCaption], TObject(ClosedCaption));
              end;
            end
            // Column Dropdown List : Voice Add
            else if (I = IDX_COL_CUESHEET_VOICE_ADD) then
            begin
              Header := NAM_COL_CUESHEET_VOICE_ADD;
              Width  := WIDTH_COL_CUESHEET_VOICE_ADD;
              Editor := edComboList;
              for VoiceAdd := VA_NONE to VA_ETC_VOICE do
              begin
                ComboItems.AddObject(VoiceAddNames[VoiceAdd], TObject(VoiceAdd));
              end;
            end
            // Column Dropdown List : Transition Type
            else if (I = IDX_COL_CUESHEET_TR_TYPE) then
            begin
              Header := NAM_COL_CUESHEET_TR_TYPE;
              Width  := WIDTH_COL_CUESHEET_TR_TYPE;
              Editor := edComboList;
              for TrType := TT_CUT to TT_MIX do
              begin
                ComboItems.AddObject(TRTypeNames[TrType], TObject(TrType));
              end;
            end
            // Column Dropdown List : Transition Rate
            else if (I = IDX_COL_CUESHEET_TR_RATE) then
            begin
              Header := NAM_COL_CUESHEET_TR_RATE;
              Width  := WIDTH_COL_CUESHEET_TR_RATE;
              Editor := edComboList;
              for TrRate := TR_CUT to TR_SLOW do
              begin
                ComboItems.AddObject(TRRateNames[TrRate], TObject(TrRate));
              end;
            end
            // Column Dropdown List : Program Type
            else if (I = IDX_COL_CUESHEET_PROGRAM_TYPE) then
            begin
              Header := NAM_COL_CUESHEET_PROGRAM_TYPE;
              Width  := WIDTH_COL_CUESHEET_PROGRAM_TYPE;
              Editor := edComboList;
              for J := 0 to GV_ProgramTypeList.Count - 1 do
              begin
                ComboItems.AddObject(GV_ProgramTypeList[J]^.Name, TObject(GV_ProgramTypeList[J]^.Code));
              end;
            end
            // Column : Notes
            else if (I = IDX_COL_CUESHEET_NOTES) then
            begin
              Header := NAM_COL_CUESHEET_NOTES;
              Width  := WIDTH_COL_CUESHEET_NOTES;
              Editor := edNormal;
              EditMask := '';
            end;
          end;
        end;

//        DisplayPlayListGrid;
      finally
        Columns.EndUpdate;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

function TfrmPlaylist.MCCBeginUpdate: Integer;
begin
  Result := D_FALSE;

  PostMessage(Handle, WM_BEGIN_UPDATE, 0, 0);
  PostMessage(frmTimeline.Handle, WM_BEGIN_UPDATE, ChannelID, 0);

  Result := D_OK;
end;

function TfrmPlaylist.MCCEndUpdate: Integer;
begin
  Result := D_FALSE;

  PostMessage(Handle, WM_END_UPDATE, 0, 0);
  PostMessage(frmTimeline.Handle, WM_END_UPDATE, ChannelID, 0);

  Result := D_OK;
end;

function TfrmPlaylist.MCCSetOnAir(AIsOnAir: Boolean): Integer;
begin
  Result := D_FALSE;

  FChannelOnAir := AIsOnAir;

  PostMessage(Handle, WM_SET_ONAIR, ChannelID, NativeInt(AIsOnAir));
  PostMessage(frmTimeline.Handle, WM_SET_ONAIR, ChannelID, NativeInt(AIsOnAir));

  Result := D_OK;
end;

function TfrmPlaylist.MCCInputCueSheet(AIndex: Integer; ACueSheetItem: TCueSheetItem): Integer;
var
  Item: PCueSheetItem;
begin
  Result := D_FALSE;

  Item := GetCueSheetItemByID(ACueSheetItem.EventID);
  if (Item <> nil) then
  begin
    Move(ACueSheetItem, Item^, SizeOf(TCueSheetItem));
    Result := FCueSheetList.IndexOf(Item);

    PostMessage(Handle, WM_UPDATE_CUESHEET, Result, NativeInt(Item));
    PostMessage(frmTimeline.Handle, WM_UPDATE_CUESHEET, Result, NativeInt(Item));
  end
  else
  begin
    Item := New(PCueSheetItem);
    Move(ACueSheetItem, Item^, SizeOf(TCueSheetItem));
    FCueSheetList.Insert(AIndex, Item);

    PostMessage(Handle, WM_INSERT_CUESHEET, AIndex, NativeInt(Item));
    PostMessage(frmTimeline.Handle, WM_INSERT_CUESHEET, AIndex, NativeInt(Item));
  end;

  if (IsEqualEventID(Item^.EventID, FCueSheetCurrEventID)) then
    CueSheetCurr := Item;

  if (IsEqualEventID(Item^.EventID, FCueSheetNextEventID)) then
    CueSheetNext := Item;

  if (IsEqualEventID(Item^.EventID, FCueSheetTargetEventID)) then
    CueSheetTarget := Item;

  // Sort
//  EventQueueSort;

  Result := D_OK;
end;

function TfrmPlaylist.MCCDeleteCueSheet(AEventID: TEventID): Integer;
var
  Item: PCueSheetItem;
  Index: Integer;
begin
  Result := D_FALSE;

  Item := GetCueSheetItemByID(AEventID);
  if (Item <> nil) then
  begin
    Index := GetCueSheetIndexByItem(Item);

    PostMessage(Handle, WM_DELETE_CUESHEET, Index, NativeInt(Item));
    PostMessage(frmTimeline.Handle, WM_DELETE_CUESHEET, Index, NativeInt(Item));

    FCueSheetList.Remove(Item);
    Dispose(Item);
  end;

  Result := D_OK;
end;

function TfrmPlaylist.MCCClearCueSheet: Integer;
var
  I: Integer;
begin
  Result := D_FALSE;

  ClearCueSheetList;

  PostMessage(Handle, WM_CLEAR_CUESHEET, ChannelID, 0);
  PostMessage(frmTimeline.Handle, WM_CLEAR_CUESHEET, ChannelID, 0);

  Result := D_OK;
end;

function TfrmPlaylist.MCCSetCueSheetCurr(AEventID: TEventID): Integer;
begin
  Result := D_FALSE;

  CueSheetCurr := GetCueSheetItemByID(AEventID);
  FCueSheetCurrEventID := AEventID;

  Result := D_OK;
end;

function TfrmPlaylist.MCCSetCueSheetNext(AEventID: TEventID): Integer;
begin
  Result := D_FALSE;

  CueSheetNext := GetCueSheetItemByID(AEventID);
  FCueSheetNextEventID := AEventID;

  Result := D_OK;
end;

function TfrmPlaylist.MCCSetCueSheetTarget(AEventID: TEventID): Integer;
begin
  Result := D_FALSE;

  CueSheetTarget := GetCueSheetItemByID(AEventID);
  FCueSheetTargetEventID := AEventID;

  Result := D_OK;
end;

{ TTimelineTimerThread }

constructor TTimelineTimerThread.Create(APlaylistForm: TfrmPlaylist);
begin
  FPlaylistForm := APlaylistForm;

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TTimelineTimerThread.Destroy;
begin
  inherited Destroy;
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

    PostMessage(FPlaylistForm.Handle, WM_UPDATE_CHANNEL_TIME, 0, 0);

    PostMessage(FPlaylistForm.Handle, WM_UPDATE_ERROR_DISPLAY, 0, 0);

    if (frmTimeline <> nil) then
      PostMessage(frmTimeline.Handle, WM_UPDATE_ERROR_DISPLAY, 0, 0);

{    if (GV_SettingOption.AutoLoadCuesheet) then
    begin
      Inc(FPlaylistForm.FAutoLoadIntervalTime);
      if (FPlaylistForm.FAutoLoadIntervalTime > (TimecodeToMilliSec(GV_SettingOption.AutoLoadCuesheetInterval) div 1000)) then
        FPlaylistForm.FAutoLoadThread.AutoLoad;
    end;

    if (GV_SettingOption.AutoEjectCuesheet) then
    begin
      Inc(FPlaylistForm.FAutoEjectIntervalTime);
      if (FPlaylistForm.FAutoEjectIntervalTime > (TimecodeToMilliSec(GV_SettingOption.AutoEjectCuesheetInterval) div 1000)) then
        FPlaylistForm.FAutoEjectThread.AutoEject;
    end;

    Inc(FPlaylistForm.FMediaCheckIntervalTime);
    if (FPlaylistForm.FMediaCheckIntervalTime > (TimecodeToMilliSec(GV_SettingOption.MediaCheckInterval) div 1000)) then
      FPlaylistForm.FMediaCheckThread.MediaCheck; }
  end;
end;

end.
