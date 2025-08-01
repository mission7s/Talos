object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 847
  ClientWidth = 1175
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object mmRecv: TMemo
    Left = 488
    Top = 32
    Width = 513
    Height = 689
    TabOrder = 0
  end
  object btn422: TButton
    Left = 96
    Top = 399
    Width = 75
    Height = 25
    Caption = '422'
    TabOrder = 1
    OnClick = btn422Click
  end
  object btnLoginID: TButton
    Left = 96
    Top = 248
    Width = 75
    Height = 25
    Caption = 'LoginID'
    TabOrder = 2
    OnClick = btnLoginIDClick
  end
  object btn485e: TButton
    Left = 200
    Top = 399
    Width = 75
    Height = 25
    Caption = '485e'
    TabOrder = 3
    OnClick = btn485eClick
  end
  object btnConnect: TButton
    Left = 96
    Top = 183
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 4
    OnClick = btnConnectClick
  end
  object btnReadBufferSize: TButton
    Left = 96
    Top = 496
    Width = 179
    Height = 25
    Caption = 'Read Buffer Size'
    TabOrder = 5
    OnClick = btnReadBufferSizeClick
  end
  object btnPassword: TButton
    Left = 96
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Passwod'
    TabOrder = 6
    OnClick = btnPasswordClick
  end
  object btnDefApply: TButton
    Left = 96
    Top = 447
    Width = 75
    Height = 25
    Caption = 'Def Apply'
    TabOrder = 7
    OnClick = btnDefApplyClick
  end
end
