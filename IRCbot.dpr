program IRCbot;

uses
  Forms,
  main in 'main.pas' {Form1},
  IRCbot_CompileTime in 'IRCbot_CompileTime.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'BlaatSchaap IRC Bot';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
