program TestUthaRCP3;

uses
  Vcl.Forms,
  UnitTestUthaRCP3 in 'UnitTestUthaRCP3.pas' {Form12},
  UnitBaseSerial in '..\..\..\..\..\Common\UnitBaseSerial.pas',
  UnitUthaRCP3 in '..\..\..\..\Device Units\Router\UTHA\UnitUthaRCP3.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
