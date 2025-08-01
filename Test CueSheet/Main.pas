unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, LibXmlParserU, Vcl.ComCtrls,
  Vcl.ImgList,
  AdvUtil, AdvObj, BaseGrid, AdvGrid, AdvCGrid,
  Vcl.StdCtrls, Vcl.Mask, WMTimeLine,
  UnitConsts, UnitCommons, UnitDCSDLL, System.ImageList;

const
  Img_Tag          = 0;
  Img_TagWithAttr  = 1;
  Img_UndefinedTag = 2;
  Img_AttrDef      = 3;
  Img_EntityDef    = 4;
  Img_ParEntityDef = 5;
  Img_Text         = 6;
  Img_Comment      = 7;
  Img_PI           = 8;
  Img_DTD          = 9;
  Img_Notation     = 10;
  Img_Prolog       = 11;

  CRLF             = ^M^J;

type
  TElementNode = CLASS
                   Content : AnsiString;
                   Attr    : TStringList;
                   CONSTRUCTOR Create (TheContent : AnsiString; TheAttr : TNvpList);
                   DESTRUCTOR Destroy; OVERRIDE;
                 END;

  TForm8 = class(TForm)
    TreeView1: TTreeView;
    IglTree: TImageList;
    AdvColumnGrid1: TAdvColumnGrid;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtChannelID: TEdit;
    edtOnairDate: TEdit;
    edtOnairFlag: TEdit;
    edtOnairNo: TEdit;
    MaskEdit1: TMaskEdit;
    WMTimeLine1: TWMTimeLine;
    ImageList1: TImageList;
    Button2: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure AdvColumnGrid1GetDisplText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure AdvColumnGrid1EditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure AdvColumnGrid1EditingDone(Sender: TObject);
    procedure AdvColumnGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure AdvColumnGrid1ClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AdvColumnGrid1CheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure AdvColumnGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure AdvColumnGrid1ComboChange(Sender: TObject; ACol, ARow,
      AItemIndex: Integer; ASelection: string);
    procedure AdvColumnGrid1CellsChanged(Sender: TObject; R: TRect);
    procedure AdvColumnGrid1CellValidate(Sender: TObject; ACol, ARow: Integer;
      var Value: string; var Valid: Boolean);
    procedure AdvColumnGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure AdvColumnGrid1CanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure AdvColumnGrid1EditChange(Sender: TObject; ACol, ARow: Integer;
      Value: string);
    procedure AdvColumnGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
  private
    { Private declarations }
    FXmlParser: TXmlParser;
    FActiveCueSheetList: TCueSheetList;
    FIsCellEditing: Boolean;
    FIsCellModified: Boolean;
    FOldCellValue: String;

    function GetCueSheetItemByIndex(AIndex: Integer): PCueSheetItem;
    function GetCueSheetItemBySourceName(AName: String): PCueSheetItem;

    function GetParentCueSheetItemByIndex(AIndex: Integer): PCueSheetItem;
    function GetParentCueSheetItemByItem(AItem: PCueSheetItem): PCueSheetItem;

    function GetBeforeMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;

    function MakePlayerEvent(AItem: PCueSheetItem; var AEvent: TEvent): Integer;
    function MakeSwitcherEvent(AItem: PCueSheetItem; var AEvent: TEvent): Integer;

    function PlayerInputEvent(AItem: PCueSheetItem): Integer;
//    function SwitcherInputEvent(AItem: PCueSheetItem): Integer;


    function IsValidStartDate(AItem: PCueSheetItem; AStartDate: TDate): Boolean;
    function IsValidStartTC(AItem: PCueSheetItem; AStartTC: TTimecode): Boolean;
    function IsValidDuration(AItem: PCueSheetItem; ADuration: TTimecode): Boolean;
    function IsValidInTC(AItem: PCueSheetItem; AInTC: TTimecode): Boolean;
    function IsValidOutTC(AItem: PCueSheetItem; AOutTC: TTimecode): Boolean;

    procedure ScanElement(Parent: TTreeNode);

    procedure PopulateGridCellText(AIndex: Integer);
    procedure LoadGrid;
    procedure ClearGrid;
//    procedure SetGridCueSheetData(ARow: Integer);

    procedure InitTimeline;
    procedure LoadTimeline;

    procedure ResetStartDate(AIndex: Integer; ADays: Integer);
    procedure ResetStartTimePlus(AIndex: Integer; ADurEventTime: TEventTime);
    procedure ResetStartTimeMinus(AIndex: Integer; ADurEventTime: TEventTime);

    procedure SourceOpens;
    procedure SourceCloses;

    procedure InputEvent(AIndex: Integer);

  public
    { Public declarations }
  end;

var
  Form8: TForm8;
  procedure DeviceStatusNotify(ADCSIP: PChar; ADeviceHandle: TDeviceHandle; AStatus: TDeviceStatus);
  procedure EventStatusNotify(ADCSIP: PChar; AEventID: TEventID; AStatus: TEventStatus);

implementation

uses System.DateUtils;

{$R *.dfm}

PROCEDURE SetStringSF (VAR S : AnsiString; BufferStart, BufferFinal : PAnsiChar);
BEGIN
  SetString (S, BufferStart, BufferFinal-BufferStart+1);
END;

CONSTRUCTOR TElementNode.Create (TheContent : AnsiString; TheAttr : TNvpList);
VAR
  I : INTEGER;
BEGIN
  INHERITED Create;
  Content := TheContent;
  Attr    := TStringList.Create;
  IF TheAttr <> NIL THEN
    FOR I := 0 TO TheAttr.Count-1 DO
      Attr.Add (string (TNvpNode (TheAttr [I]).Name) + '=' + string (TNvpNode (TheAttr [I]).Value));
END;


DESTRUCTOR TElementNode.Destroy;
BEGIN
  Attr.Free;
  INHERITED Destroy;
END;

procedure TForm8.ScanElement(Parent: TTreeNode);
VAR
  Node : TTreeNode;
  Strg : AnsiString;
  EN   : TElementNode;

  I: Integer;
  ChannelCueSheet: PChannelCueSheet;
  CueSheetItem: PCueSheetItem;
BEGIN
  WHILE FXmlParser.Scan DO BEGIN
    Node := NIL;
    CASE FXmlParser.CurPartType OF
{        ptXmlProlog : BEGIN
                      Node := TreeView1.Items.AddChild (Parent, '<?xml?>');
                      Node.ImageIndex := Img_Prolog;
                      EN := TElementNode.Create (String(FXmlParser.CurStart) + String(FXmlParser.CurFinal), NIL);
                      Node.Data := EN;
                    END;
      ptDtdc      : BEGIN
                      Node := TreeView1.Items.AddChild (Parent, 'DTD');
                      Node.ImageIndex := Img_Dtd;
                      EN := TElementNode.Create (String(FXmlParser.CurStart) + String(FXmlParser.CurFinal), NIL);
                      Node.Data := EN;
                    END;  }
      ptStartTag,
      ptEmptyTag  : BEGIN
//                      Node := TreeView1.Items.AddChild (Parent, string (FXmlParser.CurName));
                      IF FXmlParser.CurAttr.Count > 0 THEN BEGIN
//                        Node.ImageIndex := Img_TagWithAttr;
//                        EN := TElementNode.Create ('', FXmlParser.CurAttr);
//                          Elements.Add (EN);
//                        Node.Data := EN;

                        if (FXmlParser.CurName = XML_EVENT) then
                        begin
                          CueSheetItem := New(pCueSheetItem);
                          FillChar(CueSheetItem^, SizeOf(TCueSheetItem), #0);
                          with CueSheetItem^ do
                          begin
                            EventID.ChannelID := GV_ChannelCueSheetList[0].ChannelId;
                            StrCopy(EventID.OnAirDate, GV_ChannelCueSheetList[0].OnairDate);
                            EventID.OnAirFlag := GV_ChannelCueSheetList[0].OnairFlag;
                            EventID.OnAirNo   := GV_ChannelCueSheetList[0].OnairNo;

                            for I := 0 to FXmlParser.CurAttr.Count - 1 do
                            begin
                              if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_SERIAL_NO) then
                                EventID.SerialNo := StrToIntDef(TNvpNode(FXmlParser.CurAttr[I]).Value, 0)
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_GROUP_NO) then
                                GroupNo := StrToIntDef(TNvpNode(FXmlParser.CurAttr[I]).Value, 0)
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_EVENT_MODE) then
                                EventMode := TEventMode(StrToIntDef(TNvpNode(FXmlParser.CurAttr[I]).Value, 0))
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_START_MODE) then
                                StartMode := TStartMode(StrToIntDef(TNvpNode(FXmlParser.CurAttr[I]).Value, 0))
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_START_TIME) then
                                StartTime := DateTimecodeStrToEventTime(String(EventID.OnAirDate), TNvpNode(FXmlParser.CurAttr[I]).Value)
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_INPUT) then
                                Input := TInputType(StrToIntDef(TNvpNode(FXmlParser.CurAttr[I]).Value, 0))
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_OUTPUT) then
                                Output := StrToIntDef(TNvpNode(FXmlParser.CurAttr[I]).Value, 0)
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_TITLE) then
                                StrPCopy(Title, TNvpNode(FXmlParser.CurAttr[I]).Value)
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_SUB_TITLE) then
                                StrPCopy(SubTitle, TNvpNode(FXmlParser.CurAttr[I]).Value)
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_SOURCE) then
                                StrPCopy(Source, TNvpNode(FXmlParser.CurAttr[I]).Value)
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_MEDIA_ID) then
                                StrPCopy(MediaId, TNvpNode(FXmlParser.CurAttr[I]).Value)
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_DURATION_TC) then
                                DurationTC := StringToTimecode(TNvpNode(FXmlParser.CurAttr[I]).Value)
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_IN_TC) then
                                InTC := StringToTimecode(TNvpNode(FXmlParser.CurAttr[I]).Value)
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_OUT_TC) then
                                OutTC := StringToTimecode(TNvpNode(FXmlParser.CurAttr[I]).Value)
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_TRANSITION_TYPE) then
                                TransitionType := TTRType(StrToIntDef(TNvpNode(FXmlParser.CurAttr[I]).Value, 0))
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_TRANSITION_RATE) then
                                TransitionRate := TTRRate(StrToIntDef(TNvpNode(FXmlParser.CurAttr[I]).Value, 0))
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_PROGRAM_TYPE) then
                                ProgramType := StrToIntDef(TNvpNode(FXmlParser.CurAttr[I]).Value, 0)
                              else if (TNvpNode(FXmlParser.CurAttr[I]).Name = XML_NOTES) then
                                StrPCopy(Notes, TNvpNode(FXmlParser.CurAttr[I]).Value);
                            end;
                          end;
                          GV_ChannelCueSheetList[0].CueSheetList.Add(CueSheetItem);
                        end;
                        
                        END;
//                      ELSE
//                        Node.ImageIndex := Img_Tag;

                      IF FXmlParser.CurPartType = ptStartTag THEN   // Recursion
                        ScanElement (Node);
                    END;
      ptEndTag    : BREAK;
        ptContent,
      ptCData     : BEGIN
                      if Length (FXmlParser.CurContent) > 40
                        then Strg := Copy (FXmlParser.CurContent, 1, 40) + #133
                        else Strg := FXmlParser.CurContent;
//                      Node := TreeView1.Items.AddChild (Parent, string (Strg));  // !!!
//                      Node.ImageIndex := Img_Text;
//                      EN := TElementNode.Create (FXmlParser.CurContent, NIL);
//                      Node.Data := EN;


                          ChannelCueSheet := GV_ChannelCueSheetList[0];
                      if (FXmlParser.CurName = XML_CHANNEL_ID) then
                      begin
                        edtChannelID.Text := Strg;
                        ChannelCueSheet.ChannelId := StrToIntDef(Strg, 0);
                      end
                      else if (FXmlParser.CurName = XML_ONAIR_DATE) then
                      begin
                        edtOnairDate.Text := Strg;
                        StrPCopy(ChannelCueSheet.OnairDate, Strg);
                      end
                      else if (FXmlParser.CurName = XML_ONAIR_FLAG) then
                      begin
                        edtOnairFlag.Text := Strg;
                        if (Length(Strg) > 0) then
                          ChannelCueSheet.OnairFlag := TOnAirFlagType(Ord(Strg[1]))
                        else
                          ChannelCueSheet.OnairFlag := FT_REGULAR;
                      end
                      else if (FXmlParser.CurName = XML_ONAIR_NO) then
                      begin
                        edtOnairNo.Text := Strg;
                        ChannelCueSheet.OnairNo := StrToIntDef(Strg, 0);
                      end;   
                      

                    END;
{      ptComment   : BEGIN
                      Node := TreeView1.Items.AddChild (Parent, 'Comment');
                      Node.ImageIndex := Img_Comment;
                      SetStringSF (Strg, FXmlParser.CurStart+4, FXmlParser.CurFinal-3);
                      EN := TElementNode.Create (TrimWs (Strg), NIL);
                      Node.Data := EN;
                    END;
      ptPI        : BEGIN
                      Node := TreeView1.Items.AddChild (Parent, string (FXmlParser.CurName) + ' ' + string (FXmlParser.CurContent));
                      Node.ImageIndex := Img_PI;
                    END; } 
      END;
    IF Node <> NIL THEN
      Node.SelectedIndex := Node.ImageIndex;
    END;
END;



procedure TForm8.AdvColumnGrid1CanEditCell(Sender: TObject; ARow, ACol: Integer;
  var CanEdit: Boolean);
var
  RCol, RRow: Integer;
  Item: PCueSheetItem;
begin
  CanEdit := True;
  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then
    begin
      CanEdit := False;
      exit;
    end;

    CanEdit := (RCol <> IDX_COL_CUESHEET_GROUP) and
               (RCol <> IDX_COL_CUESHEET_NO) and
               (RCol <> IDX_COL_CUESHEET_EVENT_MODE) and
               (RCol <> IDX_COL_CUESHEET_EVENT_STATUS) {and
               (RCol <> IDX_COL_CUESHEET_DEVICE_STATUS)};

    Item := GetCueSheetItemByIndex(RRow - FixedRows);
    if (Item <> nil) then
      with Item^ do
        if (EventMode = EM_COMMENT) then
        begin
          CanEdit := False;
          exit;
        end
        else if (EventMode = EM_MAIN) then
        begin
          if (StartMode = SM_ABSOLUTE) then
            CanEdit := (CanEdit)
          else
            CanEdit := (CanEdit) and
                       (RCol <> IDX_COL_CUESHEET_START_DATE) and
                       (RCol <> IDX_COL_CUESHEET_START_TIME);
        end
        else if (EventMode = EM_JOIN) then
        begin
          CanEdit := (CanEdit) and
                     (RCol <> IDX_COL_CUESHEET_START_DATE) and
                     (RCol <> IDX_COL_CUESHEET_START_TIME) and
                     (RCol <> IDX_COL_CUESHEET_DURATON);
        end
        else
        begin
          CanEdit := (CanEdit) and
                     (RCol <> IDX_COL_CUESHEET_START_DATE);
        end;
  end;
end;

procedure TForm8.AdvColumnGrid1CellsChanged(Sender: TObject; R: TRect);
var
  Value: String;
  CueSheetItem: PCueSheetItem;
  RCol, RRow: Integer;
  DurEventTime: TEventTime;
  SaveStartTime: TEventTime;
  SaveDurTC: TTimecode;
  IT: TInputType;
begin
exit;
//ShowMessage(IntToStr(AdvColumnGrid1.Col) + ' : ' + IntToStr(AdvColumnGrid1.Row));

//  with (Sender as TAdvColumnGrid) do
//    ShowMessage(IntToStr(RealRowIndex(ARow)));

  with (Sender as TAdvColumnGrid) do
  begin
    Value := Cells[Col, Row];

    RCol := RealColIndex(Col);
    RRow := RealRowIndex(Row);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if (FActiveCueSheetList <> nil) and (FActiveCueSheetList.Count > RRow - FixedRows) then
    begin
      CueSheetItem := FActiveCueSheetList[RRow - FixedRows];
      if (CueSheetItem <> nil) then
        with CueSheetItem^ do
        begin
          if (RCol = IDX_COL_CUESHEET_START_MODE) then
          begin
            with Columns[IDX_COL_CUESHEET_START_MODE].ComboItems do
              StartMode := TStartMode(Objects[IndexOf(Value)]);
          end
          else if (RCol = IDX_COL_CUESHEET_START_DATE) then
          begin
            SaveStartTime := StartTime;
            StartTime.D := StrToDate(Value);

            ResetStartDate(RRow - FixedRows + 1, Trunc(StartTime.D - SaveStartTime.D));
          end
          else if (RCol = IDX_COL_CUESHEET_START_TIME) then
          begin
            SaveStartTime := StartTime;
            StartTime.T := StringToTimecode(Value);
            DurEventTime := GetDurEventTime(SaveStartTime, StartTime);
//            if (SaveStartTime.T < StartTime.T) then
              ResetStartTimePlus(RRow - FixedRows + 1, DurEventTime);
//            else
//              ResetStartTimeMinus(RRow - FixedRows + 1, DurEventTime);
          end
          else if (RCol = IDX_COL_CUESHEET_INPUT) then
          begin
            with Columns[IDX_COL_CUESHEET_INPUT].ComboItems do
              Input := TInputType(Objects[IndexOf(Value)]);

            if (Input in [IT_MAIN, IT_BACKUP]) then
            begin
              Output := Integer(GV_SettingEventColumnDefault.OutputBkgnd);
            end
            else
            begin
              Output := Integer(GV_SettingEventColumnDefault.OutputKeyer);
            end;
          end
          else if (RCol = IDX_COL_CUESHEET_OUTPUT) then
          begin
            with Columns[IDX_COL_CUESHEET_OUTPUT].ComboItems do
              Output := Integer(Objects[IndexOf(Value)]);
          end
          else if (RCol = IDX_COL_CUESHEET_TITLE) then
            StrPCopy(Title, Value)
          else if (RCol = IDX_COL_CUESHEET_SUB_TITLE) then
            StrPCopy(SubTitle, Value)
          else if (RCol = IDX_COL_CUESHEET_SOURCE) then
            StrPCopy(Source, Value)
          else if (RCol = IDX_COL_CUESHEET_MEDIA_ID) then
            StrPCopy(MediaId, Value)
          else if (RCol = IDX_COL_CUESHEET_DURATON) then
          begin
            SaveDurTC  := DurationTC;
            DurationTC := StringToTimecode(Value);

            DurEventTime.D := 0;
            DurEventTime.T := GetDurTimecode(SaveDurTC, DurationTC);

  ShowMessage(EventTimeToDateTimecodeStr(DurEventTime, True));
            if (SaveDurTC < DurationTC) then
              ResetStartTimePlus(RRow - FixedRows + 1, DurEventTime)
            else
              ResetStartTimeMinus(RRow - FixedRows + 1, DurEventTime);
          end
          else if (RCol = IDX_COL_CUESHEET_IN_TC) then
            InTC := StringToTimecode(Value)
          else if (RCol = IDX_COL_CUESHEET_OUT_TC) then
            OutTC := StringToTimecode(Value)
          else if (RCol = IDX_COL_CUESHEET_TR_TYPE) then
          begin
            with Columns[IDX_COL_CUESHEET_TR_TYPE].ComboItems do
              TransitionType := TTRType(Objects[IndexOf(Value)]);
          end
          else if (RCol = IDX_COL_CUESHEET_TR_RATE) then
          begin
            with Columns[IDX_COL_CUESHEET_TR_RATE].ComboItems do
              TransitionRate := TTRRate(Objects[IndexOf(Value)]);
          end
          else if (RCol = IDX_COL_CUESHEET_PROGRAM_TYPE) then
          begin
            with Columns[IDX_COL_CUESHEET_PROGRAM_TYPE].ComboItems do
              ProgramType := Byte(Objects[IndexOf(Value)]);
          end
          else if (RCol = IDX_COL_CUESHEET_NOTES) then
            StrPCopy(Notes, Value);
        end;
    end;
  end;
end;

procedure TForm8.AdvColumnGrid1CellValidate(Sender: TObject; ACol,
  ARow: Integer; var Value: string; var Valid: Boolean);
var
  RCol, RRow: Integer;
  BefoItem, CurrItem: PCueSheetItem;
  CurrStartTime, BefoStartTime: TEventTime;
  DurEventTime: TEventTime;
  SaveStartTime: TEventTime;
  SaveDurTC: TTimecode;
  IT: TInputType;
begin
exit;
  // Check the cell validate.

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    CurrItem := GetCueSheetItemByIndex(RRow - FixedRows);
    if (CurrItem <> nil) then
      with CurrItem^ do
      begin
        // Checks whether the entered start time is less than the start time of the previous event.
        if (RCol = IDX_COL_CUESHEET_START_DATE) or
           (RCol = IDX_COL_CUESHEET_START_TIME) then
        begin
          if (EventMode = EM_MAIN) then
          begin
            CurrStartTime := CurrItem^.StartTime;
            if (RCol = IDX_COL_CUESHEET_START_DATE) then
              CurrStartTime.D := StrToDate(Value)
            else
            begin
              // Check that the entered timecode is validate.
              CurrStartTime.T := StringToTimecode(Value);
              if (not IsValidTimecode(CurrStartTime.T)) then
              begin
                MessageBeep(MB_ICONWARNING);
                MessageBox(Handle, PChar(SInvalidTimeocde), PChar(Application.Title), MB_OK or MB_ICONWARNING);
//                MessageDlg(SInvalidTimeocde, mtWarning, [mbOK], MB_ICONWARNING);

                Valid := False;
                  EditCell(ACol, ARow);
//                exit;
              end;
              Value := TimecodeToString(CurrStartTime.T)
            end;

            BefoItem := GetBeforeMainItemByItem(CurrItem);
            if (BefoItem <> nil) then
            begin
              BefoStartTime := GetEventEndTime(BefoItem^.StartTime, BefoItem^.DurationTC);
              if (CompareEventTime(CurrStartTime, BefoStartTime) <= 0) then
              begin
                MessageBeep(MB_ICONWARNING);
                MessageBox(Handle, PChar(SStartTimeGreaterThenBeforeEndTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
                Valid := False;
//                exit;
              end;
            end;
          end
          else if (EventMode = EM_JOIN) then
          begin
            // Check that the entered timecode is validate.

          end;

        end;
      end;
  end;
end;

procedure TForm8.AdvColumnGrid1CheckBoxClick(Sender: TObject; ACol,
  ARow: Integer; State: Boolean);
begin
//ShowMessage('1');
end;

procedure TForm8.AdvColumnGrid1ClickCell(Sender: TObject; ARow, ACol: Integer);
var
  R, C: Integer;
  CurrItem, NextItem: PCueSheetItem;
  NextIndex: Integer;
begin
  with (Sender as TAdvColumnGrid) do
  begin
    if (ACol = IDX_COL_CUESHEET_NO) and (IsNode(ARow)) then
    begin
//      ARow := GetRealRow;

      SetNodeState(Arow, not GetNodeState(ARow));
    end;
  end;
exit;
  with (Sender as TAdvColumnGrid) do
  begin
    R := RealRowIndex(ARow);
    C := RealColIndex(ACol);

    NodeState[ARow] := True;
    if (R < FixedRows) or (C < FixedCols) then exit;
    if (C <> IDX_COL_CUESHEET_GROUP) then exit;

    if (FActiveCueSheetList <> nil) and (FActiveCueSheetList.Count > ARow - FixedRows) then
    begin
      CurrItem := FActiveCueSheetList[ARow - FixedRows];
      if (CurrItem <> nil) then
        with CurrItem^ do
        begin
          if (EventMode = EM_MAIN) then
          begin
            if (ARow - FixedRows < AllRowCount) then
            begin
              NextIndex := ARow - FixedRows + 1;
              NextItem  := FActiveCueSheetList[NextIndex];
              if (NextItem <> nil) and (not (NextItem^.EventMode in [EM_MAIN, EM_COMMENT])) then
              begin
    //            Cells[IDX_COL_CUESHEET_GROUP, ARow := '<IMG src="idx:' + inttostr(1) + '">';
                if (Cells[C, ARow] = '0') then
                begin
                  Cells[C, ARow] := '1';
                  AddDataImage(C, ARow, 1, haCenter, vaCenter);

                  while (NextItem <> nil) and (not (NextItem^.EventMode in [EM_MAIN, EM_COMMENT])) do
                  begin
                    UnHideRow(NextIndex + FixedRows);
                    Inc(NextIndex);

                    if (NextIndex < FActiveCueSheetList.Count) then
                      NextItem := FActiveCueSheetList[NextIndex]
                    else
                      NextItem := nil;
                  end;
                end
                else
                begin
                  Cells[C, ARow] := '0';
                  AddDataImage(C, ARow, 0, haCenter, vaCenter);

                  while (NextItem <> nil) and (not (NextItem^.EventMode in [EM_MAIN, EM_COMMENT])) do
                  begin
                    HideRow(NextIndex + FixedRows);
                    Inc(NextIndex);

                    if (NextIndex < FActiveCueSheetList.Count) then
                      NextItem := FActiveCueSheetList[NextIndex]
                    else
                      NextItem := nil;
                  end;
                end;
              end;
            end;
          end;
        end;
    end;
    Invalidate;
  end;
end;

procedure TForm8.AdvColumnGrid1ComboChange(Sender: TObject; ACol, ARow,
  AItemIndex: Integer; ASelection: string);
var
  Input: TInputType;
  CueSheetItem: PCueSheetItem;
  RCol, RRow: Integer;
  OB: TOutputBkgndType;
  OK: TOutputKeyerType;
begin
  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if (FActiveCueSheetList <> nil) and (FActiveCueSheetList.Count > RRow - FixedRows) then
    begin
      if (RCol = IDX_COL_CUESHEET_INPUT) then
      begin
        with Columns[IDX_COL_CUESHEET_INPUT].ComboItems do
          Input := TInputType(Objects[AItemIndex]);

        if (Input in [IT_MAIN, IT_BACKUP]) then
        begin
          AllCells[IDX_COL_CUESHEET_OUTPUT, RRow] := OutputBkgndTypeNames[GV_SettingEventColumnDefault.OutputBkgnd];
        end
        else
        begin
          AllCells[IDX_COL_CUESHEET_OUTPUT, RRow] := OutputKeyerTypeNames[GV_SettingEventColumnDefault.OutputKeyer];
        end;

  {      CueSheetItem := FActiveCueSheetList[RRow - FixedRows];
        if (CueSheetItem <> nil) then
          with CueSheetItem^ do
          begin
            with Columns[IDX_COL_CUESHEET_INPUT].ComboItems do
              Input := TInputType(Objects[AItemIndex]);

            if (Input in [IT_MAIN, IT_BACKUP]) then
            begin
              Output := Integer(GV_SettingEventColumnDefault.OutputBkgnd);
              Cells[IDX_COL_CUESHEET_OUTPUT, RRow] := OutputBkgndTypeNames[GV_SettingEventColumnDefault.OutputBkgnd];
            end
            else
            begin
              Output := Integer(GV_SettingEventColumnDefault.OutputKeyer);
              Cells[IDX_COL_CUESHEET_OUTPUT, RRow] := OutputKeyerTypeNames[GV_SettingEventColumnDefault.OutputKeyer];
            end;
          end;  }
      end;
    end;
  end;
end;

procedure TForm8.AdvColumnGrid1EditCellDone(Sender: TObject; ACol,
  ARow: Integer);
var
  RCol, RRow: Integer;
  Value: String;
  CItem: PCueSheetItem;     // Current cuesheet item
  PItem: PCueSheetItem;     // Prior or parent cuesheet item
  CStartTime: TEventTime;   // Current start time
  CEndTime: TEventTime;     // Current end time
  PEndTime: TEventTime;     // Prior or parent end time
  DurTime: TEventTime;      // Duration time of current and modified start time
  SaveTime: TEventTime;     // Saved current start time

  CDurTC: TTimecode;        // Current duration tc
  SaveDurTC: TTimecode;     // Saved current duration tc
  IT: TInputType;

  EnterStartTime: TEventTime;
  EnterDate: TDate;
  EnterTC: TTimecode;
begin
//exit;
  // Check the cell validate.

  if (not FIsCellModified) then exit;

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    CItem := GetCueSheetItemByIndex(RRow - FixedRows);
    if (CItem <> nil) then
    begin
      Value := Cells[ACol, ARow];
      with CItem^ do
      begin
        if (RCol = IDX_COL_CUESHEET_START_MODE) then
        begin
          with Columns[IDX_COL_CUESHEET_START_MODE].ComboItems do
            StartMode := TStartMode(Objects[IndexOf(Value)]);
        end
        else if (RCol = IDX_COL_CUESHEET_START_DATE) then
        begin
          EnterDate := StrToDate(Value);
          if (IsValidStartDate(CItem, EnterDate)) then
          begin
            if (EventMode = EM_MAIN) then
            begin
              ResetStartDate(RRow - FixedRows + 1, Trunc(EnterDate - StartTime.D));
              StartTime.D := EnterDate;
            end;
          end
          else
          begin
            EditCell(ACol, ARow);
            exit;
          end;

{          if (EventMode = EM_MAIN) then
          begin
            SaveTime     := StartTime;

            CStartTime   := SaveTime;
            CStartTime.D := StrToDate(Value);

            // Checks whether the entered start time is less than the start time of the previous event.
            PItem := GetBeforeMainItemByItem(CItem);
            if (PItem <> nil) then
            begin
              PEndTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC);
//              ShowMessage(EventTimeToDateTimecodeStr(CurrStartTime));
//              ShowMessage(EventTimeToDateTimecodeStr(BefoStartTime));
              if (CompareEventTime(CStartTime, PEndTime) < 0) then
              begin
                MessageBeep(MB_ICONWARNING);
                MessageBox(Handle, PChar(SStartTimeGreaterThenBeforeEndTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
                EditCell(ACol, ARow);
                exit;
              end;
            end;

            StartTime.D := CStartTime.D;
            ResetStartDate(RRow - FixedRows + 1, Trunc(CStartTime.D - SaveTime.D));
          end; }
        end
        else if (RCol = IDX_COL_CUESHEET_START_TIME) then
        begin
          EnterTC := StringtoTimecode(Value);
          if (IsValidStartTC(CItem, EnterTC)) then
          begin
            if (EventMode = EM_MAIN) then
            begin
              EnterStartTime   := StartTime;
              EnterStartTime.T := EnterTC;

              DurTime := GetDurEventTime(StartTime, EnterStartTime);
              ResetStartTimePlus(RRow - FixedRows + 1, DurTime);
            end;

            StartTime.T := EnterTC;
          end
          else
          begin
            EditCell(ACol, ARow);
            exit;
          end;

{          SaveTime     := StartTime;

          CStartTime   := SaveTime;
          CStartTime.T := StringToTimecode(Value);

          if (EventMode = EM_MAIN) then
          begin
            // Check that the entered timecode is validate.
            if (not IsValidTimecode(CStartTime.T)) then
            begin
              MessageBeep(MB_ICONWARNING);
              MessageBox(Handle, PChar(SInvalidTimeocde), PChar(Application.Title), MB_OK or MB_ICONWARNING);
//                MessageDlg(SInvalidTimeocde, mtWarning, [mbOK], MB_ICONWARNING);
              EditCell(ACol, ARow);
              exit;
            end;

            // Checks whether the entered start time is less than the start time of the previous event.
            PItem := GetBeforeMainItemByItem(CItem);
            if (PItem <> nil) then
            begin
              PEndTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC);
//              ShowMessage(EventTimeToDateTimecodeStr(CurrStartTime));
//              ShowMessage(EventTimeToDateTimecodeStr(BefoStartTime));
              if (CompareEventTime(CStartTime, PEndTime) < 0) then
              begin
                MessageBeep(MB_ICONWARNING);
                MessageBox(Handle, PChar(SStartTimeGreaterThenBeforeEndTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
                EditCell(ACol, ARow);
                exit;
              end;
            end;

            StartTime.T := CStartTime.T;
            DurTime := GetDurEventTime(SaveTime, CStartTime);
//              ShowMessage(EventTimeToDateTimecodeStr(DurTime));
            ResetStartTimePlus(RRow - FixedRows + 1, DurTime);
//            ResetStartTimeMinus(RRow - FixedRows + 1, DurTime);
          end
          else if (EventMode in [EM_JOIN, EM_SUB]) then
          begin
            if (StartMode = SM_SUBBEGIN) then
            begin
              // Checks whether the entered start time is less than the end time of the parent event.
              PItem := GetParentCueSheetItemByItem(CItem);
              if (PItem <> nil) then
              begin
                PEndTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC);

                CStartTime.D := 0;
                CEndTime := GetEventEndTime(GetPlusEventTime(PItem^.StartTime, CStartTime), DurationTC);
                if (CompareEventTime(CEndTime, PEndTime) > 0) then
                begin
                  MessageBeep(MB_ICONWARNING);
                  MessageBox(Handle, PChar(SSubStartTimeLessThenParentEndTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
                  EditCell(ACol, ARow);
                  exit;
                end;
              end;

              StartTime.T := CStartTime.T;
            end
            else
            begin
              // Checks whether the entered start time is less than the end time of the parent event.
              PItem := GetParentCueSheetItemByItem(CItem);
              if (PItem <> nil) then
              begin
                PEndTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC);

                CStartTime.D := 0;
                CEndTime := GetEventEndTime(GetMinusEventTime(PEndTime, CStartTime), DurationTC);
                if (CompareEventTime(CEndTime, PEndTime) > 0) then
                begin
                  MessageBeep(MB_ICONWARNING);
                  MessageBox(Handle, PChar(SSubStartTimeLessThenParentEndTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
                  EditCell(ACol, ARow);
                  exit;
                end;
              end;

              StartTime.T := CStartTime.T;
            end;
          end; }
        end
        else if (RCol = IDX_COL_CUESHEET_INPUT) then
        begin
          with Columns[IDX_COL_CUESHEET_INPUT].ComboItems do
            Input := TInputType(Objects[IndexOf(Value)]);

          if (Input in [IT_MAIN, IT_BACKUP]) then
          begin
            Output := Integer(GV_SettingEventColumnDefault.OutputBkgnd);
          end
          else
          begin
            Output := Integer(GV_SettingEventColumnDefault.OutputKeyer);
          end;
        end
        else if (RCol = IDX_COL_CUESHEET_OUTPUT) then
        begin
          with Columns[IDX_COL_CUESHEET_OUTPUT].ComboItems do
            Output := Integer(Objects[IndexOf(Value)]);
        end
        else if (RCol = IDX_COL_CUESHEET_TITLE) then
          StrPCopy(Title, Value)
        else if (RCol = IDX_COL_CUESHEET_SUB_TITLE) then
          StrPCopy(SubTitle, Value)
        else if (RCol = IDX_COL_CUESHEET_SOURCE) then
          StrPCopy(Source, Value)
        else if (RCol = IDX_COL_CUESHEET_MEDIA_ID) then
          StrPCopy(MediaId, Value)
        else if (RCol = IDX_COL_CUESHEET_DURATON) then
        begin
          EnterTC := StringToTimecode(Value);
          if (IsValidDuration(CItem, EnterTC)) then
          begin
            if (EventMode = EM_MAIN) then
            begin
              SaveTime.D := 0;
              SaveTime.T := DurationTC;

              CStartTime.D := 0;
              CStartTime.T := EnterTC;

              DurTime := GetDurEventTime(SaveTime, CStartTime);
              ResetStartTimePlus(RRow - FixedRows + 1, DurTime);
            end;
            DurationTC := EnterTC;
          end
          else
          begin
            EditCell(ACol, ARow);
            exit;
          end;
{

          SaveTime.D := 0;
          SaveTime.T := DurationTC;

          CStartTime.D := 0;
          CStartTime.T := StringToTimecode(Value);

          // Check that the entered timecode is validate.
          if (not IsValidTimecode(CStartTime.T)) then
          begin
            MessageBeep(MB_ICONWARNING);
            MessageBox(Handle, PChar(SInvalidTimeocde), PChar(Application.Title), MB_OK or MB_ICONWARNING);
            EditCell(ACol, ARow);
            exit;
          end;

          // Feture add the media duration validate
          //
          //

          if (EventMode = EM_MAIN) then
          begin
            DurationTC := CStartTime.T;
            DurTime := GetDurEventTime(SaveTime, CStartTime);
            ResetStartTimePlus(RRow - FixedRows + 1, DurTime);
          end
          else if (EventMode in [EM_JOIN, EM_SUB]) then
          begin
            if (StartMode = SM_SUBBEGIN) then
            begin
              // Checks whether the entered end time is less than the end time of the parent event.
              PItem := GetParentCueSheetItemByItem(CItem);
              if (PItem <> nil) then
              begin
                PEndTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC);
//                ShowMessage(EventTimeToDateTimecodeStr(PEndTime));
                CEndTime := GetEventTimeSubBegin(PItem^.StartTime, CItem^.InTC);
                CEndTime := GetEventEndTime(CEndTime, CStartTime.T);
//                ShowMessage(EventTimeToDateTimecodeStr(CEndTime));

                if (CompareEventTime(CEndTime, PEndTime) > 0) then
                begin
                  MessageBeep(MB_ICONWARNING);
                  MessageBox(Handle, PChar(SSubStartTimeLessThenParentEndTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
                  EditCell(ACol, ARow);
                  exit;
                end;
              end;

              DurationTC := CStartTime.T;
            end
            else
            begin
              // Checks whether the entered start time is less than the end time of the parent event.
              PItem := GetParentCueSheetItemByItem(CItem);
              if (PItem <> nil) then
              begin
                PEndTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC);
//                ShowMessage(EventTimeToDateTimecodeStr(PEndTime));

                CEndTime := GetEventTimeSubEnd(PItem^.StartTime, PItem^.DurationTC, CItem^.InTC);
                CEndTime := GetEventEndTime(CEndTime, CStartTime.T);
//                ShowMessage(EventTimeToDateTimecodeStr(CEndTime));

                if (CompareEventTime(CEndTime, PEndTime) > 0) then
                begin
                  MessageBeep(MB_ICONWARNING);
                  MessageBox(Handle, PChar(SSubStartTimeLessThenParentEndTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
                  EditCell(ACol, ARow);
                  exit;
                end;
              end;

              DurationTC := CStartTime.T;
            end;
          end; }
        end
        else if (RCol = IDX_COL_CUESHEET_IN_TC) then
        begin
          EnterTC := StringToTimecode(Value);
          if (IsValidInTC(CItem, EnterTC)) then
          begin
            InTC := EnterTC;
          end
          else
          begin
            EditCell(ACol, ARow);
            exit;
          end;

{          SaveTime.D := 0;
          SaveTime.T := InTC;

          CStartTime.D := 0;
          CStartTime.T := StringToTimecode(Value);

          // Check that the entered timecode is validate.
          if (not IsValidTimecode(CStartTime.T)) then
          begin
            MessageBeep(MB_ICONWARNING);
            MessageBox(Handle, PChar(SInvalidTimeocde), PChar(Application.Title), MB_OK or MB_ICONWARNING);
            EditCell(ACol, ARow);
            exit;
          end;

          if (CStartTime.T >= DurationTC) then
          begin
            MessageBeep(MB_ICONWARNING);
            MessageBox(Handle, PChar(SInTCLessThenDurationTC), PChar(Application.Title), MB_OK or MB_ICONWARNING);
            EditCell(ACol, ARow);
            exit;
          end;

          if (CStartTime.T > OutTC) then
          begin
            MessageBeep(MB_ICONWARNING);
            MessageBox(Handle, PChar(SInTCLessThenOutTC), PChar(Application.Title), MB_OK or MB_ICONWARNING);
            EditCell(ACol, ARow);
            exit;
          end;

          InTC := CStartTime.T;  }
        end
        else if (RCol = IDX_COL_CUESHEET_OUT_TC) then
        begin
          EnterTC := StringToTimecode(Value);
          if (IsValidOutTC(CItem, EnterTC)) then
          begin
            OutTC := EnterTC;
          end
          else
          begin
            EditCell(ACol, ARow);
            exit;
          end;

{          SaveTime.D := 0;
          SaveTime.T := OutTC;

          CStartTime.D := 0;
          CStartTime.T := StringToTimecode(Value);

          // Check that the entered timecode is validate.
          if (not IsValidTimecode(CStartTime.T)) then
          begin
            MessageBeep(MB_ICONWARNING);
            MessageBox(Handle, PChar(SInvalidTimeocde), PChar(Application.Title), MB_OK or MB_ICONWARNING);
            EditCell(ACol, ARow);
            exit;
          end;

          if (CStartTime.T >= DurationTC) then
          begin
            MessageBeep(MB_ICONWARNING);
            MessageBox(Handle, PChar(SInTCLessThenDurationTC), PChar(Application.Title), MB_OK or MB_ICONWARNING);
            EditCell(ACol, ARow);
            exit;
          end;

          if (CStartTime.T < InTC) then
          begin
            MessageBeep(MB_ICONWARNING);
            MessageBox(Handle, PChar(SInTCLessThenOutTC), PChar(Application.Title), MB_OK or MB_ICONWARNING);
            EditCell(ACol, ARow);
            exit;
          end;

          OutTC := CStartTime.T; }
        end
        else if (RCol = IDX_COL_CUESHEET_TR_TYPE) then
        begin
          with Columns[IDX_COL_CUESHEET_TR_TYPE].ComboItems do
            TransitionType := TTRType(Objects[IndexOf(Value)]);
        end
        else if (RCol = IDX_COL_CUESHEET_TR_RATE) then
        begin
          with Columns[IDX_COL_CUESHEET_TR_RATE].ComboItems do
            TransitionRate := TTRRate(Objects[IndexOf(Value)]);
        end
        else if (RCol = IDX_COL_CUESHEET_PROGRAM_TYPE) then
        begin
          with Columns[IDX_COL_CUESHEET_PROGRAM_TYPE].ComboItems do
            ProgramType := Byte(Objects[IndexOf(Value)]);
        end
        else if (RCol = IDX_COL_CUESHEET_NOTES) then
          StrPCopy(Notes, Value);
      end;
    end;
  end;

  FIsCellEditing  := False;
  FIsCellModified := False;
end;

procedure TForm8.AdvColumnGrid1EditChange(Sender: TObject; ACol, ARow: Integer;
  Value: string);
begin
  
  FIsCellModified := True;
end;

procedure TForm8.AdvColumnGrid1EditingDone(Sender: TObject);
var
  RCol, RRow: Integer;
  Value: String;
  PItem, CItem: PCueSheetItem;
  CurrStartTime, BefoStartTime: TEventTime;
  DurEventTime: TEventTime;
  SaveStartTime: TEventTime;
  SaveDurTC: TTimecode;
  IT: TInputType;
begin
exit;
  // Check the cell validate.

  with (Sender as TAdvColumnGrid) do
  begin
//    if (not Modified) then exit;

    RCol := RealColIndex(Col);
    RRow := RealRowIndex(Row);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if (FActiveCueSheetList <> nil) and (FActiveCueSheetList.Count > Row - FixedRows) then
    begin
      Value := Cells[Col, Row];
      CItem := FActiveCueSheetList[RRow - FixedRows];
      if (CItem <> nil) then
        with CItem^ do
        begin
          // Checks whether the entered start time is less than the start time of the previous event.
          if (RCol = IDX_COL_CUESHEET_START_DATE) or
             (RCol = IDX_COL_CUESHEET_START_TIME) then
          begin
            if (EventMode = EM_MAIN) then
            begin
              CurrStartTime := CItem^.StartTime;
              if (RCol = IDX_COL_CUESHEET_START_DATE) then
                CurrStartTime.D := StrToDate(Value)
              else
              begin
                // Check that the entered timecode is validate.
                CurrStartTime.T := StringToTimecode(Value);
                if (not IsValidTimecode(CurrStartTime.T)) then
                begin
                  MessageBeep(MB_ICONWARNING);
                  MessageBox(Handle, PChar(SInvalidTimeocde), PChar(Application.Title), MB_OK or MB_ICONWARNING);
  //                MessageDlg(SInvalidTimeocde, mtWarning, [mbOK], MB_ICONWARNING);
//                  EditCell(ACol, ARow);
                  exit;
                end;
              end;

              PItem := GetBeforeMainItemByItem(CItem);
              if (PItem <> nil) then
              begin
                BefoStartTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC);
                if (CompareEventTime(CurrStartTime, BefoStartTime) <= 0) then
                begin
                  MessageBeep(MB_ICONWARNING);
                  MessageBox(Handle, PChar(SStartTimeGreaterThenBeforeEndTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
//                  EditCell(ACol, ARow);
                  exit;
                end;
              end;
            end
            else if (EventMode = EM_JOIN) then
            begin
              // Check that the entered timecode is validate.

            end;

          end;
        end;
    end;

  end;
end;

procedure TForm8.AdvColumnGrid1GetDisplText(Sender: TObject; ACol,
  ARow: Integer; var Value: string);
var
  CueSheetItem: PCueSheetItem;
begin
  inherited;
end;

procedure TForm8.AdvColumnGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
  var Value: string);
begin
  if (not FIsCellEditing) then
  begin
    with (Sender as TAdvColumnGrid) do
      FOldCellValue := Cells[ACol, ARow];
    FIsCellEditing := True;
  end;
end;

procedure TForm8.AdvColumnGrid1KeyPress(Sender: TObject; var Key: Char);
var
  CueSheetItem: PCueSheetItem;
  RCol, RRow: Integer;
begin
  with (AdvColumnGrid1) do
  begin
    if (Key = #27) then
    begin
      Modified := False;
      RCol := RealColIndex(Col);
      RRow := RealRowIndex(Row);

      if (FIsCellEditing) then
      begin
        FIsCellEditing  := False;
        FIsCellModified := False;
        Cells[Col, Row] := FOldCellValue;
      end;

      if (RRow < FixedRows) or (RCol < FixedCols) then exit;

      if (RCol = IDX_COL_CUESHEET_INPUT) and
         (FActiveCueSheetList <> nil) and (FActiveCueSheetList.Count > RRow - FixedRows) then
      begin
        CueSheetItem := FActiveCueSheetList[RRow - FixedRows];
        if (CueSheetItem <> nil) then
          with CueSheetItem^ do
          begin
            if (Input in [IT_MAIN, IT_BACKUP]) then
            begin
              Cells[IDX_COL_CUESHEET_OUTPUT, RRow] := OutputBkgndTypeNames[TOutputBkgndType(Output)];
            end
            else
            begin
              Cells[IDX_COL_CUESHEET_OUTPUT, RRow] := OutputKeyerTypeNames[TOutputKeyerType(Output)];
            end;
          end;
      end;
    end;
  end;
end;

procedure TForm8.AdvColumnGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  CItem: PCueSheetItem;
  RCol, RRow: Integer;
  SM: TStartMode;
  OB: TOutputBkgndType;
  OK: TOutputKeyerType;
begin
  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    CItem := GetCueSheetItemByIndex(RRow - FixedRows);
    if (CItem <> nil) then
    begin
      if (RCol = IDX_COL_CUESHEET_START_MODE) then
      begin
        with CItem^ do
        begin
          Columns[ACol].ComboItems.Clear;
          if (EventMode = EM_MAIN) then
          begin
            for SM := SM_ABSOLUTE to SM_LOOP do
            begin
              Columns[ACol].ComboItems.AddObject(StartModeNames[SM], TObject(SM));
            end;
          end
          else if (EventMode = EM_JOIN) then
          begin
            Columns[ACol].ComboItems.AddObject(StartModeNames[SM_SUBBEGIN], TObject(SM_SUBBEGIN));
          end
          else if (EventMode = EM_SUB) then
          begin
            for SM := SM_SUBBEGIN to SM_SUBEND do
            begin
              Columns[ACol].ComboItems.AddObject(StartModeNames[SM], TObject(SM));
            end;
          end;
        end;
      end
      else if (RCol = IDX_COL_CUESHEET_OUTPUT) then
      begin
        with CItem^ do
        begin
          Columns[ACol].ComboItems.Clear;
          if (Input in [IT_MAIN, IT_BACKUP]) then
          begin
            for OB := OB_NONE to OB_BOTH do
            begin
              Columns[ACol].ComboItems.AddObject(OutputBkgndTypeNames[OB], TObject(OB));
            end;
          end
          else
          begin
            for OK := OK_NONE to OK_OFF do
            begin
              Columns[ACol].ComboItems.AddObject(OutputKeyerTypeNames[OK], TObject(OK));
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TForm8.AdvColumnGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
var
  CueSheetItem: PCueSheetItem;
  RCol, RRow: Integer;
  DurEventTime: TEventTime;
  SaveStartTime: TEventTime;
  SaveDurTC: TTimecode;
  IT: TInputType;
begin
exit;
//ShowMessage(IntToStr(AdvColumnGrid1.Col) + ' : ' + IntToStr(AdvColumnGrid1.Row));

//  with (Sender as TAdvColumnGrid) do
//    ShowMessage(IntToStr(RealRowIndex(ARow)));

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if (FActiveCueSheetList <> nil) and (FActiveCueSheetList.Count > RRow - FixedRows) then
    begin
      CueSheetItem := FActiveCueSheetList[RRow - FixedRows];
      if (CueSheetItem <> nil) then
        with CueSheetItem^ do
        begin
          if (RCol = IDX_COL_CUESHEET_START_MODE) then
          begin
            with Columns[IDX_COL_CUESHEET_START_MODE].ComboItems do
              StartMode := TStartMode(Objects[IndexOf(Value)]);
          end
          else if (RCol = IDX_COL_CUESHEET_START_DATE) then
          begin
            SaveStartTime := StartTime;
            StartTime.D := StrToDate(Value);

            ResetStartDate(RRow - FixedRows + 1, Trunc(StartTime.D - SaveStartTime.D));
          end
          else if (RCol = IDX_COL_CUESHEET_START_TIME) then
          begin
            SaveStartTime := StartTime;
            StartTime.T := StringToTimecode(Value);
            DurEventTime := GetDurEventTime(SaveStartTime, StartTime);
//            if (SaveStartTime.T < StartTime.T) then
              ResetStartTimePlus(RRow - FixedRows + 1, DurEventTime);
//            else
//              ResetStartTimeMinus(RRow - FixedRows + 1, DurEventTime);
          end
          else if (RCol = IDX_COL_CUESHEET_INPUT) then
          begin
            with Columns[IDX_COL_CUESHEET_INPUT].ComboItems do
              Input := TInputType(Objects[IndexOf(Value)]);

            if (Input in [IT_MAIN, IT_BACKUP]) then
            begin
              Output := Integer(GV_SettingEventColumnDefault.OutputBkgnd);
            end
            else
            begin
              Output := Integer(GV_SettingEventColumnDefault.OutputKeyer);
            end;
          end
          else if (RCol = IDX_COL_CUESHEET_OUTPUT) then
          begin
            with Columns[IDX_COL_CUESHEET_OUTPUT].ComboItems do
              Output := Integer(Objects[IndexOf(Value)]);
          end
          else if (RCol = IDX_COL_CUESHEET_TITLE) then
            StrPCopy(Title, Value)
          else if (RCol = IDX_COL_CUESHEET_SUB_TITLE) then
            StrPCopy(SubTitle, Value)
          else if (RCol = IDX_COL_CUESHEET_SOURCE) then
            StrPCopy(Source, Value)
          else if (RCol = IDX_COL_CUESHEET_MEDIA_ID) then
            StrPCopy(MediaId, Value)
          else if (RCol = IDX_COL_CUESHEET_DURATON) then
          begin
            SaveDurTC  := DurationTC;
            DurationTC := StringToTimecode(Value);

            DurEventTime.D := 0;
            DurEventTime.T := GetDurTimecode(SaveDurTC, DurationTC);

  ShowMessage(EventTimeToDateTimecodeStr(DurEventTime, True));
            if (SaveDurTC < DurationTC) then
              ResetStartTimePlus(RRow - FixedRows + 1, DurEventTime)
            else
              ResetStartTimeMinus(RRow - FixedRows + 1, DurEventTime);
          end
          else if (RCol = IDX_COL_CUESHEET_IN_TC) then
            InTC := StringToTimecode(Value)
          else if (RCol = IDX_COL_CUESHEET_OUT_TC) then
            OutTC := StringToTimecode(Value)
          else if (RCol = IDX_COL_CUESHEET_TR_TYPE) then
          begin
            with Columns[IDX_COL_CUESHEET_TR_TYPE].ComboItems do
              TransitionType := TTRType(Objects[IndexOf(Value)]);
          end
          else if (RCol = IDX_COL_CUESHEET_TR_RATE) then
          begin
            with Columns[IDX_COL_CUESHEET_TR_RATE].ComboItems do
              TransitionRate := TTRRate(Objects[IndexOf(Value)]);
          end
          else if (RCol = IDX_COL_CUESHEET_PROGRAM_TYPE) then
          begin
            with Columns[IDX_COL_CUESHEET_PROGRAM_TYPE].ComboItems do
              ProgramType := Byte(Objects[IndexOf(Value)]);
          end
          else if (RCol = IDX_COL_CUESHEET_NOTES) then
            StrPCopy(Notes, Value);
        end;
    end;
  end;
end;

procedure TForm8.Button1Click(Sender: TObject);
var
  CueSheetList: TCueSheetList;
begin
  GV_ChannelCueSheetList[0].CueSheetList.Clear;

//  FXmlParser.LoadFromFile('D:\User Data\Git\APC\SEC\Win64\Debug\CueSheet\Test_20170828_정규편성_1.xml');
//  FXmlParser.LoadFromFile('D:\User Data\Git\APC\SEC\Win64\Debug\CueSheet\Test_20171103_정규편성_1.xml');
//  FXmlParser.LoadFromFile('D:\User Data\Git\APC\SEC\Win64\Debug\CueSheet\Test_20171117_정규편성_1.xml');
  FXmlParser.LoadFromFile('D:\User Data\Git\APC\SEC\Win64\Debug\CueSheet\Test_20170815_정규편성_1.xml');

  TreeView1.Items.BeginUpdate;
  TreeView1.Items.Clear;

  FXmlParser.Normalize := True;
  FXmlParser.StartScan;

  ScanElement (NIL);

//  ShowMessage(IntToStr(FXmlParser.Elements.Count));
//  ShowMessage(IntToStr(FXmlParser.Entities.Count));
//  ShowMessage(IntToStr(FXmlParser.Notations.Count));


//  FXmlParser.
  TreeView1.Items.EndUpdate;

//  AdvColumnGrid1.RowCount := GV_ChannelCueSheetList[0].CueSheetList.Count + 1;
//  AdvColumnGrid1.HideRow(1);
//  AdvColumnGrid1.ExpandNode(1);
//  AdvColumnGrid1.Repaint;

  ClearGrid;
  LoadGrid;
  LoadTimeline;
end;

procedure TForm8.Button2Click(Sender: TObject);
var
  I: Integer;
  R: Integer;

  P: PCueSheetItem;
  Start: TEventTime;
  DurEventTime: TEventTime;
begin
{  P := FActiveCueSheetList[1];
  Start := GetEventEndTime(P^.StartTime, P^.DurationTC);
  ShowMessage(EventTimeToDateTimecodeStr(Start, True));
exit;

  ShowMessage(AdvColumnGrid1.Cells[IDX_COL_CUESHEET_START_TIME,    3]);
exit;  }

  Start := DateTimeToEventTime(IncSecond(Now, 20));
  ShowMessage(EventTimeToDateTimecodeStr(Start, True));

  P := FActiveCueSheetList[1];
  DurEventTime := GetDurEventTime(P^.StartTime, Start);

//  ShowMessage(EventTimeToDateTimecodeStr(P^.StartTime, True));
  ShowMessage(EventTimeToDateTimecodeStr(DurEventTime, True));

//  DurEventTime := GetDurEventTime(P^.StartTime, Start);
//  if (P^.StartTime.T < Start.T) then
    ResetStartTimePlus(0, DurEventTime);
//  else
//    ResetStartTimeMinus(0, DurEventTime);

  for I := 0 to FActiveCueSheetList.Count - 1 do
  begin
    PlayerInputEvent(FActiveCueSheetList[I]);
  end;

  exit;


//  R := DCSOpen('127.0.0.1', 'DEC1', D);

//  ShowMessage(FActiveCueSheetList[3]^.Title);
  PlayerInputEvent(FActiveCueSheetList[3]);
  PlayerInputEvent(FActiveCueSheetList[4]);
//  ShowMessage(FActiveCueSheetList[5]^.Title);
  PlayerInputEvent(FActiveCueSheetList[5]);
  PlayerInputEvent(FActiveCueSheetList[6]);
end;

procedure TForm8.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SourceCloses;
end;

procedure TForm8.FormCreate(Sender: TObject);
var
  ChannelCueSheet: PChannelCueSheet;
//  CueSheetList: TCueSheetList;

  E: TEventMode;
  S: TStartMode;
  I: Integer;
  IT: TInputType;
  TransitionType: TTRType;
  TransitionRate: TTRRate;

  R: Integer;
begin
//  ShowMessage(TimecodeToString(FrameToTimecode(1)));
  GV_ChannelList := TChannelList.Create;
  GV_DCSList := TDCSList.Create;
  GV_SourceList := TSourceList.Create;
  GV_MCSList := TMCSList.Create;

  GV_ChannelCueSheetList := TChannelCueSheetList.Create;

  GV_ProgramTypeList := TProgramTypeList.Create;

  LoadConfig;

  FIsCellEditing := False;
  FIsCellModified := False;

  FXmlParser := TXmlParser.Create;

  FActiveCueSheetList := GV_ChannelCueSheetList[0].CueSheetList;

  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_GROUP] do
  begin
    ReadOnly := True;

  end;

  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_NO] do
    ReadOnly := True;

  // Column Dropdown List : Event Mode
  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_EVENT_MODE] do
  begin
    ReadOnly := True;

{    Editor := edComboList;
    for E := EM_MAIN to EM_JOIN do
    begin
      ComboItems.AddObject(EventModeNames[E], TObject(E));
    end; }
  end;

  // Column Dropdown List : Start Mode
  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_START_MODE] do
  begin
    Editor := edComboList;
    for S := SM_ABSOLUTE to SM_SUBEND do
    begin
      ComboItems.AddObject(StartModeNames[S], TObject(S));
    end;
  end;

  // Column : Start Time
  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_START_DATE] do
  begin
    Editor := edDateEdit;
  end;

  // Column : Start Time
  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_START_TIME] do
  begin
    Editor := edNormal;
//    EditMask := '!0000-!90-90 !90:00:00:00;1;';
    EditMask := '!90:00:00:00;1; ';
  end;

  // Column Dropdown List : Input Type
  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_INPUT] do
  begin
    Editor := edComboList;
    for IT := IT_MAIN to IT_AMIXER2 do
    begin
      ComboItems.AddObject(InputTypeNames[IT], TObject(IT));
    end;
  end;

  // Column Dropdown List : Output Type
  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_OUTPUT] do
  begin
    Editor := edComboList;
    ComboItems.Clear;
  end;

  // Column Dropdown List : Source
  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_SOURCE] do
  begin
    Editor := edComboList;
    for I := 0 to GV_SourceList.Count - 1 do
    begin
      if (not (GV_SourceList[I]^.SourceType in [ST_ROUTER, ST_MCS])) then
//        if (GV_SourceList[I]^.DCS <> nil) and (GV_SourceList[I]^.DCS^.Main) then
//         ComboItems.AddObject(String(GV_SourceList[I]^.Name), TObject(GV_SourceList[I]^.Handle));
          ComboItems.Add(String(GV_SourceList[I]^.Name));
    end;
  end;

  // Column : Duration TC
  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_DURATON] do
  begin
    Editor := edNormal;
    EditMask := '!90:00:00:00;1;';
  end;

  // Column : In TC
  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_IN_TC] do
  begin
    Editor := edNormal;
    EditMask := '!90:00:00:00;1;';
  end;

  // Column : Out TC
  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_OUT_TC] do
  begin
    Editor := edNormal;
    EditMask := '!90:00:00:00;1;';
  end;

  // Column Dropdown List : Transition Type
  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_TR_TYPE] do
  begin
    Editor := edComboList;
    for TransitionType := TT_FADE to TT_MIX do
    begin
      ComboItems.AddObject(TRTypeNames[TransitionType], TObject(TransitionType));
    end;
  end;

  // Columns Dropdown List : Transition Rate
  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_TR_RATE] do
  begin
    Editor := edComboList;
    for TransitionRate := TR_CUT to TR_SLOW do
    begin
      ComboItems.AddObject(TRRateNames[TransitionRate], TObject(TransitionRate));
    end;
  end;

  // Columns Dropdown List : Program Type
  with AdvColumnGrid1.Columns[IDX_COL_CUESHEET_PROGRAM_TYPE] do
  begin
    Editor := edComboList;
    for I := 0 to GV_ProgramTypeList.Count - 1 do
    begin
      ComboItems.AddObject(GV_ProgramTypeList[I]^.Name, TObject(GV_ProgramTypeList[I]^.Code));
    end;
  end;

  InitTimeline;


  with GV_SettingDCSPort do
  begin
    R := DCSInitialize(NotifyPort, InPort, OutPort);
    if (R <> D_OK) then
      ShowMessage('DCS initialize failed.');

    R := DCSDeviceStatusNotify(@DeviceStatusNotify);
    if (R <> D_OK) then
      ShowMessage('DeviceStatusNotify failed.');

    R := DCSEvenStatusNotify(@EventStatusNotify);
    if (R <> D_OK) then
      ShowMessage('EventStatusNotify failed.');
  end;

end;

procedure TForm8.FormDestroy(Sender: TObject);
begin
  DCSFinalize;

  SaveConfig;

  ClearProgramTypeList;

  ClearChannelCueSheetList;
  ClearMCSList;
  ClearSourceList;
  ClearDCSList;
  ClearChannelList;

  FreeAndNil(GV_ProgramTypeList);

  FreeAndNil(GV_ChannelCueSheetList);
  FreeAndNil(GV_MCSList);
  FreeAndNil(GV_SourceList);
  FreeAndNil(GV_DCSList);
  FreeAndNil(GV_ChannelList);

  FXmlParser.Free;
end;

procedure TForm8.FormShow(Sender: TObject);
begin
  SourceOpens;
end;

procedure TForm8.PopulateGridCellText(AIndex: Integer);
var
  Item: PCueSheetItem;
  R: Integer;
begin
  inherited;
  R := AIndex + CNT_CUESHEET_HEADER;
  if (R > (AdvColumnGrid1.RowCount - 1)) then exit;

  Item := GetCueSheetItemByIndex(AIndex);
  if (Item <> nil) then
  begin
    with AdvColumnGrid1 do
    begin
      with Item^ do
      begin
        if (EventMode = EM_COMMENT) then
        begin
          Cells[IDX_COL_CUESHEET_NO, R] := String(Title);
          MergeCells(IDX_COL_CUESHEET_NO, R, ColCount - IDX_COL_CUESHEET_NO, 1);
          exit;
        end
        else
        begin
          if (EventMode = EM_MAIN) then
          begin
            Cells[IDX_COL_CUESHEET_NO, R]         := Format('%d', [GroupNo + 1]);
//            Cells[IDX_COL_CUESHEET_START_DATE, R] := FormatDateTime(FORMAT_DATE, StartTime.D);
          end
          else
          begin
            Cells[IDX_COL_CUESHEET_NO, R]         := '';
//            Cells[IDX_COL_CUESHEET_START_DATE, R] := '';
          end;
        end;

        Cells[IDX_COL_CUESHEET_EVENT_MODE, R]   := EventModeShortNames[EventMode];
        Cells[IDX_COL_CUESHEET_START_MODE, R]   := StartModeNames[StartMode];
        Cells[IDX_COL_CUESHEET_START_DATE, R]   := FormatDateTime(FORMAT_DATE, StartTime.D);
        Cells[IDX_COL_CUESHEET_START_TIME, R]   := TimecodeToString(StartTime.T);
        Cells[IDX_COL_CUESHEET_INPUT, R]        := InputTypeNames[Input];

        if (Input in [IT_MAIN, IT_BACKUP]) then
          Cells[IDX_COL_CUESHEET_OUTPUT, R]     := OutputBkgndTypeNames[TOutputBkgndType(Output)]
        else
          Cells[IDX_COL_CUESHEET_OUTPUT, R]     := OutputKeyerTypeNames[TOutputKeyerType(Output)];

        Cells[IDX_COL_CUESHEET_EVENT_STATUS, R]  := EventStatusNames[EventStatus];
//        Cells[IDX_COL_CUESHEET_DEVICE_STATUS, R] := GetDeviceStatusName(DeviceStatus);

        Cells[IDX_COL_CUESHEET_TITLE, R]        := String(Title);
        Cells[IDX_COL_CUESHEET_SUB_TITLE, R]    := String(SubTitle);
        Cells[IDX_COL_CUESHEET_SOURCE, R]       := String(Source);
        Cells[IDX_COL_CUESHEET_MEDIA_ID, R]     := String(MediaId);
        Cells[IDX_COL_CUESHEET_DURATON, R]      := TimecodeToString(DurationTC);
        Cells[IDX_COL_CUESHEET_IN_TC, R]        := TimecodeToString(InTC);
        Cells[IDX_COL_CUESHEET_OUT_TC, R]       := TimecodeToString(OutTC);
        Cells[IDX_COL_CUESHEET_TR_TYPE, R]      := TRTypeNames[TransitionType];
        Cells[IDX_COL_CUESHEET_TR_RATE, R]      := TRRateNames[TransitionRate];
        Cells[IDX_COL_CUESHEET_PROGRAM_TYPE, R] := GetProgramTypeNameByCode(ProgramType);
        Cells[IDX_COL_CUESHEET_NOTES, R]        := String(Notes);
      end;
    end;
  end;
end;

procedure TForm8.LoadGrid;
var
  R, I, J: Integer;
  CGroupNo: Integer;
  CItem, NItem: PCueSheetItem;
begin
  inherited;
  if (FActiveCueSheetList = nil) then exit;

  with AdvColumnGrid1 do
  begin
    RowCount := FActiveCueSheetList.Count + CNT_CUESHEET_HEADER;
//    I := CNT_CUESHEET_HEADER;
//    J := CNT_CUESHEET_HEADER;
//    while (I < RowCount - CNT_CUESHEET_HEADER) do
//    begin
//    for R := CNT_CUESHEET_HEADER to RowCount - 1 do
    for I := 0 to FActiveCueSheetList.Count - 1 do
    begin
      PopulateGridCellText(I);
    end;

{    i := 1;
    j := 1;
    while (i<rowcount-1) do
    begin
      while (cells[1,j]=cells[1,j+1]) and (j<rowcount-1) do inc(j);
      if (i<>j) then AddNode(i,j-i+1);
      i := j + 1;
      j := i;
    end; }

    SaveFixedCells := False; // Because of node expand and collpase bug

    I := CNT_CUESHEET_HEADER;
    J := CNT_CUESHEET_HEADER;
    while (I < RowCount - 1) do
    begin
      CItem := FActiveCueSheetList[I - CNT_CUESHEET_HEADER];
      if (CItem <> nil) {and (J < RowCount - CNT_CUESHEET_HEADER - 1)} then
      begin
        if (CItem^.EventMode = EM_COMMENT) then
        begin
          Inc(I);
          Inc(J);
          Continue;
        end;

        while (J < Rowcount - 1) and (CItem^.GroupNo = FActiveCueSheetList[J - CNT_CUESHEET_HEADER + 1]^.GroupNo) do Inc(J);


{        NItem := FActiveCueSheetList[J - CNT_CUESHEET_HEADER + 1];
        while (NItem <> nil) and (CItem^.GroupNo = NItem^.GroupNo) do
        begin
          Inc(J);
          NItem := FActiveCueSheetList[J - CNT_CUESHEET_HEADER + 1];
        end;  }

        if (I <> J) then
          AddNode(I, J - I + 1);
      end;
      I := J + 1;
      J := I;
    end;


//    if (NoMerge) then
//      MergeCells(IDX_COL_CUESHEET_NO, PreRow, 1, RowCount - PreRow);

{    if (HIDE_SUB_EVENT) then
    begin
      for R := RowCount - 1 downto CNT_CUESHEET_HEADER do
      begin
        CueSheetItem := FActiveCueSheetList[R - CNT_CUESHEET_HEADER];
        if (CueSheetItem <> nil) and (not (CueSheetItem^.EventMode in [EM_MAIN, EM_COMMENT])) then HideRow(R);
      end;
    end;  }

    with Columns[IDX_COL_CUESHEET_GROUP] do
      AutoSize := True;

    ContractAll;
//    expandall;

//    AddNode(2, 2);
  end;
end;

procedure TForm8.ClearGrid;
begin
  with AdvColumnGrid1 do
  begin
    Clear;
  end;
end;

{procedure TForm8.SetGridCueSheetData(ARow: Integer);
var
  RCol, RRow: Integer;

  R, I, J: Integer;
  CGroupNo: Integer;
  CItem, NItem: PCueSheetItem;
begin
  inherited;
  if (FActiveCueSheetList = nil) then exit;

  with AdvColumnGrid1 do
  begin
    RRow := RealRowIndex(ARow);

    for R := CNT_CUESHEET_HEADER to RowCount - 1 do
    begin
      CItem := FActiveCueSheetList[R - CNT_CUESHEET_HEADER];
      if (CItem <> nil) then
      begin
        with CItem^ do
        begin
          if (EventMode = EM_COMMENT) then
          begin
            Cells[IDX_COL_CUESHEET_NO, R] := String(Title);
            MergeCells(IDX_COL_CUESHEET_NO, R, ColCount - IDX_COL_CUESHEET_NO, 1);
            Continue;
          end
          else
          begin
            if (EventMode = EM_MAIN) then
              Cells[IDX_COL_CUESHEET_NO, R] := Format('%d', [GroupNo + 1])
            else
              Cells[IDX_COL_CUESHEET_NO, R] := '';//Format('%d', [GroupNo + 1]);
          end;

          Cells[IDX_COL_CUESHEET_START_MODE, R]   := StartModeNames[StartMode];
          Cells[IDX_COL_CUESHEET_START_TIME, R]   := TimecodeToString(StartTime.T);
          Cells[IDX_COL_CUESHEET_INPUT, R]        := InputTypeNames[Input];

          if (Input in [IT_MAIN, IT_BACKUP]) then
            Cells[IDX_COL_CUESHEET_OUTPUT, R]     := OutputBkgndTypeNames[TOutputBkgndType(Output)]
          else
            Cells[IDX_COL_CUESHEET_OUTPUT, R]     := OutputKeyerTypeNames[TOutputKeyerType(Output)];

          Cells[IDX_COL_CUESHEET_TITLE, R]        := String(Title);
          Cells[IDX_COL_CUESHEET_SUB_TITLE, R]    := String(SubTitle);
          Cells[IDX_COL_CUESHEET_SOURCE, R]       := String(Source);
          Cells[IDX_COL_CUESHEET_MEDIA_ID, R]     := String(MediaId);
          Cells[IDX_COL_CUESHEET_DURATON, R]      := TimecodeToString(DurationTC);
          Cells[IDX_COL_CUESHEET_IN_TC, R]        := TimecodeToString(InTC);
          Cells[IDX_COL_CUESHEET_OUT_TC, R]       := TimecodeToString(OutTC);
          Cells[IDX_COL_CUESHEET_TR_TYPE, R]      := TRTypeNames[TransitionType];
          Cells[IDX_COL_CUESHEET_TR_RATE, R]      := TRRateNames[TransitionRate];
          Cells[IDX_COL_CUESHEET_PROGRAM_TYPE, R] := GetProgramTypeNameByCode(ProgramType);
          Cells[IDX_COL_CUESHEET_NOTES, R]        := String(Notes);
        end;
      end;

    end;
  end;
end;
}

procedure TForm8.InitTimeline;
var
  I: Integer;
begin
  for I := 0 to WMTimeLine1.DataGroupProperty.Count - 1 do
  begin
    WMTimeLine1.DataCompositionBars[I].Height := 100;
    WMTimeLine1.DataCompositionBars[I].CompositionStyle := csCollapse;
  end;

  WMTimeLine1.DataCompositionBars[0].Name := 'Main';
  WMTimeLine1.DataCompositionBars[1].Name := 'Join';
  WMTimeLine1.DataCompositionBars[2].Name := 'Sub1';
  WMTimeLine1.DataCompositionBars[3].Name := 'Sub2';
end;

procedure TForm8.LoadTimeline;
var
  I: Integer;
  CueSheetItem: PCueSheetItem;
  Track: TTrack;
  SourceType: TSourceType;

  ParentStartTime: TEventTime;
  MinPoint, MaxPoint: Integer;
begin
  if (WMTimeLine1.DataGroupProperty.Count <= 0) then exit;

  MinPoint := MaxInt;
  MaxPoint := 0;

  for I := 0 to WMTimeLine1.DataGroupProperty.Count - 1 do
    WMTimeLine1.DataCompositions[I].Tracks.BeginUpdate;

  try
    for I := 0 to FActiveCueSheetList.Count - 1 do
    begin
      CueSheetItem := FActiveCueSheetList[I];

      if (CueSheetItem <> nil) then
      begin
        with CueSheetItem^ do
        begin
          case EventMode of
            EM_MAIN:
            begin
              Track := WMTimeLine1.DataCompositions[0].Tracks.Add;
              ParentStartTime := StartTime;

              Track.Duration := TimecodeToFrame(DurationTc);
              Track.InPoint  := TimecodeToFrame(StartTime.T);
              Track.OutPoint := Track.InPoint + Track.Duration;
            end;
            EM_JOIN:
            begin
              Track := WMTimeLine1.DataCompositions[1].Tracks.Add;

              Track.Duration := TimecodeToFrame(DurationTc);
              Track.InPoint  := TimecodeToFrame(GetPlusTimecode(ParentStartTime.T, StartTime.T));
              Track.OutPoint := Track.InPoint + Track.Duration;
            end
            else Continue;
          end;

{          SourceType := GetSourceTypeByName(String(Source));
          case SourceType of
            ST_VSDEC:
            begin
              Track.Color := $00CD9F79;
              Track.SelectedColor := $00B57744;
            end;
          end; }

          Track.Color         := GetProgramTypeColorByCode(ProgramType);
          Track.SelectedColor := Track.Color;

          Track.Caption := String(Title);

          if (Track.InPoint < MinPoint) then MinPoint := Track.InPoint;
          if (Track.OutPoint < MaxPoint) then MaxPoint := Track.OutPoint;
        end;
      end;
    end;

    WMTimeLine1.TimeZoneProperty.FrameStart := MinPoint - TIMELINE_SIDE_FRAMES;
    WMTimeLine1.FrameNumber := MinPoint - TIMELINE_SIDE_FRAMES;
  finally
    for I := 0 to WMTimeLine1.DataGroupProperty.Count - 1 do
      WMTimeLine1.DataCompositions[I].Tracks.EndUpdate;
  end;
end;

function TForm8.IsValidStartDate(AItem: PCueSheetItem; AStartDate: TDate): Boolean;
var
  PItem: PCueSheetItem;   // Parent cuesheet item
  PEndTime: TEventTime;   // parent end time

  StartTime: TEventTime;  // Current start time
begin
  Result := False;

  // Checks whether the entered start time is less than the start time of the previous event.
  PItem := GetBeforeMainItemByItem(AItem);
  if (PItem <> nil) then
  begin
    // Get parent end time
    PEndTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC);

    if (AItem^.EventMode = EM_MAIN) then
    begin
      // Get current start time
      StartTime   := AItem^.StartTime;
      StartTime.D := AStartDate;

      if (CompareEventTime(StartTime, PEndTime) < 0) then
      begin
        MessageBeep(MB_ICONWARNING);
        MessageBox(Handle, PChar(SStartTimeGreaterThenBeforeEndTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
        exit;
      end;
    end;
  end;

  Result := True;
end;

function TForm8.IsValidStartTC(AItem: PCueSheetItem; AStartTC: TTimecode): Boolean;
var
  PItem: PCueSheetItem;   // Parent cuesheet item
  PEndTime: TEventTime;   // parent end time

  StartTime: TEventTime;  // Current start time
  EndTime: TEventTime;    // Current end time
begin
  Result := False;

  // Check that the entered timecode is validate.
  if (not IsValidTimecode(AStartTC)) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SInvalidTimeocde), PChar(Application.Title), MB_OK or MB_ICONWARNING);
    exit;
  end;

  // Checks whether the entered start time is less than the start time of the previous event.
  PItem := GetBeforeMainItemByItem(AItem);
  if (PItem <> nil) then
  begin
    // Get parent end time
    PEndTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC);

    if (AItem^.EventMode = EM_MAIN) then
    begin
      // Get current start time
      StartTime   := AItem^.StartTime;
      StartTime.T := AStartTC;

      if (CompareEventTime(StartTime, PEndTime) < 0) then
      begin
        MessageBeep(MB_ICONWARNING);
        MessageBox(Handle, PChar(SStartTimeGreaterThenBeforeEndTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
        exit;
      end;
    end
    else if (AItem^.EventMode in [EM_JOIN, EM_SUB]) then
    begin
      // Get current start time
      StartTime.D := 0;
      StartTime.T := AStartTC;

      if (AItem^.StartMode = SM_SUBBEGIN) then
      begin
        // Get current end time
        EndTime := GetEventEndTime(GetPlusEventTime(PItem^.StartTime, StartTime), AItem^.DurationTC);
        if (CompareEventTime(EndTime, PEndTime) > 0) then
        begin
          MessageBeep(MB_ICONWARNING);
          MessageBox(Handle, PChar(SSubStartTimeLessThenParentEndTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
          exit;
        end;
      end
      else
        // Get current end time
        EndTime := GetEventEndTime(GetMinusEventTime(PEndTime, StartTime), AItem^.DurationTC);

        if (CompareEventTime(EndTime, PEndTime) > 0) then
        begin
          MessageBeep(MB_ICONWARNING);
          MessageBox(Handle, PChar(SSubStartTimeLessThenParentEndTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
          exit;
        end
        else if (AStartTC > PItem^.DurationTC) then
        begin
          MessageBeep(MB_ICONWARNING);
          MessageBox(Handle, PChar(SSubStartTimeGreaterThenParentStartTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
          exit;
        end;
    end;
  end;

  Result := True;
end;

function TForm8.IsValidDuration(AItem: PCueSheetItem; ADuration: TTimecode): Boolean;
var
  PItem: PCueSheetItem; // Parent cuesheet item
  PEndTime: TEventTime; // parent end time

  EndTime: TEventTime;  // Current end time
begin
  Result := False;

  // Check that the entered timecode is validate.
  if (not IsValidTimecode(ADuration)) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SInvalidTimeocde), PChar(Application.Title), MB_OK or MB_ICONWARNING);
    exit;
  end;

  // Feture add the media duration validate
  //
  //

  if (AItem^.EventMode in [EM_JOIN, EM_SUB]) then
  begin
    // Checks whether the entered end time is less than the end time of the parent event.
    PItem := GetParentCueSheetItemByItem(AItem);
    if (PItem <> nil) then
    begin
      // Get parent end time
      PEndTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC);

      if (AItem^.StartMode = SM_SUBBEGIN) then
      begin
        // Get current end time
        EndTime := GetEventTimeSubBegin(PItem^.StartTime, AItem^.InTC);
        EndTime := GetEventEndTime(EndTime, ADuration);

        if (CompareEventTime(EndTime, PEndTime) > 0) then
        begin
          MessageBeep(MB_ICONWARNING);
          MessageBox(Handle, PChar(SSubStartTimeLessThenParentEndTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
          exit;
        end;
      end
      else
      begin
        // Get current end time
        EndTime := GetEventTimeSubEnd(PItem^.StartTime, PItem^.DurationTC, AItem^.StartTime.T);
        EndTime := GetEventEndTime(EndTime, ADuration);

        if (CompareEventTime(EndTime, PEndTime) > 0) then
        begin
          MessageBeep(MB_ICONWARNING);
          MessageBox(Handle, PChar(SSubStartTimeLessThenParentEndTime), PChar(Application.Title), MB_OK or MB_ICONWARNING);
          exit;
        end;
      end;
    end;
  end;
  Result := True;
end;

function TForm8.IsValidInTC(AItem: PCueSheetItem; AInTC: TTimecode): Boolean;
begin
  Result := False;

  // Check that the entered timecode is validate.
  if (not IsValidTimecode(AInTC)) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SInvalidTimeocde), PChar(Application.Title), MB_OK or MB_ICONWARNING);
    exit;
  end;

  if (AInTC >= AItem^.DurationTC) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SInTCLessThenDurationTC), PChar(Application.Title), MB_OK or MB_ICONWARNING);
    exit;
  end;

  if (AInTC > AItem^.OutTC) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SInTCLessThenOutTC), PChar(Application.Title), MB_OK or MB_ICONWARNING);
    exit;
  end;

  Result := True;
end;

function TForm8.IsValidOutTC(AItem: PCueSheetItem; AOutTC: TTimecode): Boolean;
begin
  Result := False;

  // Check that the entered timecode is validate.
  if (not IsValidTimecode(AOutTC)) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SInvalidTimeocde), PChar(Application.Title), MB_OK or MB_ICONWARNING);
    exit;
  end;

  if (AOutTC >= AItem^.DurationTC) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SOutTCLessThenDurationTC), PChar(Application.Title), MB_OK or MB_ICONWARNING);
    exit;
  end;

  if (AOutTC < AItem^.InTC) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SOutTCLessThenInTC), PChar(Application.Title), MB_OK or MB_ICONWARNING);
    exit;
  end;

  Result := True;
end;

procedure TForm8.ResetStartDate(AIndex: Integer; ADays: Integer);
var
  I: Integer;
  CItem: PCueSheetItem;
begin
  if (FActiveCueSheetList = nil) then exit;
  if (AIndex >= FActiveCueSheetList.Count) then exit;

  for I := AIndex to FActiveCueSheetList.Count - 1 do
  begin
    CItem := FActiveCueSheetList[I];
    if (CItem^.EventMode <> EM_COMMENT) then
    begin
      CItem^.StartTime.D := IncDay(CItem^.StartTime.D, ADays);

      AdvColumnGrid1.AllCells[IDX_COL_CUESHEET_START_DATE, I + CNT_CUESHEET_HEADER] := FormatDateTime(FORMAT_DATE, CItem^.StartTime.D);
    end;
  end;
end;

procedure TForm8.ResetStartTimePlus(AIndex: Integer; ADurEventTime: TEventTime);
var
  I: Integer;
  CItem, PItem: PCueSheetItem;
  CStartTime, PEndTime: TEventTime;
  PStartDate: TDate;    // Parent cuesheet start date
begin
  if (FActiveCueSheetList = nil) then exit;
  if (AIndex >= FActiveCueSheetList.Count) then exit;

  // Get next main event index
  for I := AIndex to FActiveCueSheetList.Count - 1 do
  begin
    CItem := FActiveCueSheetList[I];
    if (CItem <> nil) and (CItem^.EventMode = EM_MAIN) then
    begin
      AIndex := I;
      break;
    end;
  end;

  PItem := nil;
  PStartDate := 0;
  for I := AIndex to FActiveCueSheetList.Count - 1 do
  begin
    CItem := FActiveCueSheetList[I];
    if (CItem <> nil) then
    begin
      if (CItem^.EventMode <> EM_COMMENT) then
      begin
        // If then main event then checks whether the current start time is less than the start time of the previous event.
        if (CItem^.EventMode = EM_MAIN) then
        begin
          CStartTime := GetPlusEventTime(CItem^.StartTime, ADurEventTime);
          if (PItem <> nil) then
          begin
            PEndTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC);
            if (CompareEventTime(CStartTime, PEndTime) < 0) then
            begin
              CStartTime := PEndTime;
            end;
          end;
          PItem := CItem;

          PStartDate := CStartTime.D;

          CItem^.StartTime := CStartTime;
        end
        else
        begin
          CItem^.StartTime.D := PStartDate;
        end;


  //      AdvColumnGrid1.Cells[IDX_COL_CUESHEET_START_DATE, DispRow] := FormatDateTime(FORMAT_DATE, CItem^.StartTime.D);
  //      AdvColumnGrid1.Cells[IDX_COL_CUESHEET_START_TIME, DispRow] := TimecodeToString(CItem^.StartTime.T);


        AdvColumnGrid1.AllCells[IDX_COL_CUESHEET_START_DATE, I + CNT_CUESHEET_HEADER] := FormatDateTime(FORMAT_DATE, CItem^.StartTime.D);
        AdvColumnGrid1.AllCells[IDX_COL_CUESHEET_START_TIME, I + CNT_CUESHEET_HEADER] := TimecodeToString(CItem^.StartTime.T);
      end;
    end;
  end;
end;

procedure TForm8.ResetStartTimeMinus(AIndex: Integer; ADurEventTime: TEventTime);
var
  I: Integer;
  CItem, PItem: PCueSheetItem;
  CStartTime, PEndTime: TEventTime;
  PStartDate: TDate;    // Parent cuesheet start date
begin
  if (FActiveCueSheetList = nil) then exit;
  if (AIndex >= FActiveCueSheetList.Count) then exit;

  PItem := nil;
  PStartDate := 0;
  for I := AIndex to FActiveCueSheetList.Count - 1 do
  begin
    CItem := FActiveCueSheetList[I];
    if (CItem^.EventMode <> EM_COMMENT) then
    begin
      // If then main event then checks whether the current start time is less than the start time of the previous event.
      if (CItem^.EventMode = EM_MAIN) then
      begin
        CStartTime := GetMinusEventTime(CItem^.StartTime, ADurEventTime);
        if (PItem <> nil) then
        begin
          PEndTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC);
          if (CompareEventTime(CStartTime, PEndTime) < 0) then
          begin
            CStartTime := PEndTime;
          end;
        end;
        PItem := CItem;

        PStartDate := CStartTime.D;

        CItem^.StartTime := CStartTime;
      end
      else
      begin
        CItem^.StartTime.D := PStartDate;
      end;


//      AdvColumnGrid1.Cells[IDX_COL_CUESHEET_START_DATE, DispRow] := FormatDateTime(FORMAT_DATE, CItem^.StartTime.D);
//      AdvColumnGrid1.Cells[IDX_COL_CUESHEET_START_TIME, DispRow] := TimecodeToString(CItem^.StartTime.T);


      AdvColumnGrid1.AllCells[IDX_COL_CUESHEET_START_DATE, I + CNT_CUESHEET_HEADER] := FormatDateTime(FORMAT_DATE, CItem^.StartTime.D);
      AdvColumnGrid1.AllCells[IDX_COL_CUESHEET_START_TIME, I + CNT_CUESHEET_HEADER] := TimecodeToString(CItem^.StartTime.T);

    end;
  end;
end;

procedure TForm8.SourceOpens;
var
  I, J: Integer;
  R: Integer;
  SourceHandle: PSourceHandle;
  DeviceHandle: TDeviceHandle;
begin
//exit;
  for I := 0 to GV_SourceList.Count - 1 do
  begin
    if (GV_SourceList[I]^.Handles <> nil) then
    begin
      for J := 0 to GV_SourceList[I]^.Handles.Count - 1 do
      begin
        SourceHandle := GV_SourceList[I]^.Handles[J];
  //    ShowMessage(DCS^.HostIP);
  //    ShowMessage(GV_SourceList[I]^.Name);
        R := DCSOpen(SourceHandle^.DCSID, SourceHandle^.DCSIP, GV_SourceList[I]^.Name, DeviceHandle);
        if (R = D_OK) then
        begin
          SourceHandle^.Handle := DeviceHandle;
//          ShowMessage(Format('Success ID=%d, IP=%s, DeviceName=%s, DeviceHandle=%d', [SourceHandle^.DCSID, SourceHandle^.DCSIP, GV_SourceList[I]^.Name, DeviceHandle]));
        end
        else
        begin
          SourceHandle^.Handle := DeviceHandle;
          ShowMessage(Format('Fail ID=%d, IP=%s, DeviceName=%s, DeviceHandle=%d', [SourceHandle^.DCSID, SourceHandle^.DCSIP, GV_SourceList[I]^.Name, DeviceHandle]));
        end;
      end;
    end;
  end;
end;

procedure TForm8.SourceCloses;
var
  I, J: Integer;
  R: Integer;
  SourceHandle: PSourceHandle;
begin
//exit;
  for I := GV_SourceList.Count - 1 downto 0 do
  begin
    if (GV_SourceList[I]^.Handles <> nil) then
    begin
      for J := 0 to GV_SourceList[I]^.Handles.Count - 1 do
      begin
        SourceHandle := GV_SourceList[I]^.Handles[J];

        if (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
        begin
          R := DCSClose(SourceHandle^.DCSID, SourceHandle^.Handle);
          if (R <> D_OK) then
            ShowMessage(Format('Close Failed ID=%d, Handle=%d, Name=%s', [SourceHandle^.DCSID, SourceHandle^.Handle, GV_SourceList[I]^.Name]));
        end;
      end;
    end;
  end;
end;

procedure TForm8.InputEvent(AIndex: Integer);
var
  I: Integer;
  R: Integer;
  DCS: PDCS;

  C: PCueSheetItem;
  E: TEvent;
begin
  C := FActiveCueSheetList[AIndex];
end;

function TForm8.GetCueSheetItemByIndex(AIndex: Integer): PCueSheetItem;
begin
  Result := nil;

  if (FActiveCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FActiveCueSheetList.Count - 1) then exit;

  Result := FActiveCueSheetList[AIndex];
end;

function TForm8.GetCueSheetItemBySourceName(AName: String): PCueSheetItem;
begin
//  Get
//  if ( then

end;

function TForm8.GetParentCueSheetItemByIndex(AIndex: Integer): PCueSheetItem;
var
  I: Integer;
  CItem, ParentItem: PCueSheetItem;
begin
  Result := nil;

  if (FActiveCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FActiveCueSheetList.Count - 1) then exit;

  CItem := FActiveCueSheetList[AIndex];

  for I := AIndex downto 0 do
  begin
    ParentItem := FActiveCueSheetList[I];
    if (ParentItem^.GroupNo = CItem^.GroupNo) and (ParentItem^.EventMode = EM_MAIN) then
    begin
      Result := ParentItem;
      break;
    end;
//    else if (P^.GroupNo > C^.GroupNo) then break;
  end;
end;

function TForm8.GetParentCueSheetItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I, CurrIndex: Integer;
  ParentItem: PCueSheetItem;
begin
  Result := nil;

  if (FActiveCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  CurrIndex := FActiveCueSheetList.IndexOf(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex downto 0 do
  begin
    ParentItem := FActiveCueSheetList[I];
    if (ParentItem^.GroupNo = AItem^.GroupNo) and (ParentItem^.EventMode = EM_MAIN) then
    begin
      Result := ParentItem;
      break;
    end;
//    else if (P^.GroupNo > C^.GroupNo) then break;
  end;
end;

function TForm8.GetBeforeMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I, CurrIndex: Integer;
  PItem: PCueSheetItem;
begin
  Result := nil;

  if (FActiveCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  CurrIndex := FActiveCueSheetList.IndexOf(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex - 1 downto 0 do
  begin
    PItem := FActiveCueSheetList[I];
    if (PItem^.EventMode = EM_MAIN) then
    begin
      Result := PItem;
      break;
    end;
  end;
end;

function TForm8.MakePlayerEvent(AItem: PCueSheetItem; var AEvent: TEvent): Integer;
var
  ParentItem: PCueSheetItem;
begin
  Result := D_FALSE;

  FillChar(AEvent, SizeOf(TEvent), #0);
  with AEvent do
  begin
    EventID   := AItem^.EventID;
    StartTime := AItem^.StartTime;
    if (AItem^.StartMode in [SM_SUBBEGIN, SM_SUBEND]) then
    begin
      ParentItem := GetParentCueSheetItemByItem(AItem);
      if (ParentItem <> nil) then
      begin
        if (AItem^.StartMode = SM_SUBBEGIN) then
        begin
//          StartTime := GetPlusEventTime(ParentItem^.StartTime, TimecodeToEventTime(AItem^.StartTime.T));

//          StartTime := ParentItem^.StartTime;
//          StartTime.T := StartTime.T + AItem^.StartTime.T;

          StartTime := GetEventTimeSubBegin(ParentItem^.StartTime, AItem^.StartTime.T);

//            ShowMessage(DateTimeToStr(EventTimeToDateTime(StartTime)));
        end
        else
        begin
//          StartTime := GetMinusEventTime(GetPlusEventTime(ParentItem^.StartTime, TimecodeToEventTime(ParentItem^.DurationTC)), TimecodeToEventTime(AItem^.StartTime.T));

//          StartTime := ParentItem^.StartTime;
//          StartTime.T := StartTime.T + ParentItem^.DurationTC;
//          StartTime.T := StartTime.T - AItem^.StartTime.T - AItem^.DurationTC;

          StartTime := GetEventTimeSubEnd(ParentItem^.StartTime, ParentItem^.DurationTC, AItem^.StartTime.T);

//            ShowMessage(DateTimeToStr(EventTimeToDateTime(StartTime)));
        end;
      end;
    end;
//      ShowMessage(DateTimeToStr(EventTimeToDateTime(StartTime)));
    DurTime             := AItem^.DurationTC;
    TakeEvent           := False;
    ManualEvent         := (AItem^.StartMode = SM_MANUAL);
    EventType           := ET_PLAYER;
    Player.StartTC      := AItem^.InTC;
//    Player.FinishAction := ACueSheet^.FinishAction;
//    StrCopy(Player.ID.BinNo, ACueSheet^.BinNo);
    StrCopy(Player.ID.ID, AItem^.MediaId);
  end;

  Result := D_OK;
end;

function TForm8.MakeSwitcherEvent(AItem: PCueSheetItem; var AEvent: TEvent): Integer;
var
  ParentItem: PCueSheetItem;
begin
  Result := D_FALSE;

  FillChar(AEvent, SizeOf(TEvent), #0);
  with AEvent do
  begin
    EventID   := AItem^.EventID;
    StartTime := AItem^.StartTime;
    if (AItem^.StartMode in [SM_SUBBEGIN, SM_SUBEND]) then
    begin
      ParentItem := GetParentCueSheetItemByItem(AItem);
      if (ParentItem <> nil) then
      begin
        if (AItem^.StartMode = SM_SUBBEGIN) then
        begin
//          StartTime := GetPlusEventTime(ParentItem^.StartTime, TimecodeToEventTime(AItem^.StartTime.T));

//          StartTime := ParentItem^.StartTime;
//          StartTime.T := StartTime.T + AItem^.StartTime.T;

          StartTime := GetEventTimeSubBegin(ParentItem^.StartTime, AItem^.StartTime.T);

//            ShowMessage(DateTimeToStr(EventTimeToDateTime(StartTime)));
        end
        else
        begin
//          StartTime := GetMinusEventTime(GetPlusEventTime(ParentItem^.StartTime, TimecodeToEventTime(ParentItem^.DurationTC)), TimecodeToEventTime(AItem^.StartTime.T));

//          StartTime := ParentItem^.StartTime;
//          StartTime.T := StartTime.T + ParentItem^.DurationTC;
//          StartTime.T := StartTime.T - AItem^.StartTime.T - AItem^.DurationTC;

          StartTime := GetEventTimeSubEnd(ParentItem^.StartTime, ParentItem^.DurationTC, AItem^.StartTime.T);

//            ShowMessage(DateTimeToStr(EventTimeToDateTime(StartTime)));
        end;
      end;
    end;
//      ShowMessage(DateTimeToStr(EventTimeToDateTime(StartTime)));
    DurTime             := AItem^.DurationTC;
    TakeEvent           := False;
    ManualEvent         := (AItem^.StartMode = SM_MANUAL);
    EventType           := ET_PLAYER;
    Player.StartTC      := AItem^.InTC;
//    Player.FinishAction := ACueSheet^.FinishAction;
//    StrCopy(Player.ID.BinNo, ACueSheet^.BinNo);
    StrCopy(Player.ID.ID, AItem^.MediaId);
  end;

  Result := D_OK;
end;

function TForm8.PlayerInputEvent(AItem: PCueSheetItem): Integer;
var
  I: Integer;
  Source: PSource;
  SourceHandles: TSourceHandleList;
  Event: TEvent;
begin
  Result := D_FALSE;

  if (AItem^.EventMode = EM_COMMENT) then exit;

  Source := GetSourceByName(String(AItem^.Source));
  if (Source = nil) then exit;

  SourceHandles := Source^.Handles;
  if (SourceHandles = nil) or (SourceHandles.Count <= 0) then exit;

  Result := MakePlayerEvent(AItem, Event);
  if (Result = D_OK) then
  begin
    for I := 0 to SourceHandles.Count - 1 do
      Result := DCSInputEvent(SourceHandles[I]^.DCSID, SourceHandles[I]^.Handle, Event);
  end;
end;

procedure DeviceStatusNotify(ADCSIP: PChar; ADeviceHandle: TDeviceHandle; AStatus: TDeviceStatus);
var
  I, J: Integer;
  Source: PSource;
  SourceHandles: TSourceHandleList;
begin
  Source := nil;
  for I := 0 to GV_SourceList.Count - 1 do
  begin
    SourceHandles := GV_SourceList[I]^.Handles;
    if (SourceHandles <> nil) then
    begin
      for J := 0 to SourceHandles.Count - 1 do
        if (String(SourceHandles[J].DCSIP) = String(ADCSIP)) and
           (SourceHandles[J].Handle = ADeviceHandle) then
        begin
          Source := GV_SourceList[I];
          break;
        end;
    end;
    if (Source <> nil) then break;
  end;

  if (Source = nil) then exit;
end;

procedure EventStatusNotify(ADCSIP: PChar; AEventID: TEventID; AStatus: TEventStatus);
var
  Item: PCueSheetItem;
begin
//  Item := GetParentForm()
  Item := nil;
end;

end.
