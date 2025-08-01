unit UnitStartSplash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Samples.Gauges,
  UnitCommons, UnitConsts;

type
  TfrmStartSplash = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    lblAppName: TLabel;
    lblStart: TLabel;
    lblCheck: TLabel;
    gaProgress: TGauge;
    lblVersion: TLabel;
    lblCompany: TLabel;
    lblStatus: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DisplayCheck(ACheckStr: String; AProgress: Integer = 0);
    procedure DisplayStatus(AStatusStr: String; AProgress: Integer = 0);
  end;

var
  frmStartSplash: TfrmStartSplash;

implementation

{$R *.dfm}

procedure TfrmStartSplash.DisplayCheck(ACheckStr: String; AProgress: Integer = 0);
begin
  lblCheck.Caption := ACheckStr;
  lblStatus.Caption := '';
  gaProgress.Progress := AProgress;
//  Update;
  SetWindowPos(Handle, HWND_TOPMOST, Left, Top, 0, 0, SWP_NOSIZE or SWP_SHOWWINDOW);
  Application.ProcessMessages;
end;

procedure TfrmStartSplash.DisplayStatus(AStatusStr: String; AProgress: Integer = 0);
begin
  lblStatus.Caption := AStatusStr;
  gaProgress.Progress := AProgress;
//  Update;
  Application.ProcessMessages;
end;

procedure TfrmStartSplash.FormCreate(Sender: TObject);
begin
  lblAppName.Caption := Application.Title;
  lblStart.Caption   := Application.Title + ' starting...';
  lblCheck.Caption   := '';
  lblStatus.Caption  := '';
  lblVersion.Caption := 'Version ' + GetFileVersionStr(Application.ExeName);
end;

end.
