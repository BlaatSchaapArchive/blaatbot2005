object Form1: TForm1
  Left = 255
  Top = 250
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'BlaatSchaap IRC BOT'
  ClientHeight = 250
  ClientWidth = 500
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
  object Panel2: TPanel
    Left = 16
    Top = 16
    Width = 225
    Height = 225
    TabOrder = 0
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
      Left = 80
      Top = 176
      Width = 65
      Height = 41
      Caption = 'Go'
      TabOrder = 6
      OnClick = GoClick
    end
    object server: TEdit
      Left = 104
      Top = 8
      Width = 113
      Height = 21
      CharCase = ecLowerCase
      TabOrder = 0
      OnChange = serverChange
    end
    object channel: TEdit
      Left = 104
      Top = 56
      Width = 113
      Height = 21
      TabOrder = 2
      OnChange = channelChange
    end
    object port: TEdit
      Left = 104
      Top = 32
      Width = 113
      Height = 21
      TabOrder = 1
      OnChange = portChange
    end
    object Nick: TEdit
      Left = 104
      Top = 80
      Width = 113
      Height = 21
      TabOrder = 3
      OnChange = NickChange
    end
    object Stop: TButton
      Left = 152
      Top = 176
      Width = 65
      Height = 41
      Caption = 'Stop'
      Enabled = False
      TabOrder = 8
      OnClick = StopClick
    end
    object Panel1: TPanel
      Left = 16
      Top = 176
      Width = 41
      Height = 41
      TabOrder = 7
    end
    object ChanPass: TEdit
      Left = 104
      Top = 128
      Width = 113
      Height = 21
      PasswordChar = '*'
      TabOrder = 5
      OnChange = ChanPassChange
    end
    object ChanServID: TCheckBox
      Left = 8
      Top = 104
      Width = 209
      Height = 17
      Caption = 'Enable Chanserv Identify'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = ChanServIDClick
    end
    object RunTempBat: TButton
      Left = 0
      Top = 0
      Width = 41
      Height = 25
      Caption = 'RunTempBat'
      TabOrder = 9
      OnClick = RunTempBatClick
    end
  end
  object Panel3: TPanel
    Left = 256
    Top = 16
    Width = 225
    Height = 225
    TabOrder = 1
    object EditCommands: TEdit
      Left = 8
      Top = 16
      Width = 209
      Height = 21
      TabOrder = 0
      OnKeyPress = EditCommandsKeyPress
    end
    object MemoOutput: TMemo
      Left = 8
      Top = 48
      Width = 209
      Height = 153
      ReadOnly = True
      TabOrder = 1
    end
  end
  object TcpClient: TTcpClient
    Left = 272
    Top = 72
  end
  object ping: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = pingTimer
    Left = 336
    Top = 72
  end
  object Updater: TTimer
    Interval = 1
    OnTimer = status_uodater
    Left = 304
    Top = 72
  end
  object reconnect: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = reconnectTimer
    Left = 272
    Top = 104
  end
  object reconnect2: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = reconnect2Timer
    Left = 304
    Top = 104
  end
  object wait1: TTimer
    Enabled = False
    OnTimer = wait1Timer
    Left = 336
    Top = 104
  end
  object wait2: TTimer
    Enabled = False
    OnTimer = wait2Timer
    Left = 272
    Top = 136
  end
  object TimeoutTimer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TimeoutTimerTimer
    Left = 304
    Top = 136
  end
  object ShoutCastInfo: TTcpClient
    Left = 336
    Top = 136
  end
end
