object form1: Tform1
  Left = 0
  Top = 0
  Caption = 'form1'
  ClientHeight = 404
  ClientWidth = 627
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
  object mmDesc: TMemo
    Left = 210
    Top = 8
    Width = 409
    Height = 388
    ImeName = 'Microsoft IME 2010'
    TabOrder = 0
  end
  object UDPIn: TIdUDPServer
    Bindings = <>
    DefaultPort = 0
    ThreadedEvent = True
    OnUDPRead = UDPInUDPRead
    Left = 32
    Top = 8
  end
end
