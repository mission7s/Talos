object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
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
  object UDPOut: TIdUDPClient
    Port = 0
    Left = 32
    Top = 24
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 112
    Top = 24
  end
end
