object frmTimelineChannel: TfrmTimelineChannel
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmTimelineChannel'
  ClientHeight = 77
  ClientWidth = 157
  Color = 6901572
  TransparentColorValue = 2432025
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
  object pnlChannel: TWMPanel
    Left = 0
    Top = 0
    Width = 157
    Height = 77
    Transparent = True
    ColorHighLight = 919047
    ColorShadow = 919047
    Align = alClient
    ParentBackground = False
    ParentColor = True
    TabOrder = 0
    OnDblClick = pnlChannelDblClick
    DesignSize = (
      157
      77)
    object lblChannelPlayedTime: TLabel
      Left = 8
      Top = 49
      Width = 66
      Height = 19
      Alignment = taCenter
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = '00:00:00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clLime
      Font.Height = -19
      Font.Name = 'Crystal'
      Font.Style = []
      ParentFont = False
      OnDblClick = pnlChannelDblClick
    end
    object lblChannelName: TLabel
      Left = 8
      Top = 6
      Width = 59
      Height = 17
      Caption = 'Channel 1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -12
      Font.Name = 'Century Gothic'
      Font.Style = []
      ParentFont = False
      OnDblClick = pnlChannelDblClick
    end
    object lblOnAirFlag: TLabel
      Left = 8
      Top = 26
      Width = 35
      Height = 17
      Anchors = [akLeft]
      Caption = 'On air'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -12
      Font.Name = 'Century Gothic'
      Font.Style = []
      ParentFont = False
      OnDblClick = pnlChannelDblClick
    end
    object lblChannelRemainingTime: TLabel
      Left = 85
      Top = 49
      Width = 66
      Height = 19
      Alignment = taCenter
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = '00:00:00'
      Font.Charset = ANSI_CHARSET
      Font.Color = 33023
      Font.Height = -19
      Font.Name = 'Crystal'
      Font.Style = []
      ParentFont = False
      OnDblClick = pnlChannelDblClick
      ExplicitLeft = 89
    end
  end
end
