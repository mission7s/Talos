program TestAdvColumnGridScroll;

uses
  Vcl.Forms,
  UnitAdvColumnGridScroll in 'UnitAdvColumnGridScroll.pas' {Form14},
  UnitConsts in '..\SEC\UnitConsts.pas',
  UnitCommons in '..\Common\UnitCommons.pas',
  UnitDCSDLL in '..\Common\UnitDCSDLL.pas',
  UnitBaseSerial in '..\Common\UnitBaseSerial.pas',
  UnitTypeConvert in '..\Common\UnitTypeConvert.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm14, Form14);
  Application.Run;
end.
