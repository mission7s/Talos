unit UnitSECLangKOdll;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

const
  DLLName = 'SEC_Lang_ko.dll';

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FLangDLLHandle: HMODULE;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
{$I SECLang.INC}

procedure TForm1.Button1Click(Sender: TObject);
var
  Buf: array[0..1024] of Char;
begin
  if (FLangDLLHandle <> 0) then
    if (LoadString(FLangDLLHandle, SAFile, Buf, Length(Buf)) <> 0) then
      Caption := String(Buf);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLangDLLHandle := LoadLibraryEx(PChar(DLLName), 0, LOAD_LIBRARY_AS_DATAFILE);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if (FLangDLLHandle <> 0) then
    FreeLibrary(FLangDLLHandle);
end;

end.
