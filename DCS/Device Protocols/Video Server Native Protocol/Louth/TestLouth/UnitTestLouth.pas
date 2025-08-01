unit UnitTestLouth;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registry, Mask,
  UnitBaseSerial, UnitLouth;

const
  WM_CONNECT_CHANGED  = WM_USER + 2001;
  WM_TIMECODE_CHANGED = WM_USER + 2002;
  WM_STATUS_CHANGED   = WM_USER + 2003;

type
  TForm1 = class(TForm)
    cbComportNum: TComboBox;
    Label2: TLabel;
    btnConnect: TButton;
    btnDisconnect: TButton;
    btnOpenPort: TButton;
    btnSelectPort: TButton;
    btnClosePort: TButton;
    mmLog: TMemo;
    Label7: TLabel;
    cbVDCPPort: TComboBox;
    btnPlayCueWithData: TButton;
    btnPlay: TButton;
    Label8: TLabel;
    edClipID: TEdit;
    Label9: TLabel;
    edDuration: TEdit;
    btnStop: TButton;
    btnPortStateStatus: TButton;
    btnCurrentTC: TButton;
    btnPlayCue: TButton;
    btnIDRequest: TButton;
    btnIDSize: TButton;
    Label10: TLabel;
    edCurrentTC: TEdit;
    Label11: TLabel;
    edConnected: TEdit;
    btnAutoStatus: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnOpenPortClick(Sender: TObject);
    procedure btnSelectPortClick(Sender: TObject);
    procedure btnClosePortClick(Sender: TObject);
    procedure btnPlayCueWithDataClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnPortStateStatusClick(Sender: TObject);
    procedure btnCurrentTCClick(Sender: TObject);
    procedure btnPlayCueClick(Sender: TObject);
    procedure btnIDRequestClick(Sender: TObject);
    procedure btnIDSizeClick(Sender: TObject);
    procedure btnAutoStatusClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FLouth: TLouth;

    FConnected: Boolean;
    FCurrentTC: String;
    FCurrentPortStatus: TPortStateStatus;
    FAutoStatus: Boolean;

    function PopulateComportNum: HRESULT;
    procedure WndProc(var Message: TMessage); override;

    procedure ConnectChanged(Sender: TComponent; AConnected: Boolean);
    procedure TimeCodeChanged(Sender: TComponent; ATC: String);
    procedure StateStatusChanged(Sender: TComponent; APortStateStatus: TPortStateStatus);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.WndProc(var Message: TMessage);
begin
  try
    case Message.Msg of
      WM_CONNECT_CHANGED:
      begin
        edConnected.Text := BoolToStr(Boolean(Message.LParam));
      end;
      WM_TIMECODE_CHANGED:
      begin
        edCurrentTC.Text := FCurrentTC;
        mmLog.Lines.Add(Format('Current TC : %s', [FCurrentTC]));
      end;
      WM_STATUS_CHANGED:
      begin
        mmLog.Lines.Add(Format('Get Status', []));
      end;
    end;
  finally
    inherited WndProc(Message);
  end;
end;

procedure TForm1.ConnectChanged(Sender: TComponent; AConnected: Boolean);
begin
  PostMessage(Form1.Handle, WM_CONNECT_CHANGED, 0, NativeInt(AConnected));
end;

procedure TForm1.TimeCodeChanged(Sender: TComponent; ATC: String);
begin
  FCurrentTC := String(ATC);
  PostMessage(Form1.Handle, WM_TIMECODE_CHANGED, 0, 0);
end;

procedure TForm1.StateStatusChanged(Sender: TComponent; APortStateStatus: TPortStateStatus);
begin
  FCurrentPortStatus := APortStateStatus;
  PostMessage(Form1.Handle, WM_STATUS_CHANGED, 0, 0);
end;

// 현재 인스톨된 COM포트 목록을 구한다.
function TForm1.PopulateComportNum: HRESULT;
var
  RegFile: TRegistry;
  DeviceList: TStrings;
  I: Integer;
  CurrentPort: string;
begin
  Result := S_OK;
  if cbComportNum.Items.Count > 0 then exit;

  RegFile := TRegistry.Create;
  try
    RegFile.RootKey := HKEY_LOCAL_MACHINE;
    RegFile.OpenKeyReadOnly('hardware\devicemap\serialcomm');
    DeviceList := TStringList.Create;
    try
      RegFile.GetValueNames(DeviceList);
      cbComportNum.Items.Clear;
      for I := 0 to DeviceList.Count - 1 do
      begin
        CurrentPort := RegFile.ReadString(DeviceList.Strings[I]);
        cbComportNum.Items.AddObject(CurrentPort, TObject(StrToInt(Copy(CurrentPort, 4, Length(CurrentPort)))));
      end;
    finally
      FreeAndNil(DeviceList);
    end;
    RegFile.CloseKey;
  finally
    FreeAndNil(RegFile);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PopulateComportNum;

  cbComportNum.ItemIndex := cbComportNum.Items.IndexOfObject(TObject(3));

  FLouth := TLouth.Create(nil);
  FLouth.ControlType := ctSerial;
  FLouth.ComPortBaudRate := br38400;
  FLouth.ComPortDataBits := db8BITS;
  FLouth.ComPortStopBits := sb1Bits;
  FLouth.ComPortParity := ptOdd;
  FLouth.LogIsHexcode := True;
  FLouth.LogPath := ExtractFilePath(Application.ExeName) + 'Log\';
  FLouth.LogExt  := 'Louth.log';
  FLouth.LogEnabled := True;

  FLouth.AutoStatus := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FLouth.Disconnect;
  FreeAndNil(FLouth);
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  FLouth.ControlType := ctSerial;
  FLouth.ComPort := Integer(cbComportNum.Items.Objects[cbComportNum.ItemIndex]);

  if (FLouth.Connect) then
    mmLog.Lines.Add('Connect success.')
  else
    mmLog.Lines.Add('[Error] Connect Fail.');
end;

procedure TForm1.btnDisconnectClick(Sender: TObject);
begin
  if (FLouth.Disconnect) then
    mmLog.Lines.Add('Disconnect success.')
  else
    mmLog.Lines.Add('[Error] Disconnect Fail.');
end;

procedure TForm1.btnIDRequestClick(Sender: TObject);
var
  R: Integer;
  IDRequest: TIDRequest;
begin
  FillChar(IDRequest, SizeOf(TIDRequest), #0);

  R := FLouth.GetIDRequest(edClipID.Text, IDRequest);
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('GetIDRequest success.');
    mmLog.Lines.Add(Format('InDisk %s.', [BoolToStr(IDRequest.InDisk, True)]));
    mmLog.Lines.Add(Format('InMarkedForXFer %s.', [BoolToStr(IDRequest.InMarkedForXFer, True)]));
    mmLog.Lines.Add(Format('InRemoteSystem %s.', [BoolToStr(IDRequest.InRemoteSystem, True)]));
    mmLog.Lines.Add(Format('DeleteProtected %s.', [BoolToStr(IDRequest.DeleteProtected, True)]));
    mmLog.Lines.Add(Format('InArchive %s.', [BoolToStr(IDRequest.InArchive, True)]));
    mmLog.Lines.Add(Format('ArchivePending %s.', [BoolToStr(IDRequest.ArchivePending, True)]));
    mmLog.Lines.Add(Format('InXFer %s.', [BoolToStr(IDRequest.InXFer, True)]));
    mmLog.Lines.Add(Format('OperationPending %s.', [BoolToStr(IDRequest.OperationPending, True)]));
  end
  else
    mmLog.Lines.Add(Format('[Error] GetIDRequest fail. errorcode = %d', [R]));
end;

procedure TForm1.btnIDSizeClick(Sender: TObject);
var
  R: Integer;
  DurationTC: String;
begin
  R := FLouth.GetSize(edClipID.Text, DurationTC);
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('GetSize success.');
    mmLog.Lines.Add(Format('Duration TC %s.', [DurationTC]));
  end
  else
    mmLog.Lines.Add(Format('[Error] GetSize fail. errorcode = %d', [R]));
end;

procedure TForm1.btnOpenPortClick(Sender: TObject);
var
  R: Integer;
  PortNumber: Integer;
begin
  PortNumber := StrToIntDef(cbVDCPPort.Text, 0);

  R := FLouth.Open(PortNumber, $01);
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('Open Success');
    mmLog.Lines.Add(Format('PortNumber = %d', [PortNumber]));
  end
  else
    mmLog.Lines.Add(Format('[Error] Open fail. errorcode = %d', [R]));
end;

procedure TForm1.btnSelectPortClick(Sender: TObject);
var
  R: Integer;
begin
  R := FLouth.SelectPort(FLouth.PortNumber);
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('SelectPort Success');
    mmLog.Lines.Add(Format('PortNumber = %d', [FLouth.PortNumber]));
  end
  else
    mmLog.Lines.Add(Format('[Error] SelectPort fail. errorcode = %d', [R]));
end;

procedure TForm1.btnAutoStatusClick(Sender: TObject);
var
  R: Integer;
begin
  FLouth.AutoStatus := not FAutoStatus;

  mmLog.Lines.Add('SetAutoStatus success');
end;

procedure TForm1.btnClosePortClick(Sender: TObject);
var
  R: Integer;
begin
  R := FLouth.ClosePort(FLouth.PortNumber);
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('ClosePort Success');
    mmLog.Lines.Add(Format('PortNumber = %d', [FLouth.PortNumber]));
  end
  else
    mmLog.Lines.Add(Format('[Error] ClosePort fail. errorcode = %d', [R]));
end;

procedure TForm1.btnPlayCueWithDataClick(Sender: TObject);
var
  R: Integer;
begin
  R := FLouth.PlayCueWithData(edClipID.Text, '00:00:00:00', edDuration.Text);
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('PlayCueWithData Success');
  end
  else
    mmLog.Lines.Add(Format('[Error] PlayCueWithData fail. errorcode = %d', [R]));
end;

procedure TForm1.btnPlayClick(Sender: TObject);
var
  R: Integer;
begin
  R := FLouth.Play;
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('Play Success');
  end
  else
    mmLog.Lines.Add(Format('[Error] Play fail. errorcode = %d', [R]));
end;

procedure TForm1.btnStopClick(Sender: TObject);
var
  R: Integer;
begin
  R := FLouth.Stop;
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('Stop Success');
  end
  else
    mmLog.Lines.Add(Format('[Error] Stop fail. errorcode = %d', [R]));
end;

procedure TForm1.btnPortStateStatusClick(Sender: TObject);
var
  R: Integer;
  PortStateStatus: TPortStateStatus;
begin
  FillChar(PortStateStatus, SizeOf(TPortStateStatus), #0);

  R := FLouth.GetPortStateStatus(PortStateStatus);
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('GetPortStateStatus success');
    mmLog.Lines.Add(Format('Idle %s.', [BoolToStr(PortStateStatus.Idle, True)]));
    mmLog.Lines.Add(Format('Cue %s.', [BoolToStr(PortStateStatus.Cue, True)]));
    mmLog.Lines.Add(Format('PlayRecord %s.', [BoolToStr(PortStateStatus.PlayRecord, True)]));
    mmLog.Lines.Add(Format('Still %s.', [BoolToStr(PortStateStatus.Still, True)]));
    mmLog.Lines.Add(Format('Jog %s.', [BoolToStr(PortStateStatus.Jog, True)]));
    mmLog.Lines.Add(Format('Shuttle %s.', [BoolToStr(PortStateStatus.Shuttle, True)]));
    mmLog.Lines.Add(Format('PortBusy %s.', [BoolToStr(PortStateStatus.PortBusy, True)]));
    mmLog.Lines.Add(Format('CueDone %s.', [BoolToStr(PortStateStatus.CueDone, True)]));
  end
  else
    mmLog.Lines.Add(Format('[Error] GetPortStateStatus fail. errorcode = %d', [R]));
end;

procedure TForm1.btnCurrentTCClick(Sender: TObject);
var
  R: Integer;
  TC: String;
begin
  R := FLouth.GetPositionRequest(ptCurrent, TC);
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('GetPositionRequest success');
    mmLog.Lines.Add(Format('Current TC : %s.', [TC]));
  end
  else
    mmLog.Lines.Add(Format('[Error] GetPositionRequest fail. errorcode = %d', [R]));
end;

procedure TForm1.btnPlayCueClick(Sender: TObject);
var
  R: Integer;
begin
  R := FLouth.PlayCue(edClipID.Text);
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('PlayCue Success');
  end
  else
    mmLog.Lines.Add(Format('[Error] PlayCue fail. errorcode = %d', [R]));
end;

end.
