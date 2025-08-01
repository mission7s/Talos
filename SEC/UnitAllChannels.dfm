inherited frmAllChannels: TfrmAllChannels
  Caption = 'frmAllChannels'
  ClientHeight = 452
  ClientWidth = 1095
  ExplicitWidth = 1095
  ExplicitHeight = 452
  TextHeight = 17
  inherited WMPanel: TWMPanel
    Width = 1095
    Height = 452
    ExplicitWidth = 1095
    ExplicitHeight = 452
    inherited WMTitleBar: TWMTitleBar
      Width = 1085
      ExplicitWidth = 1085
      inherited WMIBClose: TWMImageSpeedButton
        Left = 1052
        ExplicitLeft = 1052
      end
      inherited WMIBMinimize: TWMImageSpeedButton
        Left = 1018
        ExplicitLeft = 1018
      end
    end
    inherited pnlDesc: TWMPanel
      Width = 1085
      Height = 384
      ExplicitWidth = 1085
      ExplicitHeight = 384
      object AdvSplitter2: TAdvSplitter
        Left = 303
        Top = 1
        Width = 2
        Height = 382
        AutoSnap = False
        MinSize = 157
        ResizeStyle = rsUpdate
        Appearance.BorderColor = clNone
        Appearance.BorderColorHot = clNone
        Appearance.Color = 1644825
        Appearance.ColorTo = 1644825
        Appearance.ColorHot = 1644825
        Appearance.ColorHotTo = 1644825
        DblClickAction = dbaOpenClose
        GripStyle = sgNone
        ExplicitLeft = 9
        ExplicitTop = 2
      end
      object WMPanel8: TWMPanel
        Left = 305
        Top = 1
        Width = 779
        Height = 382
        ColorHighLight = 2497307
        ColorShadow = 2497307
        Align = alClient
        DoubleBuffered = False
        ParentColor = True
        ParentDoubleBuffered = False
        TabOrder = 0
        object wmtlPlaylist: TWMTimeLine
          Left = 1
          Top = 1
          Width = 777
          Height = 380
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -12
          Font.Name = 'Century Gothic'
          Font.Style = []
          ParentFont = False
          OnMouseWheel = wmtlPlaylistMouseWheel
          FrameNumber = 0
          TimeZoneProperty.Height = 46
          TimeZoneProperty.FrameStart = 0
          TimeZoneProperty.FrameCount = 180000
          TimeZoneProperty.FrameRate = 30.000000000000000000
          TimeZoneProperty.FrameStep = 15
          TimeZoneProperty.FrameGap = 7
          TimeZoneProperty.FrameSkip = 600
          TimeZoneProperty.FrameDayReset = False
          TimeZoneProperty.BarGap = 24
          TimeZoneProperty.BarLarge = 20
          TimeZoneProperty.BarSmall = 10
          TimeZoneProperty.BarColor = 7427652
          TimeZoneProperty.Color = 5060404
          TimeZoneProperty.ColorTo = 5060404
          TimeZoneProperty.MarkColor = clNavy
          TimeZoneProperty.MarkLineColor = 788230
          TimeZoneProperty.Font.Charset = ANSI_CHARSET
          TimeZoneProperty.Font.Color = 16765315
          TimeZoneProperty.Font.Height = -12
          TimeZoneProperty.Font.Name = 'Century Gothic'
          TimeZoneProperty.Font.Style = []
          TimeZoneProperty.RailImage.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000090000
            000A0806000000660574BE0000004D4944415478DA63FCCFC00044F801E35056
            F40C484BE251F31CA4481FC83804C47C58147C02623B46A85D0E40BC0B885991
            14FC066237203EC088E4A050205E01C44C40FC0F8823807835480200C3641A10
            EB5741070000000049454E44AE426082}
          TimeZoneProperty.RailBarColor = clRed
          TimeZoneProperty.RailBarVisible = True
          TimeZoneProperty.Visible = True
          CompositionBarProperty.CaptionHeight = 40
          CompositionBarProperty.MinWidth = 240
          CompositionBarProperty.MaxWidth = 240
          CompositionBarProperty.MinHeight = 200
          CompositionBarProperty.MaxHeight = 400
          CompositionBarProperty.Width = 0
          CompositionBarProperty.Color = 2497307
          CompositionBarProperty.ColorSelected = 12767956
          CompositionBarProperty.Visible = False
          CompositionBarProperty.Font.Charset = DEFAULT_CHARSET
          CompositionBarProperty.Font.Color = clSilver
          CompositionBarProperty.Font.Height = -12
          CompositionBarProperty.Font.Name = 'Tahoma'
          CompositionBarProperty.Font.Style = []
          CompositionBarProperty.TimecodeBarFont.Charset = DEFAULT_CHARSET
          CompositionBarProperty.TimecodeBarFont.Color = clWindowText
          CompositionBarProperty.TimecodeBarFont.Height = -11
          CompositionBarProperty.TimecodeBarFont.Name = 'Tahoma'
          CompositionBarProperty.TimecodeBarFont.Style = []
          CompositionBarProperty.LineHorzColor = 788230
          CompositionBarProperty.LineVertColor = 788230
          ZoomBarProperty.Min = 0
          ZoomBarProperty.Max = 100
          ZoomBarProperty.Position = 0
          VideoGroupProperty.Count = 0
          VideoGroupProperty.HeightRate = 0.450000000000000000
          VideoGroupProperty.Visible = False
          AudioGroupProperty.Count = 0
          AudioGroupProperty.HeightRate = 0.450000000000000000
          AudioGroupProperty.Visible = False
          AudioGroupProperty.DefaultChannelStereo = True
          DataGroupProperty.Count = 10
          DataGroupProperty.HeightRate = 0.100000000000000000
          DataGroupProperty.Visible = True
          VideoTrackProperty.Font.Charset = DEFAULT_CHARSET
          VideoTrackProperty.Font.Color = clWindowText
          VideoTrackProperty.Font.Height = -11
          VideoTrackProperty.Font.Name = 'Tahoma'
          VideoTrackProperty.Font.Style = []
          VideoTrackProperty.Color = 13408882
          VideoTrackProperty.ColorCaption = 13408882
          VideoTrackProperty.ColorSelected = 13750737
          VideoTrackProperty.ColorSelectedCaption = 13750737
          AudioTrackProperty.Font.Charset = DEFAULT_CHARSET
          AudioTrackProperty.Font.Color = clWindowText
          AudioTrackProperty.Font.Height = -11
          AudioTrackProperty.Font.Name = 'Tahoma'
          AudioTrackProperty.Font.Style = []
          AudioTrackProperty.Color = 13408882
          AudioTrackProperty.ColorCaption = 13408882
          AudioTrackProperty.ColorSelected = 13750737
          AudioTrackProperty.ColorSelectedCaption = 13750737
          DataTrackProperty.Font.Charset = ANSI_CHARSET
          DataTrackProperty.Font.Color = clWindowText
          DataTrackProperty.Font.Height = -24
          DataTrackProperty.Font.Name = 'Century Gothic'
          DataTrackProperty.Font.Style = []
          DataTrackProperty.Color = 13408882
          DataTrackProperty.ColorCaption = 13408882
          DataTrackProperty.ColorSelected = 13750737
          DataTrackProperty.ColorSelectedCaption = 13750737
          WorkAreaVisible = True
          ScrollType = ssMetro
          ScrollProperty.Color = 2497307
          ScrollProperty.ParentColor = False
          ScrollProperty.ThumbColor = 8608301
          ScrollProperty.Size = 4
          OnTrackCustomDrawEvent = wmtlPlaylistTrackCustomDrawEvent
          OnTrackHintEvent = wmtlPlaylistTrackHintEvent
          OnDataGroupVertScrollEvent = wmtlPlaylistDataGroupVertScrollEvent
          ExplicitTop = 43
          ExplicitHeight = 338
        end
      end
      object pnlChannel: TWMPanel
        Left = 1
        Top = 1
        Width = 302
        Height = 382
        ColorHighLight = 2432025
        ColorShadow = 2432025
        Align = alLeft
        DoubleBuffered = False
        ParentColor = True
        ParentDoubleBuffered = False
        TabOrder = 1
        object pnlChannelCaption: TWMPanel
          Left = 1
          Top = 1
          Width = 300
          Height = 48
          ColorHighLight = 2432025
          ColorShadow = 2432025
          Align = alTop
          DoubleBuffered = False
          ParentColor = True
          ParentDoubleBuffered = False
          TabOrder = 0
          object imgTimeline: TImage
            Left = 8
            Top = 3
            Width = 149
            Height = 38
            Picture.Data = {
              0954506E67496D61676589504E470D0A1A0A0000000D494844520000005D0000
              0018080600000098E4F11C000004E74944415478DAED995B68154718C727862A
              05B168B5DE8AC6A42A1505438220F8209A63A322226814D40711120BE20DC389
              0A3E798B82F6C10B3D88A52A3E1845F1C10692EA8328AD26FA22B40F4D5A2A2A
              5E305E1FBC44FDFFCF7C1BBFB3EED9B3C793E3AE970FFECC996F6766777E333B
              FBCD9C82C6C64603FB02FACA587B003D3701ADB2B2B2EB37DA2A40D21B2A841E
              E3DA8BA0ED7C4A5600509390FE662C2CDA5FD09834E5393004FB107A49870BFA
              41248B25FB189A8FEBA7C3EE64D48CD05B9096499E30A7417F4AFE4B683EB400
              9A00F515FF53E8327402DA0FB01D74A2AD7148CE40FDA5DC5D5C1B107627A366
              84DE89B487791BF80C681F340CBA089D85FE3676867F074D84A61A3BA3D7417B
              01F89507F81EF487DDD12819A1B7190B48038F43DBA0F3D04AA8354DFD1268B3
              B16FC321680900772AF05F43859FA1A71AA1FF80F4AE7903B61AFA19DA0DAD82
              3AFD1AE09A8E3696E1E71E2881FC8FF4C33716C934E47786DDC9A85981442F8E
              8D84AE42C7A04550C619EA7C48D14E2D92EDD06CF84E85DDB1289B1B3A61339A
              1965EC1A4F635473C5D88FE626E54F9A82CEA8E61CC40FE7F7F0BFCC7473D4E1
              1B559DE6720C6A82EAD056FDFB8081E749BEE5B81FB954E4EBFE1AFA20E81AB4
              1EDAA1CA1441FFCAEF5BC67E347F35DE21E32C249CE515F0FF9E6587F956D5A0
              5E42F279EBB4CF33BC77E80BA1C3D0B7D07555A6C858E875D06472862E412BA0
              3F5CD0B929BA0D1D80BF36CB0EA7400FC334F47CDE4743E768721D1FEA2A5364
              2CF439D0496826B4CBD8F59F9BA17578C81BEAC1195A3EADD4A311ACC3EE995E
              8C8491550CBE66E41951114A3B5421D5B83FE04C4CE03AA3ADB8F8191454C1DF
              AEDAE71E83CBD93C75DB7A94A9F382EE71FF2629562C4AB9BFC7E0C555B95629
              D7EC86FE0B540A8DCF009DD613DA0AAD31F6D8E01B34F84C6EC81DE960E4B7E7
              01FA36E9287DADCAD7201D8C497304D4813231D55693D4AD91BA6532085C22CB
              0342E76037AB769D482FE60055CFD435A06A4270223468E8DC084D814667804E
              E0ABA10DC61E096C4443BBB2019C03F4B8035CD5BB273F4BD4CE98405BC4D72E
              1F6CCEF0728FD9DF2680EA0340EF2BF90ED5C65124ED04ACEAA4BC416A30A812
              0DBD5646A80FF4240D741E60113077A45C5AF8CADCCC157816D0ABF1BBC4558F
              655AE1AF523E775D0E4CC20D42CAB2CFFCF09707804EB8351EF5CB38FBD52CEF
              A707460D309FA34A43E7B6FE0234DBD808C40D9D1A61D4479417B35CBAF305BD
              C1B53677D535F61BD096E9FE02FA5DA0C765D062194260C7EA34742E15FFC843
              C654A121C646330C17D931CEF0AE183C22D0133AAC4B33D3EB33857EDD003DB9
              84E0773FBFFBB837474BA1FDD05CE8B8F2F35C8633FBA1ABFE16199474C653C6
              B51180CE1958EC7C005539BEF25CFBB94C367403F4943A1EE5E671197343E76C
              67617ECDA7CA03F9D9E900D02B4C00CB33F462E98B134A76C8E687EB2FC1978B
              2F27E892679BD54685926AD9496EB4DCD0693C7164AC3D1CE241D6113F581FC2
              F2A27C04A2E3F4848070A29E9CA12B1FDBD2717AC2E99B17741AD724EE4EA71B
              7BDCCBC23CAAFDCF558ED706FAB064AC5CDA2DA3F211593AE8C96BC6CE0A9EB5
              381BA63BC69EA13F92FC72F3E6CF0A2FBB0FE83F85DDC9A8991F746DCE3F453C
              71E4FAE4442F3CA7F1837E0FD0FF0FBB9351B3A0D0D319677C6F9FEBCF00BD57
              D89D8C9AE50A9DA78A7E2772AFF8F75DD89D8C9ABD06B1122B9BA8BB73660000
              000049454E44AE426082}
            Stretch = True
          end
        end
        object pnlChannelList: TWMPanel
          Left = 1
          Top = 49
          Width = 300
          Height = 332
          ColorHighLight = 2432025
          ColorShadow = 2432025
          Align = alClient
          DoubleBuffered = False
          ParentColor = True
          ParentDoubleBuffered = False
          TabOrder = 1
          ExplicitTop = 75
          ExplicitHeight = 306
        end
      end
    end
  end
end
