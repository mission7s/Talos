inherited frmTimelineChannel: TfrmTimelineChannel
  Caption = 'frmTimelineChannel'
  ClientHeight = 135
  ClientWidth = 170
  Font.Name = 'Tahoma'
  ExplicitWidth = 170
  ExplicitHeight = 135
  PixelsPerInch = 96
  TextHeight = 14
  inherited WMPanel: TWMPanel
    Width = 170
    Height = 135
    ExplicitWidth = 1095
    ExplicitHeight = 452
    inherited WMTitleBar: TWMTitleBar
      Width = 160
      Font.Name = 'Tahoma'
      ExplicitWidth = 1085
      inherited WMIBClose: TWMImageSpeedButton
        Left = 121
        ExplicitLeft = 1018
      end
      inherited WMIBMinimize: TWMImageSpeedButton
        Left = 85
        ExplicitLeft = 1004
      end
    end
    inherited pnlDesc: TWMPanel
      Width = 160
      Height = 79
      ExplicitWidth = 1085
      ExplicitHeight = 396
      object pnlChannel: TWMPanel
        Left = 1
        Top = 1
        Width = 158
        Height = 77
        ColorHighLight = 919047
        ColorShadow = 919047
        Align = alClient
        Color = 6901572
        ParentBackground = False
        TabOrder = 0
        ExplicitLeft = -1
        ExplicitTop = 0
        ExplicitWidth = 161
        DesignSize = (
          158
          77)
        object lblChannelPlayedTime: TLabel
          Left = 8
          Top = 49
          Width = 66
          Height = 19
          Alignment = taCenter
          Anchors = [akLeft, akBottom]
          Caption = '00:00:00'
          Font.Charset = ANSI_CHARSET
          Font.Color = clLime
          Font.Height = -19
          Font.Name = 'Crystal'
          Font.Style = []
          ParentFont = False
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
        end
        object lblChannelOnair: TLabel
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
        end
        object lblChannelRemainingTime: TLabel
          Left = 86
          Top = 49
          Width = 66
          Height = 19
          Alignment = taCenter
          Anchors = [akRight, akBottom]
          Caption = '00:00:00'
          Font.Charset = ANSI_CHARSET
          Font.Color = 33023
          Font.Height = -19
          Font.Name = 'Crystal'
          Font.Style = []
          ParentFont = False
          ExplicitLeft = 89
        end
      end
    end
  end
end
