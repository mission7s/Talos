unit UnitTCPOut;

interface

uses System.Classes, System.SysUtils, Winapi.Windows, Winapi.Winsock2,
  System.SyncObjs, Generics.Collections, UnitTCPCommons;

type
  TTCPOutRecvThread = class;

  TTCPOut = class(TTCPCommon)
  private
    FSendEvent: THandle;
    FRecvEvent: THandle;

    FTCPOutRecvThread: TTCPOutRecvThread;

    procedure DoSendBuffer;
  protected
    procedure Execute; override;
  public
    function IsConnected: Boolean;
    procedure Send(ABuffer: AnsiString); overload;
  end;

  TTCPOutRecvThread = class(TThread)
  private
    FTCPOut: TTCPOut;
    FConnected: Boolean;

    procedure DoRecvBuffer;
  protected
    procedure Execute; override;
  public
    constructor Create(ATCPOut: TTCPOut); overload; virtual;
    destructor Destroy; override;
  end;

implementation

{ TTCPOut }

function TTCPOut.IsConnected: Boolean;
begin
  Result := (FTCPOutRecvThread <> nil) and (FTCPOutRecvThread.FConnected);
end;

procedure TTCPOut.Send(ABuffer: AnsiString);
var
  PBuffer: PTCPBuffer;
begin
  PBuffer := New(PTCPBuffer);
  FillChar(PBuffer^, SizeOf(TTCPBuffer), #0);

  Move(ABuffer[1], PBuffer^.Buffer, Length(ABuffer));
  PBuffer^.BufSize := Length(ABuffer);

  FBufferCritSec.Enter;
  try
    FBufferQueue.Enqueue(PBuffer);
  finally
    FBufferCritSec.Leave;
  end;

  SetEvent(FSendEvent);
end;

procedure TTCPOut.DoSendBuffer;
var
  Overlapped: TOverlapped;
  Buf: WSABUF;
  SendFlags: Cardinal;
  Sent: DWORD;
  R: DWORD;

  PBuffer: PTCPBuffer;

  SendSize: Integer;
begin
  ResetEvent(FSendEvent);

  FBufferCritSec.Enter;
  try
    while (FBufferQueue.Count > 0) do
    begin
      PBuffer := FBufferQueue.Dequeue;
      try
        // Setup address structure
        SendSize := PBuffer^.BufSize;

        // Send buffer
        if (FAsyncMode) then
        begin
          FillChar(Overlapped, SizeOf(Overlapped), 0);
          Overlapped.hEvent := CreateEvent(nil, True, False, nil);
          if Overlapped.hEvent = 0 then exit;

          try
            Buf.buf := PBuffer^.Buffer;
            Buf.len := SendSize;
            SendFlags := 0;

            if WSASend(FSocket, @Buf, 1, @Sent, SendFlags, @Overlapped, nil) = SOCKET_ERROR then
            begin
              SendSize := SOCKET_ERROR;
              FLastError := WSAGetLastError;
              if (FLastError = WSA_IO_PENDING) then
              begin
                R := WaitForSingleObject(Overlapped.hEvent, INFINITE);
                case R of
                  WAIT_OBJECT_0:
                  begin
                    if GetOverlappedResult(FSocket, Overlapped, Sent, False) then
                    begin
                      SendSize := Sent;
                    end;
                  end;
                end;
              end;
            end
            else
              SendSize := Sent;
          finally
            CloseHandle(Overlapped.hEvent);
          end;
        end
        else
        begin
          if (Winapi.Winsock2.send(FSocket, PBuffer^.Buffer, SendSize, 0) = SOCKET_ERROR) then
          begin
            SendSize := SOCKET_ERROR;
            FLastError := WSAGetLastError;
            exit;
          end;
        end;

{        if (SendSize > 0) then
        begin
          if (LogEnabled) then WriteLog(ltSend, PBuffer^.Buffer, SendSize);
      //    if Assigned(FOnTCPInRead) then FOnTCPInRead(FRecvBuffer, FRecvSize);
        end; }
        if (LogEnabled) then WriteLog(ltSend, PBuffer^.Buffer, PBuffer^.BufSize);
      finally
        Dispose(PBuffer);
      end;
    end;
  finally
    FBufferCritSec.Leave;
  end;
end;

procedure TTCPOut.Execute;
var
  WSAData: TWSAData;
  ServerSockAddr: TSockAddrIn;

  WaitResut: Integer;
  WaitHandles: array [0..1] of THandle;
begin
  FCloseEvent := CreateEvent(nil, True, False, nil);

{  if (FAsyncMode) then
    FSendEvent := CreateEvent(nil, False, False, nil)
  else }
    FSendEvent := CreateEvent(nil, True, False, nil);

{$IFDEF MSWINDOWS}
  if (FAsyncMode) then
    FRecvEvent := CreateEvent(nil, False, False, nil)
  else
{$ENDIF}
    FRecvEvent := CreateEvent(nil, True, True, nil);

{$IFDEF MSWINDOWS}
  // Initialise winsock
  if WSAStartup($0202, WSAData) <> 0 then
  begin
    FLastError := WSAGetLastError;
    FSocket := 0;
    exit;
  end;
{$ENDIF}

  // Create socket
{$IFDEF MSWINDOWS}
  if (FAsyncMode) then
    FSocket := WSASocket(AF_INET, SOCK_STREAM, IPPROTO_IP, nil, 0, WSA_FLAG_OVERLAPPED)
  else
{$ENDIF}
    FSocket := socket(AF_INET, SOCK_STREAM, IPPROTO_IP);

  if (FSocket = INVALID_SOCKET) then
  begin
    FLastError := WSAGetLastError;
    exit;
  end;

  // Timeout
  if (not FAsyncMode) then
  begin
    if (setsockopt(FSocket, SOL_SOCKET, SO_RCVTIMEO, @FTimeout, SizeOf(FTimeout)) = SOCKET_ERROR) then
    begin
      FLastError := WSAGetLastError;
      exit;
    end;
  end;

{$IFDEF MSWINDOWS}
  if (FAsyncMode) then
  begin
    if WSAEventSelect(FSocket, FRecvEvent, FD_CONNECT or FD_READ {or FD_CLOSE}) = SOCKET_ERROR then
    begin
      FLastError := WSAGetLastError;
      exit;
    end;
  end;
{$ENDIF}

  // Setup address structure
  FillChar(ServerSockAddr, SizeOf(TSockAddrIn), #0);
  ServerSockAddr.sin_family := AF_INET;
  ServerSockAddr.sin_port := htons(FPort);
  ServerSockAddr.sin_addr.s_addr := inet_addr(PAnsiChar(AnsiString(FHostIP)));

{$IFDEF MSWINDOWS}
  if (FAsyncMode) then
  begin
    if (WSAconnect(FSocket, TSockAddr(ServerSockAddr), Sizeof(TSockAddr), nil, nil, nil, nil) = SOCKET_ERROR) then
    begin
      FLastError := WSAGetLastError;
      if (FLastError <> WSAEWOULDBLOCK) then
      begin
        exit;
      end;
    end;
  end
  else
{$ENDIF}
  begin
    if (connect(FSocket, TSockAddr(ServerSockAddr), Sizeof(TSockAddr)) = SOCKET_ERROR) then
    begin
      FLastError := WSAGetLastError;
      exit;
    end;
  end;

  FTCPOutRecvThread := TTCPOutRecvThread.Create(Self);
  FTCPOutRecvThread.Start;

  WaitHandles[0] := FCloseEvent;
  WaitHandles[1] := FSendEvent;

  while not Terminated do
  begin
    WaitResut := WaitForMultipleObjects(2, @WaitHandles, False, INFINITE);
    case WaitResut of
      WAIT_OBJECT_0:
      begin
        Break;
      end;
      WAIT_OBJECT_0 + 1: DoSendBuffer;
    end;
  end;

  if (FTCPOutRecvThread <> nil) then
  begin
    FTCPOutRecvThread.Terminate;
    if (FAsyncMode) then
    begin
      FTCPOutRecvThread.WaitFor;
      FreeAndNil(FTCPOutRecvThread);
    end;
  end;

  closesocket(FSocket);
  WSACleanup;

  CloseHandle(FCloseEvent);
  CloseHandle(FSendEvent);
  CloseHandle(FRecvEvent);
end;

{ TTCPOutRecvThread }

constructor TTCPOutRecvThread.Create(ATCPOut: TTCPOut);
begin
  FTCPOut := ATCPOut;

  FConnected := False;

  FreeOnTerminate := (not FTCPOut.AsyncMode);

  inherited Create(True);
end;

destructor TTCPOutRecvThread.Destroy;
begin
  inherited Destroy;
end;

procedure TTCPOutRecvThread.DoRecvBuffer;
var
  ClientSockAddr: TSockAddrIn;
  ClientAddrSize: Integer;

  RecvBuffer: array[0..RECV_BUF_LEN - 1] of AnsiChar;

  DataStr: AnsiString;

  OverLapped: TOverLapped;
  Buf: WSABUF;
  RecvFlags: Cardinal;
  Read: DWORD;
  R: Integer;

  RecvSize: Integer;
begin
  // Read buffer
  ClientAddrSize := SizeOf(TSockAddrIn);
  FillChar(RecvBuffer, SizeOf(RecvBuffer), #0);

{$IFDEF MSWINDOWS}
  RecvSize := SOCKET_ERROR;
  if (FTCPOut.FAsyncMode) then
  begin
    FillChar(OverLapped, SizeOf(OverLapped), 0);
    OverLapped.hEvent := CreateEvent(nil, True, False, nil);
    if OverLapped.hEvent = 0 then exit;

    try
      Buf.buf := RecvBuffer;
      Buf.len := RECV_BUF_LEN;
      RecvFlags := 0;

      if WSARecvFrom(FTCPOut.FSocket, @Buf, 1, @Read, RecvFlags, @TSockAddr(ClientSockAddr), @ClientAddrSize, @Overlapped, nil) = SOCKET_ERROR then
      begin
        FTCPOut.FLastError := WSAGetLastError;
        if (FTCPOut.FLastError = WSA_IO_PENDING) then
        begin
          R := WaitForSingleObject(OverLapped.hEvent, FTCPOut.FTimeout);
          case R of
            WAIT_OBJECT_0:
            begin
              if GetOverlappedResult(FTCPOut.FSocket, OverLapped, Read, False) then
              begin
                RecvSize := Read;
              end;
            end;
          end;
        end;
      end
      else
      begin
        RecvSize := Read;
      end;
    finally
      CloseHandle(OverLapped.hEvent);
    end;
  end
  else
  begin
{$ENDIF}
    RecvSize := recvfrom(FTCPOut.FSocket, RecvBuffer, RECV_BUF_LEN, 0, TSockAddr(ClientSockAddr), ClientAddrSize);
{$IFDEF MSWINDOWS}
  end;
{$ENDIF}

  if (RecvSize <= 0) then
  begin
    FTCPOut.FLastError := WSAGetLastError;
    exit;
  end
  else
  begin
    if (FTCPOut.LogEnabled) then FTCPOut.WriteLog(ltReceive, RecvBuffer, RecvSize);

    if Assigned(FTCPOut.FOnTCPRead) then
    begin
      SetLength(DataStr, RecvSize);
      Move(RecvBuffer, DataStr[1], RecvSize);

      FTCPOut.FOnTCPRead(AnsiString(inet_ntoa(ClientSockAddr.sin_addr)), DataStr, RecvSize);
    end;
  end;
end;

procedure TTCPOutRecvThread.Execute;
var
  WaitResut: Integer;
  WaitHandles: array [0..1] of THandle;

  NetworkEvents: TWSANetworkEvents;
begin
  WaitHandles[0] := FTCPOut.FCloseEvent;
  WaitHandles[1] := FTCPOut.FRecvEvent;

  while not Terminated do
  begin
    WaitResut := WaitForMultipleObjects(2, @WaitHandles, False, INFINITE);
    case WaitResut of
      WAIT_OBJECT_0:
      begin
        Break;
      end;
      WAIT_OBJECT_0 + 1:
      begin
        if (FTCPOut.FAsyncMode) then
        begin
          FillChar(NetworkEvents, SizeOf(TWSANetworkEvents), 0);
          if (WSAEnumNetworkEvents(FTCPOut.FSocket, FTCPOut.FRecvEvent, NetworkEvents) = SOCKET_ERROR) then
          begin
            FTCPOut.FLastError := GetLastError;
            exit;
          end;

          if ((NetworkEvents.lNetworkEvents and FD_CONNECT) = FD_CONNECT) then
          begin
            FConnected := True;
          end
          else if ((NetworkEvents.lNetworkEvents and FD_READ) = FD_READ) then
          begin
            DoRecvBuffer;
          end
        end
        else
          DoRecvBuffer;

        {$IFDEF MSWINDOWS}
        if (not FTCPOut.FAsyncMode) then
          Sleep(30);
        {$ENDIF}
      end;
    end;
  end;
end;

end.
