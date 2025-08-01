program PlayerAPI_Test;

uses
  Vcl.Forms,
  UnitMain in 'UnitMain.pas' {Form7},
  UnitOmClipFileDefs in '..\..\..\..\Device Units\Video Server\Omneon\UnitOmClipFileDefs.pas',
  UnitOmMediaDefs in '..\..\..\..\Device Units\Video Server\Omneon\UnitOmMediaDefs.pas',
  UnitOmPlrClnt in '..\..\..\..\Device Units\Video Server\Omneon\UnitOmPlrClnt.pas',
  UnitOmPlrDefs in '..\..\..\..\Device Units\Video Server\Omneon\UnitOmPlrDefs.pas',
  UnitOmTcData in '..\..\..\..\Device Units\Video Server\Omneon\UnitOmTcData.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm7, Form7);
  Application.Run;
end.
