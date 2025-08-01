program TestMediaInfo;

uses
  Vcl.Forms,
  UnitTestMediaInfo in 'UnitTestMediaInfo.pas' {Form18};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm18, Form18);
  Application.Run;
end.
