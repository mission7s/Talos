unit UnitTestUthaRCP3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  UnitBaseSerial, UnitUthaRCP3;

type
  TForm12 = class(TForm)
    Label1: TLabel;
    edtServerIP: TEdit;
    Label2: TLabel;
    edtServerPort: TEdit;
    mmDesc: TMemo;
    edtSource: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtDestination: TEdit;
    Label5: TLabel;
    btnTake: TButton;
    btnConnect: TButton;
    btnDisconnect: TButton;
    btnDestnationDisconnect: TButton;
    btnPing: TButton;
    chkbLevel1: TCheckBox;
    chkbLevel2: TCheckBox;
    chkbLevel3: TCheckBox;
    chkbLevel4: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnTakeClick(Sender: TObject);
    procedure btnPingClick(Sender: TObject);
    procedure btnDestnationDisconnectClick(Sender: TObject);
  private
    { Private declarations }
    FUthaRCP3: TUthaRCP3;

    procedure SetLevelBitmap(var ALevels: TLevelArray);
  public
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

uses System.Math;

{$R *.dfm}

procedure TForm12.SetLevelBitmap(var ALevels: TLevelArray);
var
  I: Integer;
  Lvl: Word;
begin
  FillChar(ALevels, SizeOf(TLevelArray), #0);

  for I := 0 to ControlCount - 1 do
  begin
    if (Controls[I] is TCheckBox) then
    begin
      if (Controls[I] as TCheckBox).Checked then
      begin
        Lvl := StrToIntDef(StringReplace(Controls[I].Name, 'chkbLevel', '', []), 0);
        if (InRange(Lvl, 1, MAX_LEVEL)) then
          ALevels[Lvl - 1] := True;
      end;
    end;
  end;
end;

procedure TForm12.btnTakeClick(Sender: TObject);
var
  R: Integer;

  Src, Dst, Lvl: Word;
  Levels: TLevelArray;
begin
  Src := StrToIntDef(edtSource.Text, 0);
  Dst := StrToIntDef(edtDestination.Text, 0);
  SetLevelBitmap(Levels);

  R := FUthaRCP3.Take(Src, Dst, Levels);

  if (R = D_OK) then
  begin
    mmDesc.Lines.Add(Format('Take Success, Source = %d, Destination = %d', [Src, Dst]));
  end
  else
  begin
    mmDesc.Lines.Add(Format('Take Error = %d', [R]));
  end;
end;

procedure TForm12.btnConnectClick(Sender: TObject);
begin
  FUthaRCP3.ControlIP := edtServerIP.Text;
  FUthaRCP3.ControlPort := StrToIntDef(edtServerPort.Text, 0);
  FUthaRCP3.Connect;

  if (FUthaRCP3.Connected) then
  begin
    mmDesc.Lines.Add(Format('Connect Success, IP = %s, Port = %d', [FUthaRCP3.ControlIP, FUthaRCP3.ControlPort]));
  end
  else
  begin
    mmDesc.Lines.Add('Connect Error.');
  end;
end;

procedure TForm12.btnDisconnectClick(Sender: TObject);
begin
  FUthaRCP3.Disconnect;

  if (not FUthaRCP3.Connected) then
  begin
    mmDesc.Lines.Add('Disconnect Success.');
  end
  else
  begin
    mmDesc.Lines.Add('Disconnect Error.');
  end;
end;

procedure TForm12.btnPingClick(Sender: TObject);
var
  R: Integer;
  Conn: Boolean;
begin
  R := FUthaRCP3.Ping;

  if (R = D_OK) then
  begin
    mmDesc.Lines.Add(Format('Ping Success.', []));
  end
  else
  begin
    mmDesc.Lines.Add(Format('Ping Error = %d', [R]));
  end;
end;

procedure TForm12.btnDestnationDisconnectClick(Sender: TObject);
var
  R: Integer;

  Dst: Word;
  Levels: TLevelArray;
begin
  Dst := StrToIntDef(edtDestination.Text, 0);
  SetLevelBitmap(Levels);

  R := FUthaRCP3.DistinationDisconnect(Dst, Levels);

  if (R = D_OK) then
  begin
    mmDesc.Lines.Add(Format('DistinationDisconnect Success, Destination = %d', [Dst]));
  end
  else
  begin
    mmDesc.Lines.Add(Format('DistinationDisconnect Error = %d', [R]));
  end;
end;

procedure TForm12.FormCreate(Sender: TObject);
begin
  FUthaRCP3 := TUthaRCP3.Create(Self);
  FUthaRCP3.ControlType := ctTCP;

  FUthaRCP3.LogPath := ExtractFilePath(Application.ExeName) + 'PortLog\';
  FUthaRCP3.LogExt  := 'UthaRCP3.log';
  FUthaRCP3.LogIsHexcode := True;
  FUthaRCP3.LogEnabled := True;
end;

procedure TForm12.FormDestroy(Sender: TObject);
begin
  if (FUthaRCP3.Connected) then FUthaRCP3.Disconnect;
  FreeAndNil(FUthaRCP3);
end;

end.
