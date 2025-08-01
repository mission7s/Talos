object Form18: TForm18
  Left = 0
  Top = 0
  Caption = 'Form18'
  ClientHeight = 629
  ClientWidth = 1122
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 25
  object Label1: TLabel
    Left = 200
    Top = 117
    Width = 100
    Height = 25
    Caption = 'Event time'
  end
  object Label2: TLabel
    Left = 432
    Top = 117
    Width = 146
    Height = 25
    Caption = 'Parent duration'
  end
  object Label3: TLabel
    Left = 665
    Top = 117
    Width = 137
    Height = 25
    Caption = 'Start timecode'
  end
  object Label4: TLabel
    Left = 200
    Top = 21
    Width = 100
    Height = 25
    Caption = 'Event time'
  end
  object Label5: TLabel
    Left = 432
    Top = 21
    Width = 137
    Height = 25
    Caption = 'Start timecode'
  end
  object Label6: TLabel
    Left = 200
    Top = 221
    Width = 100
    Height = 25
    Caption = 'Event time'
  end
  object Label7: TLabel
    Left = 432
    Top = 221
    Width = 80
    Height = 25
    Caption = 'Duration'
  end
  object Label8: TLabel
    Left = 200
    Top = 325
    Width = 151
    Height = 25
    Caption = 'Start event time'
  end
  object Label9: TLabel
    Left = 432
    Top = 325
    Width = 142
    Height = 25
    Caption = 'End event time'
  end
  object Label10: TLabel
    Left = 200
    Top = 429
    Width = 151
    Height = 25
    Caption = 'Start event time'
  end
  object Label11: TLabel
    Left = 432
    Top = 429
    Width = 142
    Height = 25
    Caption = 'End event time'
  end
  object btnCalc1: TButton
    Left = 8
    Top = 52
    Width = 177
    Height = 33
    Caption = 'Sub begin start'
    TabOrder = 0
    OnClick = btnCalc1Click
  end
  object edtBase1: TEdit
    Left = 200
    Top = 52
    Width = 217
    Height = 33
    TabOrder = 1
    Text = '20230101 12:00:00:00'
  end
  object edtValue1: TEdit
    Left = 432
    Top = 52
    Width = 217
    Height = 33
    TabOrder = 2
    Text = '00:01:00:00'
  end
  object edtResult1: TEdit
    Left = 897
    Top = 52
    Width = 217
    Height = 33
    TabOrder = 3
  end
  object btnCalc2: TButton
    Left = 8
    Top = 148
    Width = 177
    Height = 33
    Caption = 'Sub end start'
    TabOrder = 4
    OnClick = btnCalc2Click
  end
  object edtBase2: TEdit
    Left = 200
    Top = 148
    Width = 217
    Height = 33
    TabOrder = 5
    Text = '20230101 12:00:00:00'
  end
  object edtValue21: TEdit
    Left = 432
    Top = 148
    Width = 217
    Height = 33
    TabOrder = 6
    Text = '00:01:00:00'
  end
  object edtResult2: TEdit
    Left = 897
    Top = 148
    Width = 217
    Height = 33
    TabOrder = 7
  end
  object edtValue22: TEdit
    Left = 665
    Top = 148
    Width = 217
    Height = 33
    TabOrder = 8
    Text = '00:01:00:00'
  end
  object btnCalc3: TButton
    Left = 8
    Top = 252
    Width = 177
    Height = 33
    Caption = 'Event end'
    TabOrder = 9
    OnClick = btnCalc3Click
  end
  object edtBase3: TEdit
    Left = 200
    Top = 252
    Width = 217
    Height = 33
    TabOrder = 10
    Text = '20230101 12:00:00:00'
  end
  object edtValue3: TEdit
    Left = 432
    Top = 252
    Width = 217
    Height = 33
    TabOrder = 11
    Text = '00:01:00:00'
  end
  object edtResult3: TEdit
    Left = 897
    Top = 252
    Width = 217
    Height = 33
    TabOrder = 12
  end
  object btnCalc4: TButton
    Left = 8
    Top = 356
    Width = 177
    Height = 33
    Caption = 'Event duration'
    TabOrder = 13
    OnClick = btnCalc4Click
  end
  object edtBase4: TEdit
    Left = 200
    Top = 356
    Width = 217
    Height = 33
    TabOrder = 14
    Text = '20230101 12:00:00:00'
  end
  object edtResult4: TEdit
    Left = 897
    Top = 356
    Width = 217
    Height = 33
    TabOrder = 15
  end
  object edtValue4: TEdit
    Left = 432
    Top = 356
    Width = 217
    Height = 33
    TabOrder = 16
    Text = '20230101 12:00:00:00'
  end
  object btnCalc5: TButton
    Left = 8
    Top = 460
    Width = 177
    Height = 33
    Caption = 'Minus event time'
    TabOrder = 17
    OnClick = btnCalc5Click
  end
  object edtBase5: TEdit
    Left = 200
    Top = 460
    Width = 217
    Height = 33
    TabOrder = 18
    Text = '20230101 12:00:00:00'
  end
  object edtResult5: TEdit
    Left = 897
    Top = 460
    Width = 217
    Height = 33
    TabOrder = 19
  end
  object edtValue5: TEdit
    Left = 432
    Top = 460
    Width = 217
    Height = 33
    TabOrder = 20
    Text = '20230101 12:00:00:00'
  end
end
