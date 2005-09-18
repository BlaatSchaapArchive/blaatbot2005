object Form1: TForm1
  Left = 255
  Top = 250
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'dCG IRC BOT'
  ClientHeight = 250
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
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
  object Label9: TLabel
    Left = 25
    Top = 128
    Width = 69
    Height = 20
    Alignment = taRightJustify
    Caption = 'Password'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object status: TLabel
    Left = 8
    Top = 152
    Width = 146
    Height = 20
    Caption = 'Click [Go] to connect'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Go: TButton
    Left = 104
    Top = 184
    Width = 121
    Height = 25
    Caption = 'Go'
    TabOrder = 4
    OnClick = GoClick
  end
  object server: TEdit
    Left = 104
    Top = 8
    Width = 121
    Height = 21
    CharCase = ecLowerCase
    TabOrder = 0
    OnChange = serverChange
  end
  object channel: TEdit
    Left = 104
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 2
    OnChange = channelChange
  end
  object port: TEdit
    Left = 104
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 1
    OnChange = portChange
  end
  object Nick: TEdit
    Left = 104
    Top = 80
    Width = 121
    Height = 21
    TabOrder = 3
    OnChange = NickChange
  end
  object Stop: TButton
    Left = 104
    Top = 216
    Width = 121
    Height = 25
    Caption = 'Stop'
    Enabled = False
    TabOrder = 5
    OnClick = StopClick
  end
  object Panel1: TPanel
    Left = 40
    Top = 184
    Width = 57
    Height = 57
    TabOrder = 6
  end
  object ChanPass: TEdit
    Left = 104
    Top = 128
    Width = 121
    Height = 21
    TabOrder = 7
    OnChange = ChanPassChange
  end
  object ChanServID: TCheckBox
    Left = 8
    Top = 104
    Width = 217
    Height = 17
    Caption = 'Enable Chanserv Identify'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnClick = ChanServIDClick
  end
  object TcpClient: TTcpClient
    Left = 8
    Top = 8
  end
  object ping: TTimer
    Enabled = False
    Interval = 15000
    OnTimer = pingTimer
    Left = 72
    Top = 8
  end
  object Updater: TTimer
    Interval = 1
    OnTimer = status_uodater
    Left = 40
    Top = 8
  end
  object reconnect: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = reconnectTimer
    Left = 8
    Top = 40
  end
  object reconnect2: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = reconnect2Timer
    Left = 40
    Top = 40
  end
  object wait1: TTimer
    Enabled = False
    OnTimer = wait1Timer
    Left = 72
    Top = 40
  end
  object wait2: TTimer
    Enabled = False
    OnTimer = wait2Timer
    Left = 8
    Top = 72
  end
  object TimeoutTimer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TimeoutTimerTimer
    Left = 40
    Top = 72
  end
  object ShoutCastInfo: TTcpClient
    Left = 72
    Top = 72
  end
end
