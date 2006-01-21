object Form2: TForm2
  Left = 746
  Top = 208
  Width = 179
  Height = 181
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object wait2: TTimer
    Enabled = False
    OnTimer = wait2Timer
    Left = 8
    Top = 40
  end
  object wait1: TTimer
    Enabled = False
    OnTimer = wait1Timer
    Left = 40
    Top = 8
  end
  object Updater: TTimer
    Left = 88
    Top = 8
  end
  object Timer_doupgrade: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer_doupgradeTimer
    Left = 88
    Top = 104
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
  object ShoutCastInfo: TTcpClient
    Left = 120
    Top = 40
  end
  object reconnect2: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = reconnect2Timer
    Left = 40
    Top = 40
  end
  object reconnect: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = reconnectTimer
    Left = 8
    Top = 8
  end
  object ping: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = pingTimer
    Left = 88
    Top = 72
  end
end
