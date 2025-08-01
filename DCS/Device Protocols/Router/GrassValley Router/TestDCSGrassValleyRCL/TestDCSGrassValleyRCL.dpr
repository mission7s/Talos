program TestDCSGrassValleyRCL;

uses
  Vcl.Forms,
  UnitTestDCSGrassValleyRCL in 'UnitTestDCSGrassValleyRCL.pas' {Form12},
  UnitDCSDLL in '..\..\..\..\..\Common\UnitDCSDLL.pas',
  UnitCommons in '..\..\..\..\..\Common\UnitCommons.pas',
  UnitBaseSerial in '..\..\..\..\..\Common\UnitBaseSerial.pas',
  UnitTypeConvert in '..\..\..\..\..\Common\UnitTypeConvert.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
