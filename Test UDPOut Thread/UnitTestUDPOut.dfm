object Form7: TForm7
  Left = 0
  Top = 0
  Caption = 'Form7'
  ClientHeight = 300
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnSend: TButton
    Left = 24
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 0
    OnClick = btnSendClick
  end
  object edtSend: TEdit
    Left = 120
    Top = 58
    Width = 457
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 1
  end
  object edtHostIP: TEdit
    Left = 120
    Top = 26
    Width = 457
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 2
  end
end
