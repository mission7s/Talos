unit UnitUDPOut;

interface

uses System.Classes, System.SysUtils, Winapi.Windows, Winapi.Winsock2,
  System.SyncObjs, Generics.Collections, UnitUDPCommons;

type
  TUDPOutRecvThread = class;

  TUDPOut = class(TUDPCommon)
  private
    FSendEvent: THandle;
    FRecvEvent: THandle;

    FUDPOutRecvThread: TUDPOutRecvThread;

    procedure DoSendBuffer;
  protected
    procedure Execute; override;
  public
    procedure Send(AHostIP: AnsiString; ABuffer: AnsiString); overload;
    procedure Send(AHostIP: AnsiString; APort: Word; ABuffer: AnsiString); overload;
  end;

  TUDPOutRecvThread = class(TThread)
  private
    FUDPOut: TUDPOut;

    procedure DoRecvBuffer;
  protected
    procedure Execute; override;
  public
    constructor Create(AUDPOut: TUDPOut); overload; virtual;
    destructor Destroy; override;
  end;

implementation

{ TUDPOut }

procedure TUDPOut.Send(AHostIP: AnsiString; ABuffer: AnsiString);
begin
  Send(AHostIP, FPort, ABuffer);
end;

procedure TUDPOut.Send(AHostIP: AnsiString; APort: Word; ABuffer: AnsiString);
var
  PBuffer: PUDPBuffer;
begin
  PBuffer := New(PUDPBuffer);
  FillChar(PBuffer^, SizeOf(TUDPBuffer), #0);

  Move(AHostIP[1], PBuffer^.HostIP, Length(AHostIP));
  PBuffer^.Port   := APort;
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

procedure TUDPOut.DoSendBuffer;
var
  Overlapped: TOverlapped;
  Buf: WSABUF;
  SendFlags: Cardinal;
  Sent: DWORD;
  R: DWORD;

  PBuffer: PUDPBuffer;
  ServerSockAddr: TSockAddrIn;

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
        FillChar(ServerSockAddr, SizeOf(TSockAddrIn), #0);
        ServerSockAddr.sin_family := AF_INET;
        ServerSockAddr.sin_port := htons(PBuffer^.Port);

        // Broadcast
        if (FBroadcast) then
          ServerSockAddr.sin_addr.s_addr := htonl(INADDR_BROADCAST)
        else
          ServerSockAddr.sin_addr.s_addr := inet_addr(PBuffer^.HostIP);

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

            if WSASendTo(FSocket, @Buf, 1, @Sent, SendFlags, TSockAddr(ServerSockAddr), SizeOf(TSockAddr), @Overlapped, nil) = SOCKET_ERROR then
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
          if (sendto(FSocket, PBuffer^.Buffer, SendSize, 0, @TSockAddr(ServerSockAddr), SizeOf(TSockAddr)) = SOCKET_ERROR) then
          begin
            SendSize := SOCKET_ERROR;
            FLastError := WSAGetLastError;
            exit;
          end;
        end;

{        if (SendSize > 0) then
        begin
          if (LogEnabled) then WriteLog(ltSend, PBuffer^.Buffer, SendSize);
      //    if Assigned(FOnUDPInRead) then FOnUDPInRead(FRecvBuffer, FRecvSize);
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

procedure TUDPOut.Execute;
var
  WSAData: TWSAData;

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
    FSocket := WSASocket(AF_INET, SOCK_DGRAM, IPPROTO_IP, nil, 0, WSA_FLAG_OVERLAPPED)
  else
{$ENDIF}
    FSocket := socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);

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

  // Broadcast
  if (FBroadcast) then
  begin
    if (setsockopt(FSocket, SOL_SOCKET, SO_BROADCAST, @FBroadcast, SizeOf(FBroadcast)) = SOCKET_ERROR) then
    begin
      FLastError := WSAGetLastError;
      exit;
    end;
  end;

{$IFDEF MSWINDOWS}
  if (FAsyncMode) then
  begin
    if WSAEventSelect(FSocket, FRecvEvent, FD_READ) = SOCKET_ERROR then
    begin
      FLastError := WSAGetLastError;
      exit;
    end;
  end;
{$ENDIF}

  FUDPOutRecvThread := TUDPOutRecvThread.Create(Self);
  FUDPOutRecvThread.Start;

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

  if (FUDPOutRecvThread <> nil) then
  begin
    FUDPOutRecvThread.Terminate;
    if (FAsyncMode) then
    begin
      FUDPOutRecvThread.WaitFor;
      FreeAndNil(FUDPOutRecvThread);
    end;
  end;

  closesocket(FSocket);
  WSACleanup;

  CloseHandle(FCloseEvent);
  CloseHandle(FSendEvent);
  CloseHandle(FRecvEvent);
end;

{ TUDPOutRecvThread }

constructor TUDPOutRecvThread.Create(AUDPOut: TUDPOut);
begin
  FUDPOut := AUDPOut;

  FreeOnTerminate := (not FUDPOut.AsyncMode);

  inherited Create(True);
end;

destructor TUDPOutRecvThread.Destroy;
begin
  inherited Destroy;
end;

procedure TUDPOutRecvThread.DoRecvBuffer;
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
  if (FUDPOut.FAsyncMode) then
  begin
    FillChar(OverLapped, SizeOf(OverLapped), 0);
    OverLapped.hEvent := CreateEvent(nil, True, False, nil);
    if OverLapped.hEvent = 0 then exit;

    try
      Buf.buf := RecvBuffer;
      Buf.len := RECV_BUF_LEN;
      RecvFlags := 0;

      if WSARecvFrom(FUDPOut.FSocket, @Buf, 1, @Read, RecvFlags, @TSockAddr(ClientSockAddr), @ClientAddrSize, @Overlapped, nil) = SOCKET_ERROR then
      begin
        FUDPOut.FLastError := WSAGetLastError;
        if (FUDPOut.FLastError = WSA_IO_PENDING) then
        begin
          R := WaitForSingleObject(OverLapped.hEvent, FUDPOut.FTimeout);
          case R of
            WAIT_OBJECT_0:
            begin
              if GetOverlappedResult(FUDPOut.FSocket, OverLapped, Read, False) then
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
    RecvSize := recvfrom(FUDPOut.FSocket, RecvBuffer, RECV_BUF_LEN, 0, TSockAddr(ClientSockAddr), ClientAddrSize);
{$IFDEF MSWINDOWS}
  end;
{$ENDIF}

  if (RecvSize <= 0) then
  begin
    FUDPOut.FLastError := WSAGetLastError;
    exit;
  end
  else
  begin
    if (FUDPOut.LogEnabled) then FUDPOut.WriteLog(ltReceive, RecvBuffer, RecvSize);

    if Assigned(FUDPOut.FOnUDPRead) then
    begin
      SetLength(DataStr, RecvSize);
      Move(RecvBuffer, DataStr[1], RecvSize);
      FUDPOut.FOnUDPRead(AnsiString(inet_ntoa(ClientSockAddr.sin_addr)), DataStr, RecvSize);
    end;
  end;
end;

procedure TUDPOutRecvThread.Execute;
var
  WaitResut: Integer;
  WaitHandles: array [0..1] of THandle;
begin
  WaitHandles[0] := FUDPOut.FCloseEvent;
  WaitHandles[1] := FUDPOut.FRecvEvent;

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
        DoRecvBuffer;

        {$IFDEF MSWINDOWS}
        if (not FUDPOut.FAsyncMode) then
          Sleep(30);
        {$ENDIF}
      end;
    end;
  end;
end;

end.
