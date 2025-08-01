unit UnitUDPCommons;

interface

uses System.Classes, System.SysUtils, Vcl.Forms, Winapi.Windows, Winapi.Winsock2,
  System.SyncObjs, Generics.Collections;

const
  HOSTIP_LEN = 20;

  SEND_BUF_LEN = 4096;
  RECV_BUF_LEN = 4096;

type
  TUDPLogType = (ltSend, ltReceive, ltTest);

  TUDPReadEvent = procedure(const ABindingIP: AnsiString; const AData: AnsiString; const ADataSize: Integer) of object;

  TUDPBuffer = record
    HostIP: array[0..HOSTIP_LEN] of AnsiChar;
//    HostIP: AnsiString;
    Port: Word;
    Buffer: array[0..SEND_BUF_LEN] of AnsiChar;
//    Buffer: AnsiString;
    BufSize: Word;
  end;
  PUDPBuffer = ^TUDPBuffer;
  TUDPQueue = TQueue<PUDPBuffer>;

  TUDPCommon = class(TThread)
  protected
    FPort: Word;
    FAsyncMode: Boolean;
    FBroadcast: Boolean;
    FTimeout: Cardinal;

    FSocket: TSocket;
    FLastError: Integer;

    FBufferCritSec: TCriticalSection;
    FBufferQueue: TUDPQueue;

    FCloseEvent: THandle;

    FLogPath: String;
    FLogEnabled: Boolean;
    FLogExt: String;
    FLogCritSec: TCriticalSection;

    FOnUDPRead: TUDPReadEvent;

    function WriteLog(ALogType: TUDPLogType; ABuffer: PAnsiChar; ADataSize: Integer): Integer; virtual;
  public
{$IFDEF MSWINDOWS}
    constructor Create(APort: Word; AAsyncMode: Boolean = False; ABroadcast: Boolean = False; ATimeout: Cardinal = 1000); overload; virtual;
    constructor Create; overload; virtual;
{$ELSE}
    constructor Create(APort: Word; ABroadcast: Boolean = False; ATimeout: Cardinal = 1000); virtual;
{$ENDIF}

    destructor Destroy; override;

    procedure Close;

    property Port: Word read FPort write FPort;
    property AsyncMode: Boolean read FAsyncMode write FAsyncMode;
    property Broadcast: Boolean read FBroadcast write FBroadcast;
    property Timeout: Cardinal read FTimeout write FTimeout;

    property LogPath: String read FLogPath write FLogPath;
    property LogEnabled: Boolean read FLogEnabled write FLogEnabled;
    property LogExt: String read FLogExt write FLogExt;

    property OnUDPRead: TUDPReadEvent read FOnUDPRead write FOnUDPRead;
  end;

implementation

{$IFDEF MSWINDOWS}
constructor TUDPCommon.Create(APort: Word; AAsyncMode: Boolean; ABroadcast: Boolean; ATimeout: Cardinal);
begin
  Create;

  FPort      := APort;
  FAsyncMode := AAsyncMode;
  FBroadcast := ABroadcast;
  FTimeout   := ATimeout;
end;

constructor TUDPCommon.Create;
begin
  FPort      := 0;
  FAsyncMode := False;
  FBroadcast := False;
  FTimeout   := 1000;

  FSocket    := 0;

  FBufferCritSec := TCriticalSection.Create;
  FBufferQueue := TUDPQueue.Create;

  FLogPath := ExtractFilePath(Application.ExeName) + 'UDPLog' + PathDelim;
  FLogExt  := 'UDP.log';

//  FLogPath := '';
//  FLogExt := '';
  FLogEnabled := False;

  FLogCritSec := TCriticalSection.Create;

  FreeOnTerminate := False;

  inherited Create(True);
end;

{$ELSE}
constructor TUDPCommon.Create(APort: Word; ABroadcast: Boolean; ATimeout: Cardinal);
begin
  Create;

  FPort      := APort;
  FAsyncMode := False;
  FBroadcast := ABroadcast;
  FTimeout   := ATimeout;
end;
{$ENDIF}

destructor TUDPCommon.Destroy;
begin
  FreeAndNil(FLogCritSec);

  if (FBufferQueue <> nil) then
  begin
    while (FBufferQueue.Count > 0) do
      Dispose(FBufferQueue.Dequeue);

    FreeAndNil(FBufferQueue);
  end;

  FreeAndNil(FBufferCritSec);

  inherited Destroy;
end;

procedure TUDPCommon.Close;
begin
  SetEvent(FCloseEvent);
end;

function TUDPCommon.WriteLog(ALogType: TUDPLogType; ABuffer: PAnsiChar; ADataSize: Integer): Integer;
var
  FilePath, FileName: String;
  FileStream: TFileStream;
  S: AnsiString;
//  F: TextFile;
  WriteBuf: Pointer;

  function PAnsiCharToHexCode(AValue: PAnsiChar; ADataSize: Integer): AnsiString;
  var
    I: Integer;
  begin
    for I := 0 to ADataSize - 1 do
    begin
      Result := Result + Format('0X%0.2x ', [Ord(AValue[I])]);
    end;
  end;

begin
  FLogCritSec.Enter;
  try
    Result := -1;

    FilePath := Format('%s%s\', [FLogPath, FormatDateTime('YYYY-MM', Date)]);
    FileName := Format('%s%s_%s', [FilePath, FormatDateTime('YYYY-MM-DD', Date), FLogExt]);

    // 디렉토리 있는지 확인 없으면 생성
    if (not DirectoryExists(FilePath)) then ForceDirectories(FilePath);

    try
      if (not FileExists(FileName)) then
        FileStream := TFileStream.Create(FileName, fmCreate or fmShareDenyNone)
      else
        FileStream := TFileStream.Create(FileName, fmOpenWrite or fmShareDenyNone);

      try
        FileStream.Position := FileStream.Size;

        S := FormatDateTime('[hh:nn:ss.zzz]', Now);
        case ALogType of
          ltSend: S := S + ' [S] ';
          ltReceive: S := S + ' [R] ';
          else S := S + ' [T] ';
        end;

        S := S + PAnsiCharToHexCode(ABuffer, ADataSize) + #13#10;

        GetMem(WriteBuf, Length(S) + 1);
        try
          FillChar(WriteBuf^, Length(S) + 1, #0);
          Move(S[1], WriteBuf^, Length(S));
          FileStream.Write(WriteBuf^, Length(S));
        finally
          FreeMemory(WriteBuf);
        end;
      finally
        FreeAndNil(FileStream);
      end;
      Result := Length(S);
    except
//      MessageBeep(MB_ICONERROR);
//      Application.MessageBox(PChar(Format('Cannot create log file %s', [FileName])), PChar(Application.Title), MB_OK or MB_ICONERROR or MB_TOPMOST);
    end;
  finally
    FLogCritSec.Leave;
  end;
{  FCriticalSection.Enter;
  // 디렉토리 있는지 확인 없으면 생성
  if not DirectoryExists(FilePath) then ForceDirectories(FilePath);

  S := FormatDateTime('[hh:nn:ss:zzz]', Now);
  case ALogKind of
    lkSend: S := S + ' [S] ';
    lkReceive: S := S + ' [R] ';
    else S := S + ' [T] ';
  end;

  S := S + PAnsiCharToHexCode(ABuffer, ADataSize);
  try
    AssignFile(F, FileName);
    if FileExists(FileName) then Append(F)
    else Rewrite(F);
    Writeln(F, S);
  finally
    Closefile(F);
  end;
  FCriticalSection.Leave; }
end;

end.
