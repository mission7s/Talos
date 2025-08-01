program TestGrassValleyRCL;

uses
  Vcl.Forms,
  UnitBaseSerial in '..\..\..\..\..\Common\UnitBaseSerial.pas',
  UnitGrassValleyRCL in '..\..\..\..\Device Units\Router\Grass Valley Router\UnitGrassValleyRCL.pas',
  UnitTestGrassValleyRCL in 'UnitTestGrassValleyRCL.pas' {Form12};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
