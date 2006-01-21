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


unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Sockets, ShellAPI, IRCbot_CompileTime, OSinfo,
  general_codes,network_stuff,irc_protocol, irc_protocol2, strings, bot_commands;

//    function ReadParams(data : string; number : integer; space : boolean):string;
//    function contains (data,what: string) : boolean;
//    function  IsAdmin  (name: string) : boolean;

//    procedure GetStats();
//    procedure KickBadWords(line,user: string);
    procedure RestoreSettings();
    procedure SaveSettings();
//    procedure ReQuote();
//    procedure Dice();
//    procedure ListAdmin();
//    procedure AddAdmin(name:string);
//    procedure RemoveAdmin(name:string);
//    procedure ListBadWords();
//    procedure AddBadWord(badword:string);
//    procedure RemoveBadWord(badword:string);
//    procedure MusicPlaying();
    procedure AddStation(name,server,port:string);
    procedure RemoveStation(name:string);
    procedure ListStations();
//    procedure ReadData(data: string);
//    procedure Say(msg: string);
//    procedure SayPriv(msg,user: string);
//    procedure Announce(msg: string);
//    procedure AnnouncePriv(msg,user: string);
//    procedure Action(msg: string);
//    procedure Kick(who: string);
//    procedure Mode (who: string; mode : char; enable : boolean);
//    procedure DoSomething(user, line, command, data: string; inchannel : boolean);
//    procedure DoConvert(data : string);

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Go: TButton;
    server: TEdit;
    channel: TEdit;
    port: TEdit;
    Nick: TEdit;
    Stop: TButton;
    Panel1: TPanel;
    ChanPass: TEdit;
    ChanServID: TCheckBox;
    Panel3: TPanel;
    EditCommands: TEdit;
    MemoOutput: TMemo;
    status: TLabel;
    autoconnect: TCheckBox;
    longwait: TCheckBox;
    Label1: TLabel;
    Time_Timer: TTimer;
    AutoConnect_Timer: TTimer;
    timer_doupgrade: TTimer;

    procedure GoClick(Sender: TObject);
    procedure pingTimer(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure status_uodater(Sender: TObject);
    procedure joinerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure serverChange(Sender: TObject);
    procedure portChange(Sender: TObject);
    procedure channelChange(Sender: TObject);
    procedure NickChange(Sender: TObject);
    procedure ChanPassChange(Sender: TObject);
    procedure ChanServIDClick(Sender: TObject);
    procedure EditCommandsKeyPress(Sender: TObject; var Key: Char);
    procedure RunTempBatClick(Sender: TObject);
    procedure Time_TimerTimer(Sender: TObject);
    procedure AutoConnect_TimerTimer(Sender: TObject);
    procedure timer_doupgradeTimer(Sender: TObject);


  end;
  type
  TReceive = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;





var
  Form1: TForm1;

implementation

uses system_code;

{$R *.dfm}



    procedure AddStation(name,server,port:string);
    begin end; // not implemented

    procedure RemoveStation(name:string);
    begin end; // not implemented

    procedure ListStations();
// copy paste musicplaying ...
    var
    musicfile : textfile;
    temp      : char;
    server    : string;
    port      : string;

    station   : string;

    begin
    assign(musicfile, 'music');
    reset (musicfile);
    //say ( 'DEBUG : MUSIC : Reading data file ');
    while not eof(musicfile) do

      begin
      station :='';
      repeat
      read (musicfile, temp);
      if not (temp = ',') then station := station + temp
      until temp = ',';
      //say ( 'DEBUG : STATION NAME IS '+ station );

      server :='';
      repeat
      read (musicfile, temp);
      if not (temp = ',') then server := server + temp
      until temp = ',';
      //say ( 'DEBUG : SERVER IS '+ server );
      port :='';
      repeat
      read (musicfile, temp);
      if not (temp = ',') then port := port + temp
      until temp = ',';
      //say ( 'DEBUG : PORT IS '+ port );
      // infochecker

      say ( station + ' ' + server + ' ' + port );
      form1.MemoOutput.lines.Add( station + ' ' + server + ' ' + port )
     end;


    end; // not implemented

procedure SaveSettings();
  var
  settingfile : textfile;
    begin
    irc_server   := form1.server.text ;
    irc_port     := form1.port.text   ;
    irc_channel  := form1.channel.text;
    irc_nick     := form1.nick.text   ;
    irc_nickserv := form1.ChanservID.checked;
    irc_nickpass := form1.ChanPass.text;

    assign(settingfile, 'settings');
    rewrite (settingfile);
    write (settingfile, irc_server);
    write (settingfile, ',');
    write (settingfile, irc_port);
    write (settingfile, ',');
    write (settingfile, irc_channel);
    write (settingfile, ',');
    write (settingfile, irc_nick);
    write (settingfile, ',');
    write (settingfile, irc_nickserv);
    write (settingfile, ',');
    write (settingfile, irc_nickpass);
    write (settingfile, ',');
    write (settingfile, form1.AutoConnect.checked);
    write (settingfile, ',');
    closefile(settingfile);
    end;


procedure RestoreSettings();
  var
  settingfile : textfile;
  temp         : char;
  data         : string;
  tempfile : textfile;
//testing the quote function
//  tempfile    : textfile;
    begin
    // put the file thing in here, doesn;t want to
    // work in a form1.something
    // first parameter not a file then or something
    assign(logfile, 'log'); // for debugging
    rewrite (logfile);     //

    assign(quotefile, 'quotefile');

    assign(settingfile, 'settings');
    reset (settingfile);
        data :='';
if (not eof(settingfile)) then begin

        repeat
        read (settingfile, temp);
        if not (temp = ',') then data := data + temp
        until temp = ',';
        form1.server.text := data;
        data :='';
        repeat
        read (settingfile, temp);
        if not (temp = ',') then data := data + temp
        until temp = ',';
        form1.port.text := data ;
        data :='';
        repeat
        read (settingfile, temp);
        if not (temp = ',') then data := data + temp
        until temp = ',';
        form1.channel.text := data;
        data :='';
        repeat
        read (settingfile, temp);
        if not (temp = ',') then data := data + temp
        until temp = ',';
        form1.nick.text := data;
        data :='';

        repeat
        read (settingfile, temp);
        if not (temp = ',') then data := data + temp
        until temp = ',';
        convert := data;
        form1.ChanServID.checked := convert;
        data :='';

        repeat
        read (settingfile, temp);
        if not (temp = ',') then data := data + temp
        until temp = ',';
        form1.ChanPass.text := data;
        data :='';

        repeat
        read (settingfile, temp);
        if not (temp = ',') then data := data + temp
        until temp = ',';
        convert := data;
        form1.AutoConnect.checked := convert;
        data :='';

        closefile(settingfile);

    irc_server   := form1.server.text ;
    irc_port     := form1.port.text   ;
    irc_channel  := form1.channel.text;
    irc_nick     := form1.nick.text   ;
    irc_nickserv := form1.ChanservID.checked;
    irc_nickpass := form1.ChanPass.text;

    // putting code back here from requote

       assign(tempfile, 'temp');
   rewrite (tempfile);
   assign(quotefile, 'quotefile');
   reset (quotefile);

      while not eof(quotefile) do
      begin
      read (quotefile, temp);
      write (tempfile, temp);
      end;

      closefile(quotefile);
      closefile(tempfile);

   //assign(tempfile, 'temp');
   reset (tempfile);
   //assign(quotefile, 'quotefile');
   rewrite (quotefile);

      while not eof(tempfile) do
      begin
      read (tempfile, temp);
      write (quotefile, temp);
      end;

   //closefile(tempfile);
     close (tempfile);
//     flush (quotefile); // flushing the file did not seem to be the problem.





        //        ready := true; //
        //    preventing the change to activate the
        //    savesettings

        // try this
//        assign(quotefile,'quotefile');
//        rewrite (quotefile);
//
end; // check for file //
ReQuote;
ready := true;

    end;




















// end of forbidden words stuff










//end;




//blaat
procedure TForm1.GoClick(Sender: TObject);

begin
irc_live := true;
      writeln (quotefile, ' ');
      writeln (quotefile, 'Logging starts at ' + time_now + ' '+ date_now);
      writeln (quotefile, ' ');

timeout := false;
Form2.TimeoutTimer.Enabled:=true; //wtf?!? acces violation on enabling timer ?
bot_status:='Connecting....';
irc_nickserv:= form1.ChanServID.Checked;
go.Enabled := false;
stop.Enabled := true;
irc_server := server.Text;
irc_port := port.Text;
irc_setserver(irc_server);
irc_setport(irc_port);

if irc_connect() then
begin
bot_status:='Connected...';
status.Repaint;
treceive.Create(false);
irc_sendln('NICK '+ nick.Text);
//tcpclient.Sendln('USER dgcbot dgchost '+ server.Text + ' :dGCbot www.sf.net/projects/dgcshell');
// got kiced in #Skyos
irc_Sendln('USER blaatbot blaathost '+ server.Text + ' :Blaatschaap Bot www.sf.net/projects/dgcshell');
//sniffed
//USER andre_winxp 786at1600 irc.chat4all.org :Andre van Schoubroeck
server.Enabled := false;
port.Enabled := false;
nick.Enabled := false;
channel.Enabled := false;
ChanservID.Enabled:=false;
ChanPass.Enabled := false;
bot_status:='Waiting for server...';
//status.Repaint;
// found the code to detect when the server is ready
// moving login code to readdata



end else
begin
bot_status:='Server did not respond';
status.Repaint;
AutoConnect_Timer.Interval:=10000;
if irc_live then AutoConnect_Timer.Enabled:=true;

end;
end;





// procedure contains(data,what: string);






procedure TReceive.Execute;
begin

repeat

sleep (1); // sleep for 1 ms to keep the cpu usage low
if  form2.TcpClient.WaitForData() then
begin

receivingdata := true;
receiveddata := irc_Receiveln();

//bebug, should start log a file ?
//form1.memo1.Text := form1.memo1.Text  + receiveddata  ;
 readdata(receiveddata);
// and now read the received data
 receiveddata :='';
// and get rid of it

end else receivingdata := false;;

until (irc_Connected = false);
form1.Panel1.Color := clred;
uptime :=0;
//form1.Stop.click;
irc_Disconnect;
form1.AutoConnect_Timer.Interval:=10000;
form1.AutoConnect_Timer.Enabled:=true;

end;





procedure TForm1.pingTimer(Sender: TObject);
var
tempstring : string;
begin
//write (logfile,'PING ');
//write (logfile,pingcount);
//write (logfile, chr(13));
if NOT (pingcount = pongcount) then
// PING TIMEOUT //
begin
status.Caption := 'PING TIMEOUT : Reconnect';
status.Repaint;
//reconnect.Enabled := true;
write (logfile,'PING TIMEOUT: PING ');
write (logfile,pingcount);
write (logfile,'  PONG ');
write (logfile,pongcount);
write (logfile, chr(13));
end;

//if not (pingcount = 2147483647 )then
// this will never overflow ...
// 2147483647 * 15 sec = 1021 years
// i don;t think it will ever run that long :P
pingcount := pingcount + 1;
//else pingcount := 1;
convert := pingcount;
tempstring := convert;
irc_Sendln('PING : '+tempstring)  ;
end;

procedure TForm1.StopClick(Sender: TObject);
begin
AutoConnect_Timer.Enabled:=false;
irc_Sendln('PART '+ irc_channel +' BlaatBot Disconnecting');
irc_live:=false;
//reconnect.enabled := false;
//reconnect2.enabled:=false;
//wait1.enabled := false;
//wait2.enabled := false;
//timeouttimer.enabled:=false;
form2.ping.Enabled := false;

status.Caption:='Disconnected';
status.Repaint;
ChanservID.Enabled:=true;
ChanPass.Enabled := true;
server.Enabled := true;
port.Enabled := true;
nick.Enabled := true;
channel.Enabled := true;
go.Enabled := true;
stop.Enabled := false;
irc_Disconnect;
end;


procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
irc_Disconnect;
closefile(logfile);
closefile(quotefile);
end;



procedure TForm1.Button4Click(Sender: TObject);
begin
dice;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
restoresettings();
end;

procedure TForm1.status_uodater(Sender: TObject);
begin
If irc_Connected then uptime := uptime + 1 ;
if form1.longwait.Checked then begin form2.timeouttimer.Interval:=3000000000; end else form2.timeouttimer.Interval:=10000;
// Update current time and date.


//time_convert  := time;
time_now :=TimeToStr(time);
//time_convert  := date;
date_now := DateToStr(date);

if time_now = '03:33:33' then CheckForUpdate();



if timeout then
  begin
  timeout :=false;
  write (logfile,'Login Timeout' + chr(13) );
  //stop.Click;
  irc_Disconnect;
  status.Caption := 'Connected, but no answer';
  status.Repaint;
{     if  (not wait2.Enabled ) or
         (not reconnect.Enabled ) or
         (not reconnect2.enabled) then wait1.enabled := true
else if  (not wait1.Enabled ) or
         (not reconnect.Enabled ) or
         (not reconnect2.enabled) then wait2.enabled := true
else status.Caption := 'timeout / reconnect bug';status.Repaint;
}
  end;

if irc_Connected = false then panel1.Color := clred else
if receivingdata = true then panel1.Color := clgreen else
if receivingdata = false then panel1.Color := clgray;
if ( irc_Connected = false ) AND (form2.ping.Enabled = true) then  form1.Status.Caption := 'Server dropped connection';form1.status.Repaint;
end;

procedure TForm1.joinerTimer(Sender: TObject);
begin
//tcpclient.Sendln('JOIN '+ channel.Text)  ;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
// set date and time formats
TimeSeparator   := ':';
DateSeparator   := '-';
ShortDateFormat := 'dd/mm/yyyy' ;
LongTimeFormat  := 'hh:nn:ss'   ;
currentversion := DateToStr(CompileTime);
bot_status :='Click [Go] to connect';
bot_version:='BlaatSchaap IRC BOT (Compile Date ' + DateToStr(CompileTime)+' @ '+TimeToStr(CompileTime) +')';
Form1.Caption:=bot_version;
restoresettings();

irc_channel:=channel.Text;
irc_nick := nick.Text;
irc_nickpass := chanpass.text;

if ChanServID.Checked then ChanPass.Enabled := true else ChanPass.Enabled := false;
//pongcount := 1; // begin value
AutoConnect_Timer.Enabled:=AutoConnect.Checked;
end;

procedure TForm1.serverChange(Sender: TObject);
begin
if ready then savesettings();

end;

procedure TForm1.portChange(Sender: TObject);
begin
if ready then savesettings()
end;

procedure TForm1.channelChange(Sender: TObject);
begin
if ready then savesettings()
end;

procedure TForm1.NickChange(Sender: TObject);
begin
if ready then savesettings()
end;

procedure TForm1.ChanPassChange(Sender: TObject);
begin
if ready then savesettings()
end;

procedure TForm1.ChanServIDClick(Sender: TObject);
begin
if ready then savesettings();
if ChanServID.Checked then ChanPass.Enabled := true else ChanPass.Enabled := false;
end;


procedure TForm1.EditCommandsKeyPress(Sender: TObject; var Key: Char);
var
temp: char;
command, data : string;
count : integer;
begin

if Key = chr(13) then

begin
count := 0;
// insert code
//MemoOutput.Lines.Add('test :')   ;
repeat
count := count + 1;
temp := EditCommands.Text[count];
if NOT((temp = ' ') or (temp = '')) then command := command + temp;
until (temp = '' )or (temp = ' ');
if not (temp= '') then repeat
count := count + 1;
temp := EditCommands.Text[count];
if not (temp = '') then data := data + temp
until temp = '';
//MemoOutput.Lines.Add(EditCommands.text);
//MemoOutput.Lines.Add(command);
//MemoOutput.Lines.Add(data);
// command, data

DoSomething('áðµíñ',EditCommands.Text,command,data,false);
//DoSomething('Admin',EditCommands.Text,command,data,true);
//
EditCommands.Clear;
end;
end;

procedure TForm1.RunTempBatClick(Sender: TObject);
begin
ShellExecute   (   handle,'open',  'temp.bat' , nil, nil, SW_HIDE);


//ShellExecute(Handle, 'open', PChar('temp.bat'), nil, nil, SW_SHOWNORMAL);
//SW_SHOWNORMAL    SW_HIDE
end;

procedure TForm1.Time_TimerTimer(Sender: TObject);
begin

 form1.server.text        :=    irc_server    ;
 form1.port.text          :=    irc_port      ;
 form1.channel.text       :=    irc_channel   ;
 form1.nick.text          :=    irc_nick      ;
 form1.ChanservID.checked :=    irc_nickserv  ;
 form1.ChanPass.text      :=    irc_nickpass  ;

TimeSeparator   := ':';
DateSeparator   := '-';
ShortDateFormat := 'dd/mm/yyyy' ;
LongTimeFormat  := 'hh:nn:ss'   ;


status.Caption := bot_status;
uptime := uptime +1;
//time_convert  := time;
time_now :=TimeToStr(time);
//time_convert  := date;
date_now := DateToStr(date);


if irc_connected then
if receivingdata then panel1.Color:=clgreen else panel1.Color:=clgray else
panel1.color:=clred;


if time_now = '03:33:33' then CheckForUpdate();


if ((time_now[4]  = '0') or (time_now[4]  = '3'))and (time_now[5] = '0')
then begin
randomize;
randomnumber := random(30)+1 ;

if randomnumber = 1 then say('"I am weird and I am proud of it"');

if randomnumber = 2 then say('"Good and evil walk hand in hand.. they will never seperate."');

if randomnumber = 3 then say('"You laugh at me because I'+ char(39) +'m different, I laugh at you because you'+ char(39) +'re all the same."');

if randomnumber = 4 then say('"Nothing is truly good, nothing is truly evil."');

if randomnumber = 5 then say('"Think Different"');

if randomnumber = 6 then say('"Being insane is not a disease, it is a way of life."');

if randomnumber = 7 then say('"Everybody wants to be the sun in your life... but I would rather be the moon that shines on you in your darkest times"');

if randomnumber = 8 then say('"Everybody tells me I'+ char(39) +'m smart, and then I laugh about their stupidity."');

if randomnumber = 9 then say('"When telepathy is the norm, we will have an entirely wireless community."');

if randomnumber = 10 then say('"Where there is darkness there is light, where there is light there is shadow."');

if randomnumber = 11 then say('"A light can only shine in the dark"');

if randomnumber = 12 then say('"Life is like an onion: you peel off layer after layer, then you find there is nothing in it."');

if randomnumber = 13 then say('"I think the only reason I waste my breath on you is that being dead I don'+ char(39) +'t have any other use for it."');

if randomnumber = 14 then say('"If life was a box of chocolates, it'+ char(39) +'d be pretty empty. "');

if randomnumber = 15 then say('"Consciousness: that annoying time between naps."');

if randomnumber = 16 then say('"Why doesn'+ char(39) +'t DOS ever say: EXCELLENT command or filename?"');

if randomnumber = 17 then say('"Live life to the fullest...think of all the people on the Titanic who passed up chocolate dessert."');

if randomnumber = 18 then say('"If you can'+ char(39) +'t say anything nice...come sit by us."');

if randomnumber = 19 then say('"It'+ char(39) +'s not that I don'+ char(39) +'t want to clean my room its just that I have this theory that everything is balanced just right and if I attempt to move anything the whole structure of the house will come down like a house of cards."');

if randomnumber = 20 then say('"If you must choose between two evils, pick the one you'+ char(39) +'ve never tried before."');

if randomnumber = 21 then say('"I am NOT suffering from insanity... I happen to be enjoying myself! "');

if randomnumber = 22 then say('"4 out of 5 voices in my head say go back to sleep"');

if randomnumber = 23 then say('"I smile because I have no idea what'+ char(39) +'s going on."');

if randomnumber = 24 then say('"We are born naked, wet and hungry. Then things get worse"');

if randomnumber = 25 then say('"Laugh and the world thinks you'+ char(39) +'re an idiot. Laugh and the world laughs with you. Cry and the world laughs louder. "');

if randomnumber = 26 then say('"It is not the fall that kills you. it+ char(39) +''s the sudden stop at the end."');

if randomnumber = 27 then say('"I try to take one day at a time, but sometimes several days attack me at once. "');

if randomnumber = 28 then say('"Sure, the truth hurts, but so does a machete."');

if randomnumber = 29 then say('"Love goes as deep as you'+ char(39) +'re willing to dig the pit."');

if randomnumber = 30 then say('"I don'+ char(39) +'t suffer from insanity, I enjoy every minute of it"');

end;





end;

procedure TForm1.AutoConnect_TimerTimer(Sender: TObject);
begin
AutoConnect_Timer.Enabled:=false;
if irc_live then go.Click;

end;

procedure TForm1.timer_doupgradeTimer(Sender: TObject);
begin
timer_doupgrade.Enabled:=false;
      ShellExecute(Handle, 'open', PChar('Updater.exe'), nil, nil, SW_SHOWNORMAL);
      form1.close;

end;

end.
