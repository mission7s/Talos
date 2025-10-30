program SEC_Lang_ko;

uses
  Vcl.Forms,
  UnitSEC_Lang_ko in 'UnitSEC_Lang_ko.pas' {$R *.res},
  UnitSEC_Lang_ko_dummy in 'UnitSEC_Lang_ko_dummy.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Run;
  UnitSEC_Lang_ko_dummy.ForceLink;
end.

