program TestHLK20v01;

uses
  Forms,
  UnitTestHLK20v01 in 'UnitTestHLK20v01.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

