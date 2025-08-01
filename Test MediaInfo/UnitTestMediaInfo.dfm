object Form18: TForm18
  Left = 0
  Top = 0
  Caption = 'Form18'
  ClientHeight = 618
  ClientWidth = 804
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    804
    618)
  PixelsPerInch = 96
  TextHeight = 14
  object sBtnLoadFileName: TSpeedButton
    Left = 768
    Top = 104
    Width = 23
    Height = 22
    OnClick = sBtnLoadFileNameClick
  end
  object btnLoadMediaInfoDLL: TButton
    Left = 24
    Top = 24
    Width = 177
    Height = 25
    Caption = 'Load MediaInfo DLL'
    TabOrder = 0
    OnClick = btnLoadMediaInfoDLLClick
  end
  object mmDesc: TMemo
    Left = 224
    Top = 136
    Width = 572
    Height = 474
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object btnNewMediaInfo: TButton
    Left = 24
    Top = 64
    Width = 177
    Height = 25
    Caption = 'New MediaInfo'
    TabOrder = 2
    OnClick = btnNewMediaInfoClick
  end
  object btnOpenMediaInfo: TButton
    Left = 24
    Top = 104
    Width = 177
    Height = 25
    Caption = 'Open MediaInfo'
    TabOrder = 3
    OnClick = btnOpenMediaInfoClick
  end
  object edtFileName: TEdit
    Left = 224
    Top = 104
    Width = 537
    Height = 22
    TabOrder = 4
    Text = 'D:\CIAB\Media\2022-04-26 11-30-03.mkv'
  end
  object btnGetDuration: TButton
    Left = 24
    Top = 144
    Width = 177
    Height = 25
    Caption = 'Get Duration'
    TabOrder = 5
    OnClick = btnGetDurationClick
  end
end
