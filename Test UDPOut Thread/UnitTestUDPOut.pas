unit UnitTestUDPOut;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  UnitUDPOut, Vcl.StdCtrls;

type
  TForm7 = class(TForm)
    btnSend: TButton;
    edtSend: TEdit;
    edtHostIP: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
  private
    { Private declarations }
    FUDPOut: TUDPOut;
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

procedure TForm7.btnSendClick(Sender: TObject);
var
  Buffer: AnsiString;
begin
//  FUDPOut.Send('', 9000, edtSend.Text);
  FUDPOut.Send(edtHostIP.Text, 9001, edtSend.Text);

{  Buffer := Chr($02) + Char($02 + 4) + Char($00) + Chr($00) + Char($11);

  FUDPOut.Send('127.0.0.1', 9000, Buffer); }
end;

procedure TForm7.FormCreate(Sender: TObject);
begin
//  FUDPOut := TUDPOut.Create(9000, False, False);
  FUDPOut := TUDPOut.Create;
  FUDPOut.AsyncMode := True;
  FUDPOut.Broadcast := False;
  FUDPOut.Port := 9001;
  FUDPOut.Resume;
end;

procedure TForm7.FormDestroy(Sender: TObject);
begin
  FUDPOut.Close;
  FUDPOut.Terminate;
  FUDPOut.WaitFor;
  FreeAndNil(FUDPOut);
end;

end.
