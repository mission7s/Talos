unit UnitChannelEvents;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.SyncObjs, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, System.Types,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, AdvUtil, AdvObj, BaseGrid, AdvGrid, AdvCGrid,
  AdvOfficePager, WMTools, WMControls,
  UnitWorkForm, UnitCommons, UnitConsts, UnitDeviceThread;

type
  TChannelEventsTimerThread = class;
  TChannelEventsListCheckThread = class;

  TfrmChannelEvents = class(TfrmWork)
    acgEventList: TAdvColumnGrid;
    procedure acgEventListGetDisplText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acgEventListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure acgEventListGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
  private
    { Private declarations }
    FChannel: PChannel;
    FEventItemLock: TCriticalSection;
    FEventItemList: TEventItemList;
    FEventOnAirEventHighlightIndex: Integer;

    FEventsListCheckThread: TChannelEventsListCheckThread;
//    FEventsListCheckIntervalTime: Integer;

    FTimerThread: TChannelEventsTimerThread;

    function GetEventItemByID(AEventID: TEventID; ADevice: PDevice): PEventItem;
    function GetEventItemByIndex(AIndex: Integer): PEventItem;

    function GetEventItemIndexByID(AEventID: TEventID; ADevice: PDevice): Integer;
    function GetEventItemIndexByDateTime(ADateTime: TDateTime): Integer;

    procedure Initialize;
    procedure Finalize;

    procedure InitializeChannelEventListGrid;

    procedure UpdateEventItemList(AEventItemCount: Integer);

    procedure PopulateEventList(AIndex: Integer);
    procedure PopulateEventStatus(AIndex: Integer; AEventItem: PEventItem);

    procedure UpdateOnAirEventHighlight;

    procedure ClearEventItemList;

    procedure EventItemsQuickSort(L, R: Integer);

    procedure EventsListCheck;
  protected
//    procedure WndProc(var Message: TMessage); override;

    procedure WMInsertEvent(var Message: TMessage); message WM_INSERT_EVENT;
    procedure WMUpdateEvent(var Message: TMessage); message WM_UPDATE_EVENT;
    procedure WMDeleteEvent(var Message: TMessage); message WM_DELETE_EVENT;
    procedure WMClearEvent(var Message: TMessage); message WM_CLEAR_EVENT;
    procedure WMUpdateEventStatus(var Message: TMessage); message WM_UPDATE_EVENT_STATUS;
    procedure WMExecuteEventListCheckEvent(var Message: TMessage); message WM_EXECUTE_EVENT_LIST_CHECK;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AChannel: PChannel; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer); overload;

    function InputEvent(AHostIP: AnsiString; AEvent: PEvent; ADevice: PDevice): Integer;
    function DeleteEvent(AEvent: PEvent; ADevice: PDevice): Integer;
    function ClearEvent(ADevice: PDevice): Integer;
    function TakeEvent(AEventNext, AEventCurr: PEvent; ADevice: PDevice): Integer;
    function HoldEvent(AEvent: PEvent; ADevice: PDevice): Integer;
    function ChangeDurationEvent(AEvent: PEvent; ADevice: PDevice): Integer;
    function GetOnAirEventID(AHostIP: AnsiString; var AEventID: TEventID): Integer;

    procedure SetEventStatus(AThread: TDeviceThread; AEvent: PEvent; AState: TEventState; AErrorCode: Integer = E_NO_ERROR);

    procedure ResetStartTime(AEvent: PEvent; ADevice: PDevice);

    procedure EventItemsSort;

    property EventItemList: TEventItemList read FEventItemList;
  end;

  TChannelEventsTimerThread = class(TThread)
  private
    FChannelEventsForm: TfrmChannelEvents;
  protected
    procedure Execute; override;
  public
    constructor Create(AChannelEventsForm: TfrmChannelEvents);
    destructor Destroy; override;
  end;

  TChannelEventsListCheckThread = class(TThread)
  private
    FChannelEventsForm: TfrmChannelEvents;

    FEventsListCheckEvent: THandle;
    FCloseEvent: THandle;
  protected
    procedure DoEventsListCheck;

    procedure Execute; override;
  public
    constructor Create(AChannelEventsForm: TfrmChannelEvents);
    destructor Destroy; override;

    procedure Terminate;
    procedure EventsListCheck;
  end;

var
  frmChannelEvents: TfrmChannelEvents;

implementation

uses Math;

{$R *.dfm}

procedure TfrmChannelEvents.WMInsertEvent(var Message: TMessage);
var
  EventCount: Integer;
begin
  EventCount := Message.LParam;
  UpdateEventItemList(EventCount);
end;

procedure TfrmChannelEvents.WMUpdateEvent(var Message: TMessage);
var
  Index: Integer;
  E: PEventItem;
begin
  Index := Message.WParam;
  E := PEventItem(Message.LParam);

  PopulateEventList(Index);
end;

procedure TfrmChannelEvents.WMDeleteEvent(var Message: TMessage);
var
  EventCount: Integer;
begin
  EventCount := Message.LParam;
  UpdateEventItemList(EventCount);
end;

procedure TfrmChannelEvents.WMClearEvent(var Message: TMessage);
var
  EventCount: Integer;
begin
  EventCount := Message.LParam;
  UpdateEventItemList(EventCount);
end;

procedure TfrmChannelEvents.WMUpdateEventStatus(var Message: TMessage);
var
  Index: Integer;
  E: PEventItem;
begin
  Index := Message.WParam;
  E := PEventItem(Message.LParam);

  PopulateEventStatus(Index, E);
end;

procedure TfrmChannelEvents.WMExecuteEventListCheckEvent(var Message: TMessage);
begin
  EventsListCheck;
end;

{procedure TfrmChannelEvents.WndProc(var Message: TMessage);
var
  ChannelID: Word;
  ChannelEventCount: Integer;
  Index: Integer;
  Event: PEvent;
begin
  inherited;
  case Message.Msg of
    WM_INSERT_EVENT:
    begin
      ChannelID := Message.WParam;
      ChannelEventCount := Message.LParam;

      UpdateEventItemList(ChannelEventCount);
    end;
    WM_UPDATE_EVENT:
    begin
      Index := Message.WParam;
      Event := PEvent(Message.LParam);

      PopulateEventList(Index, Event);
    end;
    WM_DELETE_EVENT:
    begin
      ChannelID := Message.WParam;
      ChannelEventCount := Message.LParam;

      UpdateEventItemList(ChannelEventCount);
    end;
    WM_CLEAR_EVENT:
    begin
      ChannelID := Message.WParam;
      ChannelEventCount := Message.LParam;

      UpdateEventItemList(ChannelEventCount);
    end;
    WM_EXECUTE_EVENT_LIST_CHECK:
    begin
      EventsListCheck;
    end;
  end;
end; }

procedure TfrmChannelEvents.SetEventStatus(AThread: TDeviceThread; AEvent: PEvent; AState: TEventState; AErrorCode: Integer);
var
  Index: Integer;
  E: PEventItem;
begin
  if (AEvent = nil) then exit;

  FEventItemLock.Enter;
  try

  {  AEvent^.Status.State      := AState;
    AEvent^.Status.ErrorCode  := AErrorCode;
    AEvent^.TakeEvent         := (AState = esOnAir); }

    Index := GetEventItemIndexByID(AEvent^.EventID, AThread.Device);
    if (Index >= 0) then
    begin
      E := GetEventItemByIndex(Index);
      if (E <> nil) then
      begin
        Move(AEvent^.Status, E^.Event.Status, SizeOf(TEventStatus));
    //    E^.Event.Status.State      := AState;
    //    E^.Event.Status.ErrorCode  := AErrorCode;
    //    E^.Event.TakeEvent         := (AState = esOnAir);

    {    if (AThread <> nil) then
        begin
    //        AThread.ControlBy := String(FEventItemList[Index].ControlIP);

          AThread.ControlChannel := FChannelID;
        end;}
        PostMessage(Handle, WM_UPDATE_EVENT_STATUS, Index, NativeInt(E));
      end;
    end;
  finally
    FEventItemLock.Leave;
  end;
end;

procedure TfrmChannelEvents.ResetStartTime(AEvent: PEvent; ADevice: PDevice);
var
  Index: Integer;
  E: PEventItem;
begin
  if (AEvent = nil) then exit;

  FEventItemLock.Enter;
  try
    Index := GetEventItemIndexByID(AEvent^.EventID, ADevice);
    if (Index >= 0) then
    begin
        E := GetEventItemByIndex(Index);
        Move(AEvent^, E^.Event, SizeOf(TEvent));

      PostMessage(Handle, WM_UPDATE_EVENT, Index, NativeInt(E));
    end;
  finally
    FEventItemLock.Leave;
  end;
end;

constructor TfrmChannelEvents.Create(AOwner: TComponent; AChannel: PChannel; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited Create(AOwner, ACombine, ALeft, ATop, AWidth, AHeight);

  FChannel := AChannel;
end;

procedure TfrmChannelEvents.Initialize;
begin
  FEventItemLock := TCriticalSection.Create;

  FEventItemList := TEventItemList.Create;

  FEventOnAirEventHighlightIndex := -1;

  InitializeChannelEventListGrid;

//  FEventsListCheckIntervalTime := 0;
  FEventsListCheckThread := TChannelEventsListCheckThread.Create(Self);
  FEventsListCheckThread.Start;

  FTimerThread := TChannelEventsTimerThread.Create(Self);
  FTimerThread.Start;
end;

procedure TfrmChannelEvents.Finalize;
begin
  if (FTimerThread <> nil) then
  begin
    FTimerThread.Terminate;
    FTimerThread.WaitFor;
    FreeAndNil(FTimerThread);
  end;

  if (FEventsListCheckThread <> nil) then
  begin
    FEventsListCheckThread.Terminate;
    FEventsListCheckThread.WaitFor;
    FreeAndNil(FEventsListCheckThread);
  end;

  ClearEventItemList;

  FreeAndNil(FEventItemList);

  FreeAndNil(FEventItemLock);
end;

procedure TfrmChannelEvents.FormCreate(Sender: TObject);
begin
  inherited;
  Initialize;
end;

procedure TfrmChannelEvents.FormDestroy(Sender: TObject);
begin
  inherited;
  Finalize;
end;

procedure TfrmChannelEvents.InitializeChannelEventListGrid;
var
  I: Integer;
  Column: TGridColumnItem;
begin
  with acgEventList do
  begin
    BeginUpdate;
    try
      FixedRows := CNT_EVENT_HEADER;
      RowCount  := CNT_EVENT_HEADER + 1;
      ColCount  := CNT_EVENT_COLUMNS;

      Columns.BeginUpdate;
      try
        Columns.Clear;
        for I := 0 to CNT_EVENT_COLUMNS - 1 do
        begin
          Column := Columns.Add;
          with Column do
          begin
            HeaderFont.Assign(acgEventList.FixedFont);
            Font.Assign(acgEventList.Font);

            // Column : No
            if (I = IDX_COL_EVENT_NO) then
            begin
              Alignment := taLeftJustify;
              Header    := NAM_COL_EVENT_NO;
              HeaderAlignment := taCenter;
              ReadOnly  := True;
              Width     := WIDTH_COL_EVENT_NO;
            end
            // Column : Start Type
            else if (I = IDX_COL_EVENT_START_TYPE) then
            begin
              Alignment := taLeftJustify;
              Header    := NAM_COL_EVENT_START_TYPE;
              ReadOnly  := True;
              Width     := WIDTH_COL_EVENT_START_TYPE;
            end
            // Column : Start Time
            else if (I = IDX_COL_EVENT_START_TIME) then
            begin
              Header    := NAM_COL_EVENT_START_TIME;
              ReadOnly  := True;
              Width     := WIDTH_COL_EVENT_START_TIME;
            end
            // Column : Duration
            else if (I = IDX_COL_EVENT_DURATON) then
            begin
              Header := NAM_COL_EVENT_DURATON;
              ReadOnly  := True;
              Width  := WIDTH_COL_EVENT_DURATON;
            end
            // Column : Status
            else if (I = IDX_COL_EVENT_STATUS) then
            begin
              Header := NAM_COL_EVENT_STATUS;
              ReadOnly  := True;
              Width  := WIDTH_COL_EVENT_STATUS;
            end
            // Column : Title
            else if (I = IDX_COL_EVENT_SOURCE) then
            begin
              Header := NAM_COL_EVENT_SOURCE;
              ReadOnly  := True;
              Width  := WIDTH_COL_EVENT_SOURCE;
            end
            // Column : Media ID
            else if (I = IDX_COL_EVENT_MEADIA_ID) then
            begin
              Header := NAM_COL_EVENT_MEDIA_ID;
              ReadOnly  := True;
              Width  := WIDTH_COL_EVENT_MEADIA_ID;
            end
            // Column : In TC
            else if (I = IDX_COL_EVENT_START_TC) then
            begin
              Header := NAM_COL_EVENT_START_TC;
              ReadOnly  := True;
              Width  := WIDTH_COL_EVENT_START_TC;
            end
            // Column : Notes
            else if (I = IDX_COL_EVENT_NOTES) then
            begin
              Header := NAM_COL_EVENT_NOTES;
              ReadOnly  := True;
              Width  := WIDTH_COL_EVENT_NOTES;
            end;
          end;
        end;
      finally
        Columns.EndUpdate;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfrmChannelEvents.UpdateEventItemList(AEventItemCount: Integer);
begin
  with acgEventList do
  begin
//    BeginUpdate;
    try
      RowCount := AEventItemCount + CNT_EVENT_HEADER + 1;
    finally
//      EndUpdate;
    end;
  end;
end;

procedure TfrmChannelEvents.PopulateEventList(AIndex: Integer);
var
  R, T: Integer;
begin
//  acgEventList.Repaint;
//  exit;

  if (FEventItemList = nil) then exit;
  if (AIndex < 0) or (AIndex > FEventItemList.Count - 1) then exit;

  with acgEventList do
  begin
//    R := RealRowIndex(AIndex + CNT_EVENT_HEADER);
    R := DisplRowIndex(AIndex + CNT_EVENT_HEADER);
    if (InRange(R, TopRow, TopRow + VisibleRowCount - 1)) then
      RepaintRow(R);
  end;
end;

procedure TfrmChannelEvents.PopulateEventStatus(AIndex: Integer; AEventItem: PEventItem);
var
  R, T: Integer;
  I: Integer;
begin
  if (FEventItemList = nil) then exit;
  if (AIndex < 0) or (AIndex > FEventItemList.Count - 1) then exit;
  if (AEventItem = nil) then exit;

  with acgEventList do
  begin
//    R := RealRowIndex(AIndex + CNT_EVENT_HEADER);
    R := DisplRowIndex(AIndex + CNT_EVENT_HEADER);
    if (GV_ConfigOption.OnAirEventHighlight) and (AEventItem^.Event.Status.State in [esCueing, esCued, esOnAir]) then
    begin
{      if (FEventOnAirEventHighlightIndex >= 0) then
        R := DisplRowIndex(FEventOnAirEventHighlightIndex + CNT_EVENT_HEADER)
      else
        FEventOnAirEventHighlightIndex := -1;

      T := R - GV_ConfigOption.OnAirEventFixedRow;
      if (T >= FixedRows) then
        TopRow := T
      else
        TopRow := FixedRows; }

      UpdateOnAirEventHighlight;
    end
    else if (InRange(R, TopRow, TopRow + VisibleRowCount - 1)) then
      RepaintRow(R);
  end;

exit;

  with acgEventList do
  begin
//    R := RealRowIndex(AIndex + CNT_EVENT_HEADER);
    R := DisplRowIndex(AIndex + CNT_EVENT_HEADER);
    if (GV_ConfigOption.OnAirEventHighlight) and (AEventItem^.Event.Status.State in [esCueing, esCued, esOnAir]) then
    begin
      T := R - GV_ConfigOption.OnAirEventFixedRow;
      if (T >= FixedRows) then
        TopRow := T
      else
        TopRow := FixedRows;

      MouseActions.DisjunctRowSelect := False;
      ClearRowSelect;
      MouseActions.DisjunctRowSelect := True;
      SelectRows(R, 1);
      Row := R;
    end
    else if (InRange(R, TopRow, TopRow + VisibleRowCount - 1)) then
      RepaintRow(R);
  end;
end;

procedure TfrmChannelEvents.UpdateOnAirEventHighlight;
var
  R, T: Integer;
  I: Integer;
begin
  with acgEventList do
  begin
    I := GetEventItemIndexByDateTime(SystemTimeToDateTime(GV_TimeCurrent));
    if (I >= 0) then
    begin
      R := DisplRowIndex(I + CNT_EVENT_HEADER);

      T := R - GV_ConfigOption.OnAirEventFixedRow;
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

procedure TfrmChannelEvents.acgEventListDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  inherited;

  with (Sender as TAdvColumnGrid) do
  begin
    if not (gdFixed in State) and
       (((gdSelected in State) or (gdRowSelected in State)) or
        (RowSelect[ARow])) then
    begin
      Canvas.Brush.Style := bsClear;
      Canvas.Pen.Color := COLOR_ROW_SELECT_EVENT;//$00FFBDAD;//clRed;

      Canvas.MoveTo(Rect.Left, Rect.Top);
      Canvas.LineTo(Rect.Right + 1, Rect.Top);

      Canvas.MoveTo(Rect.Left, Rect.Bottom - 1);
      Canvas.LineTo(Rect.Right + 1, Rect.Bottom - 1);

//      SetTextColor(Canvas.Handle, clWhite);

      if (ACol = FixedCols) then
      begin
        Canvas.MoveTo(Rect.Left, Rect.Top);
        Canvas.LineTo(Rect.Left, Rect.Bottom);

        if (IsMergedCell(ACol, ARow)) then
        begin
          Canvas.MoveTo(Rect.Right, Rect.Top);
          Canvas.LineTo(Rect.Right, Rect.Bottom);
        end;
      end
      else if (ACol = ColCount - 1) then //or (IsMergedCell(ACol, ARow)) then
      begin
        Canvas.MoveTo(Rect.Right, Rect.Top);
        Canvas.LineTo(Rect.Right, Rect.Bottom);
      end;
    end
    else
    begin
//      SetTextColor(Canvas.Handle, Font.Color);
    end;
  end;
end;

procedure TfrmChannelEvents.acgEventListGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  RCol, RRow: Integer;
  E: PEventItem;
begin
  inherited;

  if (FEventItemList = nil) then exit;

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if ((gdSelected in AState) or (gdRowSelected in AState)) or
       (RowSelect[RRow]) then
    begin
      AFont.Color := COLOR_BK_EVENTSTATUS_NORMAL;
      AFont.Color := clWhite;
    end;

    FEventItemLock.Enter;
    try
      E := GetEventItemByIndex(RRow - CNT_EVENT_HEADER);
      if (E <> nil) then
      begin
        case E^.Event.Status.State of
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
            ABrush.Color := COLOR_BK_EVENTSTATUS_ERROR;
            AFont.Color  := COLOR_TX_EVENTSTATUS_ERROR;
          end;
        else
          ABrush.Color := COLOR_BK_EVENTSTATUS_NORMAL;
          if (not (gdSelected in AState) and (not (gdRowSelected in AState))) and
             (not (RowSelect[RRow])) then
          begin
            AFont.Color  := COLOR_TX_EVENTSTATUS_NORMAL;
          end;
        end;
      end;
    finally
      FEventItemLock.Leave;
    end;
  end;
end;

procedure TfrmChannelEvents.acgEventListGetDisplText(Sender: TObject; ACol,
  ARow: Integer; var Value: string);
var
  E: PEventItem;
  R: Integer;
begin
  inherited;

  with (Sender as TAdvColumnGrid) do
  begin
    if (ARow < FixedRows) or (ACol < FixedCols) then exit;

    R := RealRowIndex(ARow);

    FEventItemLock.Enter;
    try
      E := GetEventItemByIndex(R - FixedRows);
      if (E <> nil) then
      begin
        if (ACol = IDX_COL_EVENT_NO) then
        begin
          Value := Format('%d', [R]);
        end
        else if (ACol = IDX_COL_EVENT_START_TYPE) then
        begin
          if (E^.Event.ManualEvent) then Value := 'Manual'
          else Value := 'Auto';
        end
        else if (ACol = IDX_COL_EVENT_START_TIME) then
        begin
          Value := EventTimeToDateTimecodeStr(E^.Event.StartTime, FChannel^.FrameRateType, True);//   FormatDateTime(FormatSettings.ShortDateFormat + ' hh:nn:ss', EventTimeToDateTime(P^.Event^.StartTime));
        end
        else if (ACol = IDX_COL_EVENT_DURATON) then
        begin
          Value := TimecodeToString(E^.Event.DurTime, (FChannel^.FrameRateType in [FR_29_97_DF, FR_59_94_DF]));
        end
        else if (ACol = IDX_COL_EVENT_STATUS) then
        begin
          Value := EventStatusNames[E^.Event.Status.State]
        end
        else if (ACol = IDX_COL_EVENT_SOURCE) then
        begin
          if (E^.Device <> nil) then
            Value := E^.Device^.Name
          else
            Value := '';
        end
        else if (ACol = IDX_COL_EVENT_MEADIA_ID) then
        begin
          case E^.Event.EventType of
            ET_PLAYER: Value := String(E^.Event.Player.ID.ID);
            else
              Value := '';
          end;
        end
        else if (ACol = IDX_COL_EVENT_START_TC) then
        begin
          case E^.Event.EventType of
            ET_PLAYER: Value := TimecodeToString(E^.Event.Player.StartTC, (FChannel^.FrameRateType in [FR_29_97_DF, FR_59_94_DF]));
            else
              Value := '';
          end;
        end
        else if (ACol = IDX_COL_EVENT_NOTES) then
        begin
          Value := '';
        end;
      end;
    finally
      FEventItemLock.Leave;
    end;
  end;
end;

procedure TfrmChannelEvents.ClearEventItemList;
var
  I: Integer;
  E: PEventItem;
begin
  FEventItemLock.Enter;
  try
    for I := FEventItemList.Count - 1 downto 0 do
    begin
      E := FEventItemList[I];
      if (E <> nil) then
        Dispose(E);
    end;

    FEventItemList.Clear;
  finally
    FEventItemLock.Leave;
  end;
end;

procedure TfrmChannelEvents.EventItemsQuickSort(L, R: Integer);
var
  I, J, P: Integer;
  Save: PEventItem;
  SortList: TEventItemList;

  function Compare(Item1, Item2: PEventItem): Integer;
  var
    ID1, ID2: String;
  begin
    Result := CompareEventTime(Item1^.Event.StartTime, Item2^.Event.StartTime, FChannel^.FrameRateType);
    if (Result = EqualsValue) then
    begin
      if (Item1^.Event.DurTime = Item2^.Event.DurTime) then
        Result := EqualsValue
      else if (Item1^.Event.DurTime < Item2^.Event.DurTime) then
        Result := LessThanValue
      else
        Result := GreaterThanValue;

      if (Result = EqualsValue) then
      begin
        if (Item1^.Event.EventType = Item2^.Event.EventType) then
          Result := EqualsValue
        else if (Item1^.Event.EventType > Item2^.Event.EventType) then
          Result := LessThanValue
        else
          Result := GreaterThanValue;
      end;

      if (Result = EqualsValue) then
      begin
        if (Item1^.Device <> nil) and (Item2^.Device <> nil) then
        begin
          if (Item1^.Device^.Handle = Item2^.Device^.Handle) then
            Result := EqualsValue
          else if (Item1^.Device^.Handle < Item2^.Device^.Handle) then
            Result := LessThanValue
          else
            Result := GreaterThanValue;
        end;
      end;
    end;

    exit;
    Result := CompareEventTime(Item1^.Event.StartTime, Item2^.Event.StartTime, FChannel^.FrameRateType);
    if (Result = EqualsValue) then
    begin
      ID1 := EventIDToString(Item1^.Event.EventID);
      ID2 := EventIDToString(Item2^.Event.EventID);

      if (ID1 = ID2) then
        Result := EqualsValue
      else if (ID1 < ID2) then
        Result := LessThanValue
      else
        Result := GreaterThanValue;

      if (Result = EqualsValue) then
      begin
        if (Item1^.Device <> nil) and (Item2^.Device <> nil) then
        begin
          if (Item1^.Device^.Handle = Item2^.Device^.Handle) then
            Result := EqualsValue
          else if (Item1^.Device^.Handle < Item2^.Device^.Handle) then
            Result := LessThanValue
          else
            Result := GreaterThanValue;
        end;
      end;
    end;
  end;

begin
  FEventItemLock.Enter;
  try
    SortList := FEventItemList;
    repeat
      I := L;
      J := R;
      P := (L + R) shr 1;
      repeat
        while Compare(FEventItemList[I], FEventItemList[P]) < 0 do
          Inc(I);
        while Compare(FEventItemList[J], FEventItemList[P]) > 0 do
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
        EventItemsQuickSort(L, J);
      L := I;
    until I >= R;
  finally
    FEventItemLock.Leave;
  end;
end;

procedure TfrmChannelEvents.EventsListCheck;
var
  CheckCount: Integer;
  DeleteCount: Integer;
  I: Integer;

  E: PEventItem;
  BaseDateTime: TDateTime;
  EventEndTime: TDateTime;

  RemoveItemList: TIntList;
begin
  Assert(False, GetLogCommonStr(lsNormal, Format('Start delete event list item check. channel = %d', [FChannel^.ID])));

  // 지정된 시각 이전 종료된 이벤트 삭제
  BaseDateTime := SystemTimeToDateTime(GV_TimeCurrent);


  FEventItemLock.Enter;
  RemoveItemList := TIntList.Create(-1, -1);
  try
    for I := 0 to FEventItemList.Count - 1 do
    begin
      E := FEventItemList[I];
      if (E <> nil) then
      begin
        EventEndTime := EventTimeToDateTime(GetEventEndTime(E^.Event.StartTime, E^.Event.DurTime, FChannel^.FrameRateType), FChannel^.FrameRateType);

        if (EventEndTime < BaseDateTime) and (DateTimeToTimecode(BaseDateTime - EventEndTime, FChannel^.FrameRateType) > GV_ConfigOption.EventListCheckTime) then
        begin
          RemoveItemList.Add(I);
        end
        else
          break;
      end;
    end;

    Assert(False, GetLogCommonStr(lsNormal, Format('Check delete event list item count. channel = %d, delete count = %d', [FChannel^.ID, RemoveItemList.Count])));

    // Delete rows & EventItem
    if (RemoveItemList.Count > 0) then
    begin
      for I := RemoveItemList.Count - 1 downto 0 do
      begin
        E := FEventItemList[RemoveItemList[I]];
        FEventItemList.Remove(E);
        Dispose(E);
      end;

      UpdateEventItemList(FEventItemList.Count);
      if (GV_ConfigOption.OnAirEventHighlight) then
        UpdateOnAirEventHighlight;

      Dec(FEventOnAirEventHighlightIndex, RemoveItemList.Count);

      Assert(False, GetLogCommonStr(lsNormal, Format('Execute delete event list item. channel = %d, delete count = %d, remain count = %d', [FChannel^.ID, RemoveItemList.Count, FEventItemList.Count])));
    end;
  finally
    FreeAndNil(RemoveItemList);
    FEventItemLock.Leave;

    Assert(False, GetLogCommonStr(lsNormal, Format('Finished delete event list item check. channel = %d', [FChannel^.ID])));
  end;

//  FEventsListCheckIntervalTime := 0;
end;

procedure TfrmChannelEvents.EventItemsSort;
begin
  if (FEventItemList.Count > 1) then EventItemsQuickSort(0, pred(FEventItemList.Count));
end;

function TfrmChannelEvents.GetEventItemByID(AEventID: TEventID; ADevice: PDevice): PEventItem;
var
  I: Integer;
  E: PEventItem;
begin
  Result := nil;

  FEventItemLock.Enter;
  try
    for I := 0 to FEventItemList.Count - 1 do
    begin
      E := FEventItemList[I];
      if (E <> nil) and (IsEqualEventID(E^.Event.EventID, AEventID)) and
         (E^.Device = ADevice) then
      begin
        Result := E;
        break;
      end;
    end;
  finally
    FEventItemLock.Leave;
  end;
end;

function TfrmChannelEvents.GetEventItemByIndex(AIndex: Integer): PEventItem;
begin
  Result := nil;
  if (AIndex < 0) or (AIndex > FEventItemList.Count - 1) then exit;

  FEventItemLock.Enter;
  try
    Result := FEventItemList[AIndex];
  finally
    FEventItemLock.Leave;
  end;
end;

function TfrmChannelEvents.GetEventItemIndexByID(AEventID: TEventID; ADevice: PDevice): Integer;
var
  I: Integer;
  E: PEventItem;
begin
  Result := -1;

  FEventItemLock.Enter;
  try
    for I := 0 to FEventItemList.Count - 1 do
    begin
      E := FEventItemList[I];
      if (E <> nil) and (IsEqualEventID(E^.Event.EventID, AEventID)) and
         (E^.Device = ADevice) then
      begin
        Result := I;
        break;
      end;
    end;
  finally
    FEventItemLock.Leave;
  end;
end;

function TfrmChannelEvents.GetEventItemIndexByDateTime(ADateTime: TDateTime): Integer;
var
  I: Integer;
  E: PEventItem;
  S: TEventTime;
begin
  Result := -1;

  S := DateTimeToEventTime(ADateTime, FChannel^.FrameRateType);
  FEventItemLock.Enter;
  try
    for I := 0 to FEventItemList.Count - 1 do
    begin
      E := FEventItemList[I];
      if (E <> nil) and (CompareEventTime(E^.Event.StartTime, S, FChannel^.FrameRateType) >= 0) then
      begin
        Result := I;
        break;
      end;
    end;
  finally
    FEventItemLock.Leave;
  end;
end;

function TfrmChannelEvents.InputEvent(AHostIP: AnsiString; AEvent: PEvent; ADevice: PDevice): Integer;
var
  E: PEventItem;

  procedure PopulateItem(AItem: PEventItem);
  begin
    FillChar(AItem^, SizeOf(TEventItem), #0);
    StrPLCopy(AItem^.ControlIP, AHostIP, HOSTIP_LEN);
    Move(AEvent^, AItem^.Event, SizeOf(TEvent));
    AItem^.Device := ADevice;
  end;

begin
  FEventItemLock.Enter;
  try
    E := GetEventItemByID(AEvent^.EventID, ADevice);
    if (E <> nil) then
    begin
      PopulateItem(E);
      Result := FEventItemList.IndexOf(E);

      // Sort
      EventItemsSort;

      PostMessage(Handle, WM_UPDATE_EVENT, Result, NativeInt(@E^.Event));
    end
    else
    begin
      E := New(PEventItem);
      PopulateItem(E);
      Result := FEventItemList.Add(E);

      // Sort
      EventItemsSort;

      PostMessage(Handle, WM_INSERT_EVENT, FChannel^.ID, FEventItemList.Count);
    end;
  finally
    FEventItemLock.Leave;
  end;
end;

function TfrmChannelEvents.DeleteEvent(AEvent: PEvent; ADevice: PDevice): Integer;
var
  E: PEventItem;
begin
  Result := -1;

  FEventItemLock.Enter;
  try
    E := GetEventItemByID(AEvent^.EventID, ADevice);
    if (E <> nil) then
    begin
      Result := FEventItemList.Remove(E);
      Dispose(E);

      PostMessage(Handle, WM_DELETE_EVENT, AEvent^.EventID.ChannelID, FEventItemList.Count);
    end;
  finally
    FEventItemLock.Leave;
  end;
end;

function TfrmChannelEvents.ClearEvent(ADevice: PDevice): Integer;
var
  I: Integer;
  E: PEventItem;
begin
  Result := D_FALSE;

  FEventItemLock.Enter;
  try
    for I := FEventItemList.Count - 1 downto 0 do
    begin
      E := FEventItemList[I];
      if (E <> nil) and (E^.Device = ADevice) then
      begin
        FEventItemList.Delete(I);
        Dispose(E);
      end;
    end;

    PostMessage(Handle, WM_CLEAR_EVENT, FChannel^.ID, FEventItemList.Count);
  finally
    FEventItemLock.Leave;
  end;

  Result := D_OK;
end;

function TfrmChannelEvents.TakeEvent(AEventNext, AEventCurr: PEvent; ADevice: PDevice): Integer;
var
  E: PEventItem;
begin
  Result := -1;

  if (AEventNext <> nil) then
  begin
    FEventItemLock.Enter;
    try
      E := GetEventItemByID(AEventNext^.EventID, ADevice);
      if (E <> nil) then
      begin
//        E^.Event := AEventNext;
        Move(AEventNext^, E^.Event, SizeOf(TEvent));
        Result := FEventItemList.IndexOf(E);

        PostMessage(Handle, WM_UPDATE_EVENT, Result, NativeInt(E));
      end;
    finally
      FEventItemLock.Leave;
    end;
  end;

  if (AEventCurr <> nil) then
  begin
    FEventItemLock.Enter;
    try
      E := GetEventItemByID(AEventCurr^.EventID, ADevice);
      if (E <> nil) then
      begin
//        E^.Event := AEventCurr;
        Move(AEventCurr^, E^.Event, SizeOf(TEvent));
        Result := FEventItemList.IndexOf(E);

        PostMessage(Handle, WM_UPDATE_EVENT, Result, NativeInt(E));
      end;
    finally
      FEventItemLock.Leave;
    end;
  end;
end;

function TfrmChannelEvents.HoldEvent(AEvent: PEvent; ADevice: PDevice): Integer;
var
  E: PEventItem;
begin
  Result := -1;

  if (AEvent <> nil) then
  begin
    FEventItemLock.Enter;
    try
      E := GetEventItemByID(AEvent^.EventID, ADevice);
      if (E <> nil) then
      begin
//        E^.Event := AEvent;
        Move(AEvent^, E^.Event, SizeOf(TEvent));
        Result := FEventItemList.IndexOf(E);

        PostMessage(Handle, WM_UPDATE_EVENT, Result, NativeInt(@E^.Event));
      end;
    finally
      FEventItemLock.Leave;
    end;
  end;
end;

function TfrmChannelEvents.ChangeDurationEvent(AEvent: PEvent; ADevice: PDevice): Integer;
var
  E: PEventItem;
begin
  Result := -1;

  if (AEvent <> nil) then
  begin
    FEventItemLock.Enter;
    try
      E := GetEventItemByID(AEvent^.EventID, ADevice);
      if (E <> nil) then
      begin
//        E^.Event := AEvent;
        Move(AEvent^, E^.Event, SizeOf(TEvent));
        Result := FEventItemList.IndexOf(E);

        PostMessage(Handle, WM_UPDATE_EVENT, Result, NativeInt(@E^.Event));
      end;
    finally
      FEventItemLock.Leave;
    end;
  end;
end;

function TfrmChannelEvents.GetOnAirEventID(AHostIP: AnsiString; var AEventID: TEventID): Integer;
var
  I: Integer;
  E: PEventItem;
begin
  Result := D_FALSE;

  FillChar(AEventID, SizeOf(TEventID), #0);

  FEventItemLock.Enter;
  try
    for I := 0 to FEventItemList.Count - 1 do
    begin
      E := FEventItemList[I];
      if (E <> nil) then
      begin
        if //(E^.Event <> nil) and
           (E^.Event.EventType = ET_PLAYER) and
           (E^.Event.TakeEvent) then
        begin
          AEventID := E^.Event.EventID;

          Result := D_OK;
          break;
        end;
      end;
    end;
  finally
    FEventItemLock.Leave;
  end;
end;

{ TChannelEventsTimerThread }

constructor TChannelEventsTimerThread.Create(AChannelEventsForm: TfrmChannelEvents);
begin
  FChannelEventsForm := AChannelEventsForm;

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TChannelEventsTimerThread.Destroy;
begin
  inherited Destroy;
end;

procedure TChannelEventsTimerThread.Execute;
var
  WaitList: array[0..1] of THandle;
begin
  WaitList[0] := GV_TimerExecuteEvent;
  WaitList[1] := GV_TimerCancelEvent;
  while not Terminated do
  begin
    if (WaitForMultipleObjects(2, @WaitList, False, INFINITE) <> WAIT_OBJECT_0) then
      break; // Terminate thread when GV_TimerCancelEvent is signaled

{    Inc(FChannelEventsForm.FEventsListCheckIntervalTime);
    if (FChannelEventsForm.FEventsListCheckIntervalTime > (TimecodeToMilliSec(GV_ConfigOption.EventListCheckInterval) div 1000)) then
      FChannelEventsForm.FEventsListCheckThread.EventsListCheck; }
  end;
end;

{ TChannelEventsListCheckThread }

constructor TChannelEventsListCheckThread.Create(AChannelEventsForm: TfrmChannelEvents);
begin
  FChannelEventsForm := AChannelEventsForm;

  FEventsListCheckEvent := CreateEvent(nil, True, False, nil);
  FCloseEvent := CreateEvent(nil, True, False, nil);

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TChannelEventsListCheckThread.Destroy;
begin
  CloseHandle(FEventsListCheckEvent);
  CloseHandle(FCloseEvent);

  inherited Destroy;
end;

procedure TChannelEventsListCheckThread.Terminate;
begin
  inherited Terminate;

  ResetEvent(FEventsListCheckEvent);
  SetEvent(FCloseEvent);
end;

procedure TChannelEventsListCheckThread.EventsListCheck;
begin
  SetEvent(FEventsListCheckEvent);
end;

procedure TChannelEventsListCheckThread.DoEventsListCheck;
begin
  ResetEvent(FEventsListCheckEvent);

  PostMessage(FChannelEventsForm.Handle, WM_EXECUTE_EVENT_LIST_CHECK, 0, 0);
end;

procedure TChannelEventsListCheckThread.Execute;
var
  R: Cardinal;
  WaitList: array[0..1] of THandle;
begin
  WaitList[0] := FCloseEvent;
  WaitList[1] := FEventsListCheckEvent;
  while not Terminated do
  begin
    R := WaitForMultipleObjects(2, @WaitList, False, TimecodeToMilliSec(GV_ConfigOption.EventListCheckInterval, FR_30));
    case R of
      WAIT_OBJECT_0: break;
      else
        DoEventsListCheck;
    end;
  end;

{  WaitList[0] := FEventsListCheckEvent;
  WaitList[1] := FCloseEvent;
  while not Terminated do
  begin
    R := WaitForMultipleObjects(2, @WaitList, False, INFINITE);
    case R of
      WAIT_OBJECT_0: DoEventsListCheck;
      WAIT_OBJECT_0 + 1: break;
    end;
  end; }
end;

end.
