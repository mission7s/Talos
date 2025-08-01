unit UnitTestMediaInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MediaInfoDll, Vcl.StdCtrls, Vcl.Buttons;

type
  TForm18 = class(TForm)
    btnLoadMediaInfoDLL: TButton;
    mmDesc: TMemo;
    btnNewMediaInfo: TButton;
    btnOpenMediaInfo: TButton;
    edtFileName: TEdit;
    sBtnLoadFileName: TSpeedButton;
    btnGetDuration: TButton;
    procedure btnLoadMediaInfoDLLClick(Sender: TObject);
    procedure btnNewMediaInfoClick(Sender: TObject);
    procedure sBtnLoadFileNameClick(Sender: TObject);
    procedure btnOpenMediaInfoClick(Sender: TObject);
    procedure btnGetDurationClick(Sender: TObject);
  private
    { Private declarations }
    FHandle: NativeInt;
  public
    { Public declarations }
  end;

var
  Form18: TForm18;

implementation

{$R *.dfm}

procedure TForm18.btnGetDurationClick(Sender: TObject);
var
  DurationString: String;
begin
  DurationString := String(MediaInfo_Get(FHandle, Stream_General, 0, 'Duration/String4', Info_Text, Info_Name));
  mmDesc.Lines.Add(Format('Succeeded get Duration/String4, duration = %s', [DurationString]));
end;

procedure TForm18.btnLoadMediaInfoDLLClick(Sender: TObject);
begin
  if (MediaInfoDLL_Load('MediaInfo.dll')=false) then
  begin
    mmDesc.Lines.Add('Error while loading MediaInfo.dll');
    exit;
  end
  else
    mmDesc.Lines.Add('Succeeded load MediaInfo.dll');
end;

procedure TForm18.btnNewMediaInfoClick(Sender: TObject);
begin
  FHandle := MediaInfo_New;
  mmDesc.Lines.Add(Format('Succeeded new MediaInfo handle, handle = %d', [FHandle]));
end;

procedure TForm18.btnOpenMediaInfoClick(Sender: TObject);
begin
  if (MediaInfo_Open(FHandle, PChar(edtFileName.Text)) <= 0) then
  begin
    mmDesc.Lines.Add('Error while opening MediaInfo');
    exit;
  end
  else
    mmDesc.Lines.Add(Format('Succeeded open MediaInfo, filen = %s', [edtFileName.Text]));
end;

procedure TForm18.sBtnLoadFileNameClick(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do
    try
      Title := 'Load file';
      FileName := ExtractFileName(edtFileName.Text);
      InitialDir := ExtractFilePath(edtFileName.Text);
      Filter  := 'Video file|*.mxf;*.mov;*.mp4;*.mpg;*.mpeg;*.avi;*.wmv|Audio file|*.wav;*.mp3;*.wma|Any file(*.*)|*.*';
      if Execute then
      begin
        edtFileName.Text := FileName;
      end;
    finally
      Free;
    end;
end;

end.
