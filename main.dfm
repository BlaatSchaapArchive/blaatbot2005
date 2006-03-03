object Form1: TForm1
  Left = 265
  Top = 150
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'BlaatSchaap IRC BOT'
  ClientHeight = 300
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 16
    Top = 16
    Width = 225
    Height = 273
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
    object Go: TButton
      Left = 80
      Top = 224
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
      Top = 224
      Width = 65
      Height = 41
      Caption = 'Stop'
      Enabled = False
      TabOrder = 8
      OnClick = StopClick
    end
    object Panel1: TPanel
      Left = 16
      Top = 224
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
    object autoconnect: TCheckBox
      Left = 8
      Top = 152
      Width = 209
      Height = 17
      Caption = 'Enable Auto-Connect'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      OnClick = ChanServIDClick
    end
    object longwait: TCheckBox
      Left = 8
      Top = 176
      Width = 193
      Height = 17
      Caption = 'Long timeout for login'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
    end
  end
  object Panel3: TPanel
    Left = 256
    Top = 16
    Width = 225
    Height = 273
    TabOrder = 1
    object status: TLabel
      Left = 8
      Top = 240
      Width = 4
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 197
      Height = 20
      Caption = 'Enter commands to the bot:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object EditCommands: TEdit
      Left = 8
      Top = 32
      Width = 209
      Height = 21
      TabOrder = 0
      OnKeyPress = EditCommandsKeyPress
    end
    object MemoOutput: TMemo
      Left = 8
      Top = 64
      Width = 209
      Height = 169
      ReadOnly = True
      TabOrder = 1
    end
  end
  object Time_Timer: TTimer
    OnTimer = Time_TimerTimer
    Left = 272
    Top = 88
  end
  object AutoConnect_Timer: TTimer
    Enabled = False
    OnTimer = AutoConnect_TimerTimer
    Left = 304
    Top = 88
  end
  object timer_doupgrade: TTimer
    Enabled = False
    Interval = 1
    OnTimer = timer_doupgradeTimer
    Left = 272
    Top = 120
  end
end
