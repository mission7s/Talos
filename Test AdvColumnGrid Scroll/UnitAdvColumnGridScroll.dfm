object Form14: TForm14
  Left = 0
  Top = 0
  Caption = 'Form14'
  ClientHeight = 493
  ClientWidth = 1385
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object acgPlaylist: TAdvColumnGrid
    Left = 0
    Top = 0
    Width = 877
    Height = 493
    Align = alClient
    BevelWidth = 4
    BorderStyle = bsNone
    Color = 2497307
    ColCount = 12
    Ctl3D = False
    DefaultRowHeight = 26
    DoubleBuffered = True
    DrawingStyle = gdsClassic
    FixedColor = 5060404
    RowCount = 300
    Font.Charset = ANSI_CHARSET
    Font.Color = 12105912
    Font.Height = -14
    Font.Name = 'Century Gothic'
    Font.Style = []
    GradientEndColor = 788230
    GradientStartColor = 788230
    Options = [goFixedVertLine, goFixedHorzLine, goHorzLine, goRangeSelect, goColSizing, goRowMoving, goColMoving, goRowSelect, goThumbTracking, goFixedHotTrack]
    ParentCtl3D = False
    ParentDoubleBuffered = False
    ParentFont = False
    TabOrder = 3
    StyleElements = [seBorder]
    OnDrawCell = acgPlaylistDrawCell
    ActiveRowColor = 11304545
    GridLineColor = 788230
    GridFixedLineColor = 788230
    OnGetDisplText = acgPlaylistGetDisplText
    OnGetCellColor = acgPlaylistGetCellColor
    OnCanEditCell = acgPlaylistCanEditCell
    HighlightColor = 8869383
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -11
    ActiveCellFont.Name = 'Century Gothic'
    ActiveCellFont.Style = [fsBold]
    CellNode.NodeType = cnGlyph
    CellNode.NodeColor = 16765315
    CellNode.NodeIndent = 20
    CellNode.ExpandGlyph.Data = {
      82020000424D820200000000000042000000280000000C0000000C0000000100
      20000300000040020000000000000000000000000000000000000000FF0000FF
      0000FF000000FFD1834AFFD183E7FFD183FFFFD183FFFFD183FFFFD183FFFFD1
      83FFFFD183FFFFD183FFFFD183FFFFD183E6FFD18349FFD183E4FFD183FFFFD1
      83FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD1
      83FFFFD183E6FFD183FFFFD183FFFFD183FFFFD183FFFFD183FFCA9E5EFFCA9E
      5EFFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD1
      83FFFFD183FFD9AC68FF845B2EFF845B2EFFD9AD69FFFFD183FFFFD183FFFFD1
      83FFFFD183FFFFD183FFFFD183FFFFD183FFE6B971FF885F31FF835A2DFF835A
      2DFF885F31FFE6B972FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFF0C3
      79FF8F6535FF835A2DFFB3884EFFB3884EFF835A2DFF8F6535FFF0C379FFFFD1
      83FFFFD183FFFFD183FFF8CA7EFF986E3CFF835A2DFFA57A44FFFDCF81FFFDCF
      81FFA47A44FF835A2DFF986E3CFFF8CA7EFFFFD183FFFFD183FFA87D47FF835A
      2DFF996F3CFFF8CA7EFFFFD183FFFFD183FFF8CA7EFF986F3CFF835A2DFFA87D
      47FFFFD183FFFFD183FFE7BA72FF9F7540FFF0C379FFFFD183FFFFD183FFFFD1
      83FFFFD183FFF0C379FF9E7440FFE7BA72FFFFD183FFFFD183FFFFD183FFFFD1
      83FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD1
      83FFFFD183FFFFD183E7FFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD1
      83FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183E6FFD1834AFFD183E6FFD1
      83FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD1
      83E6FFD18349}
    CellNode.ContractGlyph.Data = {
      82020000424D820200000000000042000000280000000C0000000C0000000100
      20000300000040020000000000000000000000000000000000000000FF0000FF
      0000FF000000FFD1834AFFD183E7FFD183FFFFD183FFFFD183FFFFD183FFFFD1
      83FFFFD183FFFFD183FFFFD183FFFFD183E4FFD1834AFFD183E6FFD183FFFFD1
      83FFE7BA72FFA87D47FFF8CA7EFFFFD183FFFFD183FFFFD183FFFFD183FFFFD1
      83FFFFD183E7FFD183FFFFD183FFFFD183FF9F7540FF835A2DFF986E3CFFF0C3
      79FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD1
      83FFF0C379FF996F3CFF835A2DFF8F6535FFE6B971FFFFD183FFFFD183FFFFD1
      83FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFF8CA7EFFA57A44FF835A
      2DFF885F31FFD9AC68FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD1
      83FFFFD183FFFFD183FFFDCF81FFB3884EFF835A2DFF845B2EFFCA9E5EFFFFD1
      83FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFDCF81FFB388
      4EFF835A2DFF845B2EFFCA9E5EFFFFD183FFFFD183FFFFD183FFFFD183FFFFD1
      83FFFFD183FFF8CA7EFFA47A44FF835A2DFF885F31FFD9AD69FFFFD183FFFFD1
      83FFFFD183FFFFD183FFFFD183FFFFD183FFF0C379FF986F3CFF835A2DFF8F65
      35FFE6B972FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD1
      83FF9E7440FF835A2DFF986E3CFFF0C379FFFFD183FFFFD183FFFFD183FFFFD1
      83FFFFD183FFFFD183E6FFD183FFFFD183FFE7BA72FFA87D47FFF8CA7EFFFFD1
      83FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183E6FFD18349FFD183E6FFD1
      83FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD183FFFFD1
      83E6FFD18349}
    CellNode.TreeColor = 8608301
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
    ControlLook.CheckAlwaysActive = True
    ControlLook.ControlStyle = csFlat
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
    ControlLook.ToggleSwitch.BackgroundBorderWidth = 1.000000000000000000
    ControlLook.ToggleSwitch.ButtonBorderWidth = 1.000000000000000000
    ControlLook.ToggleSwitch.CaptionFont.Charset = DEFAULT_CHARSET
    ControlLook.ToggleSwitch.CaptionFont.Color = clWindowText
    ControlLook.ToggleSwitch.CaptionFont.Height = -15
    ControlLook.ToggleSwitch.CaptionFont.Name = 'Segoe UI'
    ControlLook.ToggleSwitch.CaptionFont.Style = []
    ControlLook.ToggleSwitch.Shadow = False
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
    FixedColWidth = 36
    FixedRowHeight = 26
    FixedFont.Charset = DEFAULT_CHARSET
    FixedFont.Color = 16765315
    FixedFont.Height = -14
    FixedFont.Name = 'Century Gothic'
    FixedFont.Style = []
    Flat = True
    FloatFormat = '%.2f'
    HideFocusRect = True
    HoverButtons.Buttons = <>
    HTMLSettings.ImageFolder = 'images'
    HTMLSettings.ImageBaseName = 'img'
    Look = glListView
    MouseActions.DisjunctRowSelect = True
    MouseActions.NodeAllExpandContract = True
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
    SelectionColorMixer = True
    SelectionTextColor = clHighlightText
    ShowSelection = False
    ShowDesignHelper = False
    SortSettings.HeaderColorTo = 16579058
    SortSettings.HeaderMirrorColor = 16380385
    SortSettings.HeaderMirrorColorTo = 16182488
    VAlignment = vtaCenter
    Version = '3.2.1.2'
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
        Header = 'NO'
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
        Header = 'Start type'
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
        Header = 'Start Time'
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
        Header = 'Duration'
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
        Color = 2497307
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = ANSI_CHARSET
        Font.Color = 12105912
        Font.Height = -14
        Font.Name = 'Century Gothic'
        Font.Style = []
        Header = 'Title'
        HeaderAlignment = taCenter
        HeaderFont.Charset = ANSI_CHARSET
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
        Color = 2497307
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = ANSI_CHARSET
        Font.Color = 12105912
        Font.Height = -14
        Font.Name = 'Century Gothic'
        Font.Style = []
        Header = 'Media'
        HeaderAlignment = taCenter
        HeaderFont.Charset = ANSI_CHARSET
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
        Color = 2497307
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = ANSI_CHARSET
        Font.Color = 12105912
        Font.Height = -14
        Font.Name = 'Century Gothic'
        Font.Style = []
        Header = 'Device'
        HeaderAlignment = taCenter
        HeaderFont.Charset = ANSI_CHARSET
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
        Font.Charset = ANSI_CHARSET
        Font.Color = 12105912
        Font.Height = -14
        Font.Name = 'Century Gothic'
        Font.Style = []
        Header = 'Status'
        HeaderAlignment = taCenter
        HeaderFont.Charset = ANSI_CHARSET
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
        Color = 2497307
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = ANSI_CHARSET
        Font.Color = 12105912
        Font.Height = -14
        Font.Name = 'Century Gothic'
        Font.Style = []
        Header = 'Transition'
        HeaderAlignment = taCenter
        HeaderFont.Charset = ANSI_CHARSET
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
        Color = 2497307
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = ANSI_CHARSET
        Font.Color = 12105912
        Font.Height = -14
        Font.Name = 'Century Gothic'
        Font.Style = []
        Header = 'Finish action'
        HeaderAlignment = taCenter
        HeaderFont.Charset = ANSI_CHARSET
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
        Color = 2497307
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = ANSI_CHARSET
        Font.Color = 12105912
        Font.Height = -14
        Font.Name = 'Century Gothic'
        Font.Style = []
        Header = 'SOM'
        HeaderAlignment = taCenter
        HeaderFont.Charset = ANSI_CHARSET
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
        Color = 2497307
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = ANSI_CHARSET
        Font.Color = 12105912
        Font.Height = -14
        Font.Name = 'Century Gothic'
        Font.Style = []
        Header = 'Description'
        HeaderAlignment = taCenter
        HeaderFont.Charset = ANSI_CHARSET
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
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
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
  object Button1: TButton
    Left = 312
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 624
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button2: TButton
    Left = 464
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 877
    Top = 0
    Width = 508
    Height = 493
    Align = alRight
    Lines.Strings = (
      'Memo1')
    TabOrder = 4
    ExplicitLeft = 875
    ExplicitHeight = 485
  end
end
