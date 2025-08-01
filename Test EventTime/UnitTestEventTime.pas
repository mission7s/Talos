unit UnitTestEventTime;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  UnitCommons;

type
  TForm18 = class(TForm)
    btnCalc1: TButton;
    edtBase1: TEdit;
    edtValue1: TEdit;
    edtResult1: TEdit;
    btnCalc2: TButton;
    edtBase2: TEdit;
    edtValue21: TEdit;
    edtResult2: TEdit;
    edtValue22: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnCalc3: TButton;
    edtBase3: TEdit;
    edtValue3: TEdit;
    edtResult3: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    btnCalc4: TButton;
    edtBase4: TEdit;
    edtResult4: TEdit;
    edtValue4: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    btnCalc5: TButton;
    edtBase5: TEdit;
    edtResult5: TEdit;
    edtValue5: TEdit;
    procedure btnCalc1Click(Sender: TObject);
    procedure btnCalc2Click(Sender: TObject);
    procedure btnCalc3Click(Sender: TObject);
    procedure btnCalc4Click(Sender: TObject);
    procedure btnCalc5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form18: TForm18;

implementation

{$R *.dfm}

procedure TForm18.btnCalc1Click(Sender: TObject);
var
  R, B: TEventTime;
  V: TTimecode;
begin
  B := StringToEventTime(edtBase1.Text);
  V := StringToTimecode(edtValue1.Text);
  R := GetEventTimeSubBegin(B, V);

  edtResult1.Text := EventTimeToString(R);
end;

procedure TForm18.btnCalc2Click(Sender: TObject);
var
  R, B: TEventTime;
  V1, V2: TTimecode;
begin
  B := StringToEventTime(edtBase2.Text);
  V1 := StringToTimecode(edtValue21.Text);
  V2 := StringToTimecode(edtValue22.Text);
  R := GetEventTimeSubEnd(B, V1, V2);

  edtResult2.Text := EventTimeToString(R);
end;

procedure TForm18.btnCalc3Click(Sender: TObject);
var
  R, B: TEventTime;
  V: TTimecode;
begin
  B := StringToEventTime(edtBase3.Text);
  V := StringToTimecode(edtValue3.Text);
  R := GetEventEndTime(B, V);

  edtResult3.Text := EventTimeToString(R);
end;

procedure TForm18.btnCalc4Click(Sender: TObject);
var
  R, B, V: TEventTime;
begin
  B := StringToEventTime(edtBase4.Text);
  V := StringToEventTime(edtValue4.Text);
  R := GetDurEventTime(B, V);

  edtResult4.Text := EventTimeToString(R);
end;

procedure TForm18.btnCalc5Click(Sender: TObject);
var
  R, B, V: TEventTime;
begin
  B := StringToEventTime(edtBase5.Text);
  V := StringToEventTime(edtValue5.Text);
  R := GetMinusEventTime(B, V);

  edtResult5.Text := EventTimeToString(R);
end;

end.
