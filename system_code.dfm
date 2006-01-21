object Form2: TForm2
  Left = 679
  Top = 130
  BorderStyle = bsNone
  Caption = 'System Window'
  ClientHeight = 148
  ClientWidth = 168
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Updater: TTimer
    Left = 88
    Top = 8
  end
  object TimeoutTimer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TimeoutTimerTimer
    Left = 88
    Top = 40
  end
  object TcpClient_Update: TTcpClient
    Left = 120
    Top = 72
  end
  object TcpClient: TTcpClient
    Left = 120
    Top = 8
  end
  object ping: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = pingTimer
    Left = 88
    Top = 72
  end
  object timer_doupgrade: TTimer
    Enabled = False
    OnTimer = timer_doupgradeTimer
    Left = 88
    Top = 104
  end
end
