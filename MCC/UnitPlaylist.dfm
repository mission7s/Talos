inherited frmPlaylist: TfrmPlaylist
  Caption = 'frmPlaylist'
  ClientHeight = 545
  ClientWidth = 1131
  Font.Name = 'Tahoma'
  ExplicitWidth = 1131
  ExplicitHeight = 545
  PixelsPerInch = 96
  TextHeight = 14
  inherited WMPanel: TWMPanel
    Width = 1131
    Height = 545
    ExplicitWidth = 1131
    ExplicitHeight = 545
    inherited WMTitleBar: TWMTitleBar
      Width = 1121
      Font.Name = 'Tahoma'
      ExplicitWidth = 1121
      inherited WMIBClose: TWMImageSpeedButton
        Left = 1082
        ExplicitLeft = 1018
      end
      inherited WMIBMinimize: TWMImageSpeedButton
        Left = 1046
        ExplicitLeft = 1004
      end
    end
    inherited pnlDesc: TWMPanel
      Width = 1121
      Height = 477
      ExplicitWidth = 1121
      ExplicitHeight = 477
      object AdvSplitter1: TAdvSplitter
        Left = 1
        Top = 470
        Width = 1119
        Height = 6
        Cursor = crVSplit
        Align = alBottom
        AutoSnap = False
        ResizeStyle = rsUpdate
        Appearance.BorderColor = clNone
        Appearance.BorderColorHot = clNone
        Appearance.Color = 1644825
        Appearance.ColorTo = 1644825
        Appearance.ColorHot = 1644825
        Appearance.ColorHotTo = 1644825
        DblClickAction = dbaOpenClose
        GripStyle = sgNone
        ExplicitTop = 539
        ExplicitWidth = 1077
      end
      object lblChannel: TLabel
        Left = 7
        Top = 4
        Width = 37
        Height = 17
        Caption = 'Status'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -12
        Font.Name = 'Century Gothic'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 110
        Top = 4
        Width = 70
        Height = 17
        Caption = 'Played time'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -12
        Font.Name = 'Century Gothic'
        Font.Style = []
        ParentFont = False
      end
      object lblPlayedTime: TLabel
        Left = 110
        Top = 21
        Width = 94
        Height = 27
        AutoSize = False
        Caption = '00:00:00'
        Font.Charset = ANSI_CHARSET
        Font.Color = clLime
        Font.Height = -27
        Font.Name = 'Crystal'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 222
        Top = 4
        Width = 92
        Height = 17
        Caption = 'Remaining time'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 33023
        Font.Height = -12
        Font.Name = 'Century Gothic'
        Font.Style = []
        ParentFont = False
      end
      object lblRemainingTime: TLabel
        Left = 222
        Top = 21
        Width = 94
        Height = 27
        AutoSize = False
        Caption = '00:00:00'
        Font.Charset = ANSI_CHARSET
        Font.Color = 33023
        Font.Height = -27
        Font.Name = 'Crystal'
        Font.Pitch = fpVariable
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 334
        Top = 4
        Width = 61
        Height = 17
        Caption = 'Next start '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -12
        Font.Name = 'Century Gothic'
        Font.Style = []
        ParentFont = False
      end
      object lblNextStart: TLabel
        Left = 334
        Top = 21
        Width = 127
        Height = 27
        AutoSize = False
        Caption = '00:00:00:00'
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -27
        Font.Name = 'Crystal'
        Font.Style = []
        ParentFont = False
      end
      object Label1: TLabel
        Left = 550
        Top = 4
        Width = 45
        Height = 17
        Caption = 'Playing:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -12
        Font.Name = 'Century Gothic'
        Font.Style = []
        ParentFont = False
      end
      object lblPlayingInfo: TLabel
        Left = 600
        Top = 4
        Width = 400
        Height = 17
        AutoSize = False
        Caption = 'Playing title/Sub title/Media id'
        EllipsisPosition = epEndEllipsis
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -12
        Font.Name = 'Century Gothic'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 564
        Top = 28
        Width = 31
        Height = 17
        Caption = 'Next:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -12
        Font.Name = 'Century Gothic'
        Font.Style = []
        ParentFont = False
      end
      object lblNextInfo: TLabel
        Left = 600
        Top = 28
        Width = 400
        Height = 17
        AutoSize = False
        Caption = 'Next title/Sub title/Media id'
        EllipsisPosition = epEndEllipsis
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -12
        Font.Name = 'Century Gothic'
        Font.Style = []
        ParentFont = False
      end
      object lblOnAirFlag: TLabel
        Left = 7
        Top = 25
        Width = 70
        Height = 24
        AutoSize = False
        Caption = 'Off Air'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -21
        Font.Name = 'Century Gothic'
        Font.Style = []
        ParentFont = False
      end
      object acgPlaylist: TAdvColumnGrid
        Left = 1
        Top = 55
        Width = 1119
        Height = 433
        Cursor = crDefault
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelWidth = 4
        BorderStyle = bsNone
        Color = 3812392
        ColCount = 12
        Ctl3D = False
        DoubleBuffered = True
        DrawingStyle = gdsClassic
        FixedColor = 6901572
        RowCount = 300
        Font.Charset = ANSI_CHARSET
        Font.Color = clSilver
        Font.Height = -12
        Font.Name = 'Century Gothic'
        Font.Style = []
        GradientEndColor = 1644825
        GradientStartColor = 1644825
        Options = [goFixedVertLine, goFixedHorzLine, goHorzLine, goRangeSelect, goColSizing, goColMoving, goRowSelect, goThumbTracking, goFixedHotTrack]
        ParentCtl3D = False
        ParentDoubleBuffered = False
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        StyleElements = [seBorder]
        OnDrawCell = acgPlaylistDrawCell
        ActiveRowColor = 11304545
        GridLineColor = 919047
        GridFixedLineColor = 1644825
        HoverRowCells = [hcNormal, hcSelected]
        OnGetDisplText = acgPlaylistGetDisplText
        OnGetCellColor = acgPlaylistGetCellColor
        OnGetCellBorder = acgPlaylistGetCellBorder
        OnGetCellBorderProp = acgPlaylistGetCellBorderProp
        OnBeforeExpandNode = acgPlaylistBeforeExpandNode
        OnBeforeContractNode = acgPlaylistBeforeContractNode
        OnClickCell = acgPlaylistClickCell
        HighlightColor = 8869383
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Century Gothic'
        ActiveCellFont.Style = [fsBold]
        CellNode.NodeType = cnFlat
        CellNode.TreeColor = 919047
        ColumnHeaders.Strings = (
          'NO'
          'Start type'
          'Start Time'
          'Duration'
          'Title'
          'Media'
          'Device'
          'Status'
          'Transition'
          'Finish action'
          'SOM'
          'Description')
        ControlLook.FixedGradientHoverFrom = 13619409
        ControlLook.FixedGradientHoverTo = 12502728
        ControlLook.FixedGradientHoverMirrorFrom = 12502728
        ControlLook.FixedGradientHoverMirrorTo = 11254975
        ControlLook.FixedGradientDownFrom = 8816520
        ControlLook.FixedGradientDownTo = 7568510
        ControlLook.FixedGradientDownMirrorFrom = 7568510
        ControlLook.FixedGradientDownMirrorTo = 6452086
        ControlLook.FixedGradientDownBorder = 14007466
        ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownHeader.Font.Color = clWindowText
        ControlLook.DropDownHeader.Font.Height = -11
        ControlLook.DropDownHeader.Font.Name = 'Tahoma'
        ControlLook.DropDownHeader.Font.Style = []
        ControlLook.DropDownHeader.Visible = True
        ControlLook.DropDownHeader.Buttons = <>
        ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownFooter.Font.Color = clWindowText
        ControlLook.DropDownFooter.Font.Height = -11
        ControlLook.DropDownFooter.Font.Name = 'Tahoma'
        ControlLook.DropDownFooter.Font.Style = []
        ControlLook.DropDownFooter.Visible = True
        ControlLook.DropDownFooter.Buttons = <>
        EditWithTags = True
        Filter = <>
        FilterDropDown.Font.Charset = DEFAULT_CHARSET
        FilterDropDown.Font.Color = clWindowText
        FilterDropDown.Font.Height = -11
        FilterDropDown.Font.Name = 'Tahoma'
        FilterDropDown.Font.Style = []
        FilterDropDown.TextChecked = 'Checked'
        FilterDropDown.TextUnChecked = 'Unchecked'
        FilterDropDownClear = '(All)'
        FilterEdit.TypeNames.Strings = (
          'Starts with'
          'Ends with'
          'Contains'
          'Not contains'
          'Equal'
          'Not equal'
          'Clear')
        FixedColWidth = 36
        FixedRowHeight = 22
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = 16760237
        FixedFont.Height = -12
        FixedFont.Name = 'Century Gothic'
        FixedFont.Style = []
        Flat = True
        FloatFormat = '%.2f'
        HideFocusRect = True
        HoverButtons.Buttons = <>
        HoverButtons.Position = hbLeftFromColumnLeft
        HTMLSettings.ImageFolder = 'images'
        HTMLSettings.ImageBaseName = 'img'
        Look = glListView
        MouseActions.DisjunctRowSelect = True
        Navigation.KeepHorizScroll = True
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'Tahoma'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'Tahoma'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'Tahoma'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'Tahoma'
        PrintSettings.FooterFont.Style = []
        PrintSettings.PageNumSep = '/'
        ScrollColor = clBlack
        SearchFooter.Color = clBtnFace
        SearchFooter.FindNextCaption = 'Find &next'
        SearchFooter.FindPrevCaption = 'Find &previous'
        SearchFooter.Font.Charset = DEFAULT_CHARSET
        SearchFooter.Font.Color = clWindowText
        SearchFooter.Font.Height = -11
        SearchFooter.Font.Name = 'Tahoma'
        SearchFooter.Font.Style = []
        SearchFooter.HighLightCaption = 'Highlight'
        SearchFooter.HintClose = 'Close'
        SearchFooter.HintFindNext = 'Find next occurrence'
        SearchFooter.HintFindPrev = 'Find previous occurrence'
        SearchFooter.HintHighlight = 'Highlight occurrences'
        SearchFooter.MatchCaseCaption = 'Match case'
        SearchFooter.ResultFormat = '(%d of %d)'
        SelectionColor = 3812392
        SelectionTextColor = clHighlightText
        ShowSelection = False
        ShowDesignHelper = False
        SortSettings.DefaultFormat = ssAutomatic
        SortSettings.HeaderColorTo = 16579058
        SortSettings.HeaderMirrorColor = 16380385
        SortSettings.HeaderMirrorColorTo = 16182488
        VAlignment = vtaCenter
        Version = '3.1.6.1'
        Columns = <
          item
            AutoMinSize = 0
            AutoMaxSize = 0
            Alignment = taRightJustify
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = 3812392
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clSilver
            Font.Height = -12
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'NO'
            HeaderAlignment = taCenter
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 16760237
            HeaderFont.Height = -12
            HeaderFont.Name = 'Century Gothic'
            HeaderFont.Style = []
            MinSize = 0
            MaxSize = 0
            Password = False
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintColor = clWhite
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -11
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            ReadOnly = False
            ShowBands = False
            SortStyle = ssAutomatic
            SpinMax = 0
            SpinMin = 0
            SpinStep = 1
            Tag = 0
            Width = 36
          end
          item
            AutoMinSize = 0
            AutoMaxSize = 0
            Alignment = taCenter
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = 3812392
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clSilver
            Font.Height = -12
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'Start type'
            HeaderAlignment = taCenter
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 16760237
            HeaderFont.Height = -12
            HeaderFont.Name = 'Century Gothic'
            HeaderFont.Style = []
            MinSize = 0
            MaxSize = 0
            Password = False
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintColor = clWhite
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -11
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            ReadOnly = False
            ShowBands = False
            SortStyle = ssAutomatic
            SpinMax = 0
            SpinMin = 0
            SpinStep = 1
            Tag = 0
            Width = 68
          end
          item
            AutoMinSize = 0
            AutoMaxSize = 0
            Alignment = taCenter
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = 3812392
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clSilver
            Font.Height = -12
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'Start Time'
            HeaderAlignment = taCenter
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 16760237
            HeaderFont.Height = -12
            HeaderFont.Name = 'Century Gothic'
            HeaderFont.Style = []
            MinSize = 0
            MaxSize = 0
            Password = False
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintColor = clWhite
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -11
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            ReadOnly = False
            ShowBands = False
            SortStyle = ssAutomatic
            SpinMax = 0
            SpinMin = 0
            SpinStep = 1
            Tag = 0
            Width = 140
          end
          item
            AutoMinSize = 0
            AutoMaxSize = 0
            Alignment = taCenter
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = 3812392
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clSilver
            Font.Height = -12
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'Duration'
            HeaderAlignment = taCenter
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 16760237
            HeaderFont.Height = -12
            HeaderFont.Name = 'Century Gothic'
            HeaderFont.Style = []
            MinSize = 0
            MaxSize = 0
            Password = False
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintColor = clWhite
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -11
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            ReadOnly = False
            ShowBands = False
            SortStyle = ssAutomatic
            SpinMax = 0
            SpinMin = 0
            SpinStep = 1
            Tag = 0
            Width = 90
          end
          item
            AutoMinSize = 0
            AutoMaxSize = 0
            Alignment = taLeftJustify
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = 3812392
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clSilver
            Font.Height = -12
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'Title'
            HeaderAlignment = taCenter
            HeaderFont.Charset = ANSI_CHARSET
            HeaderFont.Color = 16760237
            HeaderFont.Height = -12
            HeaderFont.Name = 'Century Gothic'
            HeaderFont.Style = []
            MinSize = 0
            MaxSize = 0
            Password = False
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintColor = clWhite
            PrintFont.Charset = ANSI_CHARSET
            PrintFont.Color = clWhite
            PrintFont.Height = -12
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            ReadOnly = False
            ShowBands = False
            SortStyle = ssAutomatic
            SpinMax = 0
            SpinMin = 0
            SpinStep = 1
            Tag = 0
            Width = 140
          end
          item
            AutoMinSize = 0
            AutoMaxSize = 0
            Alignment = taLeftJustify
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = 3812392
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clSilver
            Font.Height = -12
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'Media'
            HeaderAlignment = taCenter
            HeaderFont.Charset = ANSI_CHARSET
            HeaderFont.Color = 16760237
            HeaderFont.Height = -12
            HeaderFont.Name = 'Century Gothic'
            HeaderFont.Style = []
            MinSize = 0
            MaxSize = 0
            Password = False
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintColor = clWhite
            PrintFont.Charset = ANSI_CHARSET
            PrintFont.Color = clWhite
            PrintFont.Height = -12
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            ReadOnly = False
            ShowBands = False
            SortStyle = ssAutomatic
            SpinMax = 0
            SpinMin = 0
            SpinStep = 1
            Tag = 0
            Width = 120
          end
          item
            AutoMinSize = 0
            AutoMaxSize = 0
            Alignment = taCenter
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = 3812392
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clSilver
            Font.Height = -12
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'Device'
            HeaderAlignment = taCenter
            HeaderFont.Charset = ANSI_CHARSET
            HeaderFont.Color = 16760237
            HeaderFont.Height = -12
            HeaderFont.Name = 'Century Gothic'
            HeaderFont.Style = []
            MinSize = 0
            MaxSize = 0
            Password = False
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintColor = clWhite
            PrintFont.Charset = ANSI_CHARSET
            PrintFont.Color = clWhite
            PrintFont.Height = -12
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            ReadOnly = False
            ShowBands = False
            SortStyle = ssAutomatic
            SpinMax = 0
            SpinMin = 0
            SpinStep = 1
            Tag = 0
            Width = 68
          end
          item
            AutoMinSize = 0
            AutoMaxSize = 0
            Alignment = taLeftJustify
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = 3812392
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clSilver
            Font.Height = -12
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'Status'
            HeaderAlignment = taCenter
            HeaderFont.Charset = ANSI_CHARSET
            HeaderFont.Color = 16760237
            HeaderFont.Height = -12
            HeaderFont.Name = 'Century Gothic'
            HeaderFont.Style = []
            MinSize = 0
            MaxSize = 0
            Password = False
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintColor = clWhite
            PrintFont.Charset = ANSI_CHARSET
            PrintFont.Color = clWhite
            PrintFont.Height = -12
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            ReadOnly = False
            ShowBands = False
            SortStyle = ssAutomatic
            SpinMax = 0
            SpinMin = 0
            SpinStep = 1
            Tag = 0
            Width = 48
          end
          item
            AutoMinSize = 0
            AutoMaxSize = 0
            Alignment = taCenter
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = 3812392
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clSilver
            Font.Height = -12
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'Transition'
            HeaderAlignment = taCenter
            HeaderFont.Charset = ANSI_CHARSET
            HeaderFont.Color = 16760237
            HeaderFont.Height = -12
            HeaderFont.Name = 'Century Gothic'
            HeaderFont.Style = []
            MinSize = 0
            MaxSize = 0
            Password = False
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintColor = clWhite
            PrintFont.Charset = ANSI_CHARSET
            PrintFont.Color = clWhite
            PrintFont.Height = -12
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            ReadOnly = False
            ShowBands = False
            SortStyle = ssAutomatic
            SpinMax = 0
            SpinMin = 0
            SpinStep = 1
            Tag = 0
            Width = 64
          end
          item
            AutoMinSize = 0
            AutoMaxSize = 0
            Alignment = taLeftJustify
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = 3812392
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clSilver
            Font.Height = -12
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'Finish action'
            HeaderAlignment = taCenter
            HeaderFont.Charset = ANSI_CHARSET
            HeaderFont.Color = 16760237
            HeaderFont.Height = -12
            HeaderFont.Name = 'Century Gothic'
            HeaderFont.Style = []
            MinSize = 0
            MaxSize = 0
            Password = False
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintColor = clWhite
            PrintFont.Charset = ANSI_CHARSET
            PrintFont.Color = clWhite
            PrintFont.Height = -12
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            ReadOnly = False
            ShowBands = False
            SortStyle = ssAutomatic
            SpinMax = 0
            SpinMin = 0
            SpinStep = 1
            Tag = 0
            Width = 88
          end
          item
            AutoMinSize = 0
            AutoMaxSize = 0
            Alignment = taLeftJustify
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = 3812392
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clSilver
            Font.Height = -12
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'SOM'
            HeaderAlignment = taCenter
            HeaderFont.Charset = ANSI_CHARSET
            HeaderFont.Color = 16760237
            HeaderFont.Height = -12
            HeaderFont.Name = 'Century Gothic'
            HeaderFont.Style = []
            MinSize = 0
            MaxSize = 0
            Password = False
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintColor = clWhite
            PrintFont.Charset = ANSI_CHARSET
            PrintFont.Color = clWhite
            PrintFont.Height = -12
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            ReadOnly = False
            ShowBands = False
            SortStyle = ssAutomatic
            SpinMax = 0
            SpinMin = 0
            SpinStep = 1
            Tag = 0
            Width = 64
          end
          item
            AutoMinSize = 0
            AutoMaxSize = 0
            Alignment = taLeftJustify
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = 3812392
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clSilver
            Font.Height = -12
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'Description'
            HeaderAlignment = taCenter
            HeaderFont.Charset = ANSI_CHARSET
            HeaderFont.Color = 16760237
            HeaderFont.Height = -12
            HeaderFont.Name = 'Century Gothic'
            HeaderFont.Style = []
            MinSize = 0
            MaxSize = 0
            Password = False
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintColor = clWhite
            PrintFont.Charset = ANSI_CHARSET
            PrintFont.Color = clWhite
            PrintFont.Height = -12
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            ReadOnly = False
            ShowBands = False
            SortStyle = ssAutomatic
            SpinMax = 0
            SpinMin = 0
            SpinStep = 1
            Tag = 0
            Width = 140
          end>
        ColWidths = (
          36
          68
          140
          90
          140
          120
          68
          48
          64
          88
          64
          140)
        RowHeights = (
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22)
      end
    end
  end
end
