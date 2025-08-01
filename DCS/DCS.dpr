program DCS;

uses
  {$IFDEF EurekaLog}
  EMemLeaks,
  EResLeaks,
  EDebugJCL,
  EDebugExports,
  EFixSafeCallException,
  EMapWin32,
  EAppVCL,
  EDialogWinAPIMSClassic,
  EDialogWinAPIEurekaLogDetailed,
  EDialogWinAPIStepsToReproduce,
  ExceptionLog7,
  {$ENDIF EurekaLog}
  Vcl.Forms,
  Winapi.Windows,
  UnitCommons in '..\Common\UnitCommons.pas',
  UnitNormalForm in '..\Common\UnitNormalForm.pas' {frmNormal},
  UnitWorkForm in '..\Common\UnitWorkForm.pas' {frmWork},
  UnitDCS in 'UnitDCS.pas' {frmDCS},
  UnitConsts in 'UnitConsts.pas',
  UnitDeviceThread in 'UnitDeviceThread.pas',
  UnitDeviceLINE in 'Device Threads\Line\UnitDeviceLINE.pas',
  UnitUDPIn in '..\UDP\UnitUDPIn.pas',
  UnitUDPOut in '..\UDP\UnitUDPOut.pas',
  UnitTypeConvert in '..\Common\UnitTypeConvert.pas',
  Vcl.Themes,
  Vcl.Styles,
  UnitBaseSerial in '..\Common\UnitBaseSerial.pas',
  UnitDeviceK3DAsyncEngine in 'Device Threads\CG\K3DAsyncEngine\UnitDeviceK3DAsyncEngine.pas',
  UnitDeviceOMNEON in 'Device Threads\Video Server\Omneon\UnitDeviceOMNEON.pas',
  UnitChannelEvents in 'UnitChannelEvents.pas' {frmChannelEvents},
  UnitLogCommon in 'UnitLogCommon.pas' {frmLogCommon},
  UnitLogDevice in 'UnitLogDevice.pas' {frmLogDevice},
  UnitUDPCommons in '..\UDP\UnitUDPCommons.pas',
  UnitDevicePCSCG in 'Device Threads\PCS\UnitDevicePCSCG.pas',
  UnitDeviceK2ESwitcher in 'Device Threads\Master Switcher\K2E\UnitDeviceK2ESwitcher.pas',
  UnitDeviceGrassValleyRCL in 'Device Threads\Router\Grass Valley Router\UnitDeviceGrassValleyRCL.pas',
  UnitVideoTronSwitcher in 'Device Units\Master Switcher\Video Tron\UnitVideoTronSwitcher.pas',
  UnitOmClipFileDefs in 'Device Units\Video Server\Omneon\UnitOmClipFileDefs.pas',
  UnitOmMediaDefs in 'Device Units\Video Server\Omneon\UnitOmMediaDefs.pas',
  UnitOmPlrClnt in 'Device Units\Video Server\Omneon\UnitOmPlrClnt.pas',
  UnitOmPlrDefs in 'Device Units\Video Server\Omneon\UnitOmPlrDefs.pas',
  UnitOmTcData in 'Device Units\Video Server\Omneon\UnitOmTcData.pas',
  UnitPCSControl in 'Device Units\PCS\UnitPCSControl.pas',
  UnitDeviceList in 'UnitDeviceList.pas' {frmDeviceList},
  UnitDeviceLouth in 'Device Threads\Video Server\Louth\UnitDeviceLouth.pas',
  UnitLouth in 'Device Units\Video Server\Louth\UnitLouth.pas',
  UnitGrassValleyRCL in 'Device Units\Router\Grass Valley Router\UnitGrassValleyRCL.pas',
  UnitImagineLRC in 'Device Units\Router\Imagine Router\UnitImagineLRC.pas',
  UnitDevicePCSSwitcher in 'Device Threads\PCS\UnitDevicePCSSwitcher.pas',
  UnitK2ESwitcher in 'Device Units\Master Switcher\K2E\UnitK2ESwitcher.pas',
  UnitDeviceVTS in 'Device Threads\Master Switcher\Video Tron\UnitDeviceVTS.pas',
  UnitK3DAsyncEngine in 'Device Units\CG\K3DAsyncEngine\UnitK3DAsyncEngine.pas',
  UnitTAPI in 'Device Units\CG\TAPI\UnitTAPI.pas',
  UnitDeviceTAPI in 'Device Threads\CG\TAPI\UnitDeviceTAPI.pas',
  UnitDevicePCSMedia in 'Device Threads\PCS\UnitDevicePCSMedia.pas',
  UnitSingleForm in '..\Common\UnitSingleForm.pas' {frmSingle},
  UnitStartSplash in 'UnitStartSplash.pas' {frmStartSplash},
  UnitDeviceImagineLRC in 'Device Threads\Router\Imagine Router\UnitDeviceImagineLRC.pas',
  UnitQuartz in 'Device Units\Router\Quartz\UnitQuartz.pas',
  UnitDeviceQuartz in 'Device Threads\Router\Quartz\UnitDeviceQuartz.pas',
  UnitDeviceUthaRCP3 in 'Device Threads\Router\UTHA\UnitDeviceUthaRCP3.pas',
  UnitUthaRCP3 in 'Device Units\Router\UTHA\UnitUthaRCP3.pas',
  UnitTCPCommons in '..\TCP\UnitTCPCommons.pas',
  UnitTCPOut in '..\TCP\UnitTCPOut.pas';

{$R *.res}

const
  MUTEX_NAME = 'DCS_V1.0';

var
  Handle: THandle;

begin
  System.ReportMemoryLeaksOnShutdown := True;

  CreateMutex(nil, True, MUTEX_NAME);

  if (GetLastError = ERROR_ALREADY_EXISTS) then
  begin
    Handle := FindWindow('TfrmDCS', nil);
    if (Handle <> 0) then
    begin
      SetForegroundWindow(Handle);
      ShowWindow(Handle, SW_RESTORE);
    end;

    Halt;
  end;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
//  TStyleManager.TrySetStyle('Apc');
  Application.Title := 'Device control server';
  Application.CreateForm(TfrmDCS, frmDCS);
  Application.Run;
end.





