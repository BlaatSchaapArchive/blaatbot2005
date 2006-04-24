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
unit network_stuff;

interface

uses system_code;


procedure irc_setserver   (data:string);
procedure irc_setport     (data:string);
procedure irc_sendln      (data:string);
procedure irc_disconnect  ();

//procedure sc_setserver    (data:string);
//procedure sc_setport      (data:string);
//procedure sc_sendln       (data:string);
//procedure sc_disconnect   ();

procedure http_setserver  (data:string);
procedure http_setport    (data:string);
procedure http_sendln     (data:string);
procedure http_disconnect ();

function irc_connect()    : boolean;
function irc_connected()  : boolean;
function irc_receiveln()  : string;

//function sc_connect()     : boolean;
//function sc_connected()   : boolean;
//function sc_receiveln()   : string;

function http_connect()   : boolean;
function http_connected() : boolean;
function http_receiveln() : string;








implementation

procedure irc_setserver   (data:string);
begin
form2.TcpClient.RemoteHost:=data;
end;

procedure irc_setport     (data:string);
begin
form2.TcpClient.RemotePort:=data;
end;

procedure irc_sendln      (data:string);
begin
form2.TcpClient.Sendln(data);
end;

{
procedure sc_setserver   (data:string);
begin
form2.ShoutCastInfo.RemoteHost:=data;
end;

procedure sc_setport     (data:string);
begin
form2.ShoutCastInfo.RemotePort:=data;
end;

procedure sc_sendln      (data:string);
begin
form2.ShoutCastInfo.Sendln(data);
end;

}
procedure http_setserver   (data:string);
begin
form2.TcpClient_Update.RemoteHost:=data;
end;

procedure http_setport     (data:string);
begin
form2.TcpClient_Update.RemotePort:=data;
end;

procedure http_sendln      (data:string);
begin
form2.TcpClient_Update.Sendln(data);
end;


function irc_connect()    : boolean;
begin
result := form2.TcpClient.Connect;
end;

function irc_connected()  : boolean;
begin
result := form2.TcpClient.Connected;
end;

function irc_receiveln()  : string;
var receiveddata : string;
temp : char;
begin
//result := form2.TcpClient.Receiveln();

repeat
Form2.TcpClient.ReceiveBuf(temp,1);
if not ( (temp = #$D ) or (temp = #$A) or (temp = #$D))then receiveddata := receiveddata + temp;
until (temp = #$0 )or (temp = #$A)or (temp = #$D) ;

   result := receiveddata;

end;
{
function sc_connect()    : boolean;
begin
result := form2.ShoutCastInfo.Connect;
end;

function sc_connected()  : boolean;
begin
result := form2.ShoutCastInfo.Connected;
end;

function sc_receiveln()  : string;
begin
result := form2.ShoutCastInfo.Receiveln();
end;
}

function http_connect()     : boolean;
begin
result := form2.TcpClient_Update.Connect;
end;

function http_connected()  : boolean;
begin
result := form2.TcpClient_Update.Connected;
end;

function http_receiveln()  : string;
begin
result := form2.TcpClient_Update.Receiveln();
end;

procedure irc_disconnect  ();
begin
form2.TcpClient.Disconnect
end;
{
procedure sc_disconnect  ();
begin
form2.ShoutCastInfo.Disconnect
end;
}
procedure http_disconnect  ();
begin
form2.TcpClient_Update.Disconnect
end;

end.
