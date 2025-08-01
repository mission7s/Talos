program TestLouth;

uses
  Forms,
  UnitTestLouth in 'UnitTestLouth.pas' {Form1},
  UnitLouth in '..\..\..\Device Units\Video Server\Louth\UnitLouth.pas',
  UnitBaseSerial in '..\..\..\..\Common\UnitBaseSerial.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
