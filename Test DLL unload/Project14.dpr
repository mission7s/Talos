program Project14;

uses
  Vcl.Forms,
  Unit14 in 'Unit14.pas' {Form14},
  UnitMCCDLL in '..\Common\UnitMCCDLL.pas',
  UnitCommons in '..\Common\UnitCommons.pas',
  UnitBaseSerial in '..\Common\UnitBaseSerial.pas',
  UnitTypeConvert in '..\Common\UnitTypeConvert.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm14, Form14);
  Application.Run;
end.
