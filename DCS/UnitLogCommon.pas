unit UnitLogCommon;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitWorkForm, AdvUtil, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, AdvCGrid, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  AdvOfficePager, WMTools, WMControls,
  UnitCommons, UnitConsts, UnitDeviceThread;

type
  TLogCommonCheckThread = class;

  TfrmLogCommon = class(TfrmWork)
    acgLogCommonList: TAdvColumnGrid;
    procedure acgLogCommonListGetDisplText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acgLogCommonListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure acgLogCommonListGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
  private
    { Private declarations }
    FLogCommonCheckThread: TLogCommonCheckThread;

    procedure Initialize;
    procedure Finalize;

    procedure InitializeCommonLogListGrid;
  protected
//    procedure WndProc(var Message: TMessage); override;

    procedure WMAddLogCommon(var Message: TMessage); message WM_ADD_LOG_COMMON;
    procedure WMExecuteLogCommonListCheck(var Message: TMessage); message WM_EXECUTE_LOG_COMMON_LIST_CHECK;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer); overload;

    procedure UpdateLogList(ALogCount: Integer);

    procedure AddLog(ALogState: TLogState; ALogDateTime: TDateTime; ALogStr: String);
    procedure LogListCheck;
  end;

  TLogCommonCheckThread = class(TThread)
  private
    FLogCommon: TfrmLogCommon;

    FCloseEvent: THandle;
  protected
    procedure DoLogListCheck;

    procedure Execute; override;
  public
    constructor Create(ALogCommon: TfrmLogCommon);
    destructor Destroy; override;

    procedure Terminate;
  end;

var
  frmLogCommon: TfrmLogCommon;

implementation

uses Math;

{$R *.dfm}

procedure TfrmLogCommon.WMAddLogCommon(var Message: TMessage);
var
  LogCount: Integer;
begin
  LogCount := Message.LParam;
  UpdateLogList(LogCount);
end;

procedure TfrmLogCommon.WMExecuteLogCommonListCheck(var Message: TMessage);
begin
  LogListCheck;
end;

{procedure TfrmLogCommon.WndProc(var Message: TMessage);
var
  LogCount: Integer;
begin
  inherited;

  case Message.Msg of
    WM_ADD_LOG_COMMON:
    begin
      LogCount := Message.LParam;

      UpdateLogList(LogCount);
    end;
    WM_EXECUTE_LOG_COMMON_LIST_CHECK:
    begin
      LogListCheck;
    end;
  end;
end; }

constructor TfrmLogCommon.Create(AOwner: TComponent; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited Create(AOwner, ACombine, ALeft, ATop, AWidth, AHeight);
end;

procedure TfrmLogCommon.Initialize;
begin
  InitializeCommonLogListGrid;;

  FLogCommonCheckThread := TLogCommonCheckThread.Create(Self);
  FLogCommonCheckThread.Start;
end;

procedure TfrmLogCommon.Finalize;
begin
  if (FLogCommonCheckThread <> nil) then
  begin
    FLogCommonCheckThread.Terminate;
    FLogCommonCheckThread.WaitFor;
    FreeAndNil(FLogCommonCheckThread);
  end;
end;

procedure TfrmLogCommon.UpdateLogList(ALogCount: Integer);
begin
  with acgLogCommonList do
  begin
//    BeginUpdate;
    try
      RowCount := GV_LogCommonList.Count + CNT_LOG_COMMON_HEADER + 1;
    finally
//      EndUpdate;
    end;
  end;
end;

procedure TfrmLogCommon.AddLog(ALogState: TLogState; ALogDateTime: TDateTime; ALogStr: String);
var
  P: PLogCommon;
begin
  GV_LogCommonLock.Enter;
  try
    P := New(PLogCommon);
    FillChar(P^, SizeOf(TLogCommon), #0);
    with P^ do
    begin
      LogState := ALogState;
      LogDateTime := ALogDateTime;

      StrPLCopy(LogStr, ALogStr, MAX_PATH);
    end;

    GV_LogCommonList.Add(P);

    PostMessage(Handle, WM_ADD_LOG_COMMON, NativeInt(P), 0);
  finally
    GV_LogCommonLock.Leave;
  end;
end;

procedure TfrmLogCommon.LogListCheck;
var
  I: Integer;
  P: PLogCommon;
begin
  GV_LogCommonLock.Enter;
  try
    // 지정된 개수 이전 로그 삭제
    if (GV_LogCommonList.Count > GV_ConfigOption.MaxLogListHasCount) then
    begin
      for I := GV_LogCommonList.Count - GV_ConfigOption.MaxLogListHasCount - 1 downto 0 do
      begin
        P := GV_LogCommonList[I];
        GV_LogCommonList.Remove(P);
        Dispose(P);
      end;

      UpdateLogList(GV_LogCommonList.Count);
    end;
  finally
    GV_LogCommonLock.Leave;
  end;
end;

procedure TfrmLogCommon.FormCreate(Sender: TObject);
begin
  inherited;
  Initialize;
end;

procedure TfrmLogCommon.FormDestroy(Sender: TObject);
begin
  inherited;
  Finalize;
end;

procedure TfrmLogCommon.InitializeCommonLogListGrid;
var
  I: Integer;
  Column: TGridColumnItem;
begin
  with acgLogCommonList do
  begin
    BeginUpdate;
    try
      FixedRows := CNT_LOG_COMMON_HEADER;
      RowCount  := CNT_LOG_COMMON_HEADER + 1;
      ColCount  := CNT_LOG_COMMON_COLUMNS;

      Columns.BeginUpdate;
      try
        Columns.Clear;
        for I := 0 to CNT_LOG_COMMON_COLUMNS - 1 do
        begin
          Column := Columns.Add;
          with Column do
          begin
            HeaderFont.Assign(acgLogCommonList.FixedFont);
            Font.Assign(acgLogCommonList.Font);

            // Column : Time
            if (I = IDX_COL_LOG_COMMON_TIME) then
            begin
              Alignment := taLeftJustify;
              Header    := NAM_COL_LOG_COMMON_TIME;
              HeaderAlignment := taCenter;
              ReadOnly  := True;
              Width     := WIDTH_COL_LOG_COMMON_TIME;
            end
            // Column : Log
            else if (I = IDX_COL_LOG_COMMON_LOG) then
            begin
              Alignment := taLeftJustify;
              Header := NAM_COL_LOG_COMMON_LOG;
              ReadOnly  := True;
              Width  := WIDTH_COL_LOG_COMMON_LOG;
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

procedure TfrmLogCommon.acgLogCommonListDrawCell(Sender: TObject; ACol,
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

procedure TfrmLogCommon.acgLogCommonListGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  RCol, RRow: Integer;
  LogCommon: PLogCommon;
begin
  inherited;

  if (GV_LogCommonList = nil) then exit;

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if ((gdSelected in AState) or (gdRowSelected in AState)) or
       (RowSelect[RRow]) then
    begin
      AFont.Color := COLOR_BK_LOG_COMMON_NORMAL;
      AFont.Color := clWhite;
    end;

    GV_LogCommonLock.Enter;
    try
      LogCommon := GetLogCommonByIndex(AllRowCount - RRow - CNT_LOG_COMMON_HEADER - 1);
      if (LogCommon <> nil) then
      begin
        case LogCommon^.LogState of
          lsError:
          begin
            ABrush.Color := COLOR_BK_LOG_COMMON_ERROR;
            AFont.Color  := COLOR_TX_LOG_COMMON_ERROR;
          end;
          lsNormal:
          begin
            ABrush.Color := COLOR_BK_LOG_COMMON_NORMAL;
            if (not (gdSelected in AState) and (not (gdRowSelected in AState))) and
               (not (RowSelect[RRow])) then
            begin
              AFont.Color  := COLOR_TX_LOG_COMMON_NORMAL;
            end;
          end;
        end;
      end;
    finally
      GV_LogCommonLock.Leave;
    end;
  end;
end;

procedure TfrmLogCommon.acgLogCommonListGetDisplText(Sender: TObject; ACol,
  ARow: Integer; var Value: string);
var
  RCol, RRow: Integer;
  LogCommon: PLogCommon;
  Device: PDevice;
begin
  inherited;

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if (RRow < AllRowCount - CNT_LOG_COMMON_HEADER) then
    begin
      LogCommon := GetLogCommonByIndex(AllRowCount - RRow - CNT_LOG_COMMON_HEADER - 1);

      if (LogCommon <> nil) then
      begin
        with LogCommon^ do
        begin
          if (RCol = IDX_COL_LOG_COMMON_TIME) then
          begin
            Value := FormatDateTime('YYYY-MM-DD hh:nn:ss.zzz', LogDateTime);
          end
          else if (RCol = IDX_COL_LOG_COMMON_LOG) then
          begin
            Value := String(LogStr);
          end;
        end;
      end
      else
        Value := '';
    end;
  end;
end;

{ TLogCommonCheckThread }

constructor TLogCommonCheckThread.Create(ALogCommon: TfrmLogCommon);
begin
  FLogCommon := ALogCommon;

  FCloseEvent := CreateEvent(nil, True, False, nil);

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TLogCommonCheckThread.Destroy;
begin
  CloseHandle(FCloseEvent);

  inherited Destroy;
end;

procedure TLogCommonCheckThread.Terminate;
begin
  inherited Terminate;

  SetEvent(FCloseEvent);
end;

procedure TLogCommonCheckThread.DoLogListCheck;
begin
  PostMessage(FLogCommon.Handle, WM_EXECUTE_LOG_COMMON_LIST_CHECK, 0, 0);
end;

procedure TLogCommonCheckThread.Execute;
var
  R: Cardinal;
begin
  while not Terminated do
  begin
    R := WaitForSingleObject(FCloseEvent, TimecodeToMilliSec(GV_ConfigOption.LogListCheckInterval, FR_30));
    case R of
      WAIT_OBJECT_0: break;
      WAIT_TIMEOUT: DoLogListCheck;
    end;
  end;
end;

end.
