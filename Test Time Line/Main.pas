unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, WMTimeLine, Vcl.StdCtrls;

type
  TForm9 = class(TForm)
    WMTimeLine1: TWMTimeLine;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

{$R *.dfm}

procedure TForm9.FormCreate(Sender: TObject);
var
  I: Integer;
  Track: TTrack;
begin
  for I := 0 to WMTimeLine1.DataGroupProperty.Count - 1 do
  begin
    WMTimeLine1.DataCompositionBars[I].Height := 100;
    WMTimeLine1.DataCompositionBars[I].CompositionStyle := csCollapse;
  end;

  WMTimeLine1.DataCompositionBars[0].Name := 'Main';
  WMTimeLine1.DataCompositionBars[1].Name := 'Join';
  WMTimeLine1.DataCompositionBars[2].Name := 'Sub1';
  WMTimeLine1.DataCompositionBars[3].Name := 'Sub2';

//  WMTimeLine1.DataCompositions[0].SelectedColor := clRed;

  Track := WMTimeLine1.DataCompositions[0].Tracks.Add;
  Track.Color := $00CD9F79;
  Track.SelectedColor := $00B57744;
  Track.Duration := 1000;
  Track.InPoint := 100;
  Track.OutPoint := 1100;

  Track.Caption := '20:00:00 EBS 뉴스, M20170903.mxf';

  Track := WMTimeLine1.DataCompositions[0].Tracks.Add;
  Track.Color := $00DAC1CB;
  Track.SelectedColor := $007B4A60;
  Track.Duration := 1000;
  Track.InPoint := 1500;
  Track.OutPoint := 2500;

  Track.Caption := '20:00:00 EBS 뉴스, M20170903.mxf';

  Track := WMTimeLine1.DataCompositions[0].Tracks.Add;
  Track.Color := $00BDE4D7;
  Track.SelectedColor := $003C9377;
  Track.Duration := 1000;
  Track.InPoint := 3000;
  Track.OutPoint := 4000;

  Track.Caption := '20:00:00 EBS 뉴스, M20170903.mxf';
end;

end.
