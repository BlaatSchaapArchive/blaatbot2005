object Form1: TForm1
  Left = 254
  Top = 249
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
  object Button4: TButton
    Left = 336
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 7
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
