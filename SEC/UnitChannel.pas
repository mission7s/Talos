unit UnitChannel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitWorkForm, AdvUtil, Vcl.Grids, Winapi.MMSystem,
  AdvObj, BaseGrid, AdvGrid, AdvCGrid, Vcl.Imaging.pngimage, System.SyncObjs,
  Vcl.ExtCtrls, Vcl.StdCtrls, System.Generics.Collections,
  AdvOfficePager, AdvSplitter,
  WMTools, WMUtils, WMControls, WMTimeLine, {LibXmlParserU, }Xml.VerySimple,
  UnitCommons, UnitAllChannels, UnitWarningDialog, UnitAlarmThread,
  UnitDCSDLL, UnitMCCDLL, UnitSECDLL, UnitConsts, Vcl.ComCtrls;

type
  TChannelTimerThread = class;
  TChannelCueSheetCheckThread = class;
  TChannelEventControlThread = class;
  TChannelAutoLoadPlayListThread = class;
  TChannelAutoEjectPlayListThread = class;
  TChannelMediaCheckThread = class;
  TChannelBlankCheckThread = class;
  TChannelInspectThread = class;

  TfrmChannel = class(TfrmWork)
    acgPlaylist: TAdvColumnGrid;
    WMPanel2: TWMPanel;
    pnlPlayedTime: TWMPanel;
    lblPlayedTime: TLabel;
    pnlRemainingTime: TWMPanel;
    lblRemainingTime: TLabel;
    pnlNextStart: TWMPanel;
    lblNextStart: TLabel;
    pnlNextDuration: TWMPanel;
    lblNextDuration: TLabel;
    AdvSplitter1: TAdvSplitter;
    lblPlayListFileName: TLabel;
    pnlOnairStatus: TWMPanel;
    pnlRemainingTarget: TWMPanel;
    lblRemainingTargetTime: TLabel;
    wmibFreezeOnAir: TWMImageSpeedButton;
    wmibAssignNext: TWMImageSpeedButton;
    wmibTakeNext: TWMImageSpeedButton;
    wmibIncrease1Second: TWMImageSpeedButton;
    wmibDecrease1Second: TWMImageSpeedButton;
    WMPanel8: TWMPanel;
    wmtlPlaylist: TWMTimeLine;
    Shape1: TShape;
    Label2: TLabel;
    imgPlayedTime: TImage;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    lblRemainingTargetEvent: TLabel;
    imgRamainingTime: TImage;
    imgNextStart: TImage;
    imgNextDuration: TImage;
    imgRemainingTarget: TImage;
    lblTargetEventNo: TLabel;
    imgOffair: TImage;
    imgOnair: TImage;
    wmibEventTimelineClose: TWMImageSpeedButton;
    lblEventCount: TLabel;
    imgTimeline: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acgPlaylistCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure acgPlaylistClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure acgPlaylistComboChange(Sender: TObject; ACol, ARow,
      AItemIndex: Integer; ASelection: string);
    procedure acgPlaylistEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure acgPlaylistEditChange(Sender: TObject; ACol, ARow: Integer;
      Value: string);
    procedure acgPlaylistGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure acgPlaylistKeyPress(Sender: TObject; var Key: Char);
    procedure acgPlaylistSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure acgPlaylistComboDropDown(Sender: TObject; ARow, ACol: Integer);
    procedure acgPlaylistEditingDone(Sender: TObject);
    procedure acgPlaylistDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure acgPlaylistDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure acgPlaylistCustomCellDraw(Sender: TObject; Canvas: TCanvas; ACol,
      ARow: Integer; AState: TGridDrawState; ARect: TRect; Printing: Boolean);
    procedure acgPlaylistGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure acgPlaylistGetCellBorder(Sender: TObject; ARow, ACol: Integer;
      APen: TPen; var Borders: TCellBorders);
    procedure acgPlaylistGetCellBorderProp(Sender: TObject; ARow, ACol: Integer;
      LeftPen, TopPen, RightPen, BottomPen: TPen);
    procedure wmtlPlaylistTrackHintEvent(Sender: TObject; Track: TTrack;
      var HintStr: string);
    procedure acgPlaylistGetDisplText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure acgPlaylistSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure wmtlPlaylistMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure acgPlaylistBeforeContractNode(Sender: TObject; ARow,
      ARowReal: Integer; var Allow: Boolean);
    procedure acgPlaylistBeforeExpandNode(Sender: TObject; ARow,
      ARowReal: Integer; var Allow: Boolean);
    procedure acgPlaylistExpandNode(Sender: TObject; ARow, ARowreal: Integer);
    procedure wmtbTimelineZoomChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure acgPlaylistEllipsClick(Sender: TObject; ACol, ARow: Integer;
      var S: string);
    procedure acgPlaylistCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure wmtlPlaylistTrackCustomDrawEvent(Sender: TObject; ATrack: TTrack;
      ACanvas: TCanvas; ARect: TRect; var ACustomDraw: Boolean);
    procedure acgPlaylistFixedCellClick(Sender: TObject; ACol, ARow: Integer);
    procedure acgPlaylistSelectionChanged(Sender: TObject; ALeft, ATop, ARight,
      ABottom: Integer);
    procedure acgPlaylistRowUpdate(Sender: TObject; OldRow, NewRow: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FPlayListFileName: String;

    FChannelID: Word;
    FChannelFrameRateType: TFrameRateType;
    FChannelIsDropFrame: Boolean;

    // Break current
    FBreakAddTime: TTimecode;
    FBreakEventDurationTime: TTimecode;
    FBreakEventSource: String;
    FBreakEventTitle: String;
    FBreakEventInput: TInputType;
    FBreakEventOutputBkgnd: TOutputBkgndType;
    FBreakEventOutputKeyer: TOutputKeyerType;

    FChannelOnAir: Boolean;
    FChannelCueSheetList: TChannelCueSheetList;

    FCueSheetLock: TCriticalSection;
    FCueSheetList: TCueSheetList;

    FLastDisplayNo: Integer;
    FLastCount: Integer;

    FLastInputIndex: Integer;

//    FFirstStartTime: TEventTime;
    FTimelineStartDate: TDateTime;
    FTimelineEndDate: TDateTime;

    FIsContrctAll: Boolean;
    FIsCellEditing: Boolean;
    FIsCellModified: Boolean;
    FNewCellValue: String;
    FOldCellValue: String;
    FOldOutput: Integer;

    FTimeLineDaysPerFrames: Integer;
    FTimeLineMin: Integer;
    FTimeLineMax: Integer;

//    FTimeLineZoomType: TTimelineZoomType;
//    FTimeLineZoomPosition: Integer;

//    FTimelineSpace: Integer;

    FCueSheetCurr: PCueSheetItem;
    FCueSheetNext: PCueSheetItem;
    FCueSheetTarget: PCueSheetItem;

    FCueSheetLoopFirst: PCueSheetItem;
    FCueSheetLoopLast: PCueSheetItem;
    FCueSheetLoopPrevList: TCueSheetList;
    FCueSheetLoopNextList: TCueSheetList;

    FCueSheetLoopLastStartTime: TEventTime;
    FCueSheetLoopLastDurationTC: TTimecode;

    FServerEventIDCurr: TEventID;
    FServerEventIDNext: TEventID;
    FServerEventIDTarget: TEventID;

    FEventContolThread: TChannelEventControlThread;
    FEventContolIntervalTime: Integer;

    FAutoLoadThread: TChannelAutoLoadPlayListThread;
//    FAutoLoadIntervalTime: Integer;

    FAutoEjectThread: TChannelAutoEjectPlayListThread;
//    FAutoEjectIntervalTime: Integer;

    FMediaCheckThread: TChannelMediaCheckThread;
//    FMediaCheckIntervalTime: Integer;

    FBlankCheckThread: TChannelBlankCheckThread;

    FInspectThread: TChannelInspectThread;

    FErrorDisplayEnabled: Boolean;

    FCueSheetCheckThread: TChannelCueSheetCheckThread;

    FTimerThread: TChannelTimerThread;

    procedure SetPlayListFileName(AValue: String);

{    function GetPositionByZoomType(AZoomType: TTimelineZoomType): Integer;
    function GetZoomTypeByPosition(APosition: Integer): TTimelineZoomType;
    procedure UpdateZoomPosition(APosition: Integer);
    procedure SetZoomPosition(AValue: Integer); }

    function GetChannelNullEventID: TEventID;

    // ChannelCueSheet functions
    function GetChannelCueSheetByIndex(AIndex: Integer): PChannelCueSheet;
    function GetChannelCueSheetByItem(AItem: PCueSheetItem): PChannelCueSheet;
    function GetChannelCueSheetByOnairDate(ADate: TDate): PChannelCueSheet;

    function GetChannelCueSheetStartIndex(AChannelCueSheet: PChannelCueSheet): Integer;

    function GetBeforeChannelCueSheetByOnairDate(ADate: TDate): PChannelCueSheet;
    function GetNextChannelCueSheetByOnairDate(ADate: TDate): PChannelCueSheet;


    // CueSheetList functions
    function GetCueSheetItemByIndex(AIndex: Integer): PCueSheetItem;
    function GetCueSheetItemByID(AEventID: TEventID): PCueSheetItem;
    function GetCueSheetIndexByItem(AItem: PCueSheetItem): Integer;

    function GetSelectCueSheetItem: PCueSheetItem;
    function GetSelectCueSheetIndex: Integer;

    function GetParentCueSheetItemByIndex(AIndex: Integer): PCueSheetItem;
    function GetParentCueSheetItemByItem(AItem: PCueSheetItem): PCueSheetItem;

    function GetChildCountByItem(AItem: PCueSheetItem): Integer;
    function GetChildCueSheetIndexByItem(AItem: PCueSheetItem; AIncludeComment: Boolean = False): Integer;

    function GetLastChildCueSheetItemByIndex(AIndex: Integer): PCueSheetItem;
    function GetLastChildCueSheetItemByItem(AItem: PCueSheetItem): PCueSheetItem;

    function GetFirstMainItem: PCueSheetItem;
    function GetFirstMainIndex: Integer;
    function GetLastMainItem: PCueSheetItem;
    function GetLastMainIndex: Integer;
    function GetBeforeMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;
    function GetBeforeMainItemByIndex(AIndex: Integer): PCueSheetItem;
    function GetNextMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;
    function GetNextMainItemByIndex(AIndex: Integer): PCueSheetItem;
    function GetNextMainIndexByItem(AItem: PCueSheetItem): Integer;
    function GetNextMainIndexByIndex(AIndex: Integer): Integer;
    function GetNextLoadedMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;

    function GetBeforeMainCountByItem(AItem: PCueSheetItem): Integer;
    function GetBeforeMainCountByIndex(AIndex: Integer): Integer;

    function GetMainItemByInRangeTime(AIndex: Integer; ADateTime: TDateTime): PCueSheetItem;
    function GetMainItemByStartTime(AIndex: Integer; ADateTime: TDateTime): PCueSheetItem;

    // Program �̺�Ʈ�� ����
    function GetProgramItemByIndex(AIndex: Integer): PCueSheetItem;
    function GetProgramItemByItem(AItem: PCueSheetItem): PCueSheetItem;

    // Program�� ù��° Main �̺�Ʈ�� ����
    function GetProgramMainItemByIndex(AIndex: Integer): PCueSheetItem;
    function GetProgramMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;

    // Program�� �ڽ� �̺�Ʈ ������ ����
    function GetProgramChildCountByItem(AItem: PCueSheetItem): Integer;

    // Program�� ��ü ���̸� ����
    function GetProgramDurationByItem(AItem: PCueSheetItem): TTimecode;

    function GetLastProgramMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;

    function GetLastProgramItem: PCueSheetItem;
    function GetLastProgramIndex: Integer;
    function GetBeforeProgramItemByItem(AItem: PCueSheetItem): PCueSheetItem;
    function GetBeforeProgramItemByIndex(AIndex: Integer): PCueSheetItem;

    // ť��Ʈ �� DCS�� Input���� ���� ù��° ���� �̺�Ʈ �ε����� ����
    function GetStartOnAirMainIndex: Integer;
    // ť��Ʈ �� DCS�� Input���� ���� ù��° ���� �̺�Ʈ�� ����
    function GetStartOnAirMainItem: PCueSheetItem;

    // ť��Ʈ �� DCS�� ���� Input�� ���� �̺�Ʈ�� ����
    function GetNextOnAirMainIndexByItem(AItem: PCueSheetItem): Integer;
    // ť��Ʈ �� DCS�� ���� Input�� ���� �̺�Ʈ�� ����
    function GetNextOnAirMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;

    // ���õ� �̺�Ʈ�� ���� ����� ����
    function GetDeleteCueSheetList(ADeleteList: TCueSheetList): Integer;

    // ���õ� �̺�Ʈ�� ���� �� �߶󳻱� ����� ����
    function GetClipboardCueSheetList(AClipboardCueSheet: TClipboardCueSheet; APasteMode: TPasteMode = pmCut): Integer;

    function MakePlayerEvent(AItem, AParentItem: PCueSheetItem; var AEvent: TEvent): Integer;
    function MakeSwitcherEvent(AItem, AParentItem: PCueSheetItem; var AEvent: TEvent; ASourceName: String; ARouter: TXptList): Integer;

    function InputEvent(AItem: PCueSheetItem; AParentItem: PCueSheetItem = nil): Integer;
    function DeleteEvent(AItem: PCueSheetItem): Integer;
    function ClearEvent: Integer;
    function TakeEvent(AItem: PCueSheetItem): Integer;
    function HoldEvent(AItem: PCueSheetItem): Integer;
    function ChangeDurationEvent(AItem: PCueSheetItem; ADuration: TTimecode): Integer;

    procedure SetCueSheetCurr(AValue: PCueSheetItem);
    procedure SetCueSheetNext(AValue: PCueSheetItem);
    procedure SetCueSheetTarget(AValue: PCueSheetItem);

    procedure Initialize;
    procedure Finalize;

    procedure InitializePlayListGrid;
    procedure InitializePlayListTimeLine;

//    function GetChannelOnairDatePlayListFile(AFileName: String; var AOnairDate: TDateTime): Boolean;

//    procedure PlaylistFileParsing(AFileName: String);
    procedure SavePlayListXML(AChannelCueSheet: PChannelCueSheet; AAll: Boolean = False);

    procedure DisplayPlayListGrid(AIndex: Integer = 0; AAddCount: Integer = 0); overload;
    procedure DisplayPlayListGrid(AIndex: Integer; AItem: PCueSheetItem); overload;

    procedure PopulatePlayListGrid(AIndex: Integer);
    procedure PopulateEventStatusPlayListGrid(AIndex: Integer; AItem: PCueSheetItem);
    procedure PopulateMediaCheckPlayListGrid(AIndex: Integer; AItem: PCueSheetItem);
//    procedure DisplayPlayListGrid(AIndex: Integer; ACount: Integer = 0); overload;

    procedure ErrorDisplayPlayListGrid;

    procedure InsertPlayListGridProgram(AIndex: Integer);
    procedure InsertPlayListGridMain(AIndex: Integer);
    procedure InsertPlayListGridSub(AIndex: Integer);

    procedure DeletePlayListGridProgram(AIndex: Integer);
    procedure DeletePlayListGridMain(AIndex: Integer);
    procedure DeletePlayListGridSub(AIndex: Integer);

    procedure SelectRowPlayListGrid(AIndex: Integer);

    procedure CalcuratePlayListTimeLineRange; overload;
    procedure CalcuratePlayListTimeLineRange(ADurEventTime: TEventTime); overload;
    procedure UpdatePlayListTimeLineRange;
    procedure PopulatePlayListTimeLine(AIndex: Integer); overload;
    procedure PopulatePlayListTimeLine(AItem: PCuesheetItem); overload;
    procedure PopulateEventStatusPlayListTimeLine(AIndex: Integer; AItem: PCueSheetItem);
    procedure UpdateChangeDatePlayListTimeLine(ADays: Integer);
    procedure RealtimeChangePlayListTimeLine;
    procedure DisplayPlayListTimeLine(AIndex: Integer = 0); overload;
    procedure DisplayPlayListTimeLine(AIndex: Integer; AItem: PCueSheetItem); overload;
    procedure DeletePlayListTimeLineByItem(AItem: PCueSheetItem);
    procedure DeletePlayListTimeLineByIndex(AIndex: Integer);

    procedure ErrorDisplayPlayListTimeLine;

    procedure ClearCueSheetLoopPrevList;
    procedure ClearCueSheetLoopNextList;

    procedure ClearChannelCueSheetList;
    procedure ClearCueSheetList;
    procedure ClearPlayListGrid;
    procedure ClearPlayListTimeLine;

    procedure ResetNo(AIndex: Integer; ANo: Integer);
    procedure ResetStartDate(AIndex: Integer; ADays: Integer);
    procedure ResetStartTime(AIndex: Integer); overload;

    procedure ResetStartTime(AIndex: Integer; ASaveEndTime: TEventTime); overload;
    procedure ResetStartTimeByTime(AIndex: Integer; ASaveStartTime: TEventTime; ASaveDurationTC: TTimecode); overload;
    procedure ResetStartTimeByTime(AIndex: Integer; ASaveStartTime: TEventTime); overload;
    procedure ResetStartTimeByTime(AIndex: Integer; ASaveDurationTC: TTimecode); overload;

    procedure ResetStartTimeByDuration(AIndex: Integer; ADuration: TTimecode);

    procedure ResetStartTimePlus(AIndex: Integer; ADurEventTime: TEventTime);
    procedure ResetStartTimeMinus(AIndex: Integer; ADurEventTime: TEventTime);

    procedure ResetChildItems(AIndex: Integer; ADurationTC: TTimecode);

    procedure ResetStartDateTimeline(AIndex: Integer);

    procedure ChannelCueSheetListQuickSort(L, R: Integer; AChannelCueSheetList: TChannelCueSheetList);
    procedure CueSheetListQuickSort(L, R: Integer; ACueSheetList: TCueSheetList);

//    procedure SetCueSheetItemStatusByIndex(AStartIndex, AEndIndex: Integer; AState: TEventState = esIdle; AErrorCode: TErrorCode = ERR_NoError);
    procedure SetCueSheetItemStatusByIndex(AStartIndex, AEndIndex: Integer; AState: TEventState = esIdle; AErrorCode: Integer = E_NO_ERROR);

    procedure AutoLoadPlayList;
    procedure AutoEjectPlayList;
//    procedure MediaCheck; overload;

    procedure MediaCheck(AItem: PCueSheetItem; ASourceHandle: PSourceHandle = nil); overload;

    procedure SetChannelOnAir(AOnAir: Boolean);

    procedure OnAirInputEvents(AIndex: Integer; ACount: Integer = 0; ANewEventOnly: Boolean = False);
    procedure OnAirDeleteEvents(AFromIndex, AToIndex: Integer);
    procedure OnAirClearEvents;
    procedure OnAirTakeEvent(AIndex: Integer);
    procedure OnAirHoldEvent(AIndex: Integer);
    procedure OnAirChangeDurationEvent(AIndex: Integer; ASaveDuration, AChangeDuration: TTimecode);
  protected
//    procedure WndProc(var Message: TMessage); override;

    procedure WMUpdateChannelTime(var Message: TMessage); message WM_UPDATE_CHANNEL_TIME;
    procedure WMUpdateChannelOnAir(var Message: TMessage); message WM_UPDATE_CHANNEL_ONAIR;

    procedure WMUpdateCurrEvent(var Message: TMessage); message WM_UPDATE_CURR_EVENT;
    procedure WMUpdateNextEvent(var Message: TMessage); message WM_UPDATE_NEXT_EVENT;
    procedure WMUpdateTargetEvent(var Message: TMessage); message WM_UPDATE_TARGET_EVENT;

    procedure WMExecuteLoopInputEvent(var Message: TMessage); message WM_EXECUTE_LOOP_INPUT_EVENT;
    procedure WMExecuteLoopUpdateEvent(var Message: TMessage); message WM_EXECUTE_LOOP_UPDATE_EVENT;

    procedure WMUpdateEventStatus(var Message: TMessage); message WM_UPDATE_EVENT_STATUS;

    procedure WMUpdateErrorDisplay(var Message: TMessage); message WM_UPDATE_ERROR_DISPLAY;

    procedure WMExecuteAutoLoadPlayList(var Message: TMessage); message WM_EXECUTE_AUTO_LOAD_PLAYLIST;
    procedure WMExecuteAutoEjectPlayList(var Message: TMessage); message WM_EXECUTE_AUTO_EJECT_PLAYLIST;
    procedure WMExecuteSourceExchange(var Message: TMessage); message WM_EXECUTE_SOURCE_EXCHANGE;

    procedure WMUpdateMediaCheck(var Message: TMessage); message WM_UPDATE_MEDIA_CHECK;

    procedure WMInvalidEdit(var Message: TMessage); message WM_INVALID_EDIT;
    procedure WMWarningDisplayNotExistEvent(var Message: TMessage); message WM_WARNING_DISPLAY_NOT_EXIST_EVENT;

    procedure WMBeginUpdateW(var Message: TMessage); message WM_BEGIN_UPDATEW;
    procedure WMEndUpdateW(var Message: TMessage); message WM_END_UPDATEW;
    procedure WMSetOnAirW(var Message: TMessage); message WM_SET_ONAIRW;
    procedure WMSetTimelineRangeW(var Message: TMessage); message WM_SET_TIMELINE_RANGEW;
    procedure WMInsertCueWheetW(var Message: TMessage); message WM_INSERT_CUESHEETW;
    procedure WMUpdateCueWheetW(var Message: TMessage); message WM_UPDATE_CUESHEETW;
    procedure WMDeleteCueWheetW(var Message: TMessage); message WM_DELETE_CUESHEETW;
    procedure WMClearCueWheetW(var Message: TMessage); message WM_CLEAR_CUESHEETW;

    procedure WMFinishLoadCueWheetW(var Message: TMessage); message WM_FINISH_LOAD_CUESHEETW;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AChannelID: Word; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer); overload;

    function SECBeginUpdateW: Integer;
    function SECEndUpdateW: Integer;

    function SECSetOnAirW(AIsOnAir: Boolean): Integer;
    function SECSetEventStatusW(AEventID: TEventID; AStatus: TEventStatus): Integer;
    function SECSetMediaStatusW(AEventID: TEventID; AStatus: TMediaStatus): Integer;
    function SECSetTimelineRangeW(AStartDate, AEndDate: TDateTime): Integer;

    function SECInputCueSheetW(AIndex: Integer; ACueSheetItem: TCueSheetItem): Integer;
    function SECDeleteCueSheetW(AEventID: TEventID): Integer;
    function SECClearCueSheetW: Integer;

    function SECSetCueSheetCurrW(AEventID: TEventID): Integer;
    function SECSetCueSheetNextW(AEventID: TEventID): Integer;
    function SECSetCueSheetTargetW(AEventID: TEventID): Integer;

    function SECInputChannelCueSheetW(ACueSheetFileName: String; AOnairdate: String; AOnairFlag: TOnAirFlagType;
                                      AOnairNo, AEventCount, ALastSerialNo, ALastProgramNo, ALastGroupNo: Integer): Integer;
    function SECDeleteChannelCueSheetW(AOnairdate: String): Integer;
    function SECClearChannelCueSheetW(AChannelID: Word): Integer;
    function SECFinishLoadCueSheetW(ACueSheetFileName: String): Integer;

    function IsValidStartDate(AItem: PCueSheetItem; AStartDate: TDate; AIsSelf: Boolean = True): Boolean;
    function IsValidStartTime(AItem: PCueSheetItem; AStartTC: TTimecode; AIsSelf: Boolean = True): Boolean;
    function IsValidDuration(AItem: PCueSheetItem; ADuration: TTimecode; AIsSelf: Boolean = True): Boolean;
    function IsValidInTC(AItem: PCueSheetItem; AInTC: TTimecode; AIsSelf: Boolean = True): Boolean;
    function IsValidOutTC(AItem: PCueSheetItem; AOutTC: TTimecode; AIsSelf: Boolean = True): Boolean;
    function IsValidMediaId(AMediaId: String; AIsSelf: Boolean = True): Boolean;

    procedure UpdateMCCCheck(AMCC: PMCC; AAlive: Boolean);
    procedure UpdateSECCheck(ASEC: PSEC; AAlive: Boolean);

    procedure MediaCheck(ASourceHandle: PSourceHandle = nil); overload;
    procedure BlankCheck;

    procedure NewPlayList;

    function GetChannelCueSheetByDuplicate(ADate: TDate; AOnairFlag: TOnAirFlagType; AOnairNo: Integer): PChannelCueSheet;
    procedure AddPlayListItem(AChannelCueSheet: PChannelCueSheet; ACueSheetList: TCueSheetList; AEventsNode: TXmlNode; AIndex: Integer; AAdd: Boolean = False; ASerialNo: Integer = -1);
    procedure OpenPlayListXML(AChannelCueSheet: PChannelCueSheet; ACueSheetList: TCueSheetList; AAdd: Boolean = False);

    procedure AddLoadPlayList(ALoadChannelCueSheet: PChannelCueSheet; ACueSheetList: TCueSheetList; AAdd: Boolean = False);
    procedure OpenPlayList(AFileName: String);
    procedure OpenAddPlayList(AFileName: String; AAutoFollow: Boolean = False);

    procedure SavePlayList;
    procedure SaveAsPlayList(AFileName: String; ADate: TDate);
//    procedure DeletePlayList(AFileName: String);

    procedure ChannelCueSheetListSort(AChannelCueSheetList: TChannelCueSheetList);
    procedure CueSheetListSort(ACueSheetList: TCueSheetList);

    function CheckCueSheetEditPossibleLockTimeByIndex(AIndex: Integer): Boolean;
    function CheckCueSheetEditPossibleLockTimeByItem(AItem: PCueSheetItem): Boolean;

    function CheckCueSheetEditPossibleLocationByIndex(AIndex: Integer): Boolean;
    function CheckCueSheetEditPossibleLocationByItem(AItem: PCueSheetItem): Boolean;

    function OpenDialogMediaFile(ACaption: String; var AFileName: String): Boolean;

    function InputLoopEvent(ALoopItem: PCueSheetItem): Integer;
    function DeleteLoopCueSheet: Integer;
    procedure UpdateLoopCueSheet(ALoopItem: PCueSheetItem);
    procedure CheckCueSheetLoop(AIndex: Integer); overload;
    procedure CheckCueSheetLoop(AItem: PCueSheetItem); overload;
    procedure ClearCueSheetLoopItems;

    procedure InsertCueSheet(AEventMode: TEventMode);
    procedure ExecuteInsertCueSheetProgram(AIndex: Integer; AAddItem: PCueSheetItem);
    procedure ExecuteInsertCueSheetMain(AIndex: Integer; AAddItem: PCueSheetItem);
    procedure ExecuteInsertCueSheetJoin(AIndex: Integer; AParentItem, AAddItem: PCueSheetItem);
    procedure ExecuteInsertCueSheetSub(AIndex: Integer; AParentItem, AAddItem: PCueSheetItem);
    procedure ExecuteInsertCueSheetComment(AIndex: Integer; AAddItem: PCueSheetItem);

    procedure UpdateCueSheet;
    procedure ExecuteUpdateCueSheet(AIndex: Integer; AEventMode: TEventMode; ASaveStartTime: TEventtime; ASaveDurationTC: TTimecode; ASourceChanged: Boolean = False);

    procedure DeleteCueSheet;
    procedure ExecuteDeleteCueSheet(ADeleteList: TCueSheetList);

    procedure InspectCueSheet;

    procedure SourceExchangeCueSheet;
    procedure MainErrorSourceExchange(ASource: PSource);
    procedure ExecuteSourceExchange(AIndex: Integer);

    procedure CopyToClipboardCueSheet;

    procedure CutToClipboardCueSheet;

    procedure PasteFromClipboardCueSheet;

    procedure ClearClipboardCueSheet;

    procedure SelectMediaFileInCueSheet;

    procedure TimelineGotoCurrent;
    procedure TimelineMoveLeft;
    procedure TimelineMoveRight;

    procedure TimelineZoomIn;
    procedure TimelineZoomOut;

    procedure StartOnAir;
    procedure FreezeOnAir;
    procedure FinishOnAir;
    procedure BreakOnAir;
    procedure CatchOnair;

    procedure AssignNextEvent(ANextLockTime: Boolean = True);
    procedure StartNextEventImmediately;

    procedure IncSecondsOnAirEvent(ASeconds: Integer);

    procedure AssignTargetEvent;

    procedure GotoCurrentEvent;

    procedure SetEventStatus(AEventID: TEventID; AStatus: TEventStatus; AIsCurrEvent: Boolean = False); overload;
    procedure SetEventStatus(AHandle: TDeviceHandle; AEventID: TEventID; AStatus: TEventStatus; AIsCurrEvent: Boolean = False); overload;
    procedure SetEventStatusColor(AItem: PCueSheetItem);

    procedure SetEventOverall(ADCSIP: String; ADeviceHandle: TDeviceHandle; AOverall: TEventOverall);

    procedure SetMediaStatus(AEventID: TEventID; AStatus: TMediaStatus);

    procedure ServerBeginUpdates(AChannelID: Word);
    procedure ServerEndUpdates(AChannelID: Word);

    procedure ServerSetOnAirs(AChannelID: Word; AIsOnAir: Boolean);
    procedure ServerSetEventStatuses(AEventID: TEventID; AEventStatus: TEventStatus);
    procedure ServerSetMediaStatuses(AEventID: TEventID; AMediaStatus: TMediaStatus);
    procedure ServerSetTimelineRange(AChannelID: Word; AStartDate, AEndDate: TDateTime);

    procedure ServerInputCueSheets(AChannelID: Word; AIndex: Integer; ACount: Integer = 0); overload;
    procedure ServerInputCueSheets(AIndex: Integer; AItem: PCueSheetItem); overload;
    procedure ServerDeleteCueSheets(AChannelID: Word; ADeleteList: TCueSheetList); overload;
    procedure ServerDeleteCueSheets(AEventID: TEventID); overload;
    procedure ServerDeleteCueSheets(AChannelID: Word; AFromIndex, AToIndex: Integer); overload;
    procedure ServerClearCueSheets(AChannelID: Word);

    procedure ServerSetCueSheetCurrs(AEventID: TEventID);
    procedure ServerSetCueSheetNexts(AEventID: TEventID);
    procedure ServerSetCueSheetTargets(AEventID: TEventID);

    procedure ServerInputChannelCueSheets(AChannelCueSheet: PChannelCueSheet);
    procedure ServerDeleteChannelCueSheets(AChannelCueSheet: PChannelCueSheet);
    procedure ServerClearChannelCueSheets(AChannelID: Word);
    procedure ServerFinishLoadCuesheets(AChannelID: Word; ACueSheetFileName: String);

    procedure MCCBeginUpdates(AChannelID: Word);
    procedure MCCEndUpdates(AChannelID: Word);

    procedure MCCSetOnAirs(AChannelID: Word; AIsOnAir: Boolean);
    procedure MCCSetEventStatuses(AEventID: TEventID; AEventStatus: TEventStatus);
    procedure MCCSetMediaStatuses(AEventID: TEventID; AMediaStatus: TMediaStatus);
    procedure MCCSetTimelineRanges(AChannelID: Word; AStartDate, AEndDate: TDateTime);

    procedure MCCInputCueSheets(AIndex: Integer; ACount: Integer = 0); overload;
    procedure MCCInputCueSheets(AIndex: Integer; AItem: TCueSheetItem); overload;
    procedure MCCDeleteCueSheets(AChannelID: Word; ADeleteList: TCueSheetList); overload;
    procedure MCCDeleteCueSheets(AEventID: TEventID); overload;
    procedure MCCDeleteCueSheets(AChannelID: Word; AFromIndex, AToIndex: Integer); overload;
    procedure MCCClearCueSheets(AChannelID: Word);

    procedure MCCSetCueSheetCurrs(AEventID: TEventID);
    procedure MCCSetCueSheetNexts(AEventID: TEventID);
    procedure MCCSetCueSheetTargets(AEventID: TEventID);

    procedure SECBeginUpdates(AChannelID: Word);
    procedure SECEndUpdates(AChannelID: Word);

    procedure SECSetOnAirs(AChannelID: Word; AIsOnAir: Boolean);
    procedure SECSetEventStatuses(AEventID: TEventID; AEventStatus: TEventStatus);
    procedure SECSetMediaStatuses(AEventID: TEventID; AMediaStatus: TMediaStatus);
    procedure SECSetTimelineRanges(AChannelID: Word; AStartDate, AEndDate: TDateTime);

    procedure SECInputCueSheets(AIndex: Integer; ACount: Integer = 0); overload;
    procedure SECInputCueSheets(AIndex: Integer; AItem: TCueSheetItem); overload;
    procedure SECDeleteCueSheets(AChannelID: Word; ADeleteList: TCueSheetList); overload;
    procedure SECDeleteCueSheets(AEventID: TEventID); overload;
    procedure SECDeleteCueSheets(AChannelID: Word; AFromIndex, AToIndex: Integer); overload;
    procedure SECClearCueSheets(AChannelID: Word);

    procedure SECSetCueSheetCurrs(AEventID: TEventID);
    procedure SECSetCueSheetNexts(AEventID: TEventID);
    procedure SECSetCueSheetTargets(AEventID: TEventID);

    procedure SECInputChannelCueSheets(AChannelCueSheet: TChannelCueSheet);
    procedure SECDeleteChannelCueSheets(AChannelCueSheet: TChannelCueSheet);
    procedure SECClearChannelCueSheets(AChannelID: Word);
    procedure SECFinishLoadCueSheets(AChannelID: Word; ACueSheetFileName: String);

    property ChannelID: Word read FChannelID;
    property ChannelFrameRateType: TFrameRateType read FChannelFrameRateType;
    property ChannelIsDropFrame: Boolean read FChannelIsDropFrame;
    property BreakAddTime: TTimecode read FBreakAddTime;
    property BreakEventDurationTime: TTimecode read FBreakEventDurationTime;
    property BreakEventSource: String read FBreakEventSource;
    property BreakEventTitle: String read FBreakEventTitle;
    property BreakEventInput: TInputType read FBreakEventInput;
    property BreakEventOutputBkgnd: TOutputBkgndType read FBreakEventOutputBkgnd;
    property BreakEventOutputKeyer: TOutputKeyerType read FBreakEventOutputKeyer;
    property ChannelOnAir: Boolean read FChannelOnAir;

    property CueSheetLock: TCriticalSection read FCueSheetLock;

    property ChannelCueSheetList: TChannelCueSheetList read FChannelCueSheetList;
    property CueSheetList: TCueSheetList read FCueSheetList;
    property LastDisplayNo: Integer read FLastDisplayNo write FLastDisplayNo;
//    property LastCount: Integer read FLastCount write FLastCount;

    property PlayListFileName: String read FPlayListFileName write SetPlayListFileName;

    property CueSheetCurr: PCueSheetItem read FCueSheetCurr write SetCueSheetCurr;
    property CueSheetNext: PCueSheetItem read FCueSheetNext write SetCueSheetNext;
    property CueSheetTarget: PCueSheetItem read FCueSheetTarget write SetCueSheetTarget;

    property CueSheetLoopFirst: PCueSheetItem read FCueSheetLoopFirst;
    property CueSheetLoopLast: PCueSheetItem read FCueSheetLoopLast;

//    property TimelineZoomPosition: Integer read FTimelineZoomPosition write SetZoomPosition;
//    property TimelineZoomType: TTimelineZoomType read FTimelineZoomType;
  end;

  TChannelEventControlThread = class(TThread)
  private
    FChannelForm: TfrmChannel;

    FInputIndex: Integer;
    FInputCount: Integer;

    FInputEvent: THandle;
    FDeleteEvent: THandle;
    FClearEvent: THandle;
    FTakeEvent: THandle;
    FHoldEvent: THandle;
    FChangeDurationEvent: THandle;
    FCloseEvent: THandle;

    procedure DoEventInput;
//    procedure DoEventDelete;
//    procedure DoEventClear;
//    procedure DoEventTake;
//    procedure DoEventHold;
//    procedure DoEventChangeDuration;
  protected
    procedure Execute; override;
  public
    constructor Create(AChannelForm: TfrmChannel);
    destructor Destroy; override;

    procedure Terminate;
    procedure InputEvent(AInputIndex: Integer; AInputCount: Integer);
  end;

  TChannelTimerThread = class(TThread)
  private
    FChannelForm: TfrmChannel;

    FCloseEvent: THandle;

    procedure DoCueSheetCheck;
  protected
    procedure Execute; override;
  public
    constructor Create(AChannelForm: TfrmChannel);
    destructor Destroy; override;

    procedure Terminate;
  end;

  TChannelCueSheetCheckThread = class(TThread)
  private
    FChannelForm: TfrmChannel;

    FCloseEvent: THandle;

    procedure DoCueSheetCheck;
  protected
    procedure Execute; override;
  public
    constructor Create(AChannelForm: TfrmChannel);
    destructor Destroy; override;

    procedure Terminate;
  end;

  TChannelAutoLoadPlayListThread = class(TThread)
  private
    FChannelForm: TfrmChannel;

//    FAutoLoadEvent: THandle;
    FCloseEvent: THandle;
  protected
    procedure DoAutoLoad;

    procedure Execute; override;
  public
    constructor Create(AChannelForm: TfrmChannel);
    destructor Destroy; override;

    procedure Terminate;
//    procedure AutoLoad;
  end;

  TChannelAutoEjectPlayListThread = class(TThread)
  private
    FChannelForm: TfrmChannel;

//    FAutoEjectEvent: THandle;
    FCloseEvent: THandle;
  protected
    procedure DoAutoEject;

    procedure Execute; override;
  public
    constructor Create(AChannelForm: TfrmChannel);
    destructor Destroy; override;

    procedure Terminate;
//    procedure AutoEject;
  end;

  TChannelMediaCheckThread = class(TThread)
  private
    FChannelForm: TfrmChannel;

    FMediaCheckEvent: THandle;
    FCloseEvent: THandle;
  protected
    procedure DoMediaCheck;

    procedure Execute; override;
  public
    constructor Create(AChannelForm: TfrmChannel);
    destructor Destroy; override;

    procedure Terminate;
    procedure MediaCheck;
  end;

  TChannelBlankCheckThread = class(TThread)
  private
    FChannelForm: TfrmChannel;

    FBlankCheckEvent: THandle;
    FCloseEvent: THandle;

    FWarningDialog: TfrmWarningDialog;
  protected
    procedure DoBlankCheck;

    procedure Execute; override;
  public
    constructor Create(AChannelForm: TfrmChannel);
    destructor Destroy; override;

    procedure Terminate;
    procedure BlankCheck;
  end;

  TChannelInspectThread = class(TThread)
  private
    FChannelForm: TfrmChannel;

    FInspectEvent: THandle;
    FCloseEvent: THandle;

    FIsCancel: Boolean;
  protected
    procedure DoInspect;

    procedure Execute; override;
  public
    constructor Create(AChannelForm: TfrmChannel);
    destructor Destroy; override;

    procedure Terminate;
    procedure Inspect;
    procedure Cancel;
  end;

var
  frmChannel: TfrmChannel;

implementation

uses UnitSEC, UnitOpenPlaylist, UnitEditEvent, UnitSelectStartOnAir,
  System.DateUtils, System.Math;

{$R *.dfm}

procedure TfrmChannel.WMUpdateChannelTime(var Message: TMessage);
var
  Index, Count: Integer;
  Item: PCueSheetItem;

//  NextStartTime: TDateTime;
  NextStartTime: TEventTime;
  NextIndex: Integer;
  CurrIndex: Integer;
  TargetIndex: Integer;

//  CurrentTime: TDateTime;
//  PlayedTime: TDateTime;
//  RemainTime: TDateTime;
//  RemainTargetTime: TDateTime;

  CurrentTime: TEventTime;
  PlayedTime: TEventTime;
  RemainTime: TEventTime;
  RemainTargetTime: TEventTime;

  PlayedTimeString: String;
  RemainTimeString: String;
  NextStartTimeString: String;
  NextDurationString: String;
  RemainTargetTimeString: String;

  SaveStartTime: TEventTime;
  SaveDurationTC: TTimecode;
begin
  inherited;

//  CurrentTime := SystemTimeToDateTime(GV_TimeCurrent);//Now;
  CurrentTime := SystemTimeToEventTime(GV_TimeCurrent, ChannelFrameRateType);

  FCueSheetLock.Enter;
  try

  // Next Start, Duration time
  if (CueSheetNext <> nil) then
  begin
//    NextStartTime := EventTimeToDateTime(CueSheetNext^.StartTime);
    NextStartTime := CueSheetNext^.StartTime;
    // ���� �̺�Ʈ�� ��������� ��� ���۽ð� �ڵ� �ø�
    if (HasMainControl) and
       (CueSheetNext^.EventMode = EM_MAIN) and
       (CueSheetNext^.StartMode = SM_MANUAL) and
       (CueSheetNext^.EventStatus.State <= esCued) and
//       (NextStartTime > CurrentTime) and
       (CompareEventTime(NextStartTime, CurrentTime, ChannelFrameRateType) > 0) and
//       (DateTimeToTimecode(NextStartTime - CurrentTime) <= GV_SettingTimeParameter.AutoIncreaseDurationBefore) then
       (EventTimeToTimecode(GetDurEventTime(NextStartTime, CurrentTime, ChannelFrameRateType)) <= GV_SettingTimeParameter.AutoIncreaseDurationBefore) then
    begin
      if (ChannelOnAir) then
        ServerBeginUpdates(ChannelID);
      try
        // ���� �������� �̺�Ʈ�� ���̴� �ڵ����� �÷���
        if (CueSheetCurr <> nil) then
        begin
          SaveDurationTC := CueSheetCurr.DurationTC;

          CueSheetCurr.DurationTC := GetPlusTimecode(CueSheetCurr.DurationTC, GV_SettingTimeParameter.AutoIncreaseDurationAmount, ChannelFrameRateType);
          CurrIndex := GetCueSheetIndexByItem(CueSheetCurr);
          ResetChildItems(CurrIndex, SaveDurationTC);
        end;

        // ���� �̺�Ʈ�� ���� �ð��� �ڵ����� �÷���
        SaveStartTime := CueSheetNext^.StartTime;
        CueSheetNext^.StartTime := GetPlusEventTime(CueSheetNext^.StartTime, TimecodeToEventTime(GV_SettingTimeParameter.AutoIncreaseDurationAmount), ChannelFrameRateType);
        NextIndex := GetCueSheetIndexByItem(CueSheetNext);

        ResetStartTimeByTime(NextIndex, SaveStartTime);

        if (CueSheetCurr <> nil) then
        begin
          OnAirInputEvents(CurrIndex, GV_SettingOption.MaxInputEventCount);

          acgPlaylist.Repaint;

          FLastDisplayNo := GetBeforeMainCountByIndex(CurrIndex);
//            DisplayPlayListGrid(CurrIndex);

//            DisplayPlayListTimeLine(CurrIndex);

          if (ChannelOnAir) then
            ServerInputCueSheets(ChannelID, CurrIndex);
        end
        else
        begin
          OnAirInputEvents(NextIndex, GV_SettingOption.MaxInputEventCount);

          acgPlaylist.Repaint;

          FLastDisplayNo := GetBeforeMainCountByIndex(NextIndex);
//            DisplayPlayListGrid(NextIndex);

//            DisplayPlayListTimeLine(NextIndex);

          if (ChannelOnAir) then
            ServerInputCueSheets(ChannelID, NextIndex);
        end;
      finally
        if (ChannelOnAir) then
          ServerEndUpdates(ChannelID);
      end;
    end;

    NextStartTimeString := TimecodeToString(CueSheetNext^.StartTime.T, ChannelIsDropFrame);
    NextDurationString  := TimecodeToString(CueSheetNext^.DurationTC, ChannelIsDropFrame);
  end
  else
  begin
    NextStartTimeString := GetIdleTimecodeString(ChannelIsDropFrame);
    NextDurationString  := GetIdleTimecodeString(ChannelIsDropFrame);
  end;

  lblNextStart.Caption    := NextStartTimeString;
  lblNextDuration.Caption := NextDurationString;

  // Played, Remaining time
  if (ChannelOnAir) and (CueSheetCurr <> nil) then
  begin
{    PlayedTime := CurrentTime - EventTimeToDateTime(CueSheetCurr^.StartTime);
    RemainTime := IncSecond(EventTimeToDateTime(GetEventEndTime(CueSheetCurr^.StartTime, CueSheetCurr^.DurationTC)) - CurrentTime);

    PlayedTimeString := FormatDateTime('hh:nn:ss', PlayedTime);
    RemainTimeString := FormatDateTime('hh:nn:ss', RemainTime); }

    PlayedTime := GetDurEventTime(CueSheetCurr^.StartTime, CurrentTime, ChannelFrameRateType);
    RemainTime := GetDurEventTime(CurrentTime, GetEventEndTime(CueSheetCurr^.StartTime, CueSheetCurr^.DurationTC, ChannelFrameRateType), ChannelFrameRateType);

    PlayedTimeString := TimecodeToString(PlayedTime.T, ChannelIsDropFrame, False);
    RemainTimeString := TimecodeToString(RemainTime.T, ChannelIsDropFrame, False);
  end
  else
  begin
    if (ChannelOnAir) and (CueSheetNext <> nil) then
    begin
{      RemainTime := IncSecond(EventTimeToDateTime(CueSheetNext^.StartTime) - CurrentTime);
      RemainTimeString := FormatDateTime('hh:nn:ss', RemainTime); }

      RemainTime := GetDurEventTime(CurrentTime, CueSheetNext^.StartTime, ChannelFrameRateType);

      RemainTimeString := TimecodeToString(RemainTime.T, ChannelIsDropFrame, False);
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
  if (ChannelOnAir) and (CueSheetTarget <> nil) then
  begin
    lblTargetEventNo.Caption := Format('%d', [CueSheetTarget^.DisplayNo + 1]);
{    RemainTargetTime := IncSecond(EventTimeToDateTime(CueSheetTarget^.StartTime) - CurrentTime);
    RemainTargetTimeString := FormatDateTime('hh:nn:ss', RemainTargetTime) }

    RemainTargetTime := GetDurEventTime(CurrentTime, CueSheetTarget^.StartTime, ChannelFrameRateType);
    RemainTargetTimeString := TimecodeToString(RemainTargetTime.T, ChannelIsDropFrame, False);
  end
  else
  begin
    lblTargetEventNo.Caption := '';
    RemainTargetTimeString := IDLE_TIME;
  end;

  lblRemainingTargetTime.Caption := RemainTargetTimeString;

  if (frmAllChannels <> nil) then
  begin
    frmAllChannels.SetChannelTime(ChannelID, PlayedTimeString, RemainTimeString, NextStartTimeString, NextDurationString);
  end;

  if (ChannelOnAir) then
  begin
    RealtimeChangePlayListTimeLine;
{        // Timeline
    with wmtlPlaylist do
    begin
      wmtlPlaylist.FrameNumber := TimecodeToFrame(DateTimeToTimecode(CurrentTime)) +
                                  Trunc((CurrentTime - FTimelineStartDate)) * FTimeLineDaysPerFrames;
    end;  }

//        if (FChannelTimelineForm <> nil) then
//          FChannelTimelineForm.SetFrameNumber(wmtlPlaylist.FrameNumber);
  end;

  finally
    FCueSheetLock.Leave;
  end;
end;

procedure TfrmChannel.WMUpdateChannelOnAir(var Message: TMessage);
begin
  SetChannelOnAir(Boolean(Message.WParam));
end;

procedure TfrmChannel.WMUpdateCurrEvent(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
  R, T: Integer;
begin
  Index := Message.WParam;
  Item  := PCueSheetItem(Message.LParam);
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

//    Index := GetNextOnAirMainIndexByItem(Item);
//    OnAirInputEvents(Index, 1);
  end;
end;

procedure TfrmChannel.WMUpdateNextEvent(var Message: TMessage);
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

procedure TfrmChannel.WMUpdateTargetEvent(var Message: TMessage);
begin
  with acgPlaylist do
    Repaint;
end;

procedure TfrmChannel.WMExecuteLoopInputEvent(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item  := PCueSheetItem(Message.LParam);

  if (Item <> nil) and (Item^.EventMode = EM_MAIN) and (Item^.StartMode = SM_LOOP) then
    InputLoopEvent(Item);
end;

procedure TfrmChannel.WMExecuteLoopUpdateEvent(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item  := PCueSheetItem(Message.LParam);

  if (Item <> nil) and (Item^.EventMode = EM_MAIN) and (Item^.StartMode = SM_LOOP) then
    UpdateLoopCueSheet(Item);
end;

procedure TfrmChannel.WMUpdateEventStatus(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item := PCueSheetItem(Message.LParam);

  SetEventStatusColor(Item);

  PopulateEventStatusPlayListGrid(Index, Item);

//  if (Item <> nil) then
//    ServerSetEventStatuses(Item^.EventID, Item^.EventStatus);

//  PopulateEventStatusPlayListTimeLine(Index, Item);
end;

procedure TfrmChannel.WMUpdateErrorDisplay(var Message: TMessage);
begin
  FErrorDisplayEnabled := not FErrorDisplayEnabled;

  ErrorDisplayPlayListGrid;
//  ErrorDisplayPlayListTimeLine;
end;

procedure TfrmChannel.WMExecuteAutoLoadPlayList(var Message: TMessage);
begin
  AutoLoadPlayList;
end;

procedure TfrmChannel.WMExecuteAutoEjectPlayList(var Message: TMessage);
begin
  AutoEjectPlayList;
end;

procedure TfrmChannel.WMExecuteSourceExchange(var Message: TMessage);
begin
  ExecuteSourceExchange(Message.LParam);
end;

procedure TfrmChannel.WMUpdateMediaCheck(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item := PCueSheetItem(Message.LParam);

  PopulateMediaCheckPlayListGrid(Index, Item);

  if (Item^.MediaStatus in [msNone, msNotExist, msShort]) then
    with GV_SettingOption do
      if (MediaCheckAlarm) then
        TAlarmThread.Create(MediaCheckAlarmFileName, MediaCheckAlarmDuration, MediaCheckAlarmInterval).Start;
end;

procedure TfrmChannel.WMBeginUpdateW(var Message: TMessage);
begin
  if (not (acgPlaylist.IsUpdating)) then
    acgPlaylist.BeginUpdate;

  wmtlPlaylist.BeginUpdateCompositions;

//  if (frmAllChannels <> nil) then
//    PostMessage(frmAllChannels.Handle, WM_BEGIN_UPDATE, 0, 0);


{      if (frmAllChannels <> nil) then
  begin
    frmAllChannels.wmtlPlaylist.BeginUpdateCompositions;
  end; }
end;

procedure TfrmChannel.WMEndUpdateW(var Message: TMessage);
begin
  if (acgPlaylist.IsUpdating) then
    acgPlaylist.EndUpdate;

  wmtlPlaylist.EndUpdateCompositions;

//  if (frmAllChannels <> nil) then
//    PostMessage(frmAllChannels.Handle, WM_END_UPDATE, 0, 0);

{      if (frmAllChannels <> nil) then
  begin
    frmAllChannels.wmtlPlaylist.EndUpdateCompositions;
  end; }
end;

procedure TfrmChannel.WMSetOnAirW(var Message: TMessage);
var
  ChannelID: Word;
  IsOnAir: Boolean;
begin
  ChannelID := Message.WParam;
  IsOnAir := Boolean(Message.LParam);

  SetChannelOnAir(IsOnAir);

//  if (frmAllChannels <> nil) then
//    PostMessage(frmAllChannels.Handle, WM_SET_ONAIR, ChannelID, NativeInt(IsOnAir));
end;

procedure TfrmChannel.WMSetTimelineRangeW(var Message: TMessage);
begin
  CalcuratePlayListTimeLineRange;
  UpdatePlayListTimeLineRange;
end;

procedure TfrmChannel.WMInsertCueWheetW(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item := PCueSheetItem(Message.LParam);

  DisplayPlayListGrid(Index, Item);
  PopulatePlayListGrid(Index);

//      CalcuratePlayListTimeLineRange;
//      UpdatePlayListTimeLineRange;

  PopulatePlayListTimeLine(Index);

  // If program exist then re display
  Item := GetProgramItemByIndex(Index);
  if (Item <> nil) then
  begin
    Index := GetCueSheetIndexByItem(Item);
    PopulatePlayListTimeLine(Index);
  end;
end;

procedure TfrmChannel.WMUpdateCueWheetW(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item := PCueSheetItem(Message.LParam);

  PopulatePlayListGrid(Index);

//      CalcuratePlayListTimeLineRange;
//      UpdatePlayListTimeLineRange;

  PopulatePlayListTimeLine(Index);

  // If program exist then re display
  Item := GetProgramItemByIndex(Index);
  if (Item <> nil) then
  begin
    Index := GetCueSheetIndexByItem(Item);
    PopulatePlayListTimeLine(Index);
  end;
end;

procedure TfrmChannel.WMDeleteCueWheetW(var Message: TMessage);
var
  Index: Integer;
  Item: PCueSheetItem;
begin
  Index := Message.WParam;
  Item := PCueSheetItem(Message.LParam);

  DeletePlayListGridMain(Index);

  DeletePlayListTimeLineByIndex(Index);

    FCueSheetLock.Enter;
    try
      FCueSheetList.Remove(Item);

      Dispose(Item);
    finally
      FCueSheetLock.Leave;
    end;
end;

procedure TfrmChannel.WMClearCueWheetW(var Message: TMessage);
var
  ChannelID: Word;
begin
  ChannelID := Message.WParam;

  ClearPlayListGrid;
  ClearPlayListTimeLine;

  DisplayPlayListGrid;

  CalcuratePlayListTimeLineRange;
  UpdatePlayListTimeLineRange;
end;

procedure TfrmChannel.WMFinishLoadCueWheetW(var Message: TMessage);
var
  FileNameStrLen: Integer;
  FileNameStr: PChar;

  CueSheetFileName: String;
  LoadFileName: String;
  WorkFileName: String;
begin
  FileNameStrLen := Message.WParam;
  FileNameStr    := Pchar(Message.LParam);

  if (FileNameStr <> nil) then
  begin
    CueSheetFileName := String(FileNameStr);
    try
      LoadFileName := GV_SettingGeneral.LoadCueSheetPath + CueSheetFileName;
      WorkFileName := GV_SettingGeneral.WorkCueSheetPath + CueSheetFileName;

      if (MoveFileEx(PChar(LoadFileName), PChar(WorkFileName), MOVEFILE_REPLACE_EXISTING)) then
      begin

      end;
    finally
      StrDispose(FileNameStr);
    end;
  end;
end;

procedure TfrmChannel.WMInvalidEdit(var Message: TMessage);
var
  C, R: Integer;
begin
  C := Message.WParam;
  R := Message.LParam;
        acgPlaylist.Options := acgPlaylist.Options - [goRowSelect];
        acgPlaylist.Options := acgPlaylist.Options + [goEditing];
  acgPlaylist.GotoCell(C, R);
  acgPlaylist.FocusCell(C, R);
//      acgPlaylist.ShowSelection := True;
  acgPlaylist.EditCell(C, R);
  acgPlaylist.SetFocus;
//      acgPlaylist.Col := C;
//      acgPlaylist.Row := R;
//      acgPlaylist.Repaint;
end;

procedure TfrmChannel.WMWarningDisplayNotExistEvent(var Message: TMessage);
var
  WarningStrLen: Integer;
  WarningStr: PChar;

  WarningText: String;
begin
  WarningStrLen := Message.WParam;

  if (WarningStrLen > 0) then
  begin
    WarningStr := StrAlloc(WarningStrLen);
    try
      if ((GlobalGetAtomName(Message.LParam, WarningStr, WarningStrLen)) > 0) then
      begin
        WarningText := StrPas(WarningStr);
        GlobalDeleteAtom(Message.LParam);
        if (FBlankCheckThread.FWarningDialog = nil) or (not FBlankCheckThread.FWarningDialog.HandleAllocated) then
        begin
          FBlankCheckThread.FWarningDialog := CreateWarningDialog(WarningText);

          with GV_SettingOption do
            if (BlankCheckAlarm) then
              TAlarmThread.Create(BlankCheckAlarmFileName, BlankCheckAlarmDuration, BlankCheckAlarmInterval).Start;
        end;
      end;
    finally
      StrDispose(WarningStr);
    end;
  end;

exit;
  WarningStrLen := Message.WParam;
  WarningStr := PChar(Message.LParam);

  if (WarningStr <> nil) then
  begin
    WarningText := String(WarningStr);
    try
      if (FBlankCheckThread.FWarningDialog = nil) or (not FBlankCheckThread.FWarningDialog.HandleAllocated) then
      begin
        FBlankCheckThread.FWarningDialog := CreateWarningDialog(WarningText);

        with GV_SettingOption do
          if (BlankCheckAlarm) then
            TAlarmThread.Create(BlankCheckAlarmFileName, BlankCheckAlarmDuration, BlankCheckAlarmInterval).Start;
      end;
    finally
      StrDispose(WarningStr);
    end;
  end;

  exit;


  if (FBlankCheckThread.FWarningDialog = nil) or (not FBlankCheckThread.FWarningDialog.HandleAllocated) then
  begin
    WarningText := String(PChar(Message.LParam));
    FBlankCheckThread.FWarningDialog := CreateWarningDialog(WarningText);

    with GV_SettingOption do
      if (BlankCheckAlarm) then
        TAlarmThread.Create(BlankCheckAlarmFileName, BlankCheckAlarmDuration, BlankCheckAlarmInterval).Start;
  end;
end;

{procedure TfrmChannel.WndProc(var Message: TMessage);
begin
  inherited;

  case Message.Msg of
    WM_UPDATE_CHANNEL_TIME: WMUpdateCurrentTime(Message);
    WM_UPDATE_CHANNEL_ONAIR: WMUpdateChannelOnAir(Message);

    WM_UPDATE_CURR_EVENT: WMUpdateCurrEvent(Message);
    WM_UPDATE_NEXT_EVENT: WMUpdateNextEvent(Message);
    WM_UPDATE_TARGET_EVENT: WMUpdateTargetEvent(Message);

    WM_UPDATE_EVENT_STATUS: WMUpdateEventStatus(Message);

    WM_UPDATE_ERROR_DISPLAY: WMUpdateErrorDisplay(Message);

    WM_EXECUTE_AUTO_LOAD_PLAYLIST: WMExecuteAutoLoadPlayList(Message);
    WM_EXECUTE_AUTO_EJECT_PLAYLIST: WMExecuteAutoEjectPlayList(Message);

    WM_UPDATE_MEDIA_CHECK: WMUpdateMediaCheck(Message);

    WM_BEGIN_UPDATE: WMBeginUpdate(Message);
    WM_END_UPDATE: WMEndUpdate(Message);

    WM_SET_ONAIR: WMSetOnAir(Message);
    WM_SET_TIMELINE_RANGE: WMSetTimelineRange(Message);

    WM_INSERT_CUESHEET: WMInsertCueWheet(Message);
    WM_UPDATE_CUESHEET: WMUpdateCueWheet(Message);
    WM_DELETE_CUESHEET: WMDeleteCueWheet(Message);
    WM_CLEAR_CUESHEET: WMClearCueWheet(Message);

    WM_INVALID_EDIT: WMInvalidEdit(Message);

    WM_WARNING_DISPLAY: WMWarningDisplay(Message);
  end;
end;}

procedure TfrmChannel.acgPlaylistBeforeContractNode(Sender: TObject; ARow,
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

procedure TfrmChannel.acgPlaylistBeforeExpandNode(Sender: TObject; ARow,
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

procedure TfrmChannel.acgPlaylistCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
var
  RCol, RRow: Integer;
  Index: Integer;
  NextIndex, CurrIndex: Integer;
  Item: PCueSheetItem;
  ParentItem: PCueSheetItem;
begin
  inherited;

  CanEdit := False;

  if (not HasMainControl) then exit;

  with (Sender as TAdvColumnGrid) do
  begin
    try
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
                 (RCol <> IDX_COL_CUESHEET_EVENT_STATUS) and
//                 (RCol <> IDX_COL_CUESHEET_DEVICE_STATUS) and
                 (RCol <> IDX_COL_CUESHEET_MEDIA_STATUS);

      Index := RRow - FixedRows;

      if (CueSheetNext <> nil) then
      begin
        NextIndex := GetCueSheetIndexByItem(CueSheetNext);
        if (NextIndex >= 0) and (Index < NextIndex) then
        begin
          CanEdit := False;
          exit;
        end;
      end
      else if (CueSheetCurr <> nil) then
      begin
        CurrIndex := GetCueSheetIndexByItem(CueSheetCurr);
        if (CurrIndex >= 0) and (Index < CurrIndex) then
        begin
          CanEdit := False;
          exit;
        end;
      end;

      Item := GetCueSheetItemByIndex(Index);
      if (Item <> nil) then
      begin
        if ((CueSheetNext <> nil) and (Item^.GroupNo = CueSheetNext^.GroupNo)) or
           ((CueSheetCurr <> nil) and (Item^.GroupNo = CueSheetCurr^.GroupNo)) then
        begin
          CanEdit := False;
          exit;
        end;

        if (Item^.EventMode in [EM_JOIN, EM_SUB]) then
        begin
          ParentItem := GetParentCueSheetItemByItem(Item);
          if (ParentItem <> nil) then
          begin
            if (ParentItem^.EventStatus.State > esLoaded) then exit;
          end;
        end;

        with Item^ do
          if (EventMode = EM_COMMENT) then
          begin
            CanEdit := (RCol = IDX_COL_CUESHEET_NO);
            exit;
          end
          else if (EventMode = EM_PROGRAM) then
          begin
            CanEdit := (RCol = IDX_COL_CUESHEET_TITLE) or
                       (RCol = IDX_COL_CUESHEET_SUB_TITLE);
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
                       (RCol <> IDX_COL_CUESHEET_START_MODE) and
                       (RCol <> IDX_COL_CUESHEET_START_DATE) and
                       (RCol <> IDX_COL_CUESHEET_START_TIME) and
                       (RCol <> IDX_COL_CUESHEET_DURATON) and
                       (RCol <> IDX_COL_CUESHEET_IN_TC) and
                       (RCol <> IDX_COL_CUESHEET_OUT_TC);
          end
          else
          begin
            CanEdit := (CanEdit) and
                       (RCol <> IDX_COL_CUESHEET_START_DATE);
          end;
      end
      else
        CanEdit := False;

    finally
{      if (not CanEdit) then
      begin
        Options := Options + [goRowSelect];
        Options := Options - [goEditing];
      end; }
    end;
  end;
end;

procedure TfrmChannel.acgPlaylistCheckBoxClick(Sender: TObject; ACol,
  ARow: Integer; State: Boolean);
begin
  inherited;

  exit;
  with acgPlaylist do
    if (ACol = IDX_COL_CUESHEET_GROUP) and (ARow = FixedRows - 1) then
    begin

      if (State) then ExpandAll
      else ContractAll;

      PostMessage(Self.Handle, WM_UPDATE_CURR_EVENT, GetCueSheetIndexByItem(FCueSheetCurr), NativeInt(FCueSheetCurr));
      PostMessage(Self.Handle, WM_UPDATE_NEXT_EVENT, GetCueSheetIndexByItem(FCueSheetNext), NativeInt(FCueSheetNext));
    end;
end;

procedure TfrmChannel.acgPlaylistClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
  inherited;

  with (Sender as TAdvColumnGrid) do
  begin
    if (ACol = IDX_COL_CUESHEET_NO) and (IsNode(ARow)) then
    begin
      SetNodeState(Arow, not GetNodeState(ARow));
    end;
  end;
end;

procedure TfrmChannel.acgPlaylistComboChange(Sender: TObject; ACol, ARow,
  AItemIndex: Integer; ASelection: string);
var
  CItem: PCueSheetItem;
  RCol, RRow: Integer;
  Index: Integer;
  SaveInput: TInputType;
  OB: TOutputBkgndType;
  OK: TOutputKeyerType;
begin
  inherited;

  if (not HasMainControl) then exit;

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if (FCueSheetList = nil) then exit;

    Index := RRow - FixedRows;

    CItem := GetCueSheetItemByIndex(Index);
    if (CItem <> nil) then
    begin
      with CItem^ do
      begin
        if (RCol = IDX_COL_CUESHEET_START_MODE) then
        begin
          with Columns[IDX_COL_CUESHEET_START_MODE].ComboItems do
            StartMode := TStartMode(Objects[AItemIndex]);
        end
        else if (RCol = IDX_COL_CUESHEET_INPUT) then
        begin
          SaveInput := Input;
          with Columns[IDX_COL_CUESHEET_INPUT].ComboItems do
            Input := TInputType(Objects[AItemIndex]);

          if ((SaveInput in [IT_MAIN, IT_BACKUP]) and (not (Input in [IT_MAIN, IT_BACKUP]))) or
             (not (SaveInput in [IT_MAIN, IT_BACKUP]) and (Input in [IT_MAIN, IT_BACKUP])) then
          begin
            Columns[IDX_COL_CUESHEET_OUTPUT].ComboItems.Clear;

            FOldOutput := Output;
            if (Input in [IT_MAIN, IT_BACKUP]) then
            begin
              for OB := OB_NONE to OB_BOTH do
              begin
                Columns[IDX_COL_CUESHEET_OUTPUT].ComboItems.AddObject(OutputBkgndTypeNames[OB], TObject(OB));
              end;
              Output := Integer(GV_SettingEventColumnDefault.OutputBkgnd);
              AllCells[IDX_COL_CUESHEET_OUTPUT, RRow] := OutputBkgndTypeNames[GV_SettingEventColumnDefault.OutputBkgnd];
            end
            else
            begin
              for OK := OK_NONE to OK_AD do
              begin
                Columns[IDX_COL_CUESHEET_OUTPUT].ComboItems.AddObject(OutputKeyerTypeNames[OK], TObject(OK));
              end;
              Output := Integer(GV_SettingEventColumnDefault.OutputKeyer);
              AllCells[IDX_COL_CUESHEET_OUTPUT, RRow] := OutputKeyerTypeNames[GV_SettingEventColumnDefault.OutputKeyer];
            end;
          end;
        end
        else if (RCol = IDX_COL_CUESHEET_OUTPUT) then
        begin
          with Columns[IDX_COL_CUESHEET_OUTPUT].ComboItems do
            Output := Integer(Objects[AItemIndex]);
        end
        else if (RCol = IDX_COL_CUESHEET_TR_TYPE) then
        begin
          with Columns[IDX_COL_CUESHEET_TR_TYPE].ComboItems do
            TransitionType := TTRType(Objects[AItemIndex]);
        end
        else if (RCol = IDX_COL_CUESHEET_TR_RATE) then
        begin
          with Columns[IDX_COL_CUESHEET_TR_RATE].ComboItems do
            TransitionRate := TTRRate(Objects[AItemIndex]);
        end
        else if (RCol = IDX_COL_CUESHEET_FINISH_ACTION) then
        begin
          with Columns[IDX_COL_CUESHEET_FINISH_ACTION].ComboItems do
            FinishAction := TFinishAction(Objects[AItemIndex]);
        end
        else if (RCol = IDX_COL_CUESHEET_PROGRAM_TYPE) then
        begin
          with Columns[IDX_COL_CUESHEET_PROGRAM_TYPE].ComboItems do
            ProgramType := Byte(Objects[AItemIndex]);
        end;
      end;
    end;
  end;
end;

procedure TfrmChannel.acgPlaylistComboDropDown(Sender: TObject; ARow,
  ACol: Integer);
var
  CItem: PCueSheetItem;
  RCol, RRow: Integer;
  Index: Integer;
  SM: TStartMode;
  OB: TOutputBkgndType;
  OK: TOutputKeyerType;
begin
  inherited;
exit;
  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    Index := RRow - FixedRows;

    CItem := GetCueSheetItemByIndex(Index);
    if (CItem <> nil) then
    begin
      if (RCol = IDX_COL_CUESHEET_START_MODE) then
      begin
        with CItem^ do
        begin
          Columns[ACol].ComboItems.Clear;
          case EventMode of
            EM_MAIN:
            begin
              for SM := SM_ABSOLUTE to SM_LOOP do
              begin
                Columns[ACol].ComboItems.AddObject(StartModeNames[SM], TObject(SM));
              end;
            end;
            EM_JOIN:
            begin
              for SM := SM_SUBBEGIN to SM_SUBBEGIN do
              begin
                Columns[ACol].ComboItems.AddObject(StartModeNames[SM], TObject(SM));
              end;
            end;
            EM_SUB:
            begin
              for SM := SM_SUBBEGIN to SM_SUBEND do
              begin
                Columns[ACol].ComboItems.AddObject(StartModeNames[SM], TObject(SM));
              end;
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
            for OK := OK_NONE to OK_AD do
            begin
              Columns[ACol].ComboItems.AddObject(OutputKeyerTypeNames[OK], TObject(OK));
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmChannel.acgPlaylistCustomCellDraw(Sender: TObject;
  Canvas: TCanvas; ACol, ARow: Integer; AState: TGridDrawState; ARect: TRect;
  Printing: Boolean);
begin
  inherited;
  exit;
  with (Sender as TAdvColumnGrid) do
  begin
//      if (GV_ClipboardCueSheetList.IndexOf(CItem) >= 0) then
//      begin
//        ABrush.Style := bsDiagCross;
//      end;

    if (gdSelected in AState) or (gdRowSelected in AState) then
    begin
      Canvas.Brush.Style := bsDiagCross;
      Canvas.Pen.Color := clRed;

      Canvas.MoveTo(ARect.Left, ARect.Top);
      Canvas.LineTo(ARect.Right + 1, ARect.Top);

      Canvas.MoveTo(ARect.Left, ARect.Bottom - 1);
      Canvas.LineTo(ARect.Right + 1, ARect.Bottom - 1);

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

procedure TfrmChannel.acgPlaylistDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
  inherited;

  if (not HasMainControl) then exit;

  with (Sender as TAdvColumnGrid) do
  begin
    if (EditMode) then exit;

    Options := Options - [goRowSelect];
    Options := Options + [goEditing];
    if (IsEditable(ACol, ARow)) then
    begin
//      ShowSelection := True;
      EditCell(ACol, ARow);
      ClearClipboardCueSheet;
    end
    else
    begin
    Options := Options + [goRowSelect];
    Options := Options - [goEditing];
    end;
  end;
end;

procedure TfrmChannel.acgPlaylistDrawCell(Sender: TObject; ACol, ARow: Integer;
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
//    frmSEC.WMTitleBar.Caption := Format('%d, %d', [ACol, ARow]);

    if not (gdFixed in State) and
       (((gdSelected in State) or (gdRowSelected in State)) or
        (RowSelect[ARow])) then
    begin
      Canvas.Brush.Style := bsClear;
      Canvas.Pen.Color := COLOR_ROW_SELECT_CUESHHET; //$00FFBDAD;//clRed;

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

procedure TfrmChannel.acgPlaylistEditCellDone(Sender: TObject; ACol,
  ARow: Integer);
var
  RCol, RRow: Integer;
  Index: Integer;
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

  SaveStartTime: TEventTime;
  SaveDurationTC: TTimecode;

  ChildCount: Integer;

  P: TPoint;

  procedure ReEditCell(ACol, ARow: Integer);
  begin
    with (Sender as TAdvColumnGrid) do
    begin
      Options := Options - [goRowSelect];
      Options := Options + [goEditing];
      EditCell(ACol, ARow);
    end;
  end;

begin
  inherited;

  if (not HasMainControl) then exit;

  frmSEC.EnableShortCutAction(True);

//  exit;
  // Check the cell validate.

//      MessageBeep(MB_ICONWARNING);
//      Application.MessageBox(PChar('111'), PChar(Application.Title), MB_OK or MB_ICONWARNING);

//acgPlaylist.ShowSelection := True;
//ShowMessage('1');
//            acgPlaylist.Options := acgPlaylist.Options + [goRowSelect];
//      acgPlaylist.SetFocus;
//acgPlaylist.ShowSelection := False;
//      exit;

  with (Sender as TAdvColumnGrid) do
  begin
    Options := Options + [goRowSelect];
    Options := Options - [goEditing];
  end;


  if (not FIsCellModified) then exit;

  with (Sender as TAdvColumnGrid) do
  begin
//      ShowSelection := True;
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    Index := RRow - FixedRows;

    CItem := GetCueSheetItemByIndex(Index);
    if (CItem <> nil) then
    begin
      with CItem^ do
      begin
        if (RCol = IDX_COL_CUESHEET_NO) then
        begin
          if (EventMode = EM_COMMENT) then
          begin
            StrPLCopy(Title, FNewCellValue, TITLE_LEN);
          end;
        end
        else if (RCol = IDX_COL_CUESHEET_START_MODE) then
        begin
          if (EventMode = EM_SUB) then
          begin
            if (not IsValidStartTime(CItem, CItem^.StartTime.T)) then
            begin
              ReEditCell(ACol, ARow);
              exit;
            end;
          end;
        end
        else if (RCol = IDX_COL_CUESHEET_START_DATE) then
        begin
          EnterDate := StrToDate(FNewCellValue);
          if (IsValidStartDate(CItem, EnterDate)) then
          begin
{            if (EventMode = EM_MAIN) then
            begin
              EnterStartTime := StartTime;
              EnterStartTime.D := EnterDate;

//              ResetStartDate(RRow - FixedRows + 1, Trunc(EnterDate - StartTime.D));

//              StartTime.D := EnterDate;
//              ResetStartTime(Index);

              ResetStartTimeByTime(Index, EnterStartTime);
              ResetChildItems(Index);

//              ResetStartDateTimeLine(RRow - FixedRows);
            end;   }

{            EnterStartTime := StartTime;
            EnterStartTime.D := EnterDate; }

            SaveStartTime := StartTime;
            StartTime.D   := EnterDate;

            ResetStartTimeByTime(Index, SaveStartTime);

//            ResetChildItems(Index);
          end
          else
          begin
//            GotoCell(ACol, ARow);
//      Selection := TGridRect(Rect(FixedCols, ARow, ColCount - 1, ARow));
//          RepaintRect(TRect(Selection));

//            Options := Options - [goRowSelect];
//            Options := Options + [goEditing];
//            ShowInplaceEdit;
//            Col := ACol;
//            Row := ARow;
//            PostMessage(Handle, WM_GRIDEDITSHOW, 0, 0);
//            PostMessage(Self.Handle, WM_INVALID_EDIT, ACol, ARow);

//            Col := ColCount - 1;
//            FocusCell(ACol, ARow);
//              Row := ARow;
//              Col := ACol;
//              P := CellRect(ACol, ARow).TopLeft;
//              PostMessage(Handle, WM_LBUTTONDBLCLK, 0, MakeLong(P.X, P.Y));
            ReEditCell(ACol, ARow);
//      ShowSelection := True;
//      SetFocus;
//            acgPlaylistDrawCell(acgPlaylist, ACol, ARow, Rect(0, 0, 0, 0), [gdSelected]);
//            Options := Options + [goRowSelect];
//            Options := Options - [goEditing];
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
          EnterTC := StringtoTimecode(FNewCellValue);
          if (IsValidStartTime(CItem, EnterTC)) then
          begin
{            StartTime.T := EnterTC;
            if (EventMode = EM_MAIN) then
            begin

//              ResetStartTime(Index);

              ResetStartTimeByTime(Index, EnterStartTime);
              ResetChildItems(Index);
            end; }
{
            EnterStartTime := StartTime;
            EnterStartTime.T := EnterTC; }

            SaveStartTime := StartTime;
            StartTime.T   := EnterTC;

            ResetStartTimeByTime(Index, SaveStartTime);

//            ResetChildItems(Index);
          end
          else
          begin
            ReEditCell(ACol, ARow);
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
{          with Columns[IDX_COL_CUESHEET_OUTPUT].ComboItems do
            Output := Integer(Objects[IndexOf(Cells[IDX_COL_CUESHEET_OUTPUT, ARow])]); }
        end
        else if (RCol = IDX_COL_CUESHEET_TITLE) then
          StrPLCopy(Title, FNewCellValue, TITLE_LEN)
        else if (RCol = IDX_COL_CUESHEET_SUB_TITLE) then
          StrPLCopy(SubTitle, FNewCellValue, SUBTITLE_LEN)
        else if (RCol = IDX_COL_CUESHEET_SOURCE) then
        begin
          // If source change then onair event delete process
          if (FOldCellValue <> FNewCellValue) then
            OnAirDeleteEvents(Index, FLastInputIndex);

          StrPLCopy(Source, FNewCellValue, DEVICENAME_LEN);
        end
        else if (RCol = IDX_COL_CUESHEET_MEDIA_ID) then
        begin
          StrPLCopy(MediaId, FNewCellValue, MEDIAID_LEN);
        end
        else if (RCol = IDX_COL_CUESHEET_DURATON) then
        begin
          EnterTC := StringToTimecode(FNewCellValue);
          if (IsValidDuration(CItem, EnterTC)) then
          begin
{            DurationTC := EnterTC;
            if (EventMode = EM_MAIN) then
            begin
              ResetStartTime(Index);
              ResetChildItems(Index);
            end;
//            DurationTC := EnterTC; }

            SaveDurationTC := DurationTC;
            DurationTC     := EnterTC;

            OutTC := GetPlusTimecode(InTC, FrameToTimecode(TimecodeToFrame(DurationTC, ChannelFrameRateType) - 1, ChannelFrameRateType), ChannelFrameRateType);

            ResetStartTimeByTime(Index, SaveDurationTC);

//            ResetStartTimeByDuration(Index, EnterTC);
//            ResetChildItems(Index);
          end
          else
          begin
            ReEditCell(ACol, ARow);
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
          EnterTC := StringToTimecode(FNewCellValue);
          if (IsValidInTC(CItem, EnterTC)) then
          begin
            InTC := EnterTC;
            OutTC := GetPlusTimecode(InTC, FrameToTimecode(TimecodeToFrame(DurationTC, ChannelFrameRateType) - 1, ChannelFrameRateType), ChannelFrameRateType);

            if (EventMode = EM_MAIN) then
            begin
//              ResetChildItems(Index);

{              if (ChannelOnAir) then
              begin
                ChildCount := GetChildCountByItem(CItem);

                if (Index <= FLastInputIndex) then
                  OnAirInputEvents(Index, ChildCount + 1);

                ServerBeginUpdates(ChannelID);
                try
                  ServerInputCueSheets(ChannelID, Index, ChildCount + 1);
                finally
                  ServerEndUpdates(ChannelID);
                end;
              end; }
            end;
          end
          else
          begin
            ReEditCell(ACol, ARow);
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
          EnterTC := StringToTimecode(FNewCellValue);

          if (IsValidOutTC(CItem, EnterTC)) then
          begin
            OutTC := EnterTC;
            SaveDurationTC := DurationTC;
            DurationTC     := GetDurTimecode(InTC, FrameToTimeCode(TimecodeToFrame(OutTC, ChannelFrameRateType) + 1, ChannelFrameRateType), ChannelFrameRateType);

            if (EventMode = EM_MAIN) then
            begin
//              ResetChildItems(Index);

{              if (ChannelOnAir) then
              begin
                ChildCount := GetChildCountByItem(CItem);

                if (Index <= FLastInputIndex) then
                  OnAirInputEvents(Index, ChildCount + 1);

                ServerBeginUpdates(ChannelID);
                try
                  ServerInputCueSheets(ChannelID, Index, ChildCount + 1);
                finally
                  ServerEndUpdates(ChannelID);
                end;
              end; }

              ResetStartTimeByTime(Index, SaveDurationTC);
            end;
          end
          else
          begin
            ReEditCell(ACol, ARow);
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
        else if (RCol = IDX_COL_CUESHEET_NOTES) then
          StrPLCopy(Notes, FNewCellValue, NOTES_LEN);
      end;

      if (ChannelOnAir) then
      begin

//        // DoCueSheetCheck���� �ޤ����� �̺�Ʈ�� Input ó����
        if (Index <= FLastInputIndex) then
        begin
          OnAirInputEvents(Index, GV_SettingOption.MaxInputEventCount);
        end;


        ServerBeginUpdates(ChannelID);
        try
          ServerInputCueSheets(ChannelID, Index);
        finally
          ServerEndUpdates(ChannelID);
        end;
      end;
    end;
//      ShowSelection := False;
  end;

  FIsCellEditing  := False;
  FIsCellModified := False;
end;

procedure TfrmChannel.acgPlaylistEditChange(Sender: TObject; ACol,
  ARow: Integer; Value: string);
begin
  inherited;

  if (not HasMainControl) then exit;

  if (not FIsCellModified) then
  begin
    with (Sender as TAdvColumnGrid) do
      FOldCellValue := Cells[ACol, ARow];
    FIsCellModified := True;
  end;
end;

procedure TfrmChannel.acgPlaylistEditingDone(Sender: TObject);
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
  inherited;
  exit;
  with (Sender as TAdvColumnGrid) do
  begin
    Options := Options + [goRowSelect];
    Options := Options - [goEditing];
  end;

  exit;
  // Check the cell validate.

  if (not FIsCellModified) then exit;

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(Col);
    RRow := RealRowIndex(Row);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    CItem := GetCueSheetItemByIndex(RRow - FixedRows);
    if (CItem <> nil) then
    begin
      Value := Cells[Col, Row];
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
            EditCell(Col, Row);
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
          if (IsValidStartTime(CItem, EnterTC)) then
          begin
            if (EventMode = EM_MAIN) then
            begin
              EnterStartTime   := StartTime;
              EnterStartTime.T := EnterTC;

              DurTime := GetDurEventTime(StartTime, EnterStartTime, ChannelFrameRateType);
              ResetStartTimePlus(RRow - FixedRows + 1, DurTime);
            end;

            StartTime.T := EnterTC;
          end
          else
          begin
            EditCell(Col, Row);
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
          StrPLCopy(Title, Value, TITLE_LEN)
        else if (RCol = IDX_COL_CUESHEET_SUB_TITLE) then
          StrPLCopy(SubTitle, Value, SUBTITLE_LEN)
        else if (RCol = IDX_COL_CUESHEET_SOURCE) then
          StrPLCopy(Source, Value, DEVICENAME_LEN)
        else if (RCol = IDX_COL_CUESHEET_MEDIA_ID) then
          StrPLCopy(MediaId, Value, MEDIAID_LEN)
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

              DurTime := GetDurEventTime(SaveTime, CStartTime, ChannelFrameRateType);
              ResetStartTimePlus(RRow - FixedRows + 1, DurTime);
            end;
            DurationTC := EnterTC;
          end
          else
          begin
            EditCell(Col, Row);
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
            EditCell(Col, Row);
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
            EditCell(Col, Row);
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
        else if (RCol = IDX_COL_CUESHEET_FINISH_ACTION) then
        begin
          with Columns[IDX_COL_CUESHEET_FINISH_ACTION].ComboItems do
            FinishAction := TFinishAction(Objects[IndexOf(Value)]);
        end
        else if (RCol = IDX_COL_CUESHEET_PROGRAM_TYPE) then
        begin
          with Columns[IDX_COL_CUESHEET_PROGRAM_TYPE].ComboItems do
            ProgramType := Byte(Objects[IndexOf(Value)]);
        end
        else if (RCol = IDX_COL_CUESHEET_NOTES) then
          StrPLCopy(Notes, Value, NOTES_LEN);
      end;
    end;
  end;

  FIsCellEditing  := False;
  FIsCellModified := False;
end;

procedure TfrmChannel.acgPlaylistEllipsClick(Sender: TObject; ACol,
  ARow: Integer; var S: string);
var
  Index: Integer;
  Item: PCueSheetItem;
  Source: PSource;
  FileName: String;
  SaveDurationTC: TTimecode;
begin
  inherited;

  if (not HasMainControl) then exit;

  with acgPlaylist do
  begin
    Index := RealRowIndex(ARow) - FixedRows;

    Item := GetCueSheetItemByIndex(Index);

    if (Item = nil) then exit;

    Source := GetSourceByName(String(Item^.Source));
    if (Source = nil) then exit;

    if (Source^.SourceType = ST_VSDEC) and (Source^.UsePCS) then
    begin
      FileName := String(Item^.MediaId);
      if (OpenDialogMediaFile(NAM_COL_CUESHEET_MEDIA_ID, FileName)) then
      begin
//        StrPLCopy(Item^.MediaId, FileName);
        S := FileName;

        SaveDurationTC := Item^.DurationTC;
        Item^.DurationTC := GetMediaDuration(FileName);

        RepaintRow(ARow);

        if (Item^.EventMode = EM_MAIN) then
        begin
          ResetStartTimeByTime(Index, SaveDurationTC);
        end;

//        Modified := True;
//        RepaintCell(IDX_COL_CUESHEET_MEDIA_ID, ARow);
      end;
    end;
  end;
end;

procedure TfrmChannel.acgPlaylistExpandNode(Sender: TObject; ARow,
  ARowreal: Integer);
var
  Level: Integer;
  I: Integer;
  NodeSpan: Integer;
  SubNodeState: Boolean;

  CellGraphic: TCellGraphic;
  O: TObject;
  C: TCellType;
  CG: TCellGraphic;
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
        begin
          ShowMessage(IntToStr(RealRowIndex(I)) + 'Node');
          CG := CellGraphics[CellNode.NodeColumn, RealRowIndex(I)];
          if (CG.CellBoolean) then
            ShowMessage('Contract')
          else
            ShowMessage('Expand')

        end
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

procedure TfrmChannel.acgPlaylistFixedCellClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  inherited;
//  ShowMessage(IntToStr(acgPlaylist.Columns[ACol].Width));
end;

procedure TfrmChannel.acgPlaylistGetCellBorder(Sender: TObject; ARow,
  ACol: Integer; APen: TPen; var Borders: TCellBorders);
var
  RCol, RRow: Integer;
begin
  inherited;
  exit;
  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if (RowSelect[RRow]) then
      Borders := [cbTop, cbBottom];

    if (RCol = IDX_COL_CUESHEET_GROUP) then
    begin
      Borders := Borders + [cbRight];
      exit;
    end;
  end;
end;

procedure TfrmChannel.acgPlaylistGetCellBorderProp(Sender: TObject; ARow,
  ACol: Integer; LeftPen, TopPen, RightPen, BottomPen: TPen);
var
  RCol, RRow: Integer;
begin
  inherited;
  exit;
  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    TopPen.Color := clRed;
    BottomPen.Color := clRed;

    if (RCol = IDX_COL_CUESHEET_GROUP) then
    begin
      RightPen.Color := GridLineColor;
    end;
  end;
end;

procedure TfrmChannel.acgPlaylistGetCellColor(Sender: TObject; ARow,
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
    SetEventStatusColor(Item);

    if (Item <> nil) then
    begin
      if {(GV_ClipboardCueSheet.PasteMode = pmCut) and }(GV_ClipboardCueSheet.IndexOf(Item) >= 0) then
      begin
        ABrush.Color := COLOR_BK_CLIPBOARD;
        AFont.Color  := COLOR_TX_CLIPBOARD;
      end
      else
      begin
        ABrush.Color := Item^.BkColor;
        AFont.Color  := Item^.TxColor;

        if (Item^.EventStatus.State = esError) then
        begin
//          case Item^.EventStatus.ErrorCode of
//            E_INVALID_START_TIME:
//            begin
//              if (RCol in [IDX_COL_CUESHEET_START_DATE, IDX_COL_CUESHEET_START_TIME]) then
//              begin
//                if (FErrorDisplayEnabled) then
//                begin
//                  ABrush.Color := COLOR_BK_EVENTSTATUS_ERROR;
//                  AFont.Color  := COLOR_TX_EVENTSTATUS_ERROR;
//                end{
//                else
//                begin
//                  ABrush.Color := COLOR_BK_EVENTSTATUS_NORMAL;
//                  AFont.Color  := COLOR_TX_EVENTSTATUS_NORMAL;
//                end};
//              end;
//            end;
//            else
//            begin
//              if (RCol = IDX_COL_CUESHEET_SOURCE) then
//              begin
//                if (FErrorDisplayEnabled) then
//                begin
//                  ABrush.Color := COLOR_BK_EVENTSTATUS_ERROR;
//                  AFont.Color  := COLOR_TX_EVENTSTATUS_ERROR;
//                end{
//                else
//                begin
//                  ABrush.Color := COLOR_BK_EVENTSTATUS_NORMAL;
//                  AFont.Color  := COLOR_TX_EVENTSTATUS_NORMAL;
//                end};
//              end;
//            end;
//          end;

          if (RCol in [IDX_COL_CUESHEET_START_DATE, IDX_COL_CUESHEET_START_TIME]) then
          begin
            if (FErrorDisplayEnabled) then
            begin
              if ((Item^.EventStatus.ErrorCode and E_INVALID_START_TIME) = E_INVALID_START_TIME) or
                 ((Item^.EventStatus.ErrorCode and E_DUPLICATED_START_TIME) = E_DUPLICATED_START_TIME) or
                 ((Item^.EventStatus.ErrorCode and E_BLANK_START_TIME) = E_BLANK_START_TIME) then
              begin
                ABrush.Color := COLOR_BK_EVENTSTATUS_ERROR;
                AFont.Color  := COLOR_TX_EVENTSTATUS_ERROR;
              end;
            end;
          end
          else if (RCol in [IDX_COL_CUESHEET_SOURCE]) then
          begin
            if (FErrorDisplayEnabled) then
            begin
              if ((Item^.EventStatus.ErrorCode and E_INVALID_DEVICE_NAME) = E_INVALID_DEVICE_NAME) or
                 ((Item^.EventStatus.ErrorCode and E_INVALID_DEVICE_HANDLE) = E_INVALID_DEVICE_HANDLE) or
                 ((Item^.EventStatus.ErrorCode and E_DUPLICATED_DEVICE) = E_DUPLICATED_DEVICE) or
                 ((Item^.EventStatus.ErrorCode and E_NOT_SUCCESSIVE_DEVICE) = E_NOT_SUCCESSIVE_DEVICE) then
              begin
                ABrush.Color := COLOR_BK_EVENTSTATUS_ERROR;
                AFont.Color  := COLOR_TX_EVENTSTATUS_ERROR;
              end;
            end;
          end
          else if (RCol in [IDX_COL_CUESHEET_MEDIA_ID]) then
          begin
            if (FErrorDisplayEnabled) then
            begin
              if ((Item^.EventStatus.ErrorCode and E_EMPTY_MEDIA_ID) = E_EMPTY_MEDIA_ID) then
              begin
                ABrush.Color := COLOR_BK_EVENTSTATUS_ERROR;
                AFont.Color  := COLOR_TX_EVENTSTATUS_ERROR;
              end;
            end;
          end;
        end;

        if (Item^.MediaStatus in [msNotExist, msShort]) then
        begin
          if (RCol in [IDX_COL_CUESHEET_MEDIA_ID, IDX_COL_CUESHEET_MEDIA_STATUS]) then
          begin
            if (FErrorDisplayEnabled) then
            begin
              ABrush.Color := COLOR_BK_MEDIASTATUS_NOT_EXIST;
              AFont.Color  := COLOR_TX_MEDIASTATUS_NOT_EXIST;
            end{
            else
            begin
              ABrush.Color := COLOR_BK_MEDIASTATUS_NORMAL;
              AFont.Color  := COLOR_TX_MEDIASTATUS_NORMAL;
            end};
          end;
        end;
      end;
    end;

    if (AFont.Color = COLOR_TX_EVENTSTATUS_NORMAL) and
       (not (gdFixed in AState) and
       (((gdSelected in AState) or (gdRowSelected in AState)) or
        (RowSelect[ARow]))) then
    begin
      AFont.Color := clWhite;
    end;

    exit;

    if (Item <> nil) then
    begin
      if {(GV_ClipboardCueSheet.PasteMode = pmCut) and }(GV_ClipboardCueSheet.IndexOf(Item) >= 0) then
      begin
        ABrush.Color := COLOR_BK_CLIPBOARD;
        AFont.Color  := COLOR_TX_CLIPBOARD;
      end
      else if (Item^.EventMode = EM_PROGRAM) then
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
            if (FErrorDisplayEnabled) then
            begin
              case Item^.EventStatus.ErrorCode of
                E_INVALID_START_TIME:
                  if (RCol in [IDX_COL_CUESHEET_START_DATE, IDX_COL_CUESHEET_START_TIME]) then
                  begin
                    ABrush.Color := COLOR_BK_EVENTSTATUS_ERROR;
                    AFont.Color  := COLOR_TX_EVENTSTATUS_ERROR;
                  end;
                else
                  if (RCol = IDX_COL_CUESHEET_SOURCE) then
                  begin
                    ABrush.Color := COLOR_BK_EVENTSTATUS_ERROR;
                    AFont.Color  := COLOR_TX_EVENTSTATUS_ERROR;
                  end;
              end;
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

    if (AFont.Color = COLOR_TX_EVENTSTATUS_NORMAL) and
       (not (gdFixed in AState) and
       (((gdSelected in AState) or (gdRowSelected in AState)) or
        (RowSelect[ARow]))) then
    begin
      AFont.Color := clWhite;
    end;
  end;
end;

procedure TfrmChannel.acgPlaylistGetDisplText(Sender: TObject; ACol,
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
              Value := TimecodeToString(StartTime.T, ChannelIsDropFrame)
            else if (EventMode in [EM_PROGRAM]) and (EventStatus.State <> esSkipped) then
            begin
              ProgramMainItem := GetProgramMainItemByItem(Item);
              if (ProgramMainItem <> nil) then
                Value := TimecodeToString(ProgramMainItem^.StartTime.T, ChannelIsDropFrame)
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
{            if (EventMode in [EM_PROGRAM]) then
            begin
              ProgramMainItem := GetProgramMainItemByItem(Item);
              if (ProgramMainItem <> nil) then
                Value := TimecodeToString(ProgramMainItem^.StartTime.T)
              else
                Value := ''; }

            Value := EventStatusNames[EventStatus.State];
          end
          else if (RCol = IDX_COL_CUESHEET_TITLE) then
          begin
            Value := String(Title);
//            Value := Format('%d, %d', [ARow, RRow]);
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
              Value := TimecodeToString(DurationTC, ChannelIsDropFrame)
            else if (EventMode in [EM_PROGRAM]) then
              Value := TimecodeToString(GetProgramDurationByItem(Item), ChannelIsDropFrame)
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_IN_TC) then
          begin
            if (EventMode in [EM_MAIN, EM_SUB]) then
              Value := TimecodeToString(InTC, ChannelIsDropFrame)
            else
              Value := '';
          end
          else if (RCol = IDX_COL_CUESHEET_OUT_TC) then
          begin
            if (EventMode in [EM_MAIN, EM_SUB]) then
              Value := TimecodeToString(OutTC, ChannelIsDropFrame)
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
          else if (RCol = IDX_COL_CUESHEET_FINISH_ACTION) then
          begin
            if (EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
              Value := FinishActionNames[FinishAction]
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

procedure TfrmChannel.acgPlaylistGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: string);
var
  RCol, RRow: Integer;
  Item: PCueSheetItem;
begin
  inherited;

  frmSEC.EnableShortCutAction(False);

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);
    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    if (FIsCellModified) then
    begin
      Value := FNewCellValue;
      exit;
    end;

    Item := GetCueSheetItemByIndex(RRow - CNT_CUESHEET_HEADER);
    if (Item <> nil) then
    begin
      with Item^ do
      begin
        if (RCol = IDX_COL_CUESHEET_NO) then
        begin
          if (EventMode = EM_COMMENT) then
          begin
            Value := String(Title);
          end;
        end
        else if (RCol = IDX_COL_CUESHEET_START_MODE) then
        begin
          Value := StartModeNames[StartMode];
        end
        else if (RCol = IDX_COL_CUESHEET_START_DATE) then
        begin
          Value := FormatDateTime(FORMAT_DATE, StartTime.D)
        end
        else if (RCol = IDX_COL_CUESHEET_START_TIME) then
        begin
          Value := TimecodeToString(StartTime.T, ChannelIsDropFrame)
        end
        else if (RCol = IDX_COL_CUESHEET_INPUT) then
        begin
          Value := InputTypeNames[Input];
        end
        else if (RCol = IDX_COL_CUESHEET_OUTPUT) then
        begin
          if (Input in [IT_MAIN, IT_BACKUP]) then
            Value := OutputBkgndTypeNames[TOutputBkgndType(Output)]
          else
            Value := OutputKeyerTypeNames[TOutputKeyerType(Output)];
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
          Value := String(Source);
        end
        else if (RCol = IDX_COL_CUESHEET_MEDIA_ID) then
        begin
          Value := String(MediaId);
        end
        else if (RCol = IDX_COL_CUESHEET_DURATON) then
        begin
          Value := TimecodeToString(DurationTC, ChannelIsDropFrame)
        end
        else if (RCol = IDX_COL_CUESHEET_IN_TC) then
        begin
          Value := TimecodeToString(InTC, ChannelIsDropFrame)
        end
        else if (RCol = IDX_COL_CUESHEET_OUT_TC) then
        begin
          Value := TimecodeToString(OutTC, ChannelIsDropFrame)
        end
        else if (RCol = IDX_COL_CUESHEET_TR_TYPE) then
        begin
          Value := TRTypeNames[TransitionType];
        end
        else if (RCol = IDX_COL_CUESHEET_TR_RATE) then
        begin
          Value := TRRateNames[TransitionRate];
        end
        else if (RCol = IDX_COL_CUESHEET_FINISH_ACTION) then
        begin
          Value := FinishActionNames[FinishAction];
        end
        else if (RCol = IDX_COL_CUESHEET_PROGRAM_TYPE) then
        begin
          Value := GetProgramTypeNameByCode(ProgramType);
        end
        else if (RCol = IDX_COL_CUESHEET_NOTES) then
        begin
          Value := String(Notes);
        end;
      end;
    end;
  end;

//  if (not FIsCellEditing) then
//  begin
//    with (Sender as TAdvColumnGrid) do
//      FOldCellValue := Cells[ACol, ARow];
//    FIsCellEditing := True;
//  end;
end;

procedure TfrmChannel.acgPlaylistKeyPress(Sender: TObject; var Key: Char);
var
  CueSheetItem: PCueSheetItem;
  RCol, RRow: Integer;
  SaveInput: TInputType;
  OB: TOutputBkgndType;
  OK: TOutputKeyerType;
begin
  inherited;

  if (not HasMainControl) then exit;

  with acgPlaylist do
  begin
    if (Key = #27) then
    begin
      Modified := False;
      RCol := RealColIndex(Col);
      RRow := RealRowIndex(Row);

//      ShowMEssage(Format('%d, %d, %d, %d', [Col, Row, RCol, RRow]));

{      if (FIsCellEditing) then
      begin
        FIsCellEditing  := False;
        FIsCellModified := False;
        Cells[Col, Row] := FOldCellValue;
      end;  }

      if (FIsCellModified) then
      begin
        FIsCellModified := False;
//        PopulatePlayListGrid(RRow - CNT_CUESHEET_HEADER);
//        Cells[Col, Row] := FOldCellValue;
        FNewCellValue := FOldCellValue;
//        ShowSelection := False;

        if (RRow < FixedRows) or (RCol < FixedCols) then exit;

        CueSheetItem := GetCueSheetItemByIndex(RRow - FixedRows);
        if (CueSheetItem <> nil) then
        begin
          with CueSheetItem^ do
          begin
            if (RCol = IDX_COL_CUESHEET_START_MODE) then
            begin
              with Columns[IDX_COL_CUESHEET_START_MODE].ComboItems do
                StartMode := TStartMode(Objects[IndexOf(FOldCellValue)]);
            end
            else if (RCol = IDX_COL_CUESHEET_INPUT) then
            begin
              with Columns[IDX_COL_CUESHEET_INPUT].ComboItems do
                Input := TInputType(Objects[IndexOf(FOldCellValue)]);

              Output := FOldOutput;
            end
            else if (RCol = IDX_COL_CUESHEET_OUTPUT) then
            begin
              with Columns[IDX_COL_CUESHEET_OUTPUT].ComboItems do
                Output := Integer(Objects[IndexOf(FOldCellValue)]);
            end
            else if (RCol = IDX_COL_CUESHEET_TR_TYPE) then
            begin
              with Columns[IDX_COL_CUESHEET_TR_TYPE].ComboItems do
                TransitionType := TTRType(Objects[IndexOf(FOldCellValue)]);
            end
            else if (RCol = IDX_COL_CUESHEET_TR_RATE) then
            begin
              with Columns[IDX_COL_CUESHEET_TR_RATE].ComboItems do
                TransitionRate := TTRRate(Objects[IndexOf(FOldCellValue)]);
            end
            else if (RCol = IDX_COL_CUESHEET_FINISH_ACTION) then
            begin
              with Columns[IDX_COL_CUESHEET_FINISH_ACTION].ComboItems do
                FinishAction := TFinishAction(Objects[IndexOf(FOldCellValue)]);
            end
            else if (RCol = IDX_COL_CUESHEET_VIDEO_TYPE) then
            begin
              with Columns[IDX_COL_CUESHEET_VIDEO_TYPE].ComboItems do
                VideoType := TVideoType(Objects[IndexOf(FOldCellValue)]);
            end
            else if (RCol = IDX_COL_CUESHEET_AUDIO_TYPE) then
            begin
              with Columns[IDX_COL_CUESHEET_AUDIO_TYPE].ComboItems do
                AudioType := TAudioType(Objects[IndexOf(FOldCellValue)]);
            end
            else if (RCol = IDX_COL_CUESHEET_CLOSED_CAPTION) then
            begin
              with Columns[IDX_COL_CUESHEET_CLOSED_CAPTION].ComboItems do
                ClosedCaption := TClosedCaption(Objects[IndexOf(FOldCellValue)]);
            end
            else if (RCol = IDX_COL_CUESHEET_VOICE_ADD) then
            begin
              with Columns[IDX_COL_CUESHEET_VOICE_ADD].ComboItems do
                VoiceAdd := TVoiceAdd(Objects[IndexOf(FOldCellValue)]);
            end
            else if (RCol = IDX_COL_CUESHEET_PROGRAM_TYPE) then
            begin
              with Columns[IDX_COL_CUESHEET_PROGRAM_TYPE].ComboItems do
                ProgramType := Byte(Objects[IndexOf(FOldCellValue)]);
            end
          end;
        end;
      end
      else
        ClearClipboardCueSheet;


      exit;

      if (RRow < FixedRows) or (RCol < FixedCols) then exit;

      if (RCol = IDX_COL_CUESHEET_INPUT) then
      begin
        CueSheetItem := GetCueSheetItemByIndex(RRow - FixedRows);
        if (CueSheetItem <> nil) then
          with CueSheetItem^ do
          begin
            SaveInput := Input;

            with Columns[IDX_COL_CUESHEET_INPUT].ComboItems do
              Input := TInputType(Objects[IndexOf(Cells[Col, Row])]);

            if ((SaveInput in [IT_MAIN, IT_BACKUP]) and (not (Input in [IT_MAIN, IT_BACKUP]))) or
               (not (SaveInput in [IT_MAIN, IT_BACKUP]) and (Input in [IT_MAIN, IT_BACKUP])) then
            begin
              Columns[IDX_COL_CUESHEET_OUTPUT].ComboItems.Clear;
              if (Input in [IT_MAIN, IT_BACKUP]) then
              begin
                for OB := OB_NONE to OB_BOTH do
                begin
                  Columns[IDX_COL_CUESHEET_OUTPUT].ComboItems.AddObject(OutputBkgndTypeNames[OB], TObject(OB));
                end;
                Cells[IDX_COL_CUESHEET_OUTPUT, RRow] := OutputBkgndTypeNames[TOutputBkgndType(Output)];
              end
              else
              begin
                for OK := OK_NONE to OK_AD do
                begin
                  Columns[IDX_COL_CUESHEET_OUTPUT].ComboItems.AddObject(OutputKeyerTypeNames[OK], TObject(OK));
                end;
                Cells[IDX_COL_CUESHEET_OUTPUT, RRow] := OutputKeyerTypeNames[TOutputKeyerType(Output)];
              end;
            end;
          end;
      end;
    end;
  end;
end;

procedure TfrmChannel.acgPlaylistRowUpdate(Sender: TObject; OldRow,
  NewRow: Integer);
var
  ChannelCueSheet: PChannelCueSheet;
begin
  inherited;
  with acgPlaylist do
    ChannelCueSheet := GetChannelCueSheetByIndex(RealRowIndex(NewRow) - FixedRows);
    if (ChannelCueSheet <> nil) then
      PlayListFileName := String(ChannelCueSheet^.FileName)
    else
      PlayListFileName := '';
end;

procedure TfrmChannel.acgPlaylistSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  Index: Integer;
  CItem: PCueSheetItem;
  RCol, RRow: Integer;
  SM: TStartMode;
  OB: TOutputBkgndType;
  OK: TOutputKeyerType;

  ChannelCueSheet: PChannelCueSheet;
begin
  inherited;

  with (Sender as TAdvColumnGrid) do
  begin
    RCol := RealColIndex(ACol);
    RRow := RealRowIndex(ARow);

    if (RRow < FixedRows) or (RCol < FixedCols) then exit;

    Index := RRow - FixedRows;

    CItem := GetCueSheetItemByIndex(Index);
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
            for OK := OK_NONE to OK_AD do
            begin
              Columns[ACol].ComboItems.AddObject(OutputKeyerTypeNames[OK], TObject(OK));
            end;
          end;
        end;
      end;
    end;

//    ChannelCueSheet := GetChannelCueSheetByIndex(RealRowIndex(Row) - FixedRows);
//    if (ChannelCueSheet <> nil) then
//      PlayListFileName := String(ChannelCueSheet^.FileName)
//    else
//      PlayListFileName := '';
  end;
end;

procedure TfrmChannel.acgPlaylistSelectionChanged(Sender: TObject; ALeft, ATop,
  ARight, ABottom: Integer);
begin
  inherited;
  with (Sender as TAdvColumnGrid) do
    lblEventCount.Caption := Format('%d / %d', [SelectedRowCount, FCueSheetList.Count + 1]);
end;

procedure TfrmChannel.acgPlaylistSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  inherited;
  FNewCellValue := Value;
end;

function TfrmChannel.SECBeginUpdateW: Integer;
begin
  Result := D_FALSE;

  SendMessage(Handle, WM_BEGIN_UPDATEW, 0, 0);

//  Window message���� ó��
  if (frmAllChannels <> nil) then
    SendMessage(frmAllChannels.Handle, WM_BEGIN_UPDATEW, 0, 0);

  Result := D_OK;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'SECBeginUpdateW'));
end;

function TfrmChannel.SECEndUpdateW: Integer;
begin
  Result := D_FALSE;

  SendMessage(Handle, WM_END_UPDATEW, 0, 0);

//  Window message���� ó��
  if (frmAllChannels <> nil) then
    SendMessage(frmAllChannels.Handle, WM_END_UPDATEW, 0, 0);

  Result := D_OK;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'SECEndUpdateW'));
end;

function TfrmChannel.SECSetOnAirW(AIsOnAir: Boolean): Integer;
begin

  Assert(False, GetChannelLogStr(lsError, ChannelID, 'SECSetOnAirW start.'));
  Result := D_FALSE;

//  Windows message���� ó��
  FChannelOnAir := AIsOnAir;

  PostMessage(Handle, WM_SET_ONAIRW, ChannelID, NativeInt(AIsOnAir));

//  Windows message���� ó��
  if (frmAllChannels <> nil) then
    PostMessage(frmAllChannels.Handle, WM_SET_ONAIRW, ChannelID, NativeInt(AIsOnAir));

  Result := D_OK;
  Assert(False, GetChannelLogStr(lsError, ChannelID, 'SECSetOnAirW end.'));
end;

function TfrmChannel.SECSetEventStatusW(AEventID: TEventID; AStatus: TEventStatus): Integer;
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

      if (frmAllChannels <> nil) then
        PostMessage(frmAllChannels.Handle, WM_UPDATE_EVENT_STATUS, Index, NativeInt(Item));
    end;
  end;

  Result := D_OK;
end;

function TfrmChannel.SECSetMediaStatusW(AEventID: TEventID; AStatus: TMediaStatus): Integer;
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

      if (frmAllChannels <> nil) then
        PostMessage(frmAllChannels.Handle, WM_UPDATE_MEDIA_CHECK, Index, NativeInt(Item));
    end;
  end;

  Result := D_OK;
end;

function TfrmChannel.SECSetTimelineRangeW(AStartDate, AEndDate: TDateTime): Integer;
begin
// Window message���� Ÿ�Ӷ��� �ٽ� ���
//  FTimelineStartDate := AStartDate;
//  FTimelineEndDate   := AEndDate;

{  if (frmAllChannels <> nil) then
  begin
    frmAllChannels.CalcuratePlayListTimeLineRange(AStartDate, AEndDate);
  end; }

  PostMessage(Handle, WM_SET_TIMELINE_RANGEW, 0, 0);

  if (frmAllChannels <> nil) then
  begin
    PostMessage(frmAllChannels.Handle, WM_SET_TIMELINE_RANGEW, 0, 0);
  end;

  Result := D_OK;
end;

function TfrmChannel.SECInputCueSheetW(AIndex: Integer; ACueSheetItem: TCueSheetItem): Integer;
var
  Item: PCueSheetItem;
begin
  Result := D_FALSE;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECInputCueSheetW Index=%d, ID=%s', [AIndex, EventIDToString(ACueSheetItem.EventID)])));

  Item := GetCueSheetItemByID(ACueSheetItem.EventID);
  if (Item <> nil) then
  begin
  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'U111'));
    Move(ACueSheetItem, Item^, SizeOf(TCueSheetItem));
  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'U222'));
    Result := GetCueSheetIndexByItem(Item);
  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'U333'));

    PostMessage(Handle, WM_UPDATE_CUESHEETW, Result, NativeInt(Item));
  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'U444'));

    if (frmAllChannels <> nil) then
      PostMessage(frmAllChannels.Handle, WM_UPDATE_CUESHEETW, Result, NativeInt(Item));
  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'U555'));

    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECInputCueSheetW update cuesheet, Index=%d, ID=%s', [AIndex, EventIDToString(ACueSheetItem.EventID)])));
  end
  else
  begin
    FCueSheetLock.Enter;
    try
    Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'I111'));
      Item := New(PCueSheetItem);
    Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'I222'));
      Move(ACueSheetItem, Item^, SizeOf(TCueSheetItem));
    Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'I333'));
      if (AIndex < FCueSheetList.Count) then
        FCueSheetList.Insert(AIndex, Item)
      else
        FCueSheetList.Add(Item);
  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'I444'));

    PostMessage(Handle, WM_INSERT_CUESHEETW, AIndex, NativeInt(Item));
  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'I555'));

    if (frmAllChannels <> nil) then
      PostMessage(frmAllChannels.Handle, WM_INSERT_CUESHEETW, AIndex, NativeInt(Item));
  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'I666'));

    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECInputCueSheetW insert cuesheet, Index=%d, ID=%s', [AIndex, EventIDToString(ACueSheetItem.EventID)])));
    finally
      FCueSheetLock.Leave;
    end;
  end;

  if (IsEqualEventID(Item^.EventID, FServerEventIDCurr)) then CueSheetCurr := Item;
  if (IsEqualEventID(Item^.EventID, FServerEventIDNext)) then CueSheetNext := Item;
  if (IsEqualEventID(Item^.EventID, FServerEventIDTarget)) then CueSheetTarget := Item;

  // Sort
//  EventQueueSort;

  Result := D_OK;
end;

function TfrmChannel.SECDeleteCueSheetW(AEventID: TEventID): Integer;
var
  Item: PCueSheetItem;
  Index: Integer;
begin
  Result := D_FALSE;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECDeleteCueSheetW ID=%s', [EventIDToString(AEventID)])));

  Item := GetCueSheetItemByID(AEventID);
  if (Item <> nil) then
  begin
    Index := GetCueSheetIndexByItem(Item);

    SendMessage(Handle, WM_DELETE_CUESHEETW, Index, NativeInt(Item));

    if (frmAllChannels <> nil) then
      SendMessage(frmAllChannels.Handle, WM_DELETE_CUESHEETW, Index, NativeInt(Item));

// Window message���� ó��
{    FCueSheetLock.Enter;
    try
      FCueSheetList.Remove(Item);

      Dispose(Item);
    finally
      FCueSheetLock.Leave;
    end; }

    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECDeleteCueSheetW delete cuesheet, ID=%s', [EventIDToString(AEventID)])));
  end;

  Result := D_OK;
end;

function TfrmChannel.SECClearCueSheetW: Integer;
var
  I: Integer;
begin
  Result := D_FALSE;

  ClearCueSheetList;

  PostMessage(Handle, WM_CLEAR_CUESHEETW, ChannelID, 0);

  if (frmAllChannels <> nil) then
    PostMessage(frmAllChannels.Handle, WM_CLEAR_CUESHEETW, ChannelID, 0);

  Result := D_OK;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'SECClearCueSheetW'));
end;

function TfrmChannel.SECSetCueSheetCurrW(AEventID: TEventID): Integer;
var
  Item: PCueSheetItem;
begin
  Result := D_FALSE;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECSetCueSheetCurrW ID=%s', [EventIDToString(AEventID)])));

  Move(AEventID, FServerEventIDCurr, SizeOf(TEventID));

  Item := GetCueSheetItemByID(AEventID);
//  if (Item <> nil) then
  begin
    CueSheetCurr := Item;

    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECSetCueSheetCurrW set curr cuesheet, curr=%p, ID=%s', [CueSheetCurr, EventIDToString(AEventID)])));
  end;

  Result := D_OK;
end;

function TfrmChannel.SECSetCueSheetNextW(AEventID: TEventID): Integer;
var
  Item: PCueSheetItem;
begin
  Result := D_FALSE;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECSetCueSheetNextW ID=%s', [EventIDToString(AEventID)])));

  Move(AEventID, FServerEventIDNext, SizeOf(TEventID));

  Item := GetCueSheetItemByID(AEventID);
//  if (Item <> nil) then
  begin
    CueSheetNext := Item;

    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECSetCueSheetNextW set next cuesheet, next=%p, ID=%s', [CueSheetNext, EventIDToString(AEventID)])));
  end;

  Result := D_OK;
end;

function TfrmChannel.SECSetCueSheetTargetW(AEventID: TEventID): Integer;
var
  Item: PCueSheetItem;
begin
  Result := D_FALSE;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECSetCueSheetTargetW ID=%s', [EventIDToString(AEventID)])));

  Move(AEventID, FServerEventIDTarget, SizeOf(TEventID));

  Item := GetCueSheetItemByID(AEventID);
//  if (Item <> nil) then
  begin
    CueSheetTarget := Item;

    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECSetCueSheetTargetW set target cuesheet, target=%p, ID=%s', [CueSheetTarget, EventIDToString(AEventID)])));
  end;

  Result := D_OK;
end;

function TfrmChannel.SECInputChannelCueSheetW(ACueSheetFileName: String; AOnairdate: String; AOnairFlag: TOnAirFlagType;
                                              AOnairNo, AEventCount, ALastSerialNo, ALastProgramNo, ALastGroupNo: Integer): Integer;
var
  AddFlag: Boolean;
  ChannelCueSheet: PChannelCueSheet;
begin
  Result := D_FALSE;

  Assert(False, GetChannelLogStr(lsError, ChannelID, 'SECInputChannelCueSheetW start.'));

  if (FChannelCueSheetList = nil) then exit;

  AddFlag := False;

  ChannelCueSheet := GetChannelCueSheetByOnairDate(OnAirDateToDate(AOnairdate));

  if (ChannelCueSheet = nil) then
  begin
    ChannelCueSheet := New(PChannelCueSheet);
    AddFlag := True;
  end;

  with ChannelCueSheet^ do
  begin
    StrPLCopy(FileName, ACueSheetFileName, MAX_PATH);
    ChannelID := FChannelID;
    StrPLCopy(OnairDate, AOnairdate, DATE_LEN);
    OnairFlag := AOnairFlag;
    OnairNo := AOnairNo;
    EventCount := AEventCount;
    LastSerialNo := ALastSerialNo;
    LastProgramNo := ALastProgramNo;
    LastGroupNo := ALastGroupNo;
  end;

  if (AddFlag) then
    FChannelCueSheetList.Add(ChannelCueSheet);

  Result := D_OK;

  Assert(False, GetChannelLogStr(lsError, ChannelID, 'SECInputChannelCueSheetW end.'));

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECInputChannelCueSheetW file = %s', [ACueSheetFileName])));
end;

function TfrmChannel.SECDeleteChannelCueSheetW(AOnairdate: String): Integer;
var
  ChannelCueSheet: PChannelCueSheet;
begin
  Result := D_FALSE;

  if (FChannelCueSheetList = nil) then exit;

  ChannelCueSheet := GetChannelCueSheetByOnairDate(OnAirDateToDate(AOnairdate));

  if (ChannelCueSheet <> nil) then
  begin
    FChannelCueSheetList.Remove(ChannelCueSheet);
  end;

  Result := D_OK;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECDeleteChannelCueSheetW date = %s', [AOnairdate])));
end;

function TfrmChannel.SECClearChannelCueSheetW(AChannelID: Word): Integer;
begin
  Result := D_FALSE;

  Assert(False, GetChannelLogStr(lsError, ChannelID, 'SECClearChannelCueSheetW start.'));

  Result := D_FALSE;

  if (FChannelCueSheetList = nil) then exit;

  ClearChannelCueSheetList;

  Result := D_OK;

  Assert(False, GetChannelLogStr(lsError, ChannelID, 'SECClearChannelCueSheetW End.'));

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECClearChannelCueSheetW', [])));
end;

function TfrmChannel.SECFinishLoadCueSheetW(ACueSheetFileName: String): Integer;
var
  I: Integer;
  FileNameStrLen: Integer;
  FileNameStr: PChar;
begin
  Result := D_FALSE;

  FileNameStrLen := Length(ACueSheetFileName) + 1;
  FileNameStr := StrAlloc(FileNameStrLen);
  StrPLCopy(FileNameStr, ACueSheetFileName, Length(ACueSheetFileName));

  PostMessage(Handle, WM_FINISH_LOAD_CUESHEETW, FileNameStrLen, LParam(FileNameStr));

  Result := D_OK;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECFinishLoadCueSheetW file = %s', [ACueSheetFileName])));
end;

constructor TfrmChannel.Create(AOwner: TComponent; AChannelID: Word; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer);
var
  Channel: PChannel;
begin
  inherited Create(AOwner, ACombine, ALeft, ATop, AWidth, AHeight);

  FChannelID := AChannelId;
  FChannelFrameRateType := GetChannelFrameRateTypeByID(FChannelID);
  FChannelIsDropFrame := GetChannelIsDropFrameByID(FChannelID);

  Channel := GetChannelByID(AChannelID);
  if (Channel <> nil) then
  begin
    // Break current
    FBreakAddTime           := Channel^.BreakAddTime;
    FBreakEventDurationTime := Channel^.BreakEventDurationTime;
    FBreakEventSource       := Channel^.BreakEventSource;
    FBreakEventTitle        := Channel^.BreakEventTitle;
    FBreakEventInput        := Channel^.BreakEventInput;
    FBreakEventOutputBkgnd  := Channel^.BreakEventOutputBkgnd;
    FBreakEventOutputKeyer  := Channel^.BreakEventOutputKeyer;
  end;
end;

procedure TfrmChannel.Initialize;
begin
  FChannelOnAir := False;

  FChannelCueSheetList := TChannelCueSheetList.Create;

  FCueSheetLock := TCriticalSection.Create;
  FCueSheetList := TCueSheetList.Create;

  FLastDisplayNo := 0;

  FLastCount  := 0;

  FLastInputIndex := -1;

  FIsContrctAll  := False;
  FIsCellEditing  := False;
  FIsCellModified := False;

  FOldCellValue := '';
  FOldOutput := 0;

  FErrorDisplayEnabled := True;

  FCueSheetCurr   := nil;
  FCueSheetNext   := nil;
  FCueSheetTarget := nil;

  FCueSheetLoopLastStartTime  := InitEventTime;
  FCueSheetLoopLastDurationTC := 0;

  FCueSheetLoopFirst := nil;
  FCueSheetLoopLast  := nil;

  FCueSheetLoopPrevList := TCueSheetList.Create;
  FCueSheetLoopNextList := TCueSheetList.Create;

  FillChar(FServerEventIDCurr, SizeOf(TEVentID), #0);
  FServerEventIDCurr.ChannelID := ChannelID;

  FillChar(FServerEventIDNext, SizeOf(TEVentID), #0);
  FServerEventIDNext.ChannelID := ChannelID;

  FillChar(FServerEventIDTarget, SizeOf(TEVentID), #0);
  FServerEventIDTarget.ChannelID := ChannelID;

  lblPlayedTime.Caption           := IDLE_TIME;
  lblRemainingTime.Caption        := IDLE_TIME;
  lblNextStart.Caption            := GetIdleTimecodeString(ChannelIsDropFrame);
  lblNextDuration.Caption         := GetIdleTimecodeString(ChannelIsDropFrame);
  lblRemainingTargetTime.Caption  := GetIdleTimecodeString(ChannelIsDropFrame);

  wmibFreezeOnAir.Caption     := 'Freeze';
  wmibAssignNext.Caption      := 'Assign next';
  wmibTakeNext.Caption        := 'Take next';
  wmibIncrease1Second.Caption := '+1';
  wmibDecrease1Second.Caption := '-1';

{  wmtbTimelineZoom.Min := 0;
  wmtbTimelineZoom.Max := Round(SecsPerDay * wmtlPlaylist.TimeZoneProperty.FrameRate) + 1;
  wmtbTimelineZoom.Position := 6;//wmtbTimelineZoom.Max; }
//  FTimeLineZoomPosition := wmtbTimelineZoom.Position;

//  FTimelineSpace := GV_SettingOption.TimelineSpace;

  SetChannelOnAir(FChannelOnAir);

  InitializePlayListGrid;
  InitializePlayListTimeLine;

  FEventContolIntervalTime := 0;
  FEventContolThread := TChannelEventControlThread.Create(Self);
  FEventContolThread.Start;

//  FAutoLoadIntervalTime := 0;
  if (GV_SettingOption.AutoLoadCuesheet) then
  begin
    FAutoLoadThread := TChannelAutoLoadPlayListThread.Create(Self);
    FAutoLoadThread.Start;
  end;

//  FAutoEjectIntervalTime := 0;
  if (GV_SettingOption.AutoEjectCuesheet) then
  begin
    FAutoEjectThread := TChannelAutoEjectPlayListThread.Create(Self);
    FAutoEjectThread.Start;
  end;

//  FMediaCheckIntervalTime := 0;
  FMediaCheckThread := TChannelMediaCheckThread.Create(Self);
  FMediaCheckThread.Start;

  FBlankCheckThread := TChannelBlankCheckThread.Create(Self);
  FBlankCheckThread.Start;

  FInspectThread := TChannelInspectThread.Create(Self);
  FInspectThread.Start;

  FCueSheetCheckThread := TChannelCueSheetCheckThread.Create(Self);
  FCueSheetCheckThread.Start;

  FTimerThread := TChannelTimerThread.Create(Self);
  FTimerThread.Start;
end;

procedure TfrmChannel.Finalize;
begin
  if (FTimerThread <> nil) then
  begin
    FTimerThread.Terminate;
    FTimerThread.WaitFor;
    FreeAndNil(FTimerThread);
  end;

  Assert(False, GetMainLogStr(lsNormal, Format('Succeeded Channel Timer thread destroy. Channel=%d', [ChannelID])));

  if (FCueSheetCheckThread <> nil) then
  begin
    FCueSheetCheckThread.Terminate;
    FCueSheetCheckThread.WaitFor;
    FreeAndNil(FCueSheetCheckThread);
  end;

  Assert(False, GetMainLogStr(lsNormal, Format('Succeeded Channel CuesheetCheck thread destroy. Channel=%d', [ChannelID])));

  if (FInspectThread <> nil) then
  begin
    FInspectThread.Terminate;
    FInspectThread.WaitFor;
    FreeAndNil(FInspectThread);
  end;

  Assert(False, GetMainLogStr(lsNormal, Format('Succeeded Channel Inspect thread destroy. Channel=%d', [ChannelID])));

  if (FBlankCheckThread <> nil) then
  begin
    FBlankCheckThread.Terminate;
    FBlankCheckThread.WaitFor;
    FreeAndNil(FBlankCheckThread);
  end;

  Assert(False, GetMainLogStr(lsNormal, Format('Succeeded Channel BlankCheck thread destroy. Channel=%d', [ChannelID])));

  if (FMediaCheckThread <> nil) then
  begin
    FMediaCheckThread.Terminate;
    FMediaCheckThread.WaitFor;
    FreeAndNil(FMediaCheckThread);
  end;

  Assert(False, GetMainLogStr(lsNormal, Format('Succeeded Channel MediaCheck thread destroy. Channel=%d', [ChannelID])));

  if (FAutoEjectThread <> nil) then
  begin
    FAutoEjectThread.Terminate;
    FAutoEjectThread.WaitFor;
    FreeAndNil(FAutoEjectThread);
  end;

  Assert(False, GetMainLogStr(lsNormal, Format('Succeeded Channel AutoEject thread destroy. Channel=%d', [ChannelID])));

  if (FAutoLoadThread <> nil) then
  begin
    FAutoLoadThread.Terminate;
    FAutoLoadThread.WaitFor;
    FreeAndNil(FAutoLoadThread);
  end;

  Assert(False, GetMainLogStr(lsNormal, Format('Succeeded Channel AutoLoad thread destroy. Channel=%d', [ChannelID])));

  if (FEventContolThread <> nil) then
  begin
    FEventContolThread.Terminate;
    FEventContolThread.WaitFor;
    FreeAndNil(FEventContolThread);
  end;

  Assert(False, GetMainLogStr(lsNormal, Format('Succeeded Channel EventContol thread destroy. Channel=%d', [ChannelID])));

  ClearCueSheetLoopItems;

  ClearCueSheetLoopPrevList;
  FreeAndNil(FCueSheetLoopPrevList);

  ClearCueSheetLoopNextList;
  FreeAndNil(FCueSheetLoopNextList);

  ClearPlayListTimeLine;
  ClearPlayListGrid;
  ClearCueSheetList;
  ClearChannelCueSheetList;

  FreeAndNil(FCueSheetList);
  FreeAndNil(FCueSheetLock);

  FreeAndNil(FChannelCueSheetList);

  Assert(False, GetMainLogStr(lsNormal, Format('Succeeded Channel finalize. Channel=%d', [ChannelID])));

  // If exist hide rows bug
{  with acgPlaylist do
  begin
    acgPlaylist.RowCount := 0;
  end;  }
end;

procedure TfrmChannel.SetPlayListFileName(AValue: String);
begin
  if (FPlayListFileName <> AValue) then
  begin
    FPlayListFileName := AValue;
    lblPlayListFileName.Caption := AValue;
  end;
end;

{function TfrmChannel.GetPositionByZoomType(AZoomType: TTimelineZoomTYpe): Integer;
var
  RatePerFrame: Word;
begin
  Result := 0;

  with wmtlPlaylist.TimeZoneProperty do
  begin
    case AZoomType of
      zt1Second: Result := Round(1 * FrameRate);
      zt2Seconds: Result := Round(2 * FrameRate);
      zt5Seconds: Result := Round(5 * FrameRate);
      zt10Seconds: Result := Round(10 * FrameRate);
      zt15Seconds: Result := Round(15 * FrameRate);
      zt30Seconds: Result := Round(30 * FrameRate);
      zt1Minute: Result := Round(SecsPerMin * FrameRate);
      zt2Minutes: Result := Round(2 * SecsPerMin * FrameRate);
      zt5Minutes: Result := Round(5 * SecsPerMin * FrameRate);
      zt10Minutes: Result := Round(10 * SecsPerMin * FrameRate);
      zt15Minutes: Result := Round(15 * SecsPerMin * FrameRate);
      zt30Minutes: Result := Round(30 * SecsPerMin * FrameRate);
      zt1Hour: Result := Round(SecsPerHour * FrameRate);
      zt2Hours: Result := Round(2 * SecsPerHour * FrameRate);
      zt6Hours: Result := Round(6 * SecsPerHour * FrameRate);
      zt12Hours: Result := Round(12 * SecsPerHour * FrameRate);
      zt1Day: Result := Round(SecsPerDay * FrameRate);
      ztFit: Result := Round(SecsPerDay * FrameRate) + 1;
    end;
  end;
end;

function TfrmChannel.GetZoomTypeByPosition(APosition: Integer): TTimelineZoomType;
begin
  Result := ztNone;
  with wmtlPlaylist.TimeZoneProperty do
  begin
    if (APosition <= Round(1 * FrameRate)) then
      Result := zt1Second
    else if (APosition <= Round(2 * FrameRate)) then
      Result := zt2Seconds
    else if (APosition <= Round(5 * FrameRate)) then
      Result := zt5Seconds
    else if (APosition <= Round(10 * FrameRate)) then
      Result := zt10Seconds
    else if (APosition <= Round(15 * FrameRate)) then
      Result := zt15Seconds
    else if (APosition <= Round(30 * FrameRate)) then
      Result := zt30Seconds
    else if (APosition <= Round(SecsPerMin * FrameRate)) then
      Result := zt1Minute
    else if (APosition <= Round(2 * SecsPerMin * FrameRate)) then
      Result := zt2Minutes
    else if (APosition <= Round(5 * SecsPerMin * FrameRate)) then
      Result := zt5Minutes
    else if (APosition <= Round(10 * SecsPerMin * FrameRate)) then
      Result := zt10Minutes
    else if (APosition <= Round(15 * SecsPerMin * FrameRate)) then
      Result := zt15Minutes
    else if (APosition <= Round(30 * SecsPerMin * FrameRate)) then
      Result := zt30Minutes
    else if (APosition <= Round(SecsPerHour * FrameRate)) then
      Result := zt1Hour
    else if (APosition <= Round(2 * SecsPerHour * FrameRate)) then
      Result := zt2Hours
    else if (APosition <= Round(6 * SecsPerHour * FrameRate)) then
      Result := zt6Hours
    else if (APosition <= Round(12 * SecsPerHour * FrameRate)) then
      Result := zt12Hours
    else if (APosition <= Round(SecsPerDay * FrameRate)) then
      Result := zt1Day
    else if (APosition <= Round(SecsPerDay * FrameRate) + 1) then
      Result := ztFit;
  end;
end;

procedure TfrmChannel.UpdateZoomPosition(APosition: Integer);
var
  SampleTime: Double;
  Frames: Integer;
begin
  if (FTimelineZoomType = ztFit) then
  begin
    wmtlPlaylist.ZoomToFit;
  end
  else
  begin
    with wmtlPlaylist.TimeZoneProperty do
    begin
      BeginUpdate;
      try
//      SampleTime := FrameToSampleTime(APosition, Round(FrameRate));
//      SampleTime := Round(APosition / FrameRate);

        SampleTime := Round(APosition / FrameRate);
        if (SampleTime < 1) then SampleTime := 1;

        Frames := TimecodeToFrame(SecondToTimeCode(SampleTime, GV_SettingOption.TimelineFrameRateType), GV_SettingOption.TimelineFrameRateType);

        if (SampleTime >= 1) and (SampleTime < 15) then
        begin
          FrameGap := 12;
          FrameStep := 10;
          FrameSkip := Frames div 2;
        end
        else if (SampleTime >= 15) and (SampleTime < SecsPerMin) then
        begin
          FrameGap := 6;
          FrameStep := 20;
          FrameSkip := Frames div 5;
        end
        else if (SampleTime >= SecsPerMin) and (SampleTime < SecsPerMin * 15) then
        begin
          FrameGap := 24;
          FrameStep := 5;
          FrameSkip := Frames;
        end
        else if (SampleTime >= SecsPerMin * 15) and (SampleTime < SecsPerMin * 30) then
        begin
          FrameGap := 12;
          FrameStep := 12;
          FrameSkip := Frames div 3;
        end
        else if (SampleTime >= SecsPerMin * 30) and (SampleTime < SecsPerHour) then
        begin
          FrameGap := 8;
          FrameStep := 36;
          FrameSkip := Frames div 6;
        end
        else if (SampleTime >= SecsPerHour) then
        begin
          FrameGap := 4;
          FrameStep := 36;
          FrameSkip := Frames div 6;
        end;

//        if (ChannelOnAir) then
//          RealtimeChangePlayListTimeLine;
      finally
        EndUpdate;
      end;
  //    WMTimeLine.ViewSplitter;
  //    WMTimeLine.ViewAreaRepaint;
    end;
  end;
end;

procedure TfrmChannel.SetZoomPosition(AValue: Integer);
var
  Pos: Integer;
begin
//  if (FZoomPosition <> AValue) then
  begin
    FTimelineZoomPosition := AValue;
//    wmtlPlaylist.ZoomBarProperty.Position := AValue;
    wmtbTimelineZoom.Position := AValue;

    FTimelineZoomType := GetZoomTypeByPosition(AValue);
    UpdateZoomPosition(AValue);
  end;
end; }

procedure TfrmChannel.SetCueSheetCurr(AValue: PCueSheetItem);
var
  Index: Integer;
begin
  if (FCueSheetCurr <> AValue) then
  begin
    FCueSheetLock.Enter;
    try
      FCueSheetCurr := AValue;
    finally
      FCueSheetLock.Leave;
    end;

    if (AValue <> nil) then
    begin
      Index := GetCueSheetIndexByItem(AValue);

      PostMessage(Handle, WM_UPDATE_CURR_EVENT, Index, NativeInt(FCueSheetCurr));

      ServerSetCueSheetCurrs(AValue^.EventID);
    end
    else
      ServerSetCueSheetCurrs(GetChannelNullEventID);

    if (FCueSheetCurr = CueSheetTarget) then
      CueSheetTarget := nil;
  end;
end;

procedure TfrmChannel.SetCueSheetNext(AValue: PCueSheetItem);
var
  Index: Integer;
  NullEventID: TEventID;
begin
  if (FCueSheetNext <> AValue) then
  begin
    FCueSheetLock.Enter;
    try
      FCueSheetNext := AValue;
    finally
      FCueSheetLock.Leave;
    end;

    if (AValue <> nil) then
    begin
      Index := GetCueSheetIndexByItem(AValue);

      PostMessage(Handle, WM_UPDATE_NEXT_EVENT, Index, NativeInt(FCueSheetNext));

      ServerSetCueSheetNexts(AValue^.EventID);
    end
    else
      ServerSetCueSheetNexts(GetChannelNullEventID);
  end;
end;

procedure TfrmChannel.SetCueSheetTarget(AValue: PCueSheetItem);
var
  Index: Integer;
  NullEventID: TEventID;
begin
  if (FCueSheetTarget <> AValue) then
  begin
    FCueSheetLock.Enter;
    try
      FCueSheetTarget := AValue;
    finally
      FCueSheetLock.Leave;
    end;

    if (AValue <> nil) then
    begin
      Index := GetCueSheetIndexByItem(AValue);

      PostMessage(Handle, WM_UPDATE_TARGET_EVENT, Index, NativeInt(FCueSheetTarget));

      ServerSetCueSheetTargets(AValue^.EventID);
    end
    else
      ServerSetCueSheetTargets(GetChannelNullEventID);
  end;
end;

function TfrmChannel.GetChannelNullEventID: TEventID;
begin
  FillChar(Result, SizeOf(TEVentID), #0);
  Result.ChannelID := ChannelID;
end;

function TfrmChannel.GetChannelCueSheetByIndex(AIndex: Integer): PChannelCueSheet;
var
  I: Integer;
  ChannelCueSheet: PChannelCueSheet;
  EventCount: Integer;
begin
  Result := nil;

  if (FChannelCueSheetList = nil) then exit;

  EventCount := 0;
  for I := 0 to FChannelCueSheetList.Count - 1 do
  begin
    ChannelCueSheet := FChannelCueSheetList[I];
    Inc(EventCount, ChannelCueSheet.EventCount);

    if (AIndex < EventCount) then
    begin
      Result := ChannelCueSheet;
      break;
    end;
  end;
end;

function TfrmChannel.GetChannelCueSheetByItem(AItem: PCueSheetItem): PChannelCueSheet;
var
  I: Integer;
  Index: Integer;
  ChannelCueSheet: PChannelCueSheet;
  EventCount: Integer;
begin
  Result := nil;

  if (FChannelCueSheetList = nil) then exit;

  Index := GetCueSheetIndexByItem(AItem);
  if (Index < 0) then exit;

  EventCount := 0;
  for I := 0 to FChannelCueSheetList.Count - 1 do
  begin
    ChannelCueSheet := FChannelCueSheetList[I];
    Inc(EventCount, ChannelCueSheet.EventCount);

    if (Index < EventCount) then
    begin
      Result := ChannelCueSheet;
      break;
    end;
  end;
end;

function TfrmChannel.GetChannelCueSheetByOnairDate(ADate: TDate): PChannelCueSheet;
var
  I: Integer;
  ChannelCueSheet: PChannelCueSheet;
begin
  Result := nil;

  if (FChannelCueSheetList = nil) then exit;

  for I := 0 to FChannelCueSheetList.Count - 1 do
  begin
    ChannelCueSheet := FChannelCueSheetList[I];

    if (ChannelCueSheet^.ChannelID = FChannelID) and
       (OnAirDateToDate(ChannelCueSheet^.OnairDate) = ADate) then
    begin
      Result := ChannelCueSheet;
      break;
    end;
  end;
end;

function TfrmChannel.GetChannelCueSheetByDuplicate(ADate: TDate; AOnairFlag: TOnAirFlagType; AOnairNo: Integer): PChannelCueSheet;
var
  I: Integer;
  ChannelCueSheet: PChannelCueSheet;
begin
  Result := nil;

  if (FChannelCueSheetList = nil) then exit;

  for I := 0 to FChannelCueSheetList.Count - 1 do
  begin
    ChannelCueSheet := FChannelCueSheetList[I];

    if (ChannelCueSheet^.ChannelID = FChannelID) and
       (OnAirDateToDate(ChannelCueSheet^.OnairDate) = ADate) and
       (ChannelCueSheet^.OnAirFlag = AOnairFlag) and
       (ChannelCueSheet^.OnairNo = AOnairNo) then
    begin
      Result := ChannelCueSheet;
      break;
    end;
  end;
end;

// ä�� ť��Ʈ�� ���� �ε��� ����
function TfrmChannel.GetChannelCueSheetStartIndex(AChannelCueSheet: PChannelCueSheet): Integer;
var
  I: Integer;
  ChannelCueSheet: PChannelCueSheet;
  EventCount: Integer;
begin
  Result := -1;

  if (FChannelCueSheetList = nil) then exit;

  Result := 0;
  for I := 0 to FChannelCueSheetList.Count - 1 do
  begin
    ChannelCueSheet := FChannelCueSheetList[I];
    if (ChannelCueSheet = AChannelCueSheet) then break;

    Inc(Result, ChannelCueSheet.EventCount);
  end;
end;

function TfrmChannel.GetBeforeChannelCueSheetByOnairDate(ADate: TDate): PChannelCueSheet;
var
  I: Integer;
  ChannelCueSheet: PChannelCueSheet;
begin
  Result := nil;

  if (FChannelCueSheetList = nil) then exit;

  for I := FChannelCueSheetList.Count - 1 downto 0 do
  begin
    ChannelCueSheet := FChannelCueSheetList[I];

    if (ChannelCueSheet^.ChannelID = FChannelID) and
       (OnAirDateToDate(ChannelCueSheet^.OnairDate) < ADate) then
    begin
      Result := ChannelCueSheet;
      break;
    end;
  end;
end;

function TfrmChannel.GetNextChannelCueSheetByOnairDate(ADate: TDate): PChannelCueSheet;
var
  I: Integer;
  ChannelCueSheet: PChannelCueSheet;
begin
  Result := nil;

  if (FChannelCueSheetList = nil) then exit;

  for I := 0 to FChannelCueSheetList.Count - 1 do
  begin
    ChannelCueSheet := FChannelCueSheetList[I];

    if (ChannelCueSheet^.ChannelID = FChannelID) and
       (OnAirDateToDate(ChannelCueSheet^.OnairDate) > ADate) then
    begin
      Result := ChannelCueSheet;
      break;
    end;
  end;
end;

function TfrmChannel.GetCueSheetItemByIndex(AIndex: Integer): PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  FCueSheetLock.Enter;
  try
    Result := FCueSheetList[AIndex];
  finally
    FCueSheetLock.Leave;
  end;
end;

function TfrmChannel.GetCueSheetItemByID(AEventID: TEventID): PCueSheetItem;
var
  I, CurrIndex: Integer;
  CurrItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;

  for I := 0 to FCueSheetList.Count - 1 do
  begin
    CurrItem := GetCueSheetItemByIndex(I);
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

function TfrmChannel.GetCueSheetIndexByItem(AItem: PCueSheetItem): Integer;
begin
  Result := -1;

  if (FCueSheetList = nil) then exit;

  FCueSheetLock.Enter;
  try
    Result := FCueSheetList.IndexOf(AItem);
  finally
    FCueSheetLock.Leave;
  end;
end;

function TfrmChannel.GetSelectCueSheetItem: PCueSheetItem;
var
  R: Integer;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;

  with acgPlaylist do
  begin
    R := RealRowIndex(Row);
    Result := GetCueSheetItemByIndex(R - CNT_CUESHEET_HEADER);
  end;
end;

function TfrmChannel.GetSelectCueSheetIndex: Integer;
begin
  Result := -1;

  if (FCueSheetList = nil) then exit;

  with acgPlaylist do
  begin
    Result := RealRowIndex(Row) - CNT_CUESHEET_HEADER;
  end;

  if (Result >= FCueSheetList.Count) then
    Result := -1;
end;

function TfrmChannel.GetParentCueSheetItemByIndex(AIndex: Integer): PCueSheetItem;
var
  I, CurrIndex: Integer;
  CurrItem, ParentItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  CurrItem := GetCueSheetItemByIndex(AIndex);

  if (CurrItem <> nil) then
  begin
    for I := AIndex downto 0 do
    begin
      ParentItem := GetCueSheetItemByIndex(I);
      if (ParentItem <> nil) then
      begin
        if (ParentItem^.GroupNo = CurrItem^.GroupNo) and (ParentItem^.EventMode = EM_MAIN) then
        begin
          Result := ParentItem;
          break;
        end;
      end;
    end;
  end;
end;

function TfrmChannel.GetParentCueSheetItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I, CurrIndex: Integer;
  ParentItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  CurrIndex := GetCueSheetIndexByItem(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex downto 0 do
  begin
    ParentItem := GetCueSheetItemByIndex(I);
    if (ParentItem <> nil) then
    begin
      if (ParentItem^.EventMode = EM_COMMENT) then continue;

      if (ParentItem^.GroupNo = AItem^.GroupNo) and (ParentItem^.EventMode = EM_MAIN) then
      begin
        Result := ParentItem;
        break;
      end;
//      else if (P^.GroupNo > C^.GroupNo) then break;
    end;
  end;
end;

function TfrmChannel.GetChildCountByItem(AItem: PCueSheetItem): Integer;
var
  I, CurrIndex: Integer;
  Item: PCueSheetItem;
begin
  Result := 0;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;
  if (AItem^.EventMode <> EM_MAIN) then exit;

  CurrIndex := GetCueSheetIndexByItem(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex + 1 to FCueSheetList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(I);
    if (Item <> nil) then
    begin
      if (Item^.GroupNo = AItem^.GroupNo) then
      begin
        Inc(Result);
      end
      else
        break;
    end;
  end;
end;

function TfrmChannel.GetChildCueSheetIndexByItem(AItem: PCueSheetItem; AIncludeComment: Boolean): Integer;
var
  I: Integer;
  ParentItem: PCueSheetItem;
  ParentIndex: Integer;
  CurrItem: PCueSheetItem;
  CurrIndex: Integer;
begin
  Result := -1;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;
  if (not AIncludeComment) and (AItem^.EventMode = EM_COMMENT) then exit;

  if (AItem^.EventMode = EM_MAIN) then
  begin
    Result := 0;
    exit;
  end;

  ParentItem  := GetParentCueSheetItemByItem(AItem);
  if (ParentItem <> nil) then
  begin
    ParentIndex := GetCueSheetIndexByItem(ParentItem);
    CurrIndex := GetCueSheetIndexByItem(AItem);

    if (AIncludeComment) then
      Result := CurrIndex - ParentIndex
    else
    begin
      Result := 0;

      for I := ParentIndex + 1 to CurrIndex do
      begin
//        ShowMessage(IntToStr(ParentIndex));
//        ShowMessage(IntToStr(I));
        CurrItem := GetCueSheetItemByIndex(I);
        if (CurrItem <> nil) then
        begin
          if (CurrItem^.GroupNo = ParentItem^.GroupNo) then
          begin
            if (CurrItem^.EventMode <> EM_COMMENT) then
              Inc(Result);
          end
          else
            break;
        end;
      end;
    end;
  end;
end;

function TfrmChannel.GetLastChildCueSheetItemByIndex(AIndex: Integer): PCueSheetItem;
var
  I: Integer;
  PItem, CItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  PItem := GetCueSheetItemByIndex(AIndex);
  if (PItem <> nil) then
  begin
    if (AIndex >= FCueSheetList.Count - 1) then
    begin
      Result := PItem;
      exit;
    end;

    for I := AIndex + 1 to FCueSheetList.Count - 1 do
    begin
      CItem := GetCueSheetItemByIndex(I);
      if (CItem <> nil) then
      begin
        if (CItem^.EventMode = EM_COMMENT) then continue;

        if (CItem^.GroupNo <> PItem^.GroupNo) then
        begin
          if (I > 0) then
          begin
            Result := GetCueSheetItemByIndex(I - 1);
          end;
          break;
        end;
      end;
    end;
  end;
end;

function TfrmChannel.GetLastChildCueSheetItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I, CurrIndex: Integer;
  CItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  CurrIndex := GetCueSheetIndexByItem(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex + 1 to FCueSheetList.Count - 1 do
  begin
    CItem := GetCueSheetItemByIndex(I);
    if (CItem <> nil) then
    begin
      if (CItem^.EventMode = EM_COMMENT) then continue;

      if (CItem^.GroupNo <> AItem^.GroupNo) then
      begin
        if (I > 0) then
        begin
          Result := GetCueSheetItemByIndex(I - 1);
        end;
        break;
      end;
    end;
  end;
end;

function TfrmChannel.GetFirstMainItem: PCueSheetItem;
var
  I: Integer;
  PItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;

  for I := 0 to FCueSheetList.Count - 1 do
  begin
    PItem := GetCueSheetItemByIndex(I);
    if (PItem <> nil) then
    begin
      if (PItem^.EventMode = EM_MAIN) and (PItem^.EventStatus.State <> esSkipped) then
      begin
        Result := PItem;
        break;
      end;
    end;
  end;
end;

function TfrmChannel.GetFirstMainIndex: Integer;
var
  I: Integer;
  PItem: PCueSheetItem;
begin
  Result := -1;

  if (FCueSheetList = nil) then exit;

  for I := 0 to FCueSheetList.Count - 1 do
  begin
    PItem := GetCueSheetItemByIndex(I);
    if (PItem <> nil) then
    begin
      if (PItem^.EventMode = EM_MAIN) and (PItem^.EventStatus.State <> esSkipped) then
      begin
        Result := I;
        break;
      end;
    end;
  end;
end;

function TfrmChannel.GetLastMainItem: PCueSheetItem;
var
  I: Integer;
  PItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;

  for I := FCueSheetList.Count - 1 downto 0 do
  begin
    PItem := GetCueSheetItemByIndex(I);
    if (PItem <> nil) then
    begin
      if (PItem^.EventMode = EM_MAIN) then
      begin
        Result := PItem;
        break;
      end;
    end;
  end;
end;

function TfrmChannel.GetLastMainIndex: Integer;
var
  I: Integer;
  PItem: PCueSheetItem;
begin
  Result := -1;

  if (FCueSheetList = nil) then exit;

  for I := FCueSheetList.Count - 1 downto 0 do
  begin
    PItem := GetCueSheetItemByIndex(I);
    if (PItem <> nil) then
    begin
      if (PItem^.EventMode = EM_MAIN) then
      begin
        Result := I;
        break;
      end;
    end;
  end;
end;

function TfrmChannel.GetBeforeMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I, CurrIndex: Integer;
  PItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  CurrIndex := GetCueSheetIndexByItem(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex - 1 downto 0 do
  begin
    PItem := GetCueSheetItemByIndex(I);
    if (PItem <> nil) then
    begin
      if (PItem^.EventMode = EM_MAIN) and (PItem^.EventStatus.State <> esSkipped) then
      begin
        Result := PItem;
        break;
      end;
    end;
  end;
end;

function TfrmChannel.GetBeforeMainItemByIndex(AIndex: Integer): PCueSheetItem;
var
  I: Integer;
  PItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  for I := AIndex - 1 downto 0 do
  begin
    PItem := GetCueSheetItemByIndex(I);
    if (PItem <> nil) then
    begin
      if (PItem^.EventMode = EM_MAIN) and (PItem^.EventStatus.State <> esSkipped) then
      begin
        Result := PItem;
        break;
      end;
    end;
  end;
end;

function TfrmChannel.GetNextMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I, CurrIndex: Integer;
  PItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;

  if (AItem = nil) then CurrIndex := 0
  else
  begin
    CurrIndex := GetCueSheetIndexByItem(AItem);
    if (CurrIndex < 0) then exit;
  end;

  for I := CurrIndex + 1 to FCueSheetList.Count - 1 do
  begin
    PItem := GetCueSheetItemByIndex(I);
    if (PItem^.EventMode = EM_MAIN) and (PItem^.EventStatus.State <> esSkipped) then
    begin
      Result := PItem;
      break;
    end;
  end;
end;

function TfrmChannel.GetNextMainItemByIndex(AIndex: Integer): PCueSheetItem;
var
  I: Integer;
  PItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  for I := AIndex + 1 to FCueSheetList.Count - 1 do
  begin
    PItem := GetCueSheetItemByIndex(I);
    if (PItem <> nil) then
    begin
      if (PItem^.EventMode = EM_MAIN) and (PItem^.EventStatus.State <> esSkipped) then
      begin
        Result := PItem;
        break;
      end;
    end;
  end;
end;

function TfrmChannel.GetNextMainIndexByItem(AItem: PCueSheetItem): Integer;
var
  PItem: PCueSheetItem;
begin
  Result := -1;

  PItem := GetNextMainItemByItem(AItem);
  if (PItem = nil) then exit;

  Result := GetCueSheetIndexByItem(PItem);
end;

function TfrmChannel.GetNextMainIndexByIndex(AIndex: Integer): Integer;
var
  PItem: PCueSheetItem;
begin
  Result := -1;

  PItem := GetNextMainItemByIndex(AIndex);
  if (PItem = nil) then exit;

  Result := GetCueSheetIndexByItem(PItem);
end;

function TfrmChannel.GetNextLoadedMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I, CurrIndex: Integer;
  PItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  CurrIndex := GetCueSheetIndexByItem(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex + 1 to FCueSheetList.Count - 1 do
  begin
    PItem := GetCueSheetItemByIndex(I);
    if (PItem <> nil) then
    begin
      if (PItem^.EventMode = EM_MAIN) and (PItem^.EventStatus.State = esLoaded) then
      begin
        Result := PItem;
        break;
      end;
    end;
  end;
end;

function TfrmChannel.GetBeforeMainCountByItem(AItem: PCueSheetItem): Integer;
var
  I: Integer;
  Index: Integer;
  CItem: PCueSheetItem;
begin
  Result := 0;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  Index := GetCueSheetIndexByItem(AItem);
  Dec(Index);
  for I := Index downto 0 do
  begin
    CItem := GetCueSheetItemByIndex(I);
    if (CItem <> nil) then
    begin
      if (CItem^.EventMode = EM_MAIN) then
      begin
        Inc(Result);
      end;
    end;
  end;
end;

function TfrmChannel.GetBeforeMainCountByIndex(AIndex: Integer): Integer;
var
  I: Integer;
  CItem: PCueSheetItem;
begin
  Result := 0;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  Dec(AIndex);
  for I := AIndex downto 0 do
  begin
    CItem := GetCueSheetItemByIndex(I);
    if (CItem <> nil) then
    begin
      if (CItem^.EventMode = EM_MAIN) then
      begin
        Inc(Result);
      end;
    end;
  end;
end;

function TfrmChannel.GetMainItemByInRangeTime(AIndex: Integer; ADateTime: TDateTime): PCueSheetItem;
var
  I: Integer;
  Item: PCueSheetItem;
  StartTime, EndTime: TDateTime;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  for I := AIndex to FCueSheetList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(I);
    if (Item <> nil) and (Item^.EventMode = EM_MAIN) and (Item^.EventStatus.State <> esSkipped) then
    begin
      StartTime := EventTimeToDateTime(Item^.StartTime, ChannelFrameRateType);
      EndTime   := EventTimeToDateTime(GetEventEndTime(Item^.StartTime, Item^.DurationTC, ChannelFrameRateType), ChannelFrameRateType);
      if (CompareDateTime(ADateTime, StartTime) >= 0) and (CompareDateTime(ADateTime, EndTime) < 0) then
      begin
        Result := Item;
        break;
      end;
    end;
  end;
end;

function TfrmChannel.GetMainItemByStartTime(AIndex: Integer; ADateTime: TDateTime): PCueSheetItem;
var
  I: Integer;
  PItem: PCueSheetItem;
  StartTime: TDateTime;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  for I := AIndex to FCueSheetList.Count - 1 do
  begin
    PItem := GetCueSheetItemByIndex(I);
    if (PItem <> nil) and (PItem^.EventMode = EM_MAIN) and (PItem^.EventStatus.State <> esSkipped) then
    begin
      StartTime := EventTimeToDateTime(PItem^.StartTime, ChannelFrameRateType);
      if (CompareDateTime(StartTime, ADateTime) >= 0) then
      begin
        Result := PItem;
        break;
      end;
    end;
  end;
end;

function TfrmChannel.GetProgramItemByIndex(AIndex: Integer): PCueSheetItem;
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

function TfrmChannel.GetProgramItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I, ProgIndex: Integer;
  ProgItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  ProgIndex := GetCueSheetIndexByItem(AItem);
  if (ProgIndex < 0) then exit;

  for I := ProgIndex downto 0 do
  begin
    ProgItem := GetCueSheetItemByIndex(I);
    if (ProgItem <> nil) and (ProgItem^.ProgramNo = AItem^.ProgramNo) then
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

function TfrmChannel.GetProgramMainItemByIndex(AIndex: Integer): PCueSheetItem;
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
      Item := GetCueSheetItemByIndex(I);
      if (Item <> nil) and (Item^.ProgramNo = PItem^.ProgramNo) then
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

function TfrmChannel.GetProgramMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I, CurrIndex: Integer;
  Item: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  CurrIndex := GetCueSheetIndexByItem(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex + 1 to FCueSheetList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(I);
    if (Item <> nil) and (Item^.ProgramNo = AItem^.ProgramNo) then
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

// Program�� Main �̺�Ʈ ������ ����
function TfrmChannel.GetProgramChildCountByItem(AItem: PCueSheetItem): Integer;
var
  I, CurrIndex: Integer;
  Item: PCueSheetItem;
begin
  Result := 0;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;
  if (AItem^.EventMode <> EM_PROGRAM) then exit;

  CurrIndex := GetCueSheetIndexByItem(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex + 1 to FCueSheetList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(I);
    if (Item <> nil) and (Item^.ProgramNo = AItem^.ProgramNo) then
    begin
      Inc(Result);
    end
    else
      break;
  end;
end;

function TfrmChannel.GetProgramDurationByItem(AItem: PCueSheetItem): TTimecode;
var
  I, CurrIndex: Integer;
  Item: PCueSheetItem;
begin
  Result := 0;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  if (AItem^.EventMode <> EM_PROGRAM) then exit;

  CurrIndex := GetCueSheetIndexByItem(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex + 1 to FCueSheetList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(I);
    if (Item <> nil) and (Item^.ProgramNo = AItem^.ProgramNo) then
    begin
      if (Item^.EventMode = EM_MAIN) then
      begin
        Result := GetPlusTimecode(Result, Item^.DurationTC, ChannelFrameRateType);
      end;
    end
    else
      break;
  end;
end;

function TfrmChannel.GetLastProgramMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I, CurrIndex: Integer;
  Item: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;
  if (AItem^.EventMode <> EM_PROGRAM) then exit;

  CurrIndex := GetCueSheetIndexByItem(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex + 1 to FCueSheetList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(I);
    if (Item <> nil) and (Item^.ProgramNo = AItem^.ProgramNo) then
    begin
      if (Item^.EventMode = EM_MAIN) then
        Result := Item;
    end
    else
      break;
  end;
end;

function TfrmChannel.GetLastProgramItem: PCueSheetItem;
var
  I: Integer;
  PItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;

  for I := FCueSheetList.Count - 1 downto 0 do
  begin
    PItem := GetCueSheetItemByIndex(I);
    if (PItem <> nil) and (PItem^.EventMode = EM_PROGRAM) then
    begin
      Result := PItem;
      break;
    end;
  end;
end;

function TfrmChannel.GetLastProgramIndex: Integer;
var
  I: Integer;
  PItem: PCueSheetItem;
begin
  Result := -1;

  if (FCueSheetList = nil) then exit;

  for I := FCueSheetList.Count - 1 downto 0 do
  begin
    PItem := GetCueSheetItemByIndex(I);
    if (PItem <> nil) and (PItem^.EventMode = EM_PROGRAM) then
    begin
      Result := I;
      break;
    end;
  end;
end;

function TfrmChannel.GetBeforeProgramItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I, CurrIndex: Integer;
  PItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AItem = nil) then exit;

  CurrIndex := GetCueSheetIndexByItem(AItem);
  if (CurrIndex < 0) then exit;

  for I := CurrIndex - 1 downto 0 do
  begin
    PItem := GetCueSheetItemByIndex(I);
    if (PItem <> nil) and (PItem^.EventMode = EM_PROGRAM) and (PItem^.EventStatus.State <> esSkipped) then
    begin
      Result := PItem;
      break;
    end;
  end;
end;

function TfrmChannel.GetBeforeProgramItemByIndex(AIndex: Integer): PCueSheetItem;
var
  I: Integer;
  PItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  for I := AIndex - 1 downto 0 do
  begin
    PItem := GetCueSheetItemByIndex(I);
    if (PItem <> nil) and (PItem^.EventMode = EM_PROGRAM) and (PItem^.EventStatus.State <> esSkipped) then
    begin
      Result := PItem;
      break;
    end;
  end;
end;

// ť��Ʈ �� DCS�� Input���� ���� ù��° ���� �̺�Ʈ �ε����� ����
function TfrmChannel.GetStartOnAirMainIndex: Integer;
var
  I, StartIndex, LoopStartIndex: Integer;
  CItem: PCueSheetItem;
begin
  Result := -1;

  if (FCueSheetList = nil) then exit;

{  if (FCueSheetNext <> nil) then
  begin
    Result := GetCueSheetIndexByItem(FCueSheetNext);
    exit;
  end;

  for I := 0 to FCueSheetList.Count - 1 do
  begin
    CItem := GetCueSheetItemByIndex(I);
    if (CItem^.EventMode = EM_MAIN) and
       (CItem^.EventStatus.State in [esIdle, esLoaded]) then
    begin
      Result := I;
      break;
    end;
  end; }


  if (CueSheetNext <> nil) then
    StartIndex := GetCueSheetIndexByItem(CueSheetNext)
  else if (CueSheetCurr <> nil) then
    StartIndex := GetNextMainIndexByItem(CueSheetCurr)
  else
    StartIndex := 0;

  if (StartIndex > 0) and (CueSheetLoopFirst <> nil) then
  begin
    LoopStartIndex := GetCueSheetIndexByItem(CueSheetLoopFirst);
    if (LoopStartIndex < StartIndex) then
       StartIndex := LoopStartIndex;
  end;

  for I := StartIndex to FCueSheetList.Count - 1 do
  begin
    CItem := GetCueSheetItemByIndex(I);
    if (CItem <> nil) and (CItem <> CueSheetCurr) and
       (CItem^.EventMode = EM_MAIN) and
       (CItem^.EventStatus.State <> esSkipped) {and (CItem^.EventStatus.State <> esError) }and
       (CItem^.EventStatus.State <= esCued) then
    begin
      Result := I;
      break;
    end;
  end;
end;

// ť��Ʈ �� DCS�� Input���� ���� ù��° ���� �̺�Ʈ�� ����
function TfrmChannel.GetStartOnAirMainItem: PCueSheetItem;
var
  I: Integer;
  CItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;

  for I := 0 to FCueSheetList.Count - 1 do
  begin
    CItem := GetCueSheetItemByIndex(I);
    if (CItem <> nil) and
       (CItem^.EventMode = EM_MAIN) and
       (CItem^.EventStatus.State <> esSkipped) and (CItem^.EventStatus.State <> esError) and
       (CItem^.EventStatus.State <= esCued) then
    begin
      Result := CItem;
      break;
    end;
  end;
end;

// ť��Ʈ �� DCS�� ���� Input�� ���� �̺�Ʈ�� ����
function TfrmChannel.GetNextOnAirMainIndexByItem(AItem: PCueSheetItem): Integer;
var
  I: Integer;
  Index: Integer;
  CItem: PCueSheetItem;
begin
  Result := -1;

  if (FCueSheetList = nil) then exit;

  if (AItem = nil) then Index := 0
  else
  begin
    Index := GetNextMainIndexByItem(AItem);
    if (Index < 0) then exit;
  end;

  for I := Index to FCueSheetList.Count - 1 do
  begin
    CItem := GetCueSheetItemByIndex(I);
    if (CItem <> nil) and
       (CItem^.EventMode = EM_MAIN) and (CItem^.EventStatus.State in [esIdle]) then
    begin
      Result := I;
      break;
    end;
  end;
end;

// ť��Ʈ �� DCS�� ���� Input�� ���� �̺�Ʈ�� ����
function TfrmChannel.GetNextOnAirMainItemByItem(AItem: PCueSheetItem): PCueSheetItem;
var
  I: Integer;
  Index: Integer;
  CItem: PCueSheetItem;
begin
  Result := nil;

  if (FCueSheetList = nil) then exit;

  if (AItem = nil) then Index := 0
  else
  begin
    Index := GetNextMainIndexByItem(AItem);
    if (Index < 0) then exit;
  end;

  for I := Index to FCueSheetList.Count - 1 do
  begin
    CItem := GetCueSheetItemByIndex(I);
    if (CItem <> nil) and
       (CItem^.EventMode = EM_MAIN) and (CItem^.EventStatus.State in [esIdle]) then
    begin
      Result := CItem;
      break;
    end;
  end;
end;

// ���õ� �̺�Ʈ�� ���� ��� �� ������ ����
function TfrmChannel.GetDeleteCueSheetList(ADeleteList: TCueSheetList): Integer;
var
  I, J: Integer;
  Index: Integer;
  SelectItem, Item: PCueSheetItem;
  SortSelectedRows: TList<Integer>;
begin
  Result := 0;

  if (ADeleteList = nil) then exit;

  with acgPlaylist do
  begin
    if (SelectedRowCount <= 0) then exit;

    SortSelectedRows := TList<Integer>.Create;
    try
      for I := 0 to SelectedRowCount - 1 do
        SortSelectedRows.Add(SelectedRow[I]);

      SortSelectedRows.Sort;
      
      ADeleteList.Clear;
      for I := 0 to SelectedRowCount - 1 do
      begin
        Index := RealRowIndex(SortSelectedRows[I]) - CNT_CUESHEET_HEADER;
        SelectItem := GetCueSheetItemByIndex(Index);
        if (SelectItem <> nil) then
        begin
          case SelectItem^.EventMode of
            EM_PROGRAM:
            begin
              // ���ӵ� �̺�Ʈ ����
              if (ADeleteList.IndexOf(SelectItem) < 0) then
                ADeleteList.Add(SelectItem);

              for J := Index + 1 to FCueSheetList.Count - 1 do
              begin
                Item := GetCueSheetItemByIndex(J);
                if (Item <> nil) and (SelectItem^.ProgramNo = Item^.ProgramNo) and (ADeleteList.IndexOf(Item) < 0) then
                begin
                  ADeleteList.Add(Item);
                end
                else
                  break;
              end;
            end;
            EM_MAIN:
            begin
              // Cue or onair evnet not include
              if (SelectItem^.EventStatus.State in [esCueing..esFinished]) then Continue;

              // ���ӵ� �̺�Ʈ ����
              if (ADeleteList.IndexOf(SelectItem) < 0) then
                ADeleteList.Add(SelectItem);

              for J := Index + 1 to FCueSheetList.Count - 1 do
              begin
                Item := GetCueSheetItemByIndex(J);
                if (Item <> nil) and (SelectItem^.GroupNo = Item^.GroupNo) and (ADeleteList.IndexOf(Item) < 0) then
                begin
                  ADeleteList.Add(Item);
                end
                else
                  break;
              end;
            end;
            EM_JOIN,
            EM_SUB,
            EM_COMMENT:
            begin
              // Cue or onair parent evnet not include
              Item := GetParentCueSheetItemByItem(SelectItem);
              if (Item <> nil) and (Item^.EventStatus.State in [esCueing..esFinished]) then Continue;

              // �ڽ��� �̺�Ʈ�� ����
              if (ADeleteList.IndexOf(SelectItem) < 0) then
                ADeleteList.Add(SelectItem);
            end;
          end;
        end;
      end;
    finally
      FreeAndNil(SortSelectedRows);
    end;
  end;

  Result := ADeleteList.Count;
end;

function TfrmChannel.GetClipboardCueSheetList(AClipboardCueSheet: TClipboardCueSheet; APasteMode: TPasteMode): Integer;
var
  I, J: Integer;
  Index: Integer;
  SelectItem, Item: PCueSheetItem;
  SortSelectedRows: TList<Integer>;
begin
  Result := 0;

  if (AClipboardCueSheet = nil) then exit;

  with acgPlaylist do
  begin
    if (SelectedRowCount <= 0) then exit;

    AClipboardCueSheet.Clear;
    AClipboardCueSheet.PasteMode := APasteMode;
    AClipboardCueSheet.ChannelID := FChannelID;
    AClipboardCueSheet.PasteIncluded := [];

    SortSelectedRows := TList<Integer>.Create;
    try
      for I := 0 to SelectedRowCount - 1 do
        SortSelectedRows.Add(SelectedRow[I]);

      SortSelectedRows.Sort;
                          
      // ���α׷� �̺�Ʈ�� ���ԵǾ� �ִ��� �˻�
      for I := 0 to SelectedRowCount - 1 do
      begin
        Index := RealRowIndex(SortSelectedRows[I]) - CNT_CUESHEET_HEADER;
        SelectItem := GetCueSheetItemByIndex(Index);
        if (SelectItem <> nil) and (SelectItem^.EventMode = EM_PROGRAM) {and
           (SelectItem^.EventStatus.State in [esIdle..esLoaded, esDone..esSkipped])} then
        begin
          AClipboardCueSheet.PasteIncluded := AClipboardCueSheet.PasteIncluded + [EM_PROGRAM];
          break;
        end;
      end;

      // ���� �̺�Ʈ�� ���ԵǾ� �ִ��� �˻�
      for I := 0 to SelectedRowCount - 1 do
      begin
        Index := RealRowIndex(SortSelectedRows[I]) - CNT_CUESHEET_HEADER;
        SelectItem := GetCueSheetItemByIndex(Index);
        if (SelectItem <> nil) and (SelectItem^.EventMode = EM_MAIN) {and
           (SelectItem^.EventStatus.State in [esIdle..esLoaded, esDone..esSkipped])} then
        begin
          AClipboardCueSheet.PasteIncluded := AClipboardCueSheet.PasteIncluded + [EM_MAIN];
          break;
        end;
      end;

      for I := 0 to SelectedRowCount - 1 do
      begin
        Index := RealRowIndex(SortSelectedRows[I]) - CNT_CUESHEET_HEADER;
        SelectItem := GetCueSheetItemByIndex(Index);
        if (SelectItem <> nil) then
        begin
          case SelectItem^.EventMode of
            EM_PROGRAM:
            begin
//              // ���α׷� �̺�Ʈ�� ���ԵǾ� �ִ� ��� �θ��̺�Ʈ �� ���� �̺�Ʈ ��� ����
//              if (EM_PROGRAM in AClipboardCueSheet.PasteIncluded) then
//              begin
//                Item := GetProgramItemByItem(SelectItem);
//                // Cue or onair evnet not include
//                if (Item <> nil) {and (Item^.EventStatus.State in [esIdle..esLoaded, esDone..esSkipped])} then
//                begin
//                  Index := GetCueSheetIndexByItem(Item);
//                  for J := Index to FCueSheetList.Count - 1 do
//                  begin
//                    Item := GetCueSheetItemByIndex(J);
//                    if (SelectItem^.ProgramNo = Item^.ProgramNo) and (AClipboardCueSheet.IndexOf(Item) < 0) then
//                    begin
//                      AClipboardCueSheet.Add(Item);
//                      AClipboardCueSheet.PasteIncluded := AClipboardCueSheet.PasteIncluded + [Item^.EventMode];
//                    end
//                    else
//                      break;
//                  end;
//                end
//                else
//                begin
//                  // ���ӵ� �̺�Ʈ ����
//                  if (AClipboardCueSheet.IndexOf(SelectItem) < 0) then
//                    AClipboardCueSheet.Add(SelectItem);
//
//                  for J := Index + 1 to FCueSheetList.Count - 1 do
//                  begin
//                    Item := GetCueSheetItemByIndex(J);
//                    if (SelectItem^.GroupNo = Item^.GroupNo) and (AClipboardCueSheet.IndexOf(Item) < 0) then
//                    begin
//                      AClipboardCueSheet.Add(Item);
//                      AClipboardCueSheet.PasteIncluded := AClipboardCueSheet.PasteIncluded + [Item^.EventMode];
//                    end
//                    else
//                      break;
//                  end;
//                end;
//              end
//              else
              begin
                // ���ӵ� �̺�Ʈ ����
                if (AClipboardCueSheet.IndexOf(SelectItem) < 0) then
                  AClipboardCueSheet.Add(SelectItem);

                for J := Index + 1 to FCueSheetList.Count - 1 do
                begin
                  Item := GetCueSheetItemByIndex(J);
                  if (Item <> nil) and (SelectItem^.ProgramNo = Item^.ProgramNo) and (AClipboardCueSheet.IndexOf(Item) < 0) then
                  begin
                    AClipboardCueSheet.Add(Item);
                    AClipboardCueSheet.PasteIncluded := AClipboardCueSheet.PasteIncluded + [Item^.EventMode];
                  end
                  else
                    break;
                end;
              end;
            end;
            EM_MAIN:
            begin
              // Cue or onair evnet not include
  //            if (SelectItem^.EventStatus.State in [esCueing..esFinished]) then Continue;

//              // ���α׷� �̺�Ʈ�� ���ԵǾ� �ִ� ��� �θ��̺�Ʈ �� ���� �̺�Ʈ ��� ����
//              if (EM_PROGRAM in AClipboardCueSheet.PasteIncluded) then
//              begin
//                Item := GetProgramItemByItem(SelectItem);
//                // Cue or onair evnet not include
//                if (Item <> nil) {and (Item^.EventStatus.State in [esIdle..esLoaded, esDone..esSkipped])} then
//                begin
//                  Index := GetCueSheetIndexByItem(Item);
//                  for J := Index to FCueSheetList.Count - 1 do
//                  begin
//                    Item := GetCueSheetItemByIndex(J);
//                    if (SelectItem^.ProgramNo = Item^.ProgramNo) and (AClipboardCueSheet.IndexOf(Item) < 0) then
//                    begin
//                      AClipboardCueSheet.Add(Item);
//                      AClipboardCueSheet.PasteIncluded := AClipboardCueSheet.PasteIncluded + [Item^.EventMode];
//                    end
//                    else
//                      break;
//                  end;
//                end
//                else
//                begin
//                  // ���ӵ� �̺�Ʈ ����
//                  if (AClipboardCueSheet.IndexOf(SelectItem) < 0) then
//                    AClipboardCueSheet.Add(SelectItem);
//
//                  for J := Index + 1 to FCueSheetList.Count - 1 do
//                  begin
//                    Item := GetCueSheetItemByIndex(J);
//                    if (SelectItem^.GroupNo = Item^.GroupNo) and (AClipboardCueSheet.IndexOf(Item) < 0) then
//                    begin
//                      AClipboardCueSheet.Add(Item);
//                      AClipboardCueSheet.PasteIncluded := AClipboardCueSheet.PasteIncluded + [Item^.EventMode];
//                    end
//                    else
//                      break;
//                  end;
//                end;
//              end
//              else
              begin
                // ���ӵ� �̺�Ʈ ����
                if (AClipboardCueSheet.IndexOf(SelectItem) < 0) then
                  AClipboardCueSheet.Add(SelectItem);

                for J := Index + 1 to FCueSheetList.Count - 1 do
                begin
                  Item := GetCueSheetItemByIndex(J);
                  if (Item <> nil) and (SelectItem^.GroupNo = Item^.GroupNo) and (AClipboardCueSheet.IndexOf(Item) < 0) then
                  begin
                    AClipboardCueSheet.Add(Item);
                    AClipboardCueSheet.PasteIncluded := AClipboardCueSheet.PasteIncluded + [Item^.EventMode];
                  end
                  else
                    break;
                end;
              end;
            end;
            EM_JOIN,
            EM_SUB,
            EM_COMMENT:
            begin
              // ���� �̺�Ʈ�� ���ԵǾ� �ִ� ��� �θ��̺�Ʈ �� ���� �̺�Ʈ ��� ����
              if (EM_MAIN in AClipboardCueSheet.PasteIncluded) then
              begin
                Item := GetParentCueSheetItemByItem(SelectItem);
                // Cue or onair evnet not include
                if (Item <> nil) {and (Item^.EventStatus.State in [esIdle..esLoaded, esDone..esSkipped])} then
                begin
                  Index := GetCueSheetIndexByItem(Item);
                  for J := Index to FCueSheetList.Count - 1 do
                  begin
                    Item := GetCueSheetItemByIndex(J);
                    if (Item <> nil) and (SelectItem^.GroupNo = Item^.GroupNo) and (AClipboardCueSheet.IndexOf(Item) < 0) then
                    begin
                      AClipboardCueSheet.Add(Item);
                      AClipboardCueSheet.PasteIncluded := AClipboardCueSheet.PasteIncluded + [Item^.EventMode];
                    end
                    else
                      break;
                  end;
                end
                else if (AClipboardCueSheet.IndexOf(SelectItem) < 0) then
                begin
                  AClipboardCueSheet.Add(SelectItem);
                  AClipboardCueSheet.PasteIncluded := AClipboardCueSheet.PasteIncluded + [SelectItem^.EventMode];
                end;
              end
              else
              begin
                // Cue or onair parent evnet not include
  //              Item := GetParentCueSheetItemByItem(SelectItem);
  //              if (Item <> nil) and (Item^.EventStatus.State in [esCueing..esFinished]) then Continue;

                // �ڽ��� �̺�Ʈ�� ����
                if (AClipboardCueSheet.IndexOf(SelectItem) < 0) then
                begin
                  AClipboardCueSheet.Add(SelectItem);
                  AClipboardCueSheet.PasteIncluded := AClipboardCueSheet.PasteIncluded + [SelectItem^.EventMode];
                end;
              end;
            end;
          end;
        end;
      end;
    finally
      FreeAndNil(SortSelectedRows);
    end;
{    for I := 0 to AClipboardCueSheet.Count - 1 do
      ShowMessage(AClipboardCueSheet[I]^.SubTitle);  }
  end;

  Result := AClipboardCueSheet.Count;
end;

function TfrmChannel.IsValidStartDate(AItem: PCueSheetItem; AStartDate: TDate; AIsSelf: Boolean): Boolean;
var
  ErrorString: String;

  PItem: PCueSheetItem;   // Parent cuesheet item
  PEndTime: TEventTime;   // parent end time

  StartTime: TEventTime;  // Current start time
begin
  Result := True;

  ErrorString := '';
  try
    // Checks whether the entered start time is less than the start time of the previous event.
    PItem := GetBeforeMainItemByItem(AItem);
    if (PItem <> nil) then
    begin
      // Get parent end time
      PEndTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC, ChannelFrameRateType);

      if (AItem^.EventMode = EM_MAIN) then
      begin
        // Get current start time
        StartTime   := AItem^.StartTime;
        StartTime.D := AStartDate;

        if (CompareEventTime(StartTime, PEndTime, ChannelFrameRateType) < 0) then
        begin
          ErrorString := SStartTimeGreaterThenBeforeEndTime;
          exit;
        end;
      end;
    end;
  finally
    if (ErrorString <> '') then
    begin
      if (AIsSelf) then
        TAdvOfficePage(Parent).AdvOfficePager.ActivePage := TAdvOfficePage(Parent);

      MessageBeep(MB_ICONWARNING);
      MessageBox(Handle, PChar(ErrorString), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
      Result := False;
    end;
  end;
end;

function TfrmChannel.IsValidStartTime(AItem: PCueSheetItem; AStartTC: TTimecode; AIsSelf: Boolean): Boolean;
var
  ErrorString: String;

  PItem: PCueSheetItem;   // Parent cuesheet item
  PEndTime: TEventTime;   // parent end time

  StartTime: TEventTime;  // Current start time
  EndTime: TEventTime;    // Current end time
begin
  Result := True;

  ErrorString := '';
  try
    // Check that the entered timecode is validate.
    if (not IsValidTimecode(AStartTC, ChannelFrameRateType)) then
    begin
      ErrorString := Format(SInvalidTimeocde, ['Start time']);
      exit;
    end;

    // Checks whether the entered start time is less than the start time of the previous event.
    PItem := GetBeforeMainItemByItem(AItem);
    if (PItem <> nil) then
    begin
      // Get parent end time
      PEndTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC, ChannelFrameRateType);

      if (AItem^.EventMode = EM_MAIN) then
      begin
        // Get current start time
        StartTime   := AItem^.StartTime;
        StartTime.T := AStartTC;

        if (CompareEventTime(StartTime, PEndTime, ChannelFrameRateType) < 0) then
        begin
          ErrorString := SStartTimeGreaterThenBeforeEndTime;
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
          EndTime := GetEventEndTime(GetPlusEventTime(PItem^.StartTime, StartTime, ChannelFrameRateType), AItem^.DurationTC, ChannelFrameRateType);
//          ShowMessage(EventTimeToDateTimecodeStr(PEndTime));
//          ShowMessage(EventTimeToDateTimecodeStr(EndTime));

          if (CompareEventTime(EndTime, PEndTime, ChannelFrameRateType) > 0) then
          begin
            ErrorString := SSubStartTimeLessThenParentEndTime;
            exit;
          end;
        end
        else
          // Get current end time
          EndTime := GetEventEndTime(GetMinusEventTime(PEndTime, StartTime, ChannelFrameRateType), AItem^.DurationTC, ChannelFrameRateType);

          if (CompareEventTime(EndTime, PEndTime, ChannelFrameRateType) > 0) then
          begin
            ErrorString := SSubStartTimeLessThenParentEndTime;
            exit;
          end
          else if (AStartTC > PItem^.DurationTC) then
          begin
            ErrorString := SSubStartTimeGreaterThenParentStartTime;
            exit;
          end;
      end;
    end;
  finally
    if (ErrorString <> '') then
    begin
      if (AIsSelf) then
        TAdvOfficePage(Parent).AdvOfficePager.ActivePage := TAdvOfficePage(Parent);

      MessageBeep(MB_ICONWARNING);
      MessageBox(Handle, PChar(ErrorString), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
      Result := False;
    end;
  end;
end;

function TfrmChannel.IsValidDuration(AItem: PCueSheetItem; ADuration: TTimecode; AIsSelf: Boolean): Boolean;
var
  ErrorString: String;

  PItem: PCueSheetItem; // Parent cuesheet item
  PEndTime: TEventTime; // parent end time

  EndTime: TEventTime;  // Current end time
begin
  Result := True;

  ErrorString := '';
  try
    // Check that the entered timecode is validate.
    if (not IsValidTimecode(ADuration, ChannelFrameRateType)) then
    begin
      ErrorString := Format(SInvalidTimeocde, ['Duration']);
      exit;
    end;

    if (AItem <> nil) then
    begin
      if (AItem^.Input <> IT_NONE) then
      begin
        if (ADuration < GV_SettingThresholdTime.MinDuration) then
        begin
          ErrorString := Format(SDurationTCGreaterThenMinDuration, ['Duration', TimecodeToString(GV_SettingThresholdTime.MinDuration, ChannelIsDropFrame)]);
          exit;
        end;

        if (ADuration > GV_SettingThresholdTime.MaxDuration) then
        begin
          ErrorString := Format(SDurationTCLessThenMaxDuration, ['Duration', TimecodeToString(GV_SettingThresholdTime.MaxDuration, ChannelIsDropFrame)]);
          exit;
        end;
      end;

    // Feture add the media duration validate
    //
    //


//    if (AItem <> nil) then
//    begin
      if (AItem^.EventMode in [EM_JOIN, EM_SUB]) then
      begin
        // Checks whether the entered end time is less than the end time of the parent event.
        PItem := GetParentCueSheetItemByItem(AItem);
        if (PItem <> nil) then
        begin
          // Get parent end time
          PEndTime := GetEventEndTime(PItem^.StartTime, PItem^.DurationTC, ChannelFrameRateType);

          if (AItem^.StartMode = SM_SUBBEGIN) then
          begin
            // Get current end time
            EndTime := GetEventTimeSubBegin(PItem^.StartTime, AItem^.StartTime.T, ChannelFrameRateType);
            EndTime := GetEventEndTime(EndTime, ADuration, ChannelFrameRateType);

            if (CompareEventTime(EndTime, PEndTime, ChannelFrameRateType) > 0) then
            begin
              ErrorString := SSubStartTimeLessThenParentEndTime;
              exit;
            end;
          end
          else
          begin
            // Get current end time
            EndTime := GetEventTimeSubEnd(PItem^.StartTime, PItem^.DurationTC, AItem^.StartTime.T, ChannelFrameRateType);
            EndTime := GetEventEndTime(EndTime, ADuration, ChannelFrameRateType);

            if (CompareEventTime(EndTime, PEndTime, ChannelFrameRateType) > 0) then
            begin
              ErrorString := SSubStartTimeLessThenParentEndTime;
              exit;
            end;
          end;
        end;
      end;
    end;
  finally
    if (ErrorString <> '') then
    begin
      if (AIsSelf) then
        TAdvOfficePage(Parent).AdvOfficePager.ActivePage := TAdvOfficePage(Parent);

      MessageBeep(MB_ICONWARNING);
      MessageBox(Handle, PChar(ErrorString), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
      Result := False;
    end;
  end;
end;

function TfrmChannel.IsValidInTC(AItem: PCueSheetItem; AInTC: TTimecode; AIsSelf: Boolean): Boolean;
var
  ErrorString: String;
begin
  Result := True;

  ErrorString := '';
  try
    // Check that the entered timecode is validate.
    if (not IsValidTimecode(AInTC, ChannelFrameRateType)) then
    begin
      ErrorString := Format(SInvalidTimeocde, ['In']);
      exit;
    end;

    if (AItem <> nil) then
    begin
      if (AItem^.Input <> IT_NONE) then
      begin
        if (AInTC >= AItem^.DurationTC) then
        begin
          ErrorString := SInTCLessThenDurationTC;
          exit;
        end;

        if (AInTC > AItem^.OutTC) then
        begin
          ErrorString := SInTCLessThenOutTC;
          exit;
        end;
      end;
    end;
  finally
    if (ErrorString <> '') then
    begin
      if (AIsSelf) then
        TAdvOfficePage(Parent).AdvOfficePager.ActivePage := TAdvOfficePage(Parent);

      MessageBeep(MB_ICONWARNING);
      MessageBox(Handle, PChar(ErrorString), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
      Result := False;
    end;
  end;
end;

function TfrmChannel.IsValidOutTC(AItem: PCueSheetItem; AOutTC: TTimecode; AIsSelf: Boolean): Boolean;
var
  ErrorString: String;
begin
  Result := True;

  ErrorString := '';
  try
    // Check that the entered timecode is validate.
    if (not IsValidTimecode(AOutTC, ChannelFrameRateType)) then
    begin
      ErrorString := Format(SInvalidTimeocde, ['Out']);
      exit;
    end;

    if (AItem <> nil) then
    begin
      if (AItem^.Input <> IT_NONE) then
      begin
  {      if (AOutTC >= AItem^.DurationTC) then
        begin
          ErrorString := SOutTCLessThenDurationTC;
          exit;
        end; }

        if (AOutTC < AItem^.InTC) then
        begin
          ErrorString := SOutTCGreaterThenInTC;
          exit;
        end;
      end;
    end;
  finally
    if (ErrorString <> '') then
    begin
      if (AIsSelf) then
        TAdvOfficePage(Parent).AdvOfficePager.ActivePage := TAdvOfficePage(Parent);

      MessageBeep(MB_ICONWARNING);
      MessageBox(Handle, PChar(ErrorString), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
      Result := False;
    end;
  end;
end;

function TfrmChannel.IsValidMediaId(AMediaId: String; AIsSelf: Boolean): Boolean;
var
  ErrorString: String;
begin
  Result := True;

  ErrorString := '';
  try
  finally
    if (ErrorString <> '') then
    begin
      if (AIsSelf) then
        TAdvOfficePage(Parent).AdvOfficePager.ActivePage := TAdvOfficePage(Parent);

      MessageBeep(MB_ICONWARNING);
      MessageBox(Handle, PChar(ErrorString), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
      Result := False;
    end;
  end;
end;

procedure TfrmChannel.NewPlayList;
var
  ChannelCueSheet: PChannelCueSheet;
begin
  if (FChannelOnAir) then
  begin
    exit;
  end;
  if (FCueSheetList = nil) then exit;

  if (GV_ClipboardCueSheet.Count > 0) and (GV_ClipboardCueSheet.ChannelID = FChannelID) then
    ClearClipboardCueSheet;

  ClearPlayListTimeLine;
  ClearPlayListGrid;
  ClearCueSheetList;
  ClearChannelCueSheetList;

  FLastDisplayNo := -1;

  FLastCount  := 0;

  FLastInputIndex := -1;

  FTimeLineDaysPerFrames := Round(SecsPerDay * wmtlPlaylist.TimeZoneProperty.FrameRate);
  FTimeLineMin := MaxInt;
  FTimeLineMax := -MaxInt;

  ChannelCueSheet := New(PChannelCueSheet);
  FillChar(ChannelCueSheet^, SizeOf(TChannelCueSheet), #0);
  with ChannelCueSheet^ do
  begin
    StrPLCopy(FileName, NEW_CUESHEET_NAME, MAX_PATH);
    ChannelID := FChannelID;
    StrPLCopy(OnairDate, FormatDateTime('YYYYMMDD', Date), DATE_LEN);
    OnairFlag := FT_REGULAR;
    OnairNo := 0;
    EventCount := 0;
    LastSerialNo := 0;
    LastProgramNo := 0;
    LastGroupNo := 0;
  end;
  FChannelCueSheetList.Add(ChannelCueSheet);

  DisplayPlayListGrid;

  CalcuratePlayListTimeLineRange;
  UpdatePlayListTimeLineRange;

{  FPlayListFileName := NEW_CUESHEET_NAME;
  lblPlayListFileName.Caption := FPlayListFileName; }

  PlayListFileName := NEW_CUESHEET_NAME;

  CueSheetCurr   := nil;
  CueSheetNext   := nil;
  CueSheetTarget := nil;

  FCueSheetLoopLastStartTime  := InitEventTime;
  FCueSheetLoopLastDurationTC := 0;

  FCueSheetLoopFirst := nil;
  FCueSheetLoopLast  := nil;
end;

procedure TfrmChannel.AddLoadPlayList(ALoadChannelCueSheet: PChannelCueSheet; ACueSheetList: TCueSheetList; AAdd: Boolean = False);
var
  I: Integer;
begin
  Screen.Cursor := crHourGlass;
  try
    if (GV_ClipboardCueSheet.Count > 0) and (GV_ClipboardCueSheet.ChannelID = FChannelID) then
      ClearClipboardCueSheet;

    ClearPlayListTimeLine;
    ClearPlayListGrid;
    ClearCueSheetList;
    ClearChannelCueSheetList;

    FLastDisplayNo := -1;

    FLastCount  := 0;

    FLastInputIndex := -1;

    FTimeLineDaysPerFrames := Round(SecsPerDay * wmtlPlaylist.TimeZoneProperty.FrameRate);
    FTimeLineMin := MaxInt;
    FTimeLineMax := -MaxInt;

    for I := 0 to ACueSheetList.Count - 1 do
    begin
      FCueSheetList.Add(ACueSheetList[I]);
    end;

    FChannelCueSheetList.Add(ALoadChannelCueSheet);

    PlayListFileName := String(ALoadChannelCueSheet^.FileName);

    DisplayPlayListGrid(0, FCueSheetList.Count);

    CalcuratePlayListTimeLineRange;
    UpdatePlayListTimeLineRange;

    DisplayPlayListTimeLine;

    FLastCount := FCueSheetList.Count;
  finally
    Screen.Cursor := crDefault;
  end;

end;

procedure TfrmChannel.OpenPlayList(AFileName: String);
var
  OpenPlaylistForm: TfrmOpenPlaylist;

  ChannelCueSheet: PChannelCueSheet;
  CueSheetList: TCueSheetList;
begin
{  if (FCueSheetList = nil) then exit;

  OpenPlaylistForm := TfrmOpenPlaylist.Create(Self, AFileName);
  try
    OpenPlaylistForm.ShowModal;
    if (OpenPlaylistForm.ModalResult <> mrOK) then exit;
  finally
    FreeAndNil(OpenPlaylistForm);
  end;

  exit;
}







  if (GV_ClipboardCueSheet.Count > 0) and (GV_ClipboardCueSheet.ChannelID = FChannelID) then
    ClearClipboardCueSheet;

  Screen.Cursor := crHourGlass;
  try
    ClearPlayListTimeLine;
    ClearPlayListGrid;
    ClearCueSheetList;
    ClearChannelCueSheetList;

    FLastDisplayNo := -1;

    FLastCount  := 0;

    FLastInputIndex := -1;

    FTimeLineDaysPerFrames := Round(SecsPerDay * wmtlPlaylist.TimeZoneProperty.FrameRate);
    FTimeLineMin := MaxInt;
    FTimeLineMax := -MaxInt;

    ChannelCueSheet := New(PChannelCueSheet);
    FillChar(ChannelCueSheet^, SizeOf(TChannelCueSheet), #0);
    with ChannelCueSheet^ do
    begin
      StrPLCopy(FileName, AFileName, MAX_PATH);
      ChannelID := FChannelID;
    end;

  //  PlaylistFileParsing(AFileName);
    OpenPlayListXML(ChannelCueSheet, FCueSheetList);

    FChannelCueSheetList.Add(ChannelCueSheet);

{    FPlayListFileName := AFileName;
    lblPlayListFileName.Caption := FPlayListFileName; }

    PlayListFileName := AFileName;

    DisplayPlayListGrid(0, FCueSheetList.Count);

    CalcuratePlayListTimeLineRange;
    UpdatePlayListTimeLineRange;

    DisplayPlayListTimeLine;

    FLastCount := FCueSheetList.Count;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmChannel.OpenAddPlayList(AFileName: String; AAutoFollow: Boolean);
var
  ChannelCueSheet: PChannelCueSheet;

  LastItem: PCueSheetItem;
  LastEndTime: TEventTime;

  NextItem: PCueSheetItem;
  NextIndex: Integer;

  SaveStartTime: TEventTime;
begin
  if (FCueSheetList = nil) then exit;

  if (GV_ClipboardCueSheet.Count > 0) and (GV_ClipboardCueSheet.ChannelID = FChannelID) then
    ClearClipboardCueSheet;

  Screen.Cursor := crHourGlass;
  try
    // �̺�Ʈ�� ���� ��� ä�� ť��Ʈ ��� ����
    if (FCueSheetList.Count <= 0) then
      ClearChannelCueSheetList;

    ChannelCueSheet := New(PChannelCueSheet);
    FillChar(ChannelCueSheet^, SizeOf(TChannelCueSheet), #0);
    with ChannelCueSheet^ do
    begin
      StrPLCopy(FileName, AFileName, MAX_PATH);
      ChannelID := FChannelID;
    end;
  //  PlaylistFileParsing(AFileName);
    OpenPlayListXML(ChannelCueSheet, FCueSheetList, True);

    FChannelCueSheetList.Add(ChannelCueSheet);

    // �ڵ����� ���� �ð��� ���������� Update�� ���
    if (AAutoFollow) then
    begin
      LastItem := GetParentCueSheetItemByIndex(FLastCount - 1);
      if (LastItem <> nil) then
      begin
        NextItem := GetNextMainItemByItem(LastItem);
        if (NextItem <> nil) then
        begin
          NextIndex   := GetCueSheetIndexByItem(NextItem);
          LastEndTime := GetEventEndTime(LastItem^.StartTime, LastItem^.DurationTC, ChannelFrameRateType);

          SaveStartTime := NextItem^.StartTime;
          NextItem^.StartTime := LastEndTime;

          ResetStartTimeByTime(NextIndex, SaveStartTime);
        end;
      end;
    end;

    DisplayPlayListGrid(FLastCount, FCueSheetList.Count - FLastCount);

    if (not ChannelOnAir) then
    begin
      CalcuratePlayListTimeLineRange;
      UpdatePlayListTimeLineRange;
    end;
    DisplayPlayListTimeLine(FLastCount);

    FLastCount     := FCueSheetList.Count;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmChannel.SavePlayList;
var
  I: Integer;
  ChannelCueSheet: PChannelCueSheet;
begin
  if (FChannelCueSheetList = nil) then exit;

  Screen.Cursor := crHourGlass;
  try
    for I := 0 to FChannelCueSheetList.Count - 1 do
    begin
      ChannelCueSheet := FChannelCueSheetList[I];
      SavePlayListXML(ChannelCueSheet);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmChannel.SaveAsPlayList(AFileName: String; ADate: TDate);
var
  I: Integer;
  ChannelCueSheet: PChannelCueSheet;
begin
  if (FChannelCueSheetList = nil) then exit;

  Screen.Cursor := crHourGlass;
  try
    ClearChannelCueSheetList;

    ChannelCueSheet := New(PChannelCueSheet);
    FillChar(ChannelCueSheet^, SizeOf(TChannelCueSheet), #0);
    with ChannelCueSheet^ do
    begin
      StrPLCopy(FileName, AFileName, MAX_PATH);
      ChannelID := FChannelID;
      StrPLCopy(OnairDate, FormatDateTime('YYYYMMDD', ADate), DATE_LEN);
      OnairFlag := FT_REGULAR;
      OnairNo := 0;
      EventCount := FCueSheetList.Count;
      LastSerialNo := 0;
      LastProgramNo := 0;
      LastGroupNo := 0;
      LastDisplayNo := 0;
    end;

    SavePlayListXML(ChannelCueSheet, True);

    FChannelCueSheetList.Add(ChannelCueSheet);

    PlayListFileName := AFileName;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmChannel.SetEventStatusColor(AItem: PCueSheetItem);
var
  BkColor, TxColor, ToColor: TColor;
  Index: Integer;
begin
  if (AItem = nil) then exit;

  BkColor := COLOR_BK_EVENTSTATUS_NORMAL;
  TxColor := COLOR_TX_EVENTSTATUS_NORMAL;
  ToColor := COLOR_TO_EVENTSTATUS_NORMAL;

  if (AItem^.EventMode = EM_COMMENT) then
  begin
    BkColor := COLOR_BK_COMMENT_CUESHEET;
    TxColor := COLOR_TX_COMMENT_CUESHEET;
  end
  else if (AItem^.EventMode = EM_PROGRAM) then
  begin
    BkColor := COLOR_BK_EVENTSTATUS_NORMAL;
    TxColor := COLOR_TX_EVENTSTATUS_NORMAL;
    ToColor := COLOR_TO_EVENTSTATUS_NORMAL;
    if (CueSheetCurr <> nil) then
    begin
      if (CueSheetCurr^.ProgramNo = AItem^.ProgramNo) then
      begin
        BkColor := COLOR_BK_EVENTSTATUS_ONAIR;
        TxColor := COLOR_TX_EVENTSTATUS_ONAIR;
        ToColor := COLOR_TO_EVENTSTATUS_ONAIR;
      end
      else
      begin
        Index := GetCueSheetIndexByItem(AItem);
        if (Index < GetCueSheetIndexByItem(CueSheetCurr)) then
        begin
          BkColor := COLOR_BK_EVENTSTATUS_DONE;
          TxColor := COLOR_TX_EVENTSTATUS_DONE;
          ToColor := COLOR_TO_EVENTSTATUS_DONE;
        end;
      end;
    end
    else if (CueSheetNext <> nil) then
    begin
      if (CueSheetNext^.ProgramNo = AItem^.ProgramNo) then
      begin
        BkColor := COLOR_BK_EVENTSTATUS_NEXT;
        TxColor := COLOR_TX_EVENTSTATUS_NEXT;
        ToColor := COLOR_TO_EVENTSTATUS_NEXT;
      end
      else
      begin
        Index := GetCueSheetIndexByItem(AItem);
        if (Index < GetCueSheetIndexByItem(CueSheetNext)) then
        begin
          BkColor := COLOR_BK_EVENTSTATUS_DONE;
          TxColor := COLOR_TX_EVENTSTATUS_DONE;
          ToColor := COLOR_TO_EVENTSTATUS_DONE;
        end;
      end;
    end
    else
    begin
      if (GetProgramMainItemByItem(AItem) = nil) then
      begin
        BkColor := COLOR_BK_EVENTSTATUS_DONE;
        TxColor := COLOR_TX_EVENTSTATUS_DONE;
        ToColor := COLOR_TO_EVENTSTATUS_DONE;
      end;
    end;
  end
  else if (CueSheetNext <> nil) and (AItem^.GroupNo = CueSheetNext^.GroupNo) and
          ((not FChannelOnAir) or ((CueSheetNext^.EventStatus.State in [esLoaded]) and (AItem^.EventStatus.State in [esLoaded]))) then
  begin
    BkColor := COLOR_BK_EVENTSTATUS_NEXT;
    TxColor := COLOR_TX_EVENTSTATUS_NEXT;
    ToColor := COLOR_TO_EVENTSTATUS_NEXT;
  end
  else if (CueSheetCurr <> nil) and (AItem^.GroupNo = CueSheetCurr^.GroupNo) and
          (AItem^.EventStatus.State in [esLoaded]) then
  begin
    BkColor := COLOR_BK_EVENTSTATUS_NEXT;
    TxColor := COLOR_TX_EVENTSTATUS_NEXT;
    ToColor := COLOR_TO_EVENTSTATUS_NEXT;
  end
  else
  begin
    case AItem^.EventStatus.State of
      esCueing..esPreroll:
      begin
        BkColor := COLOR_BK_EVENTSTATUS_CUED;
        TxColor := COLOR_TX_EVENTSTATUS_CUED;
        ToColor := COLOR_TO_EVENTSTATUS_CUED;
      end;
      esOnAir:
      begin
        BkColor := COLOR_BK_EVENTSTATUS_ONAIR;
        TxColor := COLOR_TX_EVENTSTATUS_ONAIR;
        ToColor := COLOR_TO_EVENTSTATUS_ONAIR;
      end;
      esSkipped,
      esFinish..esDone:
      begin
        BkColor := COLOR_BK_EVENTSTATUS_DONE;
        TxColor := COLOR_TX_EVENTSTATUS_DONE;
        ToColor := COLOR_TO_EVENTSTATUS_DONE;
      end;
{      esError:
      begin
        BkColor := COLOR_BK_EVENTSTATUS_ERROR;
        TxColor := COLOR_TX_EVENTSTATUS_ERROR;
        ToColor := COLOR_TO_EVENTSTATUS_ERROR;
      end; }
      else
      begin
        if (CueSheetTarget <> nil) and (AItem^.GroupNo = CueSheetTarget^.GroupNo) then
        begin
          BkColor := COLOR_BK_EVENTSTATUS_TARGET;
          TxColor := COLOR_TX_EVENTSTATUS_TARGET;
          ToColor := COLOR_TO_EVENTSTATUS_TARGET;
        end
        else
        begin
          BkColor := COLOR_BK_EVENTSTATUS_NORMAL;
          TxColor := COLOR_TX_EVENTSTATUS_NORMAL;
          ToColor := COLOR_TO_EVENTSTATUS_NORMAL;
        end;
      end;
    end;
  end;

  AItem^.BkColor := BkColor;
  AItem^.TxColor := TxColor;
  AItem^.ToColor := ToColor;
end;

procedure TfrmChannel.ChannelCueSheetListSort(AChannelCueSheetList: TChannelCueSheetList);
begin
  if (AChannelCueSheetList.Count > 1) then ChannelCueSheetListQuickSort(0, pred(AChannelCueSheetList.Count), AChannelCueSheetList);
end;

procedure TfrmChannel.CueSheetListSort(ACueSheetList: TCueSheetList);
begin
  if (ACueSheetList.Count > 1) then CueSheetListQuickSort(0, pred(ACueSheetList.Count), ACueSheetList);
end;

function TfrmChannel.CheckCueSheetEditPossibleLockTimeByIndex(AIndex: Integer): Boolean;
var
  Item: PCueSheetItem;
  CheckTime: TEventTime;
begin
  Result := True;

  if (FChannelOnAir) then
  begin
    Item := GetCueSheetItemByIndex(AIndex);
    if (Item <> nil) and (Item^.EventMode = EM_MAIN) then
    begin
      CheckTime := GetPlusEventTime(DateTimeToEventTime(Now, ChannelFrameRateType), TimecodeToEventTime(GV_SettingThresholdTime.EditLockTime), ChannelFrameRateType);
      if (CompareEventTime(Item^.StartTime, CheckTime, ChannelFrameRateType) <= 0) then
      begin
        Result := False;
        exit;
      end;
    end;
  end;
end;

function TfrmChannel.CheckCueSheetEditPossibleLockTimeByItem(AItem: PCueSheetItem): Boolean;
var
  CheckTime: TEventTime;
begin
  Result := True;

  if (FChannelOnAir) then
  begin
    if (AItem <> nil) and (AItem^.EventMode = EM_MAIN) then
    begin
      CheckTime := GetPlusEventTime(DateTimeToEventTime(Now, ChannelFrameRateType), TimecodeToEventTime(GV_SettingThresholdTime.EditLockTime), ChannelFrameRateType);
      if (CompareEventTime(AItem^.StartTime, CheckTime, ChannelFrameRateType) <= 0) then
      begin
        Result := False;
        exit;
      end;
    end;
  end;
end;

function TfrmChannel.CheckCueSheetEditPossibleLocationByIndex(AIndex: Integer): Boolean;
var
  CheckIndex: Integer;
  ParentItem: PCueSheetItem;
  ParentIndex: Integer;
begin
  Result := True;

  if (FChannelOnAir) then
  begin
    if (CueSheetNext <> nil) then
      CheckIndex := GetCueSheetIndexByItem(CueSheetNext)
    else if (CueSheetCurr <> nil) then
      CheckIndex := GetCueSheetIndexByItem(CueSheetCurr)
    else
      CheckIndex := FCueSheetList.Count - 1;

    ParentItem := GetParentCueSheetItemByIndex(AIndex);
    if (ParentItem <> nil) then
    begin
      ParentIndex := GetCueSheetIndexByItem(ParentItem);
      if (ParentIndex <= CheckIndex) then
      begin
        Result := False;
        exit;
      end;
    end
    else if (AIndex >= 0) and (AIndex <= CheckIndex) then
    begin
      Result := False;
      exit;
    end;
  end;
end;

function TfrmChannel.CheckCueSheetEditPossibleLocationByItem(AItem: PCueSheetItem): Boolean;
var
  CheckIndex: Integer;
  ParentItem: PCueSheetItem;
  ParentIndex: Integer;
  Index: Integer;
begin
  Result := True;

  if (FChannelOnAir) then
  begin
    if (CueSheetNext <> nil) then
      CheckIndex := GetCueSheetIndexByItem(CueSheetNext)
    else if (CueSheetCurr <> nil) then
      CheckIndex := GetCueSheetIndexByItem(CueSheetCurr)
    else
      CheckIndex := FCueSheetList.Count - 1;

    Index := GetCueSheetIndexByItem(AItem);

    ParentItem := GetParentCueSheetItemByItem(AItem);
    if (ParentItem <> nil) then
    begin
      ParentIndex := GetCueSheetIndexByItem(ParentItem);
      if (ParentIndex <= CheckIndex) then
      begin
        Result := False;
        exit;
      end;
    end
    else if (Index >= 0) and (Index <= CheckIndex) then
    begin
      Result := False;
      exit;
    end;
  end;
end;

function TfrmChannel.OpenDialogMediaFile(ACaption: String; var AFileName: String): Boolean;
begin
  Result := False;

  with TOpenDialog.Create(Self) do
    try
      Title := ACaption;
      Filename := ExtractFileName(AFileName);

      if (AFileName <> '') then
        InitialDir := ExtractFilePath(AFileName)
      else
        InitialDir := GV_SettingGeneral.MediaPath;

      Filter  := 'Video file|*.mxf;*.mov;*.mp4;*.mpg;*.mpeg;*.avi;*.wmv|Audio file|*.wav;*.mp3;*.wma|Any file(*.*)|*.*';
      if Execute then
      begin
        if (AFileName <> FileName) then
        begin
          AFileName := FileName;
          Result := True;
        end;
      end;
    finally
      Free;
    end;
end;

function TfrmChannel.InputLoopEvent(ALoopItem: PCueSheetItem): Integer;
var
  ChannelCueSheet: PChannelCueSheet;
  I, Index: Integer;
  Item, AddItem: PCueSheetItem;

  LoopLastItem: PCueSheetItem;

  LoopAddMainStartTime: TEventTime;
  SaveStartTime: TEventTime;

  LoopLastNextMainIndex: Integer;
  LoopLastNextMainItem: PCueSheetItem;
begin
  Result := D_FALSE;

  // ������ Loop�� ���� Main �ε����� ����
  LoopLastNextMainIndex := GetCueSheetIndexByItem(FCueSheetLoopLast);
  LoopLastItem := GetLastChildCueSheetItemByIndex(LoopLastNextMainIndex);

  LoopLastNextMainIndex := GetCueSheetIndexByItem(LoopLastItem) + 1;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('InputLoopEvent, LoopLastNextMainIndex = %d', [LoopLastNextMainIndex])));

{  // ������ Loop Index�� ���� �̺�Ʈ�� ��� ����
  if (ChannelOnAir) then
  begin
    OnAirDeleteEvents(LoopLastNextMainIndex, FLastInputIndex);

    ServerBeginUpdates(ChannelID);
    try
      ServerDeleteCueSheets(ChannelID, LoopLastNextMainIndex, FLastInputIndex);
    finally
      ServerEndUpdates(ChannelID);
    end;
    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('InputLoopEvent, OnAirDeleteEvents LoopLastNextMainIndex = %d, LastInputIndex = %d', [LoopLastNextMainIndex, FLastInputIndex])));
  end; }


  // ������ Loop�� EndTime�� ���� Loop�� StartTime����  ����
//  StartTime := GetEventEndTime(FCueSheetLoopLast^.StartTime, FCueSheetLoopLast^.DurationTC);
//  if (FCueSheetLoopLastStartTime.D = 0) and (FCueSheetLoopLastStartTime.T = 0) then
//  begin
//    FCueSheetLoopLastStartTime  := FCueSheetLoopLast^.StartTime;
//    FCueSheetLoopLastDurationTC := FCueSheetLoopLast^.DurationTC;
//  end;
  LoopAddMainStartTime := GetEventEndTime(FCueSheetLoopLastStartTime, FCueSheetLoopLastDurationTC, ChannelFrameRateType);

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('InputLoopEvent, LoopAddMainStartTime = %s', [EventTimeToString(LoopAddMainStartTime, ChannelFrameRateType)])));

  ChannelCueSheet := GetChannelCueSheetByItem(ALoopItem);
  if (ChannelCueSheet = nil) then exit;

  ClearCueSheetLoopNextList;

  Index := GetCueSheetIndexByItem(ALoopItem);
  for I := Index to FCueSheetList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(I);
    if (Item <> nil) and (Item^.GroupNo = ALoopItem^.GroupNo) then
    begin
      AddItem := New(PCueSheetItem);
      Move(Item^, AddItem^, SizeOf(TCueSheetItem));
      FillChar(AddItem^.EventStatus, SizeOf(TEventStatus), #0);

      Inc(ChannelCueSheet.LastSerialNo);

      if (Item = ALoopItem) then
      begin
        Inc(ChannelCueSheet.LastGroupNo);
        Inc(ChannelCueSheet.LastProgramNo);

        AddItem^.StartTime := LoopAddMainStartTime;
      end;

      AddItem^.EventID.SerialNo := ChannelCueSheet.LastSerialNo;
      AddItem^.GroupNo := ChannelCueSheet.LastGroupNo;
      AddItem^.ProgramNo := ChannelCueSheet.LastProgramNo;

      FCueSheetLoopNextList.Add(AddItem);
    end
    else
      break;
  end;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('InputLoopEvent, Loop add count = %d', [FCueSheetLoopNextList.Count])));

  for I := 0 to FCueSheetLoopNextList.Count - 1 do
  begin
    Result := InputEvent(FCueSheetLoopNextList[I], FCueSheetLoopNextList[0]);
    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('InputLoopEvent, InputEvent ID = %s, Result = %d', [EventIDToString(FCueSheetLoopNextList[I]^.EventID), Result])));
  end;

  // ������ Loop ���� Item�� ã��
  LoopLastNextMainItem := GetCueSheetItemByIndex(LoopLastNextMainIndex);
  if (LoopLastNextMainItem <> nil) then
  begin
    SaveStartTime := LoopLastNextMainItem^.StartTime;

//    // ������ loop ������ �̺�Ʈ �ð��� ������ Loop�� EndTime�� ���� Loop�� ���̸� ���� ������ ����
//    LoopLastNextMainItem^.StartTime := GetEventEndTime(LoopAddMainStartTime, ALoopItem^.DurationTC);

    // loop�� �߰��� �̺�Ʈ �ð����� ����
    LoopLastNextMainItem^.StartTime := LoopAddMainStartTime;

    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('InputLoopEvent, LoopLastNextMainItem StartTime = %s', [EventTimeToString(LoopLastNextMainItem.StartTime, ChannelFrameRateType)])));

    // ������ Loop ������ �̺�Ʈ ������Ʈ
    ResetStartTimeByTime(LoopLastNextMainIndex, SaveStartTime);

    if (ChannelOnAir) then
    begin
      OnAirInputEvents(LoopLastNextMainIndex, GV_SettingOption.MaxInputEventCount);

      ServerBeginUpdates(ChannelID);
      try
        ServerInputCueSheets(ChannelID, LoopLastNextMainIndex, GV_SettingOption.MaxInputEventCount);
      finally
        ServerEndUpdates(ChannelID);
      end;

      Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('InputLoopEvent, OnAirInputEvents LoopLastNextMainIndex = %d, InputCount = %d', [LoopLastNextMainIndex, GV_SettingOption.MaxInputEventCount])));
    end;
  end;

exit;




  if (FCueSheetLoopPrevList = nil) then exit;
  if (FCueSheetLoopNextList = nil) then exit;

//  if (FCueSheetLoopLast = nil) then exit;
  if (ALoopItem = nil) then exit;
  if (ALoopItem^.EventMode <> EM_MAIN) then exit;

  ChannelCueSheet := GetChannelCueSheetByItem(ALoopItem);
  if (ChannelCueSheet = nil) then exit;

  ClearCueSheetLoopPrevList;
  for I := 0 to FCueSheetLoopNextList.Count - 1 do
  begin
    Item := FCueSheetLoopNextList[I];
    if (Item <> nil) then
    begin
      AddItem := New(PCueSheetItem);
      Move(Item^, AddItem^, SizeOf(TCueSheetItem));

      FCueSheetLoopPrevList.Add(AddItem);
    end;
  end;

  // ������ Loop�� EndTime�� ���� Loop�� StartTime����  ����
//  StartTime := GetEventEndTime(FCueSheetLoopLast^.StartTime, FCueSheetLoopLast^.DurationTC);
  LoopAddMainStartTime := GetEventEndTime(FCueSheetLoopLastStartTime, FCueSheetLoopLast^.DurationTC, ChannelFrameRateType);

  // ������ Loop�� �ε����� ����
  // ������ Loop ���� Item�� ã��
  LoopLastNextMainIndex := GetCueSheetIndexByItem(FCueSheetLoopLast);
  Item := GetCueSheetItemByIndex(LoopLastNextMainIndex + 1);
  if (Item <> nil) then
  begin
    SaveStartTime := Item^.StartTime;

    // ������ loop ������ �̺�Ʈ �ð��� ������ Loop�� EndTime�� ���� Loop�� ���̸� ���� ������ ����
    Item^.StartTime := GetEventEndTime(LoopAddMainStartTime, ALoopItem^.DurationTC, ChannelFrameRateType);
    // ������ Loop ������ �̺�Ʈ ������Ʈ
    ResetStartTime(LoopLastNextMainIndex + 1, SaveStartTime);

    if (ChannelOnAir) then
    begin
      OnAirDeleteEvents(LoopLastNextMainIndex + 1, LoopLastNextMainIndex + GV_SettingOption.MaxInputEventCount + 1);
      OnAirInputEvents(LoopLastNextMainIndex + 1, GV_SettingOption.MaxInputEventCount);
    end;
  end;

  ClearCueSheetLoopNextList;

  Index := GetCueSheetIndexByItem(ALoopItem);
  for I := Index to FCueSheetList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(I);
    if (Item <> nil) and (Item^.GroupNo = ALoopItem^.GroupNo) then
    begin
      AddItem := New(PCueSheetItem);
      Move(Item^, AddItem^, SizeOf(TCueSheetItem));
      FillChar(AddItem^.EventStatus, SizeOf(TEventStatus), #0);

      Inc(ChannelCueSheet.LastSerialNo);

      if (Item = ALoopItem) then
      begin
        Inc(ChannelCueSheet.LastGroupNo);
        Inc(ChannelCueSheet.LastProgramNo);

        AddItem^.StartTime := LoopAddMainStartTime;
      end;

      AddItem^.EventID.SerialNo := ChannelCueSheet.LastSerialNo;
      AddItem^.GroupNo := ChannelCueSheet.LastGroupNo;
      AddItem^.ProgramNo := ChannelCueSheet.LastProgramNo;

      FCueSheetLoopNextList.Add(AddItem);
    end
    else
      break;
  end;

  for I := 0 to FCueSheetLoopNextList.Count - 1 do
  begin
    Result := InputEvent(FCueSheetLoopNextList[I]);
  end;

  FCueSheetLoopLastStartTime := LoopAddMainStartTime;//GetEventEndTime(StartTime, FCueSheetLoopLastDurationTC);
end;

procedure TfrmChannel.UpdateLoopCueSheet(ALoopItem: PCueSheetItem);
var
  I, LoopIndex: Integer;
  Item: PCueSheetItem;
begin
  LoopIndex := GetCueSheetIndexByItem(ALoopItem);

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('UpdateLoopCueSheet, LoopIndex = %d', [LoopIndex])));

  for I := 0 to FCueSheetLoopNextList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(LoopIndex);
    FCueSheetLock.Enter;
    try
      Move(FCueSheetLoopNextList[I]^, Item^, SizeOf(TCueSheetItem));
      SetEventStatusColor(Item);
    finally
      FCueSheetLock.Leave;
    end;

    Inc(LoopIndex);
  end;

  LoopIndex := GetCueSheetIndexByItem(ALoopItem);

  DisplayPlayListTimeLine(LoopIndex);

  if (ChannelOnAir) then
  begin
    ServerBeginUpdates(ChannelID);
    try
      ServerInputCueSheets(ChannelID, LoopIndex, FCueSheetLoopNextList.Count);
    finally
      ServerEndUpdates(ChannelID);
    end;
  end;

//  FCueSheetLoopLast := ALoopItem;

  FCueSheetLoopLastStartTime  := ALoopItem^.StartTime;
  FCueSheetLoopLastDurationTC := ALoopItem^.DurationTC;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('UpdateLoopCueSheet, LoopLastStartTime = %s, LoopLastDurationTC = %s', [EventTimeToString(FCueSheetLoopLastStartTime, ChannelFrameRateType), TimecodeToString(FCueSheetLoopLastDurationTC, ChannelIsDropFrame)])));


exit;
  if (FCueSheetLoopLast = nil) then exit;
  if (ALoopItem = nil) then exit;

  LoopIndex := GetCueSheetIndexByItem(ALoopItem);

  for I := 0 to FCueSheetLoopPrevList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(LoopIndex);
    Move(FCueSheetLoopPrevList[I]^, Item^, SizeOf(TCueSheetItem));

    Inc(LoopIndex);
  end;

//  FCueSheetLoopLast := ALoopItem;
end;

function TfrmChannel.DeleteLoopCueSheet: Integer;
var
  I, LoopIndex: Integer;
  Item: PCueSheetItem;
begin
  for I := FCueSheetLoopNextList.Count - 1 downto 0 do
  begin
    Result := DeleteEvent(FCueSheetLoopNextList[I]);
  end;
end;

procedure TfrmChannel.ClearCueSheetLoopItems;
begin
  FCueSheetLoopFirst := nil;
  FCueSheetLoopLast  := nil;
end;

procedure TfrmChannel.CheckCueSheetLoop(AIndex: Integer);
var
  I, J: Integer;
  Item: PCueSheetItem;
begin
  if (AIndex < 0) then exit;

  FCueSheetLoopFirst := nil;
  FCueSheetLoopLast  := nil;

  for I := AIndex to FCueSheetList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(I);
    if (Item <> nil) and (Item^.EventMode = EM_MAIN) and (Item^.StartMode = SM_LOOP) then
    begin
      FCueSheetLoopFirst := Item;
      FCueSheetLoopLast  := Item;

      Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('CheckCueSheetLoop, Find loop first = %s', [EventIDToString(FCueSheetLoopFirst^.EventID)])));

      for J := I + 1 to FCueSheetList.Count - 1 do
      begin
        Item := GetCueSheetItemByIndex(J);
        if (Item <> nil) and (Item^.EventMode = EM_MAIN) then
        begin
          if (Item^.StartMode = SM_LOOP) then
            FCueSheetLoopLast := Item
          else
            break;
        end;
      end;

      Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('CheckCueSheetLoop, Find loop last = %s', [EventIDToString(FCueSheetLoopLast^.EventID)])));
      break;
    end;
  end;

//  FCueSheetLoopLastStartTime := InitEventTime;

  ClearCueSheetLoopNextList;

  if (FCueSheetLoopLast <> nil) then
  begin
    FCueSheetLoopLastStartTime  := FCueSheetLoopLast^.StartTime;
    FCueSheetLoopLastDurationTC := FCueSheetLoopLast^.DurationTC;

    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('CheckCueSheetLoop, LoopLastStartTime = %s, LoopLastDurationTC = %s', [EventTimeToString(FCueSheetLoopLastStartTime, ChannelFrameRateType), TimecodeToString(FCueSheetLoopLastDurationTC, ChannelIsDropFrame)])));
  end;
end;

procedure TfrmChannel.CheckCueSheetLoop(AItem: PCueSheetItem);
var
  Index: Integer;
begin
  Index := GetCueSheetIndexByItem(AItem);
  CheckCueSheetLoop(Index);
end;

procedure TfrmChannel.InsertCueSheet(AEventMode: TEventMode);
var
  SelectIndex: Integer;
  Item, ProgItem: PCueSheetItem;
  DurTime: TEventTime;

  ChannelCueSheet: PChannelCueSheet;
begin
  if (not HasMainControl) then exit;

{  SItem := GetSelectCueSheetItem;
  if (SItem <> nil) then
  begin
    if (SItem^.EventMode in [EM_COMMENT]) then
      PItem := GetNextMainItemByItem(SItem)
    else
      PItem := GetParentCueSheetItemByItem(SItem);
  end
  else
    PItem := nil; }

  SelectIndex := GetSelectCueSheetIndex;
  if (not CheckCueSheetEditPossibleLockTimeByIndex(SelectIndex)) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SENotPossibleEditLockTime), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
    exit;
  end
  else if (not CheckCueSheetEditPossibleLocationByIndex(SelectIndex)) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SENotPossibleEditBeforeLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
    exit;
  end;

  case AEventMode of
    EM_PROGRAM:
    begin
      // ���� ���α׷� �̺�Ʈ�� ã��
      if (SelectIndex < 0) then
      begin
        Item := GetLastProgramItem;
        ProgItem := nil;
      end
      else
      begin
        Item := GetCueSheetItemByIndex(SelectIndex);
        if (Item <> nil) then
        begin
          if (Item^.EventMode in [EM_MAIN, EM_COMMENT]) then
          begin
            ProgItem := GetProgramItemByItem(Item);
            if (ProgItem <> nil) then
            begin
              MessageBeep(MB_ICONWARNING);
              MessageBox(Handle, PChar(SENotInsertProgramLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
              exit;
            end;

//            Item := GetBeforeMainItemByIndex(SelectIndex);
            ProgItem := nil;
          end
          else if (Item^.EventMode <> EM_PROGRAM) then
          begin
            MessageBeep(MB_ICONWARNING);
            MessageBox(Handle, PChar(SENotInsertProgramLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
            exit;
          end
//          else
//            Item := GetBeforeProgramItemByIndex(SelectIndex);
        end;
        ProgItem := nil;
      end;
    end;
    EM_MAIN:
    begin
      // ���� ���� �̺�Ʈ�� ã��
      if (SelectIndex < 0) then
      begin
        Item := GetLastMainItem;
        ProgItem := nil;
      end
      else
      begin
        Item := GetCueSheetItemByIndex(SelectIndex);
        if (Item <> nil) then
        begin
          if (Item^.EventMode = EM_COMMENT) then
          begin
            if (GetParentCueSheetItemByItem(Item) <> nil) then
            begin
              MessageBeep(MB_ICONWARNING);
              MessageBox(Handle, PChar(SENotInsertMainLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
              exit;
            end;
          end
          else if (not (Item^.EventMode in [EM_PROGRAM, EM_MAIN])) then
          begin
            MessageBeep(MB_ICONWARNING);
            MessageBox(Handle, PChar(SENotInsertMainLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
            exit;
          end;
        end;

        ProgItem := GetProgramItemByItem(Item);
        if (Item^.EventMode = EM_PROGRAM) then
        begin
          Item := GetNextMainItemByItem(Item);
          if (Item = nil) then
          begin
            Item := GetLastMainItem;
            SelectIndex := -1;
          end;
        end;
//        Item := GetBeforeMainItemByIndex(SelectIndex);
      end;
    end;
    EM_JOIN,
    EM_SUB:
    begin
      // �θ� �̺�Ʈ�� ã��
{      if (SelectIndex < 0) then
        Item := GetLastMainItem
      else }
        Item := GetParentCueSheetItemByIndex(SelectIndex);

      if (Item = nil) then
      begin
        MessageBeep(MB_ICONWARNING);
        MessageBox(Handle, PChar(SENotInsertJoinSubLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
        exit;
      end;

      ProgItem := GetProgramItemByIndex(SelectIndex);
    end;
    EM_COMMENT:
    begin
      Item := GetCueSheetItemByIndex(SelectIndex);
      ProgItem := GetProgramItemByIndex(SelectIndex);
    end;
    else
      exit;
  end;

  ChannelCueSheet := GetChannelCueSheetByIndex(SelectIndex);

  frmEditEvent := TfrmEditEvent.Create(Self, SelectIndex, EM_INSERT, ChannelCueSheet, AEventMode, Item, ProgItem);
  try
    frmEditEvent.ShowModal;
    if (frmEditEvent.ModalResult = mrOK) then
    begin
      case AEventMode of
        EM_PROGRAM: ExecuteInsertCueSheetProgram(SelectIndex, frmEditEvent.AddItem);
        EM_MAIN: ExecuteInsertCueSheetMain(SelectIndex, frmEditEvent.AddItem);
        EM_JOIN: ExecuteInsertCueSheetJoin(SelectIndex, Item, frmEditEvent.AddItem);
        EM_SUB: ExecuteInsertCueSheetSub(SelectIndex, Item, frmEditEvent.AddItem);
        EM_COMMENT: ExecuteInsertCueSheetComment(SelectIndex, frmEditEvent.AddItem);
        else
          exit;
      end;

      Inc(ChannelCueSheet^.EventCount);
    end;
  finally
    FreeAndNil(frmEditEvent);
  end;
end;

procedure TfrmChannel.ExecuteInsertCueSheetProgram(AIndex: Integer; AAddItem: PCueSheetItem);
begin
  if (not HasMainControl) then exit;

  FCueSheetLock.Enter;
  try
    if (AIndex < 0) then
    begin
      FCueSheetList.Add(AAddItem);
      AIndex := FCueSheetList.Count - 1;
    end
    else
    begin
      FCueSheetList.Insert(AIndex, AAddItem);
    end;
  finally
    FCueSheetLock.Leave;
  end;

  InsertPlayListGridProgram(AIndex);
  SelectRowPlayListGrid(AIndex);

  PopulatePlayListTimeLine(AIndex);

  FLastCount := FCueSheetList.Count;

  if (ChannelOnAir) then
  begin
    ServerBeginUpdates(ChannelID);
    try
      ServerInputCueSheets(ChannelID, AIndex);
    finally
      ServerEndUpdates(ChannelID);
    end;
  end;
end;

procedure TfrmChannel.ExecuteInsertCueSheetMain(AIndex: Integer; AAddItem: PCueSheetItem);
var
  I: Integer;
  Index: Integer;
  Item: PCueSheetItem;
begin
{  if (AIndex < 0) then
  begin
    FChannelCueSheet.CueSheetList.Add(AAddItem);
    AIndex := FChannelCueSheet.CueSheetList.Count - 1;
  end
  else
  begin
    FChannelCueSheet.CueSheetList.Insert(AIndex, AAddItem);

    ResetNo(AIndex + 1, LastDisplayNo);
    ResetStartTimePlus(AIndex + 1, TimecodeToEventTime(AAddItem^.DurationTC));
  end;

  InsertPlayListGridMain(AIndex);
  SelectRowPlayListGrid(AIndex);

  if (FChannelOnAir) then
    OnAirInputEvents(AIndex, GV_SettingOption.MaxInputEventCount);

//  DisplayPlayListGrid(AIndex, 1);
  DisplayPlayListTimeLine(AIndex);

  FLastCount := FChannelCueSheet.CueSheetList.Count; }



  if (not HasMainControl) then exit;

  FCueSheetLock.Enter;
  try
    if (AIndex < 0) then
    begin
      FCueSheetList.Add(AAddItem);
      Index := FCueSheetList.Count - 1;
    end
    else
    begin
      Item := GetCueSheetItemByIndex(AIndex);
      if (Item <> nil) then
      begin
        // Program �̺�Ʈ ��ġ���� �����ϴ� ���� �� ���� ��ġ�� ����
        if (Item^.EventMode = EM_PROGRAM) then
          Index := AIndex + 1
        // Main �̺�Ʈ ��ġ���� �����ϴ� ���� ���� ��ġ�� ����
        else if (Item^.EventMode = EM_MAIN) then
          Index := AIndex
        else
          Index := AIndex;

        FCueSheetList.Insert(Index, AAddItem);

        ResetNo(Index + 1, LastDisplayNo);
        ResetStartTime(Index);// + 1);
  //      ResetStartTimePlus(Index + 1, TimecodeToEventTime(AAddItem^.DurationTC));
      end;
    end;
  finally
    FCueSheetLock.Leave;
  end;

  InsertPlayListGridMain(Index);
  SelectRowPlayListGrid(Index);


//  // DoCueSheetCheck���� �ޤ����� �̺�Ʈ�� Input ó����
  if (FChannelOnAir) and (Index <= FLastInputIndex) then
    OnAirInputEvents(Index, GV_SettingOption.MaxInputEventCount);


//  FLastDisplayNo := GetBeforeMainCountByIndex(Index);

//  DisplayPlayListGrid(Index, 1);

  PopulatePlayListTimeLine(Index);

  FLastCount := FCueSheetList.Count;

  if (FChannelOnAir) and (AAddItem^.StartMode = SM_LOOP) then
    CheckCueSheetLoop(CueSheetCurr);

  if (ChannelOnAir) then
  begin
    ServerBeginUpdates(ChannelID);
    try
      ServerInputCueSheets(ChannelID, Index);
    finally
      ServerEndUpdates(ChannelID);
    end;
  end;
end;

procedure TfrmChannel.ExecuteInsertCueSheetJoin(AIndex: Integer; AParentItem, AAddItem: PCueSheetItem);
var
  I: Integer;
  Index: Integer;
  Item: PCueSheetItem;

  ParentItem: PCueSheetItem;
  ParentIndex: Integer;
begin
{  // Join �̺�Ʈ�� ��� �θ� �̺�Ʈ�� Join �̺�Ʈ�� ������ ��ġ�� ����
  Index := FChannelCueSheet.CueSheetList.IndexOf(AParentItem);

  Inc(Index);
  for I := Index to FCueSheetList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(I);

    if (Item <> nil) then
    begin
      if (AParentItem^.GroupNo <> Item^.GroupNo) then break;
      if (Item^.EventMode in [EM_JOIN, EM_SUB]) then
      begin
        Inc(Index);
      end
      else break;
    end;
  end; }

  if (not HasMainControl) then exit;

  Item := GetCueSheetItemByIndex(AIndex);
  if (Item <> nil) then
  begin
    // Main �̺�Ʈ ��ġ���� �����ϴ� ���� �� ���� ��ġ�� ����
    if (Item^.EventMode = EM_MAIN) then
      Index := AIndex + 1
    else if (Item^.EventMode = EM_JOIN) then
      // Join �̺�Ʈ ��ġ���� �����ϴ� ���� �� ��ġ�� ����
      Index := AIndex
    else if (Item^.EventMode in [EM_SUB]) then
    begin
      // Sub �̺�Ʈ ��ġ���� �����ϴ� ��� ù Sub �̺�Ʈ ��ġ�� ����
      Index := GetCueSheetIndexByItem(AParentItem);

      Inc(Index);
      for I := Index to FCueSheetList.Count - 1 do
      begin
        Item := GetCueSheetItemByIndex(I);

        if (Item <> nil) then
        begin
          if (AParentItem^.GroupNo <> Item^.GroupNo) then break;
          if (Item^.EventMode in [EM_SUB]) then
          begin
            break;
          end;
          Inc(Index);
        end;
      end;
    end
    else
    begin
      // Comment �̺�Ʈ ��ġ���� �����ϴ� ��� ���� Join �̺�Ʈ ���� ��ġ�� ����
      Index := GetCueSheetIndexByItem(AParentItem);

      Inc(Index);
      for I := Index to FCueSheetList.Count - 1 do
      begin
        Item := GetCueSheetItemByIndex(I);

        if (Item <> nil) then
        begin
          if (AParentItem^.GroupNo <> Item^.GroupNo) then break;
          if (Item^.EventMode in [EM_SUB]) then
          begin
            break;
          end;
          if (Index >= AIndex) and (Item^.EventMode in [EM_COMMENT]) then
          begin
            break;
          end;
          Inc(Index);
        end;
      end;
    end;

    FCueSheetLock.Enter;
    try
      FCueSheetList.Insert(Index, AAddItem);
    finally
      FCueSheetLock.Leave;
    end;

    InsertPlayListGridSub(AIndex);
    SelectRowPlayListGrid(Index);


//        // DoCueSheetCheck���� �ޤ����� �̺�Ʈ�� Input ó����
    if (FChannelOnAir) and (Index <= FLastInputIndex) then
      OnAirInputEvents(Index, GV_SettingOption.MaxInputEventCount);


  //  FLastDisplayNo := GetBeforeMainCountByIndex(Index);

  //  DisplayPlayListGrid(Index, 1);

    PopulatePlayListTimeLine(Index);

    FLastCount := FCueSheetList.Count;

    if (ChannelOnAir) then
    begin
      ServerBeginUpdates(ChannelID);
      try
        ServerInputCueSheets(ChannelID, Index);
      finally
        ServerEndUpdates(ChannelID);
      end;
    end;
  end;
end;

procedure TfrmChannel.ExecuteInsertCueSheetSub(AIndex: Integer; AParentItem, AAddItem: PCueSheetItem);
var
  I: Integer;
  Index: Integer;
  Item: PCueSheetItem;
begin
{  // Sub �̺�Ʈ�� ��� ���� �̺�Ʈ�� ���� ��ġ�� ����
  Index := FChannelCueSheet.CueSheetList.IndexOf(AParentItem);

  Inc(Index);
  for I := Index to FCueSheetList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(I);

    if (Item <> nil) then
    begin
      if (AParentItem^.GroupNo <> Item^.GroupNo) then break;
      if (Item^.EventMode in [EM_JOIN, EM_SUB, EM_COMMENT]) then
      begin
        Inc(Index);
      end
      else break;
    end;
  end; }

  if (not HasMainControl) then exit;

  Item := GetCueSheetItemByIndex(AIndex);
  if (Item <> nil) then
  begin
    // Main, Join �̺�Ʈ ��ġ���� �����ϴ� ���� ù Sub ���� ��ġ�� ����
    if (Item^.EventMode in [EM_MAIN, EM_JOIN]) then
    begin
      // Sub �̺�Ʈ ��ġ���� �����ϴ� ��� ù Sub �̺�Ʈ ��ġ�� ����
      Index := GetCueSheetIndexByItem(AParentItem);

      Inc(Index);
      for I := Index to FCueSheetList.Count - 1 do
      begin
        Item := GetCueSheetItemByIndex(I);

        if (Item <> nil) then
        begin
          if (AParentItem^.GroupNo <> Item^.GroupNo) then break;
          if (Item^.EventMode in [EM_SUB]) then
          begin
            break;
          end;
          Inc(Index);
        end;
      end;
    end
    else if (Item^.EventMode = EM_SUB) then
      // Sub �̺�Ʈ ��ġ���� �����ϴ� ���� �� ��ġ�� ����
      Index := AIndex
    else
    begin
      // Comment �̺�Ʈ ��ġ���� �����ϴ� ��� ù Sub �̺�Ʈ ���� �Ʒ� ��ġ�� ���� ��ġ�� ����
      Index := GetCueSheetIndexByItem(AParentItem);

      Inc(Index);
      for I := Index to FCueSheetList.Count - 1 do
      begin
        Item := GetCueSheetItemByIndex(I);

        if (Item <> nil) then
        begin
          if (AParentItem^.GroupNo <> Item^.GroupNo) then break;
          if (Item^.EventMode in [EM_SUB]) then
          begin
            break;
          end;
          Inc(Index);
        end;
      end;

      if (Index <= AIndex) then
        Index := AIndex;
    end;

    FCueSheetLock.Enter;
    try
      FCueSheetList.Insert(Index, AAddItem);
    finally
      FCueSheetLock.Leave;
    end;

    InsertPlayListGridSub(AIndex);
    SelectRowPlayListGrid(Index);


//    // DoCueSheetCheck���� �ޤ����� �̺�Ʈ�� Input ó����
    if (FChannelOnAir) and (Index <= FLastInputIndex) then
      OnAirInputEvents(Index, GV_SettingOption.MaxInputEventCount);


  //  FLastDisplayNo := GetBeforeMainCountByIndex(Index);

  //  DisplayPlayListGrid(Index, 1);

    PopulatePlayListTimeLine(Index);

    FLastCount := FCueSheetList.Count;

    if (ChannelOnAir) then
    begin
      ServerBeginUpdates(ChannelID);
      try
        ServerInputCueSheets(ChannelID, Index);
      finally
        ServerEndUpdates(ChannelID);
      end;
    end;
  end;
end;

procedure TfrmChannel.ExecuteInsertCueSheetComment(AIndex: Integer; AAddItem: PCueSheetItem);
var
  ParentItem: PCueSheetItem;
begin
  if (not HasMainControl) then exit;

  // Comment �̺�Ʈ�� ��� ���� �̺�Ʈ�� ���� ��ġ�� ����
  if (AIndex < 0) then
  begin
    FCueSheetList.Add(AAddItem);
    AIndex := FCueSheetList.Count - 1;
  end
  else
  begin
    FCueSheetList.Insert(AIndex, AAddItem);

//    FLastDisplayNo := GetBeforeMainCountByIndex(AIndex);
  end;

  ParentItem := GetParentCueSheetItemByIndex(AIndex);
  if (ParentItem <> nil) then
    InsertPlayListGridSub(AIndex)
  else
    InsertPlayListGridMain(AIndex);

  SelectRowPlayListGrid(AIndex);

//  if (FChannelOnAir) then
//    OnAirInputEvents(AIndex, GV_SettingOption.MaxInputEventCount);

//  DisplayPlayListGrid(AIndex, 1);

  PopulatePlayListTimeLine(AIndex);

  FLastCount := FCueSheetList.Count;

  if (ChannelOnAir) then
  begin
    ServerBeginUpdates(ChannelID);
    try
      ServerInputCueSheets(ChannelID, AIndex);
    finally
      ServerEndUpdates(ChannelID);
    end;
  end;
end;

procedure TfrmChannel.UpdateCueSheet;
var
  SelectIndex: Integer;
  SelectItem: PCueSheetItem;
  PEndTime, CEndTime, DurTime: TEventTime;

  ChannelCueSheet: PChannelCueSheet;

  SaveSource: String;
  SaveStartTime: TEventTime;
  SaveDurationTC: TTimecode;
begin
  if (not HasMainControl) then exit;

  SelectIndex := GetSelectCueSheetIndex;
  if (SelectIndex < 0) then exit;

  if (not CheckCueSheetEditPossibleLockTimeByIndex(SelectIndex)) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SENotPossibleEditLockTime), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
    exit;
  end
  else if (not CheckCueSheetEditPossibleLocationByIndex(SelectIndex)) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SENotPossibleEditBeforeLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
    exit;
  end;

  SelectItem  := GetCueSheetItemByIndex(SelectIndex);
  if (SelectItem <> nil) and (SelectItem^.EventMode = EM_MAIN) then
    PEndTime := GetEventEndTime(SelectItem^.StartTime, SelectItem^.DurationTC, ChannelFrameRateType);

  ChannelCueSheet := GetChannelCueSheetByIndex(SelectIndex);

  frmEditEvent := TfrmEditEvent.Create(Self, SelectIndex, EM_UPDATE, ChannelCueSheet, SelectItem);
  try
    SaveSource     := String(SelectItem^.Source);
    SaveStartTime  := SelectItem^.StartTime;
    SaveDurationTC := SelectItem^.DurationTC;

    frmEditEvent.ShowModal;
    if (frmEditEvent.ModalResult = mrOK) then
    begin
      if (SaveSource <> String(SelectItem^.Source)) then
        ExecuteUpdateCueSheet(SelectIndex, SelectItem^.EventMode, SaveStartTime, SaveDurationTC, True)
      else
        ExecuteUpdateCueSheet(SelectIndex, SelectItem^.EventMode, SaveStartTime, SaveDurationTC);
    end;
  finally
    FreeAndNil(frmEditEvent);
  end;
end;

procedure TfrmChannel.wmtbTimelineZoomChange(Sender: TObject);
begin
  inherited;
//  TimelineZoomPosition := wmtbTimelineZoom.Position;
end;

procedure TfrmChannel.wmtlPlaylistMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
  Zoom: Integer;
  Pos: Integer;
begin
  inherited;

  if (ssCtrl in Shift) then
  begin
    with wmtlPlaylist.ZoomBarProperty do
    begin
      Zoom := Integer(GV_SettingOption.TimelineZoomType);
      if (WheelDelta > 0) then Inc(Zoom)
      else if (WheelDelta < 0) then Dec(Zoom);

      if (Zoom > Integer(High(TTimelineZoomType))) then Zoom := Integer(High(TTimelineZoomType))
      else if (Zoom < Integer(Low(TTimelineZoomType))) then Zoom := Integer(Low(TTimelineZoomType));

      GV_SettingOption.TimelineZoomType := TTimelineZoomType(Zoom);
      frmSEC.SetZoomPosition(frmSEC.GetPositionByZoomType(GV_SettingOption.TimelineZoomType));
    end;
  end
  else
  begin
    with wmtlPlaylist do
    begin
      Pos := DataVertScroll.ScrollPosition;

      Dec(Pos, WheelDelta);

      DataVertScroll.ScrollPosition := Pos;

{      Pos := FrameNumber;
      if (WheelDelta > 0) then Dec(Pos)
      else if (WheelDelta < 0) then Inc(Pos);

      if (Pos > MaxFrameNumber) then Pos := MaxFrameNumber
      else if (Pos < 0) then Pos := 0;

      FrameNumber := Pos; }
    end;
  end;
  Handled := True;
end;

procedure TfrmChannel.wmtlPlaylistTrackCustomDrawEvent(Sender: TObject;
  ATrack: TTrack; ACanvas: TCanvas; ARect: TRect; var ACustomDraw: Boolean);
var
  R: TRect;
  Item: PCueSheetItem;
  BkColor, TxColor, ToColor: TColor;
  BkPicture: TPicture;
  Index: Integer;
  W, H: Integer;
  Caption: String;
  Flags: DWORD;
begin
  inherited;

  if (ATrack = nil) then exit;

  ACustomDraw := True;

  if (ATrack.Data <> nil) then
  begin
    BkPicture := GV_TimelineNormalIcon;

    BkColor := COLOR_BK_EVENTSTATUS_NORMAL;
    TxColor := clWhite;//COLOR_TX_EVENTSTATUS_NORMAL;
    ToColor := COLOR_TO_EVENTSTATUS_NORMAL;

    Caption := '';

    Item := ATrack.Data;
    if (Item <> nil) then
    begin
      BkColor := Item^.BkColor;
      TxColor := clWhite;//Item^.TxColor;
      ToColor := Item^.ToColor;

      case Item^.EventStatus.State of
        esCueing..esPreroll:
          BkPicture := GV_TimelineNextIcon;
        esOnAir:
          BkPicture := GV_TimelineOnairIcon;
        else
          BkPicture := GV_TimelineNormalIcon;
      end;

      Caption := String(Item^.Title);
    end;
  end;

  if (BkColor = COLOR_BK_EVENTSTATUS_NORMAL) then
  begin
    BkColor := $004F3B35;
  end;

{    Item := GetParentCueSheetItemByItem(Item);
    if (Item <> nil) then
    begin
      if (FCueSheetCurr <> nil) and (Item^.GroupNo = FCueSheetCurr.GroupNo) then
      begin
        TopColor  := COLOR_TIMELINE_PLAY_TOP;
        BodyColor := COLOR_TIMELINE_PLAY_BODY;
        BackPicture := GV_TimelinePlayIcon;
      end
      else if (FCueSheetNext <> nil) and (Item^.GroupNo = FCueSheetNext.GroupNo) then
      begin
        TopColor  := COLOR_TIMELINE_NEXT_TOP;
        BodyColor := COLOR_TIMELINE_NEXT_BODY;
        BackPicture := GV_TimelineNextIcon;
      end
      else
      begin
        TopColor  := COLOR_TIMELINE_NORMAL_TOP;
        BodyColor := COLOR_TIMELINE_NORMAL_BODY;
        BackPicture := GV_TimelineNormalIcon;
      end;
    end; }

  R := ARect;
  R.Bottom := ARect.Top + GV_ChannelTimelineTrackTopHeight;

  ACanvas.Brush.Color := ToColor;
  ACanvas.FillRect(R);

  R := ARect;
  R.Top := ARect.Top + GV_ChannelTimelineTrackTopHeight;

  ACanvas.Brush.Color := BkColor;
  ACanvas.FillRect(R);

  W := 0;
  H := 0;
  if (BkPicture <> nil) and (BkPicture.Graphic <> nil) then
  begin
    R := ARect;
    InflateRect(R, -2, -2);

{    R.Right := R.Left + BkPicture.Width;
    R.Top := R.Top + (R.Height - BkPicture.Height) div 2;

    ACanvas.Draw(R.Left, R.Top, BkPicture.Graphic); }

    H := R.Height - GV_ChannelTimelineTrackTopHeight * 2;
    W := Round(BkPicture.Width * (H / BkPicture.Height));

    R.Right := R.Left + W;
    R.Top := R.Top + GV_ChannelTimelineTrackTopHeight;
    R.Bottom := R.Top + H;

    ACanvas.StretchDraw(R, BkPicture.Graphic);

{      W := R.Width;
    H := R.Height;

    if (W < BackPicture.Width) then
    begin
      H := Trunc(BackPicture.Height * W / BackPicture.Width);
      W := Trunc(BackPicture.Width * H / BackPicture.Height);
    end
    else
    begin
      W :=  BackPicture.Width;
    end;

    if (H < BackPicture.Height) then
    begin
      W := Trunc(BackPicture.Width * H / BackPicture.Height);
      H := Trunc(BackPicture.Height * W / BackPicture.Width);
    end
    else
    begin
      H :=  BackPicture.Height;
    end;

    R.Right := R.Left + W;
    R.Top := R.Top + (R.Height - H) div 2;
    R.Bottom := R.Top + H;//(R.Height - H) div 2;

    ACanvas.StretchDraw(R, BackPicture.Graphic); }
  end;

  // Caption
  ACanvas.Font.Assign(ATrack.Font);
  ACanvas.Font.Color := TxColor;
  ACanvas.Brush.Style := bsClear;

  R := ARect;
  InflateRect(R, -2, -2);
//  R.Left := R.Left + W + 2;

  Flags := DT_SINGLELINE or DT_LEFT or DT_VCENTER or DT_END_ELLIPSIS;
  DrawText(ACanvas.Handle, ATrack.Caption, Length(ATrack.Caption), R, Flags);

  R := ARect;
  // Left bar
//  DrawBlendLine(ACanvas, R.Left, R.Top, 1, R.Bottom - R.Top, wmtlPlaylist.CompositionBarProperty.LineVertColor, 0.3);
  DrawBlendLine(ACanvas, R.Left, R.Top, 1, R.Bottom - R.Top, clWhite, 0.3);
//  ACanvas.Pen.Color := wmtlPlaylist.CompositionBarProperty.LineHorzColor;
//  ACanvas.MoveTo(R.Left, R.Top);
//  ACanvas.LineTo(R.Left, R.Bottom);

  // Right Bar
  ACanvas.Pen.Color := wmtlPlaylist.CompositionBarProperty.LineVertColor;
  ACanvas.MoveTo(R.Right - 1, R.Top);
  ACanvas.LineTo(R.Right - 1, R.Bottom);
end;

procedure TfrmChannel.wmtlPlaylistTrackHintEvent(Sender: TObject; Track: TTrack;
  var HintStr: string);
var
  ProgItem: PCueSheetItem;
  Item, ParentItem: PCueSheetItem;
  StartTime, EndTime: TEventTime;
begin
  inherited;
  if (Track.Data <> nil) then
  begin
    Item := Track.Data;

    case Item^.EventMode of
      EM_PROGRAM:
      begin
        HintStr := String(Item^.Title);
        exit;
      end;
      EM_MAIN:
      begin
        StartTime := Item^.StartTime;
        EndTime   := GetEventEndTime(Item^.StartTime, Item^.DurationTC, ChannelFrameRateType);
      end;
      EM_JOIN:
      begin
        ParentItem := GetParentCueSheetItemByItem(Item);
        if (ParentItem <> nil) then
        begin
          StartTime := ParentItem^.StartTime;
          EndTime   := GetEventEndTime(StartTime, Item^.DurationTC, ChannelFrameRateType);
        end
        else
          exit;
      end;
      EM_SUB:
      begin
        ParentItem := GetParentCueSheetItemByItem(Item);
        if (ParentItem <> nil) then
        begin
          if (Item^.StartMode = SM_SUBBEGIN) then
          begin
            StartTime := GetEventTimeSubBegin(ParentItem^.StartTime, Item^.StartTime.T, ChannelFrameRateType);
            EndTime   := GetEventEndTime(StartTime, Item^.DurationTC, ChannelFrameRateType);
          end
          else
          begin
            StartTime := GetEventTimeSubEnd(ParentItem^.StartTime, ParentItem^.DurationTC, Item^.StartTime.T, ChannelFrameRateType);
            EndTime   := GetEventEndTime(StartTime, Item^.DurationTC, ChannelFrameRateType);
          end;
        end
        else
          exit;
      end;
      else
        exit;
    end;

    HintStr := Format('%s'#13#10'%s'#13#10'Start: %s'#13#10'End: %s'#13#10'Duration: %s',
                      [String(Item^.Title),
                       String(Item^.SubTitle),
                       TimecodeToString(StartTime.T, ChannelIsDropFrame),
                       TimecodeToString(EndTime.T, ChannelIsDropFrame),
                       TimecodeToString(Item^.DurationTC, ChannelIsDropFrame)]);

    ProgItem := GetProgramItemByItem(Item);
    if (ProgItem <> nil) then
      HintStr := String(ProgItem^.Title) + #13#10 + HintStr;
  end;
end;

procedure TfrmChannel.ExecuteUpdateCueSheet(AIndex: Integer; AEventMode: TEventMode; ASaveStartTime: TEventtime; ASaveDurationTC: TTimecode; ASourceChanged: Boolean);
var
  Item, CItem: PCueSheetItem;
  ResetStartTime: TEventTime;
  ChildCount: Integer;
  I: Integer;
begin
  if (not HasMainControl) then exit;

//  FLastDisplayNo := GetBeforeMainCountByIndex(AIndex);

  if (AEventMode = EM_MAIN) then
  begin
{    ResetStartTimeByTime(AIndex, ASaveStartTime, ASaveDurationTC);
    acgPlaylist.Repaint; }
//    ResetChildItems(AIndex);

{    Item := GetCueSheetItemByIndex(AIndex);
    ResetStartTime := Item^.StartTime;


    // Change only date
    Item^.StartTime := ASaveStartTime;
{    Item^.StartTime.D := ResetStartTime.D;

    ResetStartTimeByTime(AIndex, ASaveStartTime);


    // Change time and duration
    ASaveStartTime := Item^.StartTime;
    Item^.StartTime.T := ResetStartTime.T;  }

//    Item^.StartTime := ResetStartTime;

    Item := GetCueSheetItemByIndex(AIndex);
    if (Item <> nil) then
    begin
      ChildCount := GetChildCountByItem(Item);

      for I := AIndex + 1 to AIndex + ChildCount do
      begin
        CItem := GetCueSheetItemByIndex(I);
        if (CItem <> nil) and (CItem^.EventMode = EM_JOIN) then
        begin
          CItem^.DurationTC := Item^.DurationTC;
          CItem^.InTC       := Item^.InTC;
          CItem^.OutTC      := Item^.OutTC;
        end;
      end;
    end;

    ResetStartTimeByTime(AIndex, ASaveStartTime, ASaveDurationTC);

    acgPlaylist.Repaint;

    if (FChannelOnAir) and (Item^.EventMode = EM_MAIN) and (Item^.StartMode = SM_LOOP) then
      CheckCueSheetLoop(CueSheetCurr);
 end;

  if (FChannelOnAir) and (AIndex <= FLastInputIndex) then
  begin
    // If source changed then onair event delete process
    if (ASourceChanged) then
    begin
      OnAirDeleteEvents(AIndex, FLastInputIndex);
    end;


//        // DoCueSheetCheck���� �ޤ����� �̺�Ʈ�� Input ó����
    OnAirInputEvents(AIndex, GV_SettingOption.MaxInputEventCount);

  end;

//  DisplayPlayListGrid(AIndex);

  PopulatePlayListTimeLine(AIndex);

//  FLastCount := FChannelCueSheet.CueSheetList.Count - 1;

  if (ChannelOnAir) then
  begin
    ServerBeginUpdates(ChannelID);
    try
      ServerInputCueSheets(ChannelID, AIndex);
    finally
      ServerEndUpdates(ChannelID);
    end;
  end;
end;

procedure TfrmChannel.DeleteCueSheet;
var
  DeleteCount: Integer;
  DeleteList: TCueSheetList;

  function GetMessageString: String;
  var
    I: Integer;
    Flag: Boolean;
    SItem: PCueSheetItem;
  begin
    Result := SQDeleteEvent + #13#10;

    with acgPlaylist do
    begin
      Flag := False;
      for I := 0 to DeleteList.Count - 1 do
      begin
        if (I < 5) or
           ((DeleteList.Count > 10) and (I >= DeleteList.Count - 5)) or
           (DeleteList.Count <= 10) then
        begin
          SItem := DeleteList[I];
          if (SItem <> nil) then
          begin
            case SItem^.EventMode of
              EM_COMMENT:
                Result := Result + #13#10 +
                          Format('%d %s %s', [SItem^.DisplayNo + 1,
                                              EventModeShortNames[SItem^.EventMode],
                                              String(SItem^.Title)]);
              EM_PROGRAM:
                Result := Result + #13#10 +
                          Format('%s %s', [EventModeShortNames[SItem^.EventMode],
                                           String(SItem^.Title)]);
              else
                Result := Result + #13#10 +
                          Format('%d %s %s-%s', [SItem^.DisplayNo + 1,
                                                 EventModeShortNames[SItem^.EventMode],
                                                 String(SItem^.Title),
                                                 String(SItem^.SubTitle)]);
            end;
{            case DItem^.EventMode of
              EM_MAIN:
                Result := Result + #13#10 +
                          Format('%s %s-%s', [AllCells[IDX_COL_CUESHEET_NO, RRow],
                                              String(DItem^.Title),
                                              String(DItem^.SubTitle)]);
              else
                Result := Result + #13#10 +
                          Format('%s %s-%s', [EventModeShortNames[DItem^.EventMode],
                                              String(DItem^.Title),
                                              String(DItem^.SubTitle)]);
            end; }
          end;
        end;

        if (DeleteList.Count > 10) and (I > 4) and (not Flag) then
        begin
          Result := Result + #13#10#13#10 + '  ��  ' + #13#10;
          Flag := True;
        end;
      end;
    end;
  end;

begin
  if (not HasMainControl) then exit;

  if (FCueSheetList = nil) then exit;
  if (FCueSheetList.Count = 0) then exit;

  DeleteList := TCueSheetList.Create;
  try
    DeleteCount := GetDeleteCueSheetList(DeleteList);
    if (DeleteList.Count = 0) then exit;

    MessageBeep(MB_ICONQUESTION);
    if (MessageBox(Handle, PChar(GetMessageString), PChar(Application.Title), MB_OKCANCEL or MB_ICONQUESTION or MB_TOPMOST) = ID_OK) then
    begin
      ExecuteDeleteCueSheet(DeleteList);
    end;
  finally
    DeleteList.Clear;
    FreeAndNil(DeleteList);
  end;
end;

procedure TfrmChannel.ExecuteDeleteCueSheet(ADeleteList: TCueSheetList);
var
  FirstIndex: Integer;
  I: Integer;

  CompMainItem: PCueSheetItem;

  ParentItem: PCueSheetItem;
  ParentStartDate: TDate;
  ParentEndTime: TEventTime;
  ParentDisplayNo: Integer;

  ParentRow: Integer;
  ParentSpan: Integer;

  DurTime: TEventTime;

  Item: PCueSheetItem;
  Index: Integer;

  StartTime: TEventTime;
  DisplayNo: Integer;

  RemoveRowList: TList<Integer>;

  ChannelCueSheet: PChannelCueSheet;

  SelectedRow: Integer;
begin
  if (not HasMainControl) then exit;

  if (ADeleteList = nil) then exit;

  Screen.Cursor := crHourGlass;
  try
    SelectedRow := acgPlaylist.Row;
    SelectRowPlayListGrid(0);

    FirstIndex := GetCueSheetIndexByItem(ADeleteList.First);

    if (ADeleteList.First^.EventMode = EM_PROGRAM) then
    begin
      // ���α׷� �̺�Ʈ�� ���� �ִ� MAIN �̺�Ʈ�� ����
      CompMainItem := GetProgramMainItemByIndex(FirstIndex);
      // ���α׷��� MAIN �̺�Ʈ�� ������ MAIN �̺�Ʈ�� Display No�� ����
      if (CompMainItem <> nil) then
      begin
        DisplayNo := CompMainItem^.DisplayNo - 1;
      end
      else
      begin
        // ���α׷��� MAIN �̺�Ʈ�� ������ ���� MAIN �̺�Ʈ�� ����
        CompMainItem := GetNextMainItemByIndex(FirstIndex);
        // ���� MAIN �̺�Ʈ�� ������ ���� MAIN �̺�Ʈ�� Display No�� ����
        if (CompMainItem <> nil) then
        begin
          DisplayNo := CompMainItem^.DisplayNo - 1;
        end
        else
        begin
          // ���� MAIN �̺�Ʈ�� ������ ������ MAIN �̺�Ʈ�� ����
          CompMainItem := GetLastMainItem;
          // ������  MAIN �̺�Ʈ�� ������ ������ MAIN �̺�Ʈ�� Display No�� ����
          if (CompMainItem <> nil) then
          begin
            DisplayNo := CompMainItem^.DisplayNo;
          end
          else
          begin
            // ������  MAIN �̺�Ʈ�� ������ Display No�� �ʱ�ȭ
            DisplayNo := -1;
          end;
        end;
      end;
    end
    else if (ADeleteList.First^.EventMode = EM_MAIN) then
      DisplayNo := ADeleteList.First^.DisplayNo - 1
    else
      DisplayNo := ADeleteList.First^.DisplayNo;

    DurTime.D := 0;
    DurTime.T := 0;

    ParentItem := nil;
    ParentStartDate := 0;

  //  ParentDisplayNo := DisplayNo;
    for I := FirstIndex to FCueSheetList.Count - 1 do
    begin
      Item := GetCueSheetItemByIndex(I);
      if (Item <> nil) then
      begin
        if (ADeleteList.IndexOf(Item) >= 0) then
        begin
          if (Item^.EventStatus.State in [esIdle..esLoaded, esDone, esSkipped]) then
          begin
            if (Item^.EventMode = EM_MAIN) then
              DurTime := GetPlusEventTime(DurTime, TimecodeToEventTime(Item^.DurationTC), ChannelFrameRateType);
          end;
        end
        else
        begin
          if (Item^.EventMode <> EM_COMMENT) then
          begin
            // If then main event then checks whether the current start time is less than the start time of the previous event.
            if (Item^.EventMode = EM_MAIN) then
            begin
              StartTime := GetMinusEventTime(Item^.StartTime, DurTime, ChannelFrameRateType);
      //          ShowMessage(EventTimeToDateTimecodeStr(CStartTime));
    {          if (ParentItem <> nil) then
              begin
                ParentEndTime := GetEventEndTime(ParentItem^.StartTime, ParentItem^.DurationTC);
                if (CompareEventTime(StartTime, ParentEndTime) < 0) then
                begin
                  StartTime := ParentEndTime;
                end;
              end;  }
              ParentItem := Item;

              ParentStartDate := StartTime.D;

              Item^.StartTime := StartTime;


              Inc(DisplayNo);
              Item^.DisplayNo := DisplayNo;
    //          ParentDisplayNo := Item^.DisplayNo;
            end
            else
            begin
              Item^.StartTime.D := ParentStartDate;
              Item^.DisplayNo   := DisplayNo;
            end;


    {        if (Item^.EventMode = EM_MAIN) then
            begin
              acgPlaylist.AllCells[IDX_COL_CUESHEET_START_DATE, I + CNT_CUESHEET_HEADER] := FormatDateTime(FORMAT_DATE, NextItem^.StartTime.D);
            end;

            if (Item^.EventMode in [EM_MAIN, EM_SUB]) then
            begin
              acgPlaylist.AllCells[IDX_COL_CUESHEET_START_TIME, I + CNT_CUESHEET_HEADER] := TimecodeToString(NextItem^.StartTime.T);
            end; }
          end;
        end;
      end;
    end;

    acgPlaylist.BeginUpdate;
    wmtlPlaylist.BeginUpdateCompositions;

    if (ChannelOnAir) then
      ServerBeginUpdates(ChannelID);

    RemoveRowList := TList<Integer>.Create;
    try
{      // Delete row node expand
      for I := 0 to ADeleteList.Count - 1 do
      begin
        Item := ADeleteList[I];
        if (Item <> nil) and (Item^.EventMode = EM_MAIN) then
        begin
          Index := GetCueSheetIndexByItem(Item) + CNT_CUESHEET_HEADER;
//          Index := acgPlaylist.DisplRowIndex(Index);
          acgPlaylist.ExpandNode(Index);
        end;
      end;
//      exit; }

      // Delete Timeline item & Delete row list
      for I := ADeleteList.Count - 1 downto 0 do
      begin
        Item := ADeleteList[I];
        if (Item <> nil) and (Item^.EventStatus.State in [esIdle..esLoaded, esDone, esSkipped]) then
        begin
          Index := GetCueSheetIndexByItem(Item);
          if (FChannelOnAir) then
          begin
            DeleteEvent(Item);
            if (CueSheetNext = Item) then
              CueSheetNext := nil;
          end;

{          // Delete nodes
          if not (acgPlaylist.IsHiddenRow(Index + CNT_CUESHEET_HEADER)) then
          begin
            ParentRow := acgPlaylist.GetParentRow(acgPlaylist.DisplRowIndex(Index + CNT_CUESHEET_HEADER));

            if (ParentRow >= 0) then
            begin
              acgPlaylist.ExpandNode(ParentRow);
              acgPlaylist.UpdateNodeSpan(ParentRow, - 1);
              acgPlaylist.UpdateSubNodeCount(ParentRow, - 1);
              ParentSpan := acgPlaylist.GetNodeSpan(ParentRow);
              if (ParentSpan <= 1) then
                acgPlaylist.RemoveNode(acgPlaylist.RealRowIndex(ParentRow));
            end;
          end; }
          RemoveRowList.Add(Index);

{          if (Item^.EventMode = EM_PROGRAM) then
            DeletePlayListGridProgram(Index)
          else if (Item^.EventMode = EM_MAIN) then
            DeletePlayListGridMain(Index)
          else if (Item^.EventMode in [EM_JOIN, EM_SUB]) then
            DeletePlayListGridSub(Index)
          else
          begin
            ParentItem := GetParentCueSheetItemByIndex(Index);
            if (ParentItem <> nil) then
              DeletePlayListGridSub(Index)
            else
              DeletePlayListGridMain(Index);
          end; }


          DeletePlayListTimeLineByItem(Item);

{          ChannelCueSheet := GetChannelCueSheetByItem(Item);
          Dec(ChannelCueSheet^.EventCount);
          FCueSheetList.Remove(Item);

          Dispose(Item); }
        end;
      end;

      // Delete rows
      for I := 0 to RemoveRowList.Count - 1 do //downto 0 do
      begin
        DeletePlayListGridMain(RemoveRowList[I]);
      end;

      if (ChannelOnAir) then
        ServerDeleteCueSheets(ChannelID, ADeleteList);

      // Delete event items
      for I := ADeleteList.Count - 1 downto 0 do
      begin
        Item := ADeleteList[I];

        ChannelCueSheet := GetChannelCueSheetByItem(Item);
        Dec(ChannelCueSheet^.EventCount);

        FCueSheetLock.Enter;
        try
          FCueSheetList.Remove(Item);

          Dispose(Item);
        finally
          FCueSheetLock.Leave;
        end;
      end;

    //    acgPlayList.RemoveRowList(RemoveList);
    //    acgPlaylist.RemoveSelectedRows;
      if (FChannelOnAir) and (FirstIndex < FLastInputIndex) then
        OnAirInputEvents(FirstIndex, GV_SettingOption.MaxInputEventCount);

      Item := GetLastMainItem;
      if (Item <> nil) then
        FLastDisplayNo := Item.DisplayNo
      else
        FLastDisplayNo := -1;

    //  DisplayPlayListGrid(FirstIndex, -ADeleteList.Count);

      if (not ChannelOnair) then
      begin
        CalcuratePlayListTimeLineRange;
        UpdatePlayListTimeLineRange;
      end;
      DisplayPlayListTimeLine(FirstIndex);

      SelectRowPlayListGrid(FirstIndex);

      if (ChannelOnAir) then
      begin
        ServerInputCueSheets(ChannelID, FirstIndex);
//        ShowMessage(IntToStr(FirstIndex));
      end;

    finally
      FreeAndNil(RemoveRowList);
      acgPlaylist.EndUpdate;
      wmtlPlaylist.EndUpdateCompositions;

      if (ChannelOnAir) then
        CheckCueSheetLoop(CueSheetCurr);

      if (ChannelOnAir) then
        ServerEndUpdates(ChannelID);
    end;

    FLastCount := FCueSheetList.Count;
  finally
    SelectRowPlayListGrid(SelectedRow);
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmChannel.InspectCueSheet;
var
  CurrTime: TDateTime;
  BaseItem: PCueSheetItem;
  BaseIndex: Integer;

  I: Integer;

  Index: Integer;
  Item: PCueSheetItem;
  WarningText: String;

  WarningStrLen: Integer;
//  WarningStr: PChar;

  WarningStrParam: DWORD;
begin
  FInspectThread.Inspect;
  exit;


  if (not HasMainControl) then exit;

  // ���� �ð�
  CurrTime := Now;

  // ���� �ð� ������ �̺�Ʈ ���� �˻�
  BaseItem := GetMainItemByStartTime(Index, CurrTime);
  if (BaseItem = nil) then exit;

  BaseIndex := GetCueSheetIndexByItem(BaseItem);

  for I := BaseIndex to FCueSheetList.Count - 1 do

  // �ð� ���� �˻�








  if (not ChannelOnAir) then exit;

  if (CueSheetCurr <> nil) then
    Index := GetCueSheetIndexByItem(CueSheetCurr)
  else if (CueSheetNext <> nil) then
    Index := GetCueSheetIndexByItem(CueSheetNext)
  else
    Index := 0;

  Item := GetMainItemByStartTime(Index, IncMilliSecond(Now, TimecodeToMilliSec(GV_SettingTimeParameter.BlankCheckTime, FR_30)));
  if (Item = nil) then
  begin
//    if (FBlankCheckThread.FWarningDialog = nil) or (not FBlankCheckThread.FWarningDialog.Showing) then
    begin
      WarningText := Format(SWNotExistNextEvent, [GetChannelNameByID(ChannelID)]);

      WarningStrLen := Length(WarningText) + 1;
//      WarningStr := StrAlloc(WarningStrLen);
//      StrPLCopy(WarningStr, WarningText);

      WarningStrParam := GlobalAddAtom(PChar(WarningText));
      System.Classes.TThread.CreateAnonymousThread(
        procedure
        begin
//          PostMessage(Handle, WM_WARNING_DISPLAY_NOT_EXIST_EVENT, WarningStrLen, LParam(WarningStr));
          PostMessage(Handle, WM_WARNING_DISPLAY_NOT_EXIST_EVENT, WarningStrLen, WarningStrParam);
        end).Start;
    end;

    exit;
  end;


{  if (not HasMainControl) then exit;

  if (FCueSheetList.Count = 0) then exit;

  FMediaCheckThread.MediaCheck;
//  frmSEC.DCSMediaThread.MediaCheck;   }
end;

procedure TfrmChannel.SourceExchangeCueSheet;
var
  I, R: Integer;
  StartIndex, CurrIndex, NextIndex: Integer;
  Item, MItem, JItem: PCueSheetItem;
  SourceName: String;
begin
  if (not HasMainControl) then exit;

  StartIndex := acgPlaylist.RealRow - CNT_CUESHEET_HEADER;
  Item := GetParentCueSheetItemByIndex(StartIndex);

  if (Item = nil) then exit;

  StartIndex := GetCueSheetIndexByItem(Item);

  if (StartIndex < 0) then exit;

  CurrIndex := GetCueSheetIndexByItem(CueSheetCurr);
  NextIndex := GetCueSheetIndexByItem(CueSheetNext);
  if (CurrIndex >= 0) then
  begin
    if (StartIndex < CurrIndex) then
    begin
//      ShowMessage(Format('%d, %d', [CurrIndex, StartIndex]));
      MessageBeep(MB_ICONWARNING);
      MessageBox(Handle, PChar(SESourceExchangeLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
      exit;
    end;
  end
  else if (NextIndex >= 0) then
  begin
    if (StartIndex < NextIndex) then
    begin
      MessageBeep(MB_ICONWARNING);
      MessageBox(Handle, PChar(SESourceExchangeLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
      exit;
    end;
  end;

  MessageBeep(MB_ICONQUESTION);
  R := MessageBox(Handle, PChar(Format(SQSourceExchange, [Item^.Title])), PChar(Application.Title), MB_YESNO or MB_ICONQUESTION);
  if (R <> IDYES) then exit;

//  ExecuteSourceExchange(StartIndex);

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SourceExchangeCueSheet, StartIndex = %d', [StartIndex])));

  PostMessage(Handle, WM_EXECUTE_SOURCE_EXCHANGE, 0, StartIndex);
end;

procedure TfrmChannel.MainErrorSourceExchange(ASource: PSource);
var
  I, R: Integer;
  StartIndex, CurrIndex, NextIndex: Integer;
  Item, MItem, JItem: PCueSheetItem;
  SourceName: String;
begin
  if (not HasMainControl) then exit;

  if (ASource = nil) then exit;

  if (CueSheetCurr <> nil) then
    StartIndex := GetCueSheetIndexByItem(CueSheetCurr)
  else if (CueSheetNext <> nil) then
    StartIndex := GetCueSheetIndexByItem(CueSheetNext)
  else
    exit;

  if (StartIndex < 0) then exit;

  Item := GetParentCueSheetItemByIndex(StartIndex);
  if (Item = nil) then exit;
  if (Item^.EventMode <> EM_MAIN) then exit;
  if (Item^.Input <> IT_MAIN) then exit;
  if (String(Item^.Source) <> (ASource^.Name)) then exit;

//  ExecuteSourceExchange(StartIndex);

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('MainErrorSourceExchange, Source = %s, StartIndex = %d', [String(ASource^.Name), StartIndex])));

  PostMessage(Handle, WM_EXECUTE_SOURCE_EXCHANGE, 0, StartIndex);



  exit;

  StartIndex := acgPlaylist.RealRow - CNT_CUESHEET_HEADER;
  Item := GetParentCueSheetItemByIndex(StartIndex);

  if (Item = nil) then exit;

  if (String(Item^.Source) <> (ASource^.Name)) then exit;

  StartIndex := GetCueSheetIndexByItem(Item);

  if (StartIndex < 0) then exit;

  ExecuteSourceExchange(StartIndex);
end;

procedure TfrmChannel.ExecuteSourceExchange(AIndex: Integer);
var
  I, J, K: Integer;
  Item: PCueSheetItem;
  MItem, JItem: PCueSheetItem;

  EventID: TEventID;
  Source: PSource;
  SourceName: String;

  SourceChanged: Boolean;
  SourceXpt: Integer;

  MCSSource: PSource;
  MCSSourceHandles: TSourceHandleList;
  MCSSourceHandle: PSourceHandle;

  R: Integer;
begin
  if (not HasMainControl) then exit;

//  if (ChannelOnAir) then
//  begin
//    OnAirDeleteEvents(AIndex, FLastInputIndex);
//
//
//{    ServerBeginUpdates(ChannelID);
//    try
//      ServerDeleteCueSheets(ChannelID, AIndex, AIndex + GV_SettingOption.MaxInputEventCount);
//    finally
//      ServerEndUpdates(ChannelID);
//    end; }
//  end;

  SourceChanged := False;

  for I := AIndex to FCueSheetList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(I);
    if (Item <> nil) then
    begin
      if (Item^.EventMode = EM_MAIN) and (Item^.Input = IT_MAIN) then
      begin
        MItem := Item;
      end
      else if (MItem <> nil) and (Item^.EventMode = EM_JOIN) and (Item^.Input = IT_BACKUP) then
      begin
        JItem := Item;

        Move(MItem^.EventID, EventID, SizeOf(TEventID));
        SourceName := String(MItem^.Source);

        Move(JItem^.EventID, MItem^.EventID, SizeOf(TEventID));
        Move(EventID, JItem^.EventID, SizeOf(TEventID));

        StrCopy(MItem^.Source, JItem^.Source);
        StrPLCopy(JItem^.Source, SourceName, DEVICENAME_LEN);

        Source := GetSourceByName(String(MItem^.Source));
        if (not SourceChanged) and (Source <> nil) and (Source^.MakeTransition) then
        begin
          SourceChanged := True;

          for J := 0 to GV_MCSList.Count - 1 do
          begin
            MCSSource := GetSourceByName(String(GV_MCSList[J]^.Name));
            if (MCSSource = nil) then continue;

            if (MCSSource^.Channel^.ID <> FChannelID) then continue;

            SourceXpt := GetSourceXptByName(MCSSource^.Router, String(MItem^.Source));

            MCSSourceHandles := MCSSource^.Handles;
            if (MCSSourceHandles = nil) or (MCSSourceHandles.Count <= 0) then continue;

            for K := 0 to MCSSourceHandles.Count - 1 do
            begin
              MCSSourceHandle := MCSSourceHandles[K];
              if (MCSSourceHandle^.DCS <> nil) and (MCSSourceHandle^.DCS^.Alive) and
                 (MCSSourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
              begin
                R := frmSEC.DCSEventThread.SetXpt(MCSSourceHandle, SourceXpt);
    {            if (R = D_OK) then
                begin
                  R := D_OK;
                end;  }
              end;
            end;
          end;
        end;
      end
      else continue;
    end;
  end;

  if (ChannelOnAir) then
  begin
    OnAirInputEvents(AIndex, GV_SettingOption.MaxInputEventCount);

    ServerBeginUpdates(ChannelID);
    try
      ServerInputCueSheets(ChannelID, AIndex);
    finally
      ServerEndUpdates(ChannelID);
    end;
  end;

  acgPlaylist.Repaint;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('ExecuteSourceExchange, Index = %d', [AIndex])));
end;

procedure TfrmChannel.CopyToClipboardCueSheet;
begin
  if (not HasMainControl) then exit;

  if (FCueSheetList.Count = 0) then exit;

  GetClipboardCueSheetList(GV_ClipboardCueSheet, pmCopy);
  try
    if (GV_ClipboardCueSheet.Count = 0) then exit;
  finally
    acgPlaylist.Repaint;
  end;
end;

procedure TfrmChannel.CutToClipboardCueSheet;
begin
  if (not HasMainControl) then exit;

  if (FCueSheetList.Count = 0) then exit;

  GetClipboardCueSheetList(GV_ClipboardCueSheet, pmCut);
  try
    if (GV_ClipboardCueSheet.Count = 0) then exit;
  finally
    acgPlaylist.Repaint;
  end;
end;

procedure TfrmChannel.PasteFromClipboardCueSheet;
var
  SelectIndex: Integer;
  SelectItem: PCueSheetItem;

  PasteList: TCueSheetList;

  FirstIndex: Integer;

  ParentIndex: Integer;
  ParentItem: PCueSheetItem;
  ParentProgramNo: Integer;
  ParentStartTime: TEventTime;
  ParentEndTime: TEventTime;
  SaveProgramNo: Integer;
  SaveGroupNo: Integer;

  ChannelForm: TfrmChannel;
  ChannelCueSheet: PChannelCueSheet;

  I, J: Integer;
  Item: PCueSheetItem;

  PasteItem: PCueSheetItem;
  PasteIndex: Integer;
  PasteGap: Integer;

  ProgIndex: Integer;
  ProgItem: PCueSheetItem;

  CompMainItem: PCueSheetItem;

  ResetIndex: Integer;
  InsertIndex: Integer;

  StartTime: TEventTime;

  PastePlus: Boolean;
  PasteDurTime: TEventTime;
  StartDurTime: TEventTime;

  function GetPasteDurationTime: TEventTime;
  var
    I: Integer;
    Item: PCueSheetItem;
    DurStartTime, DurEndTime: TEventTime;
  begin
    Result.D := 0;
    Result.T := 0;

    DurStartTime.D := 0;
    DurStartTime.T := 0;
    for I := 0 to PasteList.Count - 1 do
    begin
      Item := PasteList[I];
      if (Item^.EventMode = EM_MAIN) then
      begin
        DurStartTime := Item^.StartTime;
        break;
      end;
    end;

    DurEndTime.D := 0;
    DurEndTime.T := 0;
    for I := PasteList.Count - 1 downto 0 do
    begin
      Item := PasteList[I];
      if (Item^.EventMode = EM_MAIN) then
      begin
        DurEndTime := GetEventEndTime(Item^.StartTime, Item^.DurationTC, ChannelFrameRateType);
        break;
      end;
    end;

    Result := GetDurEventTime(DurStartTime, DurEndTime, ChannelFrameRateType);
  end;

  function GetStartDurationTime(AStartTime: TEventTime): TEventTime;
  var
    I: Integer;
    Item: PCueSheetItem;
    DurStartTime: TEventTime;
  begin
    Result.D := 0;
    Result.T := 0;

    DurStartTime.D := 0;
    DurStartTime.T := 0;
    for I := 0 to PasteList.Count - 1 do
    begin
      Item := PasteList[I];
      if (Item^.EventMode = EM_MAIN) then
      begin
        DurStartTime := Item^.StartTime;
        break;
      end;
    end;

    Result := GetDurEventTime(AStartTime, DurStartTime, ChannelFrameRateType);
  end;

begin
  if (not HasMainControl) then exit;

  if (GV_ClipboardCueSheet.Count = 0) then exit;

  // TMS Grid Bug
  // Mouse wheel top before or end after selectedrowcount = 0
  if (acgPlayList.SelectedRowCount = 0) then
  begin
    acgPlayList.SelectRows(acgPlayList.Row, 1);
  end;

  if (acgPlayList.SelectedRowCount <> 1) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SEPasteLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
    exit;
  end;

  // ������ �̺�Ʈ�� �ٿ��ֱ� �������� Ȯ��
  SelectIndex := GetSelectCueSheetIndex;
  if (not CheckCueSheetEditPossibleLockTimeByIndex(SelectIndex)) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SENotPossibleEditLockTime), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
    exit;
  end
  else if (not CheckCueSheetEditPossibleLocationByIndex(SelectIndex)) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SENotPossibleEditBeforeLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
    exit;
  end;

  // ������ �̺�Ʈ�� ����, JOIN, SUB �̺�Ʈ�� Ŭ�����忡 �ִ� ��� ����
  if (SelectIndex < 0) and
     ((not (EM_PROGRAM in GV_ClipboardCueSheet.PasteIncluded)) and
      (not (EM_MAIN in GV_ClipboardCueSheet.PasteIncluded)) and
      (GV_ClipboardCueSheet.PasteIncluded <> [EM_COMMENT])) then
  begin
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(SEPasteHasMainLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
    exit;
  end;

  // ������ �̺�Ʈ, �θ� �̺�Ʈ, ���α׷� �̺�Ʈ ����
  SelectItem := GetCueSheetItemByIndex(SelectIndex);
  ParentItem := GetParentCueSheetItemByItem(SelectItem);
  ProgItem   := GetProgramItemByItem(SelectItem);

  FLastDisplayNo := 0;

  // ������ �̺�Ʈ�� �ִ� ���
  if (SelectIndex >= 0) then
  begin
//    SelectItem := GetCueSheetItemByIndex(SelectIndex);
//    ParentItem := GetParentCueSheetItemByItem(SelectItem);
//    ProgItem   := GetProgramItemByItem(SelectItem);

    // �ٿ��ֱ� ���� ó��
    // ���α׷� �̺�Ʈ�� Ŭ�����忡 ���ԵǾ� �ִ� ���
    if (EM_PROGRAM in GV_ClipboardCueSheet.PasteIncluded) then
    begin
      if (SelectItem <> nil) then
      begin
        // ������ �̺�Ʈ�� MAIN�̰� ���α׷� �̺�Ʈ�� ���� �ְų� JOIN, SUB �̺�Ʈ �� ��� ����
        if ((SelectItem^.EventMode = EM_MAIN) and (ProgItem <> nil)) or
           (SelectItem^.EventMode in [EM_JOIN, EM_SUB]) then
        begin
          MessageBeep(MB_ICONWARNING);
          MessageBox(Handle, PChar(SEPasteHasProgramLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
          exit;
        end
        // ������ �̺�Ʈ�� COMMENT�̰� ���α׷� �Ǵ� MAIN �̺�Ʈ�� ���� �ִ� ��� ����
        else if (SelectItem^.EventMode = EM_COMMENT) and
                ((ProgItem <> nil) or (ParentItem <> nil)) then
        begin
          MessageBeep(MB_ICONWARNING);
          MessageBox(Handle, PChar(SEPasteHasProgramLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
          exit;
        end;
      end;
    end
    // MAIN �̺�Ʈ�� Ŭ�����忡 ���ԵǾ� �ִ� ���
    else if (EM_MAIN in GV_ClipboardCueSheet.PasteIncluded) then
    begin
      // ������ �̺�Ʈ�� �θ��̺�Ʈ�� �ְ� ������ �̺�Ʈ�� ���� ���� ��� ����
      if (SelectItem <> nil) and (ParentItem <> nil) and (SelectItem <> ParentItem) then
      begin
        MessageBeep(MB_ICONWARNING);
        MessageBox(Handle, PChar(SEPasteHasMainLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
        exit;
      end;
    end
    // JOIN�̳� SUB �̺�Ʈ�� Ŭ�����忡 ���ԵǾ� �ִ� ���
    else if (GV_ClipboardCueSheet.PasteIncluded <> [EM_COMMENT]) then
    begin
      // ������ �̺�Ʈ�� �θ��̺�Ʈ ������ ����
      if (ParentItem = nil) then
      begin
        MessageBeep(MB_ICONWARNING);
        MessageBox(Handle, PChar(SEPasteJoinSubLocationIncorrect), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
        exit;
      end;
    end;
  end;

  // �ٿ��ֱ� �̺�Ʈ ��� ����
  PasteList := TCueSheetList.Create;
  try
//    DurTime.D := 0;
//    DurTime.T := 0;

    // Temporary paste item add
    for I := 0 to GV_ClipboardCueSheet.Count - 1 do
    begin
      Item := GV_ClipboardCueSheet[I];

      PasteItem := New(PCueSheetItem);
      Move(Item^, PasteItem^, SizeOf(TCueSheetItem));

      PasteItem^.EventStatus.State := esIdle;

//      if (PasteItem^.EventMode = EM_MAIN)then
//        DurTime := GetPlusEventTime(DurTime, TimecodeToEventTime(PasteItem^.DurationTC));

      PasteList.Add(PasteItem);
    end;

//    DurTime.D := 0;
//    DurTime.T := 0;

    // �ٿ��ֱ� �̺�Ʈ ����� ��ü ���� ����
    PasteDurTime := GetPasteDurationTime;

    // �ٿ��ֱ� ��尡 CUT�� ���
{    if (GV_ClipboardCueSheet.PasteMode = pmCut) then
    begin
      ChannelForm := frmSEC.GetChannelFormByID(GV_ClipboardCueSheet.ChannelID);
      if (ChannelForm <> nil) then
      begin
        // ���� ��� ����
        ChannelForm.ExecuteDeleteCueSheet(GV_ClipboardCueSheet.CueSheetList);

        // ���� ä�ο��� CUT�� ���
        if (ChannelForm = Self) then
        begin
          // ������ �̺�Ʈ�� �ٿ��ֱ� ��Ͽ� ���Ե� ���
          if (GV_ClipboardCueSheet.IndexOf(SelectItem) >= 0) then
          begin
            for I := SelectIndex to FChannelCueSheet.CueSheetList.Count - 1 do
            begin
              SelectItem := GetCueSheetItemByIndex(I);
              if (SelectItem <> nil) and (GV_ClipboardCueSheet.IndexOf(SelectItem) < 0) then
              begin
                SelectIndex := I;
                StartTime := SelectItem^.StartTime;
                break;
              end;
            end;
          end
          else
          begin
            SelectIndex := GetCueSheetIndexByItem(SelectItem);
            if (SelectIndex >= 0) then
            begin
              if (SelectItem^.EventMode = EM_PROGRAM) then
              begin
                ParentItem := GetProgramMainItemByItem(SelectItem);
                if (ParentItem <> nil) then
                  StartTime := ParentItem^.StartTime
                else
                  StartTime := SelectItem^.StartTime;
              end
              else if (SelectItem^.EventMode = EM_MAIN) then
              begin
                StartTime := SelectItem^.StartTime;
              end
              else if (SelectItem^.EventMode = EM_COMMENT) then
              begin
                StartTime := PasteList.First^.StartTime;
              end
              else
                StartTime := SelectItem^.StartTime;
            end;
          end;
        end;
        GV_ClipboardCueSheet.Clear;
      end;
    end;  }

    // �ٿ��ֱ� ���۽ð�, ������ Display No ����
    if (SelectIndex >= 0) then
    begin
      // ������ �̺�Ʈ�� ���α׷��� ���
      if (SelectItem^.EventMode = EM_PROGRAM) then
      begin
        // ���α׷� �̺�Ʈ�� ���� �ִ� MAIN �̺�Ʈ�� ����
        CompMainItem := GetProgramMainItemByItem(SelectItem);
        // ���α׷��� MAIN �̺�Ʈ�� ������ MAIN �̺�Ʈ�� ���۽ð����� ����
        if (CompMainItem <> nil) then
        begin
          StartTime := CompMainItem^.StartTime;
          FLastDisplayNo := CompMainItem^.DisplayNo - 1;
        end
        else
        begin
          // ���α׷��� MAIN �̺�Ʈ�� ������ ���� MAIN �̺�Ʈ�� ����
          CompMainItem := GetNextMainItemByItem(SelectItem);
          // ���� MAIN �̺�Ʈ�� ������ ���� MAIN �̺�Ʈ�� ���۽ð����� ����
          if (CompMainItem <> nil) then
          begin
            StartTime := CompMainItem^.StartTime;
            FLastDisplayNo := CompMainItem^.DisplayNo - 1;
          end
          else
          begin
            // ���� MAIN �̺�Ʈ�� ������ ������ MAIN �̺�Ʈ�� ����
            CompMainItem := GetLastMainItem;
            // ������  MAIN �̺�Ʈ�� ������ ������ MAIN �̺�Ʈ�� ����ð����� ����
            if (CompMainItem <> nil) then
            begin
              StartTime := GetEventEndTime(CompMainItem^.StartTime, CompMainItem^.DurationTC, ChannelFrameRateType);
              FLastDisplayNo := CompMainItem^.DisplayNo;
            end
            else
            begin
              // ������  MAIN �̺�Ʈ�� ������ ���۽ð��� �ʱ�ȭ
              StartTime.D := Date;//OnAirDateToDate(FChannelCueSheet.OnairDate);
              StartTime.T := 0;
              FLastDisplayNo := -1;
            end;
          end;
        end;
      end
      // ������ �̺�Ʈ�� MAIN�� ��� MAIN�� ���۽ð����� ����
      else if (SelectItem^.EventMode = EM_MAIN) then
      begin
        StartTime := SelectItem^.StartTime;
        FLastDisplayNo := SelectItem^.DisplayNo - 1;
      end
      // ������ �̺�Ʈ�� JOIN, SUB�� ���
      else if (SelectItem^.EventMode in [EM_JOIN, EM_SUB]) then
      begin
        // �θ� �̺�Ʈ�� ������ �θ� �̺�Ʈ�� ���۽ð����� ����
        if (ParentItem <> nil) then
        begin
          StartTime := ParentItem^.StartTime;
          FLastDisplayNo := ParentItem^.DisplayNo;
        end
        else
        begin
          // �θ� �̺�Ʈ�� ������ ���۽ð��� �ʱ�ȭ
          if (FChannelCueSheetList.Count > 0) then
            ChannelCueSheet := FChannelCueSheetList[FChannelCueSheetList.Count - 1];

          if (ChannelCueSheet <> nil) then
            StartTime.D := OnAirDateToDate(ChannelCueSheet^.OnairDate)
          else
            StartTime.D := Date;

          StartTime.T := 0;
          FLastDisplayNo := -1;
        end;
      end
      // ������ �̺�Ʈ�� COMMENT�� ���
      else if (SelectItem^.EventMode = EM_COMMENT) then
      begin
        // �θ� �̺�Ʈ�� ������ �θ� �̺�Ʈ�� ���۽ð����� ����
        if (ParentItem <> nil) then
        begin
          StartTime := ParentItem^.StartTime;
          FLastDisplayNo := ParentItem^.DisplayNo;
        end
        else
        begin
          // �θ� �̺�Ʈ�� ������ ���� MAIN �̺�Ʈ�� ����
          CompMainItem := GetNextMainItemByItem(SelectItem);
          // ���� MAIN �̺�Ʈ�� ������ ���� MAIN �̺�Ʈ�� �ð��ð����� ����
          if (CompMainItem <> nil) then
          begin
            StartTime := CompMainItem^.StartTime;
            FLastDisplayNo := CompMainItem^.DisplayNo - 1;
          end
          else
          begin
            // ���� MAIN �̺�Ʈ�� ������ �ð��ð� �ʱ�ȭ
            if (FChannelCueSheetList.Count > 0) then
              ChannelCueSheet := FChannelCueSheetList[FChannelCueSheetList.Count - 1];

            if (ChannelCueSheet <> nil) then
              StartTime.D := OnAirDateToDate(ChannelCueSheet^.OnairDate)
            else
              StartTime.D := Date;

            StartTime.T := 0;
            FLastDisplayNo := -1;
          end;
        end;
      end;
    end
    else
    begin
      // ������ �̺�Ʈ�� ���� ���
      // ������ �̺�Ʈ�� ������ �̺�Ʈ�� ����
      SelectIndex := FCueSheetList.Count;

      SelectItem := GetCueSheetItemByIndex(SelectIndex);
      ParentItem := GetParentCueSheetItemByItem(SelectItem);
      ProgItem   := GetProgramItemByItem(SelectItem);

      // ������ MAIN �̺�Ʈ�� ����
      CompMainItem := GetLastMainItem;
      // ������ MAIN �̺�Ʈ�� ������ ������ MAIN �̺�Ʈ�� �շ�ð��� �ð��������� ����
      if (CompMainItem <> nil) then
      begin
        StartTime := GetEventEndTime(CompMainItem^.StartTime, CompMainItem^.DurationTC, ChannelFrameRateType);
        FLastDisplayNo := CompMainItem^.DisplayNo;
      end
      else
      begin
        // ������ MAIN �̺�Ʈ�� ������ ���۽ð� �ʱ�ȭ
        if (FChannelCueSheetList.Count > 0) then
          ChannelCueSheet := FChannelCueSheetList[FChannelCueSheetList.Count - 1];

        if (ChannelCueSheet <> nil) then
          StartTime.D := OnAirDateToDate(ChannelCueSheet^.OnairDate)
        else
          StartTime.D := Date;

        StartTime.T := 0;
        FLastDisplayNo := -1;
      end;
    end;

//    ShowMessage(EventTimeToDateTimecodeStr(StartTime));
    StartDurTime := GetStartDurationTime(StartTime);
//    ShowMessage(EventTimeToDateTimecodeStr(StartDurTime));

    // Add paste items
//    FirstIndex := ChannelForm.GetCueSheetIndexByItem(GV_ClipboardCueSheet.First);

{    // Display NO ����
    if (SelectItem <> nil) then
    begin
      if (SelectItem^.EventMode = EM_PROGRAM) then
      begin
        // ������ �̺�Ʈ�� PROGRAM �̸�
        CompMainItem := GetProgramMainItemByItem(SelectItem);
        if (CompMainItem <> nil) then
          FLastDisplayNo := CompMainItem^.DisplayNo - 1
        else
        begin
          ParentItem := GetNextMainItemByItem(SelectItem);
          if (ParentItem <> nil) then
            FLastDisplayNo := ParentItem^.DisplayNo - 1
          else
            FLastDisplayNo := 0;
        end;
      end
      else if (SelectItem^.EventMode = EM_MAIN) then
        FLastDisplayNo := SelectItem^.DisplayNo - 1
      else
        FLastDisplayNo := SelectItem^.DisplayNo;
    end
    else
    begin
      FLastDisplayNo := ParentItem^.DisplayNo;
    end;  }

//    ParentItem := nil;
    ParentStartTime.D := 0;
    ParentStartTime.T := 0;

    PasteGap := 0;

    ResetIndex := SelectIndex;
    InsertIndex := SelectIndex;

    SaveProgramNo := -1;
    SaveGroupNo := -1;

    ChannelCueSheet := GetChannelCueSheetByIndex(SelectIndex);
    if (ChannelCueSheet = nil) then
    begin
      if (FChannelCueSheetList.Count > 0) then
        ChannelCueSheet := FChannelCueSheetList[FChannelCueSheetList.Count - 1]
      else
        exit;
    end;


    acgPlaylist.BeginUpdate;
    try

    // �ٿ��ֱ� �̺�Ʈ�� ���۽ð�, ��ȣ �� ����
    for I := 0 to PasteList.Count - 1 do
    begin
      PasteItem := PasteList[I];
      PasteIndex := SelectIndex + I;

//      ChannelCueSheet := GetChannelCueSheetByIndex(PasteIndex);
//      if (ChannelCueSheet = nil) then Continue;

      ChannelCueSheet^.LastSerialNo := ChannelCueSheet^.LastSerialNo + 1;

      PasteItem^.EventID.ChannelID := FChannelID;
      StrCopy(PasteItem^.EventID.OnAirDate, ChannelCueSheet^.OnairDate);
      PasteItem^.EventID.OnAirFlag := ChannelCueSheet^.OnairFlag;
      PasteItem^.EventID.OnAirNo   := ChannelCueSheet^.OnairNo;
      PasteItem^.EventID.SerialNo  := ChannelCueSheet^.LastSerialNo;

      // �ٿ����� �̺�Ʈ�� PROGRAM�� ���
      if (PasteItem^.EventMode = EM_PROGRAM) then
      begin
        // PROGRAM NO ����
        SaveProgramNo := PasteItem^.ProgramNo;

        // ������ PROGRAM NO, GROUP NO �߰�
        Inc(ChannelCueSheet^.LastProgramNo);
        Inc(ChannelCueSheet^.LastGroupNo);

        PasteItem^.StartTime.D := 0;
        PasteItem^.StartTime.T := 0;
        PasteItem^.ProgramNo := ChannelCueSheet^.LastProgramNo;
        PasteItem^.GroupNo   := ChannelCueSheet^.LastGroupNo;

        PasteItem^.DisplayNo := 0;//FLastDisplayNo;

        ParentProgramNo := ChannelCueSheet^.LastProgramNo;

        ResetIndex := PasteIndex + 1;
      end
      // If then main event then checks whether the current start time is less than the start time of the previous event.
      else if (PasteItem^.EventMode = EM_MAIN) then
      begin
    PasteGap := 0;
        SaveGroupNo := PasteItem^.GroupNo;
//          StartTime := GetPlusEventTime(PasteItem^.StartTime, DurTime);
//          ShowMessage(EventTimeToDateTimecodeStr(CStartTime));
{        if (ParentItem <> nil) then
        begin
          ParentEndTime := GetEventEndTime(ParentItem^.StartTime, ParentItem^.DurationTC);
          if (CompareEventTime(StartTime, ParentEndTime) < 0) then
          begin
            StartTime := ParentEndTime;
          end;
        end;}

        if (CompareEventTime(StartTime, PasteItem^.StartTime, ChannelFrameRateType) >= 0) then
          StartTime := GetPlusEventTime(PasteItem^.StartTime, StartDurTime, ChannelFrameRateType)
        else
          StartTime := GetMinusEventTime(PasteItem^.StartTime, StartDurTime, ChannelFrameRateType);

        ParentItem := PasteItem;

        ParentStartTime := StartTime;

        PasteItem^.StartTime := StartTime;

        if (SaveProgramNo = PasteItem^.ProgramNo) then
        begin
          PasteItem^.ProgramNo := ChannelCueSheet^.LastProgramNo;
//          PasteIndex := ProgIndex + PasteGap + 1;
//          Inc(PasteGap);
        end
        else
        begin
//          ProgItem := GetProgramItemByIndex(SelectIndex);
          if (ProgItem <> nil) and (not (EM_PROGRAM in GV_ClipboardCueSheet.PasteIncluded)) then
          begin
            PasteItem^.ProgramNo := ProgItem^.ProgramNo;
            if (SelectItem^.EventMode = EM_PROGRAM) then
            begin
              ProgIndex := GetCueSheetIndexByItem(ProgItem);
              PasteIndex := ProgIndex + PasteGap;// + 1;
              Inc(PasteGap);
            end;
          end
          else
          begin
            Inc(ChannelCueSheet^.LastProgramNo);
            PasteItem^.ProgramNo := ChannelCueSheet^.LastProgramNo;

  //          ParentProgramNo := FLastProgramNo;
          end;
        end;

        Inc(ChannelCueSheet^.LastGroupNo);
        PasteItem^.GroupNo := ChannelCueSheet^.LastGroupNo;

        Inc(FLastDisplayNo);
        PasteItem^.DisplayNo := FLastDisplayNo;

        ParentIndex := PasteIndex;

        ResetIndex := PasteIndex + 1;
      end
      else if (PasteItem^.EventMode in [EM_JOIN, EM_SUB]) then
      begin
        if (SaveProgramNo = PasteItem^.ProgramNo) then
          PasteItem^.ProgramNo := ChannelCueSheet^.LastProgramNo
        else
        begin
//          ProgItem := GetProgramParentCueSheetItemByIndex(SelectIndex);
          if (ProgItem <> nil) then
          begin
            PasteItem^.ProgramNo := ProgItem^.ProgramNo;
          end
          else
          begin
//            Inc(ChannelCueSheet^.LastProgramNo);
            PasteItem^.ProgramNo := ChannelCueSheet^.LastProgramNo;
          end;
        end;

        if (SaveGroupNo = PasteItem^.GroupNo) then
        begin
          PasteItem^.StartTime.D := ParentStartTime.D;
          PasteItem^.GroupNo     := ChannelCueSheet^.LastGroupNo;
          PasteItem^.DisplayNo   := FLastDisplayNo;

          PasteIndex := PasteIndex + PasteGap;
          Inc(PasteGap);
        end
        else
        begin
//          ParentItem := GetParentCueSheetItemByIndex(SelectIndex);
          if (ParentItem <> nil) then
          begin
            ParentIndex := GetCueSheetIndexByItem(ParentItem);

            PasteItem^.StartTime.D := ParentItem^.StartTime.D;
            PasteItem^.GroupNo     := ParentItem^.GroupNo;
            PasteItem^.DisplayNo   := ParentItem^.DisplayNo;

//            PasteIndex := PasteIndex + PasteGap;
//            Inc(PasteGap);
          end
          else
          begin
//            Inc(ChannelCueSheet^.LastProgramNo);
            PasteItem^.ProgramNo := ChannelCueSheet^.LastProgramNo;
          end;
        end;

        if (PasteItem^.EventMode in [EM_JOIN]) then
        begin
          PasteItem^.DurationTC  := ParentItem^.DurationTC;

          // Main �̺�Ʈ ��ġ���� �����ϴ� ���� �� ���� ��ġ�� ����
          if (SelectItem <> nil) and (SelectItem^.EventMode = EM_MAIN) then
          begin
            if (SaveGroupNo < 0) then
              PasteIndex := ParentIndex + PasteGap + 1;
            Inc(PasteGap);
          end
          else if (SelectItem <> nil) and (SelectItem^.EventMode = EM_JOIN) then
          begin
            // Join �̺�Ʈ ��ġ���� �����ϴ� ���� �� ��ġ�� ����
            PasteIndex := SelectIndex + PasteGap;
            Inc(PasteGap);
          end
          else if (Item^.EventMode in [EM_SUB]) then
          begin
            // Sub �̺�Ʈ ��ġ���� �����ϴ� ��� ù Sub �̺�Ʈ ��ġ�� ����
            PasteIndex := ParentIndex + 1;
            for J := PasteIndex to FCueSheetList.Count - 1 do
            begin
              Item := GetCueSheetItemByIndex(J);

              if (Item <> nil) then
              begin
                if (ParentItem^.GroupNo <> Item^.GroupNo) then break;
                if (Item^.EventMode in [EM_SUB]) then
                begin
                  break;
                end;
                Inc(PasteIndex);
              end;
            end;
          end
          else
          begin
            // Comment �̺�Ʈ ��ġ���� �����ϴ� ��� ���� Join �̺�Ʈ ���� ��ġ�� ����
            PasteIndex := ParentIndex + 1;
            for J := PasteIndex to FCueSheetList.Count - 1 do
            begin
              Item := GetCueSheetItemByIndex(J);

              if (Item <> nil) then
              begin
                if (ParentItem^.GroupNo <> Item^.GroupNo) then break;
                if (Item^.EventMode in [EM_SUB]) then
                begin
                  break;
                end;
                if (PasteIndex >= SelectIndex + PasteGap) and (Item^.EventMode in [EM_COMMENT]) then
                begin
                  break;
                end;
                Inc(PasteIndex);
              end;
            end;
          end;
        end
        else
        begin
          if (SelectItem <> nil) then
          // Main, Join �̺�Ʈ ��ġ���� �����ϴ� ���� ù Sub ���� ��ġ�� ����
          if (SelectItem^.EventMode in [EM_MAIN, EM_JOIN]) then
          begin
            // Sub �̺�Ʈ ��ġ���� �����ϴ� ��� ù Sub �̺�Ʈ ��ġ�� ����
            PasteIndex := ParentIndex + 1;
            for J := PasteIndex to FCueSheetList.Count - 1 do
            begin
              Item := GetCueSheetItemByIndex(J);

              if (Item <> nil) then
              begin
                if (ParentItem^.GroupNo <> Item^.GroupNo) then break;
                if (Item^.EventMode in [EM_SUB]) then
                begin
                  break;
                end;
                Inc(PasteIndex);
              end;
            end;
          end
          else if (SelectItem^.EventMode = EM_SUB) then
          begin
            // Sub �̺�Ʈ ��ġ���� �����ϴ� ���� �� ��ġ�� ����
            PasteIndex := SelectIndex + PasteGap;
            Inc(PasteGap);
          end
          else
          begin
            // Comment �̺�Ʈ ��ġ���� �����ϴ� ��� ù Sub �̺�Ʈ ���� �Ʒ� ��ġ�� ���� ��ġ�� ����
            PasteIndex := ParentIndex + 1;
            for J := PasteIndex to FCueSheetList.Count - 1 do
            begin
              Item := GetCueSheetItemByIndex(J);

              if (Item <> nil) then
              begin
                if (ParentItem^.GroupNo <> Item^.GroupNo) then break;
                if (Item^.EventMode in [EM_SUB]) then
                begin
                  break;
                end;
                Inc(PasteIndex);
              end;
            end;

            if (PasteIndex <= (SelectIndex + PasteGap)) then
              PasteIndex := SelectIndex + PasteGap;
          end;
        end;


{        if (EM_MAIN in GV_ClipboardCueSheet.PasteIncluded) then
        begin
          PasteItem^.StartTime.D := ParentStartTime.D;
          PasteItem^.ProgramNo   := FLastProgramNo;
          PasteItem^.GroupNo     := FLastGroupNo;
          PasteItem^.DisplayNo := FLastDisplayNo;

          PasteIndex := PasteIndex + PasteGap;
          Inc(PasteGap);
        end
        else
        begin
          ParentItem := GetParentCueSheetItemByItem(SelectItem);
          if (ParentItem <> nil) then
          begin
            ParentIndex := GetCueSheetIndexByItem(ParentItem);

            PasteItem^.StartTime.D := ParentItem^.StartTime.D;
            PasteItem^.ProgramNo   := ParentItem^.ProgramNo;
            PasteItem^.GroupNo     := ParentItem^.GroupNo;
            PasteItem^.DisplayNo   := ParentItem^.DisplayNo;

            if (PasteItem^.EventMode in [EM_JOIN]) then
            begin
              PasteItem^.DurationTC  := ParentItem^.DurationTC;

              // Main �̺�Ʈ ��ġ���� �����ϴ� ���� �� ���� ��ġ�� ����
              if (SelectItem^.EventMode = EM_MAIN) then
              begin
                PasteIndex := ParentIndex + PasteGap + 1;
                Inc(PasteGap);
              end
              else if (SelectItem^.EventMode = EM_JOIN) then
              begin
                // Join �̺�Ʈ ��ġ���� �����ϴ� ���� �� ��ġ�� ����
                PasteIndex := SelectIndex + PasteGap;
                Inc(PasteGap);
              end
              else if (Item^.EventMode in [EM_SUB]) then
              begin
                // Sub �̺�Ʈ ��ġ���� �����ϴ� ��� ù Sub �̺�Ʈ ��ġ�� ����
                PasteIndex := ParentIndex + 1;
                for J := PasteIndex to FCueSheetList.Count - 1 do
                begin
                  Item := GetCueSheetItemByIndex(J);

                  if (Item <> nil) then
                  begin
                    if (ParentItem^.GroupNo <> Item^.GroupNo) then break;
                    if (Item^.EventMode in [EM_SUB]) then
                    begin
                      break;
                    end;
                    Inc(PasteIndex);
                  end;
                end;
              end
              else
              begin
                // Comment �̺�Ʈ ��ġ���� �����ϴ� ��� ���� Join �̺�Ʈ ���� ��ġ�� ����
                PasteIndex := ParentIndex + 1;
                for J := PasteIndex to FCueSheetList.Count - 1 do
                begin
                  Item := GetCueSheetItemByIndex(J);

                  if (Item <> nil) then
                  begin
                    if (ParentItem^.GroupNo <> Item^.GroupNo) then break;
                    if (Item^.EventMode in [EM_SUB]) then
                    begin
                      break;
                    end;
                    if (PasteIndex >= SelectIndex + PasteGap) and (Item^.EventMode in [EM_COMMENT]) then
                    begin
                      break;
                    end;
                    Inc(PasteIndex);
                  end;
                end;
              end;
            end
            else
            begin
              // Main, Join �̺�Ʈ ��ġ���� �����ϴ� ���� ù Sub ���� ��ġ�� ����
              if (SelectItem^.EventMode in [EM_MAIN, EM_JOIN]) then
              begin
                // Sub �̺�Ʈ ��ġ���� �����ϴ� ��� ù Sub �̺�Ʈ ��ġ�� ����
                PasteIndex := ParentIndex + 1;
                for J := PasteIndex to FCueSheetList.Count - 1 do
                begin
                  Item := GetCueSheetItemByIndex(J);

                  if (Item <> nil) then
                  begin
                    if (ParentItem^.GroupNo <> Item^.GroupNo) then break;
                    if (Item^.EventMode in [EM_SUB]) then
                    begin
                      break;
                    end;
                    Inc(PasteIndex);
                  end;
                end;
              end
              else if (SelectItem^.EventMode = EM_SUB) then
              begin
                // Sub �̺�Ʈ ��ġ���� �����ϴ� ���� �� ��ġ�� ����
                PasteIndex := SelectIndex + PasteGap;
                Inc(PasteGap);
              end
              else
              begin
                // Comment �̺�Ʈ ��ġ���� �����ϴ� ��� ù Sub �̺�Ʈ ���� �Ʒ� ��ġ�� ���� ��ġ�� ����
                PasteIndex := ParentIndex + 1;
                for J := PasteIndex to FCueSheetList.Count - 1 do
                begin
                  Item := GetCueSheetItemByIndex(J);

                  if (Item <> nil) then
                  begin
                    if (ParentItem^.GroupNo <> Item^.GroupNo) then break;
                    if (Item^.EventMode in [EM_SUB]) then
                    begin
                      break;
                    end;
                    Inc(PasteIndex);
                  end;
                end;

                if (PasteIndex <= (SelectIndex + PasteGap)) then
                  PasteIndex := SelectIndex + PasteGap; 
              end;
            end;
          end;
        end;
      end
      else
      begin
        if (EM_PROGRAM in GV_ClipboardCueSheet.PasteIncluded) then
        begin
          if (PasteItem^.ProgramNo <> SaveProgramNo) then
          begin
            FLastProgramNo       := FLastProgramNo + 1;
            PasteItem^.ProgramNo := FLastProgramNo;

            FLastGroupNo       := FLastGroupNo + 1;
            PasteItem^.GroupNo := FLastGroupNo;

            PasteItem^.DisplayNo := FLastDisplayNo;
          end
          else
          begin
            PasteItem^.ProgramNo := FLastProgramNo;
            PasteItem^.GroupNo := FLastGroupNo;
          end;
        end
        else if (EM_MAIN in GV_ClipboardCueSheet.PasteIncluded) then
        begin
          if (PasteItem^.GroupNo <> SaveGroupNo) then
          begin
            FLastGroupNo       := FLastGroupNo + 1;
            PasteItem^.GroupNo := FLastGroupNo;
            PasteItem^.DisplayNo := FLastDisplayNo;
          end
          else
          begin
            PasteItem^.GroupNo := FLastGroupNo;
          end;
        end
        else
        begin
          if (PasteIndex < FCueSheetList.Count) then
            PasteItem^.GroupNo := SelectItem^.GroupNo
          else
          begin
            FLastGroupNo       := FLastGroupNo + 1;
            PasteItem^.GroupNo := FLastGroupNo;
          end;

            PasteIndex := SelectIndex + PasteGap;
            Inc(PasteGap);
{          // Main �̺�Ʈ ��ġ���� �����ϴ� ���� �� ��ġ ���� ����
          if (SelectItem^.EventMode = EM_MAIN) then
          begin
            PasteIndex := SelectIndex + PasteGap;
            Inc(PasteGap);
          end
          else 
          begin
            // Join, Sub, Comment �̺�Ʈ ��ġ���� �����ϴ� ���� �� ��ġ�� ����
            PasteIndex := SelectIndex + PasteGap;
            Inc(PasteGap);
          end;}
//        end;
      end;

      FCueSheetLock.Enter;
      try
        if (PasteIndex < FCueSheetList.Count) then
          FCueSheetList.Insert(PasteIndex, PasteItem)
        else
        begin
          FCueSheetList.Add(PasteItem);
          PasteIndex := FCueSheetList.Count - 1;
        end;
      finally
        FCueSheetLock.Leave;
      end;

      if (PasteItem^.EventMode = EM_PROGRAM) then
        InsertPlayListGridProgram(PasteIndex)
      else if (PasteItem^.EventMode = EM_MAIN) then
        InsertPlayListGridMain(PasteIndex)
      else if (PasteItem^.EventMode in [EM_JOIN, EM_SUB]) then
        InsertPlayListGridSub(PasteIndex)
      else
      begin
        ParentItem := GetParentCueSheetItemByItem(PasteItem);
        if (ParentItem <> nil) then
          InsertPlayListGridSub(PasteIndex)
        else
          InsertPlayListGridMain(PasteIndex);
      end;

      if (PasteIndex < InsertIndex)  then
        InsertIndex := PasteIndex;

      Inc(ChannelCueSheet^.EventCount);
    end;

    finally
      acgPlaylist.EndUpdate;
    end;

    ParentItem := nil;
    ParentStartTime.D := 0;
    ParentStartTime.T := 0;
    for I := ResetIndex {SelectIndex + PasteList.Count} to FCueSheetList.Count - 1 do
    begin
      Item := GetCueSheetItemByIndex(I);
      if (Item <> nil) then
      begin
  //      if (Item^.EventMode <> EM_COMMENT) then
        begin
          // If then main event then checks whether the current start time is less than the start time of the previous event.
          if (Item^.EventMode = EM_MAIN) then
          begin
            StartTime := GetPlusEventTime(Item^.StartTime, PasteDurTime, ChannelFrameRateType);
    //          ShowMessage(EventTimeToDateTimecodeStr(CStartTime));
  {          if (ParentItem <> nil) then
            begin
              ParentEndTime := GetEventEndTime(ParentItem^.StartTime, ParentItem^.DurationTC);
              if (CompareEventTime(StartTime, ParentEndTime) < 0) then
              begin
                StartTime := ParentEndTime;
              end;
            end; }
            ParentItem := Item;

            ParentStartTime := StartTime;

            Item^.StartTime := StartTime;

            Inc(FLastDisplayNo);
            Item^.DisplayNo := FLastDisplayNo;
          end
          else
          begin
            if (ParentItem = nil) then
            begin
              ParentItem := GetParentCueSheetItemByIndex(I);
              ParentStartTime := ParentItem^.StartTime;
            end;
            Item^.StartTime.D := ParentStartTime.D;
            Item^.DisplayNo := FLastDisplayNo;
          end;
        end;
      end;
    end;

    // �ٿ��ֱ� ��尡 CUT�� ���
    if (GV_ClipboardCueSheet.PasteMode = pmCut) then
    begin
      ChannelForm := frmSEC.GetChannelFormByID(GV_ClipboardCueSheet.ChannelID);
      if (ChannelForm <> nil) then
      begin
        // ���� ��� ����
        ChannelForm.ExecuteDeleteCueSheet(GV_ClipboardCueSheet.CueSheetList);

{        // ���� ä�ο��� CUT�� ���
        if (ChannelForm = Self) then
        begin
          // ������ �̺�Ʈ�� �ٿ��ֱ� ��Ͽ� ���Ե� ���
          if (GV_ClipboardCueSheet.IndexOf(SelectItem) >= 0) then
          begin
            for I := SelectIndex to FChannelCueSheet.CueSheetList.Count - 1 do
            begin
              SelectItem := GetCueSheetItemByIndex(I);
              if (SelectItem <> nil) and (GV_ClipboardCueSheet.IndexOf(SelectItem) < 0) then
              begin
                SelectIndex := I;
                StartTime := SelectItem^.StartTime;
                break;
              end;
            end;
          end
          else
          begin
            SelectIndex := GetCueSheetIndexByItem(SelectItem);
            if (SelectIndex >= 0) then
            begin
              if (SelectItem^.EventMode = EM_PROGRAM) then
              begin
                ParentItem := GetProgramMainItemByItem(SelectItem);
                if (ParentItem <> nil) then
                  StartTime := ParentItem^.StartTime
                else
                  StartTime := SelectItem^.StartTime;
              end
              else if (SelectItem^.EventMode = EM_MAIN) then
              begin
                StartTime := SelectItem^.StartTime;
              end
              else if (SelectItem^.EventMode = EM_COMMENT) then
              begin
                StartTime := PasteList.First^.StartTime;
              end
              else
                StartTime := SelectItem^.StartTime;
            end;
          end;
        end; }
        GV_ClipboardCueSheet.Clear;
      end;
    end;


//        // DoCueSheetCheck���� �ޤ����� �̺�Ʈ�� Input ó����
    if (FChannelOnAir) and (SelectIndex < FLastInputIndex)  then
      OnAirInputEvents(SelectIndex, GV_SettingOption.MaxInputEventCount);


//    FLastDisplayNo := GetBeforeMainCountByIndex(SelectIndex);

//    DisplayPlayListGrid(SelectIndex, PasteList.Count);

    if (not ChannelOnair) then
    begin
      CalcuratePlayListTimeLineRange;
      UpdatePlayListTimeLineRange;
    end;
    DisplayPlayListTimeLine(SelectIndex);

//  acgPlaylist.MouseActions.DisjunctRowSelect := False;
//  acgPlaylist.ClearRowSelect;
//  acgPlaylist.MouseActions.DisjunctRowSelect := True;
//  acgPlaylist.SelectRows(FirstIndex + CNT_CUESHEET_HEADER, IDX_COL_CUESHEET_NO);

    SelectRowPlayListGrid(SelectIndex);

    FLastCount := FCueSheetList.Count;

    if (FChannelOnAir) then
    begin
      ServerBeginUpdates(ChannelID);
      try
        ServerInputCueSheets(ChannelID, SelectIndex);
      finally
        ServerEndUpdates(ChannelID);
      end;
    end;
  finally
    PasteList.Clear;
    FreeAndNil(PasteList);
  end;
end;

procedure TfrmChannel.ClearClipboardCueSheet;
begin
  if (not HasMainControl) then exit;

  if (GV_ClipboardCueSheet.Count > 0) then
  begin
    GV_ClipboardCueSheet.Clear;

    acgPlayList.Repaint;
  end;
end;

procedure TfrmChannel.SelectMediaFileInCueSheet;
var
  Item: PCueSheetItem;
  Source: PSource;
  FileName: String;
begin
  if (not HasMainControl) then exit;

  with acgPlaylist do
  begin
    Item := GetCueSheetItemByIndex(RealRowIndex(Row) - FixedRows);

    if (Item = nil) then exit;

    Source := GetSourceByName(String(Item^.Source));
    if (Source = nil) then exit;

    if (Source^.SourceType = ST_VSDEC) and (Source^.UsePCS) then
    begin
      FileName := String(Item^.MediaId);
      if (OpenDialogMediaFile(NAM_COL_CUESHEET_MEDIA_ID, FileName)) then
      begin
        StrPLCopy(Item^.MediaId, FileName, MEDIAID_LEN);
        if (InplaceRichEdit.Visible) then
          InplaceRichEdit.Text := FileName;
//        Modified := True;
//        RepaintCell(IDX_COL_CUESHEET_MEDIA_ID, Row);
      end;
    end;
  end;
end;

procedure TfrmChannel.TimelineGotoCurrent;
begin
//  FTimelineSpace := GV_SettingOption.TimelineSpace;
end;

procedure TfrmChannel.TimelineMoveLeft;
begin
//  Inc(FTimelineSpace, GV_SettingOption.TimelineSpaceInterval);
end;

procedure TfrmChannel.TimelineMoveRight;
begin
//  Dec(FTimelineSpace, GV_SettingOption.TimelineSpaceInterval);
end;

procedure TfrmChannel.TimelineZoomIn;
var
  Zoom: Integer;
begin
{  with wmtlPlayList.ZoomBarProperty do
  begin
    Zoom := Integer(FTimelineZoomType);
    Dec(Zoom);

    if (Zoom < Integer(Low(TTimelineZoomType)) + 1) then Zoom := Integer(Low(TTimelineZoomType)) + 1;

    FTimelineZoomType := TTimelineZoomType(Zoom);
    TimelineZoomPosition := GetPositionByZoomType(FTimelineZoomType);
  end; }
end;

procedure TfrmChannel.TimelineZoomOut;
var
  Zoom: Integer;
begin
{  with wmtlPlayList.ZoomBarProperty do
  begin
    Zoom := Integer(FTimelineZoomType);
    Inc(Zoom);

    if (Zoom > Integer(High(TTimelineZoomType))) then Zoom := Integer(High(TTimelineZoomType));

    FTimelineZoomType := TTimelineZoomType(Zoom);
    TimelineZoomPosition := GetPositionByZoomType(FTimelineZoomType);
  end;}
end;

procedure TfrmChannel.DisplayPlayListGrid(AIndex: Integer; AAddCount: Integer);
var
  I, J, NodeCheckCount: Integer;
  Item: PCueSheetItem;
begin
  inherited;
      Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('DisplayPlayListGrid, index = %d, addcount = %d', [AIndex, AAddCount])));

  if (FCueSheetList = nil) then exit;

  with acgPlaylist do
  begin
    BeginUpdate;
    try
      if (FixedRows > 0) then
      begin
        if (IsNode(0)) then
          FIsContrctAll := GetNodeState(0)
        else
        begin
          AddNode(0, FixedRows);
          SetNodeState(0, FIsContrctAll);
        end;
      end;

      if (AAddCount = 0) then
      begin
        RowCount := {RowCount + }FCueSheetList.Count + CNT_CUESHEET_HEADER + CNT_CUESHEET_FOOTER;
        NodeCheckCount := FCueSheetList.Count;
      end
      else
      begin
      SaveHideRowList;
      ExpandAll;
        RowCount := RowCount + AAddCount;    {//RowCount�� �����  ���� Node ������ �ݿ����� ����
//          for I := 0 to AAddCount - 1 do
//            InsertNormalRow(AIndex + CNT_CUESHEET_HEADER);
                                                              }


//            AddRow;
{        if (AIndex >= FLastCount) then
        begin
          for I := 0 to AAddCount - 1 do
            AddRow;
        end
        else  }
//          InsertRows(AIndex + CNT_CUESHEET_HEADER, AAddCount);

        NodeCheckCount := AAddCount;
      end;

//      for I := AIndex to FCueSheetList.Count - 1 do
      for I := AIndex to AIndex + NodeCheckCount - 1 do
      begin
        PopulatePlayListGrid(I);
      end;

      I := AIndex + CNT_CUESHEET_HEADER;//OldRowCount - CNT_CUESHEET_FOOTER;
      J := AIndex + CNT_CUESHEET_HEADER;//OldRowCount - CNT_CUESHEET_FOOTER;
//      while (I < AllRowCount - CNT_CUESHEET_FOOTER - 1) do
      while (I < AIndex + NodeCheckCount) and (I < AllRowCount - CNT_CUESHEET_FOOTER - 1) do
      begin
        Item := GetCueSheetItemByIndex((I) - CNT_CUESHEET_HEADER);

        if (Item <> nil) and (Item^.EventMode = EM_PROGRAM) then
        begin
          while (J < AllRowCount - CNT_CUESHEET_FOOTER - 1) and (Item^.ProgramNo = FCueSheetList[(J) - CNT_CUESHEET_HEADER + 1]^.ProgramNo) do
          begin
            Inc(J);
          end;

          if (I <> J) then
          begin
            AddNode(I, J - I + 1);
            SetNodeState(DisplRowIndex(I), FIsContrctAll);

//            CellProperties[0, DisplRowIndex(I)].NodeLevel := 1; // Because of node show tree bug
          end;
  //        else
  //          CellProperties[0, I].NodeLevel := 0; // Because of node show tree bug
        end;
        I := J + 1;
        J := I;
      end;

      I := AIndex + CNT_CUESHEET_HEADER;//OldRowCount - CNT_CUESHEET_FOOTER;
      J := AIndex + CNT_CUESHEET_HEADER;//OldRowCount - CNT_CUESHEET_FOOTER;
//      while (I < AllRowCount - CNT_CUESHEET_FOOTER - 1) do
      while (I < AIndex + NodeCheckCount) and (I < AllRowCount - CNT_CUESHEET_FOOTER - 1) do
      begin
        Item := GetCueSheetItemByIndex((I) - CNT_CUESHEET_HEADER);

        if (Item <> nil) then
        begin
          while (J < AllRowCount - CNT_CUESHEET_FOOTER - 1) and (Item^.GroupNo = FCueSheetList[(J) - CNT_CUESHEET_HEADER + 1]^.GroupNo) do
          begin
            Inc(J);
          end;

          if (I <> J) then
          begin
            AddNode(I, J - I + 1);
            SetNodeState(DisplRowIndex(I), FIsContrctAll);

//            CellProperties[0, DisplRowIndex(I)].NodeLevel := 1; // Because of node show tree bug
          end;
  //        else
  //          CellProperties[0, I].NodeLevel := 0; // Because of node show tree bug
        end;
        I := J + 1;
        J := I;
      end;

      MergeCells(IDX_COL_CUESHEET_NO, RowCount - 1, ColCount - IDX_COL_CUESHEET_NO, 1);
  //    ContractAll;
    finally

//      GroupColumn := 2;

      if (AAddCount <> 0) then LoadHideRowList;
      EndUpdate;
    end;
    lblEventCount.Caption := Format('%d / %d', [SelectedRowCount, FCueSheetList.Count + 1]);
  end;
end;

procedure TfrmChannel.DisplayPlayListGrid(AIndex: Integer; AItem: PCueSheetItem);
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
{    if (AItem^.EventMode = EM_PROGRAM) then
    begin
      InsertNormalRow(AIndex);
    end
    else if (AItem^.EventMode = EM_MAIN) then
    begin
      PItem := GetProgramItemByIndex(AIndex);
      if (PItem <> nil) then
      begin
        PIndex := GetCueSheetIndexByItem(PItem);
        if (not IsNode(DisplRowIndex(PIndex + CNT_CUESHEET_HEADER))) then
          AddNode(PIndex + CNT_CUESHEET_HEADER, 1);

        InsertChildRow(PIndex + CNT_CUESHEET_HEADER, AIndex - PIndex);
  //      PopulatePlayListTimeLine(ProgIndex);
      end
      else
        InsertNormalRow(AIndex + CNT_CUESHEET_HEADER);
    end
    else
    begin
      PItem := GetParentCueSheetItemByIndex(AIndex);
      if (PItem<> nil) then
      begin
        PIndex := GetCueSheetIndexByItem(PItem);
        if (not IsNode(DisplRowIndex(PIndex + CNT_CUESHEET_HEADER))) then
          AddNode(PIndex + CNT_CUESHEET_HEADER, 1);

        InsertChildRow(PIndex + CNT_CUESHEET_HEADER, AIndex - PIndex);// + 1);
      end;
    end;

    exit; }

    if (AItem^.EventMode = EM_PROGRAM) then
    begin
      R := RealRowIndex(AIndex + CNT_CUESHEET_HEADER);
      InsertNormalRow(R);

      Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('InsertNormalRow mairogram, %d', [R])));
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

        Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('InsertNormalRow main, %d', [R])));
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

procedure TfrmChannel.PopulatePlayListGrid(AIndex: Integer);
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

exit;
    CueSheetItem := GetCueSheetItemByIndex(AIndex);
    if (CueSheetItem <> nil) then
    begin
      with CueSheetItem^ do
      begin
        if (EventMode = EM_COMMENT) then
        begin
          AllCells[IDX_COL_CUESHEET_NO, R] := String(Title);
          MergeCells(IDX_COL_CUESHEET_NO, DisplRowIndex(R), ColCount - IDX_COL_CUESHEET_NO, 1);
          exit;
        end
        else
        begin
          SplitCells(IDX_COL_CUESHEET_NO, DisplRowIndex(R));
          if (EventMode = EM_MAIN) then
          begin
            AllCells[IDX_COL_CUESHEET_NO, R]         := Format('%d', [FLastDisplayNo + 1]);
//            AllCells[IDX_COL_CUESHEET_NO, R]         := Format('%d', [GroupNo + 1]);
//            AllCells[IDX_COL_CUESHEET_START_DATE, R] := FormatDateTime(FORMAT_DATE, StartTime.D);
            Inc(FLastDisplayNo);
          end
          else
          begin
            AllCells[IDX_COL_CUESHEET_NO, R]         := '';
//            AllCells[IDX_COL_CUESHEET_START_DATE, R] := '';
          end;
        end;

        AllCells[IDX_COL_CUESHEET_EVENT_MODE, R]   := EventModeShortNames[EventMode];
        AllCells[IDX_COL_CUESHEET_START_MODE, R]   := StartModeNames[StartMode];

        if (EventMode = EM_MAIN) and (EventStatus.State <> esSkipped) then
          AllCells[IDX_COL_CUESHEET_START_DATE, R] := FormatDateTime(FORMAT_DATE, StartTime.D)
        else
          AllCells[IDX_COL_CUESHEET_START_DATE, R] := '';

        if (EventMode in [EM_MAIN, EM_SUB]) and (EventStatus.State <> esSkipped) then
          AllCells[IDX_COL_CUESHEET_START_TIME, R] := TimecodeToString(StartTime.T, ChannelIsDropFrame)
        else
          AllCells[IDX_COL_CUESHEET_START_TIME, R] := '';

        AllCells[IDX_COL_CUESHEET_INPUT, R]        := InputTypeNames[Input];

        if (Input in [IT_MAIN, IT_BACKUP]) then
          AllCells[IDX_COL_CUESHEET_OUTPUT, R]     := OutputBkgndTypeNames[TOutputBkgndType(Output)]
        else
          AllCells[IDX_COL_CUESHEET_OUTPUT, R]     := OutputKeyerTypeNames[TOutputKeyerType(Output)];

        AllCells[IDX_COL_CUESHEET_EVENT_STATUS, R]  := EventStatusNames[EventStatus.State];
//        AllCells[IDX_COL_CUESHEET_DEVICE_STATUS, R] := GetDeviceStatusName(DeviceStatus);

        AllCells[IDX_COL_CUESHEET_TITLE, R]        := String(Title);
        AllCells[IDX_COL_CUESHEET_SUB_TITLE, R]    := String(SubTitle);
        AllCells[IDX_COL_CUESHEET_SOURCE, R]       := String(Source);
        AllCells[IDX_COL_CUESHEET_MEDIA_ID, R]     := String(MediaId);

        if (EventMode <> EM_JOIN) then
        begin
          AllCells[IDX_COL_CUESHEET_DURATON, R]    := TimecodeToString(DurationTC, ChannelIsDropFrame);
          AllCells[IDX_COL_CUESHEET_IN_TC, R]      := TimecodeToString(InTC, ChannelIsDropFrame);
          AllCells[IDX_COL_CUESHEET_OUT_TC, R]     := TimecodeToString(OutTC, ChannelIsDropFrame);
        end
        else
        begin
          AllCells[IDX_COL_CUESHEET_DURATON, R]    := '';
          AllCells[IDX_COL_CUESHEET_IN_TC, R]      := '';
          AllCells[IDX_COL_CUESHEET_OUT_TC, R]     := '';
        end;

        AllCells[IDX_COL_CUESHEET_VIDEO_TYPE, R]      := VideoTypeNames[VideoType];
        AllCells[IDX_COL_CUESHEET_AUDIO_TYPE, R]      := AudioTypeNames[AudioType];
        AllCells[IDX_COL_CUESHEET_CLOSED_CAPTION, R]  := ClosedCaptionNames[ClosedCaption];
        AllCells[IDX_COL_CUESHEET_VOICE_ADD, R]       := VoiceAddNames[VoiceAdd];

        AllCells[IDX_COL_CUESHEET_TR_TYPE, R]       := TRTypeNames[TransitionType];
        AllCells[IDX_COL_CUESHEET_TR_RATE, R]       := TRRateNames[TransitionRate];
        AllCells[IDX_COL_CUESHEET_FINISH_ACTION, R] := FinishActionNames[FinishAction];
        AllCells[IDX_COL_CUESHEET_PROGRAM_TYPE, R]  := GetProgramTypeNameByCode(ProgramType);
        AllCells[IDX_COL_CUESHEET_NOTES, R]         := String(Notes);
      end;
    end;
  end;
end;

procedure TfrmChannel.PopulateEventStatusPlayListGrid(AIndex: Integer; AItem: PCueSheetItem);
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
{    else
    begin
      if (AStatus.State in [esCueing..esFinished]) then TopRow := R;
    end};

{    CueSheetItem := GetCueSheetItemByIndex(AIndex);
    if (CueSheetItem <> nil) then
    begin
      with CueSheetItem^ do
      begin
        if (EventMode = EM_MAIN) and (EventStatus <> esSkipped) then
          AllCells[IDX_COL_CUESHEET_START_DATE, R] := FormatDateTime(FORMAT_DATE, StartTime.D)
        else
          AllCells[IDX_COL_CUESHEET_START_DATE, R] := '';

        if (EventMode in [EM_MAIN, EM_SUB]) and (EventStatus <> esSkipped) then
          AllCells[IDX_COL_CUESHEET_START_TIME, R] := TimecodeToString(StartTime.T)
        else
          AllCells[IDX_COL_CUESHEET_START_TIME, R] := '';

        AllCells[IDX_COL_CUESHEET_EVENT_STATUS, R]  := EventStatusNames[EventStatus];
//        AllCells[IDX_COL_CUESHEET_DEVICE_STATUS, R] := GetDeviceStatusName(DeviceStatus);
      end;
    end;  }
//    RepaintRow(R);
  end;
end;

procedure TfrmChannel.PopulateMediaCheckPlayListGrid(AIndex: Integer; AItem: PCueSheetItem);
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

procedure TfrmChannel.ErrorDisplayPlayListGrid;
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
{          case Item^.EventStatus.ErrorCode of
            E_INVALID_START_TIME:
            begin
              RepaintCell(IDX_COL_CUESHEET_START_DATE, I);
              RepaintCell(IDX_COL_CUESHEET_START_TIME, I);
            end;
            else
              RepaintCell(IDX_COL_CUESHEET_SOURCE, I);
          end; }

          if ((Item^.EventStatus.ErrorCode and E_INVALID_START_TIME) = E_INVALID_START_TIME) or
             ((Item^.EventStatus.ErrorCode and E_DUPLICATED_START_TIME) = E_DUPLICATED_START_TIME) or
             ((Item^.EventStatus.ErrorCode and E_BLANK_START_TIME) = E_BLANK_START_TIME) then
          begin
            RepaintCell(IDX_COL_CUESHEET_START_DATE, I);
            RepaintCell(IDX_COL_CUESHEET_START_TIME, I);
          end;

          if ((Item^.EventStatus.ErrorCode and E_INVALID_DEVICE_NAME) = E_INVALID_DEVICE_NAME) or
             ((Item^.EventStatus.ErrorCode and E_INVALID_DEVICE_HANDLE) = E_INVALID_DEVICE_HANDLE) or
             ((Item^.EventStatus.ErrorCode and E_DUPLICATED_DEVICE) = E_DUPLICATED_DEVICE) or
             ((Item^.EventStatus.ErrorCode and E_NOT_SUCCESSIVE_DEVICE) = E_NOT_SUCCESSIVE_DEVICE) then
          begin
            RepaintCell(IDX_COL_CUESHEET_SOURCE, I);
          end;

          if ((Item^.EventStatus.ErrorCode and E_EMPTY_MEDIA_ID) = E_EMPTY_MEDIA_ID) then
          begin
            RepaintCell(IDX_COL_CUESHEET_MEDIA_ID, I);
          end;
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

procedure TfrmChannel.SelectRowPlayListGrid(AIndex: Integer);
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

procedure TfrmChannel.InsertPlayListGridProgram(AIndex: Integer);
begin
  if (not HasMainControl) then exit;

  with acgPlaylist do
  begin
    InsertNormalRow(AIndex + CNT_CUESHEET_HEADER);

    PopulatePlayListGrid(AIndex);
  end;
end;

procedure TfrmChannel.InsertPlayListGridMain(AIndex: Integer);
var
  ProgItem: PCueSheetItem;
  ProgIndex: Integer;
begin
  if (not HasMainControl) then exit;

  with acgPlaylist do
  begin
    ProgItem := GetProgramItemByIndex(AIndex);
    if (ProgItem <> nil) then
    begin
      ProgIndex := GetCueSheetIndexByItem(ProgItem);
      if (not IsNode(DisplRowIndex(ProgIndex + CNT_CUESHEET_HEADER))) then
        AddNode(ProgIndex + CNT_CUESHEET_HEADER, 1);

      InsertChildRow(ProgIndex + CNT_CUESHEET_HEADER, AIndex - ProgIndex);
//      PopulatePlayListTimeLine(ProgIndex);
    end
    else
      InsertNormalRow(AIndex + CNT_CUESHEET_HEADER);

    PopulatePlayListGrid(AIndex);
  end;
end;

procedure TfrmChannel.InsertPlayListGridSub(AIndex: Integer);
var
  ParentItem: PCueSheetItem;
  ParentIndex: Integer;
begin
  if (not HasMainControl) then exit;

  with acgPlaylist do
  begin
    ParentItem := GetParentCueSheetItemByIndex(AIndex);
    if (ParentItem <> nil) then
    begin
      ParentIndex := GetCueSheetIndexByItem(ParentItem);
      if (not IsNode(DisplRowIndex(ParentIndex + CNT_CUESHEET_HEADER))) then
        AddNode(ParentIndex + CNT_CUESHEET_HEADER, 1);

      InsertChildRow(ParentIndex + CNT_CUESHEET_HEADER, AIndex - ParentIndex);// + 1);
//      PopulatePlayListTimeLine(ParentIndex);

//      PopulatePlayListGrid(AIndex);
    end;
  end;
end;

procedure TfrmChannel.DeletePlayListGridProgram(AIndex: Integer);
var
  RRow, DRow: Integer;
begin
//  if (not HasMainControl) then exit;

  with acgPlaylist do
  begin
    RRow := AIndex + CNT_CUESHEET_HEADER;
    DRow := DisplRowIndex(RRow);

    RemoveNormalRow(RRow);

//    if (IsNode(DRow)) then
//      RemoveNode(RRow);

  end;
end;

procedure TfrmChannel.DeletePlayListGridMain(AIndex: Integer);
var
  ProgItem: PCueSheetItem;
  ProgIndex: Integer;

  RRow, DRow: Integer;
  PRow: Integer;
  NodeSpan: Integer;
begin
//  if (not HasMainControl) then exit;

  with acgPlaylist do

  begin
    RRow := AIndex + CNT_CUESHEET_HEADER;
    if (IsHiddenRow(RRow)) then exit;

//    ShowMessage(IntToStr(RowCount));
    DRow := DisplRowIndex(RRow);
    PRow := GetParentRow(DRow);

    try
    NodeSpan := GetNodeSpan(DRow);
    if (NodeSpan > 1) then
    begin
    try
      ExpandNode(RRow);
    except
    Assert(False, GetChannelLogStr(lsError, ChannelID, Format('DeletePlayListGridMain procedure exception error 1-1. DRow = %d, RRow = %d', [DRow, RRow])));
    end;

      while (NodeSpan > 1)  do
      begin
//        Row := RRow + NodeSpan - 1 - 1;
    try
      ExpandNode(RRow);
    except
    Assert(False, GetChannelLogStr(lsError, ChannelID, Format('DeletePlayListGridMain procedure exception error 1-2. DRow = %d, RRow = %d', [DRow, RRow])));
    end;
    try
        RemoveChildRow(RRow + NodeSpan - 1);
        NodeSpan := GetNodeSpan(DRow);
    except
    Assert(False, GetChannelLogStr(lsError, ChannelID, Format('DeletePlayListGridMain procedure exception error 1-3. DRow = %d, RRow = %d', [DRow, RRow])));
    end;
      end;

    end;
    except
    Assert(False, GetChannelLogStr(lsError, ChannelID, Format('DeletePlayListGridMain procedure exception error 1-4. DRow = %d, RRow = %d', [DRow, RRow])));
    end;

    if (PRow >= 0) and (PRow < DRow)then
    begin
    try
//      Row := RRow - 1;
      RemoveChildRow(RRow);
    except
    Assert(False, GetChannelLogStr(lsError, ChannelID, Format('DeletePlayListGridMain procedure exception error 2. DRow = %d, RRow = %d', [DRow, RRow])));
    end;
    end
    else
    begin
    try
//      Row := DRow - 1;
      RemoveNormalRow(DRow);
    except
    Assert(False, GetChannelLogStr(lsError, ChannelID, Format('DeletePlayListGridMain procedure exception error 3. DRow = %d, RRow = %d', [DRow, RRow])));
    end;
    end;
//    ShowMessage(IntToStr(RowCount));

    try
    if (PRow >= 0) and (PRow < DRow)then
    begin
      NodeSpan := GetNodeSpan(PRow);
      if (NodeSpan <= 1) then
        RemoveNode(RealRowIndex(PRow));
    end;
    except
    Assert(False, GetChannelLogStr(lsError, ChannelID, Format('DeletePlayListGridMain procedure exception error 4. DRow = %d, RRow = %d', [DRow, RRow])));
    end;

    exit;


//      UnHideRow(RRow);

{    // Delete child row checking
    NodeSpan := GetNodeSpan(DRow);
    if (NodeSpan > 1) then
    begin
      ExpandNode(DRow);
      repeat
        RemoveChildRow(RRow + 1);
      until (GetNodeSpan(DRow) <= 1);
    end; }

    PRow := GetParentRow(DRow);
    RemoveChildRow(RRow);

    if (PRow > 0) then // and (PRow < DRow) then
    begin
      NodeSpan := GetNodeSpan(PRow);
      if (NodeSpan <= 1) then
        RemoveNode(RealRowIndex(PRow));
    end;


{    ParentRow := GetParentRow(DisplRowIndex(AIndex + CNT_CUESHEET_HEADER));
    ShowMessage(Format('%d, %d', [DisplRowIndex(AIndex + CNT_CUESHEET_HEADER), ParentRow]));

    ProgItem := GetProgramItemByIndex(AIndex);
    if (ProgItem <> nil) then
    begin
{      ProgIndex := GetCueSheetIndexByItem(ProgItem);
      if (not IsNode(DisplRowIndex(ProgIndex + CNT_CUESHEET_HEADER))) then
        AddNode(ProgIndex + CNT_CUESHEET_HEADER, 1); }

{      RemoveChildRow(AIndex + CNT_CUESHEET_HEADER);
    end
    else
    begin
      if (IsNode(DisplRowIndex(AIndex + CNT_CUESHEET_HEADER))) then
        RemoveNode(AIndex + CNT_CUESHEET_HEADER);

      RemoveNormalRow(AIndex + CNT_CUESHEET_HEADER);
    end; }
  end;
end;

procedure TfrmChannel.DeletePlayListGridSub(AIndex: Integer);
var
  ParentItem: PCueSheetItem;
  ParentIndex: Integer;

  RRow, DRow: Integer;
  PRow: Integer;
  NodeSpan: Integer;
begin
  if (not HasMainControl) then exit;

  with acgPlaylist do
  begin
    RRow := AIndex + CNT_CUESHEET_HEADER;
    if (IsHiddenRow(RRow)) then exit;

    DRow := DisplRowIndex(RRow);

//    if (IsHiddenRow(RRow)) then
//      UnHideRow(RRow);
//    exit;
//    if (IsHiddenRow(RRow)) then ShowMessage('RRow hidden');


    PRow := GetParentRow(DRow);

    RemoveChildRow(RRow);
//        RemoveNode(RealRowIndex(PRow));
    if (PRow > 0) then // and (PRow < DRow) then
    begin
      NodeSpan := GetNodeSpan(PRow);
      if (NodeSpan <= 1) then
        RemoveNode(RealRowIndex(PRow));
    end;



{    ParentItem := GetParentCueSheetItemByIndex(AIndex);

    if (ParentItem <> nil) then
    begin
      ParentIndex := GetCueSheetIndexByItem(ParentItem);

      ExpandNode(ParentIndex + CNT_CUESHEET_HEADER);
      RemoveChildRow(AIndex + CNT_CUESHEET_HEADER);
//      UpdateNodeSpan(ParentIndex + CNT_CUESHEET_HEADER, -1);

      NodeSpan := acgPlaylist.GetNodeSpan(DisplRowIndex(ParentIndex + CNT_CUESHEET_HEADER));
      if (NodeSpan <= 1) then
        RemoveNode(ParentIndex + CNT_CUESHEET_HEADER); }


//      PopulatePlayListGrid(AIndex);

{      ParentIndex := GetCueSheetIndexByItem(ParentItem);
      if (not IsNode(DisplRowIndex(ParentIndex + CNT_CUESHEET_HEADER))) then
        AddNode(ParentIndex + CNT_CUESHEET_HEADER, 1); }

//    end;
  end;
end;

{procedure TfrmChannel.DisplayPlayListGrid(AIndex: Integer; ACount: Integer);
var
  I, J: Integer;
  OldRowCount: Integer;
  CueSheetItem: PCueSheetItem;
  ParentItem: PCueSheetItem;
  DurTime: TEventTime;
begin
  inherited;
//exit;

  if (FChannelCueSheet = nil) then exit;
  if (FCueSheetList = nil) then exit;

  with acgPlaylist do
  begin
    OldRowCount := RowCount;
    RowCount := RowCount + ACount;

    for I := AIndex to FCueSheetList.Count - 1 do
    begin
//      AddRow;
      PopulatePlayListGrid(I);
    end;

//    if (FAddedCount > 0) then
//    begin
//      if (FLastCount > 0) then
//        ParentItem := GetParentCueSheetItemByIndex(FLastCount - 1);
////      else
////        ParentItem := GetCueSheetItemByIndex(FLastCount);
//
//      if (ParentItem <> nil) then
//      begin
//        CueSheetItem := GetNextMainItemByItem(ParentItem);
//        if (CueSheetItem <> nil) then
//        begin
//{          ShowMessage(EventTimeToDateTimecodeStr(ParentItem^.StartTime));
//          ShowMessage(EventTimeToDateTimecodeStr(CueSheetItem^.StartTime));
//          ShowMessage(EventTimeToDateTimecodeStr(DurTime)); }
//          if (CompareEventTime(ParentItem^.StartTime, CueSheetItem^.StartTime) > 0) then
//          begin
//            DurTime := GetDurEventTime(CueSheetItem^.StartTime, GetEventEndTime(ParentItem^.StartTime, ParentItem^.DurationTC));
//            ResetStartTimePlus(FCueSheetList.IndexOf(CueSheetItem), DurTime)
//          end
//          else
//          begin
//            DurTime := GetDurEventTime(GetEventEndTime(ParentItem^.StartTime, ParentItem^.DurationTC), CueSheetItem^.StartTime);
//            ResetStartTimeMinus(FCueSheetList.IndexOf(CueSheetItem), DurTime);
//          end;
//        end;
//      end;
//    end;

//    SaveFixedCells := False; // Because of node expand and collpase bug

{    RemoveAllNodes;
    I := CNT_CUESHEET_HEADER;//OldRowCount - CNT_CUESHEET_FOOTER;
    J := CNT_CUESHEET_HEADER;//OldRowCount - CNT_CUESHEET_FOOTER;
    while (I < RowCount - CNT_CUESHEET_FOOTER - 1) do
    begin
      CueSheetItem := GetCueSheetItemByIndex(RealRowIndex(I) - CNT_CUESHEET_HEADER);

      if (CueSheetItem <> nil) then
      begin
        if (CueSheetItem^.EventMode = EM_COMMENT) then
        begin
          Inc(I);
          Inc(J);
          Continue;
        end;

        while (J < RowCount - CNT_CUESHEET_FOOTER - 1) and (CueSheetItem^.GroupNo = FCueSheetList[RealRowIndex(J) - CNT_CUESHEET_HEADER + 1]^.GroupNo) do
          Inc(J);

        if (I <> J) then
          AddNode(I, J - I + 1)
        else
          CellProperties[0, I].NodeLevel := 0; // Because of node show tree bug
      end;
      I := J + 1;
      J := I;
    end;

//    with Columns[IDX_COL_CUESHEET_GROUP] do
//      AutoSize := True;

    ContractAll;

    Cells[IDX_COL_CUESHEET_NO, RowCount - 1] := 'End of event';
    MergeCells(IDX_COL_CUESHEET_NO, RowCount - 1, ColCount - IDX_COL_CUESHEET_NO, 1);
    EndUpdate;
  end;
end; }

procedure TfrmChannel.CalcuratePlayListTimeLineRange;
var
  Item: PCueSheetItem;
begin
  inherited;

  if (FCueSheetList = nil) then exit;

  Item := GetFirstMainItem;
  if (Item <> nil) then
  begin
    FTimelineStartDate := EventTimeToDate(Item^.StartTime);
  end
  else
    FTimelineStartDate := Date;

  Item := GetLastMainItem;
  if (Item <> nil) then
  begin
    FTimelineEndDate := EventTimeToDate(GetEventEndTime(Item^.StartTime, Item^.DurationTC, ChannelFrameRateType));
  end
  else
    FTimelineEndDate := FTimelineStartDate;

{  if (FChannelTimelineForm <> nil) then
  begin
    FChannelTimelineForm.CalcuratePlayListTimeLineRange(FTimelineStartDate, FTimelineEndDate);
  end; }
end;

procedure TfrmChannel.CalcuratePlayListTimeLineRange(ADurEventTime: TEventTime);
var
  Item: PCueSheetItem;
begin
  inherited;

  if (FCueSheetList = nil) then exit;

  Item := GetFirstMainItem;
  if (Item <> nil) then
  begin
    FTimelineStartDate := EventTimeToDate(Item^.StartTime);
  end
  else
    FTimelineStartDate := Date;

  Item := GetLastMainItem;
  if (Item <> nil) then
  begin
    FTimelineEndDate := EventTimeToDate(GetPlusEventTime(GetEventEndTime(Item^.StartTime, Item^.DurationTC, ChannelFrameRateType), ADurEventTime, ChannelFrameRateType));
  end
  else
    FTimelineEndDate := FTimelineStartDate;

{  if (FChannelTimelineForm <> nil) then
  begin
    FChannelTimelineForm.CalcuratePlayListTimeLineRange(FTimelineStartDate, FTimelineEndDate);
  end; }
end;

procedure TfrmChannel.UpdatePlayListTimeLineRange;
begin
  inherited;

  with wmtlPlaylist do
  begin
    TimeZoneProperty.FrameStart := 0;
    TimeZoneProperty.FrameCount := (Trunc(DaySpan(FTimelineStartDate, FTimelineEndDate)) + 1) * FTimeLineDaysPerFrames;
  end;

  frmSEC.UpdateZoomPosition(GV_TimeLineZoomPosition);

{  if (FChannelTimelineForm <> nil) then
  begin
    FChannelTimelineForm.UpdatePlayListTimeLineRange(wmtlPlaylist);
  end; }

  ServerSetTimelineRange(ChannelID, FTimelineStartDate, FTimelineEndDate);
end;

procedure TfrmChannel.PopulatePlayListTimeLine(AIndex: Integer);
var
  I: Integer;
  Item, ParentItem: PCueSheetItem;
  CompIndex: Integer;
  Track: TTrack;
  SubStartTime: TEventTime;
begin
  Item := GetCueSheetItemByIndex(AIndex);
  if (Item <> nil) then
  begin
    if (Item^.EventStatus.State = esSkipped) then exit;

    with wmtlPlaylist do
    begin
      CompIndex := 0;
      case Item^.EventMode of
        EM_PROGRAM: CompIndex := 0;
        EM_MAIN: CompIndex := 1;
        EM_JOIN,
        EM_SUB: CompIndex := GetChildCueSheetIndexByItem(Item) + 1;
        else
          exit;
      end;

      if (CompIndex >= 0) and (CompIndex < DataGroupProperty.Count) then
      begin
        Track := DataCompositions[CompIndex].Tracks.GetTrackByData(Item);
        if (Track = nil) then
        begin
          Track := DataCompositions[CompIndex].Tracks.Add;
          Track.Data := Item;
        end;

        case Item^.EventMode of
          EM_PROGRAM:
          begin
            ParentItem := GetProgramMainItemByItem(Item);
            if (ParentItem <> nil) then
            begin
              Track.InPoint  := TimecodeToFrame(ParentItem^.StartTime.T, GV_SettingOption.TimelineFrameRateType) + Trunc(ParentItem^.StartTime.D - FTimelineStartDate) * FTimeLineDaysPerFrames;
              Track.OutPoint := Track.InPoint + TimecodeToFrame(GetProgramDurationByItem(Item), GV_SettingOption.TimelineFrameRateType);
            end;
          end;
          EM_MAIN:
          begin
            Track.InPoint  := TimecodeToFrame(Item^.StartTime.T, GV_SettingOption.TimelineFrameRateType) + Trunc(Item^.StartTime.D - FTimelineStartDate) * FTimeLineDaysPerFrames;
            Track.OutPoint := Track.InPoint + TimecodeToFrame(Item^.DurationTC, GV_SettingOption.TimelineFrameRateType);
          end;
          EM_JOIN:
          begin
            ParentItem := GetParentCueSheetItemByItem(Item);
            if (ParentItem <> nil) then
            begin
              SubStartTime := GetEventTimeSubBegin(ParentItem^.StartTime, Item^.StartTime.T, GV_SettingOption.TimelineFrameRateType);
              Track.InPoint  := TimecodeToFrame(SubStartTime.T, GV_SettingOption.TimelineFrameRateType) + Trunc(SubStartTime.D - FTimelineStartDate) * FTimeLineDaysPerFrames;
              Track.OutPoint := Track.InPoint + TimecodeToFrame(Item^.DurationTC, GV_SettingOption.TimelineFrameRateType);
            end;
          end;
          EM_SUB:
          begin
            ParentItem := GetParentCueSheetItemByItem(Item);
            if (ParentItem <> nil) then
            begin
              if (Item^.StartMode = SM_SUBBEGIN) then
                SubStartTime := GetEventTimeSubBegin(ParentItem^.StartTime, Item^.StartTime.T, GV_SettingOption.TimelineFrameRateType)
              else
                SubStartTime := GetEventTimeSubEnd(ParentItem^.StartTime, ParentItem^.DurationTC, Item^.StartTime.T, GV_SettingOption.TimelineFrameRateType);

              Track.InPoint  := TimecodeToFrame(SubStartTime.T, GV_SettingOption.TimelineFrameRateType) + Trunc(SubStartTime.D - FTimelineStartDate) * FTimeLineDaysPerFrames;
              Track.OutPoint := Track.InPoint + TimecodeToFrame(Item^.DurationTC, GV_SettingOption.TimelineFrameRateType);
            end;
          end;
        end;

        Track.Duration := Track.OutPoint - Track.InPoint;

        if (Item^.EventMode = EM_PROGRAM) then
        begin
          Track.Color        := clAqua;
          Track.ColorCaption := clAqua;
          Track.Caption      := '';
        end
        else
        begin
          Track.Color          := GetProgramTypeColorByCode(Item^.ProgramType);
          Track.ColorCaption   := GetProgramTypeColorByCode(Item^.ProgramType);
//          Track.ColorSelected  := Track.Color;
//          Track.ColorHighLight := $000E0607;
//          Track.ColorShadow    := $000E0607;

          Track.Caption := String(Item^.Title);
        end;

        if (Track.InPoint < FTimeLineMin) then FTimeLineMin := Track.InPoint;
        if (Track.OutPoint > FTimeLineMax) then FTimeLineMax := Track.OutPoint;
//

//        if (frmAllChannels <> nil) and (Item^.EventMode = EM_MAIN) then
//          frmAllChannels.PopulatePlayListTimeLine(Item);
      end;

//      FTimeLineMin := MinInPoint;
//      FTimeLineMax := MaxOutPoint;
    end;
  end;
end;

procedure TfrmChannel.PopulatePlayListTimeLine(AItem: PCuesheetItem);
begin
  PopulatePlayListTimeLine(GetCueSheetIndexByItem(AItem));
end;

procedure TfrmChannel.PopulateEventStatusPlayListTimeLine(AIndex: Integer; AItem: PCueSheetItem);
var
  CompIndex: Integer;
  Track: TTrack;

  BackColor, FontColor: TColor;
begin
  if (AItem <> nil) then
  begin
    with wmtlPlaylist do
    begin
      BeginUpdateCompositions;
      try
        CompIndex := 0;
        case AItem^.EventMode of
          EM_PROGRAM: CompIndex := 0;
          EM_MAIN: CompIndex := 1;
          EM_JOIN,
          EM_SUB: CompIndex := GetChildCueSheetIndexByItem(AItem) + 1;
          else
            exit;
        end;

        if (CompIndex >= 0) and (CompIndex < DataGroupProperty.Count) then
        begin
          Track := DataCompositions[CompIndex].Tracks.GetTrackByData(AItem);
          if (Track <> nil) then
          begin
            if (AItem^.EventStatus.State = esSkipped) then
            begin
              FreeAndNil(Track);
              exit;
            end;

{            if (CueSheetNext <> nil) and (AItem^.GroupNo = CueSheetNext^.GroupNo) and
               ((not FChannelOnAir) or ((CueSheetNext^.EventStatus.State in [esLoaded]) and (AItem^.EventStatus.State in [esLoaded]))) then
            begin
              BackColor := COLOR_BK_EVENTSTATUS_NEXT;
              FontColor := COLOR_TX_EVENTSTATUS_NEXT;
            end
            else
            begin
              case AItem^.EventStatus.State of
                esCueing..esPreroll:
                begin
                  BackColor := COLOR_BK_EVENTSTATUS_CUED;
                  FontColor := COLOR_TX_EVENTSTATUS_CUED;
                end;
                esOnAir:
                begin
                  BackColor := COLOR_BK_EVENTSTATUS_ONAIR;
                  FontColor := COLOR_TX_EVENTSTATUS_ONAIR;
                end;
                esSkipped,
                esFinish..esDone:
                begin
                  BackColor := COLOR_BK_EVENTSTATUS_DONE;
                  FontColor := COLOR_TX_EVENTSTATUS_DONE;
                end;
                esError:
                begin
                  BackColor := COLOR_BK_EVENTSTATUS_ERROR;
                  FontColor := COLOR_TX_EVENTSTATUS_ERROR;
                end;
                else
                begin
                  if (CueSheetTarget <> nil) and (AItem^.GroupNo = CueSheetTarget^.GroupNo) then
                  begin
                    BackColor := COLOR_BK_EVENTSTATUS_TARGET;
                    FontColor := COLOR_TX_EVENTSTATUS_TARGET;
                  end
                  else
                  begin
                    BackColor := COLOR_BK_EVENTSTATUS_NORMAL;
                    FontColor := COLOR_TX_EVENTSTATUS_NORMAL;
                  end;
                end;
              end;
            end;

            Track.Color        := BackColor;
            Track.ColorCaption := FontColor; }
          end;

          DataCompositions[CompIndex].Repaint;
        end;
      finally
        EndUpdateCompositions;
      end;
    end;
  end;
end;

procedure TfrmChannel.UpdateChangeDatePlayListTimeLine(ADays: Integer);
var
  I, J: Integer;
  Track: TTrack;
  Duration: Integer;
begin
  inherited;

  with wmtlPlaylist do
  begin
    BeginUpdateCompositions;
    try
      for I := 0 to DataGroupProperty.Count - 1 do
      begin
        for J := 0 to DataCompositions[I].Tracks.Count - 1 do
        begin
          Track := DataCompositions[I].Tracks[J];
          if (Track <> nil) then
          begin
            Duration := Track.Duration;

            Track.InPoint  := Track.InPoint - (ADays * FTimeLineDaysPerFrames);
            Track.OutPoint := Track.InPoint + Duration;
          end;
        end;
      end;
    finally
      EndUpdateCompositions;
    end;
  end;
end;

procedure TfrmChannel.RealtimeChangePlayListTimeLine;
var
  Days: Integer;

  F: Integer;
  SideFrames: Integer;

  CurrentTime: TDateTime;
begin
  inherited;

  CurrentTime := SystemTimeToDateTime(GV_TimeCurrent);

  if (FTimelineStartDate <> Date) then
  begin
    Days := Trunc(CurrentTime - FTimelineStartDate);
    FTimelineStartDate := Date;

    UpdateChangeDatePlayListTimeLine(Days);
  end;

  with wmtlPlaylist do
  begin
    with TimeZoneProperty do
    begin
//    BeginUpdateComositions;
      BeginUpdate;
      try
//        SideFrames := Round(FTimelineSpace / (FrameGap / FrameSkip)) - 1;
        SideFrames := Round(GV_SettingOption.TimelineSpace / (FrameGap / FrameSkip));
        SideFrames := (SideFrames div Round(FrameRate)) * Round(FrameRate) - 1;

        F := SampleTimeToFrame(SecondOfTheDay(CurrentTime), FrameRate);
        FrameStart :=  F - SideFrames - 1;
        wmtlPlaylist.FrameNumber := F;
      finally
        EndUpdate;
      end;
//    EndUpdateCompositions;
    end;
//    SetScrollPos(HorzScrollBar.Handle, SB_HORZ, 0, True);
  end;
end;

procedure TfrmChannel.DisplayPlayListTimeLine(AIndex: Integer);
var
  I: Integer;
  Item: PCueSheetItem;
begin
  inherited;

  if (AIndex < 0) then exit;
  if (FCueSheetList = nil) then exit;

  wmtlPlaylist.BeginUpdateCompositions;

  try
    Item := GetProgramItemByIndex(AIndex);
    if (Item <> nil) then
      AIndex := GetCueSheetIndexByItem(Item);

    for I := AIndex to FCueSheetList.Count - 1 do
    begin
      PopulatePlayListTimeLine(I);
    end;
  finally
    wmtlPlaylist.EndUpdateCompositions;
  end;

  frmSEC.UpdateZoomPosition(GV_TimeLineZoomPosition);
end;

procedure TfrmChannel.DisplayPlayListTimeLine(AIndex: Integer; AItem: PCueSheetItem);
var
  I: Integer;
  ProgItem: PCueSheetItem;
  ProgIndex: Integer;
  FirstItem: PCueSheetItem;
  LastMainItem: PCueSheetItem;
  LastEndTime: TEventTime;
  SideFrames: Integer;
begin
  inherited;

  if (AIndex < 0) then exit;
  if (AItem = nil) then exit;

  if (FCueSheetList = nil) then exit;

  FirstItem := GetFirstMainItem;
  if (FirstItem <> nil) then
    FTimelineStartDate := FirstItem^.StartTime.D;

  ProgItem := GetProgramItemByIndex(AIndex);
  if (ProgItem <> nil) then
    ProgIndex := GetCueSheetIndexByItem(ProgItem)
  else
    ProgIndex := AIndex;

  for I := ProgIndex to AIndex do
  begin
    PopulatePlayListTimeLine(I);
  end;

  with wmtlPlaylist do
  begin
    TimeZoneProperty.FrameStart := 0;

    LastMainItem := GetLastMainItem;
    if (LastMainItem <> nil) then
    begin
      LastEndTime := GetEventEndTime(LastMainItem^.StartTime, LastMainItem^.DurationTC, ChannelFrameRateType);

      TimeZoneProperty.FrameCount := (Trunc(DaySpan(FTimelineStartDate, EventTimeToDate(LastEndTime))) + 1) * FTimeLineDaysPerFrames
    end
    else
      TimeZoneProperty.FrameCount := FTimeLineDaysPerFrames;

//    FrameNumber := FTimeLineMin - SideFrames;
  end;
//  wmtlPlaylist.DataGroup.Visible := True;

//  wmtlPlaylist.MarkIn := FTimeLineMin + 1000;
//  wmtlPlaylist.MarkOut := FTimeLineMax - 1000;

  frmSEC.UpdateZoomPosition(GV_TimeLineZoomPosition);
end;

procedure TfrmChannel.DeletePlayListTimeLineByItem(AItem: PCueSheetItem);
var
  CompIndex: Integer;
  Track: TTrack;
begin
  if (AItem = nil) then exit;

  with wmtlPlaylist do
  begin
    CompIndex := 0;
    case AItem^.EventMode of
      EM_PROGRAM: CompIndex := 0;
      EM_MAIN: CompIndex := 1;
      EM_JOIN,
      EM_SUB:
        CompIndex := GetChildCueSheetIndexByItem(AItem) + 1;
      else
        exit;
    end;

    if (CompIndex >= 0) and (CompIndex < DataGroupProperty.Count) then
    begin
      Track := DataCompositions[CompIndex].Tracks.GetTrackByData(AItem);

      if (Track <> nil) then
      begin
        FreeAndNil(Track);
      end;
    end;
  end;

//  UpdateZoomPosition(FTimelineZoomPosition);
end;

procedure TfrmChannel.DeletePlayListTimeLineByIndex(AIndex: Integer);
var
  Item: PCueSheetItem;
  CompIndex: Integer;
  Track: TTrack;
begin
  if (AIndex < 0) then exit;

  Item := GetCueSheetItemByIndex(AIndex);
  if (Item = nil) then exit;

  with wmtlPlaylist do
  begin
    CompIndex := 0;
    case Item^.EventMode of
      EM_PROGRAM: CompIndex := 0;
      EM_MAIN: CompIndex := 1;
      EM_JOIN,
      EM_SUB:
        CompIndex := GetChildCueSheetIndexByItem(Item) + 1;
      else
        exit;
    end;

    if (CompIndex >= 0) and (CompIndex < DataGroupProperty.Count) then
    begin
      Track := DataCompositions[CompIndex].Tracks.GetTrackByData(Item);

      if (Track <> nil) then
      begin
        FreeAndNil(Track);
      end;
    end;
  end;
end;

procedure TfrmChannel.ErrorDisplayPlayListTimeLine;
var
  I, J: Integer;
  Track: TTrack;
  Item: PCueSheetItem;
begin
  with wmtlPlaylist do
  begin
    BeginUpdateCompositions;
    try
      for I := 0 to DataGroupProperty.Count - 1 do
      begin
        for J := 0 to DataCompositions[I].Tracks.Count - 1 do
        begin
          Track := DataCompositions[I].Tracks[J];

          Item := Track.Data;
          if (Item <> nil) then
          begin
            if (Item^.EventStatus.State in [esError]) or
               (Item^.MediaStatus in [msNotExist, msShort]) then
            begin
              if (FErrorDisplayEnabled) then
              begin
                Track.Color        := COLOR_BK_EVENTSTATUS_ERROR;
                Track.ColorCaption := COLOR_BK_EVENTSTATUS_ERROR;
              end
              else
              begin
                Track.Color        := GetProgramTypeColorByCode(Item^.ProgramType);
                Track.ColorCaption := GetProgramTypeColorByCode(Item^.ProgramType);
              end;
            end;
          end;
        end;
      end;
    finally
      EndUpdateCompositions;
    end;
  end;

{  if (frmAllChannels <> nil) then
  begin
    frmAllChannels.ErrorDisplayPlayListTimeLine(FErrorDisplayEnabled);
  end; }
end;

procedure TfrmChannel.ResetNo(AIndex: Integer; ANo: Integer);
var
  I: Integer;
  CItem: PCueSheetItem;
begin
  if (FCueSheetList = nil) then exit;
  if (AIndex >= FCueSheetList.Count) then exit;

  FLastDisplayNo := ANo;
  for I := AIndex to FCueSheetList.Count - 1 do
  begin
    CItem := GetCueSheetItemByIndex(I);
    if (CItem <> nil) then
    begin
      if (CItem^.EventMode = EM_MAIN) then
      begin
  //      acgPlaylist.AllCells[IDX_COL_CUESHEET_NO, I + CNT_CUESHEET_HEADER] := Format('%d', [FLastDisplayNo + 1]);
        Inc(FLastDisplayNo);
      end;
      CItem^.DisplayNo := FLastDisplayNo;
    end;
  end;
end;

procedure TfrmChannel.ResetStartDate(AIndex: Integer; ADays: Integer);
var
  I: Integer;
  CItem: PCueSheetItem;
begin
  if (FCueSheetList = nil) then exit;
  if (AIndex >= FCueSheetList.Count) then exit;

  for I := AIndex to FCueSheetList.Count - 1 do
  begin
    CItem := GetCueSheetItemByIndex(I);
    if (CItem <> nil) then
    begin
      if (CItem^.EventMode <> EM_COMMENT) then
      begin
        CItem^.StartTime.D := IncDay(CItem^.StartTime.D, ADays);

{        // Update playlist grid
        if (CItem^.EventMode = EM_MAIN) then
        begin
          acgPlaylist.AllCells[IDX_COL_CUESHEET_START_DATE, I + CNT_CUESHEET_HEADER] := FormatDateTime(FORMAT_DATE, CItem^.StartTime.D);
        end; }
      end;
    end;
  end;
end;

procedure TfrmChannel.ResetStartTime(AIndex: Integer);
var
  ParentItem, NextItem: PCueSheetItem;
  ParentEndTime, DurTime: TEventTime;
begin
  if (FCueSheetList = nil) then exit;
  if (AIndex >= FCueSheetList.Count) then exit;

  ParentItem := GetParentCueSheetItemByIndex(AIndex);
  if (ParentItem <> nil) then
  begin


    NextItem := GetNextMainItemByItem(ParentItem);
    if (NextItem <> nil) then
    begin
      ParentEndTime := GetEventEndTime(ParentItem^.StartTime, ParentItem^.DurationTC, ChannelFrameRateType);
//      ShowMessage(EventTimeToDateTimecodeStr(GetEventEndTime(PItem^.StartTime, PItem^.DurationTC)));
      DurTime := GetDurEventTime(ParentEndTime, NextItem^.StartTime, ChannelFrameRateType);
//      ShowMessage(EventTimeToDateTimecodeStr(NItem^.StartTime));
{      ShowMessage(EventTimeToDateTimecodeStr(DurTime));
      ShowMessage(EventTimeToDateTimecodeStr(ParentEndTime));
      ShowMessage(EventTimeToDateTimecodeStr(NextItem^.StartTime)); }
//      ResetStartTimePlus(FCueSheetList.IndexOf(NItem), DurTime);
//exit;
      if (CompareEventTime(ParentEndTime, NextItem^.StartTime, ChannelFrameRateType) >= 0) then
      begin
//        DurTime := GetDurEventTime(NItem^.StartTime, GetEventEndTime(PItem^.StartTime, PItem^.DurationTC));
//        ShowMessage(EventTimeToDateTimecodeStr(DurTime));
        ResetStartTimePlus(FCueSheetList.IndexOf(NextItem), DurTime)
      end
      else
      begin
//        DurTime := GetDurEventTime(GetEventEndTime(PItem^.StartTime, PItem^.DurationTC), NItem^.StartTime);
//        ShowMessage(EventTimeToDateTimecodeStr(DurTime));
        ResetStartTimeMinus(FCueSheetList.IndexOf(NextItem), DurTime);
      end;
    end;
  end;

{  if (ParentItem = GetFirstMainItem) then
  begin
    FTimelineStartDate := ParentItem^.StartTime.D;
//    FTimeLineMin := 0;
//    FTimeLineMax := 0;
  end; }

  if (not ChannelOnAir) then
  begin
    CalcuratePlayListTimeLineRange;
    UpdatePlayListTimeLineRange;
  end;
  DisplayPlayListTimeLine(AIndex);
end;

procedure TfrmChannel.ResetStartTime(AIndex: Integer; ASaveEndTime: TEventTime);
var
  Item: PCueSheetItem;
  ItemEndTime: TEventTime;
  DurTime: TEventTime;

  NextItem: PCueSheetItem;
  NextIndex: Integer;
begin
  if (FCueSheetList = nil) then exit;
  if (AIndex >= FCueSheetList.Count) then exit;

  Item := GetCueSheetItemByIndex(AIndex);
  if (Item <> nil) then
  begin
    if (Item^.EventMode = EM_MAIN) then
    begin
      ItemEndTime := GetEventEndTime(Item^.StartTime, Item^.DurationTC, ChannelFrameRateType);

      DurTime := GetDurEventTime(ASaveEndTime, ItemEndTime, ChannelFrameRateType);

      NextItem := GetNextMainItemByItem(Item);
      if (NextItem <> nil) then
      begin
        NextIndex := GetCueSheetIndexByItem(NextItem);
        if (CompareEventTime(ASaveEndTime, ItemEndTime, ChannelFrameRateType) <= 0) then
        begin
          ResetStartTimePlus(NextIndex, DurTime)
        end
        else
        begin
          ResetStartTimeMinus(NextIndex, DurTime);
        end;
      end;

{      if (Item = GetFirstMainItem) then
      begin
        FTimelineStartDate := Item^.StartTime.D;
//        FTimeLineMin := 0;
//        FTimeLineMax := 0;
      end; }

{      ResetChildItems(AIndex); }
    end;

    if (not ChannelOnAir) then
    begin
      CalcuratePlayListTimeLineRange;
      UpdatePlayListTimeLineRange;
    end;
    DisplayPlayListTimeLine(AIndex);
  end;
end;

procedure TfrmChannel.ResetStartTimeByTime(AIndex: Integer; ASaveStartTime: TEventTime; ASaveDurationTC: TTimecode);
var
  EndTime: TEventTime;
begin
  EndTime := GetEventEndTime(ASaveStartTime, ASaveDurationTC, ChannelFrameRateType);
  ResetStartTime(AIndex, EndTime);
end;

procedure TfrmChannel.ResetStartTimeByTime(AIndex: Integer; ASaveStartTime: TEventTime);
var
  Item: PCueSheetItem;
  EndTime: TEventTime;
begin
  Item := GetCueSheetItemByIndex(AIndex);
  if (Item <> nil) then
  begin
    EndTime := GetEventEndTime(ASaveStartTime, Item^.DurationTC, ChannelFrameRateType);
    ResetStartTime(AIndex, EndTime);
  end;
end;

procedure TfrmChannel.ResetStartTimeByTime(AIndex: Integer; ASaveDurationTC: TTimecode);
var
  Item: PCueSheetItem;
  EndTime: TEventTime;
begin
  Item := GetCueSheetItemByIndex(AIndex);
  if (Item <> nil) then
  begin
    EndTime := GetEventEndTime(Item^.StartTime, ASaveDurationTC, ChannelFrameRateType);
    ResetStartTime(AIndex, EndTime);
  end;
end;

procedure TfrmChannel.ResetStartTimeByDuration(AIndex: Integer; ADuration: TTimecode);
var
  Item: PCueSheetItem;
  NextItem: PCueSheetItem;
  NextIndex: Integer;

  DurTime: TEventTime;

  I: Integer;
begin
  if (FCueSheetList = nil) then exit;
  if (AIndex >= FCueSheetList.Count) then exit;

  Item := GetCueSheetItemByIndex(AIndex);
  if (Item <> nil) then
  begin
    if (Item^.EventMode = EM_MAIN) then
    begin
      DurTime := TimecodeToEventTime(GetDurTimecode(Item^.DurationTC, ADuration, ChannelFrameRateType));

      NextItem := GetNextMainItemByItem(Item);
      if (NextItem <> nil) then
      begin
        NextIndex := GetCueSheetIndexByItem(NextItem);
        if (Item^.DurationTC <= ADuration) then
        begin
          ResetStartTimePlus(NextIndex, DurTime)
        end
        else
        begin
          ResetStartTimeMinus(NextIndex, DurTime);
        end;
      end;

      Item^.DurationTC := ADuration;
//      ResetChildItems(AIndex);
    end
    else
      Item^.DurationTC := ADuration;

    if (not ChannelOnAir) then
    begin
      CalcuratePlayListTimeLineRange;
      UpdatePlayListTimeLineRange;
    end;
    DisplayPlayListTimeLine(AIndex);
  end;
end;

procedure TfrmChannel.ResetStartTimePlus(AIndex: Integer; ADurEventTime: TEventTime);
var
  NextIndex: Integer;
  NextItem: PCueSheetItem;
  NextStartTime: TEventTime;

  I: Integer;
  ParentItem: PCueSheetItem;
  ParentEndTime: TEventTime;
begin
  if (FCueSheetList = nil) then exit;
  if (AIndex >= FCueSheetList.Count) then exit;

  // Get current or next main event index
  for I := AIndex to FCueSheetList.Count - 1 do
  begin
    NextItem := GetCueSheetItemByIndex(I);
    if (NextItem <> nil) and
       (NextItem^.EventMode = EM_MAIN) and (NextItem^.EventStatus.State <> esSkipped) then
    begin
      NextIndex := I;
      break;
    end;
  end;

  ParentItem := nil;
  for I := NextIndex to FCueSheetList.Count - 1 do
  begin
    NextItem := GetCueSheetItemByIndex(I);
    if (NextItem <> nil) then
    begin
      case NextItem^.EventMode of
        EM_MAIN:
        begin
          NextStartTime := GetPlusEventTime(NextItem^.StartTime, ADurEventTime, ChannelFrameRateType);
  //          ShowMessage(EventTimeToDateTimecodeStr(CStartTime));
          if (ParentItem <> nil) then
          begin
            ParentEndTime := GetEventEndTime(ParentItem^.StartTime, ParentItem^.DurationTC, ChannelFrameRateType);
  //            ShowMessage(EventTimeToDateTimecodeStr(PEndTime));
            if (CompareEventTime(NextStartTime, ParentEndTime, ChannelFrameRateType) < 0) then
              NextStartTime := ParentEndTime;
          end;

          NextItem^.StartTime := NextStartTime;
          ParentItem := NextItem;
        end;
        EM_JOIN:
        begin
          NextItem^.StartTime.D := ParentItem^.StartTime.D;
          NextItem^.DurationTC  := ParentItem^.DurationTC;
          NextItem^.InTC        := ParentItem^.InTC;
          NextItem^.OutTC       := ParentItem^.OutTC;
        end;
        EM_SUB:
        begin
          NextItem^.StartTime.D := ParentItem^.StartTime.D;
        end;
      end;
    end;
  end;
end;

procedure TfrmChannel.ResetStartTimeMinus(AIndex: Integer; ADurEventTime: TEventTime);
var
  NextIndex: Integer;
  NextItem: PCueSheetItem;
  NextStartTime: TEventTime;

  I: Integer;
  ParentItem: PCueSheetItem;
  ParentEndTime: TEventTime;
begin
  if (FCueSheetList = nil) then exit;
  if (AIndex >= FCueSheetList.Count) then exit;

  // Get current or next main event index
  for I := AIndex to FCueSheetList.Count - 1 do
  begin
    NextItem := GetCueSheetItemByIndex(I);
    if (NextItem <> nil) and
       (NextItem^.EventMode = EM_MAIN) and (NextItem^.EventStatus.State <> esSkipped) then
    begin
      NextIndex := I;
      break;
    end;
  end;

  ParentItem := nil;
  for I := NextIndex to FCueSheetList.Count - 1 do
  begin
    NextItem := GetCueSheetItemByIndex(I);
    if (NextItem <> nil) then
    begin
      case NextItem^.EventMode of
        EM_MAIN:
        begin
          NextStartTime := GetMinusEventTime(NextItem^.StartTime, ADurEventTime, ChannelFrameRateType);
  //          ShowMessage(EventTimeToDateTimecodeStr(CStartTime));
          if (ParentItem <> nil) then
          begin
            ParentEndTime := GetEventEndTime(ParentItem^.StartTime, ParentItem^.DurationTC, ChannelFrameRateType);
  //            ShowMessage(EventTimeToDateTimecodeStr(PEndTime));
            if (CompareEventTime(NextStartTime, ParentEndTime, ChannelFrameRateType) < 0) then
            begin
              NextStartTime := ParentEndTime;
            end;
          end;

          NextItem^.StartTime := NextStartTime;
          ParentItem := NextItem;
        end;
        EM_JOIN:
        begin
          NextItem^.StartTime.D := ParentItem^.StartTime.D;
          NextItem^.DurationTC  := ParentItem^.DurationTC;
          NextItem^.InTC        := ParentItem^.InTC;
          NextItem^.OutTC       := ParentItem^.OutTC;
        end;
        EM_SUB:
        begin
          NextItem^.StartTime.D := ParentItem^.StartTime.D;
        end;
      end;
    end;
  end;
end;

procedure TfrmChannel.ResetChildItems(AIndex: Integer; ADurationTC: TTimecode);
var
  I: Integer;
  ParentItem: PCueSheetItem;
  ParentIndex: Integer;

  Item: PCueSheetItem;
  DurTC: TTimecode;
begin
  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  ParentItem := GetParentCueSheetItemByIndex(AIndex);
  if (ParentItem <> nil) then
  begin
    ParentIndex := GetCueSheetIndexByItem(ParentItem);

    DurTC := GetDurTimecode(ADurationTC, ParentItem^.DurationTC, ChannelFrameRateType);

    for I := ParentIndex + 1 to FCueSheetList.Count - 1 do
    begin
      Item := GetCueSheetItemByIndex(I);
      if (Item <> nil) and (Item^.GroupNo = ParentItem^.GroupNo) then
      begin
        case Item^.EventMode of
          EM_JOIN:
          begin
            Item^.StartTime.D := ParentItem^.StartTime.D;
            Item^.DurationTC  := ParentItem^.DurationTC;
            Item^.InTC        := ParentItem^.InTC;
            Item^.OutTC       := ParentItem^.OutTC;

{            if (FChannelOnAir) then
              ServerInputCueSheets(I, Item); }
          end;
          EM_SUB:
          begin
            Item^.StartTime.D := ParentItem^.StartTime.D;
            if (ADurationTC > ParentItem^.DurationTC) then
              Item^.DurationTC := GetMinusTimecode(Item^.DurationTC, DurTC, ChannelFrameRateType)
            else
              Item^.DurationTC := GetPlusTimecode(Item^.DurationTC, DurTC, ChannelFrameRateType);


{            if (FChannelOnAir) then
              ServerInputCueSheets(I, Item); }
          end;
        end;
      end
      else
        break;
    end;
  end;

  if (not ChannelOnAir) then
  begin
    CalcuratePlayListTimeLineRange;
    UpdatePlayListTimeLineRange;
  end;
  DisplayPlayListTimeLine(AIndex);
end;

procedure TfrmChannel.ResetStartDateTimeline(AIndex: Integer);
var
  I: Integer;
  CItem, PItem: PCueSheetItem;
  SubStartTime: TEventTime;
  CompIndex: Integer;
  Track: TTrack;
begin
exit;
  if (FCueSheetList = nil) then exit;
  if (AIndex >= FCueSheetList.Count) then exit;

  with wmtlPlaylist do
  begin
    BeginUpdateCompositions;
    try
      for I := AIndex to FCueSheetList.Count - 1 do
      begin
        CItem := GetCueSheetItemByIndex(I);
        if (CItem <> nil) then
        begin
          with CItem^ do
          begin
            if (EventMode <> EM_COMMENT) then
            begin
              // Update playlist timeline
              case CItem^.EventMode of
                EM_MAIN:
                begin
                  CompIndex := 0;
                  if (CompIndex < DataGroupProperty.Count) then
                  begin
                    Track := DataCompositions[CompIndex].Tracks.GetTrackByData(CItem);
                    if (Track <> nil) then
                    begin
                      Track.InPoint  := TimecodeToFrame(StartTime.T, GV_SettingOption.TimelineFrameRateType) + Trunc(DaySpan(FTimelineStartDate, StartTime.D)) * FTimeLineDaysPerFrames;
                      Track.Duration := TimecodeToFrame(DurationTC, GV_SettingOption.TimelineFrameRateType);
                      Track.OutPoint := Track.InPoint + Track.Duration;
                    end;
                    Inc(CompIndex);
                  end;
                end;
                EM_JOIN:
                begin
                  if (CompIndex < DataGroupProperty.Count) then
                  begin
                    PItem := GetParentCueSheetItemByItem(CItem);
                    if (PItem <> nil) then
                    begin
                      SubStartTime := GetEventTimeSubBegin(PItem^.StartTime, CItem^.StartTime.T, ChannelFrameRateType);

                      Track := DataCompositions[CompIndex].Tracks.GetTrackByData(CItem);
                      if (Track <> nil) then
                      begin
                        Track.Duration := TimecodeToFrame(DurationTC, GV_SettingOption.TimelineFrameRateType);
                        Track.InPoint  := TimecodeToFrame(SubStartTime.T, GV_SettingOption.TimelineFrameRateType) + Trunc(DaySpan(FTimelineStartDate, SubStartTime.D)) * FTimeLineDaysPerFrames;
                        Track.OutPoint := Track.InPoint + Track.Duration;
                      end;
                      Inc(CompIndex);
                    end;
                  end;
                end;
                EM_SUB:
                begin
                  if (CompIndex < DataGroupProperty.Count) then
                  begin
                    PItem := GetParentCueSheetItemByItem(CItem);
                    if (PItem <> nil) then
                    begin
                      if (CItem^.StartMode = SM_SUBBEGIN) then
                        SubStartTime := GetEventTimeSubBegin(PItem^.StartTime, CItem^.StartTime.T, GV_SettingOption.TimelineFrameRateType)
                      else
                        SubStartTime := GetEventTimeSubEnd(PItem^.StartTime, PItem^.DurationTC, CItem^.StartTime.T, GV_SettingOption.TimelineFrameRateType);

                      Track := DataCompositions[CompIndex].Tracks.GetTrackByData(CItem);
                      if (Track <> nil) then
                      begin
                        Track.Duration := TimecodeToFrame(DurationTC, GV_SettingOption.TimelineFrameRateType);
                        Track.InPoint  := TimecodeToFrame(SubStartTime.T, GV_SettingOption.TimelineFrameRateType) + Trunc(DaySpan(FTimelineStartDate, SubStartTime.D)) * FTimeLineDaysPerFrames;
                        Track.OutPoint := Track.InPoint + Track.Duration;
                      end;
                      Inc(CompIndex);
                    end;
                  end;
                end
                else Continue;
              end;
              if (Track <> nil) then
              begin
                if (FTimeLineMin = 0) or (Track.InPoint < FTimeLineMin) then FTimeLineMin := Track.InPoint;
                if (Track.OutPoint > FTimeLineMax) then FTimeLineMax := Track.OutPoint;
              end;
            end;
          end;
        end;
      end;

//      TimeZoneProperty.FrameStart := FTimeLineMin - TIMELINE_SIDE_FRAMES;
//      TimeZoneProperty.FrameCount := FTimeLineMax - FTimeLineMin + (TIMELINE_SIDE_FRAMES * 2);
    finally
      EndUpdateCompositions;
    end;
  end;
end;

procedure TfrmChannel.ChannelCueSheetListQuickSort(L, R: Integer; AChannelCueSheetList: TChannelCueSheetList);
var
  I, J, P: Integer;
  Save: PChannelCueSheet;
  SortList: TChannelCueSheetList;

  function Compare(Item1, Item2: PChannelCueSheet): Integer;
  begin
    Result := CompareDate(OnAirDateToDate(Item1^.OnairDate), OnAirDateToDate(Item2^.OnairDate));
  end;

begin
  SortList := AChannelCueSheetList;
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while Compare(AChannelCueSheetList[I], AChannelCueSheetList[P]) < 0 do
        Inc(I);
      while Compare(AChannelCueSheetList[J], AChannelCueSheetList[P]) > 0 do
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
      ChannelCueSheetListQuickSort(L, J, AChannelCueSheetList);
    L := I;
  until I >= R;
end;

procedure TfrmChannel.CueSheetListQuickSort(L, R: Integer; ACueSheetList: TCueSheetList);
var
  I, J, P: Integer;
  Save: PCueSheetItem;
  SortList: TCueSheetList;

  function Compare(Item1, Item2: PCueSheetItem): Integer;
  begin
    Result := CompareEventTime(Item1^.StartTime, Item2^.StartTime, ChannelFrameRateType);
  end;

begin
  SortList := ACueSheetList;
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      FCueSheetLock.Enter;
      try
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
      finally
        FCueSheetLock.Leave;
      end;
    until I > J;
    if L < J then
      CueSheetListQuickSort(L, J, ACueSheetList);
    L := I;
  until I >= R;
end;

procedure TfrmChannel.SetCueSheetItemStatusByIndex(AStartIndex, AEndIndex: Integer; AState: TEventState; AErrorCode: Integer);
var
  I: Integer;
  RRow: Integer;
  ProgItem: PCueSheetItem;
  PSItem, PEItem, Item: PCueSheetItem;
begin
  if (FCueSheetList = nil) then exit;
  if (AStartIndex < 0) or (AStartIndex > FCueSheetList.Count - 1) then exit;
  if (AEndIndex < 0) or (AEndIndex > FCueSheetList.Count - 1) then exit;

{  PSItem := GetParentCueSheetItemByIndex(AStartIndex);
  AStartIndex := GetCueSheetIndexByItem(PSItem);
  if (AStartIndex < 0) then exit;

  PEItem := GetParentCueSheetItemByIndex(AEndIndex);
  AEndIndex := GetLastChildCueSheetItemByIndex(PEItem);
  if (AEndIndex < 0) then exit;





  GetLastMainItem
  EItem := GetLastChildCueSheetItemByIndex(AEndIndex);
  AEndIndex := GetCueSheetIndexByItem(EItem);
  if (AStartIndex < 0) then exit;  }


{  ProgItem := GetProgramItemByIndex(AStartIndex);
  if (ProgItem <> nil) then
  begin
    Item := GetProgramMainItemByItem(ProgItem);
    if (Item = GetCueSheetItemByIndex(AStartIndex)) then
      AStartIndex := GetCueSheetIndexByItem(ProgItem);
  end; }

  wmtlPlaylist.BeginUpdateCompositions;

  try
    for I := AStartIndex to AEndIndex do
    begin
      Item := GetCueSheetItemByIndex(I);
      if (Item <> nil) and (Item^.EventMode <> EM_COMMENT) and (Item^.EventStatus.State < esOnAir) {and (CItem^.EventStatus.State <= esPreroll)} then
      begin
        Item^.EventStatus.State := AState;
        Item^.EventStatus.ErrorCode := AErrorCode;

  //      PostMessage(Handle, WM_UPDATE_EVENTSTATUS, I, NativeInt(@CItem^.EventStatus));
        SetEventStatus(Item^.EventID, Item^.EventStatus);




        if (AState = esSkipped) then
          DeletePlayListTimeLineByItem(Item);




  {      with acgPlayList do
        begin
          RRow := I + CNT_CUESHEET_HEADER;
          AllCells[IDX_COL_CUESHEET_EVENT_STATUS, RRow] := EventStatusNames[AStatus];
        end;}
      end;
    end;

  //  acgPlaylist.Repaint;
  finally
    wmtlPlaylist.EndUpdateCompositions;
  end;
end;

procedure TfrmChannel.SetChannelOnAir(AOnAir: Boolean);
var
  I, J: Integer;
begin
  SetChannelOnAirByID(FChannelID, AOnAir);
  FChannelOnAir := AOnAir;

  imgOnair.Visible  := FChannelOnAir;
  imgOffair.Visible := (not FChannelOnAir);

  if (not FChannelOnAir) then
  begin
    CueSheetCurr   := nil;
    CueSheetNext   := nil;
    CueSheetTarget := nil;
  end;

  with wmtlPlaylist do
  begin
    TimeZoneProperty.RailBarVisible := FChannelOnAir;
  end;

  ServerSetOnAirs(ChannelID, FChannelOnAir);
end;

procedure TfrmChannel.AutoLoadPlayList;
var
  SR: TSearchRec;
  FileAttrs: Integer;

  LoadFileName, WorkFileName: String;

  LoadChannelCueSheetList: TChannelCueSheetList;  // �ε��� ä�� ť��Ʈ �׸�
  LoadChannelCueSheet: PChannelCueSheet;          // �ε��� ä�� ť��Ʈ
  LoadCueSheetList: TCueSheetList;                // �ε��� ä�� ť��Ʈ �׸�

  SaveLastDisplayNo: Integer;

  StartIndex: Integer;
  StartItem: PCueSheetItem;

  NowChannelCueSheet: PChannelCueSheet;           // ���� �ε��� ��¼�� ť��Ʈ
  NowStartIndex: Integer;                         // ���� �ε��� ��¼�� ť��Ʈ ���� �ε���

  I, J: Integer;
  Item, ChildItem: PCueSheetItem;

  BaseDateTime: TDateTime;
  BaseStartTime: TEventTime;
  StartTime: TEventTime;
  ProgramNo: Integer;
  GroupNo: Integer;

  ChildCount: Integer;

  SaveEventCount: Integer;

  SaveSelectRow: Integer;

  ParentRow: Integer;
  ParentSpan: Integer;

  RemoveItemList: TCueSheetList;
  RemoveRowList: TList<Integer>;
  RemoveMainRowList: TList<Integer>;
begin
  if (not HasMainControl) then exit;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Start AutoLoadPlayList procedure.'));

  try
    // XML Process
    FileAttrs := faAnyFile;
    if (FindFirst(GV_SettingGeneral.LoadCueSheetPath + '*.xml', FileAttrs, SR) = S_OK) then
    begin
      repeat
  //      if (SR.Attr and FileAttrs) = SR.Attr then
        begin
          LoadFileName := GV_SettingGeneral.LoadCueSheetPath + SR.Name;
          WorkFileName := GV_SettingGeneral.WorkCueSheetPath + SR.Name;

          BaseDateTime := Now;

          LoadChannelCueSheet := New(PChannelCueSheet);
          try
            FillChar(LoadChannelCueSheet^, SizeOf(TChannelCueSheet), #0);
            with LoadChannelCueSheet^ do
            begin
              StrPLCopy(FileName, LoadFileName, MAX_PATH);
              ChannelID := FChannelID;
            end;

            LoadCueSheetList := TCueSheetList.Create;
            try
              SaveLastDisplayNo := FLastDisplayNo;
              OpenPlayListXML(LoadChannelCueSheet, LoadCueSheetList);

              // Compare Channel ID
              if (LoadChannelCueSheet^.ChannelID <> FChannelID) then
              begin
                FLastDisplayNo := SaveLastDisplayNo;
                Continue;
              end;

              // Move cuesheet file less than base date
              if (CompareDate(OnAirDateToDate(LoadChannelCueSheet^.OnairDate), BaseDateTime) < 0) then
              begin
                if (MoveFileEx(PChar(LoadFileName), PChar(WorkFileName), MOVEFILE_REPLACE_EXISTING)) then
                begin
                  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('AutoLoadPlayList, Move lless than base date load cuesheet file succeeded, File = %s',
                                                                             [String(LoadChannelCueSheet^.FileName)])));
                end
                else
                begin
                  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('AutoLoadPlayList, Move less than base date load cuesheet file failed, File = %s',
                                                                             [String(LoadChannelCueSheet^.FileName)])));
                end;

                Continue;
              end;

              // Move cuesheet file aleady loaded
              NowChannelCueSheet := GetChannelCueSheetByOnairDate(OnAirDateToDate(LoadChannelCueSheet^.OnairDate));
              if (NowChannelCueSheet <> nil) then
              begin
                if (NowChannelCueSheet^.OnairNo >= LoadChannelCueSheet^.OnairNo) then
                begin
                  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('AutoLoadPlayList, Find aleady loaded cuesheet, File = %s',
                                                                             [String(LoadChannelCueSheet^.FileName)])));

                  if (MoveFileEx(PChar(LoadFileName), PChar(WorkFileName), MOVEFILE_REPLACE_EXISTING)) then
                  begin
                    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('AutoLoadPlayList, Move aleady loaded cuesheet file succeeded, File = %s',
                                                                               [String(LoadChannelCueSheet^.FileName)])));
                  end
                  else
                  begin
                    Assert(False, GetChannelLogStr(lsError, ChannelID, Format('AutoLoadPlayList, Move aleady loaded cuesheet file failed, File = %s',
                                                                              [String(LoadChannelCueSheet^.FileName)])));
                  end;

                  Continue;
                end;
              end;

              // Compare Onair Date
              if (CompareDate(OnAirDateToDate(LoadChannelCueSheet^.OnairDate), BaseDateTime) <> 0) and
                 (CompareDate(OnAirDateToDate(LoadChannelCueSheet^.OnairDate), IncDay(BaseDateTime)) <> 0) then
              begin
                FLastDisplayNo := SaveLastDisplayNo;
                Continue;
              end;

              Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Find load playlist. ' +
                                                                         'File name = %s, ' +
                                                                         'Onair date = %s, ' +
                                                                         'Onair flag = %s, ' +
                                                                         'Onair no = %d, ' +
                                                                         'Event count = %d',
                                                                         [String(LoadChannelCueSheet^.FileName),
                                                                          String(LoadChannelCueSheet^.OnairDate),
                                                                          Char(LoadChannelCueSheet^.OnairFlag),
                                                                          LoadChannelCueSheet^.OnairNo,
                                                                          LoadChannelCueSheet^.EventCount
                                                                          ])));

//              if (MoveFile(PChar(LoadFileName), PChar(WorkFileName))) then
              if (MoveFileEx(PChar(LoadFileName), PChar(WorkFileName), MOVEFILE_REPLACE_EXISTING)) then
              begin
                // ���� ���� �ð� ���� - ���� ���� ������ Ÿ�� �ɼ� �����ؾ� ��
{                if (CueSheetNext <> nil) then
                begin
                  BaseStartTime := GetEventEndTime(CueSheetNext^.StartTime, CueSheetNext^.DurationTC);
                  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Exist next event item. Base start time = %s',
                                                                             [EventTimeToString(BaseStartTime)])));
                end
                else if (CueSheetCurr <> nil) then
                begin
                  BaseStartTime := GetEventEndTime(CueSheetCurr^.StartTime, CueSheetCurr^.DurationTC);
                  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Exist current event item. Base start time = %s',
                                                                             [EventTimeToString(BaseStartTime)])));
                end
                else
                begin
                  BaseStartTime := DateTimeToEventTime(BaseDateTime);
                  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Now time is base time. Base start time = %s',
                                                                             [EventTimeToString(BaseStartTime)])));
                end; }

{                BaseStartTime := DateTimeToEventTime(BaseDateTime);
                BaseStartTime := GetPlusEventTime(BaseStartTime, TimecodeToEventTime(GV_SettingThresholdTime.EditLockTime));
                Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Now time is base time. Base start time = %s',
                                                                             [EventTimeToString(BaseStartTime)]))); }

                // �̺�Ʈ ����� ���� ���ؽð� ����
                // ���ؽð����� EditLock Time�� ���� �ð����� ���۽ð��� ū �̺�Ʈ�� ���� �ε���
                if (CueSheetCurr <> nil) then
                begin
//                  BaseStartTime := CueSheetCurr^.StartTime;
                  BaseStartTime := GetEventEndTime(CueSheetCurr^.StartTime, CueSheetCurr^.DurationTC, ChannelFrameRateType);
                  BaseStartTime := GetPlusEventTime(BaseStartTime, TimecodeToEventTime(GV_SettingThresholdTime.EditLockTime), ChannelFrameRateType);
                  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Exist current event item. Base start time = %s',
                                                                             [EventTimeToString(BaseStartTime, ChannelFrameRateType)])));
                end
                else
                begin
                  BaseStartTime := DateTimeToEventTime(BaseDateTime, ChannelFrameRateType);
                  BaseStartTime := GetPlusEventTime(BaseStartTime, TimecodeToEventTime(GV_SettingThresholdTime.EditLockTime), ChannelFrameRateType);
                  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Now time is base time. Base start time = %s',
                                                                             [EventTimeToString(BaseStartTime, ChannelFrameRateType)])));
                end;


                // �ε��� ť��Ʈ�� ���� �ð� ������ �׸� ����
                RemoveItemList := TCueSheetList.Create;
                Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Test 1'));
                try
                  for I := 0 to LoadCueSheetList.Count - 1 do
                  begin
                    Item := LoadCueSheetList[I];
                    Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Test 2'));
                    if (Item <> nil) then
                    begin
                      if (Item^.EventMode = EM_PROGRAM) then
                      begin
                        ProgramNo := Item^.ProgramNo;

                        // ���α׷� �̺�Ʈ �� ��� ���� �̺�Ʈ�� ����ð� ���� �� ��� ����
                        for J := I + 1 to LoadCueSheetList.Count - 1 do
                        begin
                          ChildItem := LoadCueSheetList[J];
                          if (ChildItem <> nil) and (ChildItem^.ProgramNo = ProgramNo) and
                             (ChildItem^.EventMode = EM_MAIN) then
                          begin
//                            StartTime := GetEventEndTime(ChildItem^.StartTime, ChildItem^.DurationTC);
                            StartTime := ChildItem^.StartTime;

                            if (CompareEventTime(StartTime, BaseStartTime, ChannelFrameRateType) <= 0) then
                              RemoveItemList.Add(Item)
                            else
                              break;
                          end
                          else
                            break;
                        end;
                      end
                      else if (Item^.EventMode = EM_MAIN) then
                      begin
                        Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Test 3'));
                        StartTime := Item^.StartTime;
//                        StartTime := GetEventEndTime(Item^.StartTime, Item^.DurationTC);
                        Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Check load main item end time. End time = %s',
                                                                                   [EventTimeToString(StartTime, ChannelFrameRateType)])));

                        if (CompareEventTime(StartTime, BaseStartTime, ChannelFrameRateType) < 0) then
                        begin
                          // ���� ���� �̺�Ʈ ����
                          RemoveItemList.Add(Item);
                          Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Add remove load main item. Index = %d, ' +
                                                                                     'Serial no = %d, ' +
                                                                                     'Group no = %d',
                                                                                     [I,
                                                                                      Item^.EventID.SerialNo,
                                                                                      Item^.GroupNo])));

                          GroupNo := Item^.GroupNo;

                          // ���� �ð� ���� ���� ��� �ڽ� �̺�Ʈ ����
                          for J := I + 1 to LoadCueSheetList.Count - 1 do
                          begin
                            ChildItem := LoadCueSheetList[J];
                            if (ChildItem <> nil) and (ChildItem^.GroupNo = GroupNo) then
                            begin
                              RemoveItemList.Add(ChildItem);
                              Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Add remove load child item. Index = %d, ' +
                                                                                         'Serial no = %d, ' +
                                                                                         'Group no = %d',
                                                                                         [J,
                                                                                          ChildItem^.EventID.SerialNo,
                                                                                          ChildItem^.GroupNo])));
                            end
                            else
                              break;
                          end;
                        end;
                      end;
                    end;
                  end;

                  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Get delete load item count = %d',
                                                                             [RemoveItemList.Count])));
                  // Delete event items
                  for I := RemoveItemList.Count - 1 downto 0 do
                  begin
                    Item := RemoveItemList[I];

                    LoadCueSheetList.Remove(Item);
                    Dispose(Item);
                  end;

                  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Success delete load items.'));

                  LoadChannelCueSheet^.EventCount := LoadCueSheetList.Count;

                  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Load channel cuesheet event count = %d', [LoadChannelCueSheet^.EventCount])));

                  if (LoadCueSheetList.Count <= 0) then
                  begin
                    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Not add cuesheet event items, playlist = %s', [LoadChannelCueSheet^.FileName])));
                    exit;
                  end;
                finally
                  RemoveItemList.Clear;
                  FreeAndNil(RemoveItemList);
                end;



                wmtlPlaylist.BeginUpdateCompositions;

                acgPlaylist.BeginUpdate;

                if (ChannelOnAir) then
                  ServerBeginUpdates(ChannelID);

                SaveSelectRow := acgPlaylist.Row;
                acgPlaylist.MouseActions.DisjunctRowSelect := False;

                try
                  // �ε��� ��¥�� ���� ť��Ʈ ã��
                  NowChannelCueSheet := GetChannelCueSheetByOnairDate(OnAirDateToDate(LoadChannelCueSheet^.OnairDate));
                  if (NowChannelCueSheet <> nil) then
                  begin

                    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Find now cuesheet onair date playlist. ' +
                                                                               'File name = %s, ' +
                                                                               'Onair date = %s, ' +
                                                                               'Onair flag = %s, ' +
                                                                               'Onair no = %d, ' +
                                                                               'Event count = %d',
                                                                               [String(NowChannelCueSheet^.FileName),
                                                                                String(NowChannelCueSheet^.OnairDate),
                                                                                Char(NowChannelCueSheet^.OnairFlag),
                                                                                NowChannelCueSheet^.OnairNo,
                                                                                NowChannelCueSheet^.EventCount
                                                                                ])));


                    RemoveItemList := TCueSheetList.Create;
                    RemoveRowList := TList<Integer>.Create;
                    RemoveMainRowList := TList<Integer>.Create;
                    try
                      // ���� ť��Ʈ�� ���� �̺�Ʈ �ε��� ����
                      NowStartIndex := GetChannelCueSheetStartIndex(NowChannelCueSheet);

                      // ���� ť��Ʈ�� ���� �ð� ������ �׸� ����
                      for I := NowStartIndex to NowStartIndex + NowChannelCueSheet^.EventCount - 1 do
                      begin
                        Item := GetCueSheetItemByIndex(I);
                        if (Item <> nil) then
                        begin
                          if (Item^.EventMode = EM_PROGRAM) then
                          begin
                            // ���α׷� �̺�Ʈ �� ��� ���� �̺�Ʈ�� ����ð� ���� �� ��� ����
                            ChildItem := GetProgramMainItemByItem(Item);
                            if (ChildItem <> nil) and
                               (ChildItem^.EventMode = EM_MAIN) then
                            begin
                              // ���α׷� �̺�Ʈ Node Expand
//                              acgPlaylist.ExpandNode(I + CNT_CUESHEET_HEADER);

//                              StartTime := GetEventEndTime(ChildItem^.StartTime, ChildItem^.DurationTC);
                              StartTime := ChildItem^.StartTime;
                              if (CompareEventTime(StartTime, BaseStartTime, ChannelFrameRateType) >= 0) then
                              begin
                                RemoveItemList.Add(Item);
                                RemoveRowList.Add(I);//acgPlaylist.DisplRowIndex(I + CNT_CUESHEET_HEADER));
                              end;
                            end;
                          end
                          else if (Item^.EventMode = EM_MAIN) {and (Item <> CueSheetNext) and (Item <> CueSheetCurr)} then
                          begin
//                            StartTime := GetEventEndTime(Item^.StartTime, Item^.DurationTC);
                            StartTime := Item^.StartTime;

                            if {(Item^.EventStatus.State = esSkipped) or }(CompareEventTime(StartTime, BaseStartTime, ChannelFrameRateType) >= 0) then
                            begin
                              // ���� �̺�Ʈ Node Expand
//                              acgPlaylist.ExpandNode(I + CNT_CUESHEET_HEADER);

                              // ���� �̺�Ʈ ����
                              RemoveItemList.Add(Item);
                              RemoveRowList.Add(I);//acgPlaylist.DisplRowIndex(I + CNT_CUESHEET_HEADER));
                              RemoveMainRowList.Add(I);

{                              // ���� Main �̺�Ʈ ����
                              if (FChannelOnAir) then
                                OnAirDeleteEvents(I, I); }

                              GroupNo := Item^.GroupNo;

                              // ���� �ð� ���� ū ��� �ڽ� �̺�Ʈ ����
                              for J := I + 1 to FCueSheetList.Count - 1 do
                              begin
                                ChildItem := GetCueSheetItemByIndex(J);
                                if (ChildItem <> nil) and (ChildItem^.GroupNo = GroupNo) then
                                begin
                                  RemoveItemList.Add(ChildItem);
                                  RemoveRowList.Add(J);//acgPlaylist.DisplRowIndex(J + CNT_CUESHEET_HEADER));
                                end
                                else
                                  break;
                              end;
                            end;
                          end;
                        end;
                      end;

                      Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Get delete item & row count. ' +
                                                                                 'Item count = %d, ' +
                                                                                 'Row count = %d',
                                                                                 [RemoveItemList.Count,
                                                                                  RemoveRowList.Count
                                                                                  ])));

                      // Delete rows
                      for I := RemoveRowList.Count - 1 downto 0 do
                      begin
//                        acgPlaylist.RemoveNode(acgPlaylist.RealRowIndex(RemoveRowList[I]));
//                        acgPlaylist.RemoveNormalRow(RemoveRowList[I]);
//                        acgPlaylist.RemoveChildRow(acgPlaylist.RealRowIndex(RemoveRowList[J]));
            deletePlayListGridMain(RemoveRowList[I]);
                     end;

                      Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Success delete rows & nodes.'));

                      // Delete dcs event
                      if (ChannelOnAir) then
                      begin
//                        Dec(FLastInputIndex, RemoveItemList.Count);

                        for I := RemoveMainRowList.Count - 1 downto 0 do
                        begin
                          OnAirDeleteEvents(RemoveMainRowList[I], RemoveMainRowList[I]);
                        end;

                        ServerDeleteCueSheets(ChannelID, RemoveItemList);
                      end;

                      // Delete event items
                      for I := RemoveItemList.Count - 1 downto 0 do
                      begin
                        Item := RemoveItemList[I];

                        DeletePlayListTimeLineByItem(Item);

                        FCueSheetLock.Enter;
                        try
                          FCueSheetList.Remove(Item);
                          Dispose(Item);
                        finally
                          FCueSheetLock.Leave;
                        end;

                        Dec(NowChannelCueSheet^.EventCount);
                      end;

                      Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Success delete event items.'));

                      SaveEventCount := NowChannelCueSheet^.EventCount;

                      Move(LoadChannelCueSheet^, NowChannelCueSheet^, SizeOf(TChannelCueSheet));
                      StrPLCopy(NowChannelCueSheet^.FileName, WorkFileName, MAX_PATH);
                      NowChannelCueSheet^.EventCount := NowChannelCueSheet^.EventCount + SaveEventCount;

                      Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Now channel cuesheet event count = %d', [NowChannelCueSheet^.EventCount])));

                      StartIndex := NowStartIndex + SaveEventCount;
  //                    ShowMessage(IntToStr(StartIndex));
                    finally
                      RemoveMainRowList.Clear;
                      RemoveRowList.Clear;
                      RemoveItemList.Clear;

                      FreeAndNil(RemoveMainRowList);
                      FreeAndNil(RemoveRowList);
                      FreeAndNil(RemoveItemList);
                    end;
                  end
                  else
                  begin
                    // �ε��� ��¥�� ť��Ʈ�� ���� ���
                    // �ε��� ��¥ ������ ť��Ʈ ã��
                    // ť��Ʈ �� �̺�Ʈ ��ġ ����
                    NowChannelCueSheet := GetNextChannelCueSheetByOnairDate(OnAirDateToDate(LoadChannelCueSheet^.OnairDate));
                    if (NowChannelCueSheet <> nil) then
                    begin
                      Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Find now cuesheet next onair date playlist. ' +
                                                                                 'File name = %s, ' +
                                                                                 'Onair date = %s, ' +
                                                                                 'Onair flag = %s, ' +
                                                                                 'Onair no = %d, ' +
                                                                                 'Event count = %d',
                                                                                 [String(NowChannelCueSheet^.FileName),
                                                                                  String(NowChannelCueSheet^.OnairDate),
                                                                                  Char(NowChannelCueSheet^.OnairFlag),
                                                                                  NowChannelCueSheet^.OnairNo,
                                                                                  NowChannelCueSheet^.EventCount
                                                                                  ])));

                      // ť��Ʈ ��ġ
                      NowStartIndex := FChannelCueSheetList.IndexOf(NowChannelCueSheet);
                      StartIndex    := GetChannelCueSheetStartIndex(NowChannelCueSheet);;
                    end
                    else
                    begin
                      Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Not found now cuesheet next onair date playlist.'));

                      NowStartIndex := FChannelCueSheetList.Count;
                      StartIndex    := FCueSheetList.Count;
                    end;

                    NowChannelCueSheet := New(PChannelCueSheet);
                    Move(LoadChannelCueSheet^, NowChannelCueSheet^, SizeOf(TChannelCueSheet));
                    StrPLCopy(NowChannelCueSheet^.FileName, WorkFileName, MAX_PATH);

                    if (NowStartIndex = FChannelCueSheetList.Count) then
                    begin
                      FChannelCueSheetList.Add(NowChannelCueSheet);
                      Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Add channel cuesheet list. Index = %d, Count = %d, File name = %s', [NowStartIndex, FChannelCueSheetList.Count, WorkFileName])));
                    end
                    else
                    begin
                      FChannelCueSheetList.Insert(NowStartIndex, NowChannelCueSheet);
                      Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Insert channel cuesheet list. Index = %d, Count = %d, File name = %s', [NowStartIndex, FChannelCueSheetList.Count, WorkFileName])));
                    end;

                    if (ChannelOnAir) then
                    begin
                      ServerInputChannelCueSheets(NowChannelCueSheet);
                    end;

                    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Add load channel cuesheet list. ' +
                                                                               'File name = %s, ' +
                                                                               'Onair date = %s, ' +
                                                                               'Onair flag = %s, ' +
                                                                               'Onair no = %d, ' +
                                                                               'Event count = %d',
                                                                               [String(NowChannelCueSheet^.FileName),
                                                                                String(NowChannelCueSheet^.OnairDate),
                                                                                Char(NowChannelCueSheet^.OnairFlag),
                                                                                NowChannelCueSheet^.OnairNo,
                                                                                NowChannelCueSheet^.EventCount
                                                                                ])));

  //                  ChannelCueSheetListSort(FChannelCueSheetList);
                  end;

  {                // ���� �ð� �̺�Ʈ �ε��� ����
                  StartItem := GetMainItemByStartTime(NowStartIndex, EventTimeToDateTime(BaseStartTime));
                  if (StartItem <> nil) then
                  begin
                    StartIndex := GetCueSheetIndexByItem(StartItem);
                  end
                  else
                  begin
                    StartIndex := FCueSheetList.Count;
                  end; }

                  // �ε��� ť��Ʈ ����
                  for I := 0 to LoadCueSheetList.Count - 1 do
                  begin
                    FCueSheetLock.Enter;
                    try
                      Item := New(PCueSheetItem);
                      Move(LoadCueSheetList[I]^, Item^, SizeOf(TCueSheetItem));
                      if (StartIndex >= FCueSheetList.Count - I) then
                      begin
                        FCueSheetList.Add(Item);
                      end
                      else
                      begin
                        FCueSheetList.Insert(StartIndex + I, Item);
                      end;
                    finally
                      FCueSheetLock.Leave;
                    end;
                  end;

                  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Add event items. Count = %d', [LoadCueSheetList.Count])));

                FLastDisplayNo := GetBeforeMainCountByIndex(StartIndex) - 1;

                ResetNo(StartIndex, FLastDisplayNo);

                  // DoCueSheetCheck���� �ڵ����� �̺�Ʈ�� Input ó����
                  // DoCueSheetCheck���� ó���� �� �ȵǴµ�
                  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('OnAirInputEvents check. Start = %d, LastInput = %d, Count = %d', [StartIndex, FLastInputIndex, GV_SettingOption.MaxInputEventCount])));
                  if (FChannelOnAir) and (StartIndex < FLastInputIndex)  then
                  begin
                    OnAirInputEvents(StartIndex, GV_SettingOption.MaxInputEventCount);
                  end;

                  FInspectThread.Inspect;

                  if (ChannelOnAir) then
                  begin
                    FMediaCheckThread.MediaCheck;
                    ServerInputCueSheets(ChannelID, StartIndex);
                  end;
                finally
                  acgPlaylist.MouseActions.DisjunctRowSelect := True;
                  if (SaveSelectRow >= 0) and (SaveSelectRow < acgPlaylist.RowCount) then
                    acgPlaylist.Row := SaveSelectRow;

                  acgPlaylist.EndUpdate;

                  wmtlPlaylist.EndUpdateCompositions;

                  if (ChannelOnAir) then
                    ServerEndUpdates(ChannelID);
                end;
//                  if (CueSheetCurr <> nil) then
//                    StartIndex := GetCueSheetIndexByItem(CueSheetCurr)
//                  else if (CueSheetNext <> nil) then
//                    StartIndex := GetCueSheetIndexByItem(CueSheetNext);

                DisplayPlayListGrid(StartIndex, LoadCueSheetList.Count);

                if (not ChannelOnAir) then
                begin
                  CalcuratePlayListTimeLineRange;
                  UpdatePlayListTimeLineRange;
                end;
                DisplayPlayListTimeLine(StartIndex);

                FLastCount := FCueSheetList.Count;

                if (ChannelOnAir) then
                  ServerFinishLoadCuesheets(ChannelID, SR.Name);
              end;
            finally
              for I := LoadCueSheetList.Count - 1 downto 0 do
                Dispose(LoadCueSheetList[I]);

              LoadCueSheetList.Clear;
              FreeAndNil(LoadCueSheetList);
            end;
          finally
            Dispose(LoadChannelCueSheet);
          end;
        end;
      until (FindNext(SR) <> 0);
      FindClose(SR);
    end;
  except
    Assert(False, GetChannelLogStr(lsError, ChannelID, 'AutoLoadPlayList procedure exception error.'));
    exit;
  end;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Finish AutoLoadPlayList procedure.'));
end;

procedure TfrmChannel.AutoEjectPlayList;
var
  I, J: Integer;
  ChannelCueSheet: PChannelCueSheet;

  StartIndex: Integer;
  RemoveRowList: TList<Integer>;
  RemoveItemList: TCueSheetList;
  Item: PCueSheetItem;

  BaseDateTime: TDateTime;
  BaseStartTime: TEventTime;

  LastMainItem: PCueSheetItem;
  LastMainEndTime: TEventTime;

  ParentRow: Integer;
  ParentSpan: Integer;

  SaveSelectRow: Integer;
begin
  if (not HasMainControl) then exit;

  if (FChannelCueSheetList.Count <= 0) then exit;
  if (FCueSheetList.Count <= 0) then exit;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Start AutoEjectPlayList procedure.'));

  // ä�� ť��Ʈ �� ���� �ð��� ���� ť��Ʈ ����

    BaseDateTime := Now;
    BaseStartTime := DateTimeToEventTime(BaseDateTime, ChannelFrameRateType);

    for I := FChannelCueSheetList.Count - 1 downto 0 do
    begin
      ChannelCueSheet := FChannelCueSheetList[I];
      if (ChannelCueSheet <> nil) then
      begin
        // ť��Ʈ�� ���� �̺�Ʈ �ε��� ����
        StartIndex := GetChannelCueSheetStartIndex(ChannelCueSheet);

        Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Check eject playlist. ' +
                                                                   'Index = %d, ' +
                                                                   'File name = %s, ' +
                                                                   'Start index = %d, ' +
                                                                   'Event count = %d',
                                                                   [I,
                                                                    String(ChannelCueSheet^.FileName),
                                                                    StartIndex,
                                                                    ChannelCueSheet^.EventCount
                                                                    ])));

        // ť��Ʈ�� ������ ���� �̺�Ʈ ����
        LastMainItem := nil;
        for J := StartIndex + ChannelCueSheet^.EventCount - 1 downto StartIndex do
        begin
          Item := GetCueSheetItemByIndex(J);
          if (Item <> nil) and (Item^.EventMode = EM_MAIN) then
          begin
            LastMainItem := Item;
            break;
          end;
        end;

        // ť��Ʈ�� ������ ���� �̺�Ʈ�� ���� �ð��� ���� �ð��� ��
        if (LastMainItem <> nil) then
        begin
          LastMainEndTime := GetEventEndTime(LastMainItem^.StartTime, LastMainItem^.DurationTC, ChannelFrameRateType);

          Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Check last main item. ' +
                                                                     'End time = %s, ' +
                                                                     'Base start time = %s',
                                                                     [EventTimeToString(LastMainEndTime, ChannelFrameRateType),
                                                                      EventTimeToString(BaseStartTime, ChannelFrameRateType)
                                                                      ])));

          if (CompareEventTime(LastMainEndTime, BaseStartTime, ChannelFrameRateType) >= 0) then continue;
        end
        else
          continue;

        Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Find eject playlist. ' +
                                                                   'File name = %s, ' +
                                                                   'Onair date = %s, ' +
                                                                   'Onair flag = %s, ' +
                                                                   'Onair no = %d, ' +
                                                                   'Event count = %d',
                                                                   [String(ChannelCueSheet^.FileName),
                                                                    String(ChannelCueSheet^.OnairDate),
                                                                    Char(ChannelCueSheet^.OnairFlag),
                                                                    ChannelCueSheet^.OnairNo,
                                                                    ChannelCueSheet^.EventCount
                                                                    ])));

  wmtlPlaylist.BeginUpdateCompositions;

  acgPlaylist.BeginUpdate;
  SaveSelectRow := acgPlaylist.Row;
  acgPlaylist.Row := 0;
  acgPlaylist.MouseActions.DisjunctRowSelect := False;
  try
        // ť��Ʈ�� �̺�Ʈ ����
        RemoveRowList := TList<Integer>.Create;
        RemoveItemList := TCueSheetList.Create;
        try
          for J := StartIndex to StartIndex + ChannelCueSheet^.EventCount - 1 do
          begin
//            acgPlaylist.ExpandNode(J + CNT_CUESHEET_HEADER);

            Item := GetCueSheetItemByIndex(J);
            if (Item <> nil) then
            begin
              RemoveItemList.Add(Item);
            end;

            RemoveRowList.Add(J);//acgPlaylist.DisplRowIndex(J + CNT_CUESHEET_HEADER));
          end;

          Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('Get delete item & row count.' +
                                                                     'Item count = %d, ' +
                                                                     'Row count = %d',
                                                                     [RemoveItemList.Count,
                                                                      RemoveRowList.Count
                                                                      ])));

          // Delete rows
          for J := RemoveRowList.Count - 1 downto 0 do
          begin
//            acgPlaylist.RemoveNode(acgPlaylist.RealRowIndex(RemoveRowList[J]));
//            acgPlaylist.RemoveNormalRow(RemoveRowList[J]);
//            acgPlaylist.RemoveChildRow(acgPlaylist.RealRowIndex(RemoveRowList[J]));
            deletePlayListGridMain(RemoveRowList[J]);
          end;

          Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Success delete rows & nodes.'));

          if (ChannelOnAir) then
          begin
            Dec(FLastInputIndex, RemoveItemList.Count);

            ServerBeginUpdates(ChannelID);
            try
              ServerDeleteCueSheets(ChannelID, RemoveItemList);
            finally
              ServerEndUpdates(ChannelID);
            end;
          end;

          // Delete event items
          for J := RemoveItemList.Count - 1 downto 0 do
          begin
            Item := RemoveItemList[J];

            DeletePlayListTimeLineByItem(Item);

            FCueSheetLock.Enter;
            try
              FCueSheetList.Remove(Item);
              Dispose(Item);
            finally
              FCueSheetLock.Leave;
            end;
          end;

          Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Success delete event items.'));

        finally
          RemoveItemList.Clear;
          RemoveRowList.Clear;

          FreeAndNil(RemoveItemList);
          FreeAndNil(RemoveRowList);
        end;
  finally
    acgPlaylist.MouseActions.DisjunctRowSelect := True;
//    if (SaveSelectRow >= 0) and (SaveSelectRow < acgPlaylist.RowCount) then
//      acgPlaylist.Row := SaveSelectRow;
    SelectRowPlayListGrid(SaveSelectRow);

    acgPlaylist.EndUpdate;

    wmtlPlaylist.EndUpdateCompositions;
  end;

        FLastDisplayNo := GetBeforeMainCountByIndex(StartIndex) - 1;

        ResetNo(StartIndex, FLastDisplayNo);
//        DisplayPlayListGrid(StartIndex);

        if (ChannelOnAir) then
        begin
          ServerBeginUpdates(ChannelID);
          try
            ServerInputCueSheets(ChannelID, StartIndex);
          finally
            ServerEndUpdates(ChannelID);
          end;
        end;

        if (not ChannelOnAir) then
        begin
          CalcuratePlayListTimeLineRange;
          UpdatePlayListTimeLineRange;
        end;
        DisplayPlayListTimeLine(StartIndex);

        FLastCount := FCueSheetList.Count;

        if (ChannelOnAir) then
        begin
          ServerBeginUpdates(ChannelID);
          try
            ServerDeleteChannelCueSheets(ChannelCueSheet);
          finally
            ServerEndUpdates(ChannelID);
          end;
        end;

        FChannelCueSheetList.Remove(ChannelCueSheet);
        Dispose(ChannelCueSheet);
      end;
    end;

  if (FChannelCueSheetList.Count <= 0) then NewPlayList;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Finish AutoEjectPlayList procedure.'));
end;

procedure TfrmChannel.MediaCheck(ASourceHandle: PSourceHandle);
var
  CurrentTime: TDateTime;
  Index: Integer;
  I, J: Integer;
  Item, ParentItem: PCueSheetItem;

  StartTime: TDateTime;

  Source: PSource;
  SourceHandles: TSourceHandleList;

  R: Integer;
  MediaExist: Boolean;
  MediaDuration: TTimecode;
  EventDuration: TTimecode;
begin
  if (not HasMainControl) then exit;

  if (not ChannelOnAir) then exit;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Start MediaCheck procedure.'));

  CurrentTime := Now;

  if (CueSheetNext <> nil) then
    Index := GetCueSheetIndexByItem(CueSheetNext)
  else
    Index := 0;

  Item := GetMainItemByStartTime(Index, CurrentTime);
  if (Item = nil) then exit;

  Index := GetCueSheetIndexByItem(Item);

{  Index := GetStartOnAirMainIndex;
  if (Index < 0) or (Index > FCueSheetList.Count - 1) then exit; }

//  if (ChannelOnAir) then
//    ServerBeginUpdates(ChannelID);

//  frmSEC.DCSEventThread.ClearMediaCheckQueueByChannelID(AID:Word; AHandle: TDeviceHandle; AChannelID: Word);

  try
    for I := Index to FCueSheetList.Count - 1 do
    begin
      Item := GetCueSheetItemByIndex(I);
      if (Item <> nil) and (Item^.EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) and
         (Item^.EventStatus.State <> esSkipped) then
      begin
        if (Item^.StartMode in [SM_SUBBEGIN, SM_SUBEND]) then
        begin
          ParentItem := GetParentCueSheetItemByItem(Item);
          if (ParentItem <> nil) then
          begin
            if (Item^.StartMode = SM_SUBBEGIN) then
            begin
              StartTime := EventTimeToDateTime(GetEventTimeSubBegin(ParentItem^.StartTime, Item^.StartTime.T, ChannelFrameRateType), ChannelFrameRateType);
            end
            else
            begin
              StartTime := EventTimeToDateTime(GetEventTimeSubEnd(ParentItem^.StartTime, ParentItem^.DurationTC, Item^.StartTime.T, ChannelFrameRateType), ChannelFrameRateType);
            end;
          end;
        end
        else
          StartTime := EventTimeToDateTime(Item^.StartTime, ChannelFrameRateType);

        if {(StartTime < Now) or }(DateTimeToTimecode(StartTime - CurrentTime, ChannelFrameRateType) <= GV_SettingTimeParameter.MediaCheckTime) then
        begin
          MediaCheck(Item, ASourceHandle);
        end
        else
          break;
      end;
    end;
  finally
//    if (ChannelOnAir) then
//      ServerEndUpdates(ChannelID);
  end;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Finish MediaCheck procedure.'));
end;

procedure TfrmChannel.MediaCheck(AItem: PCueSheetItem; ASourceHandle: PSourceHandle);
var
  I: Integer;
  PItem: PCueSheetItem;
  StartTime: TEventTime;
  EventDuration: TTimecode;

  Source: PSource;
  SourceHandles: TSourceHandleList;
  SourceHandle: PSourceHandle;

  R: Integer;
begin
  if (not HasMainControl) then exit;

  if (AItem = nil) then exit;

  // Main DCS�� ��쿡�� Media check ó��
  Source := GetSourceByName(String(AItem^.Source));
  if (Source <> nil) and (Source^.QueryDuration) then // (Source^.SourceType = ST_VSDEC) then
  begin
    SourceHandles := Source^.Handles;
    if (SourceHandles <> nil) then
    begin
      for I := 0 to SourceHandles.Count - 1 do
      begin
        SourceHandle := SourceHandles[I];
        if ((ASourceHandle = nil) or (SourceHandle = ASourceHandle)) and
           (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
           (SourceHandle^.DCS^.Main) and
           (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
        begin
          R := frmSEC.DCSEventThread.MediaCheck(SourceHandle, AItem^.EventID, String(AItem^.MediaId), AItem^.InTC, AItem^.DurationTC);
          break;
        end;
      end;
    end;
  end;
end;

procedure TfrmChannel.BlankCheck;
var
  Index: Integer;
  Item: PCueSheetItem;
  WarningText: String;

  WarningStrLen: Integer;
//  WarningStr: PChar;

  WarningStrParam: DWORD;
begin
  if (not HasMainControl) then exit;

  if (not ChannelOnAir) then exit;

  if (CueSheetCurr <> nil) then
    Index := GetCueSheetIndexByItem(CueSheetCurr)
  else if (CueSheetNext <> nil) then
    Index := GetCueSheetIndexByItem(CueSheetNext)
  else
    Index := 0;

  Item := GetMainItemByStartTime(Index, IncMilliSecond(Now, TimecodeToMilliSec(GV_SettingTimeParameter.BlankCheckTime, FR_30)));
  if (Item = nil) then
  begin
//    if (FBlankCheckThread.FWarningDialog = nil) or (not FBlankCheckThread.FWarningDialog.Showing) then
    begin
      WarningText := Format(SWNotExistNextEvent, [GetChannelNameByID(ChannelID)]);

      WarningStrLen := Length(WarningText) + 1;
//      WarningStr := StrAlloc(WarningStrLen);
//      StrPLCopy(WarningStr, WarningText);

      WarningStrParam := GlobalAddAtom(PChar(WarningText));
      System.Classes.TThread.CreateAnonymousThread(
        procedure
        begin
//          PostMessage(Handle, WM_WARNING_DISPLAY_NOT_EXIST_EVENT, WarningStrLen, LParam(WarningStr));
          PostMessage(Handle, WM_WARNING_DISPLAY_NOT_EXIST_EVENT, WarningStrLen, WarningStrParam);
        end).Start;
    end;

    exit;
  end;
end;

procedure TfrmChannel.UpdateMCCCheck(AMCC: PMCC; AAlive: Boolean);
var
  R, I: Integer;
begin
  if (not HasMainControl) then exit;
  if (AMCC = nil) then exit;

  if (AAlive) then
  begin
//    R := MCCBeginUpdate(AMCC^.HostIP, ChannelID);
//    if (R <> D_OK) then exit;

    try
      R := frmSEC.MCCEventThread.SetOnAir(AMCC, ChannelID, ChannelOnAir);
      if (R <> D_OK) then exit;

      if (ChannelOnAir) then
      begin
        R := frmSEC.MCCEventThread.ClearCueSheet(AMCC, ChannelID);
        if (R <> D_OK) then exit;

        for I := 0 to FCueSheetList.Count - 1 do
        begin
          R := frmSEC.MCCEventThread.InputCueSheet(AMCC, I, FCueSheetList[I]^);
          if (R <> D_OK) then exit;
        end;

        if (CueSheetNext <> nil) then
        begin
          R := frmSEC.MCCEventThread.SetCueSheetNext(AMCC, CueSheetNext^.EventID);
          if (R <> D_OK) then exit;
        end;

        if (CueSheetCurr <> nil) then
        begin
          R := frmSEC.MCCEventThread.SetCueSheetCurr(AMCC, CueSheetCurr^.EventID);
          if (R <> D_OK) then exit;
        end;

        if (CueSheetTarget <> nil) then
        begin
          R := frmSEC.MCCEventThread.SetCueSheetTarget(AMCC, CueSheetTarget^.EventID);
          if (R <> D_OK) then exit;
        end;
      end;
    finally
//      R := MCCEndUpdate(AMCC^.HostIP, ChannelID);
    end;
  end;
end;

procedure TfrmChannel.UpdateSECCheck(ASEC: PSEC; AAlive: Boolean);
var
  R, I: Integer;
begin
  if (not HasMainControl) then exit;
  if (ASEC = nil) then exit;

  Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('UpdateSECCheck start, Channel = %d', [ChannelID])));

  if (AAlive) then
  begin
//    R := SECBeginUpdate(ASEC, ChannelID);
//    if (R <> D_OK) then exit;

    R := frmSEC.SECEventThread.SetCmdBeginUpdate(ASEC, ChannelID);
    if (R <> D_OK) then
    begin
      Assert(False, GetChannelLogStr(lsError, ChannelID, Format('UpdateSECCheck SetCmdBeginUpdate failed, error = %d, Channel = %d', [R, ChannelID])));
      exit;
    end
    else
      Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('UpdateSECCheck SetCmdBeginUpdate succeeded, Channel = %d', [ChannelID])));

    try
      R := frmSEC.SECEventThread.SetOnAir(ASEC, ChannelID, ChannelOnAir);
      if (R <> D_OK) then
      begin
        Assert(False, GetChannelLogStr(lsError, ChannelID, Format('UpdateSECCheck SetOnAir failed, error = %d, Channel = %d, OnAir = %s', [R, ChannelID, BoolToStr(ChannelOnAir, True)])));
        exit;
      end
      else
        Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('UpdateSECCheck SetOnAir succeeded, Channel = %d, OnAir = %s', [ChannelID, BoolToStr(ChannelOnAir, True)])));

//      R := frmSEC.SECEventThread.SetTimelineRange(ASEC^.HostIP, ChannelID, FTimelineStartDate, FTimelineEndDate);
//      if (R <> D_OK) then exit;

      if (ChannelOnAir) then
      begin
        // Clear channel cuesheet list
        R := frmSEC.SECEventThread.ClearChannelCueSheet(ASEC, ChannelID);
        if (R <> D_OK) then
        begin
          Assert(False, GetChannelLogStr(lsError, ChannelID, Format('UpdateSECCheck ClearChannelCueSheet failed, error = %d, Channel = %d', [R, ChannelID])));
          exit;
        end
        else
          Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('UpdateSECCheck ClearChannelCueSheet succeeded, Channel = %d', [ChannelID])));

        // Input channel cuesheet list
        for I := 0 to FChannelCueSheetList.Count - 1 do
        begin
          R := frmSEC.SECEventThread.InputChannelCueSheet(ASEC, I, FChannelCueSheetList[I]^);
          if (R <> D_OK) then
          begin
            Assert(False, GetChannelLogStr(lsError, ChannelID, Format('UpdateSECCheck InputChannelCueSheet failed, error = %d, Channel = %d, File = %s', [R, ChannelID, FChannelCueSheetList[I]^.FileName])));
            exit;
          end
          else
            Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('UpdateSECCheck InputChannelCueSheet succeeded, Channel = %d, File = %s', [ChannelID, FChannelCueSheetList[I]^.FileName])));
        end;

        // Clear cuesheet list
        R := frmSEC.SECEventThread.ClearCueSheet(ASEC, ChannelID);
        if (R <> D_OK) then
        begin
          Assert(False, GetChannelLogStr(lsError, ChannelID, Format('UpdateSECCheck ClearCueSheet failed, error = %d, Channel = %d', [R, ChannelID])));
          exit;
        end
        else
          Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('UpdateSECCheck ClearCueSheet succeeded, Channel = %d', [ChannelID])));

        // Input cuesheet
        for I := 0 to FCueSheetList.Count - 1 do
        begin
          R := frmSEC.SECEventThread.InputCueSheet(ASEC, I, FCueSheetList[I]^);
          if (R <> D_OK) then
          begin
            Assert(False, GetChannelLogStr(lsError, ChannelID, Format('UpdateSECCheck InputCueSheet failed, error = %d, Channel = %d, ID = %s', [R, ChannelID, EventIDToString(FCueSheetList[I]^.EventID)])));
            exit;
          end
          else
            Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('UpdateSECCheck InputCueSheet succeeded, Channel = %d, ID = %s', [ChannelID, EventIDToString(FCueSheetList[I]^.EventID)])));
        end;

        if (CueSheetNext <> nil) then
        begin
          R := frmSEC.SECEventThread.SetCueSheetNext(ASEC, CueSheetNext^.EventID);
          if (R <> D_OK) then
          begin
            Assert(False, GetChannelLogStr(lsError, ChannelID, Format('UpdateSECCheck SetCueSheetNext failed, error = %d, Channel = %d, ID = %s', [R, ChannelID, EventIDToString(CueSheetNext^.EventID)])));
            exit;
          end
          else
            Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('UpdateSECCheck SetCueSheetNext succeeded, Channel = %d, ID = %s', [ChannelID, EventIDToString(CueSheetNext^.EventID)])));
        end;

        if (CueSheetCurr <> nil) then
        begin
          R := frmSEC.SECEventThread.SetCueSheetCurr(ASEC, CueSheetCurr^.EventID);
          if (R <> D_OK) then
          begin
            Assert(False, GetChannelLogStr(lsError, ChannelID, Format('UpdateSECCheck SetCueSheetCurr failed, error = %d, Channel = %d, ID = %s', [R, ChannelID, EventIDToString(CueSheetCurr^.EventID)])));
            exit;
          end
          else
            Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('UpdateSECCheck SetCueSheetCurr failed, Channel = %d, ID = %s', [ChannelID, EventIDToString(CueSheetCurr^.EventID)])));
        end;

        if (CueSheetTarget <> nil) then
        begin
          R := frmSEC.SECEventThread.SetCueSheetTarget(ASEC, CueSheetTarget^.EventID);
          if (R <> D_OK) then
          begin
            Assert(False, GetChannelLogStr(lsError, ChannelID, Format('UpdateSECCheck SetCueSheetTarget failed, error = %d, Channel = %d, ID = %s', [R, ChannelID, EventIDToString(CueSheetTarget^.EventID)])));
            exit;
          end
          else
            Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('UpdateSECCheck SetCueSheetTarget failed, Channel = %d, ID = %s', [ChannelID, EventIDToString(CueSheetTarget^.EventID)])));
        end;
      end;
    finally
//      R := SECEndUpdate(ASEC, ChannelID);

      R := frmSEC.SECEventThread.SetCmdEndUpdate(ASEC, ChannelID);
      if (R <> D_OK) then
      begin
        Assert(False, GetChannelLogStr(lsError, ChannelID, Format('UpdateSECCheck SetCmdEndUpdate failed, error = %d, Channel = %d', [R, ChannelID])));
      end
      else
        Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('UpdateSECCheck SetCmdEndUpdate succeeded, Channel = %d', [ChannelID])));
    end;
  end;
end;

procedure TfrmChannel.OnAirInputEvents(AIndex, ACount: Integer; ANewEventOnly: Boolean);
var
  I: Integer;
  StartItem: PCueSheetItem;
  PItem, CItem: PCueSheetItem;
  PGroupNo: Word;
  GroupCount: Integer;
  R: Integer;
  IsCancel: Boolean;
begin
  if (not HasMainControl) then exit;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  if (ACount <= 0) then ACount := GV_SettingOption.MaxInputEventCount;

  IsCancel := False;
  GroupCount := 0;
  PItem := GetParentCueSheetItemByIndex(AIndex);
  // Parent Main Item�� ���� ��� AIndex �� Item���� ó��
  if (PItem = nil) then
    PItem := GetCueSheetItemByIndex(AIndex);

  if (PItem <> nil) then
  begin
    StartItem := GetStartOnAirMainItem;

    PGroupNo := PItem^.GroupNo;
//    PGroupNo := -1;
    AIndex := GetCueSheetIndexByItem(PItem);
    for I := AIndex to FCueSheetList.Count - 1 do
    begin
      CItem := GetCueSheetItemByIndex(I);
      if (CItem <> nil) then
      begin
        if (CItem^.EventMode = EM_COMMENT) then continue;

        if (ANewEventOnly) then
        begin
          if (CItem^.EventStatus.State <> esIdle) then
          begin
            if (PGroupNo <> CItem^.GroupNo) then
            begin
              PGroupNo := CItem^.GroupNo;

              if (CItem^.EventMode = EM_MAIN) then
                Inc(GroupCount);
            end;

            if (GroupCount >= ACount) then break;

            Continue;
          end;
        end;

  {      if (PGroupNo <> CItem^.GroupNo) then
        begin
          // ù ���� �̺�Ʈ�� ������ ��� �ڽ� �̺�Ʈ������ ���� ó��
          if (PItem^.EventStatus.State = esError) and (FCueSheetNext = nil) then
            break;
        end; }

        if (CItem^.EventStatus.State <> esSkipped) then
        begin
          if (PGroupNo <> CItem^.GroupNo) then
          begin
            PGroupNo := CItem^.GroupNo;

            if (CItem^.EventMode = EM_MAIN) then
              Inc(GroupCount);
          end;

          if (IsCancel) and (GroupCount = 1) then break;
          if (GroupCount >= ACount) then break;

          R := InputEvent(CItem);


          // If an event is not input to all DCS, an error is displayed in the first event.
          if (R <> D_OK) and (R <> E_INVALID_START_TIME) then
          begin
            if ((CueSheetNext = CItem) or
                ((CueSheetNext <> nil) and (CueSheetNext^.GroupNo = CItem^.GroupNo))) or
               ((StartItem = CItem) or
                (StartItem <> nil) and (StartItem^.GroupNo = CItem^.GroupNo)) then
            begin
              CItem^.EventStatus.State := esError;
              SetEventStatus(CItem^.EventID, CItem^.EventStatus);

  //            acgPlaylist.RepaintRow(I + CNT_CUESHEET_HEADER);

              if (CueSheetNext = CItem) then
                IsCancel := True;
            end;
  //          break;
          end;

  //        ShowMessage(IntToStr(I));
        end;
      end;
    end;

    FLastInputIndex := I - 1;
  end;

//  if (PItem^.EventMode = EM_MAIN) and (FCueSheetNext = nil) then
//    FCueSheetNext := PItem;
end;

procedure TfrmChannel.OnAirDeleteEvents(AFromIndex, AToIndex: Integer);
var
  I: Integer;
  PItem, CItem: PCueSheetItem;
  PGroupNo: Word;
begin
  if (not HasMainControl) then exit;

  if (FCueSheetList = nil) then exit;
  if (AFromIndex < 0) or (AFromIndex > FCueSheetList.Count - 1) then exit;
  if (AToIndex < 0) or (AToIndex > FCueSheetList.Count - 1) then exit;

  PItem := GetParentCueSheetItemByIndex(AFromIndex);
  if (PItem = nil) then exit;

  AFromIndex := GetCueSheetIndexByItem(PItem);

  CItem := GetLastChildCueSheetItemByIndex(AToIndex);
  if (CItem = nil) then exit;

  AToIndex := GetCueSheetIndexByItem(CItem);

//  for I := AFromIndex to AToIndex do
  for I := AToIndex downto AFromIndex do
  begin
    CItem := GetCueSheetItemByIndex(I);
    if (CItem <> nil) then
    begin
  //    DeletePlayListTimeLine(CItem);
      DeleteEvent(CItem);
      if (CItem^.EventStatus.State <> esSkipped) then
        CItem^.EventStatus.State := esIdle;

      if (CItem^.EventMode = EM_MAIN) and (CueSheetNext = CItem) then
        CueSheetNext := nil;
    end;
  end;
end;

procedure TfrmChannel.OnAirClearEvents;
var
  I: Integer;
  PItem, CItem: PCueSheetItem;
  FromIndex, ToIndex: Integer;

  CheckCount: Integer;
begin
  if (not HasMainControl) then exit;

  ClearEvent;

  if (CueSheetCurr <> nil) then
    PItem := GetParentCueSheetItemByItem(CueSheetCurr)
  else if (CueSheetNext <> nil) then
    PItem := GetParentCueSheetItemByItem(CueSheetNext)
  else exit;

  if (PItem = nil) then exit;

  FromIndex := GetCueSheetIndexByItem(PItem);

  CheckCount := 0;
  for I := FromIndex to FCueSheetList.Count - 1 do
  begin
    CItem := GetCueSheetItemByIndex(I);
    if (CItem <> nil) then
    begin
      if (CItem^.EventMode = EM_MAIN) then Inc(CheckCount);

      if (CheckCount >= GV_SettingOption.MaxInputEventCount) then break;

      if (CItem^.EventStatus.State <> esSkipped) then
      begin
        CItem^.EventStatus.State := esIdle;
        CItem^.EventStatus.ErrorCode := E_NO_ERROR;

  //      SetEventStatus(CItem^.EventID, CItem^.EventStatus);
        PostMessage(Handle, WM_UPDATE_EVENT_STATUS, I, NativeInt(CItem));
        ServerSetEventStatuses(CItem^.EventID, CItem^.EventStatus);
      end;
    end;
  end;




exit;
  ClearEvent;

  if (CueSheetCurr <> nil) then
    PItem := GetParentCueSheetItemByItem(CueSheetCurr)
  else if (CueSheetNext <> nil) then
    PItem := GetParentCueSheetItemByItem(CueSheetNext)
  else exit;

  if (PItem = nil) then exit;

  FromIndex := GetCueSheetIndexByItem(PItem);

  CItem := GetLastChildCueSheetItemByIndex(FromIndex + GV_SettingOption.MaxInputEventCount - 1);
  if (CItem <> nil) then
    ToIndex := GetCueSheetIndexByItem(CItem)
  else
    ToIndex := FCueSheetList.Count - 1;

  for I := FromIndex to ToIndex do
//  for I := 0 to FCueSheetList.Count - 1 do
  begin
    CItem := GetCueSheetItemByIndex(I);
    if (CItem <> nil) then
    begin
      if (CItem^.EventStatus.State <> esSkipped) then
      begin
        CItem^.EventStatus.State := esIdle;

  {      if (CItem^.EventMode <> EM_COMMENT) then
          with acgPlaylist do
            AllCells[IDX_COL_CUESHEET_EVENT_STATUS, RealRowIndex(I) + CNT_CUESHEET_HEADER] := EventStatusNames[CItem^.EventStatus.State];
  }
      end;

  //    if (CItem^.EventMode = EM_MAIN) and (CueSheetNext = CItem) then
  //      CueSheetNext := nil;
    end;
  end;

  acgPlaylist.Repaint;
end;

procedure TfrmChannel.OnAirTakeEvent(AIndex: Integer);
var
  ParentItem: PCueSheetItem;
  ParentIndex: Integer;

  Item: PCueSheetItem;
  I: Integer;
begin
  if (not HasMainControl) then exit;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

{  ParentItem := GetParentCueSheetItemByIndex(AIndex);
  if (ParentItem <> nil) then
  begin
    ParentIndex := GetCueSheetIndexByItem(ParentItem);
    for I := ParentIndex to FCueSheetList.Count - 1 do
    begin
      Item := GetCueSheetItemByIndex(I);
      if (Item <> nil) and (ParentItem^.GroupNo = Item^.GroupNo) then
      begin
        TakeEvent(Item);
      end
      else
        break;
    end;
  end; }

  Item := GetCueSheetItemByIndex(AIndex);
  if (Item <> nil) then
    TakeEvent(Item);
end;

procedure TfrmChannel.OnAirHoldEvent(AIndex: Integer);
var
  ParentItem: PCueSheetItem;
  ParentIndex: Integer;

  Item: PCueSheetItem;
  I: Integer;
begin
  if (not HasMainControl) then exit;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  ParentItem := GetParentCueSheetItemByIndex(AIndex);
  if (ParentItem <> nil) then
  begin
    ParentIndex := GetCueSheetIndexByItem(ParentItem);
    for I := ParentIndex to FCueSheetList.Count - 1 do
    begin
      Item := GetCueSheetItemByIndex(I);
      if (Item <> nil) and (ParentItem^.GroupNo = Item^.GroupNo) then
      begin
        HoldEvent(Item);
      end
      else
        break;
    end;
  end;
end;

procedure TfrmChannel.OnAirChangeDurationEvent(AIndex: Integer; ASaveDuration, AChangeDuration: TTimecode);
var
  Item: PCueSheetItem;
  ChildCount: Integer;
  DurTC: TTimecode;

  EndTime: TEventTime;
  I: Integer;
begin
  if (not HasMainControl) then exit;

  if (FCueSheetList = nil) then exit;
  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  Item := GetCueSheetItemByIndex(AIndex);
  if (Item = nil) then exit;

  ChangeDurationEvent(Item, AChangeDuration);

{  ChildCount := GetChildCountByItem(CueSheetCurr);
  if (ChildCount > 0) then
  begin
    DurTC := GetDurTimecode(ASaveDuration, AChangeDuration, ChannelFrameRateType);

    for I := AIndex + 1 to AIndex + ChildCount - 1 do
    begin
      Item := GetCueSheetItemByIndex(I);
      if (Item <> nil) and (Item^.GroupNo <> CueSheetCurr.GroupNo) then
      begin
        if (ASaveDuration < AChangeDuration) then
          Item^.DurationTC := GetPlusTimecode(Item^.DurationTC, DurTC, ChannelFrameRateType)
        else
          Item^.DurationTC := GetMinusTimecode(Item^.DurationTC, DurTC, ChannelFrameRateType);

        ChangeDurationEvent(Item, Item^.DurationTC);
      end;
    end;
  end; }
end;

function TfrmChannel.MakePlayerEvent(AItem, AParentItem: PCueSheetItem; var AEvent: TEvent): Integer;
var
//  ParentItem: PCueSheetItem;
  CheckTime, EndTime: TEventTime;
begin
  Result := D_FALSE;

  FillChar(AEvent, SizeOf(TEvent), #0);
  with AEvent do
  begin
    EventID   := AItem^.EventID;
    StartTime := AItem^.StartTime;

//    ParentItem := nil;
    if (AItem^.StartMode in [SM_SUBBEGIN, SM_SUBEND]) then
    begin
      if (AParentItem = nil) then
        AParentItem := GetParentCueSheetItemByItem(AItem);

      if (AParentItem <> nil) then
      begin
        if (AItem^.StartMode = SM_SUBBEGIN) then
        begin
//          StartTime := GetPlusEventTime(ParentItem^.StartTime, TimecodeToEventTime(AItem^.StartTime.T));

//          StartTime := ParentItem^.StartTime;
//          StartTime.T := StartTime.T + AItem^.StartTime.T;

          StartTime := GetEventTimeSubBegin(AParentItem^.StartTime, AItem^.StartTime.T, ChannelFrameRateType);

//            ShowMessage(DateTimeToStr(EventTimeToDateTime(StartTime)));
        end
        else
        begin
//          StartTime := GetMinusEventTime(GetPlusEventTime(ParentItem^.StartTime, TimecodeToEventTime(ParentItem^.DurationTC)), TimecodeToEventTime(AItem^.StartTime.T));

//          StartTime := ParentItem^.StartTime;
//          StartTime.T := StartTime.T + ParentItem^.DurationTC;
//          StartTime.T := StartTime.T - AItem^.StartTime.T - AItem^.DurationTC;

          StartTime := GetEventTimeSubEnd(AParentItem^.StartTime, AParentItem^.DurationTC, AItem^.StartTime.T, ChannelFrameRateType);

//            ShowMessage(DateTimeToStr(EventTimeToDateTime(StartTime)));
        end;
      end;
    end;
//      ShowMessage(DateTimeToStr(EventTimeToDateTime(StartTime)));
    DurTime             := AItem^.DurationTC;


{    CheckTime := GetPlusEventTime(DateTimeToEventTime(Now, ChannelFrameRateType), TimecodeToEventTime(GV_SettingThresholdTime.EditLockTime), ChannelFrameRateType);
    EndTime   := GetEventEndTime(StartTime, DurTime, ChannelFrameRateType);
//    Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('MakePlayerEvent, CheckTime = %s, EndTime = %s', [EventTimeToString(CheckTime), EventTimeToString(EndTime)])));
    if (CompareEventTime(EndTime, CheckTime, ChannelFrameRateType) <= 0) then
    begin
      Result := E_INVALID_SCHEDULE;
      exit;
    end; }

    TakeEvent           := False;
    ManualEvent         := (AItem^.StartMode = SM_MANUAL) or
                           ((AParentItem <> nil) and (AParentItem^.StartMode = SM_MANUAL));
    EventType           := ET_PLAYER;
    Player.StartTC      := AItem^.InTC;
    Player.Layer        := AItem^.SourceLayer;
    Player.PlayerAction := PA_PLAY;

//    ShowMessage(Format('%s %d %d', [AItem^.Source, Integer(AItem^.Input), Integer(AItem^.Output)]));

    case AItem^.Input of
      IT_NONE:
      begin
        case TOutputKeyerType(AItem^.Output) of
          OK_NONE: Player.PlayerAction := PA_NONE;
          OK_ON: Player.PlayerAction := PA_RECORD;
          OK_OFF: Player.PlayerAction := PA_STOP;
          OK_AD: Player.PlayerAction := PA_AD;
//          else
//            exit;
        end;
      end;
    end;

//    ShowMessage(IntToStr(Integer(Player.PlayerAction)));

    Player.FinishAction := AItem^.FinishAction;
//    StrCopy(Player.ID.BinNo, ACueSheet^.BinNo);
    StrPLCopy(Player.ID.ID, Trim(String(AItem^.MediaId)), MEDIAID_LEN);
    StrPLCopy(Player.ExtraInfo1, Trim(String(AItem^.Notes)), MAXCHAR);
    StrPLCopy(Player.ExtraInfo2, Trim(String(AItem^.SubTitle)), MAXCHAR);
  end;

  Result := D_OK;
end;

function TfrmChannel.MakeSwitcherEvent(AItem, AParentItem: PCueSheetItem; var AEvent: TEvent; ASourceName: String; ARouter: TXptList): Integer;
var
//  ParentItem: PCueSheetItem;
  SourceXpt: Integer;
begin
  Result := D_FALSE;

  FillChar(AEvent, SizeOf(TEvent), #0);
  with AEvent do
  begin
    if (AItem^.Input in [IT_MAIN, IT_BACKUP]) then
    begin
      SourceXpt := GetSourceXptByName(ARouter, ASourceName);
      if (SourceXpt < 0) then exit;
    end;

    EventID   := AItem^.EventID;
    StartTime := AItem^.StartTime;

//    ParentItem := nil;
    if (AItem^.StartMode in [SM_SUBBEGIN, SM_SUBEND]) then
    begin
      if (AParentItem = nil) then
        AParentItem := GetParentCueSheetItemByItem(AItem);

      if (AParentItem <> nil) then
      begin
        if (AItem^.StartMode = SM_SUBBEGIN) then
        begin
          StartTime := GetEventTimeSubBegin(AParentItem^.StartTime, AItem^.StartTime.T, ChannelFrameRateType);
        end
        else
        begin
          StartTime := GetEventTimeSubEnd(AParentItem^.StartTime, AParentItem^.DurationTC, AItem^.StartTime.T, ChannelFrameRateType);
        end;
      end;
    end;

    DurTime             := 0;//AItem^.DurationTC;
    TakeEvent           := False;
    ManualEvent         := (AItem^.StartMode = SM_MANUAL) or
                           ((AParentItem <> nil) and (AParentItem^.StartMode = SM_MANUAL));

    EventType           := ET_SWITCHER;

    Switcher.MainVideo := -1;
    Switcher.MainAudio := -1;
    Switcher.BackupVideo := -1;
    Switcher.BackupAudio := -1;
    Switcher.Key1 := -1;
    Switcher.Key2 := -1;
    Switcher.Key3 := -1;
    Switcher.Key4 := -1;
    Switcher.Key5 := -1;
    Switcher.Key6 := -1;
    Switcher.Key7 := -1;
    Switcher.Key8 := -1;
    Switcher.Mix1 := -1;
    Switcher.Mix2 := -1;

    case AItem^.Input of
      IT_MAIN:
      begin
//        SourceXpt := GetSourceXptByName(ARouter, ASourceName);
        case TOutputBkgndType(AItem^.Output) of
          OB_VIDEO: Switcher.MainVideo := SourceXpt;
          OB_AUDIO: Switcher.MainAudio := SourceXpt;
          OB_BOTH:
          begin
            Switcher.MainVideo := SourceXpt;
            Switcher.MainAudio := SourceXpt;
          end;
//          else
//            exit;
        end;
      end;
      IT_BACKUP:
      begin
//        SourceXpt := GetSourceXptByName(ARouter, ASourceName);
        case TOutputBkgndType(AItem^.Output) of
          OB_VIDEO: Switcher.BackupVideo := SourceXpt;
          OB_AUDIO: Switcher.BackupAudio := SourceXpt;
          OB_BOTH:
          begin
            Switcher.BackupVideo := SourceXpt;
            Switcher.BackupAudio := SourceXpt;
          end;
//          else
//            exit;
        end;
      end;
      IT_KEYER1:
      begin
        case TOutputKeyerType(AItem^.Output) of
          OK_NONE: Switcher.Key1 := -1;
          OK_ON: Switcher.Key1 := 1;
          OK_OFF: Switcher.Key1 := 0;
          OK_AD: Switcher.Key1 := -1;
//          else
//            exit;
        end;
      end;
      IT_KEYER2:
      begin
        case TOutputKeyerType(AItem^.Output) of
          OK_NONE: Switcher.Key2 := -1;
          OK_ON: Switcher.Key2 := 1;
          OK_OFF: Switcher.Key2 := 0;
          OK_AD: Switcher.Key2 := -1;
//          else
//            exit;
        end;
      end;
      IT_KEYER3:
      begin
        case TOutputKeyerType(AItem^.Output) of
          OK_NONE: Switcher.Key3 := -1;
          OK_ON: Switcher.Key3 := 1;
          OK_OFF: Switcher.Key3 := 0;
          OK_AD: Switcher.Key3 := -1;
//          else
//            exit;
        end;
      end;
      IT_KEYER4:
      begin
        case TOutputKeyerType(AItem^.Output) of
          OK_NONE: Switcher.Key4 := -1;
          OK_ON: Switcher.Key4 := 1;
          OK_OFF: Switcher.Key4 := 0;
          OK_AD: Switcher.Key4 := -1;
//          else
//            exit;
        end;
      end;
      IT_KEYER5:
      begin
        case TOutputKeyerType(AItem^.Output) of
          OK_NONE: Switcher.Key5 := -1;
          OK_ON: Switcher.Key5 := 1;
          OK_OFF: Switcher.Key5 := 0;
          OK_AD: Switcher.Key5 := -1;
//          else
//            exit;
        end;
      end;
      IT_KEYER6:
      begin
        case TOutputKeyerType(AItem^.Output) of
          OK_NONE: Switcher.Key6 := -1;
          OK_ON: Switcher.Key6 := 1;
          OK_OFF: Switcher.Key6 := 0;
          OK_AD: Switcher.Key6 := -1;
//          else
//            exit;
        end;
      end;
      IT_KEYER7:
      begin
        case TOutputKeyerType(AItem^.Output) of
          OK_NONE: Switcher.Key7 := -1;
          OK_ON: Switcher.Key7 := 1;
          OK_OFF: Switcher.Key7 := 0;
          OK_AD: Switcher.Key7 := -1;
//          else
//            exit;
        end;
      end;
      IT_KEYER8:
      begin
        case TOutputKeyerType(AItem^.Output) of
          OK_NONE: Switcher.Key8 := -1;
          OK_ON: Switcher.Key8 := 1;
          OK_OFF: Switcher.Key8 := 0;
          OK_AD: Switcher.Key8 := -1;
//          else
//            exit;
        end;
      end;
      IT_AMIXER1:
      begin
        case TOutputKeyerType(AItem^.Output) of
          OK_NONE: Switcher.Mix1 := -1;
          OK_ON: Switcher.Mix1 := 1;
          OK_OFF: Switcher.Mix1 := 0;
          OK_AD: Switcher.Mix1 := -1;
//          else
//            exit;
        end;
      end;
      IT_AMIXER2:
      begin
        case TOutputKeyerType(AItem^.Output) of
          OK_NONE: Switcher.Mix2 := -1;
          OK_ON: Switcher.Mix2 := 1;
          OK_OFF: Switcher.Mix2 := 0;
          OK_AD: Switcher.Mix2 := -1;
//          else
//            exit;
        end;
      end;
    end;

    Switcher.VideoTransType := AItem^.TransitionType;
    Switcher.AudioTransType := AItem^.TransitionType;

    Switcher.VideoTransRate := AItem^.TransitionRate;
    Switcher.AudioTransRate := AItem^.TransitionRate;
  end;

  Result := D_OK;
end;

function TfrmChannel.InputEvent(AItem: PCueSheetItem; AParentItem: PCueSheetItem = nil): Integer;
var
  S, I, J: Integer;
  SourceGroup: PSourceGroup;
  Source: PSource;
  SourceHandles: TSourceHandleList;
  SourceHandle: PSourceHandle;
  Event: TEvent;

  MCSSource: PSource;
  MCSSourceHandles: TSourceHandleList;
  MCSSourceHandle: PSourceHandle;

  DCSOK: Integer;
begin
  Result := D_FALSE;

  if (not HasMainControl) then exit;

  if (AItem^.EventMode = EM_COMMENT) then exit;

  SourceGroup := GetSourceGroupByName(String(AItem^.Source));
  if (SourceGroup = nil) then exit;
  if (SourceGroup^.Sources = nil) then exit;

  DCSOK := D_FALSE;

  for S := 0 to SourceGroup^.Sources.Count - 1 do
  begin
    Source := SourceGroup^.Sources[S];
    if (Source = nil) then continue;

    SourceHandles := Source^.Handles;
    if (SourceHandles = nil) or (SourceHandles.Count <= 0) then continue;

    case Source^.SourceType of
      ST_VSDEC, ST_VSENC,
      ST_VCR,
      ST_CG,
      ST_LINE:
        Result := MakePlayerEvent(AItem, AParentItem, Event);
    end;

    if (Result = D_OK) then
    begin
      // First sub DCS
      for I := 0 to SourceHandles.Count - 1 do
      begin
        SourceHandle := SourceHandles[I];
        if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
           (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) and
           (not SourceHandle^.DCS.Main) then
          DCSOK := frmSEC.DCSEventThread.InputEvent(SourceHandle, Event);
      end;

      // Next main DCS
      for I := 0 to SourceHandles.Count - 1 do
      begin
        SourceHandle := SourceHandles[I];
        if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
           (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) and
           (SourceHandle^.DCS.Main) then
          DCSOK := frmSEC.DCSEventThread.InputEvent(SourceHandle, Event);
      end;

      // Input switcher & router event
      if (AItem^.Input <> IT_NONE) and (Source^.MakeTransition) then
      begin
        for I := 0 to GV_MCSList.Count - 1 do
        begin
          if (GV_MCSList[I]^.ChannelID <> FChannelID) then continue;

          MCSSource := GetSourceByName(String(GV_MCSList[I]^.Name));
          if (MCSSource = nil) then continue;

//          if (MCSSource^.Channel^.ID <> FChannelID) then continue;

          Result := MakeSwitcherEvent(AItem, AParentItem, Event, String(Source^.Name), MCSSource^.Router);
          if (Result <> D_OK) then continue;

          MCSSourceHandles := MCSSource^.Handles;
          if (MCSSourceHandles = nil) or (MCSSourceHandles.Count <= 0) then continue;

          // First sub DCS
          for J := 0 to MCSSourceHandles.Count - 1 do
          begin
            MCSSourceHandle := MCSSourceHandles[J];
            if (MCSSourceHandle^.DCS <> nil) and (MCSSourceHandle^.DCS^.Alive) and
               (MCSSourceHandle^.Handle > INVALID_DEVICE_HANDLE) and
               (not MCSSourceHandle^.DCS.Main) then
            begin
              DCSOK := frmSEC.DCSEventThread.InputEvent(MCSSourceHandle, Event);
  {            if (Result = D_OK) then
              begin
                DCSOK := D_OK;
              end;  }
            end;
          end;

          // Next main DCS
          for J := 0 to MCSSourceHandles.Count - 1 do
          begin
            MCSSourceHandle := MCSSourceHandles[J];
            if (MCSSourceHandle^.DCS <> nil) and (MCSSourceHandle^.DCS^.Alive) and
               (MCSSourceHandle^.Handle > INVALID_DEVICE_HANDLE) and
               (MCSSourceHandle^.DCS.Main) then
            begin
              DCSOK := frmSEC.DCSEventThread.InputEvent(MCSSourceHandle, Event);
            end;
          end;
        end;
      end;
    end;
  end;

  Result := DCSOK;
end;

function TfrmChannel.DeleteEvent(AItem: PCueSheetItem): Integer;
var
  S, I, J: Integer;
  SourceGroup: PSourceGroup;
  Source: PSource;
  SourceHandles: TSourceHandleList;
  SourceHandle: PSourceHandle;

  MCSSource: PSource;
  MCSSourceHandles: TSourceHandleList;
  MCSSourceHandle: PSourceHandle;
begin
  Result := D_FALSE;

  if (not HasMainControl) then exit;

  if (AItem^.EventMode = EM_COMMENT) then exit;

  SourceGroup := GetSourceGroupByName(String(AItem^.Source));
  if (SourceGroup = nil) then exit;
  if (SourceGroup.Sources = nil) then exit;

  for S := 0 to SourceGroup.Sources.Count - 1 do
  begin
    Source := SourceGroup.Sources[S];
    if (Source = nil) then continue;

    SourceHandles := Source^.Handles;
    if (SourceHandles = nil) or (SourceHandles.Count <= 0) then continue;

    for I := 0 to SourceHandles.Count - 1 do
    begin
      SourceHandle := SourceHandles[I];
      if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
         (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
        Result := frmSEC.DCSEventThread.DeleteEvent(SourceHandle, AItem^.EventID);
    end;

    // Delete switcher & router event
    if (Source^.MakeTransition) then
    begin
      for I := 0 to GV_MCSList.Count - 1 do
      begin
        if (GV_MCSList[I]^.ChannelID <> FChannelID) then continue;

        MCSSource := GetSourceByName(String(GV_MCSList[I]^.Name));
        if (MCSSource = nil) then continue;

//        if (MCSSource^.Channel^.ID <> FChannelID) then continue;

        MCSSourceHandles := MCSSource^.Handles;
        if (MCSSourceHandles = nil) or (MCSSourceHandles.Count <= 0) then continue;

        for J := 0 to MCSSourceHandles.Count - 1 do
        begin
          MCSSourceHandle := MCSSourceHandles[J];
          if (MCSSourceHandle^.DCS <> nil) and (MCSSourceHandle^.DCS^.Alive) and
             (MCSSourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
            Result := frmSEC.DCSEventThread.DeleteEvent(MCSSourceHandle, AItem^.EventID);
        end;
      end;
    end;
  end;

  Result := D_OK;
end;

function TfrmChannel.ClearEvent: Integer;
var
  I, J: Integer;
  Source: PSource;
  SourceHandles: TSourceHandleList;
  SourceHandle: PSourceHandle;

  MCSSource: PSource;
  MCSSourceHandles: TSourceHandleList;
  MCSSourceHandle: PSourceHandle;
begin
  Result := D_FALSE;

  if (not HasMainControl) then exit;

  for I := 0 to GV_SourceList.Count - 1 do
  begin
    Source := GV_SourceList[I];

    if (Source^.Channel <> nil) and (Source^.Channel^.ID = FChannelID) then
    begin
      SourceHandles := Source^.Handles;
      if (SourceHandles = nil) or (SourceHandles.Count <= 0) then continue;

      for J := 0 to SourceHandles.Count - 1 do
      begin
        SourceHandle := SourceHandles[J];
        if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
           (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
          Result := frmSEC.DCSEventThread.ClearEvent(SourceHandle, FChannelID);
      end;
    end;
  end;

  // Clear switcher & router event
  if (Source^.MakeTransition) then
  begin
    for I := 0 to GV_MCSList.Count - 1 do
    begin
      if (GV_MCSList[I]^.ChannelID <> FChannelID) then continue;

      MCSSource := GetSourceByName(String(GV_MCSList[I]^.Name));
      if (MCSSource = nil) then continue;

//      if (MCSSource^.Channel^.ID <> FChannelID) then continue;

      MCSSourceHandles := MCSSource^.Handles;
      if (MCSSourceHandles = nil) or (MCSSourceHandles.Count <= 0) then continue;

      for J := 0 to MCSSourceHandles.Count - 1 do
      begin
        MCSSourceHandle := MCSSourceHandles[J];
        if (MCSSourceHandle^.DCS <> nil) and (MCSSourceHandle^.DCS^.Alive) and
           (MCSSourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
          Result := frmSEC.DCSEventThread.ClearEvent(MCSSourceHandle, FChannelID);
      end;
    end;
  end;
end;

function TfrmChannel.TakeEvent(AItem: PCueSheetItem): Integer;
var
  I, J: Integer;
  SourceGroup: PSourceGroup;
  Source: PSource;
  SourceHandles: TSourceHandleList;
  SourceHandle: PSourceHandle;
  Event: TEvent;
begin
  Result := D_FALSE;

  if (not HasMainControl) then exit;

  if (AItem^.EventMode <> EM_MAIN) {or (AItem^.StartMode <> SM_MANUAL) }then exit;

  SourceGroup := GetSourceGroupByName(String(AItem^.Source));
  if (SourceGroup = nil) then exit;
  if (SourceGroup.Sources = nil) then exit;

  if (SourceGroup.Sources.Count > 0) then
  begin
    // ���� ��񿡸� ����ũ ����� ����
    Source := SourceGroup.Sources[0];
    if (Source = nil) then exit;

    SourceHandles := Source^.Handles;
    if (SourceHandles = nil) or (SourceHandles.Count <= 0) then exit;

    for I := 0 to SourceHandles.Count - 1 do
    begin
      SourceHandle := SourceHandles[I];
      if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
         (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
        Result := frmSEC.DCSEventThread.TakeEvent(SourceHandle, AItem^.EventID, GV_SettingTimeParameter.StandardTimeCorrection);
    end;

  {  // Take switcher & router event
    if (Source^.MakeTransition) then
    begin
      for I := 0 to GV_MCSList.Count - 1 do
      begin
        Source := GetSourceByName(String(GV_MCSList[I]^.Name));
        if (Source = nil) then continue;

        if (Source^.Channel^.ID <> FChannelID) then continue;

        SourceHandles := Source^.Handles;
        if (SourceHandles = nil) or (SourceHandles.Count <= 0) then continue;

        for J := 0 to SourceHandles.Count - 1 do
        begin
          SourceHandle := SourceHandles[J];
          if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Opened) and
             (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
            Result := DCSTakeEvent(SourceHandle^.DCS^.ID, SourceHandle^.Handle, AItem^.EventID, GV_SettingTimeParameter.StandardTimeCorrection);
        end;
      end;
    end; }
  end;
end;

function TfrmChannel.HoldEvent(AItem: PCueSheetItem): Integer;
var
  S, I, J: Integer;
  SourceGroup: PSourceGroup;
  Source: PSource;
  SourceHandles: TSourceHandleList;
  SourceHandle: PSourceHandle;
  Event: TEvent;
begin
  Result := D_FALSE;

  if (not HasMainControl) then exit;

  if (AItem^.EventMode <> EM_MAIN) then exit;

  SourceGroup := GetSourceGroupByName(String(AItem^.Source));
  if (SourceGroup = nil) then exit;
  if (SourceGroup.Sources = nil) then exit;

  for S := 0 to SourceGroup.Sources.Count - 1 do
  begin
    Source := SourceGroup.Sources[S];
    if (Source = nil) then exit;

    SourceHandles := Source^.Handles;
    if (SourceHandles = nil) or (SourceHandles.Count <= 0) then exit;

    for I := 0 to SourceHandles.Count - 1 do
    begin
      SourceHandle := SourceHandles[I];
      if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
         (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
        Result := frmSEC.DCSEventThread.HoldEvent(SourceHandle, AItem^.EventID);
    end;

  {  // Hold switcher & router event
    if (Source^.MakeTransition) then
    begin
      for I := 0 to GV_MCSList.Count - 1 do
      begin
        Source := GetSourceByName(String(GV_MCSList[I]^.Name));
        if (Source = nil) then continue;

        if (Source^.Channel^.ID <> FChannelID) then continue;

        SourceHandles := Source^.Handles;
        if (SourceHandles = nil) or (SourceHandles.Count <= 0) then continue;

        for J := 0 to SourceHandles.Count - 1 do
        begin
          SourceHandle := SourceHandles[J];
          if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
             (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
            Result := frmSEC.DCSEventThread.HoldEvent(SourceHandle, AItem^.EventID);
        end;
      end;
    end; }
  end;
end;

function TfrmChannel.ChangeDurationEvent(AItem: PCueSheetItem; ADuration: TTimecode): Integer;
var
  I, J: Integer;
  SourceGroup: PSourceGroup;
  Source: PSource;
  SourceHandles: TSourceHandleList;
  SourceHandle: PSourceHandle;
  Event: TEvent;
begin
  Result := D_FALSE;

  if (not HasMainControl) then exit;

  if (AItem^.EventMode <> EM_MAIN) then exit;

  SourceGroup := GetSourceGroupByName(String(AItem^.Source));
  if (SourceGroup = nil) then exit;
  if (SourceGroup.Sources = nil) then exit;

  if (SourceGroup.Sources.Count > 0) then
  begin
    // ���� ��񿡸� ���� ���� ����� ����
    Source := SourceGroup.Sources[0];
    if (Source = nil) then exit;

    SourceHandles := Source^.Handles;
    if (SourceHandles = nil) or (SourceHandles.Count <= 0) then exit;

    for I := 0 to SourceHandles.Count - 1 do
    begin
      SourceHandle := SourceHandles[I];
      if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
         (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
        Result := frmSEC.DCSEventThread.ChangeDurationEvent(SourceHandle, AItem^.EventID, ADuration);
    end;

  {  // No needed, switcher & router has duration 0
    // Change duration switcher & router event
    if (Source^.MakeTransition) then
    begin
      for I := 0 to GV_MCSList.Count - 1 do
      begin
        Source := GetSourceByName(String(GV_MCSList[I]^.Name));
        if (Source = nil) then continue;

        if (Source^.Channel^.ID <> FChannelID) then continue;

        SourceHandles := Source^.Handles;
        if (SourceHandles = nil) or (SourceHandles.Count <= 0) then continue;

        for J := 0 to SourceHandles.Count - 1 do
        begin
          SourceHandle := SourceHandles[J];
          if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
             (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
            Result := frmSEC.DCSEventThread.ChangeDurationEvent(SourceHandle, AItem^.EventID, ADuration);
        end;
      end;
    end; }
  end;
end;

procedure TfrmChannel.StartOnAir;
var
  I, J: Integer;
  R: Integer;
  Source: PSource;
  SourceHandles: TSourceHandleList;
  SourceHandle: PSourceHandle;

  OnAirItem: PCueSheetItem;
  OnAirEventID: TEventID;     // DCS onair event id
  OnAirStartTime: TEventTime; // DCS onair event start time
  OnAirDurationTC: TTimecode; // DCS onair event duration tc

  OnNextItem: PCueSheetItem;
  OnNextEventID: TEventID;      // DCS cued event id
  OnNextStartTime: TEventTime;  // DCS cued event start time
  OnNextDurationTC: TTimecode;  // DCS cued event duration tc

  DCSIsOnAir: Boolean;        // DCS onair flag
  IsManualStart: Boolean;     // Manual start flag

  CurrItem, NextItem: PCueSheetItem;
  CurrIndex, NextIndex: Integer;
  SkipIndex: Integer;

  Item: PCueSheetItem;

  StartTime, ResetStartTime: TEventTime;
  DurationTC: TTimecode;
  EventStatus: TEventStatus;

  StartOnAirTime: TDateTime;

  ErrorString: String;
begin
  if (not HasMainControl) then exit;

  acgPlaylist.HideInplaceEdit;

  // Check the aleady onair
//  if (GetChannelOnAirByID(FChannelID)) then
  if (FChannelOnAir) then
  begin
    ErrorString := Format(SChannelAlreadyRunning, [GetChannelNameByID(FChannelID)]);
    MessageBeep(MB_ICONWARNING);
    MessageBox(Handle, PChar(ErrorString), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
    exit;
  end;

  if (FCueSheetList = nil) then exit;
  if (FCueSheetList.Count <= 0) then
  begin
    ServerBeginUpdates(ChannelID);
    try
      SetChannelOnAir(True);
    finally
      ServerEndUpdates(ChannelID);
    end;
    exit;
  end;

  // Source channel check
  DCSIsOnAir := False;
  for I := 0 to GV_SourceList.Count - 1 do
  begin
    Source := GV_SourceList[I];
    if (Source <> nil) and
       (Source^.SourceType in [ST_VSDEC, ST_VCR, ST_CG, ST_LINE]) and
       (Source^.Channel <> nil) and (Source^.Channel^.ID = FChannelID) and
       (Source^.Handles <> nil) then
    begin
      SourceHandles := Source^.Handles;

      for J := 0 to SourceHandles.Count - 1 do
      begin
        SourceHandle := SourceHandles[J];
        if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
           (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
        begin
          R := frmSEC.DCSEventThread.GetOnAirEventID(SourceHandle, OnAirEventID, OnNextEventID);
          if (R = D_OK) then
          begin
            OnAirItem  := GetCueSheetItemByID(OnAirEventID);
            OnNextItem := GetCueSheetItemByID(OnNextEventID);

            if (OnAirItem <> nil) then
            begin
  //            R := DCSGetEventInfo(Source^.Handles[J]^.DCSID, Source^.Handles[J]^.Handle, OnAirEventID, OnAirStartTime, OnAirDurationTC);
              R := frmSEC.DCSEventThread.GetEventInfo(SourceHandle, OnAirEventID, OnAirStartTime, OnAirDurationTC);
              if (R = D_OK) then
              begin

              end;
            end;

            if (OnNextItem <> nil) then
            begin
  //            R := DCSGetEventInfo(Source^.Handles[J]^.DCSID, Source^.Handles[J]^.Handle, OnNextItem^.EventID, OnNextStartTime, OnNextDurationTC);
              R := frmSEC.DCSEventThread.GetEventInfo(SourceHandle, OnNextItem^.EventID, OnNextStartTime, OnNextDurationTC);
              if (R = D_OK) then
              begin

              end;
            end;

            if ((OnAirItem <> nil) and (OnAirItem^.EventMode = EM_MAIN)) or
               ((OnNextItem <> nil) and (OnNextItem^.EventMode = EM_MAIN)) then
            begin
              DCSIsOnAir := True;
              break;
            end;
          end;
  //        else
  //          ShowMessage('not on air');
        end;
      end;

      if (DCSIsOnAir) then break;
    end;
  end;
  FLastInputIndex := -1;

  IsManualStart := True;
  // If DCS is onair then select start onair type
  if (DCSIsOnAir) then
  begin
    CurrItem  := GetCueSheetItemByID(OnAirEventID);
    CurrItem  := GetParentCueSheetItemByItem(CurrItem);
    CurrIndex := GetCueSheetIndexByItem(CurrItem);

    NextItem  := GetCueSheetItemByID(OnNextEventID);
    NextItem  := GetParentCueSheetItemByItem(NextItem);
    NextIndex := GetCueSheetIndexByItem(NextItem);

    frmSelectStartOnAir := TfrmSelectStartOnAir.Create(Self, CurrItem, NextItem);
    try
      frmSelectStartOnAir.ShowModal;
      if (frmSelectStartOnAir.ModalResult = mrOk) then
      begin
        case frmSelectStartOnAir.SelectOnAirStart of
          SO_CURRENT:
          begin
            IsManualStart := False;
          end;
          SO_FIRST:
          begin
            IsManualStart := True;
          end;
        end;
      end
      else
        exit;
    finally
      FreeAndNil(frmSelectStartOnAir);
    end;
  end;

  Screen.Cursor := crHourGlass;
  try
    if (IsManualStart) then
    begin
      // Manual start check
      CurrIndex := GetStartOnAirMainIndex;
      CurrItem  := GetCueSheetItemByIndex(CurrIndex);
      if (CurrItem <> nil) then
      begin
        StartOnAirTime := IncMilliSecond(EventTimeToDateTime(CurrItem^.StartTime, ChannelFrameRateType), TimecodeToMilliSec(GV_SettingThresholdTime.OnAirLockTime, FR_30));

        if (StartOnAirTime <= Now) then
        begin
          MessageBeep(MB_ICONQUESTION);
          R := MessageBox(Handle, Pchar(SQStartOnAirByManual), PChar(Application.Title), MB_YESNOCANCEL or MB_ICONQUESTION or MB_TOPMOST);
          if (R = IDYES) then
          begin
            ServerBeginUpdates(ChannelID);
            try
              ServerClearCueSheets(ChannelID);
              SetChannelOnAir(True);

              StartTime := CurrItem^.StartTime;

              ResetStartTime := GetPlusEventTime(DateTimeToEventTime(Now, ChannelFrameRateType), TimecodeToEventTime(GV_SettingTimeParameter.AutoIncreaseDurationAmount), ChannelFrameRateType);

              CurrItem^.StartMode := SM_MANUAL;
{//              CurrItem^.StartTime := GetPlusEventTime(DateTimeToEventTime(Now), TimecodeToEventTime(GV_SettingTimeParameter.AutoIncreaseDurationAmount));
              // Change only date
              CurrItem^.StartTime.D := ResetStartTime.D;


     //          SetSkipCueSheetItemByIndex(0, CurrIndex - 1);

//              FTimelineStartDate := CurrItem^.StartTime.D;

//              CalcuratePlayListTimeLineRange(GetDurEventTime(StartTime, CurrItem^.StartTime));
              CalcuratePlayListTimeLineRange(GetDurEventTime(StartTime, ResetStartTime));
              UpdatePlayListTimeLineRange;

              ResetStartTimeByTime(CurrIndex, StartTime);

              // Change only time
              StartTime := CurrItem^.StartTime;
              CurrItem^.StartTime.T := ResetStartTime.T;  }

              CurrItem^.StartTime := ResetStartTime;
              ResetStartTimeByTime(CurrIndex, StartTime);

              OnAirClearEvents;

              OnAirInputEvents(CurrIndex, GV_SettingOption.MaxInputEventCount);
    //          FEventContolThread.InputEvent(CurrIndex, GV_SettingOption.MaxInputEventCount);

    //          FLastDisplayNo := GetBeforeMainCountByIndex(CurrIndex);
    //          DisplayPlayListGrid(CurrIndex);

    //          FTimeLineMin := 0;
    //          FTimeLineMax := 0;
//              DisplayPlayListTimeLine(CurrIndex);

              ServerInputCueSheets(ChannelID, 0);

              CueSheetNext := CurrItem;

              CheckCueSheetLoop(CueSheetNext);
            finally
              ServerEndUpdates(ChannelID);
            end;
          end
          else if (R = IDNO) then
          begin
            ServerBeginUpdates(ChannelID);
            try
              ServerClearCueSheets(ChannelID);
              SetChannelOnAir(True);

    {          if (FCueSheetNext <> nil) then
                NextItem := FCueSheetNext
              else }
                NextItem := GetMainItemByStartTime(CurrIndex, IncMilliSecond(Now, TimecodeToMilliSec(GV_SettingThresholdTime.OnAirLockTime, FR_30)));

              if (NextItem <> nil) then
              begin
                NextIndex := GetCueSheetIndexByItem(NextItem);
              end
              else
                NextIndex := FLastCount;// FCueSheetList.Count - 1;
        //      SetOnAirEvent;

              SetCueSheetItemStatusByIndex(CurrIndex, NextIndex - 1, esSkipped);

//              FTimelineStartDate := CurrItem^.StartTime.D;



    //          ResetStartTime(CurrIndex);

              OnAirClearEvents;

              OnAirInputEvents(NextIndex, GV_SettingOption.MaxInputEventCount);

    //          FLastDisplayNo := GetBeforeMainCountByIndex(CurrIndex);
    //          DisplayPlayListGrid(CurrIndex);

    //          FTimeLineMin := 0;
    //          FTimeLineMax := 0;

//              DisplayPlayListTimeLine(CurrIndex);

              ServerInputCueSheets(ChannelID, 0);

              CueSheetNext := NextItem;

              CheckCueSheetLoop(CueSheetNext);
            finally
              ServerEndUpdates(ChannelID);
            end;
          end
          else if (R = IDCANCEL) then
            exit;
        end
        else
        begin
          ServerBeginUpdates(ChannelID);
          try
            ServerClearCueSheets(ChannelID);
            SetChannelOnAir(True);

            NextItem := GetMainItemByStartTime(CurrIndex, IncMilliSecond(Now, TimecodeToMilliSec(GV_SettingThresholdTime.OnAirLockTime, FR_30)));
            if (NextItem <> nil) then
            begin
              NextIndex := GetCueSheetIndexByItem(NextItem);
            end
            else
              NextIndex := FLastCount;// FCueSheetList.Count - 1;

            SetCueSheetItemStatusByIndex(CurrIndex, NextIndex - 1, esSkipped);

//            FTimelineStartDate := CurrItem^.StartTime.D;

            OnAirClearEvents;

            OnAirInputEvents(NextIndex, GV_SettingOption.MaxInputEventCount);

    //        FLastDisplayNo := GetBeforeMainCountByIndex(NextIndex);
    //        DisplayPlayListGrid(NextIndex);

    //        FTimeLineMin := 0;
    //        FTimeLineMax := 0;

//            DisplayPlayListTimeLine(NextIndex);

    {        OnAirClearEvents;
            OnAirInputEvents(CurrIndex, GV_SettingOption.MaxInputEventCount);

            FLastDisplayNo := GetBeforeMainCountByIndex(CurrIndex);
            DisplayPlayListGrid(CurrIndex);

            FCueSheetNext := CurrItem;
            acgPlaylist.Repaint; }

            ServerInputCueSheets(ChannelID, 0);

            CueSheetNext := NextItem;

            CheckCueSheetLoop(CueSheetNext);
          finally
            ServerEndUpdates(ChannelID);
          end;
        end;

  //      Sleep(1000);
        FInspectThread.Inspect;
        FMediaCheckThread.MediaCheck;
//  frmSEC.DCSMediaThread.MediaCheck;

        acgPlayList.Repaint;

  //      FTimerThread := TChannelTimerThread.Create(Self);
  //      FTimerThread.Resume;
      end;
    end
    else
    begin
      if (OnAirItem <> nil) or (OnNextItem <> nil) then
      begin
        // Check onair event is changed
        for I := 0 to GV_SourceList.Count - 1 do
        begin
          Source := GV_SourceList[I];
          if (Source <> nil) and
             (Source^.SourceType in [ST_VSDEC, ST_VCR, ST_CG, ST_LINE]) and
             (Source^.Channel <> nil) and (Source^.Channel^.ID = FChannelID) and
             (Source^.Handles <> nil) then
          begin
            SourceHandles := Source^.Handles;
            for J := 0 to SourceHandles.Count - 1 do
            begin
              SourceHandle := SourceHandles[J];
              if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
                 (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
              begin
                R := frmSEC.DCSEventThread.GetOnAirEventID(SourceHandle, OnAirEventID, OnNextEventID);
                if (R = D_OK) then
                begin
                  OnAirItem  := GetCueSheetItemByID(OnAirEventID);
                  OnNextItem := GetCueSheetItemByID(OnNextEventID);
                  break;
                end;
              end;
            end;
          end;
          if (R = D_OK) then
            break;
        end;

        if (OnAirItem <> CurrItem) or (OnNextItem <> NextItem) then
        begin
          MessageBeep(MB_ICONERROR);
          MessageBox(Handle, PChar(SEChangedOnAirEvent), PChar(Application.Title), MB_OK or MB_ICONERROR or MB_TOPMOST);
          exit;
        end;

        ServerBeginUpdates(ChannelID);
        try
          ServerClearCueSheets(ChannelID);
          SetChannelOnAir(True);

          if (CurrItem <> nil) then
          begin
            StartTime := CurrItem^.StartTime;
            CurrItem^.StartTime   := OnAirStartTime;
            CurrItem^.DurationTC  := OnAirDurationTC;
    //        CurrItem^.EventStatus.State := esOnAir;
          end
          else if (NextItem <> nil) then
          begin
            StartTime := NextItem^.StartTime;
            NextItem^.StartTime   := OnNextStartTime;
            NextItem^.DurationTC  := OnNextDurationTC;
    //        NextItem^.EventStatus.State := esCued;
          end;

    //      ShowMessage(EventTimeToDateTimecodeStr(CurrItem^.StartTime));

    {      if (CurrItem <> nil) then
          begin
            for I := CurrIndex to FCueSheetList.Count - 1 do
            begin
              Item := GetCueSheetItemByIndex(I);
              if (Item <> nil) and (Item^.GroupNo = CurrItem^.GroupNo) then
              begin
                Source := GetSourceByName(String(Item^.Source));
                if (Source <> nil) and (Source^.Handles <> nil) then
                begin
                  for J := 0 to Source^.Handles.Count - 1 do
                  begin
                    R := DCSGetEventInfo(Source^.Handles[J]^.DCSID, Source^.Handles[J]^.Handle, Item^.EventID, StartTime, DurationTC);
                    if (R = D_OK) then
                    begin
                      Item^.StartTime  := StartTime;
                      Item^.DurationTC := DurationTC;
                    end;

                    R := DCSGetEventStatus(Source^.Handles[J]^.DCSID, Source^.Handles[J]^.Handle, Item^.EventID, EventStatus);
                    if (R = D_OK) then
                    begin
                      Item^.EventStatus.State := EventStatus;
                      break;
                    end;
                  end;
                end;
              end
              else
                break;
            end;
          end;

          if (NextItem <> nil) then
          begin
            for I := NextIndex to FCueSheetList.Count - 1 do
            begin
              Item := GetCueSheetItemByIndex(I);
              if (Item <> nil) and (Item^.GroupNo = NextItem^.GroupNo) then
              begin
                Source := GetSourceByName(String(Item^.Source));
                if (Source <> nil) and (Source^.Handles <> nil) then
                begin
                  for J := 0 to Source^.Handles.Count - 1 do
                  begin
                    R := DCSGetEventInfo(Source^.Handles[J]^.DCSID, Source^.Handles[J]^.Handle, Item^.EventID, StartTime, DurationTC);
                    if (R = D_OK) then
                    begin
                      Item^.StartTime  := StartTime;
                      Item^.DurationTC := DurationTC;
                    end;

                    R := DCSGetEventStatus(Source^.Handles[J]^.DCSID, Source^.Handles[J]^.Handle, Item^.EventID, EventStatus);
                    if (R = D_OK) then
                    begin
                      Item^.EventStatus.State := EventStatus;
                      break;
                    end;
                  end;
                end;
              end
              else
                break;
            end;
          end; }

    {      for I := SkipIndex to SkipIndex + GV_SettingOption.MaxInputEventCount do
          begin
            CurrItem := GetCueSheetItemByIndex(I);
            if (CurrItem <> nil) then
            begin
              Source := GetSourceByName(String(CurrItem^.Source));
              if (Source <> nil) and (Source^.Handles <> nil) then
              begin
                for J := 0 to Source^.Handles.Count - 1 do
                begin
                  R := DCSGetEventInfo(Source^.Handles[J]^.DCSID, Source^.Handles[J]^.Handle, CurrItem^.EventID, StartTime, DurationTC);
                  if (R = D_OK) then
                  begin
                    CurrItem^.StartTime  := StartTime;
                    CurrItem^.DurationTC := DurationTC;
                  end;

                  R := DCSGetEventStatus(Source^.Handles[J]^.DCSID, Source^.Handles[J]^.Handle, CurrItem^.EventID, EventStatus);
                  if (R = D_OK) then
                  begin
                    CurrItem^.EventStatus.State := EventStatus;
                    break;
                  end;
                end;
              end;
            end
            else
              break;
          end;  }

          if (CurrItem <> nil) then
          begin
    //        StartTime := CurrItem.StartTime;
            SkipIndex := CurrIndex;
            SetCueSheetItemStatusByIndex(GetStartOnAirMainIndex, SkipIndex - 1, esSkipped);
            ResetStartTimeByTime(SkipIndex, StartTime);
          end
          else if (NextItem <> nil) then
          begin
    //        StartTime := NextItem.StartTime;
            SkipIndex := NextIndex;
            SetCueSheetItemStatusByIndex(GetStartOnAirMainIndex, SkipIndex - 1, esSkipped);
            ResetStartTimeByTime(SkipIndex, StartTime);
          end
          else exit;

          OnAirInputEvents(SkipIndex, GV_SettingOption.MaxInputEventCount);

    {      for I := SkipIndex to SkipIndex + GV_SettingOption.MaxInputEventCount do
          begin
            CurrItem := GetCueSheetItemByIndex(I);
            if (CurrItem <> nil) then
            begin
              Source := GetSourceByName(String(CurrItem^.Source));
              if (Source <> nil) and (Source^.Handles <> nil) then
              begin
                for J := 0 to Source^.Handles.Count - 1 do
                begin
                  R := DCSGetEventInfo(Source^.Handles[J]^.DCSID, Source^.Handles[J]^.Handle, CurrItem^.EventID, StartTime, DurationTC);
                  if (R = D_OK) then
                  begin
                    CurrItem^.StartTime  := StartTime;
                    CurrItem^.DurationTC := DurationTC;
                  end;

                  R := DCSGetEventStatus(Source^.Handles[J]^.DCSID, Source^.Handles[J]^.Handle, CurrItem^.EventID, EventStatus);
                  if (R = D_OK) then
                  begin
                    CurrItem^.EventStatus.State := EventStatus;
                    break;
                  end;
                end;
              end;
            end
            else
              break;
          end;  }

{          if (CurrItem <> nil) then
            FTimelineStartDate := CurrItem^.StartTime.D
          else if (NextItem <> nil) then
            FTimelineStartDate := NextItem^.StartTime.D; }

    //      FLastDisplayNo := GetBeforeMainCountByIndex(SkipIndex);
    //      DisplayPlayListGrid(SkipIndex);

    //      FTimeLineMin := 0;
    //      FTimeLineMax := 0;

//          DisplayPlayListTimeLine(SkipIndex);

    //      CueSheetCurr := OnAirItem;
    //      CueSheetNext := OnNextItem;

    //      FTimerThread := TChannelTimerThread.Create(Self);
    //      FTimerThread.Resume;

          ServerInputCueSheets(ChannelID, 0);

          CueSheetCurr := OnAirItem;
          CueSheetNext := OnNextItem;

          CheckCueSheetLoop(CueSheetCurr);
        finally
          ServerEndUpdates(ChannelID);
        end;

        FInspectThread.Inspect;
        FMediaCheckThread.MediaCheck;
//  frmSEC.DCSMediaThread.MediaCheck;

        acgPlayList.Repaint;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;

{  exit;

  Start := DateTimeToEventTime(IncSecond(Now, 20));
  ShowMessage(EventTimeToDateTimecodeStr(Start, True));

  P := GetCueSheetItemByIndex(1);
  DurEventTime := GetDurEventTime(P^.StartTime, Start);

//  ShowMessage(EventTimeToDateTimecodeStr(P^.StartTime, True));
  ShowMessage(EventTimeToDateTimecodeStr(DurEventTime, True));

//  DurEventTime := GetDurEventTime(P^.StartTime, Start);
//  if (P^.StartTime.T < Start.T) then
    ResetStartTimePlus(0, DurEventTime);
//  else
//    ResetStartTimeMinus(0, DurEventTime);

  for I := 0 to FChannelCueSheet.CueSheetList.Count - 1 do
  begin
    InputEvent(FChannelCueSheet.CueSheetList[I]);
  end;

  FTimerThread := TChannelTimerThread.Create(Self);
  FTimerThread.Resume; }
end;

procedure TfrmChannel.FreezeOnAir;
var
  NextStartTime: TDateTime;
  NextIndex: Integer;

  CurrIndex: Integer;

  I: Integer;
begin
  if (not HasMainControl) then exit;

  if (not FChannelOnAir) then exit;

  if (CueSheetCurr <> nil) and (CueSheetNext <> nil) then
  begin
    NextStartTime := EventTimeToDateTime(CueSheetNext^.StartTime, ChannelFrameRateType);
    if (DateTimeToTimecode(NextStartTime - Now, FR_30) <= GV_SettingThresholdTime.HoldLockTime) then
    begin
      MessageBeep(MB_ICONWARNING);
      MessageBox(Handle, PChar(SFreezeOnAirTimeout), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
      exit;
    end;

    CueSheetNext^.StartMode := SM_MANUAL;
    NextIndex := GetCueSheetIndexByItem(CueSheetNext);
    PostMessage(Handle, WM_UPDATE_EVENT_STATUS, NextIndex, NativeInt(CueSheetNext));
    ServerSetEventStatuses(CueSheetNext^.EventID, CueSheetNext^.EventStatus);

//    OnAirInputEvents(NextIndex, 1);

//    CurrIndex := GetCueSheetIndexByItem(CueSheetCurr);
    OnAirHoldEvent(NextIndex);

    ServerBeginUpdates(ChannelID);
    try
      ServerInputCueSheets(NextIndex, CueSheetNext);
    finally
      ServerEndUpdates(ChannelID);
    end;
  end;

{  if (not FChannelOnAir) then exit;

  if (CueSheetNext <> nil) then
  begin
    NextStartTime := EventTimeToDateTime(CueSheetNext^.StartTime);
    if (DateTimeToTimecode(NextStartTime - Now) <= GV_SettingTresholdTime.HoldLockTime) then
    begin
      MessageBeep(MB_ICONWARNING);
      MessageBox(Handle, PChar(SFreezeOnAirTimeout), PChar(Application.Title), MB_OK or MB_ICONWARNING);
      exit;
    end;

    CueSheetNext^.StartMode := SM_MANUAL;
    NextIndex := GetCueSheetIndexByItem(CueSheetNext);

//    acgPlaylist.AllCells[IDX_COL_CUESHEET_START_MODE, NextIndex + CNT_CUESHEET_HEADER] := StartModeNames[CueSheetNext^.StartMode];

    OnAirInputEvents(NextIndex, 1);

    if (CueSheetCurr <> nil) then
    begin
      CurrIndex := GetCueSheetIndexByItem(CueSheetCurr);
      OnAirHoldEvent(CurrIndex);
    end;

    ServerBeginUpdates(ChannelID);
    try
      ServerInputCueSheets(NextIndex, CueSheetNext);
    finally
      ServerEndUpdates(ChannelID);
    end;
  end; }
end;

procedure TfrmChannel.FinishOnAir;
var
  R: Integer;
  IsFinish: Boolean;
  StartIndex, EndIndex: Integer;
begin
  if (not HasMainControl) then exit;

  if (not FChannelOnAir) then exit;

  StartIndex := -1;
  if (CueSheetCurr <> nil) then
    StartIndex := GetCueSheetIndexByItem(CueSheetCurr)
  else if (CueSheetNext <> nil) then
    StartIndex := GetCueSheetIndexByItem(CueSheetNext);

  IsFinish := False;
  MessageBeep(MB_ICONQUESTION);
  R := MessageBox(Handle, Pchar(SQFinishtOnAirAndPreserveEvent), PChar(Application.Title), MB_YESNOCANCEL or MB_ICONQUESTION or MB_TOPMOST);
  if (R = IDYES) then
  begin
    IsFinish := True;
  end
  else if (R = IDNO) then
  begin
    MessageBeep(MB_ICONQUESTION);
    R := MessageBox(Handle, Pchar(SQFinishtOnAirAndClearEvent), PChar(Application.Title), MB_YESNO or MB_ICONQUESTION or MB_TOPMOST);
    if (R = IDYES) then
    begin
      OnAirClearEvents;

      IsFinish := True;
    end
    else exit;
  end
  else if (R = IDCANCEL) then
    exit;

  if (IsFinish) then
  begin
{    if (StartIndex >= 0) then
    begin
      EndIndex := StartIndex + GV_SettingOption.MaxInputEventCount;
      if (EndIndex >= FCueSheetList.Count) then
        EndIndex := FCueSheetList.Count - 1;

      SetCueSheetItemStatusByIndex(StartIndex, EndIndex, esIdle);
    end; }

    ClearCueSheetLoopItems;

    FCueSheetCurr   := nil;
    FCueSheetNext   := nil;
    FCueSheetTarget := nil;

    acgPlayList.Repaint;

    ServerBeginUpdates(ChannelID);
    try
      ServerClearCueSheets(ChannelID);

{    if (FTimerThread <> nil) then
    begin
      FTimerThread.Terminate;
      FTimerThread.WaitFor;
      FreeAndNil(FTimerThread);
    end; }

      SetChannelOnAir(False);
    finally
      ServerEndUpdates(ChannelID);
    end;
  end;
end;

// ������ ����ġ�� Taking���� �Ӻ�, ������� GPI ��ȣ�� ���� ��� ���� �̺�Ʈ�� �и��ϰ� ���� �̺�Ʈ�� ����
procedure TfrmChannel.BreakOnAir;
var
  CurrItem: PCueSheetItem;
  CurrIndex: Integer;
  ChannelCueSheet: PChannelCueSheet;

  CurrTimeT, CurrEndTimeT: TDateTime;
  CurrTimeE, CurrEndTimeE: TEventTime;

  CopyCueSheetList: TCueSheetList;

  NewCurrItem, NewSubItem: PCueSheetItem;

  Item: PCueSheetItem;

  SubEndTimeE: TEventTime;
  SubStartTimeE: TEventTime;

  DurTimeE: TEventTime;
  SaveDurationTC: TTimecode;
  CurrDurationTC: TTimecode;
  RemainTC: TTimecode;
  OutTC: TTimecode;
  AddItem: PCueSheetItem;








  ChildCount: Integer;
  InsetIndex: Integer;

  Source: PSource;
  SourceHandles: TSourceHandleList;
  SourceHandle: PSourceHandle;

  I: Integer;
  R: Integer;


  NextIndex: Integer;
  NextItem: PCueSheetItem;


  SaveStartTime: TEventTime;

//  OnAirIndex: Integer;
//  OnAirItem: PCueSheetItem;
//  OnAirEventID: TEventID;     // DCS onair event id
//  OnAirStartTime: TEventTime; // DCS onair event start time
//  OnAirDurationTC: TTimecode; // DCS onair event duration tc
begin
  if (not HasMainControl) then exit;

  // ���� �̺�Ʈ�� ����
  // Breaking �̺�Ʈ�� ����
  // ���� �̺�Ʈ

  if (not FChannelOnAir) then exit;

//  CueSheetCurr := GetSelectCueSheetItem;
  CurrItem := CueSheetCurr;

  if (CurrItem = nil) then exit;
  if (CurrItem^.EventMode <> EM_MAIN) then exit;

  CurrTimeT := {EncodeDateTime(2024, 10, 11, 15, 39, 30, 0);// }Now;
  CurrTimeE := DateTimeToEventTime(CurrTimeT, ChannelFrameRateType);

  if (CurrItem <> nil) then
  begin
    // ���� �̺�Ʈ�� EndTime�� LockTime���� ������ �Ұ�
    CurrEndTimeE := GetEventEndTime(CurrItem^.StartTime, CurrItem^.DurationTC, ChannelFrameRateType);
    CurrEndTimeT := EventTimeToDateTime(CurrEndTimeE, ChannelFrameRateType);
    if (DateTimeToTimecode(CurrEndTimeT - CurrTimeT, FR_30) <= GV_SettingThresholdTime.BreakLockTime) then
    begin
      MessageBeep(MB_ICONWARNING);
      MessageBox(Handle, PChar(SBreakCurrentTimeout), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
      exit;
    end;

    // ���� �̺�Ʈ Index
    CurrIndex := GetCueSheetIndexByItem(CurrItem);

    // ���� �̺�Ʈ ť��Ʈ ����
    ChannelCueSheet := GetChannelCueSheetByIndex(CurrIndex);
    if (ChannelCueSheet = nil) then
    begin
      if (FChannelCueSheetList.Count > 0) then
        ChannelCueSheet := FChannelCueSheetList[FChannelCueSheetList.Count - 1]
      else
        exit;
    end;

    // ���� ������ �̺�Ʈ�� �׷� ����
    CopyCueSheetList := TCueSheetList.Create;
    try
{
      // ���� Event �߰�
      for I := CurrIndex + 1 to FCueSheetList.Count - 1 do
      begin
        Item := GetCueSheetItemByIndex(I);
        if (Item <> nil) and (CurrItem^.GroupNo = Item^.GroupNo) and
//           (Item^.EventStatus.State >= esFinish) and
           (CopyCueSheetList.IndexOf(Item) < 0) then
        begin
          CopyItem := New(PCueSheetItem);
          Move(Item^, CopyItem^, SizeOf(TCueSheetItem));
          CopyCueSheetList.Add(CopyItem);
        end
        else
          break;
      end; }

      // Event �Ӽ� ����
      // ���� �̺�Ʈ�� �Ӽ� ����
      // Finish Action�� FA_STOP���� ����
    acgPlaylist.BeginUpdate;
    try
      FCueSheetLock.Enter;
      try
        CurrItem^.FinishAction := FA_STOP;

        // ���� �ð����� ���� �̺�Ʈ�� ���۽ð��� ���� BreakCurrentAddTime�� ���� �̺�Ʈ ���� �� ����
        // DurationTC ����
        DurTimeE := GetDurEventTime(CurrTimeE, CurrItem^.StartTime, ChannelFrameRateType);
        CurrDurationTC := GetPlusTimecode(DurTimeE.T, BreakAddTime, ChannelFrameRateType);
        OutTC := GetPlusTimecode(CurrItem^.InTC, CurrDurationTC, ChannelFrameRateType);

        // ���� ���� ����
        RemainTC := GetDurTimecode(CurrItem^.DurationTC, CurrDurationTC, ChannelFrameRateType);

        SaveDurationTC := CurrItem^.DurationTC;
        CurrItem^.DurationTC := CurrDurationTC;
        CurrItem^.OutTC := GetPlusTimecode(CurrItem^.InTC, CurrItem^.DurationTC, ChannelFrameRateType);

        CurrEndTimeE := GetEventEndTime(CurrItem^.StartTime, CurrItem^.DurationTC, ChannelFrameRateType);

        InsetIndex := CurrIndex + 1;

        // ���� Event �߰�
        NewCurrItem := New(PCueSheetItem);
        Move(CurrItem^, NewCurrItem^, SizeOf(TCueSheetItem));
        FillChar(NewCurrItem^.EventStatus, SizeOf(TEventStatus), #0);
        NewCurrItem^.StartMode := SM_MANUAL;
        NewCurrItem^.StartTime := CurrEndTimeE;
        NewCurrItem^.DurationTC := RemainTC;
        NewCurrItem^.OutTC := GetPlusTimecode(NewCurrItem^.InTC, NewCurrItem^.DurationTC, ChannelFrameRateType);

        StrCat(CurrItem^.Title, ' - 1');
        StrCat(NewCurrItem^.Title, ' - 2');

        // Sub Event ����
        ChildCount := 0;
        for I := CurrIndex + 1 to FCueSheetList.Count - 1 do
        begin
          Item := GetCueSheetItemByIndex(I);
          if (Item <> nil) and (Item^.GroupNo = CurrItem^.GroupNo) then
          begin
            if (Item^.StartMode = SM_SUBBEGIN) then
            begin
              SubStartTimeE := GetEventTimeSubBegin(CurrItem^.StartTime, Item^.StartTime.T, ChannelFrameRateType);
            end
            else
            begin
              SubStartTimeE := GetEventTimeSubEnd(CurrItem^.StartTime, SaveDurationTC, Item^.StartTime.T, ChannelFrameRateType);
            end;

            if (CompareEventTime(SubStartTimeE, CurrEndTimeE, ChannelFrameRateType) > 0) then
            begin
              NewSubItem := New(PCueSheetItem);
              Move(Item^, NewSubItem^, SizeOf(TCueSheetItem));
              FillChar(NewSubItem^.EventStatus, SizeOf(TEventStatus), #0);
              NewSubItem^.StartTime := CurrEndTimeE;
              NewSubItem^.StartTime.T := Item^.StartTime.T;

              if (Item^.StartMode = SM_SUBBEGIN) then
                NewSubItem^.StartTime.T := GetMinusTimecode(Item^.StartTime.T, CurrDurationTC, ChannelFrameRateType);

              CopyCueSheetList.Add(NewSubItem);
            end
            else
            begin
            end;


{            // �����̺�Ʈ�� ���� ���̸� ���Ͽ� ����
            DurTimeE := GetDurEventTime(SubStartTimeE, CurrEndTimeE, ChannelFrameRateType);
            RemainTC := GetDurTimecode(Item^.DurationTC, DurTimeE.T, ChannelFrameRateType);
            Item^.DurationTC := GetMinusTimecode(Item^.DurationTC, RemainTC, ChannelFrameRateType);

            Item^.FinishAction := FA_STOP; }

            if (Item^.EventStatus.State < esFinish) then
            begin
              if (FChannelOnAir) then
                OnAirDeleteEvents(I, 1);

              Item^.EventStatus.State := esSkipped;
              Item^.EventStatus.ErrorCode := NO_ERROR;

              SetEventStatus(Item^.EventID, Item^.EventStatus);

//              DeletePlayListTimeLineByItem(Item);
            end;

            Inc(ChildCount);
          end
          else
            break;
        end;

        InsetIndex := InsetIndex + ChildCount;


        // �̺�Ʈ ����
        // ������ ������ ���� �� �ҽ� �̺�Ʈ �߰�
        AddItem := New(PCueSheetItem);
        FillChar(AddItem^, SizeOf(TCueSheetItem), #0);

        ChannelCueSheet^.LastSerialNo := ChannelCueSheet^.LastSerialNo + 1;

        AddItem^.EventID.ChannelID := FChannelID;
        StrCopy(AddItem^.EventID.OnAirDate, ChannelCueSheet^.OnairDate);
        AddItem^.EventID.OnAirFlag := ChannelCueSheet^.OnairFlag;
        AddItem^.EventID.OnAirNo   := ChannelCueSheet^.OnairNo;
        AddItem^.EventID.SerialNo  := ChannelCueSheet^.LastSerialNo;

        AddItem^.EventMode := EM_MAIN;
        AddItem^.StartMode := SM_AUTOFOLLOW;
        AddItem^.StartTime := CurrEndTimeE;
        AddItem^.DurationTC := BreakEventDurationTime;
        AddItem^.OutTC := FrameToTimeCode(TimecodeToFrame(AddItem^.DurationTC, ChannelFrameRateType) - 1, ChannelFrameRateType);
        StrPCopy(AddItem^.Source, BreakEventSource);
        StrPCopy(AddItem^.Title, BreakEventTitle);

        AddItem^.Input := BreakEventInput;

        if (AddItem^.Input in [IT_MAIN, IT_BACKUP]) then
        begin
          AddItem^.Output := Byte(BreakEventOutputBkgnd);
        end
        else
        begin
          AddItem^.Output := Byte(BreakEventOutputKeyer);
        end;

        Inc(ChannelCueSheet^.LastProgramNo);
        AddItem^.ProgramNo := ChannelCueSheet^.LastProgramNo;

        Inc(ChannelCueSheet^.LastGroupNo);
        AddItem^.GroupNo := ChannelCueSheet^.LastGroupNo;

        FCueSheetList.Insert(InsetIndex, AddItem);

        InsertPlayListGridMain(InsetIndex);
        Inc(ChannelCueSheet^.EventCount);

        InsetIndex := InsetIndex + 1;

        ChannelCueSheet^.LastSerialNo := ChannelCueSheet^.LastSerialNo + 1;
        NewCurrItem^.EventID.SerialNo  := ChannelCueSheet^.LastSerialNo;

        Inc(ChannelCueSheet^.LastProgramNo);
        NewCurrItem^.ProgramNo := ChannelCueSheet^.LastProgramNo;

        Inc(ChannelCueSheet^.LastGroupNo);
        NewCurrItem^.GroupNo := ChannelCueSheet^.LastGroupNo;

        FCueSheetList.Insert(InsetIndex, NewCurrItem);

        InsertPlayListGridMain(InsetIndex);
        Inc(ChannelCueSheet^.EventCount);

        InsetIndex := InsetIndex + 1;

        // Sub �̺�Ʈ �߰�
        for I := 0 to CopyCueSheetList.Count - 1 do
        begin
//          Item := CopyCueSheetList[i];

//          NewSubItem := New(PCueSheetItem);
//          FillChar(NewSubItem^, SizeOf(TCueSheetItem), #0);
//          Move(Item^, NewSubItem^, SizeOf(TCueSheetItem));
//          FillChar(NewSubItem^.EventStatus, SizeOf(TEventStatus), #0);

          NewSubItem := CopyCueSheetList[i];

          ChannelCueSheet^.LastSerialNo := ChannelCueSheet^.LastSerialNo + 1;
          NewSubItem^.EventID.SerialNo  := ChannelCueSheet^.LastSerialNo;

          NewSubItem^.GroupNo := NewCurrItem^.GroupNo;

          FCueSheetList.Insert(InsetIndex, NewSubItem);

          InsertPlayListGridSub(InsetIndex);
          Inc(ChannelCueSheet^.EventCount);

          InsetIndex := InsetIndex + 1;
        end;

        ResetNo(CurrIndex + 1, CurrItem^.DisplayNo);
        ResetStartTime(CurrIndex);

//        DisplayPlayListGrid(CurrIndex, FCueSheetList.Count);

        Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('BreakOnAir, Event update completed, Current index = %d', [CurrIndex])));

        if (FChannelOnAir) {and (CurrIndex <= FLastInputIndex) }then
        begin
          OnAirDeleteEvents(CurrIndex, FCueSheetList.Count - 1);
//          Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('BreakOnAir, Delete events, From = %d, To %d', [CurrIndex + ChildCount, FCueSheetList.Count - 1])));

          OnAirInputEvents(CurrIndex, GV_SettingOption.MaxInputEventCount);
          Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('BreakOnAir, Input events, Last input index= %d', [FLastInputIndex])));
        end;

        if (not ChannelOnair) then
        begin
          CalcuratePlayListTimeLineRange;
          UpdatePlayListTimeLineRange;
        end;
        DisplayPlayListTimeLine(CurrIndex);

        SelectRowPlayListGrid(CurrIndex);

        FLastCount := FCueSheetList.Count;

        if (FChannelOnAir) then
        begin
          ServerBeginUpdates(ChannelID);
          try
            ServerInputCueSheets(ChannelID, CurrIndex, GV_SettingOption.MaxInputEventCount);
          finally
            ServerEndUpdates(ChannelID);
          end;
        end;
      finally
        FCueSheetLock.Leave;
      end;
    finally
      acgPlaylist.EndUpdate;
    end;

    finally
      CopyCueSheetList.Clear;
      FreeAndNil(CopyCueSheetList);
    end;
  end;
end;

procedure TfrmChannel.CatchOnAir;
var
  I, J: Integer;
  R: Integer;
  Source: PSource;
  SourceHandles: TSourceHandleList;
  SourceHandle: PSourceHandle;

  OnAirItem: PCueSheetItem;
  OnAirEventID: TEventID;     // DCS onair event id
  OnAirStartTime: TEventTime; // DCS onair event start time
  OnAirDurationTC: TTimecode; // DCS onair event duration tc

  OnNextItem: PCueSheetItem;
  OnNextEventID: TEventID;      // DCS cued event id
  OnNextStartTime: TEventTime;  // DCS cued event start time
  OnNextDurationTC: TTimecode;  // DCS cued event duration tc

  DCSIsOnAir: Boolean;        // DCS onair flag

  CurrItem, NextItem: PCueSheetItem;
begin
{ �����ʿ�
2.5.7 �¿��� ĳġ
�������� �̺�Ʈ�� ��쿡�� �����Ǵ� ����Դϴ�. ����ǥ��� ������ �ǰ� ������
�� �� (Ȥ�� �� �̻�)�� ����� ����� �������� ���� ä ����ǰ� ���� �� �� �����
���� Ŭ����ġ�� �ٽ� ����ִ� ����Դϴ�. �������� �̺�Ʈ�� �ϳ� �����ϰ� [����]-
>[�¿���ĳġ]�� �����ϸ� ���� �ð��� ����Ͽ��� �̺�Ʈ�� Ŭ����ġ�� ����ϰ� �� ��
�к��� �ٽ� Play�� �� �ֵ��� �մϴ�. �� ���� ��ġ�� ã�ư��µ� �ʿ��� �ð�(�� 10 ��)
�� �ҿ�˴ϴ�.
�� ����� �ַ� ����/����� ���������� ������ �� �� ���� �ϳ��� ��� ������
���ܼ� �����ϴ� �뵵�� ���Դϴ�.
}

  if (not HasMainControl) then exit;

  // Check the aleady onair
  if (not FChannelOnAir) then exit;

  if (FCueSheetList = nil) then exit;
  if (FCueSheetList.Count <= 0) then exit;

  acgPlaylist.HideInplaceEdit;

  // Source channel check
  DCSIsOnAir := False;
  for I := 0 to GV_SourceList.Count - 1 do
  begin
    Source := GV_SourceList[I];
    if (Source <> nil) and
       (Source^.SourceType in [ST_VSDEC, ST_VCR, ST_CG, ST_LINE]) and
       (Source^.Channel <> nil) and (Source^.Channel^.ID = FChannelID) and
       (Source^.Handles <> nil) then
    begin
      SourceHandles := Source^.Handles;

      for J := 0 to SourceHandles.Count - 1 do
      begin
        SourceHandle := SourceHandles[J];
        if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
           (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
        begin
          R := frmSEC.DCSEventThread.GetOnAirEventID(SourceHandle, OnAirEventID, OnNextEventID);
          if (R = D_OK) then
          begin
            OnAirItem  := GetCueSheetItemByID(OnAirEventID);
            OnNextItem := GetCueSheetItemByID(OnNextEventID);

            if (OnAirItem <> nil) then
            begin
              R := frmSEC.DCSEventThread.GetEventInfo(SourceHandle, OnAirEventID, OnAirStartTime, OnAirDurationTC);
              if (R = D_OK) then
              begin

              end;
            end;

            if (OnNextItem <> nil) then
            begin
              R := frmSEC.DCSEventThread.GetEventInfo(SourceHandle, OnNextItem^.EventID, OnNextStartTime, OnNextDurationTC);
              if (R = D_OK) then
              begin

              end;
            end;

            if ((OnAirItem <> nil) and (OnAirItem^.EventMode = EM_MAIN)) or
               ((OnNextItem <> nil) and (OnNextItem^.EventMode = EM_MAIN)) then
            begin
              DCSIsOnAir := True;
              break;
            end;
          end;
        end;
      end;

      if (DCSIsOnAir) then break;
    end;
  end;

  if (DCSIsOnAir) then
  begin
    ServerBeginUpdates(ChannelID);
    try
      ServerClearCueSheets(ChannelID);

      CueSheetCurr := OnAirItem;
      CueSheetNext := OnNextItem;

      CheckCueSheetLoop(CueSheetCurr);
    finally
      ServerEndUpdates(ChannelID);
    end;

    acgPlayList.Repaint;
  end;
end;

procedure TfrmChannel.AssignNextEvent(ANextLockTime: Boolean = True);
var
  CurrEndTime: TDateTime;

  I: Integer;
  StartIndex, EndIndex, SkipIndex: Integer;
  LoopFirstIndex, LoopLastIndex: Integer;

  SItem, CItem: PCueSheetItem;
  SaveStartTime: TEventTime;
begin
  if (not HasMainControl) then exit;

  if (CueSheetCurr <> nil) and (ANextLockTime) then
  begin
    CurrEndTime := EventTimeToDateTime(GetEventEndTime(CueSheetCurr^.StartTime, CueSheetCurr^.DurationTC, ChannelFrameRateType), ChannelFrameRateType);
    if (DateTimeToTimecode(CurrEndTime - Now, FR_30) <= GV_SettingThresholdTime.SetNextLockTime) then
    begin
      MessageBeep(MB_ICONWARNING);
      MessageBox(Handle, PChar(SSetNextTimeout), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
      exit;
    end;
  end;

  with acgPlaylist do
  begin
    EndIndex := RealRow - CNT_CUESHEET_HEADER;
    CItem := GetParentCueSheetItemByIndex(EndIndex);
    EndIndex := GetCueSheetIndexByItem(CItem);
    if (CItem <> nil) and
       (CItem^.EventMode = EM_MAIN) and
       (CItem^.EventStatus.State <= esCued) then
    begin
      StartIndex := GetStartOnAirMainIndex;
      if (StartIndex >= 0) then
      begin
        wmtlPlaylist.BeginUpdateCompositions;
        if (ChannelOnAir) then
          ServerBeginUpdates(ChannelID);
        try
  {        for I := StartIndex to EndIndex - 1 do
          begin
            CItem := GetCueSheetItemByIndex(I);
            if (CItem <> nil) and (CItem^.EventStatus.State <= esPreroll) then
              CItem^.EventStatus.State := esSkipped;
          end;  }

  {        if (FCueSheetCurr <> nil) then
            SkipIndex := GetCueSheetIndexByItem(FCueSheetCurr)
          else if (FCueSheetNext <> nil) then
            SkipIndex := GetCueSheetIndexByItem(FCueSheetNext)
          else
            SkipIndex := StartIndex; }

          if (CueSheetNext <> nil) then
            SItem := CueSheetNext
          else if (CueSheetCurr <> nil) then
            SItem := GetNextMainItemByItem(CueSheetCurr)
          else
            SITem := GetCueSheetItemByIndex(StartIndex);

  //        SetCueSheetItemStatusByIndex(GetCueSheetIndexByItem(FCueSheetNext), StartIndex - 1, esSkipped);
          SetCueSheetItemStatusByIndex(StartIndex, EndIndex - 1, esSkipped);

{          if (CueSheetLoopFirst <> nil) and (CueSheetLoopLast <> nil) then
          begin
            LoopFirstIndex := GetCueSheetIndexByItem(CueSheetLoopFirst);
            LoopLastIndex  := GetCueSheetIndexByItem(CueSheetLoopLast);

            if (LoopFirstIndex < StartIndex) then
            begin
              for I := LoopFirstIndex to StartIndex - 1 do
              begin
                CItem := GetCueSheetItemByIndex(I);
                if (CItem <> nil) and  (CItem <> CueSheetCurr) and
                   (CItem^.EventMode = EM_MAIN) and
                   (CItem^.EventStatus.State <> esSkipped) {and (CItem^.EventStatus.State <> esError) }//and
{                   (CItem^.EventStatus.State <= esCued) then
                begin
                  Result := I;
                  break;
                end;
              end;
            end;
          end;  }

//          SItem := GetCueSheetItemByIndex(StartIndex);

          SaveStartTime := CItem^.StartTime;
          if (SItem <> nil) then
            CItem^.StartTime := SItem^.StartTime;

          ResetStartTimeByTime(EndIndex, SaveStartTime);

          // If onair then delet & input event
          if (FChannelOnAir) then
          begin
            DeleteLoopCueSheet;

            OnAirDeleteEvents(StartIndex, EndIndex - 1);
//            OnAirCDeleteEvents(StartIndex, EndIndex - 1);

            OnAirInputEvents(EndIndex, GV_SettingOption.MaxInputEventCount);
          end;

  //        FLastDisplayNo := GetBeforeMainCountByIndex(StartIndex);
  //        DisplayPlayListGrid(StartIndex, 0);
//          DisplayPlayListTimeLine(StartIndex);

          if (ChannelOnAir) then
          begin
            ServerDeleteCueSheets(ChannelID, StartIndex, EndIndex - 1);
            ServerInputCueSheets(ChannelID, EndIndex);
          end;

          CueSheetNext := GetCueSheetItemByIndex(EndIndex);

          CheckCueSheetLoop(CueSheetNext);
        finally
          if (ChannelOnAir) then
            ServerEndUpdates(ChannelID);
          wmtlPlaylist.EndUpdateCompositions;
        end;
      end;
//      CueSheetNext := CItem;


//      acgPlaylist.Repaint;


//      DisplayPlayListTimeLine(EndIndex);
    end;
  end;
end;

procedure TfrmChannel.StartNextEventImmediately;
var
  Index: Integer;
  Item: PCueSheetItem;

  SourceGroup: PSourceGroup;

  Source: PSource;
  SourceHandles: TSourceHandleList;
  SourceHandle: PSourceHandle;

  I: Integer;
  R: Integer;

  CurrIndex: Integer;
  CurrItem: PCueSheetItem;

  ChildCount: Integer;

  NextIndex: Integer;
  NextItem: PCueSheetItem;

  StartTime: TEventTime;
  DurationTC: TTimecode;

  SaveStartTime: TEventTime;
  SaveDurationTC: TTimecode;

  DurEventTime: TEventTime;

//  OnAirIndex: Integer;
//  OnAirItem: PCueSheetItem;
//  OnAirEventID: TEventID;     // DCS onair event id
//  OnAirStartTime: TEventTime; // DCS onair event start time
//  OnAirDurationTC: TTimecode; // DCS onair event duration tc
begin
  if (not HasMainControl) then exit;


{ShowMessage(EventTimeToDateTimecodeStr(GetEventEndTime(FCueSheetList[7]^.StartTime, FCueSheetList[7]^.DurationTC)));
ShowMessage(EventTimeToDateTimecodeStr(FCueSheetList[8]^.StartTime));
exit;  }
  if (not FChannelOnAir) then exit;

  if (CueSheetNext = nil) then exit;
  if (CueSheetNext^.EventMode <> EM_MAIN) then exit;

  Index := GetCueSheetIndexByItem(CueSheetNext);
  if (Index < 0) then exit;

//--- 2024/08/22, bong
//--- ���� �̺�Ʈ�ϱ��� ���¸� üũ�Ͽ� ���� ǥ��
//--- begin
{
  for I := Index to FCueSheetList.Count - 1 do
  begin
    Item := GetCueSheetItemByIndex(I);
    if (Item <> nil) and (Item^.GroupNo = CueSheetNext^.GroupNo) then
    begin
      if (not (Item^.EventStatus.State in [esLoaded..esCued])) then
      begin
        MessageBeep(MB_ICONERROR);
        MessageBox(Handle, PChar(SENextEventNotReady), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
        exit;
      end;
    end
    else
      break;
  end;
}
//--- end

  CurrItem  := CueSheetCurr;
  CurrIndex := GetCueSheetIndexByItem(CurrItem);

  NextItem  := CueSheetNext;
  NextIndex := GetCueSheetIndexByItem(NextItem);

//    OnAirEventID := FCueSheetNext^.EventID;
  OnAirTakeEvent(GetCueSheetIndexByItem(NextItem));
//--- 2023/08/12, bong
//--- begin
  // Manual �̺�Ʈ�� ��� DCS���� �̺�Ʈ ���°� �������� ä�� Ÿ�̸ӿ� ���� �ڵ� �ð� ���� ó�� �ɼ� ����
  // �̺�Ʈ ���¸� OnAir�� ���� ó����
  NextItem^.EventStatus.State := esOnair;
//--- end

  Sleep(TimecodeToMilliSec(GV_SettingTimeParameter.StandardTimeCorrection, FR_30));

  if (ChannelOnAir) then
    ServerBeginUpdates(ChannelID);
  try
{    if (CurrItem <> nil) then
    begin
      Source := GetSourceByName(String(CurrItem^.Source));
      if (Source <> nil) and (Source^.Handles <> nil) then
      begin
        SourceHandles := Source^.Handles;
        for I := 0 to SourceHandles.Count - 1 do
        begin
          SourceHandle := SourceHandles[I];
          if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
             (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
          begin
//            R := DCSGetEventInfo(Source^.Handles[I]^.DCSID, Source^.Handles[I]^.Handle, CurrItem^.EventID, StartTime, DurationTC);
            R := frmSEC.DCSEventThread.GetEventInfo(SourceHandle, CurrItem^.EventID, StartTime, DurationTC);
            if (R = D_OK) then
            begin
              SaveStartTime  := CurrItem^.StartTime;
              SaveDurationTC := CurrItem^.DurationTC;

              CurrItem^.StartTime  := StartTime;
              CurrItem^.DurationTC := DurationTC;

              ShowMessage(TimecodeToString(DurationTC));
              ResetChildItems(CurrIndex, SaveDurationTC);

              if (ChannelOnAir) then
              begin
                ChildCount := GetChildCountByItem(CurrItem);
                ServerInputCueSheets(ChannelID, CurrIndex, ChildCount + 1);
              end;

  //            FLastDisplayNo := GetBeforeMainCountByIndex(CurrIndex);
  //            DisplayPlayListGrid(CurrIndex);
  //            DisplayPlayListTimeLine(CurrIndex);

              break;
            end
            else
              ShowMessage(IntToStr(R));
          end;
        end;
      end;
    end; }

    if (NextItem <> nil) then
    begin
      SourceGroup := GetSourceGroupByName(String(NextItem^.Source));
      if (SourceGroup = nil) then exit;
      if (SourceGroup^.Sources = nil) then exit;
      if (SourceGroup^.Sources.Count <= 0) then exit;

      Source := SourceGroup^.Sources[0];
      if (Source <> nil) and (Source^.Handles <> nil) then
      begin
        SourceHandles := Source^.Handles;
        for I := 0 to SourceHandles.Count - 1 do
        begin
          SourceHandle := SourceHandles[I];
          if (SourceHandle^.DCS <> nil) and (SourceHandle^.DCS^.Alive) and
             (SourceHandle^.Handle > INVALID_DEVICE_HANDLE) then
          begin
//            R := DCSGetEventInfo(Source^.Handles[I]^.DCSID, Source^.Handles[I]^.Handle, NextItem^.EventID, StartTime, DurationTC);
            R := frmSEC.DCSEventThread.GetEventInfo(SourceHandle, NextItem^.EventID, StartTime, DurationTC);
            if (R = D_OK) then
            begin
              if (CurrItem <> nil) then
              begin
                SaveDurationTC := CurrItem^.DurationTC;

                CurrItem^.DurationTC := GetMinusTimecode(CurrItem^.DurationTC, EventTimeToTimecode(GetDurEventTime(NextItem^.StartTime, StartTime, ChannelFrameRateType)), ChannelFrameRateType);
                ResetChildItems(CurrIndex, SaveDurationTC);
              end;

//              ShowMessage(EventTimeToDateTimecodeStr(NextItem^.StartTime));
              SaveStartTime  := NextItem^.StartTime;
              SaveDurationTC := NextItem^.DurationTC;

//              ShowMessage(EventTimeToDateTimecodeStr(StartTime));
              NextItem^.StartTime  := StartTime;
              NextItem^.DurationTC := DurationTC;

              ResetStartTimeByTime(NextIndex, SaveStartTime, SaveDurationTC);

//     Aleady DCS reset start time
//                OnAirInputEvents(GetNextMainIndexByIndex(NextIndex), GV_SettingOption.MaxInputEventCount);

    //          FLastDisplayNo := GetBeforeMainCountByIndex(NextIndex);
    //          DisplayPlayListGrid(NextIndex);
    //          DisplayPlayListTimeLine(NextIndex);


              if (ChannelOnAir) then
                ServerInputCueSheets(ChannelID, NextIndex);

              break;
            end;
          end;
        end;
      end;
    end;

    CueSheetCurr := NextItem;
    NextItem := GetNextMainItemByItem(CueSheetCurr);

//            OnAirInputEvents(NextIndex, GV_SettingOption.MaxInputEventCount);
    acgPlaylist.Repaint;
//    DisplayPlayListTimeLine(NextIndex);

    CheckCueSheetLoop(CueSheetCurr);
  finally
    if (ChannelOnAir) then
      ServerEndUpdates(ChannelID);
  end;
end;

procedure TfrmChannel.IncSecondsOnAirEvent(ASeconds: Integer);
var
  NextStartTime: TDateTime;

  CurrIndex: Integer;
  SaveDurationTC, ChangeDurationTC: TTimecode;
begin
  if (not HasMainControl) then exit;

  if (not FChannelOnAir) then exit;

  if (ASeconds = 0) then exit;
  if (CueSheetCurr = nil) then exit;

  if (CueSheetNext <> nil) then
  begin
    NextStartTime := EventTimeToDateTime(CueSheetNext^.StartTime, ChannelFrameRateType);
    if (DateTimeToTimecode(NextStartTime - Now, FR_30) <= GV_SettingThresholdTime.EnqueueLockTime) then
    begin
      MessageBeep(MB_ICONWARNING);
      MessageBox(Handle, PChar(SEnqueueTimeout), PChar(Application.Title), MB_OK or MB_ICONWARNING or MB_TOPMOST);
      exit;
    end;
  end;

  CurrIndex := GetCueSheetIndexByItem(CueSheetCurr);

  SaveDurationTC := CueSheetCurr^.DurationTC;

  ChangeDurationTC := SecondToTimeCode(Abs(ASeconds), ChannelFrameRateType);

  if (ASeconds > 0) then
    CueSheetCurr^.DurationTC := GetPlusTimecode(CueSheetCurr^.DurationTC, ChangeDurationTC, ChannelFrameRateType)
  else
    CueSheetCurr^.DurationTC := GetMinusTimecode(CueSheetCurr^.DurationTC, ChangeDurationTC, ChannelFrameRateType);

  ResetChildItems(CurrIndex, SaveDurationTC);

  ResetStartTimeByTime(CurrIndex, SaveDurationTC);

  OnAirChangeDurationEvent(CurrIndex, SaveDurationTC, CueSheetCurr^.DurationTC);

//  OnAirInputEvents(CurrIndex, GV_SettingOption.MaxInputEventCount);

//  FLastDisplayNo := GetBeforeMainCountByIndex(CurrIndex);
//  DisplayPlayListGrid(CurrIndex);
  acgPlaylist.Repaint;
//  DisplayPlayListTimeLine(CurrIndex);

  ServerBeginUpdates(ChannelID);
  try
    ServerInputCueSheets(ChannelID, CurrIndex);
  finally
    ServerEndUpdates(ChannelID);
  end;
end;

procedure TfrmChannel.AssignTargetEvent;
var
  SelectIndex: Integer;
  ParentItem: PCueSheetItem;
  ParentIndex: Integer;
  CurrIndex: Integer;

//  ParentRow: Integer;
begin
  if (not HasMainControl) then exit;

  if (not FChannelOnAir) then exit;

  with acgPlaylist do
  begin
    SelectIndex := RealRow - CNT_CUESHEET_HEADER;
    ParentItem := GetParentCueSheetItemByIndex(SelectIndex);
    if (ParentItem <> nil) then
    begin
      if (CueSheetCurr <> nil) then
      begin
        CurrIndex := GetCueSheetIndexByItem(CueSheetCurr);
        ParentIndex := GetCueSheetIndexByItem(ParentItem);
        if (CurrIndex >= ParentIndex) then exit;
      end;
      CueSheetTarget := ParentItem;

{      ParentRow := GetCueSheetIndexByItem(FCueSheetTarget) + CNT_CUESHEET_HEADER;
      lblRemainingTargetEvent.Caption := Format('Remainig target (%s)', [RealCells[IDX_COL_CUESHEET_NO, ParentRow]]); }
    end;
  end;
end;

procedure TfrmChannel.GotoCurrentEvent;
var
  SelectIndex: Integer;
  ParentItem: PCueSheetItem;
  ParentIndex: Integer;

  Index: Integer;

//  ParentRow: Integer;
begin
  if (CueSheetCurr <> nil) then
  begin
    Index := GetCueSheetIndexByItem(CueSheetCurr);
    PostMessage(Handle, WM_UPDATE_CURR_EVENT, Index, NativeInt(CueSheetCurr));
  end
  else if (CueSheetNext <> nil) then
  begin
    Index := GetCueSheetIndexByItem(CueSheetNext);
    PostMessage(Handle, WM_UPDATE_NEXT_EVENT, Index, NativeInt(CueSheetNext));
  end;
end;

procedure TfrmChannel.SetEventStatus(AEventID: TEventID; AStatus: TEventStatus; AIsCurrEvent: Boolean = False);
var
  Item: PCueSheetItem;
  Index: Integer;
  I: Integer;

  SourceGroup: PSourceGroup;
  Source: PSource;
  SourceHandles: TSourceHandleList;
  SourceHandle: PSourceHandle;
begin
  if (not ChannelOnAir) then exit;

  Item := GetCueSheetItemByID(AEventID);
  if (Item <> nil) then
  begin
    if (Item^.EventStatus.State = esSkipped) then exit;

    FCueSheetLock.Enter;
    try
      Item^.EventStatus := AStatus;
    finally
      FCueSheetLock.Leave;
    end;

    Index := GetCueSheetIndexByItem(Item);
    if (Index >= 0) then
    begin
      PostMessage(Handle, WM_UPDATE_EVENT_STATUS, Index, NativeInt(Item));

      ServerSetEventStatuses(Item^.EventID, Item^.EventStatus);
    end;
  end;
end;

procedure TfrmChannel.SetEventStatus(AHandle: TDeviceHandle; AEventID: TEventID; AStatus: TEventStatus; AIsCurrEvent: Boolean = False);
var
  Item: PCueSheetItem;
  Index: Integer;
  I: Integer;

  SourceGroup: PSourceGroup;
  Source: PSource;
  SourceHandles: TSourceHandleList;
  SourceHandle: PSourceHandle;
begin
  if (not ChannelOnAir) then exit;

  Item := GetCueSheetItemByID(AEventID);
  if (Item <> nil) then
  begin
    if (Item^.EventStatus.State = esSkipped) then exit;

    SourceGroup := GetSourceGroupByName(String(Item^.Source));
    if (SourceGroup = nil) then exit;
    if (SourceGroup.Sources = nil) then exit;

    if (SourceGroup.Sources.Count > 0) then
    begin
      Source := SourceGroup.Sources[0];
      if (Source = nil) then exit;

      SourceHandles := Source^.Handles;
      if (SourceHandles = nil) or (SourceHandles.Count <= 0) then exit;

      for I := 0 to SourceHandles.Count - 1 do
      begin
        SourceHandle := SourceHandles[I];
        if (SourceHandle^.Handle = AHandle) then
        begin
          FCueSheetLock.Enter;
          try
            Item^.EventStatus := AStatus;
          finally
            FCueSheetLock.Leave;
          end;

          Index := GetCueSheetIndexByItem(Item);
          if (Index >= 0) then
          begin
            PostMessage(Handle, WM_UPDATE_EVENT_STATUS, Index, NativeInt(Item));

            ServerSetEventStatuses(Item^.EventID, Item^.EventStatus);

      //{      if (ChannelOnAir) then }ServerSetEventStatuses(Item^.EventID, Item^.EventStatus);
          end;

          break;
        end;
      end;
    end;
  end;
end;

procedure TfrmChannel.SetEventOverall(ADCSIP: String; ADeviceHandle: TDeviceHandle; AOverall: TEventOverall);
var
  Item: PCueSheetItem;
  Source: PSource;
  SourceHandles: TSourceHandleList;
  SourceHandle: PSourceHandle;
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
        SourceHandle := SourceHandles[I];
        if (SourceHandle^.DCS <> nil) and (String(SourceHandle^.DCS^.HostIP) = ADCSIP) and
           (SourceHandle^.Handle = ADeviceHandle) then
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
        SourceHandle := SourceHandles[I];
        if (SourceHandle^.DCS <> nil) and (String(SourceHandle^.DCS^.HostIP) = ADCSIP) and
           (SourceHandle^.Handle = ADeviceHandle) then
        begin
          CueSheetNext := nil;
          break;
        end;
      end;
    end;
  end;
end;

procedure TfrmChannel.SetMediaStatus(AEventID: TEventID; AStatus: TMediaStatus);
var
  Item: PCueSheetItem;
  Index: Integer;
  I: Integer;
begin
  Item := GetCueSheetItemByID(AEventID);
  if (Item <> nil) then
  begin
    Item^.MediaStatus := AStatus;
    Index := GetCueSheetIndexByItem(Item);
    if (Index >= 0) then
    begin
      PostMessage(Handle, WM_UPDATE_MEDIA_CHECK, Index, NativeInt(Item));

      if (ChannelOnAir) then ServerSetMediaStatuses(Item^.EventID, Item^.MediaStatus);
    end;
  end;
end;

procedure TfrmChannel.ClearCueSheetLoopPrevList;
var
  I: Integer;
begin
  if (FCueSheetLoopPrevList = nil) then exit;

  FCueSheetLock.Enter;
  try
    for I := FCueSheetLoopPrevList.Count - 1 downto 0 do
      Dispose(FCueSheetLoopPrevList[I]);

    FCueSheetLoopPrevList.Clear;
  finally
    FCueSheetLock.Leave;
  end;
end;

procedure TfrmChannel.ClearCueSheetLoopNextList;
var
  I: Integer;
begin
  if (FCueSheetLoopNextList = nil) then exit;

  FCueSheetLock.Enter;
  try
    for I := FCueSheetLoopNextList.Count - 1 downto 0 do
      Dispose(FCueSheetLoopNextList[I]);

    FCueSheetLoopNextList.Clear;
  finally
    FCueSheetLock.Leave;
  end;
end;

procedure TfrmChannel.ClearChannelCueSheetList;
var
  I: Integer;
begin
  // Channel
  for I := FChannelCueSheetList.Count - 1 downto 0 do
    Dispose(FChannelCueSheetList[I]);

  FChannelCueSheetList.Clear;
end;

procedure TfrmChannel.ClearCueSheetList;
var
  I: Integer;
begin
  if (FCueSheetList = nil) then exit;

  FCueSheetLock.Enter;
  try
    for I := FCueSheetList.Count - 1 downto 0 do
      Dispose(FCueSheetList[I]);

    FCueSheetList.Clear;
  finally
    FCueSheetLock.Leave;
  end;
end;

procedure TfrmChannel.ClearPlayListGrid;
begin
  with acgPlaylist do
  begin
    BeginUpdate;
    try
      if (FixedRows > 0) and (IsNode(0)) then
        FIsContrctAll := GetNodeState(0);

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
      TopRow := FixedRows;
      LeftCol := FixedCols;
    finally
      acgPlaylist.EndUpdate;
    end;
  end;
end;

procedure TfrmChannel.ClearPlayListTimeLine;
var
  I: Integer;
begin
  inherited;
  with wmtlPlaylist do
  begin
    BeginUpdateCompositions;
    try
//      DataGroup.Visible := False;
      for I := 0 to DataGroupProperty.Count - 1 do
      begin
//        DataCompositions[I].Tracks.BeginUpdate;
//        try
          DataCompositions[I].Tracks.Clear;
//        finally
//          DataCompositions[I].Tracks.EndUpdate;
//        end;
      end;
//      DataGroup.Visible := True;

//      Repaint;
    finally
      EndUpdateCompositions;
    end;
  end;
end;

procedure TfrmChannel.FormCreate(Sender: TObject);
begin
  inherited;
  Initialize;

  NewPlayList;

//  OpenPlayList('D:\User Data\Git\APC\SEC\Win64\Debug\CueSheet\ebs_test_20180417_������_1.xml');
//  OpenPlayList('D:\User Data\Git\APC\SEC\Win64\Debug\CueSheet\ebs_test_20180810_������_1.xml');
//  OpenPlayList('D:\User Data\Git\APC\SEC\Win64\Debug\CueSheet\ebs_test_20180810_������_1_endofnext.xml');
//  OpenPlayList('D:\User Data\Git\APC\SEC\Win64\Debug\CueSheet\tbs_test_20181017_������_1.xml');
//  OpenPlayList('D:\EBS\SEC\CueSheet\Work\test1.xml');
end;

procedure TfrmChannel.FormDestroy(Sender: TObject);
begin
  inherited;
  Finalize;
end;

procedure TfrmChannel.FormResize(Sender: TObject);
var
  Zoom: Integer;
begin
  inherited;
//  with wmtlPlayList.ZoomBarProperty do
//  begin
//    TimelineZoomPosition := GetPositionByZoomType(FTimelineZoomType);
//
//{    Zoom := Integer(FTimelineZoomType);
//    Inc(Zoom);
//
//    if (Zoom > Integer(High(TTimelineZoomType))) then Zoom := Integer(High(TTimelineZoomType));
//
//    FTimelineZoomType := TTimelineZoomType(Zoom);
//    TimelineZoomPosition := GetPositionByZoomType(FTimelineZoomType); }
//  end;
end;

procedure TfrmChannel.FormShow(Sender: TObject);
begin
  inherited;
//  Initialize;

//  NewPlayList;
end;

procedure TfrmChannel.InitializePlayListGrid;
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
              if (ChannelIsDropFrame) then
                EditMask := '!99:99:99;99;1; '
              else
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
              if (ChannelIsDropFrame) then
                EditMask := '!99:99:99;99;1; '
              else
                EditMask := '!99:99:99:99;1; ';
            end
            // Column : In TC
            else if (I = IDX_COL_CUESHEET_IN_TC) then
            begin
              Header := NAM_COL_CUESHEET_IN_TC;
              Width  := WIDTH_COL_CUESHEET_IN_TC;
              Editor := edNormal;
              if (ChannelIsDropFrame) then
                EditMask := '!99:99:99;99;1; '
              else
                EditMask := '!99:99:99:99;1; ';
            end
            // Column : Out TC
            else if (I = IDX_COL_CUESHEET_OUT_TC) then
            begin
              Header := NAM_COL_CUESHEET_OUT_TC;
              Width  := WIDTH_COL_CUESHEET_OUT_TC;
              Editor := edNormal;
              if (ChannelIsDropFrame) then
                EditMask := '!99:99:99;99;1; '
              else
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

procedure TfrmChannel.InitializePlayListTimeLine;
begin
  with wmtlPlaylist do
  begin
    with TimeZoneProperty do
    begin
      FrameDayReset := True;
//      FrameRate := FrameRate29_97;
      FrameRate := GetFrameRateValueByType(GV_SettingOption.TimelineFrameRateType);
      FrameSkip := 30;
      FrameStep := 15;
      RailBarColor := COLOR_BAR_TIMELINE_RAIL;
      RailBarVisible := False;

      FTimeLineDaysPerFrames := Round(SecsPerDay * TimeZoneProperty.FrameRate);
      FrameCount := FTimeLineDaysPerFrames;
    end;

    FrameSelectEnabled := False;
    TrackSelectEnabled := False;
    TrackTrimEnabled := False;

    VideoGroupProperty.Count := 0;
    AudioGroupProperty.Count := 0;

    DataGroupProperty.Count  := 3;

    DataCompositions[0].Height := 4;
    DataCompositions[1].Height := 80;
    DataCompositions[2].Height := 80;
  end;

  FTimelineStartDate := Date;
  FTimelineEndDate   := Date;

  FTimeLineMin := 0;
  FTimeLineMax := 0;

//  UpdateZoomPosition(FTimeLineZoomPosition);
end;

//function TfrmChannel.GetOnairDatePlayListFile(AFileName: String; var AOnairDate: TDateTime): Boolean;
//var
//  Xml: TXmlVerySimple;
//  DataNode: TXmlNode;
//  EventsNode, EventNode: TXmlNode;
//
//  ChannelCueSheet: PChannelCueSheet;
//  ChannelCueSheetSerialNo: Integer;
//
//  I: Integer;
//  Item: PCueSheetItem;
//begin
//  Result := False;
//
//  if (not FileExists(AFileName)) then exit;
//
//  Xml := TXmlVerySimple.Create;
//  try
//    Xml.LoadFromFile(AFileName);
//    if (Xml.DocumentElement = nil) then exit;
//
////    DataNode := Xml.DocumentElement.Find('data');
////    if (DataNode <> nil) then
//    begin
//      DataNode := Xml.DocumentElement.Find(XML_CHANNEL_ID);
//      if (DataNode <> nil) then
//        AChannelCueSheet^.ChannelId := StrToIntDef(DataNode.NodeValue, 0);
//
//      DataNode := Xml.DocumentElement.Find(XML_ONAIR_DATE);
//      if (DataNode <> nil) then
//        StrPLCopy(AChannelCueSheet^.OnairDate, DataNode.NodeValue);
//
//      DataNode := Xml.DocumentElement.Find(XML_ONAIR_FLAG);
//      if (DataNode <> nil) then
//      begin
//        if (Length(DataNode.NodeValue) > 0) then
//          AChannelCueSheet^.OnairFlag := TOnAirFlagType(Ord(DataNode.NodeValue[1]))
//        else
//          AChannelCueSheet^.OnairFlag := FT_REGULAR;
//      end
//      else
//        AChannelCueSheet^.OnairFlag := FT_REGULAR;
//
//      DataNode := Xml.DocumentElement.Find(XML_ONAIR_NO);
//      if (DataNode <> nil) then
//        AChannelCueSheet^.OnairNo := StrToIntDef(DataNode.NodeValue, 0);
//
//      DataNode := Xml.DocumentElement.Find(XML_EVENT_COUNT);
//      if (DataNode <> nil) then
//        AChannelCueSheet^.EventCount := StrToIntDef(DataNode.NodeValue, 0);
//
//      AChannelCueSheet^.LastSerialNo  := 0;
//      AChannelCueSheet^.LastProgramNo := 0;
//      AChannelCueSheet^.LastGroupNo   := 0;
//end;

{
procedure TfrmChannel.PlaylistFileParsing(AFileName: String);
var
  XmlParser: TXmlParser;
  CueSheetItem: PCueSheetItem;

  procedure ScanElement;
  var
    I: Integer;
    ContentStr: AnsiString;
  begin
    while XmlParser.Scan do
    begin
      case XmlParser.CurPartType OF
        ptStartTag,
        ptEmptyTag:
        begin
          if (XmlParser.CurAttr.Count > 0) then
          begin
            if (XmlParser.CurName = XML_EVENT) then
            begin
              CueSheetItem := New(PCueSheetItem);
              FillChar(CueSheetItem^, SizeOf(TCueSheetItem), #0);
              with CueSheetItem^ do
              begin
                EventID.ChannelID := FChannelID;
                StrCopy(EventID.OnAirDate, FChannelCueSheet^.OnairDate);
                EventID.OnAirFlag := FChannelCueSheet^.OnairFlag;
                EventID.OnAirNo   := FChannelCueSheet^.OnairNo;

                for I := 0 to XmlParser.CurAttr.Count - 1 do
                begin
                  if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_SERIAL_NO) then
                  begin
                    // Play list�� ó�� open ���� ��쿡�� ť��Ʈ�� SerialNo�� ����
                    if (FLastCount <= 0) then
                    begin
                      FLastSerialNo := StrToIntDef(TNvpNode(XmlParser.CurAttr[I]).Value, 0);
                    end
                    else
                    begin
                      FLastSerialNo := FLastSerialNo + 1;
                    end;
                    EventID.SerialNo := FLastSerialNo;
                  end
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_PROGRAM_NO) then
                  begin
                    // Play list�� ó�� open ���� ��쿡�� ť��Ʈ�� ProgramNo�� ����
                    FLastProgramNo := StrToIntDef(TNvpNode(XmlParser.CurAttr[I]).Value, 0);
                    if (FLastCount <= 0) then
                    begin
                      ProgramNo := FLastProgramNo;
                    end
                    else
                    begin
                      ProgramNo := ProgramNo + FLastProgramNo;
                    end;
                  end
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_GROUP_NO) then
                  begin
                    // Play list�� ó�� open ���� ��쿡�� ť��Ʈ�� GroupNo�� ����
                    FLastGroupNo := StrToIntDef(TNvpNode(XmlParser.CurAttr[I]).Value, 0);
                    if (FLastCount <= 0) then
                    begin
                      GroupNo := FLastGroupNo;
                    end
                    else
                    begin
                      GroupNo := GroupNo + FLastGroupNo;
                    end;
                  end
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_EVENT_MODE) then
                  begin
                    EventMode := TEventMode(StrToIntDef(TNvpNode(XmlParser.CurAttr[I]).Value, 0));
                    if (EventMode = EM_MAIN) then
                      Inc(FLastDisplayNo);

                    DisplayNo := FLastDisplayNo;
                  end
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_START_MODE) then
                    StartMode := TStartMode(StrToIntDef(TNvpNode(XmlParser.CurAttr[I]).Value, 0))
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_START_TIME) then
                    StartTime := DateTimecodeStrToEventTime(TNvpNode(XmlParser.CurAttr[I]).Value)
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_INPUT) then
                    Input := TInputType(StrToIntDef(TNvpNode(XmlParser.CurAttr[I]).Value, 0))
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_OUTPUT) then
                    Output := StrToIntDef(TNvpNode(XmlParser.CurAttr[I]).Value, 0)
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_TITLE) then
                    StrPLCopy(Title, TNvpNode(XmlParser.CurAttr[I]).Value)
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_SUB_TITLE) then
                    StrPLCopy(SubTitle, TNvpNode(XmlParser.CurAttr[I]).Value)
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_SOURCE) then
                    StrPLCopy(Source, TNvpNode(XmlParser.CurAttr[I]).Value)
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_MEDIA_ID) then
                    StrPLCopy(MediaId, TNvpNode(XmlParser.CurAttr[I]).Value)
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_DURATION_TC) then
                    DurationTC := StringToTimecode(TNvpNode(XmlParser.CurAttr[I]).Value)
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_IN_TC) then
                    InTC := StringToTimecode(TNvpNode(XmlParser.CurAttr[I]).Value)
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_OUT_TC) then
                    OutTC := StringToTimecode(TNvpNode(XmlParser.CurAttr[I]).Value)
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_TRANSITION_TYPE) then
                    TransitionType := TTRType(StrToIntDef(TNvpNode(XmlParser.CurAttr[I]).Value, 0))
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_TRANSITION_RATE) then
                    TransitionRate := TTRRate(StrToIntDef(TNvpNode(XmlParser.CurAttr[I]).Value, 0))
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_VIDEO_TYPE) then
                    VideoType := TVideoType(StrToIntDef(TNvpNode(XmlParser.CurAttr[I]).Value, 0))
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_AUDIO_TYPE) then
                    AudioType := TAudioType(StrToIntDef(TNvpNode(XmlParser.CurAttr[I]).Value, 0))
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_CLOSED_CAPTION) then
                    ClosedCaption := TClosedCaption(StrToIntDef(TNvpNode(XmlParser.CurAttr[I]).Value, 0))
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_VOICE_ADD) then
                    VoiceAdd := TVoiceAdd(StrToIntDef(TNvpNode(XmlParser.CurAttr[I]).Value, 0))
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_PROGRAM_TYPE) then
                    ProgramType := StrToIntDef(TNvpNode(XmlParser.CurAttr[I]).Value, 0)
                  else if (TNvpNode(XmlParser.CurAttr[I]).Name = XML_NOTES) then
                    StrPLCopy(Notes, TNvpNode(XmlParser.CurAttr[I]).Value);
                end;
              end;
              FCueSheetList.Add(CueSheetItem);
            end;

          end;

          if (XmlParser.CurPartType = ptStartTag) then  // Recursion
            ScanElement;
        end;
        ptEndTag: break;
        ptContent,
        ptCData:
        begin
          // Play list�� ó�� open ���� ��쿡�� ä���� ť��Ʈ ������ ����
          if (FLastCount <= 0) then
          begin
            if (Length(XmlParser.CurContent) > 40) then
              ContentStr := Copy (XmlParser.CurContent, 1, 40) + #133
            else
              ContentStr := XmlParser.CurContent;

//            if (XmlParser.CurName = XML_CHANNEL_ID) then
//            begin
//              FChannelCueSheet^.ChannelId := StrToIntDef(ContentStr, 0);
//            end
//            else
            if (XmlParser.CurName = XML_ONAIR_DATE) then
            begin
              StrPLCopy(FChannelCueSheet^.OnairDate, ContentStr);
            end
            else if (XmlParser.CurName = XML_ONAIR_FLAG) then
            begin
              if (Length(ContentStr) > 0) then
                FChannelCueSheet^.OnairFlag := TOnAirFlagType(Ord(ContentStr[1]))
              else
                FChannelCueSheet^.OnairFlag := FT_REGULAR;
            end
            else if (XmlParser.CurName = XML_ONAIR_NO) then
            begin
              FChannelCueSheet^.OnairNo := StrToIntDef(ContentStr, 0);
            end;
          end;
        end;
      end;
    end;
  end;

begin
  XmlParser := TXmlParser.Create;
  try
    XmlParser.LoadFromFile(AFileName);
    XmlParser.Normalize := True;
    XmlParser.StartScan;

    ScanElement;
  finally
    FreeAndNil(XmlParser);
  end;
end;
}

procedure TfrmChannel.AddPlayListItem(AChannelCueSheet: PChannelCueSheet; ACueSheetList: TCueSheetList; AEventsNode: TXmlNode; AIndex: Integer; AAdd: Boolean = False; ASerialNo: Integer = -1);
var
  Xml: TXmlVerySimple;
  DataNode: TXmlNode;
  EventNode: TXmlNode;

//  I: Integer;
  Item: PCueSheetItem;
begin
  if (AChannelCueSheet = nil) then exit;
  if (ACueSheetList = nil) then exit;
  if (AEventsNode = nil) then exit;

  FCueSheetLock.Enter;
  try
    Item := New(PCueSheetItem);
    FillChar(Item^, SizeOf(TCueSheetItem), #0);
    with Item^ do
    begin
      EventID.ChannelID := FChannelID;
      StrCopy(EventID.OnAirDate, AChannelCueSheet^.OnairDate);
      EventID.OnAirFlag := AChannelCueSheet^.OnairFlag;
      EventID.OnAirNo   := AChannelCueSheet^.OnairNo;

      EventNode := AEventsNode.ChildNodes[AIndex];

      EventStatus.State := TEventState(StrToIntDef(EventNode.Attributes[XML_ATTR_STATUS], 0));
      EventStatus.ErrorCode := E_NO_ERROR; // ���� errorcode ���Կ��� ����

{            // Play list�� ó�� open ���� ��쿡�� ť��Ʈ�� SerialNo�� ����
      if (FLastCount <= 0) then
      begin
        FLastSerialNo := StrToIntDef(EventNode.Attributes[XML_ATTR_SERIAL_NO], 0);
      end
      else
      begin
        FLastSerialNo := FLastSerialNo + 1;
      end;  }

      // �ߺ��� ť��Ʈ�� �ε��Ǿ� ���� ��� �̹� �ε��� ť��Ʈ�� ������ SerialNo�� �������Ѽ� ����
      if (AAdd) and (ASerialNo >= 0) then
      begin
        EventID.SerialNo := ASerialNo;
        Inc(ASerialNo);
      end
      else
        EventID.SerialNo := StrToIntDef(EventNode.Attributes[XML_ATTR_SERIAL_NO], 0);

      AChannelCueSheet^.LastSerialNo := Max(AChannelCueSheet^.LastSerialNo, EventID.SerialNo);

      // Play list�� ó�� open ���� ��쿡�� ť��Ʈ�� ProgramNo�� ����
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

{            // Play list�� ó�� open ���� ��쿡�� ť��Ʈ�� GroupNo�� ����
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
        Inc(FLastDisplayNo);

      DisplayNo := FLastDisplayNo;

      StartMode := TStartMode(StrToIntDef(EventNode.Attributes[XML_ATTR_START_MODE], 0));
      StartTime := DateTimecodeStrToEventTime(EventNode.Attributes[XML_ATTR_START_TIME], ChannelFrameRateType);
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
  finally
    FCueSheetLock.Leave;
  end;
end;

procedure TfrmChannel.OpenPlayListXML(AChannelCueSheet: PChannelCueSheet; ACueSheetList: TCueSheetList; AAdd: Boolean);
var
  Xml: TXmlVerySimple;
  DataNode: TXmlNode;
  EventsNode, EventNode: TXmlNode;

  ChannelCueSheet: PChannelCueSheet;
  ChannelCueSheetSerialNo: Integer;

  I: Integer;
//  Item: PCueSheetItem;
begin
  if (AChannelCueSheet = nil) then exit;
  if (ACueSheetList = nil) then exit;
  if (not FileExists(String(AChannelCueSheet^.FileName))) then exit;

  Xml := TXmlVerySimple.Create;
  try
    Xml.LoadFromFile(String(AChannelCueSheet^.FileName));
    if (Xml.DocumentElement = nil) then exit;

//    DataNode := Xml.DocumentElement.Find('data');
//    if (DataNode <> nil) then
    begin
      DataNode := Xml.DocumentElement.Find(XML_CHANNEL_ID);
      if (DataNode <> nil) then
        AChannelCueSheet^.ChannelId := StrToIntDef(DataNode.NodeValue, 0);

      DataNode := Xml.DocumentElement.Find(XML_ONAIR_DATE);
      if (DataNode <> nil) then
        StrPLCopy(AChannelCueSheet^.OnairDate, DataNode.NodeValue, DATE_LEN);

      DataNode := Xml.DocumentElement.Find(XML_ONAIR_FLAG);
      if (DataNode <> nil) then
      begin
        if (Length(DataNode.NodeValue) > 0) then
          AChannelCueSheet^.OnairFlag := TOnAirFlagType(Ord(DataNode.NodeValue[1]))
        else
          AChannelCueSheet^.OnairFlag := FT_REGULAR;
      end
      else
        AChannelCueSheet^.OnairFlag := FT_REGULAR;

      DataNode := Xml.DocumentElement.Find(XML_ONAIR_NO);
      if (DataNode <> nil) then
        AChannelCueSheet^.OnairNo := StrToIntDef(DataNode.NodeValue, 0);

      DataNode := Xml.DocumentElement.Find(XML_EVENT_COUNT);
      if (DataNode <> nil) then
        AChannelCueSheet^.EventCount := StrToIntDef(DataNode.NodeValue, 0);

      AChannelCueSheet^.LastSerialNo  := 0;
      AChannelCueSheet^.LastProgramNo := 0;
      AChannelCueSheet^.LastGroupNo   := 0;

      if (AAdd) then
      begin
        // �ߺ��� ť��Ʈ�� �ε��Ǿ� ���� ��� �̹� �ε��� ť��Ʈ�� ������ SerialNo�� ����
        ChannelCueSheet := GetChannelCueSheetByDuplicate(OnAirDateToDate(AChannelCueSheet^.OnairDate), AChannelCueSheet^.OnairFlag, AChannelCueSheet^.OnairNo);
        if (ChannelCueSheet <> nil) then
          ChannelCueSheetSerialNo := ChannelCueSheet^.LastSerialNo + 1
        else
          ChannelCueSheetSerialNo := -1;
      end;

      EventsNode := Xml.DocumentElement.Find(XML_EVENTS);
      if (EventsNode <> nil) then
      begin
        for I := 0 to EventsNode.ChildNodes.Count - 1 do
        begin
          AddPlayListItem(AChannelCueSheet, ACueSheetList, EventsNode, I, AAdd, ChannelCueSheetSerialNo);
//          FCueSheetLock.Enter;
//          try
//            Item := New(PCueSheetItem);
//            FillChar(Item^, SizeOf(TCueSheetItem), #0);
//            with Item^ do
//            begin
//              EventID.ChannelID := FChannelID;
//              StrCopy(EventID.OnAirDate, AChannelCueSheet^.OnairDate);
//              EventID.OnAirFlag := AChannelCueSheet^.OnairFlag;
//              EventID.OnAirNo   := AChannelCueSheet^.OnairNo;
//
//              EventNode := EventsNode.ChildNodes[I];
//
//              EventStatus.State := TEventState(StrToIntDef(EventNode.Attributes[XML_ATTR_STATUS], 0));
//              EventStatus.ErrorCode := E_NO_ERROR; // ���� errorcode ���Կ��� ����
//
//  {            // Play list�� ó�� open ���� ��쿡�� ť��Ʈ�� SerialNo�� ����
//              if (FLastCount <= 0) then
//              begin
//                FLastSerialNo := StrToIntDef(EventNode.Attributes[XML_ATTR_SERIAL_NO], 0);
//              end
//              else
//              begin
//                FLastSerialNo := FLastSerialNo + 1;
//              end;  }
//
//              // �ߺ��� ť��Ʈ�� �ε��Ǿ� ���� ��� �̹� �ε��� ť��Ʈ�� ������ SerialNo�� �������Ѽ� ����
//              if (AAdd) and (ChannelCueSheet <> nil) then
//              begin
//                EventID.SerialNo := ChannelCueSheetSerialNo;
//                Inc(ChannelCueSheetSerialNo);
//              end
//              else
//                EventID.SerialNo := StrToIntDef(EventNode.Attributes[XML_ATTR_SERIAL_NO], 0);
//
//              AChannelCueSheet^.LastSerialNo := Max(AChannelCueSheet^.LastSerialNo, EventID.SerialNo);
//
//              // Play list�� ó�� open ���� ��쿡�� ť��Ʈ�� ProgramNo�� ����
//  {            FLastProgramNo := StrToIntDef(EventNode.Attributes[XML_ATTR_PROGRAM_NO], 0);
//              if (FLastCount <= 0) then
//              begin
//                ProgramNo := FLastProgramNo;
//              end
//              else
//              begin
//                ProgramNo := ProgramNo + FLastProgramNo;
//              end; }
//
//              ProgramNo := StrToIntDef(EventNode.Attributes[XML_ATTR_PROGRAM_NO], 0);
//              AChannelCueSheet^.LastProgramNo := Max(AChannelCueSheet^.LastProgramNo, ProgramNo);
//
//  {            // Play list�� ó�� open ���� ��쿡�� ť��Ʈ�� GroupNo�� ����
//              FLastGroupNo := StrToIntDef(EventNode.Attributes[XML_ATTR_GROUP_NO], 0);
//              if (FLastCount <= 0) then
//              begin
//                GroupNo := FLastGroupNo;
//              end
//              else
//              begin
//                GroupNo := GroupNo + FLastGroupNo;
//              end; }
//
//              GroupNo := StrToIntDef(EventNode.Attributes[XML_ATTR_GROUP_NO], 0);
//              AChannelCueSheet^.LastGroupNo := Max(AChannelCueSheet^.LastGroupNo, GroupNo);
//
//              EventMode := TEventMode(StrToIntDef(EventNode.Attributes[XML_ATTR_EVENT_MODE], 0));
//              if (EventMode = EM_MAIN) then
//                Inc(FLastDisplayNo);
//
//              DisplayNo := FLastDisplayNo;
//
//              StartMode := TStartMode(StrToIntDef(EventNode.Attributes[XML_ATTR_START_MODE], 0));
//              StartTime := DateTimecodeStrToEventTime(EventNode.Attributes[XML_ATTR_START_TIME]);
//              Input := TInputType(StrToIntDef(EventNode.Attributes[XML_ATTR_INPUT], 0));
//              Output := StrToIntDef(EventNode.Attributes[XML_ATTR_OUTPUT], 0);
//              StrPLCopy(Title, EventNode.Attributes[XML_ATTR_TITLE], TITLE_LEN);
//              StrPLCopy(SubTitle, EventNode.Attributes[XML_ATTR_SUB_TITLE], SUBTITLE_LEN);
//              StrPLCopy(Source, EventNode.Attributes[XML_ATTR_SOURCE], DEVICENAME_LEN);
//              SourceLayer := StrToIntDef(EventNode.Attributes[XML_ATTR_SOURCE_LAYER], 0);
//              StrPLCopy(MediaId, EventNode.Attributes[XML_ATTR_MEDIA_ID], MEDIAID_LEN);
//              DurationTC := StringToTimecode(EventNode.Attributes[XML_ATTR_DURATION_TC]);
//              InTC := StringToTimecode(EventNode.Attributes[XML_ATTR_IN_TC]);
//              OutTC := StringToTimecode(EventNode.Attributes[XML_ATTR_OUT_TC]);
//              VideoType := TVideoType(StrToIntDef(EventNode.Attributes[XML_ATTR_VIDEO_TYPE], 0));
//              AudioType := TAudioType(StrToIntDef(EventNode.Attributes[XML_ATTR_AUDIO_TYPE], 0));
//              ClosedCaption := TClosedCaption(StrToIntDef(EventNode.Attributes[XML_ATTR_CLOSED_CAPTION], 0));
//              VoiceAdd := TVoiceAdd(StrToIntDef(EventNode.Attributes[XML_ATTR_VOICE_ADD], 0));
//              TransitionType := TTRType(StrToIntDef(EventNode.Attributes[XML_ATTR_TRANSITION_TYPE], 0));
//              TransitionRate := TTRRate(StrToIntDef(EventNode.Attributes[XML_ATTR_TRANSITION_RATE], 0));
//              FinishAction := TFinishAction(StrToIntDef(EventNode.Attributes[XML_ATTR_FINISH_ACTION], 0));
//              ProgramType := StrToIntDef(EventNode.Attributes[XML_ATTR_PROGRAM_TYPE], 0);
//              BkColor := COLOR_BK_EVENTSTATUS_NORMAL;
//              TxColor := COLOR_TX_EVENTSTATUS_NORMAL;
//              ToColor := COLOR_TO_EVENTSTATUS_NORMAL;
//              StrPLCopy(Notes, EventNode.Attributes[XML_ATTR_NOTES], NOTES_LEN);
//            end;
//
//            ACueSheetList.Add(Item);
//          finally
//            FCueSheetLock.Leave;
//          end;
        end;

        // ���� �̺�Ʈ �˻� �� ť��Ʈ�� EventCount�� ���� Count�� �˻��ؾ� ��
        AChannelCueSheet^.EventCount := EventsNode.ChildNodes.Count;//ACueSheetList.Count;
      end;
    end;
  finally
    FreeAndNil(Xml);
  end;
end;

procedure TfrmChannel.SavePlayListXML(AChannelCueSheet: PChannelCueSheet; AAll: Boolean);
var
  Xml: TXmlVerySimple;
  DocType: TXmlNode;
  DataNode: TXmlNode;
  EventsNode, EventNode: TXmlNode;
  EventCount: Integer;
  I: Integer;
  Item: PCueSheetItem;
  SaveProgramNo, SaveGroupNo: Integer;
begin
  if (AChannelCueSheet = nil) then exit;
  if (FCueSheetList = nil) then exit;

  if (AAll) then
  begin
    SaveProgramNo := -1;
    SaveGroupNo := -1;
  end;

  // Create a XML document first, and save it
  Xml := TXmlVerySimple.Create;
  try
    DocType := Xml.AddChild('DocType', ntDocType);
    DocType.Text := 'data [' + #13#10 +
                    '<!ELEMENT data (channelid, onairdate, onairflag, onairno, events)>' + #13#10 +
                    '<!ELEMENT channelid (#PCDATA)>' + #13#10 +
                    '<!ELEMENT onairdate (#PCDATA)>' + #13#10 +
                    '<!ELEMENT onairflag (#PCDATA)>' + #13#10 +
                    '<!ELEMENT onairno (#PCDATA)>' + #13#10 +
                    '<!ELEMENT eventcount (#PCDATA)>' + #13#10 +
                    '<!ELEMENT events (event)>' + #13#10 +
                    '<!ELEMENT event (#PCDATA)>' + #13#10 +
                    ']';

    DataNode := Xml.AddChild('data');
    DataNode.Addchild(XML_CHANNEL_ID).Text := Format('%d', [AChannelCueSheet^.ChannelId]);
    DataNode.Addchild(XML_ONAIR_DATE).Text := String(AChannelCueSheet^.OnairDate);
    DataNode.Addchild(XML_ONAIR_FLAG).Text := Char(AChannelCueSheet^.OnairFlag);
    DataNode.Addchild(XML_ONAIR_NO).Text := Format('%d', [AChannelCueSheet^.OnairNo]);
    DataNode.Addchild(XML_EVENT_COUNT).Text := Format('%d', [AChannelCueSheet^.EventCount]);

    EventCount := 0;
    for I := 0 to FChannelCueSheetList.IndexOf(AChannelCueSheet) - 1 do
      Inc(EventCount, FChannelCueSheetList[I]^.EventCount);

    EventsNode := DataNode.Addchild(XML_EVENTS);
    for I := EventCount to EventCount + AChannelCueSheet^.EventCount - 1 do
    begin
      if (I > FCueSheetList.Count - 1) then continue;

      Item := GetCueSheetItemByIndex(I);
      if (Item <> nil) then
      begin
        if (AAll) then
        begin
          Inc(AChannelCueSheet^.LastSerialNo);
          Item^.EventID.SerialNo := AChannelCueSheet^.LastSerialNo;

          if (SaveProgramNo <> Item^.ProgramNo) then
          begin
            Inc(AChannelCueSheet^.LastProgramNo);
            SaveProgramNo := Item^.ProgramNo;
          end;
          Item^.ProgramNo := AChannelCueSheet^.LastProgramNo;

          if (SaveGroupNo <> Item^.GroupNo) then
          begin
            Inc(AChannelCueSheet^.LastGroupNo);
            SaveGroupNo := Item^.GroupNo;
          end;
          Item^.GroupNo := AChannelCueSheet^.LastGroupNo;
        end;

        EventNode := EventsNode.AddChild(XML_EVENT);
        EventNode.SetAttribute(XML_ATTR_STATUS, Format('%d', [Integer(Item^.EventStatus.State)]));
  //      EventNode.SetAttribute(XML_ATTR_STATUS, Format('%d', [Integer(Item^.EventStatus.State)])); // errorcode �߰� Ȯ��
        EventNode.SetAttribute(XML_ATTR_SERIAL_NO, Format('%d', [Item^.EventID.SerialNo]));
        EventNode.SetAttribute(XML_ATTR_PROGRAM_NO, Format('%d', [Item^.ProgramNo]));
        EventNode.SetAttribute(XML_ATTR_GROUP_NO, Format('%d', [Item^.GroupNo]));
        EventNode.SetAttribute(XML_ATTR_EVENT_MODE, Format('%d', [Ord(Item^.EventMode)]));

        if (Item^.EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
        begin
          EventNode.SetAttribute(XML_ATTR_START_MODE, Format('%d', [Ord(Item^.StartMode)]));
          EventNode.SetAttribute(XML_ATTR_START_TIME, EventTimeToString(Item^.StartTime, ChannelFrameRateType));
          EventNode.SetAttribute(XML_ATTR_INPUT, Format('%d', [Ord(Item^.Input)]));
          EventNode.SetAttribute(XML_ATTR_OUTPUT, Format('%d', [Ord(Item^.Output)]));
        end;

        EventNode.SetAttribute(XML_ATTR_TITLE, String(Item^.Title));

        if (Item^.EventMode <> EM_COMMENT) then
        begin
          EventNode.SetAttribute(XML_ATTR_SUB_TITLE, String(Item^.SubTitle));
        end;

        if (Item^.EventMode in [EM_MAIN, EM_JOIN, EM_SUB]) then
        begin
          EventNode.SetAttribute(XML_ATTR_SOURCE, String(Item^.Source));
          EventNode.SetAttribute(XML_ATTR_SOURCE_LAYER, Format('%d', [Item^.SourceLayer]));
          EventNode.SetAttribute(XML_ATTR_MEDIA_ID, String(Item^.MediaId));
          EventNode.SetAttribute(XML_ATTR_DURATION_TC, TimecodeToString(Item^.DurationTC, ChannelIsDropFrame));
          EventNode.SetAttribute(XML_ATTR_IN_TC, TimecodeToString(Item^.InTC, ChannelIsDropFrame));
          EventNode.SetAttribute(XML_ATTR_OUT_TC, TimecodeToString(Item^.OutTC, ChannelIsDropFrame));
          EventNode.SetAttribute(XML_ATTR_VIDEO_TYPE, Format('%d', [Ord(Item^.VideoType)]));
          EventNode.SetAttribute(XML_ATTR_AUDIO_TYPE, Format('%d', [Ord(Item^.AudioType)]));
          EventNode.SetAttribute(XML_ATTR_CLOSED_CAPTION, Format('%d', [Ord(Item^.ClosedCaption)]));
          EventNode.SetAttribute(XML_ATTR_VOICE_ADD, Format('%d', [Ord(Item^.VoiceAdd)]));
          EventNode.SetAttribute(XML_ATTR_TRANSITION_TYPE, Format('%d', [Ord(Item^.TransitionType)]));
          EventNode.SetAttribute(XML_ATTR_TRANSITION_RATE, Format('%d', [Ord(Item^.TransitionRate)]));
          EventNode.SetAttribute(XML_ATTR_FINISH_ACTION, Format('%d', [Ord(Item^.FinishAction)]));
          EventNode.SetAttribute(XML_ATTR_PROGRAM_TYPE, Format('%d', [Ord(Item^.ProgramType)]));
          EventNode.SetAttribute(XML_ATTR_NOTES, String(Item^.Notes));
        end;
      end;
    end;

    Xml.SaveToFile(String(AChannelCueSheet^.FileName));
  finally
    FreeAndNil(Xml);
  end;
end;

procedure TfrmChannel.ServerBeginUpdates(AChannelID: Word);
begin
  if (frmAllChannels <> nil) then
  begin
    frmAllChannels.wmtlPlaylist.BeginUpdateCompositions;
  end;

  if (not HasMainControl) then exit;

  MCCBeginUpdates(AChannelID);
  SECBeginUpdates(AChannelID);
end;

procedure TfrmChannel.ServerEndUpdates(AChannelID: Word);
begin
  if (frmAllChannels <> nil) then
  begin
    frmAllChannels.wmtlPlaylist.EndUpdateCompositions;
  end;

  if (not HasMainControl) then exit;

  MCCEndUpdates(AChannelID);
  SECEndUpdates(AChannelID);
end;

procedure TfrmChannel.ServerSetOnAirs(AChannelID: Word; AIsOnAir: Boolean);
begin
  if (frmAllChannels <> nil) then
    frmAllChannels.SetChannelOnAir(ChannelID, AIsOnAir);

  if (not HasMainControl) then exit;

  MCCSetOnAirs(AChannelID, AIsOnAir);
  SECSetOnAirs(AChannelID, AIsOnAir);
end;

procedure TfrmChannel.ServerSetEventStatuses(AEventID: TEventID; AEventStatus: TEventStatus);
begin
  if (frmAllChannels <> nil) then
    frmAllChannels.SetEventStatus(AEventID, AEventStatus);

  if (not HasMainControl) then exit;

  MCCSetEventStatuses(AEventID, AEventStatus);
  SECSetEventStatuses(AEventID, AEventStatus);
end;

procedure TfrmChannel.ServerSetMediaStatuses(AEventID: TEventID; AMediaStatus: TMediaStatus);
begin
  if (frmAllChannels <> nil) then
    frmAllChannels.SetMediaStatus(AEventID, AMediaStatus);

  if (not HasMainControl) then exit;

  MCCSetMediaStatuses(AEventID, AMediaStatus);
  SECSetMediaStatuses(AEventID, AMediaStatus);
end;

procedure TfrmChannel.ServerSetTimelineRange(AChannelID: Word; AStartDate, AEndDate: TDateTime);
begin
  if (not HasMainControl) then exit;

  MCCSetTimelineRanges(AChannelID, AStartDate, AEndDate);
  SECSetTimelineRanges(AChannelID, AStartDate, AEndDate);
end;

procedure TfrmChannel.ServerInputCueSheets(AChannelID: Word; AIndex: Integer; ACount: Integer);
begin
  if (frmAllChannels <> nil) then
    frmAllChannels.InputCueSheets(FCueSheetList, AChannelID, AIndex, ACount);

  if (not HasMainControl) then exit;

  MCCInputCueSheets(AIndex, ACount);
  SECInputCueSheets(AIndex, ACount);
end;

procedure TfrmChannel.ServerInputCueSheets(AIndex: Integer; AItem: PCueSheetItem);
begin
  if (frmAllChannels <> nil) then
    frmAllChannels.InputCueSheets(AIndex, AItem);

  if (not HasMainControl) then exit;

  MCCInputCueSheets(AIndex, AItem^);
  SECInputCueSheets(AIndex, AItem^);
end;

procedure TfrmChannel.ServerDeleteCueSheets(AChannelID: Word; ADeleteList: TCueSheetList);
begin
  if (frmAllChannels <> nil) then
    frmAllChannels.DeleteCueSheets(AChannelID, ADeleteList);

  if (not HasMainControl) then exit;

  MCCDeleteCueSheets(AChannelID, ADeleteList);
  SECDeleteCueSheets(AChannelID, ADeleteList);
end;

procedure TfrmChannel.ServerDeleteCueSheets(AEventID: TEventID);
begin
  if (frmAllChannels <> nil) then
    frmAllChannels.DeleteCueSheets(AEventID);

  if (not HasMainControl) then exit;

  MCCDeleteCueSheets(AEventID);
  SECDeleteCueSheets(AEventID);
end;

procedure TfrmChannel.ServerDeleteCueSheets(AChannelID: Word; AFromIndex, AToIndex: Integer);
begin
  if (frmAllChannels <> nil) then
    frmAllChannels.DeleteCueSheets(FCueSheetList, AChannelID, AFromIndex, AToIndex);

  if (not HasMainControl) then exit;

  MCCDeleteCueSheets(AChannelID, AFromIndex, AToIndex);
  SECDeleteCueSheets(AChannelID, AFromIndex, AToIndex);
end;

procedure TfrmChannel.ServerClearCueSheets(AChannelID: Word);
begin
  if (frmAllChannels <> nil) then
    frmAllChannels.ClearCueSheets(AChannelID);

  if (not HasMainControl) then exit;

  MCCClearCueSheets(AChannelID);
  SECClearCueSheets(AChannelID);
end;

procedure TfrmChannel.ServerSetCueSheetCurrs(AEventID: TEventID);
begin
  if (frmAllChannels <> nil) then
    frmAllChannels.SetCueSheetCurrs(AEventID);

  if (not HasMainControl) then exit;

  MCCSetCueSheetCurrs(AEventID);
  SECSetCueSheetCurrs(AEventID);
end;

procedure TfrmChannel.ServerSetCueSheetNexts(AEventID: TEventID);
begin
  if (frmAllChannels <> nil) then
    frmAllChannels.SetCueSheetNexts(AEventID);

  if (not HasMainControl) then exit;

  MCCSetCueSheetNexts(AEventID);
  SECSetCueSheetNexts(AEventID);
end;

procedure TfrmChannel.ServerSetCueSheetTargets(AEventID: TEventID);
begin
  if (frmAllChannels <> nil) then
    frmAllChannels.SetCueSheetTargets(AEventID);

  if (not HasMainControl) then exit;

  MCCSetCueSheetTargets(AEventID);
  SECSetCueSheetTargets(AEventID);
end;

procedure TfrmChannel.ServerInputChannelCueSheets(AChannelCueSheet: PChannelCueSheet);
begin
  if (not HasMainControl) then exit;

  if (AChannelCueSheet = nil) then exit;

  SECInputChannelCueSheets(AChannelCueSheet^);
end;

procedure TfrmChannel.ServerDeleteChannelCueSheets(AChannelCueSheet: PChannelCueSheet);
begin
  if (not HasMainControl) then exit;

  if (AChannelCueSheet = nil) then exit;

  SECDeleteChannelCueSheets(AChannelCueSheet^);
end;

procedure TfrmChannel.ServerClearChannelCueSheets(AChannelID: Word);
begin
  if (not HasMainControl) then exit;

  SECClearChannelCueSheets(AChannelID);
end;

procedure TfrmChannel.ServerFinishLoadCuesheets(AChannelID: Word; ACueSheetFileName: String);
begin
  if (not HasMainControl) then exit;

  SECFinishLoadCueSheets(AChannelID, ACueSheetFileName);
end;

procedure TfrmChannel.MCCBeginUpdates(AChannelID: Word);
var
  I: Integer;
  MCC: PMCC;
begin
  exit;
  if (not GV_SettingMCC.Use) then exit;
  if (not HasMainControl) then exit;

  for I := 0 to GV_MCCList.Count - 1 do
  begin
    MCC := GV_MCCList[I];
    if (MCC <> nil) and (MCC^.Alive) then
    begin
      MCCBeginUpdate(MCC^.HostIP, AChannelID);
    end;
  end;
end;

procedure TfrmChannel.MCCEndUpdates(AChannelID: Word);
var
  I: Integer;
  MCC: PMCC;
begin
  exit;
  if (not GV_SettingMCC.Use) then exit;
  if (not HasMainControl) then exit;

  for I := 0 to GV_MCCList.Count - 1 do
  begin
    MCC := GV_MCCList[I];
    if (MCC <> nil) and (MCC^.Alive) then
    begin
      MCCEndUpdate(MCC^.HostIP, AChannelID);
    end;
  end;
end;

procedure TfrmChannel.MCCSetOnAirs(AChannelID: Word; AIsOnAir: Boolean);
var
  I: Integer;
  MCC: PMCC;
begin
  if (not GV_SettingMCC.Use) then exit;
  if (not HasMainControl) then exit;

  for I := 0 to GV_MCCList.Count - 1 do
  begin
    MCC := GV_MCCList[I];
    if (MCC <> nil) and (MCC^.Alive) then
    begin
      frmSEC.MCCEventThread.SetOnAir(MCC, AChannelID, AIsOnAir);
    end;
  end;
end;

procedure TfrmChannel.MCCSetEventStatuses(AEventID: TEventID; AEventStatus: TEventStatus);
var
  I: Integer;
  MCC: PMCC;
begin
  if (not GV_SettingMCC.Use) then exit;
  if (not HasMainControl) then exit;

  for I := 0 to GV_MCCList.Count - 1 do
  begin
    MCC := GV_MCCList[I];
    if (MCC <> nil) and (MCC^.Alive) then
    begin
      frmSEC.MCCEventThread.SetEventStatus(MCC, AEventID, AEventStatus);
    end;
  end;
end;

procedure TfrmChannel.MCCSetMediaStatuses(AEventID: TEventID; AMediaStatus: TMediaStatus);
var
  I: Integer;
  MCC: PMCC;
begin
  if (not GV_SettingMCC.Use) then exit;
  if (not HasMainControl) then exit;

  for I := 0 to GV_MCCList.Count - 1 do
  begin
    MCC := GV_MCCList[I];
    if (MCC <> nil) and (MCC^.Alive) then
    begin
      frmSEC.MCCEventThread.SetMediaStatus(MCC, AEventID, AMediaStatus);
    end;
  end;
end;

procedure TfrmChannel.MCCSetTimelineRanges(AChannelID: Word; AStartDate, AEndDate: TDateTime);
var
  I: Integer;
  MCC: PMCC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_MCCList.Count - 1 do
  begin
    MCC := GV_MCCList[I];
    if (MCC <> nil) and (MCC^.Alive) then
    begin
      frmSEC.MCCEventThread.SetTimelineRange(MCC, AChannelID, AStartDate, AEndDate);
    end;
  end;
end;

procedure TfrmChannel.MCCInputCueSheets(AIndex: Integer; ACount: Integer = 0);
var
  I: Integer;
  MCC: PMCC;
begin
  if (not GV_SettingMCC.Use) then exit;
  if (not HasMainControl) then exit;

  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  if (ACount = 0) then
    ACount := FCueSheetList.Count
  else
  begin
    ACount := AIndex + ACount;
    if (ACount > FCueSheetList.Count) then
      ACount := FCueSheetList.Count;
  end;

  for I := AIndex to ACount - 1 do
    MCCInputCueSheets(I, FCueSheetList[I]^);
end;

procedure TfrmChannel.MCCInputCueSheets(AIndex: Integer; AItem: TCueSheetItem);
var
  I: Integer;
  MCC: PMCC;
begin
  if (not GV_SettingMCC.Use) then exit;
  if (not HasMainControl) then exit;

  for I := 0 to GV_MCCList.Count - 1 do
  begin
    MCC := GV_MCCList[I];
    if (MCC <> nil) and (MCC^.Alive) then
    begin
      frmSEC.MCCEventThread.InputCueSheet(MCC, AIndex, AItem);
    end;
  end;
end;

procedure TfrmChannel.MCCDeleteCueSheets(AChannelID: Word; ADeleteList: TCueSheetList);
var
  I: Integer;
  MCC: PMCC;
begin
  if (not GV_SettingMCC.Use) then exit;
  if (not HasMainControl) then exit;

  if (ADeleteList = nil) or (ADeleteList.Count <= 0) then exit;

  for I := ADeleteList.Count - 1 downto 0 do
    MCCDeleteCueSheets(ADeleteList[I]^.EventID);
end;

procedure TfrmChannel.MCCDeleteCueSheets(AEventID: TEventID);
var
  I: Integer;
  MCC: PMCC;
begin
  if (not GV_SettingMCC.Use) then exit;
  if (not HasMainControl) then exit;

  for I := 0 to GV_MCCList.Count - 1 do
  begin
    MCC := GV_MCCList[I];
    if (MCC <> nil) and (MCC^.Alive) then
      frmSEC.MCCEventThread.DeleteCueSheet(MCC, AEventID);
  end;
end;

procedure TfrmChannel.MCCDeleteCueSheets(AChannelID: Word; AFromIndex, AToIndex: Integer);
var
  I: Integer;
begin
  if (not GV_SettingMCC.Use) then exit;
  if (not HasMainControl) then exit;

  for I := AToIndex downto AFromIndex do
    MCCDeleteCueSheets(FCueSheetList[I]^.EventID);
end;

procedure TfrmChannel.MCCClearCueSheets(AChannelID: Word);
var
  I: Integer;
  MCC: PMCC;
begin
  if (not GV_SettingMCC.Use) then exit;
  if (not HasMainControl) then exit;

  for I := 0 to GV_MCCList.Count - 1 do
  begin
    MCC := GV_MCCList[I];
    if (MCC <> nil) and (MCC^.Alive) then
      frmSEC.MCCEventThread.ClearCueSheet(MCC, AChannelID);
  end;
end;

procedure TfrmChannel.MCCSetCueSheetCurrs(AEventID: TEventID);
var
  I: Integer;
  MCC: PMCC;
begin
  if (not GV_SettingMCC.Use) then exit;
  if (not HasMainControl) then exit;

  for I := 0 to GV_MCCList.Count - 1 do
  begin
    MCC := GV_MCCList[I];
    if (MCC <> nil) and (MCC^.Alive) then
    begin
      frmSEC.MCCEventThread.SetCueSheetCurr(MCC, AEventID);
    end;
  end;
end;

procedure TfrmChannel.MCCSetCueSheetNexts(AEventID: TEventID);
var
  I: Integer;
  MCC: PMCC;
begin
  if (not GV_SettingMCC.Use) then exit;
  if (not HasMainControl) then exit;

  for I := 0 to GV_MCCList.Count - 1 do
  begin
    MCC := GV_MCCList[I];
    if (MCC <> nil) and (MCC^.Alive) then
    begin
      frmSEC.MCCEventThread.SetCueSheetNext(MCC, AEventID);
    end;
  end;
end;

procedure TfrmChannel.MCCSetCueSheetTargets(AEventID: TEventID);
var
  I: Integer;
  MCC: PMCC;
begin
  if (not GV_SettingMCC.Use) then exit;
  if (not HasMainControl) then exit;

  for I := 0 to GV_MCCList.Count - 1 do
  begin
    MCC := GV_MCCList[I];
    if (MCC <> nil) and (MCC^.Alive) then
    begin
      frmSEC.MCCEventThread.SetCueSheetTarget(MCC, AEventID);
    end;
  end;
end;

procedure TfrmChannel.SECBeginUpdates(AChannelID: Word);
var
  I: Integer;
  SEC: PSEC;
begin
//  exit;
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
    begin
//      SECBeginUpdate(SEC^.HostIP, AChannelID);
      frmSEC.SECEventThread.SetBeginUpdate(SEC, AChannelID);
    end;
  end;
end;

procedure TfrmChannel.SECEndUpdates(AChannelID: Word);
var
  I: Integer;
  SEC: PSEC;
begin
//  exit;
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
    begin
//      SECEndUpdate(SEC^.HostIP, AChannelID);
      frmSEC.SECEventThread.SetEndUpdate(SEC, AChannelID);
    end;
  end;
end;

procedure TfrmChannel.SECSetOnAirs(AChannelID: Word; AIsOnAir: Boolean);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
    begin
//      SECSetOnAir(SEC^.HostIP, AChannelID, AIsOnAir);
      frmSEC.SECEventThread.SetOnAir(SEC, AChannelID, AIsOnAir);
    end;
  end;
end;

procedure TfrmChannel.SECSetEventStatuses(AEventID: TEventID; AEventStatus: TEventStatus);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
    begin
//      SECSetEventStatus(SEC^.HostIP, AEventID, AEventStatus);
      frmSEC.SECEventThread.SetEventStatus(SEC, AEventID, AEventStatus);
    end;
  end;
end;

procedure TfrmChannel.SECSetMediaStatuses(AEventID: TEventID; AMediaStatus: TMediaStatus);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
    begin
//      SECSetMediaStatus(SEC^.HostIP, AEventID, AMediaStatus);
      frmSEC.SECEventThread.SetMediaStatus(SEC, AEventID, AMediaStatus);
    end;
  end;
end;

procedure TfrmChannel.SECSetTimelineRanges(AChannelID: Word; AStartDate, AEndDate: TDateTime);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
    begin
//      SECSetTimelineRange(SEC^.HostIP, AChannelID, AStartDate, AEndDate);
      frmSEC.SECEventThread.SetTimelineRange(SEC, AChannelID, AStartDate, AEndDate);
    end;
  end;
end;

procedure TfrmChannel.SECInputCueSheets(AIndex: Integer; ACount: Integer);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  if (AIndex < 0) or (AIndex > FCueSheetList.Count - 1) then exit;

  if (ACount = 0) then
    ACount := FCueSheetList.Count
  else
  begin
    ACount := AIndex + ACount;
    if (ACount > FCueSheetList.Count) then
      ACount := FCueSheetList.Count;
  end;

  for I := AIndex to ACount - 1 do
    SECInputCueSheets(I, FCueSheetList[I]^);
end;

procedure TfrmChannel.SECInputCueSheets(AIndex: Integer; AItem: TCueSheetItem);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
    begin
      frmSEC.SECEventThread.InputCueSheet(SEC, AIndex, AItem);
    end;
  end;
end;

procedure TfrmChannel.SECDeleteCueSheets(AChannelID: Word; ADeleteList: TCueSheetList);
var
  I, J: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  if (ADeleteList = nil) or (ADeleteList.Count <= 0) then exit;

  for I := ADeleteList.Count - 1 downto 0 do
    SECDeleteCueSheets(ADeleteList[I]^.EventID);
end;

procedure TfrmChannel.SECDeleteCueSheets(AEventID: TEventID);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
      frmSEC.SECEventThread.DeleteCueSheet(SEC, AEventID);
  end;
end;

procedure TfrmChannel.SECDeleteCueSheets(AChannelID: Word; AFromIndex, AToIndex: Integer);
var
  I: Integer;
begin
  if (not HasMainControl) then exit;

  for I := AToIndex downto AFromIndex do
    SECDeleteCueSheets(FCueSheetList[I]^.EventID);
end;

procedure TfrmChannel.SECClearCueSheets(AChannelID: Word);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
//      SECClearCueSheet(SEC^.HostIP, AChannelID);
      frmSEC.SECEventThread.ClearCueSheet(SEC, ChannelID);
  end;
end;

procedure TfrmChannel.SECSetCueSheetCurrs(AEventID: TEventID);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
    begin
//      SECSetCueSheetCurr(SEC^.HostIP, AEventID);
      frmSEC.SECEventThread.SetCueSheetCurr(SEC, AEventID);
    end;
  end;
end;

procedure TfrmChannel.SECSetCueSheetNexts(AEventID: TEventID);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
    begin
//      SECSetCueSheetNext(SEC^.HostIP, AEventID);
      frmSEC.SECEventThread.SetCueSheetNext(SEC, AEventID);
      Assert(False, GetChannelLogStr(lsNormal, ChannelID, Format('SECSetCueSheetNexts, SEC=%d, ID=%s', [SEC^.ID, EventIDToString(AEventID)])));
    end;
  end;
end;

procedure TfrmChannel.SECSetCueSheetTargets(AEventID: TEventID);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
//      SECSetCueSheetTarget(SEC^.HostIP, AEventID);
      frmSEC.SECEventThread.SetCueSheetTarget(SEC, AEventID);
  end;
end;

procedure TfrmChannel.SECInputChannelCueSheets(AChannelCueSheet: TChannelCueSheet);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
      frmSEC.SECEventThread.InputChannelCueSheet(SEC, ChannelID, AChannelCueSheet);
  end;
end;

procedure TfrmChannel.SECDeleteChannelCueSheets(AChannelCueSheet: TChannelCueSheet);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
      frmSEC.SECEventThread.DeleteChannelCueSheet(SEC, ChannelID, AChannelCueSheet);
  end;
end;

procedure TfrmChannel.SECClearChannelCueSheets(AChannelID: Word);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
      frmSEC.SECEventThread.ClearChannelCueSheet(SEC, AChannelID);
  end;
end;

procedure TfrmChannel.SECFinishLoadCueSheets(AChannelID: Word; ACueSheetFileName: String);
var
  I: Integer;
  SEC: PSEC;
begin
  if (not HasMainControl) then exit;

  for I := 0 to GV_SECList.Count - 1 do
  begin
    SEC := GV_SECList[I];
    if (SEC <> nil) and (SEC <> GV_SECMine) and (SEC^.Alive) then
      frmSEC.SECEventThread.FinishLoadCueSheet(SEC, AChannelID, ACueSheetFileName);
  end;
end;

{ TChannelTimerThread }

constructor TChannelTimerThread.Create(AChannelForm: TfrmChannel);
begin
  FChannelForm := AChannelForm;

  FCloseEvent := CreateEvent(nil, True, False, nil);

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TChannelTimerThread.Destroy;
begin
  CloseHandle(FCloseEvent);

  inherited Destroy;
end;

procedure TChannelTimerThread.Terminate;
begin
  inherited Terminate;

  SetEvent(FCloseEvent);
end;

procedure TChannelTimerThread.DoCueSheetCheck;
var
  CurrentTime: TDateTime;

  NextStartTime: TDateTime;

  SaveCurr: PCueSheetItem;
  CurrItem: PCueSheetItem;
  CurrIndex: Integer;

  SaveNext: PCueSheetItem;
  NextItem: PCueSheetItem;
  NextIndex: Integer;

  InputIndex: Integer;
begin
  if (not HasMainControl) then exit;

  with FChannelForm do
  begin
    if (not FChannelOnAir) then exit;

    CurrentTime := Now;

    // ���� �̺�Ʈ�� ��������̰� ���� ���۽ð��� AutoIncreaseDurationBefore ���� ū ���� ���
    if (CueSheetNext <> nil) and
       (CueSheetNext^.EventMode = EM_MAIN) and
       (CueSheetNext^.StartMode = SM_MANUAL) and
       (CueSheetNext^.EventStatus.State <= esCued) then
    begin
      NextStartTime := EventTimeToDateTime(CueSheetNext^.StartTime, ChannelFrameRateType);
      if (CompareDateTime(NextStartTime, CurrentTime) > 0) then
        exit;
    end;

    if (CueSheetCurr <> nil) then
      CurrIndex := GetCueSheetIndexByItem(CueSheetCurr)
    else
      CurrIndex := 0;

    SaveCurr := CueSheetCurr;
    CurrItem := GetMainItemByInRangeTime(CurrIndex, CurrentTime);
    if (SaveCurr <> CurrItem) then
    begin
      CueSheetCurr := CurrItem;

{      InputIndex := GetNextOnAirMainIndexByItem(CueSheetCurr);
//      OnAirInputEvents(InputIndex, 1);
 }
    end;


{    if (CueSheetCurr <> nil) then
      NextItem := GetNextMainItemByItem(CueSheetCurr)
    else //if (CueSheetNext = nil) then
      NextItem := GetStartOnAirMainItem; }

    if (CueSheetNext <> nil) then
      NextIndex := GetCueSheetIndexByItem(CueSheetNext)
    else
      NextIndex := 0;

    SaveNext := CueSheetNext;
    NextItem := GetMainItemByStartTime(NextIndex, CurrentTime);

    if (SaveNext <> NextItem) then
    begin
      frmSEC.DCSEventThread.ResetMediaCheckIndex;
      CueSheetNext := NextItem;

      if (CueSheetNext <> nil) then
      begin
        NextIndex := GetCueSheetIndexByItem(CueSheetNext);
        if (NextIndex >= 0) then
        begin
//          PostMessage(FChannelForm.Handle, WM_INPUT_NEXT_EVENT, NextIndex, GV_SettingOption.MaxInputEventCount);
          OnAirInputEvents(NextIndex, GV_SettingOption.MaxInputEventCount, True);
        end;
      end
      else
      begin
        // ���� �̺�Ʈ�� ���ٴ� ��� ȭ�� �ʿ�, Post Message�� ó��
      end;
    end;

{    if (CueSheetCurr <> nil) then
    begin
      CueSheetNext := GetNextMainItemByItem(CueSheetCurr);

      if (CueSheetNext = nil) then
      begin
        // ���� �̺�Ʈ�� ���ٴ� ��� ȭ�� �ʿ�, Post Message�� ó��
      end;
    end
//    else if (CueSheetNext = nil) then
//      CueSheetNext := GetStartOnAirMainItem; }
  end;
end;

procedure TChannelTimerThread.Execute;
var
  WaitList: array[0..1] of THandle;
begin
  WaitList[0] := GV_TimerExecuteEvent;
//  WaitList[1] := GV_TimerCancelEvent;
  WaitList[1] := FCloseEvent;
  while not Terminated do
  begin
    if (WaitForMultipleObjects(2, @WaitList, False, INFINITE) <> WAIT_OBJECT_0) then
      break; // Terminate thread when GV_TimerCancelEvent is signaled

//    DoCueSheetCheck;

    if (FChannelForm <> nil) and (FChannelForm.HandleAllocated) then
    begin
      PostMessage(FChannelForm.Handle, WM_UPDATE_CHANNEL_TIME, 0, 0);

      PostMessage(FChannelForm.Handle, WM_UPDATE_ERROR_DISPLAY, 0, 0);
    end;

    if (frmAllChannels <> nil) and (frmAllChannels.HandleAllocated) then
      PostMessage(frmAllChannels.Handle, WM_UPDATE_ERROR_DISPLAY, 0, 0);

{    if (GV_SettingOption.AutoLoadCuesheet) then
    begin
      Inc(FChannelForm.FAutoLoadIntervalTime);
      if (FChannelForm.FAutoLoadIntervalTime > (TimecodeToMilliSec(GV_SettingOption.AutoLoadCuesheetInterval) div 1000)) then
        FChannelForm.FAutoLoadThread.AutoLoad;
    end;

    if (GV_SettingOption.AutoEjectCuesheet) then
    begin
      Inc(FChannelForm.FAutoEjectIntervalTime);
      if (FChannelForm.FAutoEjectIntervalTime > (TimecodeToMilliSec(GV_SettingOption.AutoEjectCuesheetInterval) div 1000)) then
        FChannelForm.FAutoEjectThread.AutoEject;
    end;

    Inc(FChannelForm.FMediaCheckIntervalTime);
    if (FChannelForm.FMediaCheckIntervalTime > (TimecodeToMilliSec(GV_SettingOption.MediaCheckInterval) div 1000)) then
      FChannelForm.FMediaCheckThread.MediaCheck; }
  end;
end;

{ TChannelCueSheetCheckThread }

constructor TChannelCueSheetCheckThread.Create(AChannelForm: TfrmChannel);
begin
  FChannelForm := AChannelForm;

  FCloseEvent := CreateEvent(nil, True, False, nil);

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TChannelCueSheetCheckThread.Destroy;
begin
  CloseHandle(FCloseEvent);

  inherited Destroy;
end;

procedure TChannelCueSheetCheckThread.Terminate;
begin
  inherited Terminate;

  SetEvent(FCloseEvent);
end;

procedure TChannelCueSheetCheckThread.DoCueSheetCheck;
var
  CurrentTime: TDateTime;

  NextStartTime: TDateTime;

  SaveCurr: PCueSheetItem;
  CurrItem: PCueSheetItem;
  CurrIndex: Integer;

  SaveNext: PCueSheetItem;
  NextItem: PCueSheetItem;
  NextIndex: Integer;

  InputIndex: Integer;
begin
  if (not HasMainControl) then exit;

  with FChannelForm do
  begin
    if (not FChannelOnAir) then exit;

    Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Start DoCueSheetCheck procedure.'));

    CurrentTime := Now;

    // ���� �̺�Ʈ�� ��������̰� ���� ���۽ð��� AutoIncreaseDurationBefore ���� ū ���� ���
    if (CueSheetNext <> nil) and
       (CueSheetNext^.EventMode = EM_MAIN) and
       (CueSheetNext^.StartMode = SM_MANUAL) and
       (CueSheetNext^.EventStatus.State <= esCued) then
    begin
      NextStartTime := EventTimeToDateTime(CueSheetNext^.StartTime, ChannelFrameRateType);
      if (CompareDateTime(NextStartTime, CurrentTime) > 0) then
        exit;
    end;

    if (CueSheetCurr <> nil) then
    begin
      if (CueSheetCurr = FCueSheetLoopLast) then
        CurrIndex := GetCueSheetIndexByItem(FCueSheetLoopFirst)
      else
        CurrIndex := GetCueSheetIndexByItem(CueSheetCurr);
    end
    else
      CurrIndex := 0;

    SaveCurr := CueSheetCurr;
    CurrItem := GetMainItemByInRangeTime(CurrIndex, CurrentTime);
    if (SaveCurr <> CurrItem) then
    begin
//      if (CueSheetCurr <> nil) and (CueSheetCurr^.StartMode = SM_LOOP) then
//        UpdateLoopCueSheet(CueSheetCurr);

      CurrIndex := GetCueSheetIndexByItem(CueSheetCurr);
      PostMessage(FChannelForm.Handle, WM_EXECUTE_LOOP_UPDATE_EVENT, CurrIndex, LParam(CueSheetCurr));

      CueSheetCurr := CurrItem;

      CurrIndex := GetCueSheetIndexByItem(CurrItem);
      PostMessage(FChannelForm.Handle, WM_EXECUTE_LOOP_INPUT_EVENT, CurrIndex, LParam(CurrItem));

//      if (CueSheetCurr^.StartMode = SM_LOOP) then
//        InputLoopEvent(CueSheetCurr);

{      InputIndex := GetNextOnAirMainIndexByItem(CueSheetCurr);
//      OnAirInputEvents(InputIndex, 1);
 }
    end;


{    if (CueSheetCurr <> nil) then
      NextItem := GetNextMainItemByItem(CueSheetCurr)
    else //if (CueSheetNext = nil) then
      NextItem := GetStartOnAirMainItem; }

    if (CueSheetNext <> nil) then
      NextIndex := GetCueSheetIndexByItem(CueSheetNext)
    else
      NextIndex := 0;

    SaveNext := CueSheetNext;
    NextItem := GetMainItemByStartTime(NextIndex, CurrentTime);

    if (SaveNext <> NextItem) then
    begin
//      if (CueSheetCurr <> nil) and (CueSheetCurr^.StartMode = SM_LOOP) then
//        UpdateLoopCueSheet(CueSheetCurr);

      frmSEC.DCSEventThread.ResetMediaCheckIndex;
      CueSheetNext := NextItem;

//      if (CueSheetNext <> nil) and (CueSheetNext^.StartMode = SM_LOOP) then
//        InputLoopEvent(CueSheetNext);

      if (CueSheetNext <> nil) then
      begin
        NextIndex := GetCueSheetIndexByItem(CueSheetNext);
        if (NextIndex >= 0) then
        begin
//          PostMessage(FChannelForm.Handle, WM_INPUT_NEXT_EVENT, NextIndex, GV_SettingOption.MaxInputEventCount);
          OnAirInputEvents(NextIndex, GV_SettingOption.MaxInputEventCount, True);
          Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'TChannelCueSheetCheckThread.DoCueSheetCheck OnAirInputEvents'));
        end;
      end
      else
      begin
        // ���� �̺�Ʈ�� ���ٴ� ��� ȭ�� �ʿ�, Post Message�� ó��
      end;
    end;

{    if (CueSheetCurr <> nil) then
    begin
      CueSheetNext := GetNextMainItemByItem(CueSheetCurr);

      if (CueSheetNext = nil) then
      begin
        // ���� �̺�Ʈ�� ���ٴ� ��� ȭ�� �ʿ�, Post Message�� ó��
      end;
    end
//    else if (CueSheetNext = nil) then
//      CueSheetNext := GetStartOnAirMainItem; }

    Assert(False, GetChannelLogStr(lsNormal, ChannelID, 'Finish DoCueSheetCheck procedure.'));
  end;
end;

procedure TChannelCueSheetCheckThread.Execute;
var
  WaitList: array[0..1] of THandle;
begin
  WaitList[0] := GV_TimerExecuteEvent;
//  WaitList[1] := GV_TimerCancelEvent;
  WaitList[1] := FCloseEvent;
  while not Terminated do
  begin
    if (WaitForMultipleObjects(2, @WaitList, False, INFINITE) <> WAIT_OBJECT_0) then
      break; // Terminate thread when GV_TimerCancelEvent is signaled

    DoCueSheetCheck;
  end;
end;

{ TChannelEventControlThread }

constructor TChannelEventControlThread.Create(AChannelForm: TfrmChannel);
begin
  FChannelForm := AChannelForm;

  FInputIndex := -1;
  FInputCount := 0;

  FInputEvent := CreateEvent(nil, True, False, nil);
  FDeleteEvent := CreateEvent(nil, True, False, nil);
  FClearEvent := CreateEvent(nil, True, False, nil);
  FTakeEvent := CreateEvent(nil, True, False, nil);
  FHoldEvent := CreateEvent(nil, True, False, nil);
  FChangeDurationEvent := CreateEvent(nil, True, False, nil);
  FCloseEvent := CreateEvent(nil, True, False, nil);

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TChannelEventControlThread.Destroy;
begin
  CloseHandle(FInputEvent);
  CloseHandle(FDeleteEvent);
  CloseHandle(FClearEvent);
  CloseHandle(FTakeEvent);
  CloseHandle(FHoldEvent);
  CloseHandle(FChangeDurationEvent);
  CloseHandle(FCloseEvent);

  inherited Destroy;
end;

procedure TChannelEventControlThread.Terminate;
begin
  inherited Terminate;

  ResetEvent(FInputEvent);
  ResetEvent(FDeleteEvent);
  ResetEvent(FClearEvent);
  ResetEvent(FTakeEvent);
  ResetEvent(FHoldEvent);
  ResetEvent(FChangeDurationEvent);
  SetEvent(FCloseEvent);
end;

procedure TChannelEventControlThread.InputEvent(AInputIndex: Integer; AInputCount: Integer);
begin
  FInputIndex := AInputIndex;
  FInputCount := AInputCount;

  SetEvent(FInputEvent);
end;

procedure TChannelEventControlThread.DoEventInput;
begin
  with FChannelForm do
  begin
    OnAirInputEvents(FInputIndex, FInputCount);
  end;

  ResetEvent(FInputEvent);
end;

procedure TChannelEventControlThread.Execute;
var
  R: Cardinal;
  WaitList: array[0..6] of THandle;
begin
  WaitList[0] := FInputEvent;
  WaitList[1] := FDeleteEvent;
  WaitList[2] := FClearEvent;
  WaitList[3] := FTakeEvent;
  WaitList[4] := FHoldEvent;
  WaitList[5] := FChangeDurationEvent;
  WaitList[6] := FCloseEvent;
  while not Terminated do
  begin
    R := WaitForMultipleObjects(7, @WaitList, False, INFINITE);
    case R of
      WAIT_OBJECT_0: DoEventInput;
//      WAIT_OBJECT_0 + 1: DoEventDelete;
//      WAIT_OBJECT_0 + 2: DoEventClear;
//      WAIT_OBJECT_0 + 3: DoEventTake;
//      WAIT_OBJECT_0 + 4: DoEventHold;
//      WAIT_OBJECT_0 + 5: DoEventChangeDuration;
      WAIT_OBJECT_0 + 6: break;
    end;
  end;
end;

{ TChannelAutoLoadPlayListThread }

constructor TChannelAutoLoadPlayListThread.Create(AChannelForm: TfrmChannel);
begin
  FChannelForm := AChannelForm;

//  FAutoLoadEvent := CreateEvent(nil, True, False, nil);
  FCloseEvent := CreateEvent(nil, True, False, nil);

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TChannelAutoLoadPlayListThread.Destroy;
begin
//  CloseHandle(FAutoLoadEvent);
  CloseHandle(FCloseEvent);

  inherited Destroy;
end;

procedure TChannelAutoLoadPlayListThread.Terminate;
begin
  inherited Terminate;

//  ResetEvent(FAutoLoadEvent);
  SetEvent(FCloseEvent);
end;

{procedure TChannelAutoLoadPlayListThread.AutoLoad;
begin
  Assert(False, GetChannelLogStr(lsNormal, FChannelForm.ChannelID, 'TChannelAutoLoadPlayListThread AutoLoad procedure.'));

//  FChannelForm.FAutoLoadIntervalTime := 0;

  SetEvent(FAutoLoadEvent);
end; }

procedure TChannelAutoLoadPlayListThread.DoAutoLoad;
begin
  if (not HasMainControl) then exit;

  Assert(False, GetChannelLogStr(lsNormal, FChannelForm.ChannelID, 'TChannelAutoLoadPlayListThread DoAutoLoad procedure.'));

//  ResetEvent(FAutoLoadEvent);

  PostMessage(FChannelForm.Handle, WM_EXECUTE_AUTO_LOAD_PLAYLIST, 0, 0);
end;

procedure TChannelAutoLoadPlayListThread.Execute;
var
  R: Cardinal;
  WaitList: array[0..1] of THandle;
begin
  while not Terminated do
  begin
    R := WaitForSingleObject(FCloseEvent, TimecodeToMilliSec(GV_SettingOption.AutoLoadCuesheetInterval, FR_30));
    if (R = WAIT_OBJECT_0) then break;

    DoAutoLoad;
  end;

{  WaitList[0] := FAutoLoadEvent;
  WaitList[1] := FCloseEvent;
  while not Terminated do
  begin
    R := WaitForMultipleObjects(2, @WaitList, False, INFINITE);
    case R of
      WAIT_OBJECT_0: DoAutoLoad;
      WAIT_OBJECT_0 + 1: break;
    end;
  end; }
end;

{ TChannelAutoEjectPlayListThread }

constructor TChannelAutoEjectPlayListThread.Create(AChannelForm: TfrmChannel);
begin
  FChannelForm := AChannelForm;

//  FAutoEjectEvent := CreateEvent(nil, True, False, nil);
  FCloseEvent := CreateEvent(nil, True, False, nil);

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TChannelAutoEjectPlayListThread.Destroy;
begin
  Terminate;

//  CloseHandle(FAutoEjectEvent);
  CloseHandle(FCloseEvent);

  inherited Destroy;
end;

procedure TChannelAutoEjectPlayListThread.Terminate;
begin
  inherited Terminate;

//  ResetEvent(FAutoEjectEvent);
  SetEvent(FCloseEvent);
end;

{procedure TChannelAutoEjectPlayListThread.AutoEject;
begin
  Assert(False, GetChannelLogStr(lsNormal, FChannelForm.ChannelID, 'TChannelAutoEjectPlayListThread AutoEject procedure.'));

  FChannelForm.FAutoEjectIntervalTime := 0;

  SetEvent(FAutoEjectEvent);
end; }

procedure TChannelAutoEjectPlayListThread.DoAutoEject;
begin
  if (not HasMainControl) then exit;

  Assert(False, GetChannelLogStr(lsNormal, FChannelForm.ChannelID, 'TChannelAutoEjectPlayListThread DoAutoEject procedure.'));

//  ResetEvent(FAutoEjectEvent);

  PostMessage(FChannelForm.Handle, WM_EXECUTE_AUTO_EJECT_PLAYLIST, 0, 0);
end;

procedure TChannelAutoEjectPlayListThread.Execute;
var
  R: Cardinal;
  WaitList: array[0..1] of THandle;
begin
  while not Terminated do
  begin
    R := WaitForSingleObject(FCloseEvent, TimecodeToMilliSec(GV_SettingOption.AutoEjectCuesheetInterval, FR_30));
    if (R = WAIT_OBJECT_0) then break;

    DoAutoEject;
  end;

{  WaitList[0] := FAutoEjectEvent;
  WaitList[1] := FCloseEvent;
  while not Terminated do
  begin
    R := WaitForMultipleObjects(2, @WaitList, False, INFINITE);
    case R of
      WAIT_OBJECT_0: DoAutoEject;
      WAIT_OBJECT_0 + 1: break;
    end;
  end; }
end;

{ TChannelMediaCheckThread }

constructor TChannelMediaCheckThread.Create(AChannelForm: TfrmChannel);
begin
  FChannelForm := AChannelForm;

  FMediaCheckEvent := CreateEvent(nil, True, False, nil);
  FCloseEvent := CreateEvent(nil, True, False, nil);

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TChannelMediaCheckThread.Destroy;
begin
  CloseHandle(FMediaCheckEvent);
  CloseHandle(FCloseEvent);

  inherited Destroy;
end;

procedure TChannelMediaCheckThread.Terminate;
begin
  inherited Terminate;

  ResetEvent(FMediaCheckEvent);
  SetEvent(FCloseEvent);
end;

procedure TChannelMediaCheckThread.MediaCheck;
begin
//  FChannelForm.FMediaCheckIntervalTime := 0;

  SetEvent(FMediaCheckEvent);
end;

procedure TChannelMediaCheckThread.DoMediaCheck;
var
  Index: Integer;
  I, J: Integer;
  Item, ParentItem: PCueSheetItem;

  StartTime: TDateTime;

  Source: PSource;
  SourceHandles: TSourceHandleList;

  R: Integer;
  MediaExist: Boolean;
  MediaDuration: TTimecode;
  EventDuration: TTimecode;
begin
  ResetEvent(FMediaCheckEvent);

  if (not HasMainControl) then exit;

  FChannelForm.MediaCheck;
end;

procedure TChannelMediaCheckThread.Execute;
var
  R: Cardinal;
  WaitList: array[0..1] of THandle;
begin
  WaitList[0] := FMediaCheckEvent;
  WaitList[1] := FCloseEvent;
  while not Terminated do
  begin
    R := WaitForMultipleObjects(2, @WaitList, False, TimecodeToMilliSec(GV_SettingTimeParameter.MediaCheckInterval, FR_30));
    if (R = (WAIT_OBJECT_0 + 1)) then break;

    DoMediaCheck;

{    case R of
      WAIT_OBJECT_0: DoMediaCheck;
      WAIT_OBJECT_0 + 1: break;
    end;  }
  end;
end;

{ TChannelBlankCheckThread }

constructor TChannelBlankCheckThread.Create(AChannelForm: TfrmChannel);
begin
  FChannelForm := AChannelForm;

  FBlankCheckEvent := CreateEvent(nil, True, False, nil);
  FCloseEvent := CreateEvent(nil, True, False, nil);

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TChannelBlankCheckThread.Destroy;
begin
  CloseHandle(FBlankCheckEvent);
  CloseHandle(FCloseEvent);

  inherited Destroy;
end;

procedure TChannelBlankCheckThread.Terminate;
begin
  inherited Terminate;

  ResetEvent(FBlankCheckEvent);
  SetEvent(FCloseEvent);
end;

procedure TChannelBlankCheckThread.BlankCheck;
begin
//  FChannelForm.FBlankCheckIntervalTime := 0;

  SetEvent(FBlankCheckEvent);
end;

procedure TChannelBlankCheckThread.DoBlankCheck;
var
  Index: Integer;
  I, J: Integer;
  Item, ParentItem: PCueSheetItem;

  StartTime: TDateTime;

  Source: PSource;
  SourceHandles: TSourceHandleList;

  R: Integer;
  MediaExist: Boolean;
  MediaDuration: TTimecode;
  EventDuration: TTimecode;
begin
  if (FWarningDialog <> nil) and (FWarningDialog.HandleAllocated) then exit;

  ResetEvent(FBlankCheckEvent);

  if (not HasMainControl) then exit;

  FChannelForm.BlankCheck;
end;

procedure TChannelBlankCheckThread.Execute;
var
  R: Cardinal;
  WaitList: array[0..1] of THandle;
begin
  WaitList[0] := FBlankCheckEvent;
  WaitList[1] := FCloseEvent;
  while not Terminated do
  begin
    R := WaitForMultipleObjects(2, @WaitList, False, TimecodeToMilliSec(GV_SettingTimeParameter.BlankCheckInterval, FR_30));
    if (R = (WAIT_OBJECT_0 + 1)) then break;

    DoBlankCheck;

{    case R of
      WAIT_OBJECT_0: DoBlankCheck;
      WAIT_OBJECT_0 + 1: break;
    end;  }
  end;
end;

{ TChannelInspectThread }

constructor TChannelInspectThread.Create(AChannelForm: TfrmChannel);
begin
  FChannelForm := AChannelForm;

  FInspectEvent := CreateEvent(nil, True, False, nil);
  FCloseEvent := CreateEvent(nil, True, False, nil);

  FIsCancel := False;

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TChannelInspectThread.Destroy;
begin
  CloseHandle(FInspectEvent);
  CloseHandle(FCloseEvent);

  inherited Destroy;
end;

procedure TChannelInspectThread.Terminate;
begin
  inherited Terminate;

  ResetEvent(FInspectEvent);
  SetEvent(FCloseEvent);
end;

procedure TChannelInspectThread.Inspect;
begin
  SetEvent(FInspectEvent);
end;

procedure TChannelInspectThread.Cancel;
begin
  FIsCancel := True;
end;

procedure TChannelInspectThread.DoInspect;
var
  CurrTime: TDateTime;
  BaseItem: PCueSheetItem;
  BaseIndex: Integer;
  BaseEndTimeE: TEventTime;
  I, J: Integer;

  EndTimeE: TEventTime;

  Index: Integer;
  Item: PCueSheetItem;

  Source: PSource;

  PItem: PCueSheetItem;
  PIndex: Integer;
  PGroupNo: Integer;
begin
  FIsCancel := False;
  ResetEvent(FInspectEvent);

  if (not HasMainControl) then exit;

  // ���� �ð�
  CurrTime := Now;

  with FChannelForm do
  begin
    if (CueSheetCurr <> nil) then
      Index := GetCueSheetIndexByItem(CueSheetCurr)
    else if (CueSheetNext <> nil) then
      Index := GetCueSheetIndexByItem(CueSheetNext)
    else
      Index := 0;

    // ���� �ð� ������ �̺�Ʈ ���� �˻�
    BaseItem := GetMainItemByStartTime(Index, CurrTime);
    if (BaseItem = nil) then exit;

    BaseIndex := GetCueSheetIndexByItem(BaseItem);

    BaseEndTimeE := GetEventEndTime(BaseItem^.StartTime, BaseItem^.DurationTC, ChannelFrameRateType);

    I := BaseIndex;
    while (not Terminated) and (not FIsCancel) and (I < FCueSheetList.Count) do
    begin
      Item := FCueSheetList[I];
//      FillChar(Item^.EventStatus, SizeOf(TEventStatus), #0);

      // ���� �̺�Ʈ�� �ð� �˻�
      if (I > BaseIndex) and (Item^.EventMode = EM_MAIN) then
      begin
        if (CompareEventTime(BaseEndTimeE, Item^.StartTime, ChannelFrameRateType) > 0)  then
        begin
          // �ð� �ߺ�
          Item^.EventStatus.State := esError;
          Item^.EventStatus.ErrorCode := (Item^.EventStatus.ErrorCode or E_DUPLICATED_START_TIME);
        end
        else if (CompareEventTime(BaseEndTimeE, Item^.StartTime, ChannelFrameRateType) < 0)  then
        begin
          // �ð� ����
          Item^.EventStatus.State := esError;
          Item^.EventStatus.ErrorCode := (Item^.EventStatus.ErrorCode or E_BLANK_START_TIME);
        end;

        BaseEndTimeE := GetEventEndTime(Item^.StartTime, Item^.DurationTC, ChannelFrameRateType);
      end;

      Source := GetSourceByName(String(Item^.Source));
      if (Source = nil) then
      begin
        // �ҽ� ����
        Item^.EventStatus.ErrorCode := (Item^.EventStatus.ErrorCode or E_INVALID_DEVICE_NAME);
      end
      else
      begin
        if (Source^.SourceType in [ST_VSDEC, ST_VCR, ST_CART, ST_CG]) and
           (StrLen(Item^.MediaId) = 0) then
        begin
          // Player �ҽ��ε� �̵��ID�� ����
          Item^.EventStatus.ErrorCode := (Item^.EventStatus.ErrorCode or E_EMPTY_MEDIA_ID);
        end;

        if (Item^.EventMode in [EM_JOIN, EM_SUB]) then
        begin
          // �̺�Ʈ �׷쳻 �ҽ� �ߺ� �˻�
          PItem := GetParentCueSheetItemByItem(Item);
          if (PItem <> nil) then
          begin
            PIndex := GetCueSheetIndexByItem(PItem);
            while (PItem <> nil) and (PItem^.GroupNo = Item^.GroupNo) do
            begin
              if (PItem <> Item) and (StrComp(PItem^.Source, Item^.Source) = 0) then
              begin
                Item^.EventStatus.ErrorCode := (Item^.EventStatus.ErrorCode or E_DUPLICATED_DEVICE);
                break;
              end;

              Inc(PIndex);
              PItem := GetCueSheetItemByIndex(PIndex);
            end;
          end;
        end;

        // �ҽ� ���� ��� �˻�
        if (not Source^.SuccessiveUse) then
        begin
          PItem := GetBeforeMainItemByItem(Item);
          if (PItem <> nil) then
          begin
            PIndex := GetCueSheetIndexByItem(PItem);
            PGroupNo := PItem^.GroupNo;
            while (PItem <> nil) and (PItem^.GroupNo = PGroupNo) do
            begin
              if (StrComp(PItem^.Source, Item^.Source) = 0) then
              begin
                Item^.EventStatus.ErrorCode := (Item^.EventStatus.ErrorCode or E_NOT_SUCCESSIVE_DEVICE);
                break;
              end;

              Inc(PIndex);
              PItem := GetCueSheetItemByIndex(PIndex);
            end;
          end;
        end;
      end;

      if (Item^.EventStatus.ErrorCode <> E_NO_ERROR) then
        Item^.EventStatus.State := esError;

      Inc(I);
    end;

  end;
end;

procedure TChannelInspectThread.Execute;
var
  R: Cardinal;
  WaitList: array[0..1] of THandle;
begin
  WaitList[0] := FInspectEvent;
  WaitList[1] := FCloseEvent;
  while not Terminated do
  begin
    R := WaitForMultipleObjects(2, @WaitList, False, INFINITE);
    if (R = (WAIT_OBJECT_0 + 1)) then break;

    DoInspect;

{    case R of
      WAIT_OBJECT_0: DoInspect;
      WAIT_OBJECT_0 + 1: break;
    end;  }
  end;
end;

end.
