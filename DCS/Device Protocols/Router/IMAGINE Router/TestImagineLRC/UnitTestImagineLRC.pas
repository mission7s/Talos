unit UnitTestImagineLRC;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  UnitBaseSerial, UnitImagineLRC;

type
  TForm12 = class(TForm)
    Label1: TLabel;
    edtServerIP: TEdit;
    Label2: TLabel;
    edtServerPort: TEdit;
    mmDesc: TMemo;
    edtSrcIndex: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtDstIndex: TEdit;
    Label5: TLabel;
    edtLvlIndex: TEdit;
    btnChangeXPoint: TButton;
    btnQueryXPoint: TButton;
    btnConnect: TButton;
    btnDisconnect: TButton;
    btnGetXPoint: TButton;
    btnQueryAllXPoint: TButton;
    btnGetProtocolName: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnChangeXPointClick(Sender: TObject);
    procedure btnQueryXPointClick(Sender: TObject);
    procedure btnGetXPointClick(Sender: TObject);
    procedure btnQueryAllXPointClick(Sender: TObject);
    procedure btnGetProtocolNameClick(Sender: TObject);
  private
    { Private declarations }
    FImagineLRC: TImagineLRC;
  public
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

{$R *.dfm}

procedure TForm12.btnChangeXPointClick(Sender: TObject);
var
  R: Integer;
  DstIndex, DstLevel, SrcIndex, SrcLevel: Integer;
begin
  DstIndex := StrToIntDef(edtDstIndex.Text, 0);
  DstLevel := StrToIntDef(edtLvlIndex.Text, 0);
  SrcIndex := StrToIntDef(edtSrcIndex.Text, 0);
  SrcLevel := StrToIntDef(edtLvlIndex.Text, 0);

  R := FImagineLRC.ChangeXPoint(DstIndex, DstLevel, SrcIndex, SrcLevel);

  if (R = D_OK) then
  begin
    mmDesc.Lines.Add(Format('Change XPoint Success, Dst = %d, Dst level = %d, Src = %d, Src level= %d', [DstIndex, DstLevel, SrcIndex, SrcLevel]));
  end
  else
  begin
    mmDesc.Lines.Add(Format('Change XPoint Error = %d', [R]));
  end;
end;

procedure TForm12.btnConnectClick(Sender: TObject);
begin
  FImagineLRC.ControlIP := edtServerIP.Text;
  FImagineLRC.ControlPort := StrToIntDef(edtServerPort.Text, 0);
  FImagineLRC.Connect;

  if (FImagineLRC.Connected) then
  begin
    mmDesc.Lines.Add(Format('Connect Success, IP = %s, Port = %d', [FImagineLRC.ControlIP, FImagineLRC.ControlPort]));
  end
  else
  begin
    mmDesc.Lines.Add('Connect Error.');
  end;
end;

procedure TForm12.btnDisconnectClick(Sender: TObject);
begin
  FImagineLRC.Disconnect;

  if (not FImagineLRC.Connected) then
  begin
    mmDesc.Lines.Add('Disconnect Success.');
  end
  else
  begin
    mmDesc.Lines.Add('Disconnect Error.');
  end;
end;

procedure TForm12.btnGetProtocolNameClick(Sender: TObject);
var
  R: Integer;
  ProtocolName: AnsiString;
begin
  R := FImagineLRC.ProtocolName(ProtocolName);

  if (R = D_OK) then
  begin
    mmDesc.Lines.Add(Format('Get ProtocolNam Success, ProtocolName = %s', [ProtocolName]));
  end
  else
  begin
    mmDesc.Lines.Add(Format('Get ProtocolNam Error = %d', [R]));
  end;
end;

procedure TForm12.btnGetXPointClick(Sender: TObject);
var
  R: Integer;
  DstIndex, DstLevel, SrcIndex, SrcLevel: Integer;
begin
  DstIndex := StrToIntDef(edtDstIndex.Text, 0);
  DstLevel := StrToIntDef(edtLvlIndex.Text, 0);

  R := FImagineLRC.GetXPoint(DstIndex, DstLevel, SrcIndex, SrcLevel);

  if (R = D_OK) then
  begin
    mmDesc.Lines.Add(Format('Get XPoint Success, Dst = %d, Dst level = %d, Src = %d, Src level = %d', [DstIndex, DstLevel, SrcIndex, SrcLevel]));
  end
  else
  begin
    mmDesc.Lines.Add(Format('Get XPoint Error = %d', [R]));
  end;
end;

procedure TForm12.btnQueryAllXPointClick(Sender: TObject);
var
  R: Integer;
begin
  R := FImagineLRC.QueryXPoint(0, 0);

  if (R = D_OK) then
  begin
    mmDesc.Lines.Add('Query All XPoint Success');
  end
  else
  begin
    mmDesc.Lines.Add(Format('Query All XPoint Error = %d', [R]));
  end;
end;

procedure TForm12.btnQueryXPointClick(Sender: TObject);
var
  R: Integer;
  DstIndex, LvlIndex: Integer;
begin
  DstIndex := StrToIntDef(edtDstIndex.Text, 0);
  LvlIndex := StrToIntDef(edtLvlIndex.Text, 0);
  R := FImagineLRC.QueryXPoint(DstIndex, LvlIndex);

  if (R = D_OK) then
  begin
    mmDesc.Lines.Add(Format('Query XPoint Success, Dst = %d, Lvl = %d', [DstIndex, LvlIndex]));
  end
  else
  begin
    mmDesc.Lines.Add(Format('Query XPoint Error = %d', [R]));
  end;
end;

procedure TForm12.FormCreate(Sender: TObject);
begin
  FImagineLRC := TImagineLRC.Create(Self);
  FImagineLRC.ControlType := ctTCP;

  FImagineLRC.LogPath := ExtractFilePath(Application.ExeName) + 'PortLog\';
  FImagineLRC.LogExt  := '.log';
  FImagineLRC.LogIsHexcode := False;
  FImagineLRC.LogEnabled := True;
end;

procedure TForm12.FormDestroy(Sender: TObject);
begin
  if (FImagineLRC.Connected) then FImagineLRC.Disconnect;
  FreeAndNil(FImagineLRC);
end;

end.
