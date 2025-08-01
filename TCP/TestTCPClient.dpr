program TestTCPClient;

uses
  Vcl.Forms,
  UnitTestTCPClient in 'UnitTestTCPClient.pas' {Form1},
  UnitUDPCommons in '..\UDP\UnitUDPCommons.pas',
  UnitUDPIn in '..\UDP\UnitUDPIn.pas',
  UnitUDPOut in '..\UDP\UnitUDPOut.pas',
  UnitTCPCommons in 'UnitTCPCommons.pas',
  UnitTCPOut in 'UnitTCPOut.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
