program TestRemoteControl;

uses
  Vcl.Forms,
  UnitTestRemoteControl in 'UnitTestRemoteControl.pas' {Form12},
  UnitUDPCommons in '..\..\..\..\UDP\UnitUDPCommons.pas',
  UnitUDPIn in '..\..\..\..\UDP\UnitUDPIn.pas',
  UnitUDPOut in '..\..\..\..\UDP\UnitUDPOut.pas',
  UnitPCSControl in '..\..\..\Device Units\PCS\UnitPCSControl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
