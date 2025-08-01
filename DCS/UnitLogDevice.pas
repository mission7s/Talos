unit UnitLogDevice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.SyncObjs, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.Grids,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  AdvObj, BaseGrid, AdvGrid, AdvCGrid, AdvOfficePager, WMTools, WMControls,
  UnitWorkForm, UnitCommons, UnitConsts, UnitDeviceThread, AdvSplitter;

type
  TLogDeviceListCheckThread = class;

  TfrmLogDevice = class(TfrmWork)
    acgLogDeviceList: TAdvColumnGrid;
    procedure acgLogDeviceListGetDisplText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acgLogDeviceListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure acgLogDeviceListGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure acgDeviceListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    FDevice: PDevice;
    FLogDeviceLock: TCriticalSection;
    FLogDeviceList: TLogDeviceList;

    FLogDeviceListCheckThread: TLogDeviceListCheckThread;

    function GetLogDeviceByIndex(AIndex: Integer): PLogDevice;

    procedure Initialize;
    procedure Finalize;

    procedure InitializeLogDeviceListGrid;

    procedure ClearLogDeviceList;
  protected
//    procedure WndProc(var Message: TMessage); override;

    procedure WMAddLogDevice(var Message: TMessage); message WM_ADD_LOG_DEVICE;
    procedure WMExecuteLogDeviceListCheck(var Message: TMessage); message WM_EXECUTE_LOG_DEVICE_LIST_CHECK;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; ADevice: PDevice; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer); overload;

    procedure UpdateLogList(ALogCount: Integer);

    procedure AddLog(AControlBy: String; AControlChannel: Integer; ALogState: TLogState; ALogDateTime: TDateTime; ALogStr: String);
    procedure LogListCheck;

    property LogDeviceList: TLogDeviceList read FLogDeviceList;
  end;

  TLogDeviceListCheckThread = class(TThread)
  private
    FLogDevice: TfrmLogDevice;

    FCloseEvent: THandle;
  protected
    procedure DoLogListCheck;

    procedure Execute; override;
  public
    constructor Create(ALogDevice: TfrmLogDevice);
    destructor Destroy; override;

    procedure Terminate;
  end;

var
  frmLogDevice: TfrmLogDevice;

implementation

uses UnitDCS, System.Math;

{$R *.dfm}

procedure TfrmLogDevice.WMAddLogDevice(var Message: TMessage);
var
  DeviceHandle: TDeviceHandle;
  LogCount: Integer;
begin
  DeviceHandle := Message.WParam;
  LogCount := Message.LParam;

  UpdateLogList(LogCount);
end;

procedure TfrmLogDevice.WMExecuteLogDeviceListCheck(var Message: TMessage);
begin
  LogListCheck;
end;

{procedure TfrmLogDevice.WndProc(var Message: TMessage);
var
  DeviceHandle: TDeviceHandle;
  LogCount: Integer;
begin
  inherited;

  case Message.Msg of
    WM_ADD_LOG_DEVICE:
    begin
      DeviceHandle := Message.WParam;
      LogCount := Message.LParam;

      UpdateLogList(LogCount);
    end;
    WM_EXECUTE_LOG_DEVICE_LIST_CHECK:
    begin
      LogListCheck;
    end;
  end;
end; }

constructor TfrmLogDevice.Create(AOwner: TComponent; ADevice: PDevice; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited Create(AOwner, ACombine, ALeft, ATop, AWidth, AHeight);

  FDevice := ADevice;
end;

procedure TfrmLogDevice.Initialize;
begin
  FLogDeviceLock := TCriticalSection.Create;

  FLogDeviceList := TLogDeviceList.Create;

  InitializeLogDeviceListGrid;

  FLogDeviceListCheckThread := TLogDeviceListCheckThread.Create(Self);
  FLogDeviceListCheckThread.Start;
end;

procedure TfrmLogDevice.Finalize;
begin
  if (FLogDeviceListCheckThread <> nil) then
  begin
    FLogDeviceListCheckThread.Terminate;
    FLogDeviceListCheckThread.WaitFor;
    FreeAndNil(FLogDeviceListCheckThread);
  end;

  ClearLogDeviceList;

  FreeAndNil(FLogDeviceList);

  FreeAndNil(FLogDeviceLock);
end;

procedure TfrmLogDevice.UpdateLogList(ALogCount: Integer);
begin
  with acgLogDeviceList do
  begin
//    BeginUpdate;
    try
      RowCount := ALogCount + CNT_LOG_DEVICE_HEADER + 1;
    finally
//      EndUpdate;
    end;
  end;
end;

procedure TfrmLogDevice.AddLog(AControlBy: String; AControlChannel: Integer; ALogState: TLogState; ALogDateTime: TDateTime; ALogStr: String);
var
  P: PLogDevice;
begin
  FLogDeviceLock.Enter;
  try
    P := New(PLogDevice);
    FillChar(P^, SizeOf(TLogDevice), #0);
    with P^ do
    begin
      StrPLCopy(ControlBy, AControlBy, HOSTIP_LEN);
      ControlChannel := AControlChannel;

      LogState := ALogState;
      LogDateTime := ALogDateTime;

      StrPLCopy(LogStr, ALogStr, MAX_PATH);
    end;

    FLogDeviceList.Add(P);

    PostMessage(Handle, WM_ADD_LOG_DEVICE, FDevice^.Handle, FLogDeviceList.Count);
  finally
    FLogDeviceLock.Leave;
  end;
end;

procedure TfrmLogDevice.LogListCheck;
var
  I: Integer;
  P: PLogDevice;
begin
  FLogDeviceLock.Enter;
  try
    // 지정된 개수 이전 로그 삭제
    if (FLogDeviceList.Count > GV_ConfigOption.MaxLogListHasCount) then
    begin
      for I := FLogDeviceList.Count - GV_ConfigOption.MaxLogListHasCount - 1 downto 0 do
      begin
        P := FLogDeviceList[I];
        FLogDeviceList.Remove(P);
        Dispose(P);
      end;

      UpdateLogList(FLogDeviceList.Count);
    end;
  finally
    FLogDeviceLock.Leave;
  end;
end;

procedure TfrmLogDevice.FormCreate(Sender: TObject);
begin
  inherited;
  Initialize;
end;

procedure TfrmLogDevice.FormDestroy(Sender: TObject);
begin
  inherited;
  Finalize;
end;

procedure TfrmLogDevice.InitializeLogDeviceListGrid;
var
  I: Integer;
  Column: TGridColumnItem;
begin
  with acgLogDeviceList do
  begin
    BeginUpdate;
    try
      FixedRows := CNT_LOG_DEVICE_HEADER;
      RowCount  := CNT_LOG_DEVICE_HEADER + 1;
      ColCount  := CNT_LOG_DEVICE_COLUMNS;

      Columns.BeginUpdate;
      try
        Columns.Clear;
        for I := 0 to CNT_LOG_DEVICE_COLUMNS - 1 do
        begin
          Column := Columns.Add;
          with Column do
          begin
            HeaderFont.Assign(acgLogDeviceList.FixedFont);
            Font.Assign(acgLogDeviceList.Font);

            // Column : Time
            if (I = IDX_COL_LOG_DEVICE_TIME) then
            begin
              Alignment := taLeftJustify;
              Header    := NAM_COL_LOG_DEVICE_TIME;
              HeaderAlignment := taCenter;
              ReadOnly  := True;
              Width     := WIDTH_COL_LOG_DEVICE_TIME;
            end
            // Column : Control by
            else if (I = IDX_COL_LOG_DEVICE_CONTROLBY) then
            begin
              Alignment := taLeftJustify;
              Header    := NAM_COL_LOG_DEVICE_CONTROLBY;
              ReadOnly  := True;
              Width     := WIDTH_COL_LOG_DEVICE_CONTROLBY;
            end
            // Column : Channel
            else if (I = IDX_COL_LOG_DEVICE_CHANNEL) then
            begin
              Alignment := taLeftJustify;
              Header := NAM_COL_LOG_DEVICE_CHANNEL;
              ReadOnly  := True;
              Width  := WIDTH_COL_LOG_DEVICE_CHANNEL;
            end
            // Column : Log
            else if (I = IDX_COL_LOG_DEVICE_LOG) then
            begin
              Alignment := taLeftJustify;
              Header := NAM_COL_LOG_DEVICE_LOG;
              ReadOnly  := True;
              Width  := WIDTH_COL_LOG_DEVICE_LOG;
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

procedure TfrmLogDevice.ClearLogDeviceList;
var
  I: Integer;
  L: PLogDevice;
begin
  FLogDeviceLock.Enter;
  try
    for I := FLogDeviceList.Count - 1 downto 0 do
    begin
      L := FLogDeviceList[I];
      if (L <> nil) then
        Dispose(L);
    end;

    FLogDeviceList.Clear;
  finally
    FLogDeviceLock.Leave;
  end;
end;

function TfrmLogDevice.GetLogDeviceByIndex(AIndex: Integer): PLogDevice;
begin
  Result := nil;

  FLogDeviceLock.Enter;
  try
    if (FLogDeviceList = nil) then exit;
    if (AIndex < 0) or (AIndex > FLogDeviceList.Count - 1) then exit;

    Result := FLogDeviceList[AIndex];
  finally
    FLogDeviceLock.Leave;
  end;
end;

procedure TfrmLogDevice.acgDeviceListDrawCell(Sender: TObject; ACol,
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
      Canvas.Pen.Color := $00FFBDAD;//clRed;

      Canvas.MoveTo(Rect.Left, Rect.Top);
      Canvas.LineTo(Rect.Right + 1, Rect.Top);

      Canvas.MoveTo(Rect.Left, Rect.Bottom - 1);
      Canvas.LineTo(Rect.Right + 1, Rect.Bottom - 1);

      SetTextColor(Canvas.Handle, clWhite);
    end
    else
    begin
      SetTextColor(Canvas.Handle, Font.Color);
    end;
  end;
end;

procedure TfrmLogDevice.acgLogDeviceListDrawCell(Sender: TObject; ACol,
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

procedure TfrmLogDevice.acgLogDeviceListGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  RCol, RRow: Integer;
  LogDevice: PLogDevice;
begin
  inherited;

  if (FLogDeviceList = nil) then exit;

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if ((gdSelected in AState) or (gdRowSelected in AState)) or
       (RowSelect[RRow]) then
    begin
      AFont.Color := COLOR_BK_LOG_DEVICE_NORMAL;
      AFont.Color := clWhite;
    end;

    FLogDeviceLock.Enter;
    try
      LogDevice := GetLogDeviceByIndex(AllRowCount - RRow - CNT_LOG_DEVICE_HEADER - 1);
      if (LogDevice <> nil) then
      begin
        case LogDevice^.LogState of
          lsError:
          begin
            ABrush.Color := COLOR_BK_LOG_DEVICE_ERROR;
            AFont.Color  := COLOR_TX_LOG_DEVICE_ERROR;
          end;
          lsNormal:
          begin
            ABrush.Color := COLOR_BK_LOG_DEVICE_NORMAL;
            if (not (gdSelected in AState) and (not (gdRowSelected in AState))) and
               (not (RowSelect[RRow])) then
            begin
              AFont.Color  := COLOR_TX_LOG_DEVICE_NORMAL;
            end;
          end;
        end;
      end;
    finally
      FLogDeviceLock.Leave;
    end;
  end;
end;

procedure TfrmLogDevice.acgLogDeviceListGetDisplText(Sender: TObject; ACol,
  ARow: Integer; var Value: string);
var
  RCol, RRow: Integer;
  LogDevice: PLogDevice;
  Device: PDevice;
begin
  inherited;

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if (RRow < AllRowCount - CNT_LOG_DEVICE_HEADER) then
    begin
      FLogDeviceLock.Enter;
      try
        LogDevice := GetLogDeviceByIndex(AllRowCount - RRow - CNT_LOG_DEVICE_HEADER - 1);

        if (LogDevice <> nil) then
        begin
          with LogDevice^ do
          begin
            if (RCol = IDX_COL_LOG_DEVICE_TIME) then
            begin
              Value := FormatDateTime('YYYY-MM-DD hh:nn:ss.zzz', LogDateTime);
            end
            else if (RCol = IDX_COL_LOG_DEVICE_CONTROLBY) then
            begin
              Value := String(ControlBy);
            end
            else if (RCol = IDX_COL_LOG_DEVICE_CHANNEL) then
            begin
              Value := GetChannelNameByID(ControlChannel);
            end
            else if (RCol = IDX_COL_LOG_DEVICE_LOG) then
            begin
              Value := String(LogStr);
            end;
          end;
        end
        else
          Value := '';
      finally
        FLogDeviceLock.Leave;
      end;
    end;
  end;
end;

{ TLogDeviceListCheckThread }

constructor TLogDeviceListCheckThread.Create(ALogDevice: TfrmLogDevice);
begin
  FLogDevice := ALogDevice;

  FCloseEvent := CreateEvent(nil, True, False, nil);

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TLogDeviceListCheckThread.Destroy;
begin
  CloseHandle(FCloseEvent);

  inherited Destroy;
end;

procedure TLogDeviceListCheckThread.Terminate;
begin
  inherited Terminate;

  SetEvent(FCloseEvent);
end;

procedure TLogDeviceListCheckThread.DoLogListCheck;
begin
  PostMessage(FLogDevice.Handle, WM_EXECUTE_LOG_DEVICE_LIST_CHECK, 0, 0);
end;

procedure TLogDeviceListCheckThread.Execute;
var
  R: Cardinal;
begin
  while not Terminated do
  begin
    R := WaitForSingleObject(FCloseEvent, TimecodeToMilliSec(GV_ConfigOption.LogListCheckInterval, FR_30));
    case R of
      WAIT_OBJECT_0: break;
    else
      DoLogListCheck;
    end;
  end;
end;

end.
