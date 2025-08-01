program TestEventTime;

uses
  Vcl.Forms,
  UnitTestEventTime in 'UnitTestEventTime.pas' {Form18},
  UnitCommons in '..\Common\UnitCommons.pas',
  UnitBaseSerial in '..\Common\UnitBaseSerial.pas',
  UnitTypeConvert in '..\Common\UnitTypeConvert.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm18, Form18);
  Application.Run;
end.
