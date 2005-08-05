object Form1: TForm1
  Left = 192
  Top = 137
  Width = 696
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 104
    Top = 120
    Width = 121
    Height = 25
    Caption = 'Go'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 104
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'alphaserv.mine.nu'
  end
  object Edit2: TEdit
    Left = 104
    Top = 96
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '#degekkenclub'
  end
  object Edit3: TEdit
    Left = 104
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '6667'
  end
  object Memo1: TMemo
    Left = 16
    Top = 168
    Width = 649
    Height = 265
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object TcpClient: TTcpClient
    Left = 8
    Top = 8
  end
  object ping: TTimer
    Enabled = False
    Interval = 10000
    Left = 8
    Top = 40
  end
  object test: TTimer
    Enabled = False
    Interval = 1
    OnTimer = testTimer
    Left = 8
    Top = 72
  end
end
