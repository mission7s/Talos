unit UnitDeviceList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitWorkForm, Vcl.Imaging.pngimage,
  WMTools, WMControls, Vcl.ExtCtrls, AdvUtil, Vcl.Grids, AdvObj, BaseGrid,
  AdvGrid, AdvCGrid,
  UnitDeviceThread, UnitConsts, UnitCommons, Vcl.StdCtrls;

type
  TfrmDeviceList = class(TfrmWork)
    acgDeviceList: TAdvColumnGrid;
    wmibReset: TWMImageSpeedButton;
    wmibResetAll: TWMImageSpeedButton;
    imgDeviceStatus: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acgDeviceListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure acgDeviceListGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
  private
    { Private declarations }
    procedure Initialize;
    procedure Finalize;

    procedure InitializeDeviceListGrid;

    procedure PopulateDeviceList;
    procedure PopulateDeviceStatus(AHandle: TDeviceHandle; AStatus: TDeviceStatus);
    procedure PopulateDeviceControlBy(AHandle: TDeviceHandle; AControlBy: String);

    procedure DeviceInit(ADeviceHandle: TDeviceHandle);
  protected
//    procedure WndProc(var Message: TMessage); override;

    procedure WMUpdateDeviceStatus(var Message: TMessage); message WM_UPDATE_DEVICE_STATUS;
    procedure WMUpdateDeviceControlBy(var Message: TMessage); message WM_UPDATE_DEVICE_CONTROLBY;
  public
    { Public declarations }
    procedure SelectDeviceInit;
    procedure DeviceInitAll;
  end;

var
  frmDeviceList: TfrmDeviceList;

implementation

uses UnitDCS;

{$R *.dfm}

procedure TfrmDeviceList.WMUpdateDeviceStatus(var Message: TMessage);
var
  DeviceHandle: TDeviceHandle;
  DeviceStatus: TDeviceStatus;
begin
  DeviceHandle := Message.WParam;
  DeviceStatus := PDeviceStatus(Message.LParam)^;

  PopulateDeviceStatus(DeviceHandle, DeviceStatus);
end;

procedure TfrmDeviceList.WMUpdateDeviceControlBy(var Message: TMessage);
var
  DeviceHandle: TDeviceHandle;
  DeviceControlBy: String;
begin
  DeviceHandle := Message.WParam;
  DeviceControlBy := String(PChar(Message.LParam));

  PopulateDeviceControlBy(DeviceHandle, DeviceControlBy);
end;

{procedure TfrmDeviceList.WndProc(var Message: TMessage);
var
  DeviceHandle: TDeviceHandle;
  DeviceStatus: TDeviceStatus;
begin
  inherited;
  case Message.Msg of
    WM_UPDATE_DEVICE_STATUS:
    begin
      DeviceHandle := Message.WParam;
      DeviceStatus := PDeviceStatus(Message.LParam)^;

      PopulateDeviceStatus(DeviceHandle, DeviceStatus);
    end;
  end;
end; }

procedure TfrmDeviceList.FormCreate(Sender: TObject);
begin
  inherited;
  Initialize;
end;

procedure TfrmDeviceList.FormDestroy(Sender: TObject);
begin
  inherited;
  Finalize;
end;

procedure TfrmDeviceList.Initialize;
begin
  InitializeDeviceListGrid;

  PopulateDeviceList;
end;

procedure TfrmDeviceList.acgDeviceListDrawCell(Sender: TObject; ACol,
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
      Canvas.Pen.Color := COLOR_ROW_SELECT_EVENT;//clRed;

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

procedure TfrmDeviceList.acgDeviceListGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  RCol, RRow: Integer;
  D: TDeviceThread;
begin
  inherited;

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if ((gdSelected in AState) or (gdRowSelected in AState)) or
       (RowSelect[RRow]) then
    begin
      AFont.Color := COLOR_BK_DEVICESTATUS_NORMAL;
      AFont.Color := clWhite;
    end;

//    if (HAsMainControl) then
    begin
      D := GetDeviceThreadByHandle(RRow - CNT_DEVICE_HEADER);
      if (D <> nil) then
      begin
        if (not D.Device^.Status.Connected) or
           ((D.Device^.Status.EventType = ET_PLAYER) and (D.Device^.Status.Player.PortDown)) then
        begin
          ABrush.Color := COLOR_BK_DEVICESTATUS_ERROR;
          AFont.Color  := COLOR_TX_DEVICESTATUS_ERROR;
        end
        else
        begin
          ABrush.Color := COLOR_BK_DEVICESTATUS_NORMAL;
          if (not (gdSelected in AState) and (not (gdRowSelected in AState))) and
             (not (RowSelect[RRow])) then
          begin
            AFont.Color  := COLOR_TX_DEVICESTATUS_NORMAL;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmDeviceList.Finalize;
begin
end;

procedure TfrmDeviceList.InitializeDeviceListGrid;
var
  I: Integer;
  Column: TGridColumnItem;
begin
  with acgDeviceList do
  begin
    BeginUpdate;
    try
      FixedRows := CNT_DEVICE_HEADER;
      RowCount  := CNT_DEVICE_HEADER + 1;
      ColCount  := CNT_DEVICE_COLUMNS;

      Columns.BeginUpdate;
      try
        Columns.Clear;
        for I := 0 to CNT_DEVICE_COLUMNS - 1 do
        begin
          Column := Columns.Add;
          with Column do
          begin
            HeaderFont.Assign(acgDeviceList.FixedFont);
            Font.Assign(acgDeviceList.Font);

            // Column : No
            if (I = IDX_COL_DEVICE_NO) then
            begin
              Alignment := taLeftJustify;
              Header    := NAM_COL_DEVICE_NO;
              HeaderAlignment := taCenter;
              ReadOnly  := True;
              Width     := WIDTH_COL_DEVICE_NO;
            end
            // Column : Device
            else if (I = IDX_COL_DEVICE_NAME) then
            begin
              Header    := NAM_COL_DEVICE_NAME;
              ReadOnly  := True;
              Width     := WIDTH_COL_DEVICE_NAME;
            end
            // Column : Status
            else if (I = IDX_COL_DEVICE_STATUS) then
            begin
              Header    := NAM_COL_DEVICE_STATUS;
              ReadOnly  := True;
              Width     := WIDTH_COL_DEVICE_STATUS;
            end
            // Column : Timecode
            else if (I = IDX_COL_DEVICE_TIMECODE) then
            begin
              Alignment := taCenter;
              Header    := NAM_COL_DEVICE_TIMECODE;
              ReadOnly  := True;
              Width     := WIDTH_COL_DEVICE_TIMECODE;
            end
            // Column : Control By
            else if (I = IDX_COL_DEVICE_CONTROLBY) then
            begin
              Alignment := taLeftJustify;
              Header    := NAM_COL_DEVICE_CONTROLBY;
              ReadOnly  := True;
              Width     := WIDTH_COL_DEVICE_CONTROLBY;
            end
            // Column : Channel
            else if (I = IDX_COL_DEVICE_CHANNEL) then
            begin
              Header    := NAM_COL_DEVICE_CHANNEL;
              ReadOnly  := True;
              Width     := WIDTH_COL_DEVICE_CHANNEL;
            end
            // Column : Event
            else if (I = IDX_COL_DEVICE_EVENT) then
            begin
              Header    := NAM_COL_DEVICE_EVENT;
              ReadOnly  := True;
              Width     := WIDTH_COL_DEVICE_EVENT;
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

procedure TfrmDeviceList.PopulateDeviceList;
var
  I: Integer;
begin
  with acgDeviceList do
  begin
    RowCount := GV_DeviceList.Count + CNT_DEVICE_HEADER + 1;

    for I := 0 to GV_DeviceList.Count - 1 do
    begin
      Columns[IDX_COL_DEVICE_NO].Rows[I + CNT_DEVICE_HEADER]        := Format('%d', [I + 1]);
      Columns[IDX_COL_DEVICE_NAME].Rows[I + CNT_DEVICE_HEADER]      := GV_DeviceList[I].Name;
      Columns[IDX_COL_DEVICE_STATUS].Rows[I + CNT_DEVICE_HEADER]    := 'Ready';
      Columns[IDX_COL_DEVICE_TIMECODE].Rows[I + CNT_DEVICE_HEADER]  := '';
      Columns[IDX_COL_DEVICE_CONTROLBY].Rows[I + CNT_DEVICE_HEADER] := '';
      Columns[IDX_COL_DEVICE_CHANNEL].Rows[I + CNT_DEVICE_HEADER]   := '';
      Columns[IDX_COL_DEVICE_EVENT].Rows[I + CNT_DEVICE_HEADER]     := '';
    end;
  end;
end;

procedure TfrmDeviceList.PopulateDeviceStatus(AHandle: TDeviceHandle; AStatus: TDeviceStatus);
var
  R: Integer;
  StatusString: String;
  D: TDeviceThread;
  EventString, EventSubString: String;

  function GetSwitcherEventString(AEvent: PEvent): String;
  const
//    KeyOnOffNames: array[Boolean] of String = ('ON', 'OFF');
    KeyStateNames: array[-1..1] of String = ('NONE', 'OFF', 'ON');
  var
    KeyNumber: Integer;
    KeyState: String;
//    KeyOn: Boolean;
  begin
    Result := '';
    if (AEvent = nil) then exit;

    if (AEvent^.Switcher.MainVideo >= 0) and (AEvent^.Switcher.MainAudio >= 0) then
    begin
      Result := Format('%s, Main: V%d, A%d', [TimecodeToString(AEvent^.StartTime.T, D.ControlIsDropFrame),
                                              AEvent^.Switcher.MainVideo,
                                              AEvent^.Switcher.MainAudio]);
    end
    else
    begin
      KeyNumber := -1;
      if (AEvent^.Switcher.Key1 >= 0) then
      begin
        KeyNumber := 1;
        KeyState := KeyStateNames[AEvent^.Switcher.Key1];
      end
      else if (AEvent^.Switcher.Key2 >= 0) then
      begin
        KeyNumber := 2;
        KeyState := KeyStateNames[AEvent^.Switcher.Key2];
      end
      else if (AEvent^.Switcher.Key3 >= 0) then
      begin
        KeyNumber := 3;
        KeyState := KeyStateNames[AEvent^.Switcher.Key3];
      end
      else if (AEvent^.Switcher.Key4 >= 0) then
      begin
        KeyNumber := 4;
        KeyState := KeyStateNames[AEvent^.Switcher.Key4];
      end
      else
        exit;

{      KeyOn := False;
      if (AEvent^.Switcher.Key1 > 0) then
        KeyOn := True
      else if (AEvent^.Switcher.Key2 > 0) then
        KeyOn := True
      else if (AEvent^.Switcher.Key3 > 0) then
        KeyOn := True
      else
        exit; }

      Result := Format('%s, Key%d: %s', [TimecodeToString(AEvent^.StartTime.T, D.ControlIsDropFrame),
                                         KeyNumber, KeyState]);
    end;
  end;

  function GetRouterEventString(AEvent: PEvent): String;
  begin
    Result := '';
    if (AEvent = nil) then exit;

    Result := Format('%s, Out: %d, In: %d, Level: %d', [TimecodeToString(AEvent^.StartTime.T, D.ControlIsDropFrame),
                                                        AEvent^.RSW.XptOut,
                                                        AEvent^.RSW.XptIn,
                                                        AEvent^.RSW.XptLevel]);
  end;

begin
  with acgDeviceList do
  begin
    R := DisplRowIndex(AHandle + CNT_DEVICE_HEADER);

    if (R < FixedRows) or (R > RowCount - 1) then exit;

    D := GetDeviceThreadByHandle(AHandle);
    if (D <> nil) then
    begin
      D.Device.Status := AStatus;
      case AStatus.EventType of
        ET_PLAYER:
        begin
          if (not AStatus.Connected) then
          begin
            StatusString := 'Disconnected';
          end
          else
          begin
            if (AStatus.Player.PortDown) then
            begin
              StatusString := 'PortDown';
            end
            else if (AStatus.Player.CueDone) then
            begin
              if (AStatus.Player.Play) then
                StatusString := 'Playing.CueDone'
              else if (AStatus.Player.Still) then
                StatusString := 'Paused.CueDone'
              else StatusString := 'CueDone';
            end
            else if (AStatus.Player.Cue) then
            begin
              if (AStatus.Player.Play) then
                StatusString := 'Playing.Cueing'
              else if (AStatus.Player.Still) then
                StatusString := 'Paused.Cueing'
              else StatusString := 'Cueing';
            end
            else if (AStatus.Player.Stop) then StatusString := 'Stop'
            else if (AStatus.Player.Still) then StatusString := 'Paused'
            else if (AStatus.Player.Play) then StatusString := 'Playing'
            else if (AStatus.Player.Jog) then StatusString := 'Jog'
            else if (AStatus.Player.Shuttle) then StatusString := 'Shuttle'
            else if (AStatus.Player.FastFoward) then StatusString := 'FastFoward'
            else if (AStatus.Player.Rewind) then StatusString := 'Rewind'
            else if (AStatus.Player.Eject) then StatusString := 'Eject'
            else StatusString := 'Stop';
          end;

          Columns[IDX_COL_DEVICE_STATUS].Rows[R] := StatusString;

{          if (AStatus.Player.CueDone) or (AStatus.Player.Jog) or
             (AStatus.Player.Shuttle) or (AStatus.Player.Play) or
             (AStatus.Player.Still) then
            Columns[IDX_COL_DEVICE_TIMECODE].Rows[R] := TimecodeToString(AStatus.Player.CurTC)
          else Columns[IDX_COL_DEVICE_TIMECODE].Rows[R] := ''; }

          case D.Device^.DeviceType of
            DT_PCS_CG,
            DT_LINE,
            DT_TAPI: Columns[IDX_COL_DEVICE_TIMECODE].Rows[R] := '-';
          else
            Columns[IDX_COL_DEVICE_TIMECODE].Rows[R] := TimecodeToString(AStatus.Player.CurTC, AStatus.Player.DropFrame);
          end;

          EventString := '';
          D.EventLock.Enter;
          try
          if (D.EventCurr <> nil) then
          begin
            try
              EventString := Format('Current %s, %s', [TimecodeToString(D.EventCurr^.StartTime.T, D.ControlIsDropFrame),
                                                       TimecodeToString(D.EventCurr^.DurTime, D.ControlIsDropFrame)]);
            except
              on E : Exception do
              begin
                Assert(False, GetLogCommonStr(lsError, 'Exception current event information on device list.'));
                Application.MessageBox(PChar(Format('Exception class name = %s'#10#13'Exception message = %s'#10#13'Device = %s', [E.ClassName, E.Message, String(D.Device^.Name)])), PChar(Application.Title), MB_OK or MB_ICONERROR);
              end;
            end;
          end;

          if (D.EventNext <> nil) then
          begin
            if (EventString <> '') then EventString := EventString + ' - ';

            EventString := EventString +
                           Format('Next %s, %s', [TimecodeToString(D.EventNext^.StartTime.T, D.ControlIsDropFrame),
                                                  TimecodeToString(D.EventNext^.DurTime, D.ControlIsDropFrame)]);
          end;
          finally
            D.EventLock.Leave;
          end;

          Columns[IDX_COL_DEVICE_EVENT].Rows[R] := EventString;
        end;
        ET_SWITCHER:
        begin
          if (not AStatus.Connected) then
          begin
            StatusString := 'Disconnected';
          end
          else
          begin
            if (AStatus.Switcher.IsTransition) then
              StatusString := 'Transitioning'
            else
              StatusString := 'Connected';
          end;

          Columns[IDX_COL_DEVICE_STATUS].Rows[R]   := StatusString;
          Columns[IDX_COL_DEVICE_TIMECODE].Rows[R] := '-';

          EventString := '';
          D.EventLock.Enter;
          try
          if (D.EventCurr <> nil) then
          begin
            EventSubString := GetSwitcherEventString(D.EventCurr);
            if (EventSubString <> '') then
              EventString := Format('Current %s', [EventSubString]);
          end;

          if (D.EventNext <> nil) then
          begin
            EventSubString := GetSwitcherEventString(D.EventNext);
            if (EventSubString <> '') then
            begin
              if (EventString <> '') then EventString := EventString + ' - ';

              EventString := EventString +
                             Format('Next %s', [GetSwitcherEventString(D.EventNext)]);
            end;
          end;
          finally
            D.EventLock.Leave;
          end;

          Columns[IDX_COL_DEVICE_EVENT].Rows[R] := EventString;
        end;
        ET_RSW:
        begin
          if (not AStatus.Connected) then
          begin
            StatusString := 'Disconnected';
          end
          else
          begin
            StatusString := 'Connected';
          end;

          Columns[IDX_COL_DEVICE_STATUS].Rows[R]   := StatusString;
          Columns[IDX_COL_DEVICE_TIMECODE].Rows[R] := '-';

          EventString := '';
          D.EventLock.Enter;
          try
          if (D.EventCurr <> nil) then
          begin
            EventString := Format('Current %s', [GetRouterEventString(D.EventCurr)]);
          end;

          if (D.EventNext <> nil) then
          begin
            if (EventString <> '') then EventString := EventString + ' - ';

            EventString := EventString +
                           Format('Next %s', [GetRouterEventString(D.EventNext)]);
          end;
          finally
            D.EventLock.Leave;
          end;

          Columns[IDX_COL_DEVICE_EVENT].Rows[R] := EventString;
        end;
      else
        Columns[IDX_COL_DEVICE_STATUS].Rows[R]   := '';
        Columns[IDX_COL_DEVICE_TIMECODE].Rows[R] := '';
      end;

      Columns[IDX_COL_DEVICE_CONTROLBY].Rows[R] := D.ControlBy;
      Columns[IDX_COL_DEVICE_CHANNEL].Rows[R]   := GetChannelNameByID(D.ControlChannel)
    end
    else
    begin
      Columns[IDX_COL_DEVICE_CONTROLBY].Rows[R] := '';
      Columns[IDX_COL_DEVICE_CHANNEL].Rows[R]   := '';
      Columns[IDX_COL_DEVICE_EVENT].Rows[R]     := '';
    end;

    RepaintRow(R);
  end;
end;

procedure TfrmDeviceList.PopulateDeviceControlBy(AHandle: TDeviceHandle; AControlBy: String);
var
  R: Integer;
  StatusString: String;
begin
  with acgDeviceList do
  begin
    R := DisplRowIndex(AHandle + CNT_DEVICE_HEADER);

    if (R < FixedRows) or (R > RowCount - 1) then exit;

    R := DisplRowIndex(AHandle + CNT_DEVICE_HEADER);
    if (R >= RowCount) then exit;

    Columns[IDX_COL_DEVICE_CONTROLBY].Rows[R] := AControlBy;
  end;
end;

procedure TfrmDeviceList.DeviceInit(ADeviceHandle: TDeviceHandle);
var
  D: TDeviceThread;
begin
  if (ADeviceHandle < 0) then exit;

  D := GetDeviceThreadByHandle(ADeviceHandle);
  if (D <> nil) then
  begin
    D.DeviceReset;
  end;
end;

procedure TfrmDeviceList.SelectDeviceInit;
var
  I: Integer;
begin
  with acgDeviceList do
  begin
    // Mouse wheel top before or end after selectedrowcount = 0
    if (SelectedRowCount = 0) then
      SelectRows(Row, 1);

    for I := 0 to SelectedRowCount - 1 do
      DeviceInit(SelectedRow[I] - CNT_DEVICE_HEADER);
  end;
end;

procedure TfrmDeviceList.DeviceInitAll;
var
  I: Integer;
  Device: PDevice;
begin
  for I := 0 to GV_DeviceList.Count - 1 do
  begin
    Device := GV_DeviceList[I];
    if (Device <> nil) then
      DeviceInit(Device^.Handle);
  end;
end;

end.
