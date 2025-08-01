unit UnitTimelineChannel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitWorkForm, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, WMTools, WMControls, Vcl.ExtCtrls,
  UnitCommons, UnitConsts;

type
  TTimelineTimerThread = class;

  TfrmTimelineChannel = class(TfrmWork)
    pnlChannel: TWMPanel;
    lblChannelPlayedTime: TLabel;
    lblChannelName: TLabel;
    lblChannelOnair: TLabel;
    lblChannelRemainingTime: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FChannelID: Word;

    FTimerThread: TTimelineTimerThread;

    procedure Initialize;
    procedure Finalize;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AChannelID: Word; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer); overload;
  end;

  TTimelineTimerThread = class(TThread)
  private
    FTimelineChannelForm: TfrmTimelineChannel;
  protected
    procedure Execute; override;
  public
    constructor Create(ATimelineChannelForm: TfrmTimelineChannel);
    destructor Destroy; override;
  end;

var
  frmTimelineChannel: TfrmTimelineChannel;

implementation

uses UnitTimeline, System.DateUtils, System.Math;

{$R *.dfm}

procedure TfrmTimelineChannel.WndProc(var Message: TMessage);
begin
  inherited;
  case Message.Msg of
    WM_UPDATE_CHANNEL_TIME:
    begin
    end;

    WM_UPDATE_CURR_EVENT:
    begin
    end;

    WM_UPDATE_NEXT_EVENT:
    begin
    end;

  end;
end;

constructor TfrmTimelineChannel.Create(AOwner: TComponent; AChannelID: Word; ACombine: Boolean; ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited Create(AOwner, ACombine, ALeft, ATop, AWidth, AHeight);

  FChannelID := AChannelID;
end;

procedure TfrmTimelineChannel.Initialize;
var
  Channel: PChannel;
begin
  Channel := GetChannelByID(FChannelID);
  if (Channel <> nil) then
  begin
    lblChannelName.Caption := String(Channel^.Name);
  end;

  lblChannelPlayedTime.Caption    := IDLE_TIME;
  lblChannelRemainingTime.Caption := IDLE_TIME;

  FTimerThread := TTimelineTimerThread.Create(Self);
  FTimerThread.Resume;
end;

procedure TfrmTimelineChannel.Finalize;
begin
  if (FTimerThread <> nil) then
  begin
    FTimerThread.Terminate;
    FTimerThread.WaitFor;
    FreeAndNil(FTimerThread);
  end;
end;

procedure TfrmTimelineChannel.FormCreate(Sender: TObject);
begin
  inherited;
  Initialize;
end;

procedure TfrmTimelineChannel.FormDestroy(Sender: TObject);
begin
  inherited;
  Finalize;
end;

procedure TfrmTimelineChannel.FormResize(Sender: TObject);
var
  Zoom: Integer;
begin
  inherited;
end;

{ TTimelineTimerThread }

constructor TTimelineTimerThread.Create(ATimelineChannelForm: TfrmTimelineChannel);
begin
  FTimelineChannelForm := ATimelineChannelForm;

  FreeOnTerminate := False;
  inherited Create(True);
end;

destructor TTimelineTimerThread.Destroy;
begin
  inherited Destroy;
end;

procedure TTimelineTimerThread.Execute;
var
  WaitList: array[0..1] of THandle;
begin
  WaitList[0] := GV_TimerExecuteEvent;
  WaitList[1] := GV_TimerCancelEvent;
  while not Terminated do
  begin
    if (WaitForMultipleObjects(2, @WaitList, False, INFINITE) <> WAIT_OBJECT_0) then
      break; // Terminate thread when GV_TimerCancelEvent is signaled

    PostMessage(FTimelineChannelForm.Handle, WM_UPDATE_CHANNEL_TIME, 0, 0);
  end;
end;

end.
