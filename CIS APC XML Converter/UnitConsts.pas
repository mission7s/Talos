unit UnitConsts;

interface

uses System.SysUtils, System.Classes, System.Generics.Collections, System.IniFiles,
  Vcl.Forms, Winapi.Windows, Winapi.Messages, UnitCommons, Dialogs;

const
  WM_ADD_PROCEEDED_LOG  = WM_USER + 2001;
  WM_ADD_PROCEEDED_LIST = WM_USER + 2002;

  // CueSheet List XML Node & Attribute Name'
  XML_CHANNEL_ID      = 'channelid';
  XML_ONAIR_DATE      = 'onairdate';
  XML_ONAIR_FLAG      = 'onairflag';
  XML_ONAIR_NO        = 'onairno';

  XML_EVENT_COUNT     = 'eventcount';
  XML_EVENTS          = 'events';
  XML_EVENT           = 'event';

  XML_ATTR_SERIAL_NO       = 'serialno';
  XML_ATTR_PROGRAM_NO      = 'programno';
  XML_ATTR_GROUP_NO        = 'groupno';
  XML_ATTR_EVENT_MODE      = 'eventmode';
  XML_ATTR_START_MODE      = 'startmode';
  XML_ATTR_START_TIME      = 'starttime';
  XML_ATTR_INPUT           = 'input';
  XML_ATTR_OUTPUT          = 'output';
  XML_ATTR_TITLE           = 'title';
  XML_ATTR_SUB_TITLE       = 'subtitle';
  XML_ATTR_SOURCE          = 'source';
  XML_ATTR_MEDIA_ID        = 'mediaid';
  XML_ATTR_DURATION_TC     = 'durationtc';
  XML_ATTR_IN_TC           = 'intc';
  XML_ATTR_OUT_TC          = 'outtc';
  XML_ATTR_TRANSITION_TYPE = 'transitiontype';
  XML_ATTR_TRANSITION_RATE = 'transitionrate';
  XML_ATTR_FINISH_ACTION   = 'finishaction';
  XML_ATTR_VIDEO_TYPE      = 'videotype';
  XML_ATTR_AUDIO_TYPE      = 'audiotype';
  XML_ATTR_CLOSED_CAPTION  = 'closedcaption';
  XML_ATTR_VOICE_ADD       = 'voiceadd';
  XML_ATTR_PROGRAM_TYPE    = 'programtype';
  XML_ATTR_NOTES           = 'notes';

type
  TChannelCueSheet = packed record
    ChannelId: Word;
    OnairDate: array[0..DATE_LEN] of Char;
    OnairFlag: TOnAirFlagType;
    OnairNo: Integer;
    EventCount: Integer;
    CueSheetList: TCueSheetList;
  end;
  PChannelCueSheet = ^TChannelCueSheet;
  TChannelCueSheetList = TList<PChannelCueSheet>;

  TDeviceMap = packed record
//    Channel: Word;
    EventMode: array[0..DEVICENAME_LEN] of Char;
    EventSource: Word;
    DeviceName: array[0..DEVICENAME_LEN] of Char;
  end;
  PDeviceMap = ^TDeviceMap;
  TDeviceMapList = TList<PDeviceMap>;

  TCueSheetPath = packed record
    FilePath: array[0..MAX_PATH] of Char;
    UserId: array[0..MAX_PATH] of Char;
    Password: array[0..MAX_PATH] of Char;
  end;
  PSendPath = ^TCueSheetPath;
  TSendPathList = TList<PSendPath>;

  TConvertChannel = packed record
    ID: Word;
    SendList: TSendPathList;
    DeviceMapList: TDeviceMapList;
  end;
  PConvertChannel = ^TConvertChannel;
  TConvertChannelList = TList<PConvertChannel>;

var
  GV_SourcePath: TCueSheetPath;
  GV_SuccessPath: TCueSheetPath;
  GV_FailPath: TCueSheetPath;

//  GV_TargetPath: String;

  GV_ProcessInterval: Integer = 1000;

  GV_ConvertChannelList: TConvertChannelList;
//  GV_DeviceMapList: TDeviceMapList;

//  GV_SendPathList: TSendPathList;

procedure LoadConfig;

function GetConvertChannelByChannel(AChannel: Word): PConvertChannel;
function GetDeviceNameByChannelEvent(AChannel: Word; AEventMode: String; AEventSource: Word): String;

procedure ClearConvertChannelList;

implementation

procedure LoadConfig;
var
  IniFile: TIniFile;
  Section, Ident: String;
  NumPath: Word;
  NumChannel, NumSend, NumDeviceMap: Word;
  NumMap: Word;
  I, J: Integer;
  DataStrings: TStrings;

  Channel: PChannel;



  SendPath: PSendPath;
  ConvertChannel: PConvertChannel;
  Send: PSendPath;
  DeviceMap: PDeviceMap;


  aaa: Boolean;
begin
  // Config
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    // Common
//    GV_SourcePath  := ExtractFilePath(Application.ExeName) + IniFile.ReadString('General', 'ReceivedPath', 'Recevied') + PathDelim;
//    GV_SuccessPath := ExtractFilePath(Application.ExeName) + IniFile.ReadString('General', 'SuccededPath', 'Succeded') + PathDelim;
//    GV_FailPath    := ExtractFilePath(Application.ExeName) + IniFile.ReadString('General', 'FailedPath', 'Failed') + PathDelim;
//
//    GV_TargetPath := ExtractFilePath(Application.ExeName) + IniFile.ReadString('General', 'SendedPath', 'Sended') + PathDelim;

{
    GV_SourcePath  := IniFile.ReadString('General', 'ReceivedPath', ExtractFilePath(Application.ExeName) + 'Recevied') + PathDelim;
    GV_SuccessPath := IniFile.ReadString('General', 'SuccededPath', ExtractFilePath(Application.ExeName) + 'Succeded') + PathDelim;
    GV_FailPath    := IniFile.ReadString('General', 'FailedPath', ExtractFilePath(Application.ExeName) + 'Failed') + PathDelim;
}

    // Source Path
    FillChar(GV_SourcePath, SizeOf(TCueSheetPath), #0);
    DataStrings := TStringList.Create;
    try
      ExtractStrings([','], [' '], PChar(IniFile.ReadString('General', 'ReceivedPath', ',,')), DataStrings);
      if (DataStrings.Count > 0) then StrPCopy(GV_SourcePath.FilePath, DataStrings[0] + PathDelim);
      if (DataStrings.Count > 1) then StrPCopy(GV_SourcePath.UserId, DataStrings[1]);
      if (DataStrings.Count > 2) then StrPCopy(GV_SourcePath.Password, DataStrings[2]);

      with GV_SourcePath do
      begin
        if (MakeNetConnection(FilePath, UserId, Password)) then
        begin
          if (not DirectoryExists(FilePath)) then
            if (not ForceDirectories(FilePath)) then
            begin
              MessageBeep(MB_ICONERROR);
              MessageBox(Application.Handle, PChar(Format('Cannot create cuesheet received directory %s', [FilePath])), PChar(Application.Title), MB_OK or MB_ICONERROR);
            end;
        end;
      end;
    finally
      FreeAndNil(DataStrings);
    end;

    // Success Path
    FillChar(GV_SuccessPath, SizeOf(TCueSheetPath), #0);
    DataStrings := TStringList.Create;
    try
      ExtractStrings([','], [' '], PChar(IniFile.ReadString('General', 'SuccededPath', ',,')), DataStrings);
      if (DataStrings.Count > 0) then StrPCopy(GV_SuccessPath.FilePath, DataStrings[0] + PathDelim);
      if (DataStrings.Count > 1) then StrPCopy(GV_SuccessPath.UserId, DataStrings[1]);
      if (DataStrings.Count > 2) then StrPCopy(GV_SuccessPath.Password, DataStrings[2]);

      with GV_SuccessPath do
      begin
        if (MakeNetConnection(FilePath, UserId, Password)) then
        begin
          if (not DirectoryExists(FilePath)) then
            if (not ForceDirectories(FilePath)) then
            begin
              MessageBeep(MB_ICONERROR);
              MessageBox(Application.Handle, PChar(Format('Cannot create cuesheet succeded directory %s', [FilePath])), PChar(Application.Title), MB_OK or MB_ICONERROR);
            end;
        end;
      end;
    finally
      FreeAndNil(DataStrings);
    end;

    // Fail Path
    FillChar(GV_FailPath, SizeOf(TCueSheetPath), #0);
    DataStrings := TStringList.Create;
    try
      ExtractStrings([','], [' '], PChar(IniFile.ReadString('General', 'FailedPath', ',,')), DataStrings);
      if (DataStrings.Count > 0) then StrPCopy(GV_FailPath.FilePath, DataStrings[0] + PathDelim);
      if (DataStrings.Count > 1) then StrPCopy(GV_FailPath.UserId, DataStrings[1]);
      if (DataStrings.Count > 2) then StrPCopy(GV_FailPath.Password, DataStrings[2]);

      with GV_SuccessPath do
      begin
        if (MakeNetConnection(FilePath, UserId, Password)) then
        begin
          if (not DirectoryExists(FilePath)) then
            if (not ForceDirectories(FilePath)) then
            begin
              MessageBeep(MB_ICONERROR);
              MessageBox(Application.Handle, PChar(Format('Cannot create cuesheet failed directory %s', [FilePath])), PChar(Application.Title), MB_OK or MB_ICONERROR);
            end;
        end;
      end;
    finally
      FreeAndNil(DataStrings);
    end;

//    GV_TargetPath := IniFile.ReadString('General', 'SendedPath', ExtractFilePath(Application.ExeName) + 'Sended') + PathDelim;

{    // Target Path
    if not DirectoryExists(GV_TargetPath) then
      if not ForceDirectories(GV_TargetPath) then
      begin
        MessageBeep(MB_ICONERROR);
        MessageBox(Application.Handle, PChar(Format('Cannot create directory %s', [GV_TargetPath])), PChar(Application.Title), MB_OK or MB_ICONERROR);
      end; }

    GV_ProcessInterval := IniFile.ReadInteger('General', 'ProcessInterval', 1);

{    // Send Path
    // Num Send
    NumPath := IniFile.ReadInteger('SendPath', 'NumPath', 0);
    for I := 0 to NumPath - 1 do
    begin
      Ident := Format('Path%d', [I + 1]);

      SendPath := New(PSendPath);
      FillChar(SendPath^, SizeOf(TCueSheetPath), #0);

      DataStrings := TStringList.Create;
      try
        ExtractStrings([','], [' '], PChar(IniFile.ReadString('SendPath', Ident, ',,')), DataStrings);
        if (DataStrings.Count > 0) then StrPCopy(SendPath^.FilePath, DataStrings[0] + PathDelim);
        if (DataStrings.Count > 1) then StrPCopy(SendPath^.UserId, DataStrings[1]);
        if (DataStrings.Count > 2) then StrPCopy(SendPath^.Password, DataStrings[2]);

        with SendPath^ do
        begin
          if (MakeNetConnection(FilePath, UserId, Password)) then
          begin
            if (not DirectoryExists(FilePath)) then
              if (not ForceDirectories(FilePath)) then
              begin
                MessageBeep(MB_ICONERROR);
                MessageBox(Application.Handle, PChar(Format('Cannot create cuesheet send directory %s', [FilePath])), PChar(Application.Title), MB_OK or MB_ICONERROR);
              end;
          end;
        end;
      finally
        FreeAndNil(DataStrings);
      end;

      GV_SendPathList.Add(SendPath);
    end;  }

{    // Convert Channel
    // Num Channel
    NumChannel := IniFile.ReadInteger('ConvertChannel', 'NumChannel', 0);
    for I := 0 to NumChannel - 1 do
    begin
      Ident := Format('Channel%d', [I + 1]);

      ConvertChannel := New(PConvertChannel);
      FillChar(ConvertChannel^, SizeOf(TConvertChannel), #0);

      DataStrings := TStringList.Create;
      try
        ExtractStrings([','], [' '], PChar(IniFile.ReadString('ConvertChannel', Ident, ',0,')), DataStrings);
        ConvertChannel^.Channel := StrToIntDef(DataStrings[0], 0);
      finally
        FreeAndNil(DataStrings);
      end;

      GV_ConvertChannelList.Add(ConvertChannel);
    end;  }

    // Channel
    Section := 'Channel';
    // Num Channel
    NumChannel := IniFile.ReadInteger(Section, 'NumChannel', 0);

    for I := 0 to NumChannel - 1 do
    begin
      Section := Format('Channel%d', [I + 1]);

      ConvertChannel := New(PConvertChannel);
      FillChar(ConvertChannel^, SizeOf(TConvertChannel), #0);

      ConvertChannel^.ID := IniFile.ReadInteger(Section, 'ID', 0);

      // Send Parh
      ConvertChannel^.SendList := TSendPathList.Create;
      // Num Send
      NumSend := IniFile.ReadInteger(Section, 'NumSend', 0);
      for J := 0 to NumSend - 1 do
      begin
        Ident := Format('SendPath%d', [J + 1]);

        SendPath := New(PSendPath);
        FillChar(SendPath^, SizeOf(TCueSheetPath), #0);

        DataStrings := TStringList.Create;
        try
          ExtractStrings([','], [' '], PChar(IniFile.ReadString(Section, Ident, ',,')), DataStrings);
          if (DataStrings.Count > 0) then StrPCopy(SendPath^.FilePath, DataStrings[0] + PathDelim);
          if (DataStrings.Count > 1) then StrPCopy(SendPath^.UserId, DataStrings[1]);
          if (DataStrings.Count > 2) then StrPCopy(SendPath^.Password, DataStrings[2]);

          with SendPath^ do
          begin
            if (MakeNetConnection(FilePath, UserId, Password)) then
            begin
              if (not DirectoryExists(FilePath)) then
                if (not ForceDirectories(FilePath)) then
                begin
                  MessageBeep(MB_ICONERROR);
                  MessageBox(Application.Handle, PChar(Format('Cannot create cuesheet send directory %s', [FilePath])), PChar(Application.Title), MB_OK or MB_ICONERROR);
                end;
            end;
          end;
        finally
          FreeAndNil(DataStrings);
        end;

        ConvertChannel^.SendList.Add(SendPath);
      end;

      // Device Map
      ConvertChannel^.DeviceMapList := TDeviceMapList.Create;
      // Num Map
      NumMap := IniFile.ReadInteger(Section, 'NumMap', 0);
      for J := 0 to NumMap - 1 do
      begin
        Ident := Format('Map%d', [J + 1]);

        DeviceMap := New(PDeviceMap);
        FillChar(DeviceMap^, SizeOf(TDeviceMap), #0);

        DataStrings := TStringList.Create;
        try
          ExtractStrings([','], [' '], PChar(IniFile.ReadString(Section, Ident, ',0,')), DataStrings);
//          DeviceMap^.Channel := StrToIntDef(DataStrings[0], 0);
          StrPCopy(DeviceMap^.EventMode, DataStrings[0]);
          DeviceMap^.EventSource := StrToIntDef(DataStrings[1], 0);
          StrPCopy(DeviceMap^.DeviceName, DataStrings[2]);
        finally
          FreeAndNil(DataStrings);
        end;

        ConvertChannel^.DeviceMapList.Add(DeviceMap);
      end;

      GV_ConvertChannelList.Add(ConvertChannel);
    end;


{    // Device Map
    // Num Map
    NumMap := IniFile.ReadInteger('DeviceMap', 'NumMap', 0);
    for I := 0 to NumMap - 1 do
    begin
      Ident := Format('Map%d', [I + 1]);

      DeviceMap := New(PDeviceMap);
      FillChar(DeviceMap^, SizeOf(TDeviceMap), #0);

      DataStrings := TStringList.Create;
      try
        ExtractStrings([','], [' '], PChar(IniFile.ReadString('DeviceMap', Ident, ',0,')), DataStrings);
        DeviceMap^.Channel := StrToIntDef(DataStrings[0], 0);
        StrPCopy(DeviceMap^.EventMode, DataStrings[1]);
        DeviceMap^.EventSource := StrToIntDef(DataStrings[2], 0);
        StrPCopy(DeviceMap^.DeviceName, DataStrings[3]);
      finally
        FreeAndNil(DataStrings);
      end;

      GV_DeviceMapList.Add(DeviceMap);
    end;  }

  finally
    FreeAndNil(IniFile);
  end;
end;

function GetConvertChannelByChannel(AChannel: Word): PConvertChannel;
var
  I: Integer;
begin
  Result := nil;

  for I := 0 to GV_ConvertChannelList.Count - 1 do
  begin
    if (GV_ConvertChannelList[I] <> nil) and
       (GV_ConvertChannelList[I]^.ID = AChannel) then
    begin
      Result := GV_ConvertChannelList[I];
      break;
    end;
  end;
end;

function GetDeviceNameByChannelEvent(AChannel: Word; AEventMode: String; AEventSource: Word): String;
var
  I: Integer;
  ConvertChannel: PConvertChannel;
begin
  Result := '';

  ConvertChannel := GetConvertChannelByChannel(Achannel);
  if (ConvertChannel <> nil) then
  begin
    if (ConvertChannel^.DeviceMapList <> nil) then
    begin
      for I := 0 to ConvertChannel^.DeviceMapList.Count - 1 do
      begin
        if (ConvertChannel^.DeviceMapList[I] <> nil) and
           (String(ConvertChannel^.DeviceMapList[I].EventMode) = AEventMode) and
           (ConvertChannel^.DeviceMapList[I].EventSource = AEventSource) then
        begin
          Result := String(ConvertChannel^.DeviceMapList[I].DeviceName);
          break;
        end;
      end;
    end;
  end;
end;

procedure ClearConvertChannelList;
var
  I, J: Integer;
  ConvertChannel: PConvertChannel;
  SendList: TSendPathList;
  DeviceMapList: TDeviceMapList;
begin
  // Convert Channel
  for I := GV_ConvertChannelList.Count - 1 downto 0 do
  begin
    ConvertChannel := GV_ConvertChannelList[I];
    if (ConvertChannel <> nil) then
    begin
      SendList := ConvertChannel^.SendList;
      if (SendList <> nil) then
      begin
        for J := SendList.Count - 1 downto 0 do
          Dispose(SendList[J]);

        SendList.Clear;
        FreeAndNil(SendList);
      end;

      DeviceMapList := ConvertChannel^.DeviceMapList;
      if (DeviceMapList <> nil) then
      begin
        for J := DeviceMapList.Count - 1 downto 0 do
          Dispose(DeviceMapList[J]);

        DeviceMapList.Clear;
        FreeAndNil(DeviceMapList);
      end;
    end;

    Dispose(GV_ConvertChannelList[I]);
  end;

  GV_ConvertChannelList.Clear;
end;

end.
