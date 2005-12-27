program IRCbot;

uses
  Forms,
  main in 'main.pas' {Form1},
  IRCbot_CompileTime in 'IRCbot_CompileTime.pas',
  IRC_protocol in 'IRC_protocol.pas',
  General_code in 'General_code.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'BlaatSchaap IRC Bot';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
