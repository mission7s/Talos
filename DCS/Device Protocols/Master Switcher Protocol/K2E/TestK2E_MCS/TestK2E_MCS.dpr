program TestK2E_MCS;

uses
  Vcl.Forms,
  UnitTestK2E_MCS in 'UnitTestK2E_MCS.pas' {Form1},
  UnitK2ESwitcher in '..\..\..\..\Device Units\Master Switcher\K2E\UnitK2ESwitcher.pas',
  UnitBaseSerial in '..\..\..\..\..\Common\UnitBaseSerial.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
