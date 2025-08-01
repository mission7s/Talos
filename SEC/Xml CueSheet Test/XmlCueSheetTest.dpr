program XmlCueSheetTest;

uses
  Vcl.Forms,
  UnitXmlCueSheetTest in 'UnitXmlCueSheetTest.pas' {Form1},
  UnitCommons in '..\..\Common\UnitCommons.pas',
  UnitConsts in '..\UnitConsts.pas',
  UnitBaseSerial in '..\..\Common\UnitBaseSerial.pas',
  UnitTypeConvert in '..\..\Common\UnitTypeConvert.pas',
  UnitDCSDLL in '..\..\Common\UnitDCSDLL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
