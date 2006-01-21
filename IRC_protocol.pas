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
unit irc_protocol;


interface


uses network_stuff,strings ;

procedure Say(msg: string);
procedure SayPriv(msg,user: string);

procedure Mode (who: string; mode : char; enable : boolean);
procedure Kick(who: string);
procedure Announce(msg: string);
procedure AnnouncePriv(msg,user: string);
procedure Action(msg: string);







implementation


procedure SayPriv(msg,user: string);
begin
irc_sendln('PRIVMSG ' + user + ' :'+ msg);
end;

procedure Say(msg: string);
begin
irc_sendln('PRIVMSG ' + irc_channel + ' :'+ msg);
end;

procedure Announce(msg: string);
begin
 irc_sendln('NOTICE ' + irc_channel + ' :'+ msg);
end;

procedure AnnouncePriv(msg,user: string);
begin
 irc_sendln('NOTICE ' + user + ' :'+ msg);
end;



procedure Action(msg: string);
begin
irc_sendln('PRIVMSG ' + irc_channel + ' :'+ CHR($01) + 'ACTION '+ msg+ CHR($01));
end;


procedure Kick(who: string);
begin
irc_sendln('KICK ' + irc_channel + ' ' + who);
end;

procedure Mode (who: string; mode : char; enable : boolean);
begin
if enable = true then
irc_sendln('MODE '+ irc_channel +' +'+mode+' '+who);
if enable = false then
irc_sendln('MODE '+ irc_channel +' -'+mode+' '+who);
end;




end.
