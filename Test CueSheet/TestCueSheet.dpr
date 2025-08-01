program TestCueSheet;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form8},
  UnitCommons in '..\Common\UnitCommons.pas',
  UnitConsts in '..\SEC\UnitConsts.pas',
  UnitTypeConvert in '..\Common\UnitTypeConvert.pas',
  Vcl.Themes,
  Vcl.Styles,
  UnitDCSDLL in '..\Common\UnitDCSDLL.pas',
  UnitBaseSerial in '..\Common\UnitBaseSerial.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Apc');
  Application.CreateForm(TForm8, Form8);
  Application.Run;
end.
