object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 692
  ClientWidth = 865
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    865
    692)
  PixelsPerInch = 96
  TextHeight = 15
  object Label2: TLabel
    Left = 29
    Top = 26
    Width = 63
    Height = 15
    Caption = 'Port Numer'
  end
  object Label3: TLabel
    Left = 13
    Top = 98
    Width = 79
    Height = 15
    Caption = 'Video Channel'
  end
  object Label4: TLabel
    Left = 12
    Top = 127
    Width = 80
    Height = 15
    Caption = 'Audio Channel'
  end
  object Label5: TLabel
    Left = 12
    Top = 156
    Width = 81
    Height = 15
    Caption = 'Transition Type'
  end
  object Label1: TLabel
    Left = 12
    Top = 425
    Width = 79
    Height = 15
    Caption = 'Transition Rate'
  end
  object Label7: TLabel
    Left = 24
    Top = 396
    Width = 67
    Height = 15
    Caption = 'Key Number'
  end
  object Label8: TLabel
    Left = 40
    Top = 268
    Width = 53
    Height = 15
    Caption = 'Take Type'
  end
  object Label6: TLabel
    Left = 14
    Top = 185
    Width = 79
    Height = 15
    Caption = 'Transition Rate'
  end
  object Label9: TLabel
    Left = 30
    Top = 530
    Width = 62
    Height = 15
    Caption = 'Over in/out'
  end
  object Label10: TLabel
    Left = 12
    Top = 559
    Width = 80
    Height = 15
    Caption = 'PST/PGM Over'
  end
  object Label11: TLabel
    Left = 19
    Top = 501
    Width = 73
    Height = 15
    Caption = 'Over Channel'
  end
  object cbComportNum: TComboBox
    Left = 99
    Top = 21
    Width = 145
    Height = 23
    Style = csDropDownList
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    Sorted = True
    TabOrder = 0
  end
  object edVideoChannel: TEdit
    Left = 99
    Top = 95
    Width = 79
    Height = 23
    ImeName = 'Microsoft IME 2010'
    NumbersOnly = True
    TabOrder = 1
    Text = '1'
  end
  object edAudioChannel: TEdit
    Left = 99
    Top = 124
    Width = 79
    Height = 23
    ImeName = 'Microsoft IME 2010'
    NumbersOnly = True
    TabOrder = 2
    Text = '1'
  end
  object cbTransitionType: TComboBox
    Left = 99
    Top = 153
    Width = 335
    Height = 23
    Style = csDropDownList
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    Sorted = True
    TabOrder = 3
  end
  object cbTransitionRate: TComboBox
    Left = 99
    Top = 182
    Width = 335
    Height = 23
    Style = csDropDownList
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    Sorted = True
    TabOrder = 4
  end
  object btnPreset: TButton
    Left = 98
    Top = 211
    Width = 89
    Height = 25
    Caption = 'Preset'
    TabOrder = 5
    OnClick = btnPresetClick
  end
  object btnConnect: TButton
    Left = 250
    Top = 20
    Width = 89
    Height = 25
    Caption = 'Connect'
    TabOrder = 6
    OnClick = btnConnectClick
  end
  object btnDisconnect: TButton
    Left = 345
    Top = 20
    Width = 89
    Height = 25
    Caption = 'Disconnect'
    TabOrder = 7
    OnClick = btnDisconnectClick
  end
  object btnTake: TButton
    Left = 97
    Top = 294
    Width = 89
    Height = 25
    Caption = 'Take'
    TabOrder = 8
    OnClick = btnTakeClick
  end
  object cbKeyTransitionRate: TComboBox
    Left = 98
    Top = 422
    Width = 336
    Height = 23
    Style = csDropDownList
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    Sorted = True
    TabOrder = 9
  end
  object edKeyNumber: TEdit
    Left = 97
    Top = 393
    Width = 79
    Height = 23
    ImeName = 'Microsoft IME 2010'
    NumbersOnly = True
    TabOrder = 10
    Text = '1'
  end
  object btnKeyIn: TButton
    Left = 97
    Top = 451
    Width = 89
    Height = 25
    Caption = 'Key IN'
    TabOrder = 11
    OnClick = btnKeyInClick
  end
  object btnKeyOut: TButton
    Left = 192
    Top = 451
    Width = 89
    Height = 25
    Caption = 'Key OUT'
    TabOrder = 12
    OnClick = btnKeyOutClick
  end
  object btnMachineStatus: TButton
    Left = 98
    Top = 637
    Width = 135
    Height = 25
    Caption = 'Machine Status'
    TabOrder = 13
    OnClick = btnMachineStatusClick
  end
  object mmLog: TMemo
    Left = 480
    Top = 8
    Width = 377
    Height = 676
    Anchors = [akTop, akRight, akBottom]
    ImeName = 'Microsoft IME 2003'
    ScrollBars = ssVertical
    TabOrder = 14
  end
  object cbTakeType: TComboBox
    Left = 98
    Top = 265
    Width = 335
    Height = 23
    Style = csDropDownList
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    Sorted = True
    TabOrder = 15
  end
  object btnDirectProgramChange: TButton
    Left = 97
    Top = 333
    Width = 158
    Height = 25
    Caption = 'Direct Program Change'
    TabOrder = 16
    OnClick = btnDirectProgramChangeClick
  end
  object btnOverDirectInOut: TButton
    Left = 97
    Top = 585
    Width = 158
    Height = 25
    Caption = 'Over Direct In Out'
    TabOrder = 17
    OnClick = btnOverDirectInOutClick
  end
  object cbOverInOut: TComboBox
    Left = 98
    Top = 527
    Width = 102
    Height = 23
    Style = csDropDownList
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    Sorted = True
    TabOrder = 18
  end
  object cbOverPstPgm: TComboBox
    Left = 98
    Top = 556
    Width = 102
    Height = 23
    Style = csDropDownList
    ImeName = #54620#44397#50612' '#51077#47141' '#49884#49828#53596' (IME 2000)'
    TabOrder = 19
  end
  object edInOutChannel: TEdit
    Left = 98
    Top = 498
    Width = 79
    Height = 23
    ImeName = 'Microsoft IME 2010'
    NumbersOnly = True
    TabOrder = 20
    Text = '1'
  end
end
