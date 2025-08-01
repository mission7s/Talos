unit UnitTestK4AI48;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Win.Registry,
  UnitBaseSerial, UnitSerialK4AI48;

type
  TForm1 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cbComportNum: TComboBox;
    edOutPort: TEdit;
    edInPort: TEdit;
    cbManualMode: TComboBox;
    btnSetManualMode: TButton;
    btnConnect: TButton;
    btnDisconnect: TButton;
    btnSetPort: TButton;
    btnSystemStatus: TButton;
    mmLog: TMemo;
    btnPortStatus: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnSetPortClick(Sender: TObject);
    procedure btnSetManualModeClick(Sender: TObject);
    procedure btnSystemStatusClick(Sender: TObject);
    procedure btnPortStatusClick(Sender: TObject);
  private
    { Private declarations }
    FK4AI48: TSerialK4AI48;

    function PopulateComportNum: Integer;
    function PopulateManualMode: Integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  FK4AI48.ControlType := ctSerial;
  FK4AI48.ComPort := Integer(cbComportNum.Items.Objects[cbComportNum.ItemIndex]);

  if (FK4AI48.Connect) then
    mmLog.Lines.Add('Connect success.')
  else
    mmLog.Lines.Add('[Error] Connect Fail.');
end;

procedure TForm1.btnDisconnectClick(Sender: TObject);
begin
  if (FK4AI48.Disconnect) then
    mmLog.Lines.Add('Disconnect success.')
  else
    mmLog.Lines.Add('[Error] Disconnect Fail.');
end;

procedure TForm1.btnPortStatusClick(Sender: TObject);
var
  R: Integer;

  PortStatus: TPortStatus;
begin
  FillChar(PortStatus, SizeOf(TPortStatus), #0);

  R := FK4AI48.GetPortStatus(PortStatus);
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('GetPortStatus success.');
    with PortStatus do
    begin
      mmLog.Lines.Add(Format('In1 = %d', [Integer(In1)]));
      mmLog.Lines.Add(Format('In2 = %d', [Integer(In2)]));
      mmLog.Lines.Add(Format('In3 = %d', [Integer(In3)]));
      mmLog.Lines.Add(Format('In4 = %d', [Integer(In4)]));
      mmLog.Lines.Add(Format('Out1 = %d', [Out1]));
      mmLog.Lines.Add(Format('Out2 = %d', [Out2]));
      mmLog.Lines.Add(Format('StatusMode = %d', [Integer(StatusMode)]));
    end;
  end
  else
    mmLog.Lines.Add(Format('[Error] GetPortStatus Fail. errorcode = %d', [R]));
end;

procedure TForm1.btnSetManualModeClick(Sender: TObject);
var
  R: Integer;

  StatusMode: TStatusMode;
begin
  StatusMode := TStatusMode(cbManualMode.Items.Objects[cbManualMode.ItemIndex]);

  R := FK4AI48.SetManualMode(StatusMode);
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('SetManualMode success.');
    mmLog.Lines.Add(Format('StatusMode = %d', [Integer(StatusMode)]));
  end
  else
    mmLog.Lines.Add(Format('[Error] SetManualMode Fail. errorcode = %d', [R]));
end;

procedure TForm1.btnSetPortClick(Sender: TObject);
var
  R: Integer;

  OutPort: Byte;
  InPort: Byte;
begin
  OutPort := StrToIntDef(edOutPort.Text, 0);
  InPort := StrToIntDef(edInPort.Text, 0);

  R := FK4AI48.SetPort(OutPort, InPort);
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('SetPort success.');
    mmLog.Lines.Add(Format('OutPort = %d', [OutPort]));
    mmLog.Lines.Add(Format('InPort = %d', [InPort]));
  end
  else
    mmLog.Lines.Add(Format('[Error] SetPort Fail. errorcode = %d', [R]));
end;

procedure TForm1.btnSystemStatusClick(Sender: TObject);
var
  R: Integer;

  Model: String;
  Remote: Word;
begin
  R := FK4AI48.GetSystemStatus(Model, Remote);
  if (R = D_OK) then
  begin
    mmLog.Lines.Add('GetSystemStatus success.');
    mmLog.Lines.Add(Format('Model = %s', [Model]));
    mmLog.Lines.Add(Format('Remote = %d', [Remote]));
  end
  else
    mmLog.Lines.Add(Format('[Error] GetSystemStatus Fail. errorcode = %d', [R]));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PopulateComportNum;
  PopulateManualMode;

  cbComportNum.ItemIndex := cbComportNum.Items.IndexOfObject(TObject(3));
  cbManualMode.ItemIndex := cbManualMode.Items.IndexOfObject(TObject(smAuto));

  FK4AI48 := TSerialK4AI48.Create(nil);
  FK4AI48.ComPortBaudRate := br115200;
  FK4AI48.ComPortDataBits := db8BITS;
  FK4AI48.ComPortStopBits := sb1Bits;
  FK4AI48.ComPortParity := ptNone;
  FK4AI48.LogPath := ExtractFilePath(Application.ExeName) + 'Log\';
  FK4AI48.LogExt  := 'FK4AI48.log';
  FK4AI48.LogEnabled := True;
end;

function TForm1.PopulateComportNum: Integer;
var
  RegFile: TRegistry;
  DeviceList: TStrings;
  I: Integer;
  CurrentPort: string;
begin
  Result := D_OK;
  if (cbComportNum.Items.Count > 0) then exit;

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

function TForm1.PopulateManualMode: Integer;
begin
  Result := D_OK;
  if (cbManualMode.Items.Count > 0) then exit;

  cbManualMode.Items.AddObject('Auto', TObject(smAuto));
  cbManualMode.Items.AddObject('Manual', TObject(smManual));
end;

end.
