// BlaatSchaap IRC BOT
// by André van Schoubroeck
// http://www.sf.net/projects/dgcshell
//
// LICENCE:
//
// This software is provided 'as-is', without any express or implied warranty.
// In no event will the authors be held liable for any damages arising from the
// use of this software.
//
// Permission is granted to anyone to use this software for any purpose,
// including commercial applications, and to alter it and redistribute it
// freely, subject to the following restrictions:
//
//    1. The origin of this software must not be misrepresented;
//       you must not claim that you wrote the original software.
//       If you use this software in a product, an acknowledgment
//       in the product documentation would be appreciated but is
//       not required.
//
//    2. Altered source versions must be plainly marked as such,
//       and must not be misrepresented as being the original software.
//
//    3. This notice may not be removed or altered from any source distribution.
//
//
//
program IRCbot;

uses
  Forms,
  main in 'main.pas' {Form1},
  IRCbot_CompileTime in 'IRCbot_CompileTime.pas',
  OSinfo in 'OSinfo.pas',
  general_codes in 'general_codes.pas',
  irc_protocol in 'irc_protocol.pas',
  bot_commands in 'bot_commands.pas',
  system_code in 'system_code.pas' {Form2},
  strings in 'strings.pas',
  irc_protocol2 in 'irc_protocol2.pas',
  irc_CompileTime in 'irc_CompileTime.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'BlaatSchaap IRC Bot';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
