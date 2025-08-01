program MCC;

uses
  Vcl.Forms,
  UnitBaseSerial in '..\Common\UnitBaseSerial.pas',
  UnitCommons in '..\Common\UnitCommons.pas',
  UnitDCSDLL in '..\Common\UnitDCSDLL.pas',
  UnitNormalForm in '..\Common\UnitNormalForm.pas' {frmNormal},
  UnitSingleForm in '..\Common\UnitSingleForm.pas' {frmSingle},
  UnitTypeConvert in '..\Common\UnitTypeConvert.pas',
  UnitWorkForm in '..\Common\UnitWorkForm.pas' {frmWork},
  UnitUDPIn in '..\UDP\UnitUDPIn.pas',
  UnitUDPOut in '..\UDP\UnitUDPOut.pas',
  UnitMCC in 'UnitMCC.pas' {frmMCC},
  UnitConsts in 'UnitConsts.pas',
  UnitTimeline in 'UnitTimeline.pas' {frmTimeline},
  UnitTimelineChannel in 'UnitTimelineChannel.pas' {frmTimelineChannel},
  UnitPlaylist in 'UnitPlaylist.pas' {frmPlaylist},
  UnitUDPCommons in '..\UDP\UnitUDPCommons.pas',
  UnitDevice in 'UnitDevice.pas' {frmDevice},
  UnitStartSplash in 'UnitStartSplash.pas' {frmStartSplash};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Multi channel controller';
  Application.CreateForm(TfrmMCC, frmMCC);
  Application.Run;
end.
