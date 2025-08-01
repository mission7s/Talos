inherited frmLogDevice: TfrmLogDevice
  Caption = 'frmLogDevice'
  ClientHeight = 633
  ClientWidth = 984
  ExplicitWidth = 984
  ExplicitHeight = 633
  TextHeight = 17
  inherited WMPanel: TWMPanel
    Width = 984
    Height = 633
    ExplicitWidth = 984
    ExplicitHeight = 633
    inherited WMTitleBar: TWMTitleBar
      Width = 974
      ExplicitWidth = 974
      inherited WMIBClose: TWMImageSpeedButton
        Left = 943
        ExplicitLeft = 943
      end
      inherited WMIBMinimize: TWMImageSpeedButton
        Left = 906
        ExplicitLeft = 906
      end
    end
    inherited pnlDesc: TWMPanel
      Width = 974
      Height = 565
      ExplicitWidth = 974
      ExplicitHeight = 565
      object acgLogDeviceList: TAdvColumnGrid
        Left = 1
        Top = 1
        Width = 972
        Height = 563
        Cursor = crDefault
        Align = alClient
        BevelWidth = 4
        BorderStyle = bsNone
        Color = 2497307
        ColCount = 4
        Ctl3D = False
        DefaultRowHeight = 26
        DoubleBuffered = True
        DrawingStyle = gdsClassic
        FixedColor = 5060404
        FixedCols = 0
        RowCount = 300
        Font.Charset = ANSI_CHARSET
        Font.Color = 12105912
        Font.Height = -14
        Font.Name = 'Century Gothic'
        Font.Style = []
        GradientEndColor = 788230
        GradientStartColor = 788230
        Options = [goFixedVertLine, goFixedHorzLine, goHorzLine, goColSizing, goColMoving, goRowSelect, goThumbTracking, goFixedHotTrack]
        ParentCtl3D = False
        ParentDoubleBuffered = False
        ParentFont = False
        ScrollBars = ssNone
        TabOrder = 0
        StyleElements = [seBorder]
        OnDrawCell = acgLogDeviceListDrawCell
        ActiveRowColor = 3812392
        GridLineColor = 788230
        GridFixedLineColor = 788230
        HoverRowCells = [hcNormal, hcSelected]
        OnGetDisplText = acgLogDeviceListGetDisplText
        OnGetCellColor = acgLogDeviceListGetCellColor
        HighlightColor = 8869383
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Century Gothic'
        ActiveCellFont.Style = [fsBold]
        CellNode.NodeType = cnFlat
        CellNode.TreeColor = 919047
        ColumnHeaders.Strings = (
          'Time'
          'Control By'
          'Channel'
          'Log')
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
        DisabledFontColor = 9076349
        EditWithTags = True
        EnhTextSize = True
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
        FixedColWidth = 180
        FixedRowHeight = 26
        FixedFont.Charset = ANSI_CHARSET
        FixedFont.Color = clBlack
        FixedFont.Height = -14
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
        MouseActions.RowSelect = True
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
        ScrollColor = 8608301
        ScrollType = ssMetro
        ScrollWidth = 21
        SearchFooter.ColorTo = clWhite
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
        SelectionColor = clNone
        ShowSelection = False
        ShowDesignHelper = False
        SortSettings.DefaultFormat = ssAutomatic
        VAlignment = vtaCenter
        Version = '3.1.6.1'
        WordWrap = False
        Columns = <
          item
            AutoMinSize = 0
            AutoMaxSize = 0
            Alignment = taCenter
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = 2497307
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 12105912
            Font.Height = -14
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'Time'
            HeaderAlignment = taCenter
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 16765315
            HeaderFont.Height = -14
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
            Width = 180
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
            Color = 2497307
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 12105912
            Font.Height = -14
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'Control By'
            HeaderAlignment = taCenter
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 16765315
            HeaderFont.Height = -14
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
            Color = 2497307
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 12105912
            Font.Height = -14
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'Channel'
            HeaderAlignment = taCenter
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 16765315
            HeaderFont.Height = -14
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
            Width = 70
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
            Color = 2497307
            ColumnPopupType = cpFixedCellsRClick
            DropDownCount = 8
            EditLength = 0
            Editor = edNormal
            FilterCaseSensitive = False
            Fixed = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 12105912
            Font.Height = -14
            Font.Name = 'Century Gothic'
            Font.Style = []
            Header = 'Log'
            HeaderAlignment = taCenter
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 16765315
            HeaderFont.Height = -14
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
            Width = 80
          end>
        ColWidths = (
          180
          68
          70
          80)
        RowHeights = (
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26)
      end
    end
  end
end
