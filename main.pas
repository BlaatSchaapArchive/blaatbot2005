// dGC IRC BOT
// by André van Schoubroeck
// http://www.sf.net/projects/dgcshell
// code is under zlib licence
//
//
// *** insert licence ***
//
//
// Changelog :
//
// 26 sept 2005
// added check for # in channel name on !join command
// password box now has *
// password box disabled if chanserv is disabled


unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Sockets;


    function ReadParams(data : string; number : integer; space : boolean):string;
    function contains (data,what: string) : boolean;
    function  IsAdmin  (name: string) : boolean;

    procedure RestoreSettings();
    procedure SaveSettings();
    procedure Dice();
    procedure ListAdmin();
    procedure AddAdmin(name:string);
    procedure RemoveAdmin(name:string);
    procedure MusicPlaying();
    procedure ReadData(data: string);
    procedure Say(msg: string);
    procedure SayPriv(msg,user: string);
    procedure Announce(msg: string);
    procedure AnnouncePriv(msg,user: string);
    procedure Action(msg: string);
    procedure Kick(who: string);
    procedure Mode (who: string; mode : char; enable : boolean);
    procedure dosomething(user, line, command, data: string; inchannel : boolean);

type
  TForm1 = class(TForm)
    TcpClient: TTcpClient;
    ping: TTimer;
    Go: TButton;
    server: TEdit;
    channel: TEdit;
    port: TEdit;
    Nick: TEdit;
    Stop: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    Updater: TTimer;
    ChanPass: TEdit;
    ChanServID: TCheckBox;
    Label9: TLabel;
    status: TLabel;
    reconnect: TTimer;
    reconnect2: TTimer;
    wait1: TTimer;
    wait2: TTimer;
    TimeoutTimer: TTimer;
    ShoutCastInfo: TTcpClient;
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
  lastjoined    : string;
  kicktime      : boolean;

// from the crash code
//  Adminsfile    : TextFile;
//  AdminCounter  : Integer;
//  Admins : array [1..10]of String; // try it


  ready : boolean ;
implementation

{$R *.dfm}


procedure savesettings();
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




procedure restoresettings();
  var
  settingfile : textfile;
  temp         : char;
  data         : string;

    begin
    // put the file thing in here, doesn;t want to
    // work in a form1.something
    // first parameter not a file then or something
    assign(logfile, 'log'); // for debugging
    rewrite (logfile);     //

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
        ready := true; //
        //    preventing the change to activate the
        //    savesettings



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







procedure listadmin();
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







function isadmin  (name: string) : boolean;
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

//blaat
procedure musicplaying();
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
        form1.ShoutCastInfo.Sendln('User-Agent: Mozilla (Compatible, dgcbot)');
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
tcpclient.Sendln('USER dgcbot dgchost '+ server.Text + ' :dGCbot www.sf.net/projects/dgcshell');
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






procedure dice();
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

procedure dosomething(user, line, command, data: string; inchannel : boolean);
var
number     : integer;
//IsAdmin    : boolean;
//Counter    : integer;
begin
if not (contains(user,'serv')) then begin
// to prevent reacting on  *serv
// say in private to rejoin the channel, ( when it is kicked ? )
if (inchannel = false) and contains(line,'rejoin') then form1.TcpClient.Sendln('JOIN '+ form1.channel.Text);

//if (inchannel = false) and contains(line,form1.Nick.edit) then say('I am  '+form1.nick.Text);


if (inchannel = false) and (line = ( CHR(1) +'VERSION' + CHR(1))) then
//received a CTCP version
form1.TcpClient.Sendln('NOTICE ' + user + ' :'+ CHR($01) + 'VERSION dCGbot bèta ' + CHR($01))
else
if inchannel = false then
begin
randomize;
//number := 7;//disable
number := random(6);
// put strings in a file ?
if ( number = 0 ) then saypriv('I am '+ form1.Nick.Text, user);
if ( number = 1 ) then saypriv(user, user);
if ( number = 2 ) then saypriv('You must be bored', user);
if ( number = 3 ) then saypriv('www.deGekkenClub.tk', user);
if ( number = 4 ) then saypriv('Wat moet je ? ', user);
if ( number = 5 ) then saypriv('I am only a bot....', user);
end;

// example how to use the new contains function
if contains(line,'gek') and (not (user = lastjoined)) then
begin
action('is gek ');
lastjoined := user;    //reuse,flood protect
end;

// blaat
if ( command = '!time') then kicktime := true;
if ( command ='!notime') then kicktime:=false;
if ( kicktime and (AnsiLowerCase(user) = 'nuky') and (contains(line,'time')) ) then kick('nuky');


//if contains(line,form1.Nick.text) then say('Typ !help '+ form1.Nick.text);
// line is the full line,
//command is the first word,
//data is the rest

if command = '!music' then
  begin
  //say ( 'DEBUG : MUSIC' );
  musicplaying;
  end;


if command = '!kill' then action('kills '+data);
if command = '!dice' then dice;
//if command = '!test' then announce('blah blah blah blah');
//if command = '!test2'then action('blah blah blah');


if (inchannel = true ) and ( command = '!info' ){and  (AnsiLowerCase(data) = AnsiLowerCase(form1.Nick.text)) }then
begin
announce('I am '+ form1.Nick.Text);
announce('I am running dGCbot bèta');
announce('My Source Code is avaiable at sourceforge');
announce('It is under the zlib licence');
announce('Check http://www.deGekkenClub.tk for more info');
end;

if ( command = '!help' )then
begin

// announce
announce(' ');
announce(' Current supported user commandos are:');
announce('   !info    <botnick>     !help    <botnick>');
announce('   !kill    <username>    !dice');
announce('   !music                 !porn     ');
announce(' ');
announce(' Current supported admin commandos are:');
announce('   !op      <username>    !deop    <username>');
announce('   !hop     <username>    !dehop   <username>');
announce('   !voice   <username>    !devoice <username>');
announce('   !ban     <username>    !unban   <username>');
announce('   !nick    <newbotnick>  !join    <channel>');
announce(' ');
end;

if ( command = '!porn' ) then

begin
spammer := 0;
repeat
saypriv ( 'You want porn ? now you will be SPAMMED',user);
spammer := spammer + 1;
until (spammer = 25);
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
if data=user then say ('Do you really want to kick yourself?')
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


procedure readdata(data: string);
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
form1.status.Caption:='dGCbot Ready...';
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

end.
