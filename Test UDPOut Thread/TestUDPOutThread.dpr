program TestUDPOutThread;

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
  UnitTestUDPOut in 'UnitTestUDPOut.pas' {Form7},
  UnitUDPOut in '..\UDP\UnitUDPOut.pas',
  UnitUDPCommons in '..\UDP\UnitUDPCommons.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm7, Form7);
  Application.Run;
end.

