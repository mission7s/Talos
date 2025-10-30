const
  // Action 1101~
  // SEC
  // File action
  SAFile = 1101;
  SAFileNewPlaylist = 1102;
  SAFileOpenPlaylist = 1103;
  SAFileOpenAddPlaylist = 1104;
  SAFileSavePlaylist = 1105;
  SAFileSaveAsPlaylist = 1106;
  SAFileClose = 1107;

  // Edit action
  SAEdit = 1201;
  SAEditCopyEvent = 1202;
  SAEditCutEvent = 1203;
  SAEditPasteEvent = 1204;
  SAEditFindEvent = 1205;
  SAEditReplaceEvent = 1206;
  SAEditClearClipboard = 1207;
  SAEditSelectMedia = 1208;
  SAEditTimelineZoomIn = 1209;
  SAEditTimelineZoomOut = 1210;
  SAEditTimelineMoveLeft = 1211;
  SAEditTimelineMoveRight = 1212;
  SAEditTimelineGotoCurrent = 1213;

  // Control action
  SAControl = 1301;
  SAControlStartOnAir = 1302;
  SAControlFreezeOnAir = 1303;
  SAControlBreakOnair = 1304;
  SAControlFinishOnAir = 1305;
  SAControlCatchOnair = 1306;
  SAControlAssignNextEvent = 1307;
  SAControlStartNextEventImmediately = 1308;
  SAControlIncrease1Second = 1309;
  SAControlDecrease1Second = 1310;
  SAControlAssignTargetEvent = 1311;
  SAControlGotoCurrentEvent = 1312;

  // Event action
  SAEvent = 1401;
  SAEventInsert = 1402;
  SAEventInsertProgram = 1403;
  SAEventInsertMainEvent = 1404;
  SAEventInsertJoinEvent = 1405;
  SAEventInsertSubEvent = 1406;
  SAEventInsertCommentEvent = 1407;
  SAEventUpdateEvent = 1408;
  SAEventDeleteEvent = 1409;
  SAEventInspectEvent = 1410;
  SAEventSourceExchange = 1411;


  // UI 2101~
  // SEC
  // Pages
  SUTabChannelAll = 2101;
  SUTabDeviceList = 2102;

  // Channel form
  // Time
  SUTimePlayed = 2201;
  SUTimeRemaining = 2202;
  SUTimeNextStart = 2203;
  SUTimeNextDuration = 2204;
  SUTimeRemainigTarget = 2205;

  // CueSheet grid title
  SUCueSheetNo = 2211;
  SUCueSheetEventMode = 2212;
  SUCueSheetEventStatus = 2213;
  SUCueSheetStartMode = 2214;
  SUCueSheetStartDate = 2215;
  SUCueSheetStartTime = 2216;
  SUCueSheetDuration = 2217;
  SUCueSheetMediaID = 2218;
  SUCueSheetTitle = 2219;
  SUCueSheetSubTitle = 2220;
  SUCueSheetSource = 2221;
  SUCueSheetMediaStaus = 2222;
  SUCueSheetInTC = 2223;
  SUCueSheetOutTC = 2224;
  SUCueSheetInput = 2225;
  SUCueSheetOutput = 2226;
  SUCueSheetTrType = 2227;
  SUCueSheetTrRate = 2228;
  SUCueSheetFinishAction = 2229;
  SUCueSheetVideoType = 2230;
  SUCueSheetAudioType = 2231;
  SUCueSheetClosedCaption = 2232;
  SUCueSheetVoiceAdd = 2233;
  SUCueSheetProgramType = 2234;
  SUCueSheetNotes = 2235;

  // Device form
  // Device grid title
  SUDeviceNo = 2301;
  SUDeviceName = 2302;
  SUDeviceStatus = 2303;
  SUDeviceTimecode = 2304;
  SUDeviceControl = 2305;



  // Information message 4101~
  // SEC
  SSECStart = 4101;
  SLookingForSEC = 4102;
  SLookingForAllComponentAndDevice = 4103;
  SNotFoundComponentAndContinue = 4104;

  SLookingForMCC = 4105;
  SEInvalidSettinMCC = 4106;

  SLookingForDCS = 4107;
  SEInvalidSettinDCS = 4108;

  // Device
  SLookingForDevice = 4201;
  SLookingForAllDevice = 4202;
  SNotFoundDeviceAndContinue = 4203;

  // Edit Event
  SEnterEventMode = 4301;
  SEnterStartMode = 4302;
  SEnterInput = 4303;
  SEnterOutput = 4304;
  SEnterTitle = 4305;
  SEnterSource = 4306;
  SEnterSourceLayer = 4307;
  SEnterTransitionType = 4308;
  SEnterTransitionRate = 4309;
  SEnterFinishAction = 4310;
  SEnterProgramType = 4311;
  SEnterCompletedFileFolder = 4312;
  SEnterCompletedFileStoredDays = 4313;

  // CheSheet
  SLoadingCuesheetFile = 4401;
  SUpdatingCuesheet = 4402;
  SCompletedLoadingCuesheetFile = 4403;
  SInvalidTimeocde = 4404;
  SStartTimeGreaterThenBeforeEndTime = 4405;
  SSubStartTimeGreaterThenParentStartTime = 4406;
  SSubStartTimeLessThenParentEndTime = 4407;
  SDurationTCGreaterThenMinDuration = 4408;
  SDurationTCLessThenMaxDuration = 4409;
  SInTCLessThenDurationTC = 4410;
  SInTCLessThenOutTC = 4411;
  SOutTCLessThenDurationTC = 4412;
  SOutTCGreaterThenInTC = 4413;
  SQDeleteEvent = 4414;

  // OnAir
  SChannelAlreadyRunning = 4501;
  SFreezeOnAirTimeout = 4502;
  SBreakCurrentTimeout = 4503;
  SSetNextTimeout = 4504;
  SEnqueueTimeout = 4505;
  SQStartOnAirByManual = 4506;
  SQFinishtOnAirAndPreserveEvent = 4507;
  SQFinishtOnAirAndClearEvent = 4508;
  SQSourceExchange = 4509;


  // Error message 5101~
  // SEC
  SEInvalidSettinSEC = 5101;
  SEInvalidSettinProgramType = 5102;

  // Device
  SEInvalidSettinXpt = 5201;
  SEInvalidSettinMCS = 5202;

  // CheSheet
  SEPasteLocationIncorrect = 5401;
  SEPasteHasProgramLocationIncorrect = 5402;
  SEPasteHasMainLocationIncorrect = 5403;
  SEPasteJoinSubLocationIncorrect = 5404;
  SESourceExchangeLocationIncorrect = 5405;
  SENoCreateCuesheetWhileChannelOnair = 5406;
  SENoOpenCuesheetWhileChannelOnair = 5407;

  // OnAir
  SENextEventNotReady = 5501;
  SEChangedOnAirEvent = 5502;
  SENotPossibleEditLockTime = 5503;
  SENotPossibleEditBeforeLocationIncorrect = 5504;
  SENotInsertProgramLocationIncorrect = 5505;
  SENotInsertMainLocationIncorrect = 5506;
  SENotInsertJoinSubLocationIncorrect = 5507;


  // Warning message 6101~
  // Device
  SWDeviceCommError = 6201;
  SWDeviceStatusNotConnect = 6202;

  // CheSheet
  SWNotExistNextEvent = 6401;


