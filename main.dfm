object Form1: TForm1
  Left = 255
  Top = 250
  Width = 408
  Height = 195
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
    Width = 3
    Height = 13
    Caption = ' '
  end
  object Label2: TLabel
    Left = 256
    Top = 24
    Width = 3
    Height = 13
    Caption = ' '
  end
  object Label3: TLabel
    Left = 256
    Top = 40
    Width = 3
    Height = 13
    Caption = ' '
  end
  object Label4: TLabel
    Left = 49
    Top = 8
    Width = 46
    Height = 20
    Alignment = taRightJustify
    Caption = 'Server'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 62
    Top = 32
    Width = 29
    Height = 20
    Alignment = taRightJustify
    Caption = 'Port'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 36
    Top = 56
    Width = 59
    Height = 20
    Alignment = taRightJustify
    Caption = 'Channel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 64
    Top = 80
    Width = 30
    Height = 20
    Alignment = taRightJustify
    Caption = 'Nick'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 248
    Top = 136
    Width = 32
    Height = 13
    Caption = 'Label8'
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
    Text = 'irc.freenode.net'
  end
  object channel: TEdit
    Left = 104
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '#test'
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
    Left = 8
    Top = 72
    Width = 25
    Height = 25
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 4
    Visible = False
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
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 25
    Height = 25
    TabOrder = 7
  end
  object TcpClient: TTcpClient
    Left = 8
    Top = 104
  end
  object ping: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = pingTimer
    Left = 8
    Top = 136
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 360
    Top = 128
  end
end
