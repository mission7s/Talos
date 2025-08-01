unit UnitTestClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPClient, IdGlobal, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    UDPOut: TIdUDPClient;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  UDPOut.Active := True;
  Timer1.Enabled := True;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  UDPOut.Active := False;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Buffer: TIdBytes;
  DateTimeStr: String;
begin
//  DateTimeStr := 'ÇÑ±Û';
  DateTimeStr := DateTimeToStr(Now);

//  SetLength(Buffer, Length(DateTimeStr));
//  Move(DateTimeStr, Buffer[0], Length(DateTimeStr));
//  Buffer := RawToBytes(DateTimeStr, Length(DateTimeStr));

  UDPOut.SendBuffer('127.0.0.1', 6005, ToBytes(DateTimeStr, enUTF8));

//  UDPOut.Send('127.0.0.1', 6005, 'Test');
end;

end.
