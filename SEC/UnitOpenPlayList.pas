unit UnitOpenPlayList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitSingleForm, WMTools, WMControls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Samples.Gauges,
  System.Actions, Vcl.ActnList, Xml.VerySimple,
  UnitCommons, UnitConsts, UnitDCSDLL, UnitMCCDLL,
  UnitChannel;

type
  TOpenPlaylistThread = class;

  TfrmOpenPlayList = class(TfrmSingle)
    lblPlaylistName: TLabel;
    lblStatus: TLabel;
    wmibCancel: TWMImageButton;
    aLstStart: TActionList;
    actCancel: TAction;
    gaProgress: TGauge;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lblPlaylistNameClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FChannelForm: TfrmChannel;

    FModalResult: TModalResult;
    FFileName: String;
    FIsAdd: Boolean;

    FLoadChannelCueSheet: PChannelCueSheet;          // 로딩한 채널 큐시트
    FLoadCueSheetList: TCueSheetList;                // 로딩한 채널 큐시트 항목

    FIsCheckCancel: Boolean;
    FOpenPlaylistThread: TOpenPlaylistThread;

    procedure WMUpdateChannelOpenFileName(var Message: TMessage); message WM_UPDATE_CHANNEL_OPEN_FILENAME;
    procedure WMUpdateChannelOpenStatus(var Message: TMessage); message WM_UPDATE_CHANNEL_OPEN_STATUS;
    procedure WMUpdateChannelOpenProgress(var Message: TMessage); message WM_UPDATE_CHANNEL_OPEN_PROGRESS;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AFileName: String; AAdd: Boolean = False); overload;

    property LoadChannelCueSheet: PChannelCueSheet read FLoadChannelCueSheet;
    property LoadCueSheetList: TCueSheetList read FLoadCueSheetList;
  end;

  TOpenPlaylistThread = class(TThread)
  private
    { Private declarations }
    FForm: TfrmOpenPlaylist;
    FChannelForm: TfrmChannel;

    procedure AddPlayListItem(AItem: PCueSheetItem; AIndex: Integer; AStartIndex: Integer = 0);
    procedure LoadPlayListItem(AChannelCueSheet: PChannelCueSheet; ACueSheetList: TCueSheetList; AEventsNode: TXmlNode; AIndex: Integer; AAdd: Boolean = False; ASerialNo: Integer = -1);
    procedure OpenPlayListXML(AFileName: String; AAdd: Boolean = False; AStartIndex: Integer = 0);

    procedure DoWaitShowing;
    procedure DoOpenPlayListXML;
    procedure DoComplete;
  protected
    procedure Execute; override;
  public
    constructor Create(AForm: TfrmOpenPlaylist);
    destructor Destroy; override;
  end;

var
  frmOpenPlayList: TfrmOpenPlayList;

implementation

uses System.Math;

{$R *.dfm}

constructor TfrmOpenPlayList.Create(AOwner: TComponent; AFileName: String; AAdd: Boolean = False);
begin
  inherited Create(AOwner);

  FChannelForm := (AOwner as TfrmChannel);

  FModalResult := mrOk;

  FFileName := AFileName;
  FIsAdd := AAdd;

  FLoadChannelCueSheet := New(PChannelCueSheet);
  FillChar(FLoadChannelCueSheet^, SizeOf(TChannelCueSheet), #0);
  with FLoadChannelCueSheet^ do
  begin
    StrPLCopy(FileName, AFileName, MAX_PATH);
    ChannelID := FChannelForm.ChannelID;
  end;

  FLoadCueSheetList := TCueSheetList.Create;
end;

procedure TfrmOpenPlayList.WMUpdateChannelOpenFileName(var Message: TMessage);
var
  FileNameLen: Integer;
  FileNameStr: PChar;
begin
  FileNameLen := Message.WParam;

  if (FileNameLen > 0) then
  begin
    FileNameStr := StrAlloc(FileNameLen);
    try
      if ((GlobalGetAtomName(Message.LParam, FileNameStr, FileNameLen)) > 0) then
      begin
        lblPlaylistName.Caption := StrPas(FileNameStr);
      end;
    finally
      StrDispose(FileNameStr);
    end;
  end;
end;

procedure TfrmOpenPlayList.WMUpdateChannelOpenStatus(var Message: TMessage);
var
  StatusLen: Integer;
  StatusStr: PChar;
begin
  StatusLen := Message.WParam;

  if (StatusLen > 0) then
  begin
    StatusStr := StrAlloc(StatusLen);
    try
      if ((GlobalGetAtomName(Message.LParam, StatusStr, StatusLen)) > 0) then
      begin
        lblStatus.Caption := StrPas(StatusStr);
      end;
    finally
      StrDispose(StatusStr);
    end;
  end;
end;

procedure TfrmOpenPlayList.WMUpdateChannelOpenProgress(var Message: TMessage);
var
  MaxValue, Progress: Integer;
begin
  MaxValue := Message.WParam;
  Progress := Message.LParam;

  gaProgress.MaxValue := MaxValue;
  gaProgress.Progress := Progress;
end;

procedure TfrmOpenPlayList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  ModalResult := FModalResult;
end;

procedure TfrmOpenPlayList.FormCreate(Sender: TObject);
begin
  inherited;

  lblPlaylistName.Caption := FFileName;

  FIsCheckCancel := False;

  ModalResult := mrOK;

  FOpenPlaylistThread := TOpenPlaylistThread.Create(Self);
end;

procedure TfrmOpenPlayList.FormDestroy(Sender: TObject);
var
  I: Integer;
  Item: PCueSheetItem;
begin
  inherited;

  if (FOpenPlaylistThread <> nil) then
  begin
    FOpenPlaylistThread.Terminate;
    FOpenPlaylistThread.WaitFor;
    FreeAndNil(FOpenPlaylistThread);
  end;

  if (ModalResult <> mrOK) then
  begin
    if (FLoadChannelCueSheet <> nil) then
    begin
      Dispose(FLoadChannelCueSheet);
      FLoadChannelCueSheet := nil;
    end;

    for I := FLoadCueSheetList.Count - 1 downto 0 do
    begin
      Item := FLoadCueSheetList[I];
      if (Item <> nil) then
      begin
        FLoadCueSheetList.Remove(Item);
        Dispose(Item);
      end;
    end;
  end;

  FreeAndNil(FLoadCueSheetList);
end;

procedure TfrmOpenPlayList.FormShow(Sender: TObject);
begin
  inherited;

  if (FOpenPlaylistThread <> nil) then
    FOpenPlaylistThread.Start;
end;

procedure TfrmOpenPlayList.lblPlaylistNameClick(Sender: TObject);
begin
  inherited;

end;

{ TOpenPlaylistThread }

constructor TOpenPlaylistThread.Create(AForm: TfrmOpenPlaylist);
begin
  FForm := AForm;
  FChannelForm := (AForm.Owner as TfrmChannel);

  FreeOnTerminate := False;

  inherited Create(True);
end;

destructor TOpenPlaylistThread.Destroy;
begin
  inherited Destroy;
end;

procedure TOpenPlaylistThread.AddPlayListItem(AItem: PCueSheetItem; AIndex: Integer; AStartIndex: Integer = 0);
begin
  FChannelForm.CueSheetLock.Enter;
  try
    if (AStartIndex >= FChannelForm.CueSheetList.Count - AIndex) then
    begin
      FChannelForm.CueSheetList.Add(AItem);
    end
    else
    begin
      FChannelForm.CueSheetList.Insert(AStartIndex + AIndex, AItem);
    end;
  finally
    FChannelForm.CueSheetLock.Leave;
  end;
end;

procedure TOpenPlaylistThread.LoadPlayListItem(AChannelCueSheet: PChannelCueSheet; ACueSheetList: TCueSheetList; AEventsNode: TXmlNode; AIndex: Integer; AAdd: Boolean = False; ASerialNo: Integer = -1);
var
  EventNode: TXmlNode;
  Item: PCueSheetItem;
begin
  if (AChannelCueSheet = nil) then exit;
  if (ACueSheetList = nil) then exit;
  if (AEventsNode = nil) then exit;

  Item := New(PCueSheetItem);
  FillChar(Item^, SizeOf(TCueSheetItem), #0);
  with Item^ do
  begin
    EventID.ChannelID := AChannelCueSheet^.ChannelID;
    StrCopy(EventID.OnAirDate, AChannelCueSheet^.OnairDate);
    EventID.OnAirFlag := AChannelCueSheet^.OnairFlag;
    EventID.OnAirNo   := AChannelCueSheet^.OnairNo;

    EventNode := AEventsNode.ChildNodes[AIndex];

    EventStatus.State := TEventState(StrToIntDef(EventNode.Attributes[XML_ATTR_STATUS], 0));
    EventStatus.ErrorCode := E_NO_ERROR; // 추후 errorcode 포함여부 결정

{            // Play list를 처음 open 했을 경우에만 큐시트의 SerialNo로 저장
    if (FLastCount <= 0) then
    begin
      FLastSerialNo := StrToIntDef(EventNode.Attributes[XML_ATTR_SERIAL_NO], 0);
    end
    else
    begin
      FLastSerialNo := FLastSerialNo + 1;
    end;  }

    // 중복된 큐시트가 로딩되어 있을 경우 이미 로딩된 큐시트의 마지막 SerialNo를 증가시켜서 구함
    if (AAdd) and (ASerialNo >= 0) then
    begin
      EventID.SerialNo := ASerialNo;
      Inc(ASerialNo);
    end
    else
      EventID.SerialNo := StrToIntDef(EventNode.Attributes[XML_ATTR_SERIAL_NO], 0);

    AChannelCueSheet^.LastSerialNo := Max(AChannelCueSheet^.LastSerialNo, EventID.SerialNo);

    // Play list를 처음 open 했을 경우에만 큐시트의 ProgramNo로 저장
{            FLastProgramNo := StrToIntDef(EventNode.Attributes[XML_ATTR_PROGRAM_NO], 0);
    if (FLastCount <= 0) then
    begin
      ProgramNo := FLastProgramNo;
    end
    else
    begin
      ProgramNo := ProgramNo + FLastProgramNo;
    end; }

    ProgramNo := StrToIntDef(EventNode.Attributes[XML_ATTR_PROGRAM_NO], 0);
    AChannelCueSheet^.LastProgramNo := Max(AChannelCueSheet^.LastProgramNo, ProgramNo);

{            // Play list를 처음 open 했을 경우에만 큐시트의 GroupNo로 저장
    FLastGroupNo := StrToIntDef(EventNode.Attributes[XML_ATTR_GROUP_NO], 0);
    if (FLastCount <= 0) then
    begin
      GroupNo := FLastGroupNo;
    end
    else
    begin
      GroupNo := GroupNo + FLastGroupNo;
    end; }

    GroupNo := StrToIntDef(EventNode.Attributes[XML_ATTR_GROUP_NO], 0);
    AChannelCueSheet^.LastGroupNo := Max(AChannelCueSheet^.LastGroupNo, GroupNo);

    EventMode := TEventMode(StrToIntDef(EventNode.Attributes[XML_ATTR_EVENT_MODE], 0));
    if (EventMode = EM_MAIN) then
      FChannelForm.LastDisplayNo := FChannelForm.LastDisplayNo + 1;

    DisplayNo := FChannelForm.LastDisplayNo;

    StartMode := TStartMode(StrToIntDef(EventNode.Attributes[XML_ATTR_START_MODE], 0));
    StartTime := DateTimecodeStrToEventTime(EventNode.Attributes[XML_ATTR_START_TIME], FChannelForm.ChannelFrameRateType);
    Input := TInputType(StrToIntDef(EventNode.Attributes[XML_ATTR_INPUT], 0));
    Output := StrToIntDef(EventNode.Attributes[XML_ATTR_OUTPUT], 0);
    StrPLCopy(Title, EventNode.Attributes[XML_ATTR_TITLE], TITLE_LEN);
    StrPLCopy(SubTitle, EventNode.Attributes[XML_ATTR_SUB_TITLE], SUBTITLE_LEN);
    StrPLCopy(Source, EventNode.Attributes[XML_ATTR_SOURCE], DEVICENAME_LEN);
    SourceLayer := StrToIntDef(EventNode.Attributes[XML_ATTR_SOURCE_LAYER], 0);
    StrPLCopy(MediaId, EventNode.Attributes[XML_ATTR_MEDIA_ID], MEDIAID_LEN);
    DurationTC := StringToTimecode(EventNode.Attributes[XML_ATTR_DURATION_TC]);
    InTC := StringToTimecode(EventNode.Attributes[XML_ATTR_IN_TC]);
    OutTC := StringToTimecode(EventNode.Attributes[XML_ATTR_OUT_TC]);
    VideoType := TVideoType(StrToIntDef(EventNode.Attributes[XML_ATTR_VIDEO_TYPE], 0));
    AudioType := TAudioType(StrToIntDef(EventNode.Attributes[XML_ATTR_AUDIO_TYPE], 0));
    ClosedCaption := TClosedCaption(StrToIntDef(EventNode.Attributes[XML_ATTR_CLOSED_CAPTION], 0));
    VoiceAdd := TVoiceAdd(StrToIntDef(EventNode.Attributes[XML_ATTR_VOICE_ADD], 0));
    TransitionType := TTRType(StrToIntDef(EventNode.Attributes[XML_ATTR_TRANSITION_TYPE], 0));
    TransitionRate := TTRRate(StrToIntDef(EventNode.Attributes[XML_ATTR_TRANSITION_RATE], 0));
    FinishAction := TFinishAction(StrToIntDef(EventNode.Attributes[XML_ATTR_FINISH_ACTION], 0));
    ProgramType := StrToIntDef(EventNode.Attributes[XML_ATTR_PROGRAM_TYPE], 0);
    BkColor := COLOR_BK_EVENTSTATUS_NORMAL;
    TxColor := COLOR_TX_EVENTSTATUS_NORMAL;
    ToColor := COLOR_TO_EVENTSTATUS_NORMAL;
    StrPLCopy(Notes, EventNode.Attributes[XML_ATTR_NOTES], NOTES_LEN);
  end;

  ACueSheetList.Add(Item);
end;

procedure TOpenPlaylistThread.OpenPlayListXML(AFileName: String; AAdd: Boolean = False; AStartIndex: Integer = 0);
var
  MsgStrLen: Integer;
  MsgStrParam: DWORD;

  Xml: TXmlVerySimple;
  DataNode: TXmlNode;
  EventsNode, EventNode: TXmlNode;

  ChannelCueSheet: PChannelCueSheet;
  ChannelCueSheetSerialNo: Integer;

  I: Integer;
begin
  if (not FileExists(String(AFileName))) then exit;

  with FForm do
  begin
    MsgStrLen := Length(AFileName) + 1;
    MsgStrParam := GlobalAddAtom(PChar(AFileName));
    SendMessage(FForm.Handle, WM_UPDATE_CHANNEL_OPEN_FILENAME, MsgStrLen, MsgStrParam);

    MsgStrLen := Length(SLoadingCuesheetFile) + 1;
    MsgStrParam := GlobalAddAtom(PChar(SLoadingCuesheetFile));
    SendMessage(FForm.Handle, WM_UPDATE_CHANNEL_OPEN_STATUS, MsgStrLen, MsgStrParam);

    SendMessage(FForm.Handle, WM_UPDATE_CHANNEL_OPEN_PROGRESS, 100, 0);

    Xml := TXmlVerySimple.Create;
    try
      Xml.LoadFromFile(AFileName);
      if (Xml.DocumentElement = nil) then exit;

  //    DataNode := Xml.DocumentElement.Find('data');
  //    if (DataNode <> nil) then
      begin
        DataNode := Xml.DocumentElement.Find(XML_CHANNEL_ID);
        if (DataNode <> nil) then
          FLoadChannelCueSheet^.ChannelId := StrToIntDef(DataNode.NodeValue, 0);

        DataNode := Xml.DocumentElement.Find(XML_ONAIR_DATE);
        if (DataNode <> nil) then
          StrPLCopy(FLoadChannelCueSheet^.OnairDate, DataNode.NodeValue, DATE_LEN);

        DataNode := Xml.DocumentElement.Find(XML_ONAIR_FLAG);
        if (DataNode <> nil) then
        begin
          if (Length(DataNode.NodeValue) > 0) then
            FLoadChannelCueSheet^.OnairFlag := TOnAirFlagType(Ord(DataNode.NodeValue[1]))
          else
            FLoadChannelCueSheet^.OnairFlag := FT_REGULAR;
        end
        else
          FLoadChannelCueSheet^.OnairFlag := FT_REGULAR;

        DataNode := Xml.DocumentElement.Find(XML_ONAIR_NO);
        if (DataNode <> nil) then
          FLoadChannelCueSheet^.OnairNo := StrToIntDef(DataNode.NodeValue, 0);

        DataNode := Xml.DocumentElement.Find(XML_EVENT_COUNT);
        if (DataNode <> nil) then
          FLoadChannelCueSheet^.EventCount := StrToIntDef(DataNode.NodeValue, 0);

        FLoadChannelCueSheet^.LastSerialNo  := 0;
        FLoadChannelCueSheet^.LastProgramNo := 0;
        FLoadChannelCueSheet^.LastGroupNo   := 0;

        if (AAdd) then
        begin
          // 중복된 큐시트가 로딩되어 있을 경우 이미 로딩된 큐시트의 마지막 SerialNo를 구함
          ChannelCueSheet := FChannelForm.GetChannelCueSheetByDuplicate(OnAirDateToDate(LoadChannelCueSheet^.OnairDate), LoadChannelCueSheet^.OnairFlag, LoadChannelCueSheet^.OnairNo);
          if (ChannelCueSheet <> nil) then
            ChannelCueSheetSerialNo := ChannelCueSheet^.LastSerialNo + 1
          else
            ChannelCueSheetSerialNo := -1;
        end;

        EventsNode := Xml.DocumentElement.Find(XML_EVENTS);
        if (EventsNode <> nil) then
        begin
          PostMessage(FForm.Handle, WM_UPDATE_CHANNEL_OPEN_PROGRESS, EventsNode.ChildNodes.Count, 0);

          I := 0;
          while (not Terminated) and (I < EventsNode.ChildNodes.Count) do
          begin
            LoadPlayListItem(FLoadChannelCueSheet, FLoadCueSheetList, EventsNode, I, AAdd, ChannelCueSheetSerialNo);
            Inc(I);

            PostMessage(FForm.Handle, WM_UPDATE_CHANNEL_OPEN_PROGRESS, EventsNode.ChildNodes.Count, I);
          end;

          // 추후 이벤트 검사 시 큐시트의 EventCount와 실제 Count를 검사해야 함
          FLoadChannelCueSheet^.EventCount := FLoadCueSheetList.Count;
        end;
      end;
    finally
      FreeAndNil(Xml);
    end;
  end;
end;

procedure TOpenPlaylistThread.Execute;
begin
  { Place thread code here }
//  Synchronize(DoWaitShowing);
  DoOpenPlayListXML;
  DoComplete;
//  Synchronize(DoComplete);
end;

procedure TOpenPlaylistThread.DoWaitShowing;
begin
  while (not FForm.Showing) do
    Application.ProcessMessages;
end;

procedure TOpenPlaylistThread.DoOpenPlayListXML;
begin
  OpenPlayListXML(FForm.FFileName);
end;

procedure TOpenPlaylistThread.DoComplete;
var
  MsgStrLen: Integer;
  MsgStrParam: DWORD;
begin
  if (not Terminated) then
  begin
    MsgStrLen := Length(SUpdatingCuesheet) + 1;
    MsgStrParam := GlobalAddAtom(PChar(SUpdatingCuesheet));
    PostMessage(FForm.Handle, WM_UPDATE_CHANNEL_OPEN_STATUS, MsgStrLen, MsgStrParam);

    FChannelForm.AddLoadPlayList(FForm.LoadChannelCueSheet, FForm.LoadCueSheetList);

    MsgStrLen := Length(SCompletedLoadingCuesheetFile) + 1;
    MsgStrParam := GlobalAddAtom(PChar(SCompletedLoadingCuesheetFile));
    SendMessage(FForm.Handle, WM_UPDATE_CHANNEL_OPEN_STATUS, MsgStrLen, MsgStrParam);
  end;

  FForm.Close;
end;

end.
