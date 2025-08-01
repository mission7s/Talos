program TestVTS;

uses
  Vcl.Forms,
  UnitTestVTS in 'UnitTestVTS.pas' {Form1},
  UnitBaseSerial in '..\..\..\..\..\Common\UnitBaseSerial.pas',
  UnitVideoTronSwitcher in '..\..\..\..\Device Units\Master Switcher\Video Tron\UnitVideoTronSwitcher.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
