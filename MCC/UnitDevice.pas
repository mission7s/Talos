unit UnitDevice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitWorkForm, Vcl.Imaging.pngimage,
  WMTools, WMControls, Vcl.ExtCtrls, AdvUtil, Vcl.Grids, AdvObj, BaseGrid,
  AdvGrid, AdvCGrid,
  UnitCommons, UnitConsts;

type
  TfrmDevice = class(TfrmWork)
    acgDeviceList: TAdvColumnGrid;
    procedure FormCreate(Sender: TObject);
    procedure acgDeviceListGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure acgDeviceListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
  protected
    procedure WMUpdateDeviceCommError(var Message: TMessage); message WM_UPDATE_DEVICE_COMM_ERROR;
    procedure WMUpdateDeviceStatus(var Message: TMessage); message WM_UPDATE_DEVICE_STATUS;
  private
    { Private declarations }
    procedure Initialize;
    procedure Finalize;

    procedure InitializeDeviceListGrid;
    procedure PopulateDeviceListGrid(ASource: PSource; ADCSID: Integer = -1);
//    procedure PopulateDeviceListGrid(AIndex: Integer; AStatus: TDeviceStatus; ADCSID: Word);
  public
    { Public declarations }
    procedure SetDeviceCommError(ADeviceName: String; AStatus: TDeviceStatus);
//    procedure SetDeviceStatus(AIndex: Integer; ASource: PSource; AStatus: TDeviceStatus; ADCSID: Word);
    procedure SetDeviceStatus(ADCSIP: String; ADeviceHandle: TDeviceHandle; AStatus: TDeviceStatus);

    function MCCSetDeviceCommError(AStatus: TDeviceStatus; ADeviceName: String): Integer;
    function MCCSetDeviceStatus(ADCSID: Word; ADeviceHandle: TDeviceHandle; AStatus: TDeviceStatus): Integer;
  end;

var
  frmDevice: TfrmDevice;

implementation

uses UnitMCC, UnitTimelineChannel;

{$R *.dfm}

procedure TfrmDevice.WMUpdateDeviceCommError(var Message: TMessage);
var
  Source: PSource;
begin
  inherited;

  Source       := PSource(Message.WParam);

  PopulateDeviceListGrid(Source);
end;

procedure TfrmDevice.WMUpdateDeviceStatus(var Message: TMessage);
var
  Source: PSource;
  DCSID: Word;
begin
  inherited;

  Source  := PSource(Message.WParam);
  DCSID   := Message.LParam;

  PopulateDeviceListGrid(Source, DCSID);
end;

procedure TfrmDevice.FormCreate(Sender: TObject);
begin
  inherited;
  Initialize;
end;

procedure TfrmDevice.Initialize;
begin
  InitializeDeviceListGrid;
end;

procedure TfrmDevice.acgDeviceListDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
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

{  with (Sender as TAdvColumnGrid) do
  begin
    if (gdSelected in State) or (gdRowSelected in State) then
    begin
      Canvas.Brush.Style := bsClear;
      Canvas.Pen.Color := clRed;

      Canvas.MoveTo(Rect.Left, Rect.Top);
      Canvas.LineTo(Rect.Right + 1, Rect.Top);

      Canvas.MoveTo(Rect.Left, Rect.Bottom);
      Canvas.LineTo(Rect.Right + 1, Rect.Bottom);

      if (ACol = 0) then
      begin
        Canvas.MoveTo(Rect.Left, Rect.Top);
        Canvas.LineTo(Rect.Left, Rect.Bottom);
      end
      else if (ACol = ColCount - 1) or (IsMergedCell(ACol, ARow)) then
      begin
        Canvas.MoveTo(Rect.Right, Rect.Top);
        Canvas.LineTo(Rect.Right, Rect.Bottom);
      end;
    end;
  end; }
end;

procedure TfrmDevice.acgDeviceListGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  RCol, RRow: Integer;
  Source: PSource;
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

    Source := GV_SourceList[RRow - CNT_DEVICE_HEADER];
    if (Source <> nil) then
    begin
      if (Source^.CommSuccess) then
      begin
        if (Source^.Status.Connected) then
        begin
          ABrush.Color := COLOR_BK_DEVICESTATUS_NORMAL;
          if (not (gdSelected in AState) and (not (gdRowSelected in AState))) and
             (not (RowSelect[RRow])) then
          begin
            AFont.Color  := COLOR_TX_DEVICESTATUS_NORMAL;
          end;
        end
        else
        begin
          ABrush.Color := COLOR_BK_DEVICESTATUS_DISCONNECT;
          AFont.Color  := COLOR_TX_DEVICESTATUS_DISCONNECT;
        end;
      end
      else
      begin
        ABrush.Color := COLOR_BK_DEVICE_COMM_ERROR;
        AFont.Color  := COLOR_TX_DEVICE_COMM_ERROR;
      end;
    end;
  end;
end;

procedure TfrmDevice.Finalize;
begin

end;

procedure TfrmDevice.InitializeDeviceListGrid;
var
  I: Integer;
  Column: TGridColumnItem;
  Source: PSourceHandle;
begin
  with acgDeviceList do
  begin
    BeginUpdate;
    try
      FixedRows  := CNT_DEVICE_HEADER;
      RowCount   := GV_SourceList.Count + CNT_DEVICE_HEADER;
      ColCount   := CNT_DEVICE_COLUMNS;
      VAlignment := vtaCenter;

      Columns.BeginUpdate;
      try
        Columns.Clear;
        for I := 0 to ColCount - 1 do
        begin
          Column := Columns.Add;
          with Column do
          begin
            HeaderFont.Assign(acgDeviceList.FixedFont);
            Font.Assign(acgDeviceList.Font);

            // Column : No
            if (I = IDX_COL_DEVICE_NO) then
            begin
              Alignment  := taLeftJustify;
              Borders    := [];
              Header     := NAM_COL_DEVICE_NO;
              HeaderAlignment := taCenter;
              ReadOnly   := True;
              VAlignment := vtaCenter;
              Width      := WIDTH_COL_DEVICE_NO;
            end
            // Column : Name
            else if (I = IDX_COL_DEVICE_NAME) then
            begin
              Alignment  := taLeftJustify;
              Header     := NAM_COL_DEVICE_NAME;
              ReadOnly   := True;
              VAlignment := vtaCenter;
              Width      := WIDTH_COL_DEVICE_NAME;
            end
            // Column Status
            else if (I = IDX_COL_DEVICE_STATUS) then
            begin
              Alignment := taLeftJustify;
              Header    := NAM_COL_DEVICE_STATUS;
              ReadOnly  := True;
              Width     := WIDTH_COL_DEVICE_STATUS;
            end
            // Column Timecode
            else if (I = IDX_COL_DEVICE_TIMECODE) then
            begin
              Alignment := taCenter;
              Header    := NAM_COL_DEVICE_TIMECODE;
              ReadOnly  := True;
              Width     := WIDTH_COL_DEVICE_TIMECODE;
            end
            // Column DCS
            else if (I = IDX_COL_DEVICE_DCS) then
            begin
              Alignment := taLeftJustify;
              Header    := NAM_COL_DEVICE_DCS;
              ReadOnly  := True;
              Width     := WIDTH_COL_DEVICE_DCS;
{            end
            // Column Timecode
            else if (I = IDX_COL_DEVICE_CHANNEL) then
            begin
              Alignment := taLeftJustify;
              Header    := NAM_COL_DEVICE_CHANNEL;
              ReadOnly  := True;
              Width     := WIDTH_COL_DEVICE_CHANNEL; }
            end;
          end;
        end;

        for I := 0 to GV_SourceList.Count - 1 do
        begin
          Cells[IDX_COL_DEVICE_NO, I + CNT_DEVICE_HEADER]         := Format('%d', [I + 1]);
          Cells[IDX_COL_DEVICE_NAME, I + CNT_CUESHEET_HEADER]     := String(GV_SourceList[I]^.Name);
          Cells[IDX_COL_DEVICE_STATUS, I + CNT_CUESHEET_HEADER]   := '';
          Cells[IDX_COL_DEVICE_TIMECODE, I + CNT_CUESHEET_HEADER] := '';
          Cells[IDX_COL_DEVICE_DCS, I + CNT_CUESHEET_HEADER]      := '';
        end;
      finally
        Columns.EndUpdate;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfrmDevice.PopulateDeviceListGrid(ASource: PSource; ADCSID: Integer);
var
  R: Integer;
  StatusString: String;
begin
  if (ASource = nil) then exit;

  with acgDeviceList do
  begin
    R := DisplRowIndex(GV_SourceList.IndexOf(ASource) + CNT_CUESHEET_HEADER);

    if (R < FixedRows) or (R > RowCount - 1) then exit;

    if (ASource^.CommSuccess) then
    begin
      case ASource^.Status.EventType of
        ET_PLAYER:
        begin
          with ASource^.Status.Player do
          begin
            if (not ASource^.Status.Connected) then
            begin
              StatusString := 'Disconnected';

  //            RowColor[ARow]     := COLOR_ROW_DEVICE_ERROR;
  //            RowFontColor[ARow] := COLOR_FONT_DEVICE_ERROR;
            end
            else
            begin
  //            RowColor[ARow]     := COLOR_ROW_DEVICE_NORMAL;
  //            RowFontColor[ARow] := COLOR_FONT_DEVICE_NORMAL;

              if (CueDone) then
              begin
                if (Play) then
                  StatusString := 'Playing.CueDone'
                else if (Still) then
                  StatusString := 'Paused.CueDone'
                else StatusString := 'CueDone';
              end
              else if (Cue) then
              begin
                if (Play) then
                  StatusString := 'Playing.Cueing'
                else if (Still) then
                  StatusString := 'Paused.Cueing'
                else StatusString := 'CueDone';
              end
              else if (Stop) then StatusString := 'Stop'
              else if (Still) then StatusString := 'Paused'
              else if (Play) then StatusString := 'Playing'
              else if (Jog) then StatusString := 'Jog'
              else if (Shuttle) then StatusString := 'Shuttle'
              else if (FastFoward) then StatusString := 'FastFoward'
              else if (Rewind) then StatusString := 'Rewind'
              else if (Eject) then StatusString := 'Eject'
              else StatusString := 'Stop';
            end;

            Cells[IDX_COL_DEVICE_STATUS, R]   := StatusString;

            case ASource^.SourceType of
              ST_LINE,
              ST_CG: Cells[IDX_COL_DEVICE_TIMECODE, R] := '-';
              else
                Cells[IDX_COL_DEVICE_TIMECODE, R] := TimecodeToString(CurTC);
            end;
          end;
        end;
        ET_SWITCHER:
        begin
          if (not ASource^.Status.Connected) then
          begin
            StatusString := 'Disconnected';
          end
          else
          begin
            StatusString := 'Connected';
          end;

          Cells[IDX_COL_DEVICE_STATUS, R]   := StatusString;

          Cells[IDX_COL_DEVICE_TIMECODE, R] := '-';
        end;
      end;
    end
    else
    begin
      Cells[IDX_COL_DEVICE_STATUS, R]   := 'Comm error';
      Cells[IDX_COL_DEVICE_TIMECODE, R] := '';
    end;

    Cells[IDX_COL_DEVICE_DCS, R] := GetDCSNameByID(ADCSID);

//    Cells[IDX_COL_DEVICE_CHANNEL, R] := String(ASource^.Channel^.Name);

    RepaintRow(R);
  end;
end;

{procedure TfrmDevice.PopulateDeviceListGrid(AIndex: Integer; AStatus: TDeviceStatus; ADCSID: Word);
var
  R: Integer;
  StatusString: String;
begin
  with acgDeviceList do
  begin
    R := DisplRowIndex(AIndex + CNT_CUESHEET_HEADER);

    if (R < FixedRows) or (R > RowCount - 1) then exit;

    case AStatus.EventType of
      ET_PLAYER:
      begin
        with AStatus.Player do
        begin
          if (not Connected) then
          begin
            StatusString := 'Error';

//            RowColor[ARow]     := COLOR_ROW_DEVICE_ERROR;
//            RowFontColor[ARow] := COLOR_FONT_DEVICE_ERROR;
          end
          else
          begin
//            RowColor[ARow]     := COLOR_ROW_DEVICE_NORMAL;
//            RowFontColor[ARow] := COLOR_FONT_DEVICE_NORMAL;

            if (CueDone) then
            begin
              if (Play) then
                StatusString := 'Playing.CueDone'
              else if (Still) then
                StatusString := 'Paused.CueDone'
              else StatusString := 'CueDone';
            end
            else if (Cue) then
            begin
              if (Play) then
                StatusString := 'Playing.Cueing'
              else if (Still) then
                StatusString := 'Paused.Cueing'
              else StatusString := 'CueDone';
            end
            else if (Stop) then StatusString := 'Stop'
            else if (Still) then StatusString := 'Paused'
            else if (Play) then StatusString := 'Playing'
            else if (Jog) then StatusString := 'Jog'
            else if (Shuttle) then StatusString := 'Shuttle'
            else if (FastFoward) then StatusString := 'FastFoward'
            else if (Rewind) then StatusString := 'Rewind'
            else if (Eject) then StatusString := 'Eject'
            else StatusString := 'Stop';
          end;

          Cells[IDX_COL_DEVICE_STATUS, R]   := StatusString;
          Cells[IDX_COL_DEVICE_TIMECODE, R] := TimecodeToString(CurTC);
        end;
      end;
    end;

    Cells[IDX_COL_DEVICE_DCS, R] := GetDCSNameByID(ADCSID);
//    Cells[IDX_COL_DEVICE_CHANNEL, R] := String(ASource^.Channel^.Name);
  end;
end; }

{procedure TfrmDevice.SetDeviceStatus(AIndex: Integer; ASource: PSource; AStatus: TDeviceStatus; ADCSID: Word);
var
  R: Integer;
begin
  if (ASource = nil) then exit;

  R := AIndex + CNT_DEVICE_HEADER;
  if (R > (acgDeviceList.RowCount - 1)) then exit;

  PopulateDeviceListGrid(R, AStatus);

  with acgDeviceList do
  begin
    Cells[IDX_COL_DEVICE_DCS, R]     := GetDCSNameByID(ADCSID);
//    Cells[IDX_COL_DEVICE_CHANNEL, R] := String(ASource^.Channel^.Name);
  end;
end; }

procedure TfrmDevice.SetDeviceCommError(ADeviceName: String; AStatus: TDeviceStatus);
var
  Source: PSource;
begin
  inherited;

  Source := GetSourceByName(ADeviceName);
  if (Source <> nil) then
  begin
    Source^.Status := AStatus;
    PostMessage(Handle, WM_UPDATE_DEVICE_COMM_ERROR, NativeInt(Source), 0);
  end;
end;

procedure TfrmDevice.SetDeviceStatus(ADCSIP: String; ADeviceHandle: TDeviceHandle; AStatus: TDeviceStatus);
var
  Source: PSource;

  DCS: PDCS;
begin
  inherited;

  Source := GetSourceByIPAndHandle(ADCSIP, ADeviceHandle);
  if (Source = nil) then exit;

  Source^.CommSuccess := True;
  Source^.CommTimeout := 0;
  Source^.Status := AStatus;

  DCS := GetDCSByIP(ADCSIP);
  if (DCS <> nil) then
  begin
    PostMessage(Handle, WM_UPDATE_DEVICE_STATUS, NativeInt(Source), DCS^.ID);
  end;
end;

function TfrmDevice.MCCSetDeviceCommError(AStatus: TDeviceStatus; ADeviceName: String): Integer;
var
  Source: PSource;
begin
  Result := D_FALSE;

  Source := GetSourceByName(ADeviceName);
  if (Source = nil) then exit;

  Source^.Status := AStatus;
  PostMessage(Handle, WM_UPDATE_DEVICE_COMM_ERROR, NativeInt(Source), 0);

  Result := D_OK;
end;

function TfrmDevice.MCCSetDeviceStatus(ADCSID: Word; ADeviceHandle: TDeviceHandle; AStatus: TDeviceStatus): Integer;
var
  Source: PSource;
begin
  inherited;

  Result := D_FALSE;

  Source := GetSourceByIDAndHandle(ADCSID, ADeviceHandle);
  if (Source = nil) then exit;

  Source^.Status := AStatus;

//  ShowMessage(Format('%d, %d', [ADCSID, ADeviceHandle]));
  PostMessage(Handle, WM_UPDATE_DEVICE_STATUS, NativeInt(Source), ADCSID);

  Result := D_OK;
end;

end.
