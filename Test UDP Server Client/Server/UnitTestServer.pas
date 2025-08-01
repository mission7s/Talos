unit UnitTestServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdUDPBase, IdUDPServer, IdGlobal, IdSocketHandle;

type
  Tform1 = class(TForm)
    UDPIn: TIdUDPServer;
    mmDesc: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UDPInUDPRead(AThread: TIdUDPListenerThread; const AData: TIdBytes;
      ABinding: TIdSocketHandle);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form1: Tform1;

implementation

{$R *.dfm}

function UDPReadString(var ABuffer: String; AData: TStream): Integer;
var
  RecvBuffer: Pointer;
begin
  RecvBuffer := GetMemory(AData.Size);
  try
    FillChar(RecvBuffer^, AData.Size, #0);
    Result := AData.Read(RecvBuffer^, AData.Size);

    if Result > 0 then
    begin
      SetLength(ABuffer, Result);
      Move(RecvBuffer^, ABuffer[1], Result);
    end;
  finally
    FreeMemory(RecvBuffer);
  end;
end;

procedure Tform1.FormCreate(Sender: TObject);
begin
  UDPIn.DefaultPort := 6005;
  UDPIn.Active      := True;
end;

procedure Tform1.FormDestroy(Sender: TObject);
begin
  UDPIn.Active := False;
end;

procedure Tform1.UDPInUDPRead(AThread: TIdUDPListenerThread;
  const AData: TIdBytes; ABinding: TIdSocketHandle);
var
  msg: string;
begin
  msg := BytesToString(AData, enUTF8);
  mmDesc.Lines.Add(msg);

  if (mmDesc.Lines.Count > 10000) then
    mmDesc.Lines.Clear;
end;

end.
