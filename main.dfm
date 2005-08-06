object Form1: TForm1
  Left = 192
  Top = 109
  Width = 696
  Height = 480
  Caption = 'dCG IRC BOT'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 256
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 256
    Top = 24
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object Label3: TLabel
    Left = 256
    Top = 40
    Width = 32
    Height = 13
    Caption = 'Label3'
  end
  object comparing: TLabel
    Left = 544
    Top = 32
    Width = 49
    Height = 13
    Caption = 'comparing'
  end
  object lenght1: TLabel
    Left = 496
    Top = 32
    Width = 35
    Height = 13
    Caption = 'lenght1'
  end
  object lenght2: TLabel
    Left = 496
    Top = 56
    Width = 35
    Height = 13
    Caption = 'lenght2'
  end
  object Button1: TButton
    Left = 104
    Top = 104
    Width = 121
    Height = 25
    Caption = 'Go'
    TabOrder = 5
    OnClick = Button1Click
  end
  object server: TEdit
    Left = 104
    Top = 8
    Width = 121
    Height = 21
    CharCase = ecLowerCase
    TabOrder = 0
    Text = 'alphaserv.mine.nu'
  end
  object channel: TEdit
    Left = 104
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '#skyos_offtopic'
  end
  object port: TEdit
    Left = 104
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '6667'
  end
  object Memo1: TMemo
    Left = 16
    Top = 168
    Width = 649
    Height = 265
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object Nick: TEdit
    Left = 104
    Top = 80
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'dGCbot'
  end
  object Button2: TButton
    Left = 104
    Top = 136
    Width = 121
    Height = 25
    Caption = 'Stop'
    Enabled = False
    TabOrder = 6
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 360
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 7
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 360
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 8
    Text = 'Edit2'
  end
  object RadioButton1: TRadioButton
    Left = 360
    Top = 104
    Width = 113
    Height = 17
    Caption = 'RadioButton1'
    Enabled = False
    TabOrder = 9
  end
  object Button3: TButton
    Left = 360
    Top = 72
    Width = 121
    Height = 25
    Caption = 'Button3'
    TabOrder = 10
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 336
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 11
    OnClick = Button4Click
  end
  object TcpClient: TTcpClient
    Left = 8
    Top = 8
  end
  object ping: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = pingTimer
    Left = 8
    Top = 40
  end
end
