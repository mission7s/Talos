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
  SAEditClearEvent = 1205;
  SAEditFindEvent = 1206;
  SAEditReplaceEvent = 1207;
  SAEditSelectMediaFile = 1208;
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
  // Channel tabs
  SUTabChannelAll = 2101;

  // Device list tabs
  SUTabDeviceList = 2201;




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


  // Information log string 8101~
  // SEC
  LS_SECOpenSuccess = 8101;
  LS_SECCloseSuccess = 8102;
  LS_SECAliveCheckSuccess = 8103;
  LS_SECMainCheckSuccess = 8104;
  LS_SECFindMainSuccess = 8105;
  LS_SECNotFoundMain = 8106;
  LS_SECMainChange = 8107;

  // DCS
  LS_DCSAliveCheckSuccess = 8201;
  LS_DCSMainCheckSuccess = 8202;
  LS_DCSOpenDeviceSuccess = 8203;
  LS_DCSCloseDeviceSuccess = 8204;
  LS_DCSSetControlBySuccess = 8205;


  // MCC
  LS_MCCOpenSuccess = 8301;
  LS_MCCCloseSuccess = 8302;
  LS_MCCAliveCheckSuccess = 8303;



  // Error log string 9101~
  // SEC
  LSE_SECSysInitializeFailed = 9101;
  LSE_SECSysFinalizeFailed = 9102;
  LSE_SECSysLogInPortEnableFailed = 9103;
  LSE_SECSysLogOutPortEnableFailed = 9104;
  LSE_SECSysSetServerReadProcFailed = 9105;
  LSE_SECInitializeFailed = 9106;
  LSE_SECFinalizeFailed = 9107;
  LSE_SECLogNotifyPortEnableFailed = 9108;
  LSE_SECLogInPortEnableFailed = 9109;
  LSE_SECLogOutPortEnableFailed = 9110;
  LSE_SECLogNotifyPortDisableFailed = 9111;
  LSE_SECLogInPortDisableFailed = 9112;
  LSE_SECLogOutPortDisableFailed = 9113;
  LSE_SECSetServerReadProcFailed = 9114;
  LSE_SECOpenFailed = 9115;
  LSE_SECCloseFailed = 9116;
  LSE_SECAliveCheckFailed = 9117;
  LSE_SECMainCheckFailed = 9118;

  // DCS
  LSE_DCSSysInitializeFailed = 9201;
  LSE_DCSSysFinalizeFailed = 9202;
  LSE_DCSSysLogInPortEnableFailed = 9203;
  LSE_DCSSysLogOutPortEnableFailed = 9204;
  LSE_DCSSysLogInPortDisableFailed = 9205;
  LSE_DCSSysLogOutPortDisableFailed = 9206;
  LSE_DCSInitializeFailed = 9207;
  LSE_DCSFinalizeFailed = 9208;
  LSE_DCSLogNotifyPortEnableFailed = 9209;
  LSE_DCSLogInPortEnableFailed = 9210;
  LSE_DCSLogOutPortEnableFailed = 9211;
  LSE_DCSLogNotifyPortDisableFailed = 9212;
  LSE_DCSLogInPortDisableFailed = 9213;
  LSE_DCSLogOutPortDisableFailed = 9214;
  LSE_DCSSetDeviceStatusNotifyFailed = 9215;
  LSE_DCSSetEventStatusNotifyFailed = 9216;
  LSE_DCSSetEventOverallNotifyFailed = 9217;
  LSE_DCSAliveCheckFailed = 9218;
  LSE_DCSMainCheckFailed = 9219;
  LSE_DCSOpenDeviceFailed = 9220;
  LSE_DCSCloseDeviceFailed = 9221;
  LSE_DCSSetControlByFailed = 9222;

  // MCC
  LSE_MCCSysInitializeFailed = 9301;
  LSE_MCCSysFinalizeFailed = 9302;
  LSE_MCCSysLogInPortEnableFailed = 9303;
  LSE_MCCSysLogOutPortEnableFailed = 9304;
  LSE_MCCInitializeFailed = 9305;
  LSE_MCCFinalizeFailed = 9306;
  LSE_MCCLogNotifyPortEnableFailed = 9307;
  LSE_MCCLogInPortEnableFailed = 9308;
  LSE_MCCLogOutPortEnableFailed = 9309;
  LSE_MCCLogNotifyPortDisableFailed = 9310;
  LSE_MCCLogInPortDisableFailed = 9311;
  LSE_MCCLogOutPortDisableFailed = 9312;
  LSE_MCCOpenFailed = 9313;
  LSE_MCCCloseFailed = 9314;
  LSE_MCCAliveCheckFailed = 9315;

