unit UnitLogAllDevice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitWorkForm, AdvUtil, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, AdvCGrid, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  AdvOfficePager, WMTools, WMControls,
  UnitCommons, UnitConsts, UnitDeviceThread;

type
  TLogAllListCheckThread = class;

  TfrmLogAllDevice = class(TfrmWork)
    acgLogAllDeviceList: TAdvColumnGrid;
    procedure acgLogAllDeviceListGetDisplText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acgLogAllDeviceListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure acgLogAllDeviceListGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
  private
    { Private declarations }
    FLogAllListCheckThread: TLogAllListCheckThread;

    procedure Initialize;
    procedure Finalize;

    procedure InitializeLogAllDeviceListGrid;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer); overload;

    procedure DisplayLogList;

    procedure AddLogDevice(ALogDevice: PLogDevice);
    procedure LogListCheck;
  end;

  TLogAllListCheckThread = class(TThread)
  private
    FLogAllDevice: TfrmLogAllDevice;

    FCloseEvent: THandle;
  protected
    procedure DoLogListCheck;

    procedure Execute; override;
  public
    constructor Create(ALogAllDevice: TfrmLogAllDevice);
    destructor Destroy; override;

    procedure Terminate;
  end;

var
  frmLogAllDevice: TfrmLogAllDevice;

implementation

uses Math;

{$R *.dfm}

procedure TfrmLogAllDevice.WndProc(var Message: TMessage);
var
  LogDevice: PLogDevice;
begin
  inherited;

  case Message.Msg of
    WM_ADD_DEVICE_LOG:
    begin
      LogDevice := PLogDevice(Message.WParam);

      if (LogDevice <> nil) then
      begin
        DisplayLogList;
      end;
    end;
    WM_EXECUTE_DEVICE_LOG_LIST_CHECK:
    begin
      LogListCheck;
    end;
  end;
end;

constructor TfrmLogAllDevice.Create(AOwner: TComponent; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited Create(AOwner, ACombine, ALeft, ATop, AWidth, AHeight);
end;

procedure TfrmLogAllDevice.Initialize;
begin
  InitializeLogAllDeviceListGrid;

  FLogAllListCheckThread := TLogAllListCheckThread.Create(Self);
  FLogAllListCheckThread.Resume;
end;

procedure TfrmLogAllDevice.Finalize;
begin
  if (FLogAllListCheckThread <> nil) then
  begin
    FLogAllListCheckThread.Terminate;
    FLogAllListCheckThread.WaitFor;
    FreeAndNil(FLogAllListCheckThread);
  end;
end;

procedure TfrmLogAllDevice.DisplayLogList;
begin
  acgLogAllDeviceList.BeginUpdate;
  try
    acgLogAllDeviceList.RowCount := GV_LogDeviceList.Count + CNT_DEVICE_ALL_LOG_HEADER + 1;
  finally
    acgLogAllDeviceList.EndUpdate;
  end;
end;

procedure TfrmLogAllDevice.AddLogDevice(ALogDevice: PLogDevice);
begin
  if (ALogDevice = nil) then exit;

  PostMessage(frmLogAllDevice.Handle, WM_ADD_DEVICE_LOG, NativeInt(ALogDevice), 0);
end;

procedure TfrmLogAllDevice.LogListCheck;
var
  I: Integer;
  D: PLogDevice;
begin
  // 지정된 개수 이전 로그 삭제
  if (GV_LogDeviceList.Count > GV_ConfigOption.MaxLogListHasCount) then
  begin
    for I := GV_LogDeviceList.Count - 1 downto GV_ConfigOption.MaxLogListHasCount do
    begin
      D := GV_LogDeviceList[I];
      GV_LogDeviceList.Remove(D);
      Dispose(D);
    end;

    DisplayLogList;
  end;
end;

procedure TfrmLogAllDevice.FormCreate(Sender: TObject);
begin
  inherited;
  Initialize;
end;

procedure TfrmLogAllDevice.FormDestroy(Sender: TObject);
begin
  inherited;
  Finalize;
end;

procedure TfrmLogAllDevice.InitializeLogAllDeviceListGrid;
var
  I: Integer;
  Column: TGridColumnItem;
begin
  with acgLogAllDeviceList do
  begin
    BeginUpdate;
    try
      FixedRows := CNT_DEVICE_ALL_LOG_HEADER;
      RowCount  := CNT_DEVICE_ALL_LOG_HEADER + 1;
      ColCount  := CNT_DEVICE_ALL_LOG_COLUMNS;

      Columns.BeginUpdate;
      try
        Columns.Clear;
        for I := 0 to CNT_DEVICE_ALL_LOG_COLUMNS - 1 do
        begin
          Column := Columns.Add;
          with Column do
          begin
            HeaderFont.Assign(acgLogAllDeviceList.FixedFont);
            Font.Assign(acgLogAllDeviceList.Font);

            // Column : Time
            if (I = IDX_COL_DEVICE_ALL_LOG_TIME) then
            begin
              Alignment := taLeftJustify;
              Header    := NAM_COL_DEVICE_ALL_LOG_TIME;
              HeaderAlignment := taCenter;
              ReadOnly  := True;
              Width     := WIDTH_COL_DEVICE_ALL_LOG_TIME;
            end
            // Column : Device
            else if (I = IDX_COL_DEVICE_ALL_LOG_DEVICE) then
            begin
              Alignment := taLeftJustify;
              Header    := NAM_COL_DEVICE_ALL_LOG_DEVICE;
              ReadOnly  := True;
              Width     := WIDTH_COL_DEVICE_ALL_LOG_DEVICE;
            end
            // Column : Control by
            else if (I = IDX_COL_DEVICE_ALL_LOG_CONTROLBY) then
            begin
              Alignment := taLeftJustify;
              Header    := NAM_COL_DEVICE_ALL_LOG_CONTROLBY;
              ReadOnly  := True;
              Width     := WIDTH_COL_DEVICE_ALL_LOG_CONTROLBY;
            end
            // Column : Channel
            else if (I = IDX_COL_DEVICE_ALL_LOG_CHANNEL) then
            begin
              Alignment := taLeftJustify;
              Header := NAM_COL_DEVICE_ALL_LOG_CHANNEL;
              ReadOnly  := True;
              Width  := WIDTH_COL_DEVICE_ALL_LOG_CHANNEL;
            end
            // Column : Log
            else if (I = IDX_COL_DEVICE_ALL_LOG_LOG) then
            begin
              Alignment := taLeftJustify;
              Header := NAM_COL_DEVICE_ALL_LOG_LOG;
              ReadOnly  := True;
              Width  := WIDTH_COL_DEVICE_ALL_LOG_LOG;
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

procedure TfrmLogAllDevice.acgLogAllDeviceListDrawCell(Sender: TObject; ACol,
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

procedure TfrmLogAllDevice.acgLogAllDeviceListGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  RCol, RRow: Integer;
begin
  inherited;

  if (GV_LogDeviceList = nil) then exit;

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if ((gdSelected in AState) or (gdRowSelected in AState)) or
       (RowSelect[RRow]) then
    begin
      AFont.Color := COLOR_BK_DEVICE_ALL_LOG_NORMAL;
      AFont.Color := clWhite;
    end;
  end;
end;

procedure TfrmLogAllDevice.acgLogAllDeviceListGetDisplText(Sender: TObject; ACol,
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

    if (RRow < AllRowCount - CNT_DEVICE_ALL_LOG_HEADER) then
    begin
      LogDevice := GetLogDeviceByIndex(AllRowCount - RRow - CNT_DEVICE_ALL_LOG_HEADER - 1);

      if (LogDevice <> nil) then
      begin
        with LogDevice^ do
        begin
          if (RCol = IDX_COL_DEVICE_ALL_LOG_TIME) then
          begin
            Value := FormatDateTime('YYYY-MM-DD tt', LogDateTime);
          end
          else if (RCol = IDX_COL_DEVICE_ALL_LOG_DEVICE) then
          begin
            Device := GetDeviceByHandle(DeviceHandle);
            if (Device <> nil) then
              Value := String(Device^.Name)
            else
              Value := '';
          end
          else if (RCol = IDX_COL_DEVICE_ALL_LOG_CONTROLBY) then
          begin
            Value := String(ControlBy);
          end
          else if (RCol = IDX_COL_DEVICE_ALL_LOG_CHANNEL) then
          begin
            Value := GetChannelNameByChannel(ControlChannel);
          end
          else if (RCol = IDX_COL_DEVICE_ALL_LOG_LOG) then
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

{ TLogAllListCheckThread }

constructor TLogAllListCheckThread.Create(ALogAllDevice: TfrmLogAllDevice);
begin
  FLogAllDevice := ALogAllDevice;

  FCloseEvent := CreateEvent(nil, True, False, nil);

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TLogAllListCheckThread.Destroy;
begin
  Terminate;

  CloseHandle(FCloseEvent);

  inherited Destroy;
end;

procedure TLogAllListCheckThread.Terminate;
begin
  inherited Terminate;

  SetEvent(FCloseEvent);
end;

procedure TLogAllListCheckThread.DoLogListCheck;
begin
  PostMessage(FLogAllDevice.Handle, WM_EXECUTE_DEVICE_LOG_LIST_CHECK, 0, 0);
end;

procedure TLogAllListCheckThread.Execute;
var
  R: Cardinal;
begin
  while not Terminated do
  begin
    R := WaitForSingleObject(FCloseEvent, TimecodeToMilliSec(GV_ConfigOption.LogListCheckInterval));
    case R of
      WAIT_OBJECT_0: break;
      else
      begin
        DoLogListCheck;
      end;
    end;
  end;
end;

end.
