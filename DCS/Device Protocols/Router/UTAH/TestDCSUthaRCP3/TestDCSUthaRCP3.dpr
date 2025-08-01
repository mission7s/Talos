program TestDCSUthaRCP3;

uses
  Vcl.Forms,
  UnitTestDCSUthaRCP3 in 'UnitTestDCSUthaRCP3.pas' {Form12},
  UnitDCSDLL in '..\..\..\..\..\Common\UnitDCSDLL.pas',
  UnitBaseSerial in '..\..\..\..\..\Common\UnitBaseSerial.pas',
  UnitCommons in '..\..\..\..\..\Common\UnitCommons.pas',
  UnitTypeConvert in '..\..\..\..\..\Common\UnitTypeConvert.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
