program TestK3DAsyncEngine;

uses
  Vcl.Forms,
  UnitTestK3DAsyncEngine in 'UnitTestK3DAsyncEngine.pas' {Form1},
  UnitK3DAsyncEngine in '..\..\..\..\Device Units\CG\K3DAsyncEngine\UnitK3DAsyncEngine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
