program TestTAPI;

uses
  Vcl.Forms,
  UnitTestTAPI in 'UnitTestTAPI.pas' {Form1},
  UnitTAPI in '..\..\..\..\Device Units\CG\TAPI\UnitTAPI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
