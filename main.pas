// BlaatSchaap IRC BOT
// by Andr� van Schoubroeck
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
  Dialogs, StdCtrls, ExtCtrls, Sockets, ShellAPI, IRCbot_CompileTime;


    function ReadParams(data : string; number : integer; space : boolean):string;
    function contains (data,what: string) : boolean;
    function  IsAdmin  (name: string) : boolean;

    procedure KickBadWords(line,user: string);
    procedure RestoreSettings();
    procedure SaveSettings();
    procedure ReQuote();
    procedure Dice();
    procedure ListAdmin();
    procedure AddAdmin(name:string);
    procedure RemoveAdmin(name:string);
    procedure ListBadWords();
    procedure AddBadWord(badword:string);
    procedure RemoveBadWord(badword:string);
    procedure MusicPlaying();
    procedure AddStation(name,server,port:string);
    procedure RemoveStation(name:string);
    procedure ListStations();
    procedure ReadData(data: string);
    procedure Say(msg: string);
    procedure SayPriv(msg,user: string);
    procedure Announce(msg: string);
    procedure AnnouncePriv(msg,user: string);
    procedure Action(msg: string);
    procedure Kick(who: string);
    procedure Mode (who: string; mode : char; enable : boolean);
    procedure DoSomething(user, line, command, data: string; inchannel : boolean);
    procedure DoConvert(data : string);

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    status: TLabel;
    Go: TButton;
    server: TEdit;
    channel: TEdit;
    port: TEdit;
    Nick: TEdit;
    Stop: TButton;
    Panel1: TPanel;
    ChanPass: TEdit;
    ChanServID: TCheckBox;
    TcpClient: TTcpClient;
    ping: TTimer;
    Updater: TTimer;
    reconnect: TTimer;
    reconnect2: TTimer;
    wait1: TTimer;
    wait2: TTimer;
    TimeoutTimer: TTimer;
    ShoutCastInfo: TTcpClient;
    Panel3: TPanel;
    EditCommands: TEdit;
    MemoOutput: TMemo;

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
    procedure reconnectTimer(Sender: TObject);
    procedure reconnect2Timer(Sender: TObject);
    procedure wait1Timer(Sender: TObject);
    procedure wait2Timer(Sender: TObject);
    procedure TimeoutTimerTimer(Sender: TObject);
    procedure EditCommandsKeyPress(Sender: TObject; var Key: Char);
    procedure RunTempBatClick(Sender: TObject);


  end;
  type
  TReceive = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

  var spammer : integer;



var
  Form1: TForm1;

  logfile : textfile; //debug
  timeout      : boolean;

  receiveddata : string  ;
//  loginsleep : integer;

// converting procedures into functions

  receivednick : string  ;
  receivedchan : string  ;
  receivingdata : boolean;
  pingcount     : integer;
  pongcount     : integer;
  convert       : variant;
  time_convert  : variant;
  time_now, date_now : string;
  lastjoined    : string;
//  kicktime      : boolean;
  quotefile     : textfile;
// from the crash code
//  Adminsfile    : TextFile;
//  AdminCounter  : Integer;
//  Admins : array [1..10]of String; // try it


  ready : boolean ;
implementation

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
    assign(settingfile, 'settings');
    rewrite (settingfile);
    write (settingfile, form1.server.text);
    write (settingfile, ',');
    write (settingfile, form1.port.text);
    write (settingfile, ',');
    write (settingfile, form1.channel.text);
    write (settingfile, ',');
    write (settingfile, form1.nick.text);
    write (settingfile, ',');
    write (settingfile, form1.ChanservID.checked);
    write (settingfile, ',');
    write (settingfile, form1.ChanPass.text);
    write (settingfile, ',');
    closefile(settingfile);
    end;

procedure ReQuote();
var
tempbatfile : textfile;
//temp: char;
begin
{
//quote
//flush (quotefile);
//try close (quotefile); except end;

//try close (tempfile) ; except end;

   assign(tempfile, 'temp');
   rewrite (tempfile);
//   assign(quotefile, 'quotefile');
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
     flush (quotefile); // flushing the file did not seem to be the problem.

// quote
}
flush (quotefile);
assign (tempbatfile, 'temp.bat');
rewrite (tempbatfile);
writeln ( tempbatfile , ' del tempq ');
writeln ( tempbatfile , ' copy quotefile tempq ');
flush (tempbatfile);
close (tempbatfile);
//** shell code **
ShellExecute   (   0,'open',  'temp.bat' , nil, nil, SW_HIDE);

//FOrm1.RunTempBat.Click;
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


        closefile(settingfile);

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
ReQuote;
ready := true;

    end;



procedure AddAdmin(name:string);
    var
    adminfile : textfile;
    tempfile  : textfile;
    temp      : char;
//    admin     : string;

    begin
   assign(tempfile, 'temp');
   rewrite (tempfile);
   assign(adminfile, 'admins');
   reset (adminfile);

      while not eof(adminfile) do
      begin
      read (adminfile, temp);
      write (tempfile, temp);
      end;
      closefile(adminfile);
      closefile(tempfile);

   assign(tempfile, 'temp');
   reset (tempfile);
   assign(adminfile, 'admins');
   rewrite (adminfile);

      while not eof(tempfile) do
      begin
      read (tempfile, temp);
      write (adminfile, temp);
      end;
   closefile(tempfile);
   write (adminfile, AnsiLowerCase(name));
   write (adminfile, ',');
   closefile(adminfile);
   end;



procedure RemoveAdmin(name:string);
    var
    adminfile : textfile;
    tempfile  : textfile;
    temp      : char;
    admin     : string;

    begin
   assign(tempfile, 'temp');
   rewrite (tempfile);
   assign(adminfile, 'admins');
   reset (adminfile);

    while not eof(adminfile) do
      begin
      admin :='';
        repeat
        read (adminfile, temp);
        if not (temp = ',') then admin := admin + temp
        until temp = ',';
        if NOT (admin = name) then
        begin
        write (tempfile, admin);
        write (tempfile,',');
        end;
      end;

//      while not eof(adminfile) do
//      begin
//      read (adminfile, temp);
//      write (tempfile, temp);
//      end;
      closefile(adminfile);
      closefile(tempfile);

   assign(tempfile, 'temp');
   reset (tempfile);
   assign(adminfile, 'admins');
   rewrite (adminfile);

      while not eof(tempfile) do
      begin
      read (tempfile, temp);
      write (adminfile, temp);
      end;
   closefile(tempfile);
   closefile(adminfile);
   end;







procedure ListAdmin();
    var
    adminfile : textfile;
    temp      : char;
    admin     : string;

    begin
     say('The Admin list: ');
     say(' ');
    // try the comma separated text file
    // like the one i used in the quiz project
    assign(adminfile, 'admins');
    reset (adminfile);
    admin := '';
    while not eof(adminfile) do
      begin
      admin :='';
        repeat
        read (adminfile, temp);
        if not (temp = ',') then admin := admin + temp
        until temp = ',';
        say (admin);
      end;
      closefile(adminfile);

    end;







function IsAdmin  (name: string) : boolean;
    var
    adminfile : textfile;
    temp      : char;
    admin     : string;

    begin
    // try the comma separated text file
    // like the one i used in the quiz project
    assign(adminfile, 'admins');
    reset (adminfile);
    admin := '';
    while not eof(adminfile) do
      begin
      admin :='';
        repeat
        read (adminfile, temp);
        if not (temp = ',') then admin := admin + temp
        until temp = ',';
      if AnsiLowerCase(name) = AnsiLowerCase(admin) then result := true;
      end;
      closefile(adminfile);

    end;

// forbidden words stuff

procedure AddBadWord(badword:string);
    var
    badwordsfile : textfile;
    tempfile  : textfile;
    temp      : char;
//    admin     : string;

    begin
   assign(tempfile, 'temp');
   rewrite (tempfile);
   assign(badwordsfile, 'badwords');
   reset (badwordsfile);

      while not eof(badwordsfile) do
      begin
      read (badwordsfile, temp);
      write (tempfile, temp);
      end;
      closefile(badwordsfile);
      closefile(tempfile);

   assign(tempfile, 'temp');
   reset (tempfile);
   assign(badwordsfile, 'badwords');
   rewrite (badwordsfile);

      while not eof(tempfile) do
      begin
      read (tempfile, temp);
      write (badwordsfile, temp);
      end;
   closefile(tempfile);
   write (badwordsfile, AnsiLowerCase(badword));
   write (badwordsfile, ',');
   closefile(badwordsfile);
   end;



procedure RemoveBadWord(badword:string);
    var
    badwordsfile : textfile;
    tempfile  : textfile;
    temp      : char;
    badwordinfile : string;

    begin
   assign(tempfile, 'temp');
   rewrite (tempfile);
   assign(badwordsfile, 'badwords');
   reset (badwordsfile);

    while not eof(badwordsfile) do
      begin
      badwordinfile :='';
        repeat
        read (badwordsfile, temp);
        if not (temp = ',') then badwordinfile := badwordinfile + temp
        until temp = ',';
        if NOT (badword = badwordinfile) then
        begin
        write (tempfile, badwordinfile);
        write (tempfile,',');
        end;
      end;

//      while not eof(adminfile) do
//      begin
//      read (adminfile, temp);
//      write (tempfile, temp);
//      end;
      closefile(badwordsfile);
      closefile(tempfile);

   assign(tempfile, 'temp');
   reset (tempfile);
   assign(badwordsfile, 'badwords');
   rewrite (badwordsfile);

      while not eof(tempfile) do
      begin
      read (tempfile, temp);
      write (badwordsfile, temp);
      end;
   closefile(tempfile);
   closefile(badwordsfile);
   end;







procedure ListBadWords();
    var
    badwordsfile : textfile;
    temp      : char;
    badword     : string;

    begin
     say('The Bad Words list: ');
     say(' ');
    // try the comma separated text file
    // like the one i used in the quiz project
    assign(badwordsfile, 'badwords');
    reset (badwordsfile);
    badword := '';
    while not eof(badwordsfile) do
      begin
      badword :='';
        repeat
        read (badwordsfile, temp);
        if not (temp = ',') then badword := badword + temp
        until temp = ',';
        say (badword);
      end;
      closefile(badwordsfile);

    end;





// end of forbidden words stuff



procedure DoConvert(data : string);
var
temp0 : variant;
temp1,temp2,temp3,temp4 : integer;
temp5, temp6 : string;
begin
//say ( 'converting not implemented yet') ;

if ( readparams(data,0,false)) = 'T' then // temperature conversions
begin
    if ( readparams(data,1,false) = 'C') and  ( readparams(data,2,false) = 'F') then
    begin
    temp0 := ( readparams(data,3,false));
    temp1:= temp0 ;
    temp2 := ((temp1 * 9 div 5 ) + 32);
    temp0 := temp1;
    temp5 := temp0;
    temp0 := temp2;
    temp6 := temp0;
    say ( temp5 + '* C is '+ temp6 + '* F ');
    end;
    if ( readparams(data,1,false) = 'F') and  ( readparams(data,2,false) = 'C') then
    begin
    temp0 := ( readparams(data,3,false));
    temp1:= temp0 ;
    temp2 := ((temp1 - 32 ) * 5 div 9 );
    temp0 := temp1;
    temp5 := temp0;
    temp0 := temp2;
    temp6 := temp0;
    say ( temp5 + '* F is '+ temp6 + '* C ');
    end;
end;






end;




//blaat
procedure MusicPlaying();
    var
    musicfile : textfile;
    temp      : char;
    server    : string;
    port      : string;
    song      : string;
    station   : string;

    tempchar   : char;
    tempstring : string;
    counter : integer;
    stop : boolean;



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



    begin
    //say ( 'DEBUG : CONNECTING');
    song := '';
    stop := false;
    tempchar := char(0);
    counter := 0;

    Form1.ShoutCastInfo.RemoteHost := server;
    FOrm1.ShoutCastINfo.RemotePort := port;
    if Form1.SHoutcastINfo.Connect then
        begin
        FOrm1.ShoutCastInfo.Sendln('GET /7 HTTP/1.0');
        form1.ShoutCastInfo.Sendln('User-Agent: Mozilla (Compatible, BlaatSchaap IRC Bot)');
        form1.ShoutCastInfo.Sendln('Client-Version : '+ Form1.Caption);
        form1.ShoutCastInfo.Sendln('');
        tempstring := form1.Shoutcastinfo.Receiveln();
        tempstring := form1.Shoutcastinfo.Receiveln();
        tempstring := form1.Shoutcastinfo.Receiveln();
        tempstring := form1.Shoutcastinfo.Receiveln();


        //1
        repeat
        counter := counter +1;
        tempchar := tempstring[counter];
        until tempchar = ',';

        //2
        repeat
        counter := counter +1;
        tempchar := tempstring[counter];
        until tempchar = ',';

        //3
        repeat
        counter := counter +1;
        tempchar := tempstring[counter];
        until tempchar = ',';

        //4
        repeat
        counter := counter +1;
        tempchar := tempstring[counter];
        until tempchar = ',';

        //5
        repeat
        counter := counter +1;
        tempchar := tempstring[counter];
        until tempchar = ',';

        //6
        repeat
        counter := counter +1;
        tempchar := tempstring[counter];
        until tempchar = ',';

        repeat
        counter := counter +1;
        tempchar := tempstring[counter];
        if tempchar = '_' then tempchar := ' ';
        if tempchar = '<' then begin stop :=true; tempchar:= char(0); end;
        song := song + tempchar;
        until stop;
        say ( 'Current song at ' + station + ' is ' + song);
        say ( 'http://'+server+':'+port+'/listen.pls');
        say ( ' ') ;
        form1.Shoutcastinfo.Disconnect;


    end else say ( 'error connecting to ' + station);
//end infoshecker


    end;
// blaat
end;
closefile(musicfile);
end;

procedure TForm1.GoClick(Sender: TObject);

begin
      writeln (quotefile, ' ');
      writeln (quotefile, 'Logging starts at ' + time_now + ' '+ date_now);
      writeln (quotefile, ' ');

timeout := false;
TimeoutTimer.Enabled:=true;
status.Caption:='Connecting....';
status.Repaint; // force repaint else not when server down
go.Enabled := false;
stop.Enabled := true;
tcpclient.RemoteHost := server.Text;
tcpclient.RemotePort := port.Text;
if tcpclient.Connect then
begin
status.Caption:='Connected...';
treceive.Create(false);
tcpclient.Sendln('NICK '+ nick.Text);
//tcpclient.Sendln('USER dgcbot dgchost '+ server.Text + ' :dGCbot www.sf.net/projects/dgcshell');
// got kiced in #Skyos
tcpclient.Sendln('USER blaatbot blaathost '+ server.Text + ' :Blaatschaap Bot www.sf.net/projects/dgcshell');
//sniffed
//USER andre_winxp 786at1600 irc.chat4all.org :Andre van Schoubroeck
server.Enabled := false;
port.Enabled := false;
nick.Enabled := false;
channel.Enabled := false;
ChanservID.Enabled:=false;
ChanPass.Enabled := false;
status.Caption:='Waiting for server...';
// found the code to detect when the server is ready
// moving login code to readdata



end else
begin
status.Caption:='Server did not respond';
if (reconnect2.Enabled= true) then
wait1.Enabled:= true else wait2.Enabled:= true;
end;
end;


procedure Kick(who: string);
begin
form1.TcpClient.Sendln('KICK ' + form1.channel.Text + ' ' + who);
end;

procedure Mode (who: string; mode : char; enable : boolean);
begin
if enable = true then
form1.TcpClient.Sendln('MODE '+ form1.channel.Text +' +'+mode+' '+who);
if enable = false then
form1.TcpClient.Sendln('MODE '+ form1.channel.Text +' -'+mode+' '+who);
end;

    procedure KickBadWords(line,user: string);
    var
    badwordsfile : textfile;
    temp         : char;
    badword      : string;

    begin
    //say('testing for bad words');
    // try the comma separated text file
    // like the one i used in the quiz project
    assign(badwordsfile, 'badwords');
    reset (badwordsfile);
    badword := '';
    while not eof(badwordsfile) do
      begin
      badword :='';
        repeat
        read (badwordsfile, temp);
        if not (temp = ',') then badword := badword + temp
        until temp = ',';
        //say ('did '+ user+' say '+badword);
      if contains(line,badword) then
        begin
        say('Forbidden word: ' + badword + ', kicking '+user);
        kick(user);
        end;
      //AnsiLowerCase(name) = AnsiLowerCase(badword) then result := true;
      end;
      closefile(badwordsfile);

    end;





procedure Dice();
var
die1, die2 : integer;
temp, temp2: string;

begin
randomize;
die1 := random(6) + 1;
die2 := random(6) + 1;
convert := die1;
temp := convert;
convert := die1;
temp := (temp + '  &  ');
convert := die2;
temp2 := convert;
temp :=  (temp + temp2);
say(temp);
end;

// procedure contains(data,what: string);
function contains (data,what: string):boolean;

var
counter    : integer;
wordlenght : integer;
datalenght : integer;
tempstring : string;
tempchar   : char;
counter2   : integer;
counter3   : integer;
//temp       : integer;
convert    : variant;

begin
data := AnsiLowerCase(data);
what := AnsiLowerCase(what);

if NOT ( data = '') then if NOT( what = '') then begin;
// check if there is data
counter := 0;
counter2 := 0;
counter3 := 0;


repeat
counter := counter + 1;
tempchar := what[counter];
until  (tempchar = '');
wordlenght := counter-1; // we know now the lenght of the word
    convert := wordlenght;


counter := 0;
repeat
counter := counter + 1;
tempchar := data[counter];
until (tempchar='');
datalenght := counter; // we know now the lenght of the data
    convert := datalenght-1;


if datalenght > wordlenght then begin
repeat
counter3 := counter3 + 1;
tempstring := '';
counter2 := 0;
  repeat
    counter2 := counter2 + 1;

    // it seems it is now allowed to do tempchat[counter2+counter3]
    tempchar := data[counter2 + counter3 - 1];
    tempstring := tempstring + tempchar;
  until counter2 = wordlenght;


until (counter3 = datalenght - wordlenght) or (tempstring = what);
//if (tempstring = what) then temp_contains := true else temp_contains := false;
if (tempstring = what) then Result := true else Result := false;


end; // end of check for datalenght > whatlenght
end; // end check for valid data


end;

procedure DoSomething(user, line, command, data: string; inchannel : boolean);
var
number     : integer;
//IsAdmin    : boolean;
//Counter    : integer;
quotes : textfile ; //does delphi allow the same file to be opened twice ?
quoteline : string;
quotecount : integer;

begin
// try this to fix the find stops logging
// only temp solution, it can't stay this way
// ReQuote;
// not working....



if NOT(Contains(line,chr(1))) then
writeln(quotefile, '['+ date_now + ' ' + time_now + '] <'+user + '>  ' + line)
else
writeln(quotefile, '['+ date_now + ' ' + time_now + '] *'+user + '  ' + line);
// action, still strip the chr(1);




if not (command='') then
if (command[1]='!') then Form1.MemoOutput.Lines.Add(user + ' : ' + command + ' ' + data);


if not (contains(user,'serv')) then begin
// to prevent reacting on  *serv
// say in private to rejoin the channel, ( when it is kicked ? )
if (inchannel = false) and contains(line,'rejoin') then form1.TcpClient.Sendln('JOIN '+ form1.channel.Text);

//if (inchannel = false) and contains(line,form1.Nick.edit) then say('I am  '+form1.nick.Text);

if (inchannel = false) and (line = ( CHR(1) +'VERSION' + CHR(1))) then
//received a CTCP version
form1.TcpClient.Sendln('NOTICE ' + user + ' :'+ CHR($01) + 'VERSION '+ Form1.Caption + CHR($01))
else

if inchannel = false then
begin
randomize;
number := 7; //disable
//number := random(6);
// put strings in a file ?
if ( number = 0 ) then saypriv('I am '+ form1.Nick.Text, user);
if ( number = 1 ) then saypriv(user, user);
if ( number = 2 ) then saypriv('You must be bored', user);
if ( number = 3 ) then saypriv('blaatschaap.nukysrealm.net', user);
if ( number = 4 ) then saypriv('Wat moet je ? ', user);
if ( number = 5 ) then saypriv('I am only a bot....', user);
end;

// example how to use the new contains function
if contains(line,'blaat') and (not (user = lastjoined)) then
begin
say('Inderdaad, blaat in het kwadraat!');
lastjoined := user;    //reuse,flood protect
end;


if ( command = '!convert' ) then DoConvert(data);

if (command = '!music') and (data ='') then
  begin
  //say ( 'DEBUG : MUSIC' );
  musicplaying;
  end;


if ( command = '!music' ) and (ReadParams(data,0,false) ='add') then
  begin
  AddStation( ReadParams(data,1,false) ,  //name
              ReadParams(data,2,false) ,  //server
              ReadParams(data,3,false) ); //port
  end;

if ( command = '!music' ) and (ReadParams(data,0,false) ='remove') then
  begin
  RemoveStation( ReadParams(data,1,false) );  //name
  end;

if ( command = '!music' ) and (ReadParams(data,0,false) ='list') then
  begin
  ListStations();
  end;


if command = '!find' then
begin
//flush(quotefile);
//close(quotefile);
ReQuote;
sleep(350); // give the batch file time to run
assign (quotes,'tempq');
reset ( quotes );
quotecount := 0;
      while not eof(quotes) do
      begin
      readln ( quotes, quoteline );
     // say ( 'DEBUG: ' + quoteline);
      if contains(quoteline,data) then
        begin
        quotecount := quotecount + 1;
       if (quotecount < 6 ) then say (quoteline);
        end;
      end;
close (quotes);  // Andre was stupid, forgot to close the fucking file !!
end;

if command = '!kill' then action('kills '+data);
if command = '!nuke' then action('nukes '+data);
if command = '!dice' then dice;
if command = '!torture' then action('tortures '+data);  // Torture code

// Code meow start here
if command = '!meow' then say(form1.nick.text  + char(39) + 's cat: meow');
// End code meow

if command = '!woof' then begin
say ( 'Sorry, no dogs allowed in here ');
kick (user);
end;


if (inchannel = true ) and ( command = '!info' ){and  (AnsiLowerCase(data) = AnsiLowerCase(form1.Nick.text)) }then
begin
announce('I am BlaatSchaap Bot b�ta');
announce('My Source Code is avaiable at sourceforge');
announce('Compile date: ' + DateToStr(CompileTime) + ' ' + TimeToStr(CompileTime) );
announce('It is under the zlib licence');
announce('Check http://blaatschaap.nukysrealm.net/content.php?content.5 or');
announce('http://www.sf.net/projects/dgcshell for more info');
end;

if ( command = '!help' )then
begin


say(' ');
say(' Current supported user commandos are:');
say('   !info                  !help             ');
say('   !kill    <username>    !dice');
say('   !music                 !porn     ');
say('   !nuke                  !torture   ');
say('   !meow                  !woof ');
say(' ');
say(' Current supported admin commandos are:');
say('   !op      <username>    !deop    <username>');
say('   !hop     <username>    !dehop   <username>');
say('   !voice   <username>    !devoice <username>');
say('   !ban     <username>    !unban   <username>');
say('   !nick    <newbotnick>  !join    <channel>');
say(' ');
end;

if ( command = '!porn' ) then

begin
spammer := 0;
repeat
saypriv ( 'You want porn ? now you will be SPAMMED',user);
spammer := spammer + 1;
until (spammer = 25);
say ( 'No porn in here, get out '+user+' !!!!');
kick(user);
end;


//administrative stuff , needs to add protection
//else everyone can start banning

//  this is the acces violating code

//    try to implent admins in a file
//    AssignFile(Adminsfile, 'admins');
//    Reset(Adminsfile);
//
//    while not eof(adminsfile) do
//    begin
//    admincounter := admincounter + 1;
//    readln ( adminsfile , admins[admincounter] )
//    end;
//    Close(Adminsfile);
//    repeat
//    counter := counter + 1 ;
//    if (AnsiLowerCase(user) = admins[counter]) then IsAdmin := true;
//    until counter = admincounter;
//if isadmin then



// temporairy security code
//if (AnsiLowerCase(user) = 'andre') or (AnsiLowerCase(user) = 'a-v-s')or (AnsiLowerCase(user) = 'nuky') then

if isadmin(user) then
begin
// command to the bots
if (command = '!admin') and (ReadParams(data,0,false)= 'list')  then
listadmin();

if (command = '!admin') and (ReadParams(data,0,false)= 'add') then
begin
if NOT ((ReadParams(data,1,false)) = '') then
begin
AddAdmin(ReadParams(data,1,false));
announce(user + ' added '+ (ReadParams(data,1,false)) + ' to the admin list.')
end else say('who?');
end;


if (command = '!admin') and (ReadParams(data,0,false)= 'remove') then
begin
if NOT ((ReadParams(data,1,false)) = '') then
begin
RemoveAdmin(ReadParams(data,1,false));
announce(user + ' removed '+ (ReadParams(data,1,false)) + ' from the admin list.')
end else announce('who?');
end;



if (command = '!badword') and (ReadParams(data,0,false)= 'list')  then
listbadwords();

if (command = '!badword') and (ReadParams(data,0,false)= 'add') then
begin
if NOT ((ReadParams(data,1,false)) = '') then
begin
AddBadWord(ReadParams(data,1,true));
announce(user + ' added '+ (ReadParams(data,1,false)) + ' to the bad word list.')
end else announce('no word to add');
end;


if (command = '!badword') and (ReadParams(data,0,false)= 'remove') then
begin
if NOT ((ReadParams(data,1,false)) = '') then
begin
RemoveBadword(ReadParams(data,1,true));
announce(user + ' removed '+ (ReadParams(data,1,true)) + ' from the bad word list.')
end else announce('no word to remove');
end;


// add check for illegal signs in nick ..
// check what is allowed to be in a nick first ..
if command = '!nick' then begin form1.Nick.text:=data; form1.tcpclient.Sendln('NICK '+form1.nick.text);end;

if command = '!join' then
begin
if data[1]='#' then
  begin
  form1.TcpClient.Sendln('PART '+ form1.channel.Text);
  form1.channel.Text := data;
  form1.TcpClient.Sendln('JOIN '+ form1.channel.Text);
  // add check for succesfull join.
  // check how to do so ...
  // add check for illegal signs in channel name
  end else
say ('Channels should begin with # ');
end;

// commands in the channel
//if NOT(contains(data,form1.Nick.Text)) then


// add check if bot is +h / +o / +a / +q
if NOT(data=form1.Nick.Text) then
begin

if command = '!kick'     then
begin
if AnsiLowerCase(data)=AnsiLowerCase(user) then say ('Do you really want to kick yourself?')
else kick(data);  end;

if command = '!ban'      then mode(data,'b',true);
if command = '!unban'    then mode(data,'b',false);
if command = '!op'       then mode(data,'o',true);
if command = '!deop'     then mode(data,'o',false);
if command = '!hop'      then mode(data,'h',true);
if command = '!dehop'    then mode(data,'h',false);
if command = '!voice'    then mode(data,'v',true);
if command = '!devoice'  then mode(data,'v',false);
end; // don't do that to itself
KickBadWords(line,user);
end;

end; // end of *serv detection
end;

function ReadParams(data : string; number : integer; space : boolean):string;
var
datalen,counter : integer;
datas : integer;
temp : char;
datatemp , params : string;
currentnumber : integer;
begin
if not( data = '') then begin
datas := 0;
counter := 0;
datalen := 0;
currentnumber :=0;
if number > 0 then begin
  repeat
  currentnumber := currentnumber + 1;
  repeat
	datas := datas + 1;
	temp := data[datas];
  until (temp = ' ');
  until (currentnumber = number) or (temp = '');
  //datas := datas ;
end;

//  if NOT (temp = '')  then begin
//  if temp = ' ' then begin
begin


	repeat
	datalen := datalen + 1;
	temp := data[datas + datalen];
	datatemp := datatemp + temp ;
	until (temp = '')or ((space=false) and (temp = ' '));

//  if NOT (data = '') then begin
//  if data = ' ' then begin
//  say ('tweede spatie gevonden');
if datalen > 1  then
	repeat
	counter := counter + 1;
	params := params + data[datas + counter];
	until counter = datalen -1;
//  end;
  result:=params;
  end;// else result :='invalid data (end of data)';

end else result :='no data'; //data
end;


procedure ReadData(data: string);
var
temp    : char;
counter : integer;
username: string;
usertemp: string;
command : string;
target  : string;
message : string;
inchannel : boolean;
namelen : integer;
counter2: integer;
Dcount  : integer;
mCommand: string;
mCommandtemp : string;
scount  : integer;
mData   : string;
mCount  : integer;
mestemp : string;
pinger : string;
ok : boolean;
begin

counter := 0;
counter2 := 0;
mcommand :='';
mdata := '';

// now we have the ReadParams ,
// a lot of this code could be replaced
//
// the code could be like this then
if ReadParams(data,1,false) = 'PONG' then
begin
convert := ReadParams(data,4,false);
//form1.status.caption := convert;
pongcount := convert;
//write (logfile,'PONG ');
//write (logfile,pingcount);
//write (logfile, chr(13));
end;




// not sure what this does, but that is how xchat reacted
// if  (contains(data,'MODE')) and (contains(data,'+i'))  then form1.TcpClient.Sendln('USERHOST '+form1.Nick.Text);


if NOT (data = '') then // check if there is data
begin
//form1.Label4.Caption := '' ;
if NOT (data[1] = 'P') then counter := counter + 1; // ignoring the first letter :
// leave the P of PING

repeat
counter := counter + 1;
namelen := namelen + 1;
temp := data[counter];
usertemp := usertemp + temp ;
until (temp = '!') or (temp = ' ');
//username must be the !

if temp = '!' then
begin

repeat
counter2 := counter2 + 1;
username := username + usertemp[counter2];
until counter2 = namelen -1;
// remove the ! from the name


repeat
counter := counter + 1;
temp := data[counter];
//form1.Label4.Caption := form1.Label4.Caption + temp
until temp = ' ';




repeat
counter := counter + 1;
temp := data[counter];
command := command + temp;
until temp = ' ';

//form1.Label1.Caption := command; // debug command


// try moving it if command = 'PRIVMSG ' then
begin
repeat
counter := counter + 1;
temp := data[counter];
target := target + temp;
until temp = ' ';

//form1.Label2.Caption := target; // debug the target

if AnsiLowerCase(target) = (form1.channel.Text + ' ') then
// message in the channel
begin
ok := true;
inchannel := true;
end;

if AnsiLowerCase(target) = AnsiLowerCase((form1.nick.Text + ' ')) then
//message in private
begin
ok := true;
inchannel := false;
end;

if ok = true then
begin

  if command = 'PRIVMSG ' then  counter := counter + 1;   // ignore the ':'
  temp := data[counter];



mcount := 0;
repeat
counter := counter + 1;
mcount := mcount + 1;
temp := data[counter];
mestemp := mestemp + temp;
until temp = '';    // end of data

counter := 0;
mcount := mcount - 1;
repeat
counter := counter + 1;
temp := mestemp[counter];
message := message + temp;
until counter = mcount;
//remove the '' from the end;


dcount := mcount;
//form1.Label3.Caption := message; // debug the command
mCount:=0;
repeat
mCount := mCount + 1;
temp := Message[mCount];
mCommandTemp := mCommandTemp + temp;
//Temp ..
until (temp = ' ') or (mcount = dcount);

//try this
if not (mcount = 1) then begin
if (temp = ' ') then begin


 repeat
 sCount := sCount + 1;
 temp := mCommandTemp[sCount];
 mCommand := mCommand + temp;
 until scount = mcount - 1;
 //remove the ' '


if not (mcount = dcount) then begin //no space at the end

repeat
mCount := mCount + 1;
temp := Message[mCount];
mData := mData + temp;
until mcount = dcount;
end; // read the data


 end else mCommand := mCommandTemp ;
end; // begins with a space

// mot deze weg
 end;// end of separating commands


// i think this is where the separation should be
if command = 'PRIVMSG ' then begin

dosomething (username, message,mCommand,mData, inchannel);

// and now comes the action
// write some stuff here
// or better, put it
// in a new procedure




end; // end of channel message


end; //end of PRIVMSG


if command = 'KICK ' then
// someone got kicked !
// check if it is us
//if (contains(data,form1.Nick.Text)) and (NOT (username=form1.Nick.text)) then
if mCommand = form1.Nick.Text  then
begin
form1.TcpClient.Sendln('JOIN '+ form1.channel.text);
say('Ouch .... '+username+', stop kicking me, it hurts.' );
end;
if (command = 'JOIN ' )and (not (username = form1.Nick.Text)) and (not (username = lastjoined)) then
begin
lastjoined := username;
say('Heey, ' +  username + ', welcome to ' + form1.channel.Text);
end;

//
//repeat
//counter := counter + 1;
//temp := data[counter];
//command := command + temp;
//until temp = ' ';
//



//

//

end else begin //end of user message , could now add the PONG command


repeat
counter := counter + 1;
temp := data[counter];
command := command + temp;
until temp = ' ';



//if (data[1] = 'P') and (usertemp ='ING ') then // we removed the first character
//  begin
//pinger :='';
//counter :=5;
//  repeat
//counter := counter + 1;
//temp := data[counter];
//pinger := pinger + temp ;
//until temp = '';
//form1.TcpClient.Sendln('PONG '+ pinger) ;


//  end else begin
//if (data[1] = 'P') and (usertemp ='ING ') then // we removed the first character
//fuck chatnet ... if that is true ... then i need to rewrite all the shit
// or leave support for that specific server
// or write a compatibility proxy
// need to rewrite that too,
if usertemp = 'PING ' then
//  the fix worked

  begin
pinger :='';
counter :=5;
repeat
counter := counter + 1;
temp := data[counter];
pinger := pinger + temp ;
until (temp = '') or (temp =CHR($01));
// replaced above with the pasted
// try to paste the f*cking code here
// since it REFUSES to work in a METHOD !!!
// pasted code here cause the remove method
// is fucked up and i can't see what is wrong
// with the fucking code.

////bebug
// seems to work now ?!?!?
//form1.Label3.Caption := remove(pinger);
//form1.tcpclient.Sendln( 'PONG '+ form1.Label3.Caption);
////
    mcount := counter;
    counter := 0;
    mcount := mcount - 1;
    repeat
   counter := counter + 1;
    temp := pinger[counter];
    message := message + temp;
    until counter = mcount-5;
    pinger := message;
// pased till here ..

// remove in method;
//form1.TcpClient.Sendln('PONG '+ REMOVE(pinger)) ;

// test remove method again
form1.TcpClient.Sendln('PONG '+ pinger) ;

//wtf ? remove code adds some chr($0) ?!?!?!

  end else begin






// test dit
repeat
counter := counter + 1;
temp := data[counter];
target := target + temp;
until temp = ' ';

begin
counter := counter + 1;
temp := data[counter];
// ignore the ':' ?
mcount := 0;
repeat
counter := counter + 1;
mcount := mcount + 1;
temp := data[counter];
mestemp := mestemp + temp;
until temp = '';    // end of data

counter := 0;
mcount := mcount - 1;
repeat
counter := counter + 1;
temp := mestemp[counter];
message := message + temp;
until counter = mcount;
//remove the '' from the end;
end;
// tot hier
end;
//form1.Label8.Caption := target;


if command='376 ' then
// ready to log in
begin
form1.TimeoutTimer.Enabled:=false;
form1.status.Caption:='BlaatSchaap Bot Ready...';
form1.tcpclient.Sendln('JOIN '+ form1.channel.Text);
form1.ping.Enabled := true;
if form1.ChanServID.checked then saypriv('identify '+form1.ChanPass.Text,'NickServ');
// add check if password is accepted ?
end;



end; // end of server message
end; //end of valid data

end;

procedure SayPriv(msg,user: string);
begin

form1.TcpClient.Sendln('PRIVMSG ' + user + ' :'+ msg);
end;






procedure Say(msg: string);
begin

form1.TcpClient.Sendln('PRIVMSG ' + form1.channel.Text + ' :'+ msg);
end;

procedure Announce(msg: string);
begin
 form1.TcpClient.Sendln('NOTICE ' + form1.channel.Text + ' :'+ msg);
end;

procedure AnnouncePriv(msg,user: string);
begin
 form1.TcpClient.Sendln('NOTICE ' + user + ' :'+ msg);
end;



procedure Action(msg: string);
begin
form1.TcpClient.Sendln('PRIVMSG ' + form1.channel.Text + ' :'+ CHR($01) + 'ACTION '+ msg+ CHR($01));
end;






procedure TReceive.Execute;
begin

repeat

sleep (1); // sleep for 1 ms to keep the cpu usage low
if  form1.TcpClient.WaitForData() then
begin
receivingdata := true;
receiveddata := form1.tcpclient.Receiveln();
//bebug, should start log a file ?
//form1.memo1.Text := form1.memo1.Text  + receiveddata  ;
 readdata(receiveddata);
// and now read the received data
 receiveddata :='';
// and get rid of it

end else receivingdata := false;;

until (form1.TcpClient.Connected = false);
form1.Panel1.Color := clred;
//form1.Stop.click;
form1.TcpClient.Disconnect;

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
reconnect.Enabled := true;
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
tcpclient.Sendln('PING : '+tempstring)  ;
end;

procedure TForm1.StopClick(Sender: TObject);
begin

reconnect.enabled := false;
reconnect2.enabled:=false;
wait1.enabled := false;
wait2.enabled := false;
timeouttimer.enabled:=false;
ping.Enabled := false;

status.Caption:='Disconnected';
ChanservID.Enabled:=true;
ChanPass.Enabled := true;
server.Enabled := true;
port.Enabled := true;
nick.Enabled := true;
channel.Enabled := true;
go.Enabled := true;
stop.Enabled := false;
tcpclient.Disconnect;
end;


procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
tcpclient.Disconnect;
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

// Update current time and date.


time_convert  := time;
time_now := time_convert;
time_convert  := date;
date_now := time_convert;




if timeout then
  begin
  timeout :=false;
  write (logfile,'Login Timeout' + chr(13) );
  //stop.Click;
  tcpclient.Disconnect;
  status.Caption := 'Connected, but no answer';
     if  (not wait2.Enabled ) or
         (not reconnect.Enabled ) or
         (not reconnect2.enabled) then wait1.enabled := true
else if  (not wait1.Enabled ) or
         (not reconnect.Enabled ) or
         (not reconnect2.enabled) then wait2.enabled := true
else status.Caption := 'timeout / reconnect bug';

  end;

if form1.tcpclient.Connected = false then panel1.Color := clred else
if receivingdata = true then panel1.Color := clgreen else
if receivingdata = false then panel1.Color := clgray;
if ( form1.TcpClient.Connected = false ) AND (form1.ping.Enabled = true) then  form1.Status.Caption := 'Server dropped connection'
end;

procedure TForm1.joinerTimer(Sender: TObject);
begin
tcpclient.Sendln('JOIN '+ channel.Text)  ;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
// set date and time formats
TimeSeparator   := ':';
DateSeparator   := '-';
ShortDateFormat := 'dd/mm/yyyy' ;
LongTimeFormat  := 'hh:nn:ss'   ;

Form1.Caption:='BlaatSchaap IRC BOT (Compile Date ' + DateToStr(CompileTime)+' @ '+TimeToStr(CompileTime) +')';
restoresettings();
if ChanServID.Checked then ChanPass.Enabled := true else ChanPass.Enabled := false;
//pongcount := 1; // begin value
end;

procedure TForm1.serverChange(Sender: TObject);
begin
if ready then savesettings()
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

procedure TForm1.reconnectTimer(Sender: TObject);
begin
write (logfile, 'Reconnecting.....' + chr(13));
status.Caption:='Reconnecting.....';
//stop.Click;
tcpclient.Disconnect;
go.click;
reconnect.Enabled:=false;
end;

procedure TForm1.reconnect2Timer(Sender: TObject);
begin
reconnect.Enabled:=false;
write (logfile, 'Reconnecting.....' + chr(13));
status.Caption:='Reconnecting.....';
//stop.Click;
tcpclient.Disconnect;
go.click;
reconnect2.Enabled:=false;
end;

procedure TForm1.wait1Timer(Sender: TObject);
begin
if wait2.Enabled = true then
begin
// this may not happen
status.Caption := 'Reconnect timer bug';
write(logfile,'Reconnect timer bug : 1 nog actief' + chr(13));
end;

reconnect.Enabled:=true;
wait1.Enabled := false;
end;

procedure TForm1.wait2Timer(Sender: TObject);
begin
if wait1.Enabled = true then
begin
// this may not happen
status.Caption := 'Reconnect timer bug';
write(logfile,'Reconnect timer bug : 1 nog actief' + chr(13));
end;

reconnect2.Enabled:=true;
wait2.Enabled := false;
end;

procedure TForm1.TimeoutTimerTimer(Sender: TObject);
begin
timeout := true;
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

//DoSomething('Admin',EditCommands.Text,command,data,false);
DoSomething('Admin',EditCommands.Text,command,data,true);
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

end.
