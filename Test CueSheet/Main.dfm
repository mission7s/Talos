object Form8: TForm8
  Left = 0
  Top = 0
  Caption = 'Form8'
  ClientHeight = 862
  ClientWidth = 1227
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 864
    Top = 27
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'Channel Id:'
  end
  object Label2: TLabel
    Left = 864
    Top = 51
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'Onair Date:'
  end
  object Label3: TLabel
    Left = 867
    Top = 75
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'Onair Flag:'
  end
  object Label4: TLabel
    Left = 874
    Top = 100
    Width = 46
    Height = 13
    Alignment = taRightJustify
    Caption = 'Onair No:'
  end
  object TreeView1: TTreeView
    Left = 24
    Top = 24
    Width = 569
    Height = 154
    Indent = 19
    TabOrder = 0
  end
  object AdvColumnGrid1: TAdvColumnGrid
    Left = 24
    Top = 184
    Width = 1049
    Height = 273
    ColCount = 23
    DrawingStyle = gdsClassic
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    TabOrder = 1
    StyleElements = [seBorder]
    OnGetEditText = AdvColumnGrid1GetEditText
    OnKeyPress = AdvColumnGrid1KeyPress
    OnSelectCell = AdvColumnGrid1SelectCell
    OnSetEditText = AdvColumnGrid1SetEditText
    OnGetDisplText = AdvColumnGrid1GetDisplText
    OnClickCell = AdvColumnGrid1ClickCell
    OnCanEditCell = AdvColumnGrid1CanEditCell
    OnCellValidate = AdvColumnGrid1CellValidate
    OnCellsChanged = AdvColumnGrid1CellsChanged
    OnCheckBoxClick = AdvColumnGrid1CheckBoxClick
    OnComboChange = AdvColumnGrid1ComboChange
    OnEditingDone = AdvColumnGrid1EditingDone
    OnEditCellDone = AdvColumnGrid1EditCellDone
    OnEditChange = AdvColumnGrid1EditChange
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -11
    ActiveCellFont.Name = 'Tahoma'
    ActiveCellFont.Style = [fsBold]
    ActiveCellColor = 15387318
    ColumnHeaders.Strings = (
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      ''
      '')
    ControlLook.FixedGradientFrom = clWhite
    ControlLook.FixedGradientTo = clBtnFace
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
    ControlLook.ToggleSwitch.BackgroundBorderWidth = 1.000000000000000000
    ControlLook.ToggleSwitch.ButtonBorderWidth = 1.000000000000000000
    ControlLook.ToggleSwitch.CaptionFont.Charset = DEFAULT_CHARSET
    ControlLook.ToggleSwitch.CaptionFont.Color = clWindowText
    ControlLook.ToggleSwitch.CaptionFont.Height = -15
    ControlLook.ToggleSwitch.CaptionFont.Name = 'Segoe UI'
    ControlLook.ToggleSwitch.CaptionFont.Style = []
    ControlLook.ToggleSwitch.Shadow = False
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
      'Larger than'
      'Smaller than'
      'Clear')
    FixedRowHeight = 22
    FixedFont.Charset = DEFAULT_CHARSET
    FixedFont.Color = clBlack
    FixedFont.Height = -11
    FixedFont.Name = 'Tahoma'
    FixedFont.Style = [fsBold]
    FloatFormat = '%.2f'
    GridImages = ImageList1
    HoverButtons.Buttons = <>
    HTMLSettings.ImageFolder = 'images'
    HTMLSettings.ImageBaseName = 'img'
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
    ScrollWidth = 21
    SearchFooter.ColorTo = 15790320
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
    SortSettings.HeaderColorTo = 16579058
    SortSettings.HeaderMirrorColor = 16380385
    SortSettings.HeaderMirrorColorTo = 16182488
    Version = '3.2.1.2'
    Columns = <
      item
        AutoMinSize = 0
        AutoMaxSize = 0
        Alignment = taLeftJustify
        Borders = [cbRight]
        BorderPen.Color = clSilver
        ButtonHeight = 18
        CheckFalse = 'N'
        CheckTrue = 'Y'
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edComboList
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        EditMask = '!0000-!90-90 !90:00:00:00;1; '
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Color = clWindow
        ColumnPopupType = cpFixedCellsRClick
        DropDownCount = 8
        EditLength = 0
        Editor = edNormal
        FilterCaseSensitive = False
        Fixed = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        HeaderAlignment = taLeftJustify
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -11
        HeaderFont.Name = 'Tahoma'
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
        Width = 64
      end>
    ColWidths = (
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64)
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
      22)
  end
  object Button1: TButton
    Left = 599
    Top = 22
    Width = 130
    Height = 25
    Caption = 'Load Cue Sheet'
    TabOrder = 2
    OnClick = Button1Click
  end
  object edtChannelID: TEdit
    Left = 926
    Top = 24
    Width = 121
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 3
    Text = 'edtChannelID'
  end
  object edtOnairDate: TEdit
    Left = 926
    Top = 48
    Width = 121
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 4
    Text = 'edtOnairDate'
  end
  object edtOnairFlag: TEdit
    Left = 926
    Top = 72
    Width = 121
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 5
    Text = 'edtOnairFlag'
  end
  object edtOnairNo: TEdit
    Left = 926
    Top = 97
    Width = 121
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 6
    Text = 'edtOnairNo'
  end
  object MaskEdit1: TMaskEdit
    Left = 926
    Top = 144
    Width = 114
    Height = 21
    EditMask = '!0000-!90-90 !90:00:00:00;1; '
    ImeName = 'Microsoft IME 2010'
    MaxLength = 22
    TabOrder = 7
    Text = '    -  -     :  :  :  '
  end
  object WMTimeLine1: TWMTimeLine
    Left = 24
    Top = 463
    Width = 1142
    Height = 351
    Color = 2171169
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    FrameNumber = 1800
    TimeZoneProperty.Height = 32
    TimeZoneProperty.FrameStart = 0
    TimeZoneProperty.FrameCount = 2589408
    TimeZoneProperty.FrameRate = 29.970000000000000000
    TimeZoneProperty.FrameStep = 30
    TimeZoneProperty.FrameGap = 7
    TimeZoneProperty.FrameSkip = 600
    TimeZoneProperty.FrameDayReset = False
    TimeZoneProperty.BarGap = 14
    TimeZoneProperty.BarLarge = 20
    TimeZoneProperty.BarSmall = 10
    TimeZoneProperty.BarColor = 5329233
    TimeZoneProperty.Color = 1644825
    TimeZoneProperty.ColorTo = 1644825
    TimeZoneProperty.MarkColor = clNavy
    TimeZoneProperty.MarkLineColor = 8555662
    TimeZoneProperty.Font.Charset = DEFAULT_CHARSET
    TimeZoneProperty.Font.Color = clSilver
    TimeZoneProperty.Font.Height = -12
    TimeZoneProperty.Font.Name = 'Tahoma'
    TimeZoneProperty.Font.Style = []
    TimeZoneProperty.RailImage.Data = {
      07544269746D61700E030000424D0E0300000000000036000000280000000D00
      00000E0000000100200000000000D80200000000000000000000000000000000
      000000808000008080000080800000808000008080000080800000C0E0000080
      8000008080000080800000808000008080000080800000808000008080000080
      800000808000008080000080800000C0E0008080800000808000008080000080
      80000080800000808000008080000080800000808000008080000080800000C0
      E00000C0E00000C0E00000808000008080000080800000808000008080000080
      80000080800000808000008080000080800000C0E00000C0E00000C0E0008080
      8000008080000080800000808000008080000080800000808000008080000080
      800000C0E00000C0E00000C0E00000C0E00000C0E00000808000008080000080
      8000008080000080800000808000008080000080800000C0E00000C0E00000C0
      E00000C0E00000C0E00080808000008080000080800000808000008080000080
      80000080800000C0E00000C0E00000C0E00000C0E00000C0E00000C0E00000C0
      E00000808000008080000080800000808000008080000080800000C0E00000C0
      E00000C0E00000C0E00000C0E00000C0E00000C0E00080808000008080000080
      8000008080000080800000C0E00000C0E00000C0E00000C0E00000C0E00000C0
      E00000C0E00000C0E00000C0E0000080800000808000008080000080800000C0
      E00000C0E00000C0E00000C0E00000C0E00000C0E00000C0E00000C0E00000C0
      E00080808000008080000080800000C0E00000C0E00000C0E00000C0E00000C0
      E00000C0E00000C0E00000C0E00000C0E00000C0E00000C0E000008080000080
      800000C0E00000C0E00000C0E00000C0E00000C0E00000C0E00000C0E00000C0
      E00000C0E00000C0E00000C0E0008080800000C0E00000C0E00000C0E00000C0
      E00000C0E00000C0E00000C0E00000C0E00000C0E00000C0E00000C0E00000C0
      E00000C0E00000C0E00000C0E00000C0E00000C0E00000C0E00000C0E00000C0
      E00000C0E00000C0E00000C0E00000C0E00000C0E00000C0E000}
    TimeZoneProperty.RailBarColor = clRed
    TimeZoneProperty.RailBarVisible = True
    TimeZoneProperty.Visible = True
    CompositionBarProperty.CaptionHeight = 20
    CompositionBarProperty.MinWidth = 120
    CompositionBarProperty.MaxWidth = 240
    CompositionBarProperty.MinHeight = 48
    CompositionBarProperty.MaxHeight = 480
    CompositionBarProperty.Width = 120
    CompositionBarProperty.Color = 2500134
    CompositionBarProperty.ColorSelected = 12767956
    CompositionBarProperty.Visible = True
    CompositionBarProperty.Font.Charset = DEFAULT_CHARSET
    CompositionBarProperty.Font.Color = clSilver
    CompositionBarProperty.Font.Height = -12
    CompositionBarProperty.Font.Name = 'Tahoma'
    CompositionBarProperty.Font.Style = []
    CompositionBarProperty.TimecodeBarFont.Charset = DEFAULT_CHARSET
    CompositionBarProperty.TimecodeBarFont.Color = clWhite
    CompositionBarProperty.TimecodeBarFont.Height = -12
    CompositionBarProperty.TimecodeBarFont.Name = 'Tahoma'
    CompositionBarProperty.TimecodeBarFont.Style = []
    CompositionBarProperty.LineHorzColor = 1644825
    CompositionBarProperty.LineVertColor = 1644825
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
    DataGroupProperty.Count = 4
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
    DataTrackProperty.Font.Charset = DEFAULT_CHARSET
    DataTrackProperty.Font.Color = clWindowText
    DataTrackProperty.Font.Height = -11
    DataTrackProperty.Font.Name = 'Tahoma'
    DataTrackProperty.Font.Style = []
    DataTrackProperty.Color = 13408882
    DataTrackProperty.ColorCaption = 13408882
    DataTrackProperty.ColorSelected = 13750737
    DataTrackProperty.ColorSelectedCaption = 13750737
    WorkAreaVisible = True
  end
  object Button2: TButton
    Left = 599
    Top = 70
    Width = 130
    Height = 25
    Caption = 'DCS Open'
    TabOrder = 9
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 599
    Top = 109
    Width = 130
    Height = 25
    Caption = 'Start Cue Sheet'
    TabOrder = 10
  end
  object IglTree: TImageList
    Left = 452
    Top = 8
    Bitmap = {
      494C01010D000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      000000000000000000000000000000000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000BF0000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000BFFFFFFF0000FFFF000000
      0000008080000080800000808000008080000080800000808000008080000080
      80000080800000000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000080800000808000008080000080800000808000008080000080
      80000080800000808000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000BFFFFFFF0000FFFFBFFFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000BF0000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000BFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFFFF00000000BF0000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000BF0000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF000000000000008080808000808080808080
      8000808080808080800080808080808080008080808080808000808080808080
      800080808080808080008080808080808000000000BF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000008080808000000000BF00000000000000BFFF00
      0000FF0000BFFF000000FF0000BFFF000000FF0000BFFF000000008000000080
      00000080000000000000000000BF00000000000000BF0000000000FFFFBF0000
      000000FFFFBF0000000000FFFFBF0000000000FFFFBF0000000000FFFFBF0000
      0000000000BF00000000000000BF00000000000000BFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFF
      FF00000000BF00000000000000BF00000000000000BF0000000000FFFFBF0000
      000000FFFFBF0000000000FFFFBF0000000000FFFFBF0000000000FFFFBF0000
      000000FFFFBF000000000000008080808000000000BF00000000000000BFFF00
      0000FF0000BFFF000000FF0000BFFF000000FF00000000800000008000000080
      00000080000000000000000000BF000000000000000000FFFF000000000000FF
      FF0000000000000000000000000000FFFF0000000000000000000000000000FF
      FF000000000000000000000000BF000000000000000000FFFF000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000000000000000BF000000000000000000FFFF00000000000000
      00000000000000FFFF0000000000000000000000000000FFFF00000000000000
      00000000000000FFFF000000008080808000000000BF00000000000000BFFF00
      0000FF0000BFFF000000FF0000BFFF000000FF00000000800000008000000080
      00000080000000000000000000BF00000000000000BF0000000000FFFF000000
      0000000000BF0000000000FFFFBF0000000000FFFFBF0000000000FFFFBF0000
      000000FFFFBF00000000000000BF00000000000000BFFFFFFF00000000BFFFFF
      FF0000FFFFBFFFFFFF0000FFFFBFFFFFFF00000000BFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF00000000BF00000000000000BF00000000000000BF0000
      0000000000BF0000000000FFFF000000000000FFFFBF00000000000000BF0000
      0000000000BF000000000000008080808000000000BF00000000000000BFFF00
      0000FF0000BFFFFF0000FFFF00BFFFFF00000080000000800000008000000080
      00000080000000000000000000BF000000000000000000FFFF00000000000000
      00000000000000FFFF000000000000FFFF0000000000000000000000000000FF
      FF000000000000FFFF0000000000000000000000000000FFFF00000000000000
      00000000000000FFFF00FFFFFF0000FFFF000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000FFFF000000000000FF
      FF000000000000FFFF0000000000000000000000000000FFFF000000000000FF
      FF000000000000FFFF000000008080808000000000BF00000000000000BFFFFF
      0000FFFF00BFFFFF0000FFFF00BFFFFF00000080000000800000008000000080
      00000080000000000000000000BF00000000000000BF0000000000FFFF000000
      0000000000BF0000000000FFFF000000000000FFFFBF00000000000000BF0000
      000000FFFFBF00000000000000BF00000000000000BFFFFFFF00000000BFFFFF
      FF0000FFFF000000000000FFFFBFFFFFFF00000000BFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF00000000BF00000000000000BF00000000000000BF0000
      0000000000BF0000000000FFFF000000000000FFFFBF00000000000000BF0000
      0000000000BF000000000000008080808000000000BF00000000000000BFFFFF
      0000FFFF00BFFFFF0000FFFF00BFFFFF0000FFFF000000800000008000000080
      00000080000000000000000000BF000000000000000000FFFF000000000000FF
      FF0000000000000000000000000000FFFF0000000000000000000000000000FF
      FF000000000000000000000000BF000000000000000000FFFF00000000000000
      00000000000000FFFF00FFFFFF00000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000000000000000BF000000000000000000FFFF00000000000000
      00000000000000FFFF0000000000000000000000000000FFFF00000000000000
      00000000000000FFFF000000008080808000000000BF000000000000000000FF
      FF0000FFFFBFFFFF0000FFFF00BFFFFF0000FFFF00BFFFFF0000FFFF00000080
      00000080000000000000000000BF00000000000000BF0000000000FFFFBF0000
      000000FFFFBF0000000000FFFFBF0000000000FFFFBF0000000000FFFFBF0000
      0000000000BF00000000000000BF00000000000000BFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFF
      FF00000000BF00000000000000BF00000000000000BF0000000000FFFFBF0000
      000000FFFFBF0000000000FFFFBF0000000000FFFFBF0000000000FFFFBF0000
      000000FFFFBF000000000000008080808000000000BF000000000000000000FF
      FF0000FFFF0000FFFF00FFFF00BFFFFF0000FFFF00BFFFFF0000FFFF00BFFFFF
      0000FFFF000000000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000BF00000000000000BF000000000000000000FF
      FF0000FFFF0000FFFF00FFFF00BFFFFF0000FFFF00BFFFFF0000FFFF00BFFFFF
      0000FFFF000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BFFFFF
      FF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFF
      FF00FFFFFF0000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000BF00000000000000BF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000BF00000000000000BF00000000000000BFFFFF
      FF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFF
      FF00FFFFFF0000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BFFFFF
      FF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFF
      FF00FFFFFF0000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BFFF000000FF0000BFFF000000FF0000BFFF000000FF0000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FFBF0000
      00000000000000000000000000BF00000000000000BF00000000000000BFFFFF
      FF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFF
      FF00FFFFFF0000000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BFFFFF
      FF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFF
      FF00FFFFFF0000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BFFF000000FF0000BFFF000000FF0000BFFF000000FF0000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FFBF0000
      00000000000000000000000000BF00000000000000BF00000000000000BFFFFF
      FF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFF
      FF00FFFFFF0000000000000000BF000000000000000000000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BFFFFF
      FF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFF
      FF00FFFFFF0000000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF000000000000000000000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BFFF000000FF0000BFFF000000FF0000BFFF000000FF0000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FFBF0000
      00000000000000000000000000BF00000000000000BF00000000000000BFFFFF
      FF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFF
      FF00FFFFFF0000000000000000BF000000000000000000000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BFFFFF
      FF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BFFF000000FF0000BFFF000000FF0000BFFF000000FF0000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FFBF0000
      00000000000000000000000000BF00000000000000BF00000000000000BFFFFF
      FF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFF0000000000FFFFFFBFFFFF
      FF00C0C0C00000000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      00000000000000000000000000BF00000000000000BF00000000000000BFFFFF
      FF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFF0000000000FFFFFF80C0C0
      C000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000BF00000000000000BF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000BF00000000000000BF00000000000000BFFFFF
      FF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFF0000000000C0C0C0000000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000BF00000000000000BF00000000000000BF0000000000000080C0C0
      C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0
      C000C0C0C00000000000000000BF00000000000000BFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFF
      FF00000000BF00000000000000BF00000000000000BFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFF
      FF00000000BF00000000000000BF0000000000000080C0C0C000C0C0C080C0C0
      C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0
      C000000000BF00000000000000BF00000000000000BF0000000000000080C0C0
      C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0
      C000C0C0C00000000000000000BF000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000000000000000BF000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000000000000000BF0000000000000080C0C0C000C0C0C080C0C0
      C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0
      C000C0C0C00000000000000000BF00000000000000BF0000000000000080C0C0
      C000C0C0C000000000000000000000000000000000000000000000000080C0C0
      C000C0C0C00000000000000000BF00000000000000BFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF00000000BF00000000000000BFFFFFFF0000FFFF000000
      00000000000000000000000000000000000000FFFFBFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF00000000BF0000000000000080C0C0C000C0C0C080C0C0
      C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0
      C000C0C0C080C0C0C000000000BF00000000000000BF0000000000000080C0C0
      C000C0C0C000000000000000000000000000000000000000000000000080C0C0
      C000C0C0C00000000000000000BF000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF000000000000000080C0C0C000C0C0C080C0C0
      C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0
      C000C0C0C080C0C0C000C0C0C00000000000000000BF0000000000000080C0C0
      C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0
      C000C0C0C00000000000000000BF00000000000000BFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF00000000BF00000000000000BFFFFFFF0000FFFF000000
      00000000000000000000000000000000000000FFFFBFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF00000000BF0000000000000080C0C0C000C0C0C080C0C0
      C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0
      C000C0C0C080C0C0C000000000BF00000000000000BF0000000000000080C0C0
      C000C0C0C000000000000000000000000000000000000000000000000080C0C0
      C000C0C0C00000000000000000BF000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000000000000000BF000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000000000000000BF0000000000000080C0C0C000C0C0C080C0C0
      C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0
      C000C0C0C00000000000000000BF00000000000000BF0000000000000080C0C0
      C000C0C0C000000000000000000000000000000000000000000000000080C0C0
      C000C0C0C00000000000000000BF00000000000000BFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFF
      FF00000000BF00000000000000BF00000000000000BFFFFFFF0000FFFFBFFFFF
      FF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFFFF0000FFFFBFFFFF
      FF00000000BF00000000000000BF0000000000000080C0C0C000C0C0C080C0C0
      C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0
      C000000000BF00000000000000BF00000000000000BF0000000000000080C0C0
      C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0
      C000C0C0C00000000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000BF00000000000000BF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000BF00000000000000BF00000000000000BF0000000000000080C0C0
      C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0C000C0C0C080C0C0
      C000C0C0C00000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000000000BF00000000000000BF0000
      0000000000BF00000000000000BF00000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      001F000000000000000F00000000000000070000000000000003000000000000
      00010000000000000000000000000000001F000000000000001F000000000000
      001F0000000000008FF1000000000000FFF9000000000000FF75000000000000
      FF8F000000000000FFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF8000C003000F000F0000C003555700075554C003222B
      00030A88C003455500015454C0030A8A00000280C003445500015454C003222B
      00030808C003555700075554C003000F000F0001C003FFFFFFFFFFFFC003FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC003FFFF
      FFFFFFFFC003FFFFC003C003C003FFFFDFFBDFFBC003FFFFD81BD81BC003FBFF
      DFFBDFFBC003DFFFD81BD81BC003BBFFDFFBDFFBC0037B11D81BD81BC003BBFF
      DFFBDFFBC003DBFFD81BD81BC003FBFFDFFBDFFBC007FFFFC003C003C00FFFFF
      FFFFFFFFC01FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFC003000F000F000FC003000700070007C003
      000300030003C003000100010001C003000000000000C003000100010001C003
      000300030003C003000700070007C003000F000F000FC003FFFFFFFFFFFFC003
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ImageList1: TImageList
    Height = 13
    Width = 13
    Left = 648
    Top = 152
    Bitmap = {
      494C01010200140004000D000D00FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000340000000D0000000100200000000000900A
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000C0C0C000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C000C0C0C00000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000C0C0C000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000C0C0C000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000424D3E000000000000003E00000028000000340000000D00000001000100
      00000000680000000000000000000000000000000000000000000000FFFFFF00
      FFFFFFC000000000FDFFEFC000000000FCFFC7C000000000FC7F83C000000000
      C03F01C000000000C01E00C000000000C00C004000000000C01F83C000000000
      C03F83C000000000FC7F83C000000000FCFF83C000000000FDFFFFC000000000
      FFFFFFC00000000000000000000000000000000000000000000000000000}
  end
end
