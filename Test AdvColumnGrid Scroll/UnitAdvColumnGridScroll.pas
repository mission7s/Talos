unit UnitAdvColumnGridScroll;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.Grids, AdvObj, BaseGrid,
  AdvGrid, AdvCGrid, Vcl.StdCtrls, UnitConsts, UnitCommons;

type
  TForm14 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    acgPlaylist: TAdvColumnGrid;
    Memo1: TMemo;
    procedure acgPlaylistGetDisplText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure acgPlaylistDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure acgPlaylistCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure acgPlaylistGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure AdvStringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    procedure ClearPlayListGrid;
  public
    { Public declarations }
  end;

var
  Form14: TForm14;

implementation

{$R *.dfm}

procedure TForm14.ClearPlayListGrid;
begin
  with acgPlaylist do
  begin
    BeginUpdate;
    try
//      if (FixedRows > 0) and (IsNode(0)) then
//        FIsContrctAll := GetNodeState(0);

      MouseActions.DisjunctRowSelect := False;
      ClearRowSelect;
      SplitAllCells;
      ExpandAll;
      RemoveAllNodes;
//      RowCount := CNT_CUESHEET_HEADER + CNT_CUESHEET_FOOTER;
//      RemoveRowsEx(CNT_CUESHEET_HEADER, RowCount - CNT_CUESHEET_HEADER - CNT_CUESHEET_FOOTER);
      RemoveRows(CNT_CUESHEET_HEADER, RowCount - CNT_CUESHEET_HEADER - CNT_CUESHEET_FOOTER);
      MouseActions.DisjunctRowSelect := True;
      SelectRows(CNT_CUESHEET_HEADER, 1);
      Row := CNT_CUESHEET_HEADER;
    finally
      acgPlaylist.EndUpdate;
    end;
  end;
end;

procedure TForm14.acgPlaylistCanEditCell(Sender: TObject; ARow, ACol: Integer;
  var CanEdit: Boolean);
begin
  CanEdit := False;
end;

procedure TForm14.acgPlaylistDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  R: TRect;
  RRow: Integer;
begin
  inherited;
//  exit;
  with (Sender as TAdvColumnGrid) do
  begin
//    frmSEC.WMTitleBar.Caption := Format('%d, %d', [ACol, ARow]);

//    if not (gdFixed in State) and
//       (((gdSelected in State) or (gdRowSelected in State) or (gdFocused in State)) or
//        (RowSelect[ARow])) then
    if (gdFixed in State) then exit;

    if ((Focused) and (gdSelected in State) and (GetKeyState(VK_LBUTTON) and $8000 = $8000)) or
        (RowSelect[ARow]) then


//    if (RowSelect[ARow]) or
//       ((GetKeystate(VK_CONTROL) and $8000 = $8000) and or MouseActions.DisjunctRowSelectNoCtrl then
//       ( then

    begin
      Canvas.Brush.Style := bsClear;
      Canvas.Pen.Color := $00FFAB1D;

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

//  Memo1.Lines.Add(Format('%d, %d', [ACol, ARow]));
end;

procedure TForm14.acgPlaylistGetCellColor(Sender: TObject; ARow, ACol: Integer;
  AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
                  ABrush.Color := COLOR_BK_EVENTSTATUS_ERROR;
                  AFont.Color  := COLOR_TX_EVENTSTATUS_ERROR;
end;

procedure TForm14.acgPlaylistGetDisplText(Sender: TObject; ACol, ARow: Integer;
  var Value: string);
begin
  Value := Format('%d:%d', [ACol, ARow]);
end;

procedure TForm14.AdvStringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  with (Sender as TAdvStringGrid) do
  begin
//    frmSEC.WMTitleBar.Caption := Format('%d, %d', [ACol, ARow]);

//    if not (gdFixed in State) and
//       (((gdSelected in State) or (gdRowSelected in State) or (gdFocused in State)) or
//        (RowSelect[ARow])) then
    if (gdFixed in State) then exit;

    if ((Focused) and (gdSelected in State) and (GetKeyState(VK_LBUTTON) and $8000 = $8000)) or
        (RowSelect[ARow]) then


//    if (RowSelect[ARow]) or
//       ((GetKeystate(VK_CONTROL) and $8000 = $8000) and or MouseActions.DisjunctRowSelectNoCtrl then
//       ( then

    begin
      Canvas.Brush.Style := bsClear;
      Canvas.Pen.Color := $00FFAB1D;

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

procedure TForm14.Button1Click(Sender: TObject);
begin
  acgPlaylist.ScrollType := ssMetro;
end;

procedure TForm14.Button2Click(Sender: TObject);
var
  I: Integer;
begin
  acgPlaylist.ScrollType := ssNormal;
exit;

  with acgPlaylist do
  begin
    for i := 0 to SelectedRowCount - 1 do
      ShowMessage(IntToStr(SelectedRow[i]));
  end;
end;

procedure TForm14.Button3Click(Sender: TObject);
var
  I: Integer;
begin
  ClearPlayListGrid;

  with acgPlaylist do
  begin
    BeginUpdate;
    RowCount := 50;
//    for I := 0 to 1000 - 1 do
//      InsertNormalRow(acgPlaylist.RowCount - 1);
      MergeCells(1, RowCount - 1, ColCount - 1, 1);
    EndUpdate;
  end;
end;

procedure TForm14.FormCreate(Sender: TObject);
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
  FinishAction: TFinishAction;
begin
exit;
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
              Alignment := taCenter;
              BorderPen.Color := GridLineColor;
              Borders  := [cbRight];
              Header   := NAM_COL_CUESHEET_GROUP;
              HeaderAlignment := taCenter;
              ReadOnly := True;
              Width    := WIDTH_COL_CUESHEET_GROUP;

//              AddCheckBoxColumn(I);
//              Options := Options + [goEditing];
//              AddCheckBox(I, 0, False, False);
//              MouseActions.CheckAllCheck := True;
      AddNode(0, 1);
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
              for IType := IT_NONE to IT_AMIXER2 do
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
{              for J := 0 to GV_SourceList.Count - 1 do
              begin
                if (not (GV_SourceList[J]^.SourceType in [ST_ROUTER, ST_MCS])) then
  //                if (GV_SourceList[I]^.DCS <> nil) and (GV_SourceList[I]^.DCS^.Main) then
  //                 ComboItems.AddObject(String(GV_SourceList[I]^.Name), TObject(GV_SourceList[I]^.Handle));
                    ComboItems.Add(String(GV_SourceList[J]^.Name));
              end;  }
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
            // Column Dropdown List : Finish Action
            else if (I = IDX_COL_CUESHEET_FINISH_ACTION) then
            begin
              Header := NAM_COL_CUESHEET_FINISH_ACTION;
              Width  := WIDTH_COL_CUESHEET_FINISH_ACTION;
              Editor := edComboList;
              for FinishAction := FA_NONE to FA_EJECT do
              begin
                ComboItems.AddObject(FinishActionNames[FinishAction], TObject(FinishAction));
              end;
            end
            // Column Dropdown List : Program Type
            else if (I = IDX_COL_CUESHEET_PROGRAM_TYPE) then
            begin
              Header := NAM_COL_CUESHEET_PROGRAM_TYPE;
              Width  := WIDTH_COL_CUESHEET_PROGRAM_TYPE;
              Editor := edComboList;
{              for J := 0 to GV_ProgramTypeList.Count - 1 do
              begin
                ComboItems.AddObject(GV_ProgramTypeList[J]^.Name, TObject(GV_ProgramTypeList[J]^.Code));
              end; }
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
      Row := CNT_CUESHEET_HEADER;
      EndUpdate;
    end;
  end;
end;

end.
