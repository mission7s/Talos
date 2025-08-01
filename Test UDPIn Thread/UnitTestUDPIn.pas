unit UnitTestUDPIn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  UnitUDPIn, Vcl.StdCtrls;

type
  TForm7 = class(TForm)
    mmRecv: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FUDPIn: TUDPIn;
    procedure UDPRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

procedure TForm7.FormCreate(Sender: TObject);
begin
//  FUDPIn := TUDPIn.Create(9000, False, True, 1000);
  FUDPIn := TUDPIn.Create;
  FUDPIn.AsyncMode := True;
  FUDPIn.Broadcast := False;
  FUDPIn.Port := 9001;
  FUDPIn.OnUDPRead := UDPRead;
  FUDPIn.Resume;
end;

procedure TForm7.FormDestroy(Sender: TObject);
begin
//  if (WaitForSingleObject(FUDPIn.Handle, 0) = WAIT_OBJECT_0) then
  begin
    FUDPIn.Close;
    FUDPIn.Terminate;
    FUDPIn.WaitFor;
  end;
  FreeAndNil(FUDPIn);
end;

procedure TForm7.UDPRead(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer);
begin
  mmRecv.Lines.Add(Format('Bind: %s, Data: %s, Size: %d', [ABindingIP, AData, ADataSize]));
end;

end.
