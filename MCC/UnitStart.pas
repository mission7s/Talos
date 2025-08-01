unit UnitStart;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UnitSingleForm, WMTools, WMControls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.ComCtrls, Vcl.StdCtrls,
  System.Actions, Vcl.ActnList,
  UnitCommons, UnitConsts, UnitDCSDLL;

type
  TDeviceCheckThread = class;

  TfrmStart = class(TfrmSingle)
    lblChecking: TLabel;
    lblDeviceName: TLabel;
    pBarStart: TProgressBar;
    wmibCancel: TWMImageButton;
    aLstStart: TActionList;
    actCancel: TAction;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FIsCheckCancel: Boolean;
    FIsCheckAll: Boolean;
    FDeviceCheckThread: TDeviceCheckThread;
  public
    { Public declarations }
  end;

  TDeviceCheckThread = class(TThread)
  private
    { Private declarations }
    FForm: TfrmStart;
    procedure DoControl;
  protected
    procedure Execute; override;
  public
    constructor Create(AForm: TfrmStart);
    destructor Destroy; override;
  end;

var
  frmStart: TfrmStart;

implementation

{$R *.dfm}

procedure TfrmStart.FormCreate(Sender: TObject);
begin
  inherited;

  lblDeviceName.Caption := '';

  FIsCheckCancel := False;

  FDeviceCheckThread := TDeviceCheckThread.Create(Self);
end;

procedure TfrmStart.FormDestroy(Sender: TObject);
begin
  inherited;
  if (FDeviceCheckThread <> nil) then
  begin
    FDeviceCheckThread.Terminate;
    FDeviceCheckThread.WaitFor;
    FreeAndNil(FDeviceCheckThread);
  end;
end;

procedure TfrmStart.FormShow(Sender: TObject);
begin
  inherited;
  FDeviceCheckThread.Resume;
end;

{ TDeviceCheckThread }

constructor TDeviceCheckThread.Create(AForm: TfrmStart);
begin
  FForm := AForm;

  FreeOnTerminate := False;

  inherited Create(True);
end;

destructor TDeviceCheckThread.Destroy;
begin
  inherited Destroy;
end;

procedure TDeviceCheckThread.Execute;
begin
  { Place thread code here }
  Synchronize(DoControl);
end;

procedure TDeviceCheckThread.DoControl;
var
  ErrorString: String;
  DeviceName: String;
  DCSName: String;
  HandleCount: Integer;

  I, J: Integer;
  R: Integer;
  IsMain: Boolean;
  SourceHandle: PSourceHandle;
  DeviceHandle: TDeviceHandle;
begin
  with FForm do
  begin
    try
      FIsCheckCancel := False;

      HandleCount := 0;
      for I := 0 to GV_SourceList.Count - 1 do
      begin
        if (GV_SourceList[I]^.Handles <> nil) then
        begin
          for J := 0 to GV_SourceList[I]^.Handles.Count - 1 do
            Inc(HandleCount);
        end;
      end;

      pBarStart.Min := 0;
      pBarStart.Max := HandleCount;
      pBarStart.Position := 0;
      Application.ProcessMessages;

      // DCS check
  {    for I := 0 to GV_DCSList.Count - 1 do
      begin
        R := DCSIsMain(GV_DCSList[I]^.ID, GV_DCSList[I]^.HostIP, IsMain);
        if (R = D_OK) then
        begin
          GV_DCSList[I]^.Main := IsMain;
        end
        else
          GV_DCSList[I]^.Main := False;
      end;  }

      // Device check
      lblChecking.Caption := SLookingForDevice;
      for I := 0 to GV_SourceList.Count - 1 do
      begin
        DeviceName := GV_SourceList[I]^.Name;
        if (GV_SourceList[I]^.Handles <> nil) then
        begin
          for J := 0 to GV_SourceList[I]^.Handles.Count - 1 do
          begin
            SourceHandle := GV_SourceList[I]^.Handles[J];
            DCSName := GetDCSNameByID(SourceHandle^.DCS^.ID);
            lblDeviceName.Caption := Format('%s, %s', [DeviceName, DCSName]);
            pBarStart.Position := pBarStart.Position + 1;
            Application.ProcessMessages;

            if (not FIsCheckCancel) then
            begin
        //    ShowMessage(DCS^.HostIP);
        //    ShowMessage(GV_SourceList[I]^.Name);
              R := DCSOpen(SourceHandle^.DCS^.ID, SourceHandle^.DCS^.HostIP, GV_SourceList[I]^.Name, DeviceHandle);
              if (R = D_OK) then
              begin
                SourceHandle^.Handle := DeviceHandle;
//                GV_SourceList[I]^.CommSuccess := True;
      //          ShowMessage(Format('Success ID=%d, IP=%s, DeviceName=%s, DeviceHandle=%d', [SourceHandle^.DCSID, SourceHandle^.DCSIP, GV_SourceList[I]^.Name, DeviceHandle]));

                Assert(False, GetMainLogStr(lsNormal, @LS_DCSOpenDeviceSuccess, [SourceHandle^.DCS^.ID, String(GV_SourceList[I]^.Name)]));
              end
              else
              begin
                SourceHandle^.Handle := DeviceHandle;

                Assert(False, GetMainLogStr(lsError, @LSE_DCSOpenDeviceFailed, [R, SourceHandle^.DCS^.ID, String(GV_SourceList[I]^.Name)]));

  //              ShowMessage(IntToStr(R));
                if (not FIsCheckAll) then
                begin
                  ErrorString := Format(SNotFoundDeviceAndContinue, [DeviceName, DCSName]);
                  MessageBeep(MB_ICONWARNING);
                  R := MessageBox(Handle, PChar(ErrorString), PChar(Application.Title), MB_YESNO or MB_ICONWARNING or MB_TOPMOST);
                  if (R = ID_NO) then
                  begin
                    FIsCheckCancel := True;
                  end
                  else
                  begin
                    ErrorString := SLookingForAllDevice;
                    MessageBeep(MB_ICONQUESTION);
                    R := MessageBox(Handle, PChar(ErrorString), PChar(Application.Title), MB_YESNO or MB_ICONQUESTION or MB_TOPMOST);
                    if (R = ID_YES) then
                    begin
                      FIsCheckAll := True;
                    end
                  end;
                end;
              end;
            end
            else
              SourceHandle^.Handle := INVALID_DEVICE_HANDLE;
          end;
        end;
      end;
    finally
      Close;
    end;
  end;
end;

end.
