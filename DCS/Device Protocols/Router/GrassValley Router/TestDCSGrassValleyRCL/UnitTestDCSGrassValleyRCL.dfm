object Form12: TForm12
  Left = 0
  Top = 0
  Caption = 'Form12'
  ClientHeight = 601
  ClientWidth = 843
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 45
    Top = 60
    Width = 34
    Height = 13
    Caption = 'DCS ID'
  end
  object Label2: TLabel
    Left = 44
    Top = 87
    Width = 63
    Height = 13
    Caption = 'Source Name'
  end
  object Label8: TLabel
    Left = 45
    Top = 33
    Width = 33
    Height = 13
    Caption = 'DCS IP'
  end
  object Label3: TLabel
    Left = 24
    Top = 244
    Width = 33
    Height = 13
    Caption = 'Source'
  end
  object Label4: TLabel
    Left = 24
    Top = 271
    Width = 54
    Height = 13
    Caption = 'Destination'
  end
  object Label5: TLabel
    Left = 24
    Top = 298
    Width = 25
    Height = 13
    Caption = 'Level'
  end
  object mmDesc: TMemo
    Left = 338
    Top = 8
    Width = 497
    Height = 553
    ImeName = 'Microsoft IME 2010'
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object edtDCSID: TEdit
    Left = 117
    Top = 57
    Width = 121
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 1
    Text = '0'
  end
  object edtSourceName: TEdit
    Left = 117
    Top = 84
    Width = 121
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 2
    Text = 'GRASSVALLEY_ROUTER1'
  end
  object btnDeviceOpen: TButton
    Left = 117
    Top = 123
    Width = 121
    Height = 25
    Caption = 'Device Open'
    TabOrder = 3
    OnClick = btnDeviceOpenClick
  end
  object btnDeviceClose: TButton
    Left = 117
    Top = 154
    Width = 121
    Height = 25
    Caption = 'Device Close'
    TabOrder = 4
    OnClick = btnDeviceCloseClick
  end
  object edtDCSIP: TEdit
    Left = 117
    Top = 30
    Width = 121
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 5
    Text = '127.0.0.1'
  end
  object edtSrcIndex: TEdit
    Left = 96
    Top = 241
    Width = 121
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 6
    Text = '20'
  end
  object edtDstIndex: TEdit
    Left = 96
    Top = 268
    Width = 121
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 7
    Text = '403'
  end
  object edtLvlIndex: TEdit
    Left = 96
    Top = 295
    Width = 121
    Height = 21
    ImeName = 'Microsoft IME 2010'
    TabOrder = 8
    Text = '0'
  end
  object btnSetRoute: TButton
    Left = 96
    Top = 331
    Width = 121
    Height = 25
    Caption = 'Set Route'
    TabOrder = 9
    OnClick = btnSetRouteClick
  end
  object btnGetRoute: TButton
    Left = 96
    Top = 371
    Width = 121
    Height = 25
    Caption = 'Get Route'
    TabOrder = 10
    OnClick = btnGetRouteClick
  end
end
