unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Sockets;

    procedure dice();
//    procedure contains(data,what: string);
    function contains (data,what: string) : boolean;
    function isadmin  (name: string) : boolean;

    procedure readdata(data: string);
    procedure Say(msg: string);
    procedure Kick(who: string);
    procedure Mode (who: string; mode : char; enable : boolean);

    procedure SayPriv(msg,user: string);
    procedure Announce(msg: string);
    procedure Action(msg: string);
procedure dosomething(user, line, command, data: string; inchannel : boolean);

type
  TForm1 = class(TForm)
    TcpClient: TTcpClient;
    ping: TTimer;
    Button1: TButton;
    server: TEdit;
    channel: TEdit;
    port: TEdit;
    Memo1: TMemo;
    Nick: TEdit;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    Timer1: TTimer;
    Label8: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure pingTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure joinerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);


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
  adminlist:tmemo;
  receiveddata : string  ;
//  loginsleep : integer;

// converting procedures into functions

  receivednick : string  ;
  receivedchan : string  ;
  receivingdata : boolean;
  convert       : variant;

  Adminsfile    : TextFile;
  AdminCounter  : Integer;
  Admins : array [1..10]of String; // try it
implementation

{$R *.dfm}

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


procedure TForm1.Button1Click(Sender: TObject);

begin
label3.Caption:='connecting....';
button1.Enabled := false;
Button2.Enabled := true;
tcpclient.RemoteHost := server.Text;
tcpclient.RemotePort := port.Text;
if tcpclient.Connect then
begin
treceive.Create(false);
tcpclient.Sendln('NICK '+ nick.Text);
tcpclient.Sendln('USER dgcbot dgchost '+ server.Text + ' :dGCbot www.deGekkenClub.tk');
//sniffed
//USER andre_winxp 786at1600 irc.chat4all.org :Andre van Schoubroeck

server.Enabled := false;
port.Enabled := false;
nick.Enabled := false;
channel.Enabled := false;

// found the code to detect when the server is ready
// moving login code to readdata



end else label3.caption :='server down';
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
temp       : integer;
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
<<<<<<< main.pas
//IsAdmin    : boolean;
//Counter    : integer;
=======
IsAdmin    : boolean;
Counter    : integer;

>>>>>>> 1.26
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
number := 7;//disable
//number := random(6);
if ( number = 0 ) then saypriv('I am '+ form1.Nick.Text, user);
if ( number = 1 ) then saypriv(user, user);
if ( number = 2 ) then saypriv('You must be bored', user);
if ( number = 3 ) then saypriv('www.deGekkenClub.tk', user);
if ( number = 4 ) then saypriv('Wat moet je ? ', user);
if ( number = 5 ) then saypriv('I am only a bot....', user);
end;

// example how to use the new contains function
if contains(line,'gek') then action('is gek ');
//if contains(line,form1.Nick.text) then say('Typ !help '+ form1.Nick.text);
// line is the full line,
//command is the first word,
//data is the rest


if command = '!kill' then action('kills '+data);
if command = '!dice' then dice;
if command = '!test' then announce('blah blah blah blah');
if command = '!test2'then action('blah blah blah');


if (inchannel = true ) and ( command = '!info' )and  (AnsiLowerCase(data) = AnsiLowerCase(form1.Nick.text)) then
begin
say('I am '+ form1.Nick.Text);
say('I am running dGCbot');
say('My Source Code is avaiable');
say('Check http://www.deGekkenClub.tk for more info');
end;

if (inchannel = true ) and ( command = '!help' )and  (AnsiLowerCase(data) = AnsiLowerCase(form1.Nick.text)) then
begin

say(' ');
say(' Current supported user commandos are:');
say('   !info    <botnick>     !help    <botnick>');
say('   !kill    <username>    !dice');
say(' ');
say(' Current supported admin commandos are:');
say('   !op      <username>    !deop    <username>');
say('   !hop     <username>    !dehop   <username>');
say('   !voice   <username>    !devoice <username>');
say('   !ban     <username>    !unban   <username>');
say('   !nick    <newbotnick>  !join    <channel>');
say(' ');
end;

//administrative stuff , needs to add protection
//else everyone can start banning

//  this is the acces violating code

//    try to implent admins in a file
{    AssignFile(Adminsfile, extractfilepath(application.exename)+'\admins');
    Reset(Adminsfile);
//
    while not eof(adminsfile) do
    begin
    admincounter := admincounter + 1;
    readln ( adminsfile , admins[admincounter] )
    end;
    Close(Adminsfile);
    repeat
    counter := counter + 1 ;
    if (AnsiLowerCase(user) = admins[counter]) then IsAdmin := true;
    until counter >= admincounter;
    form1.Caption:=admins[1]+':'+admins[2]+':'+admins[3];
//if isadmin then say('woot.. teh great admin..');
    counter:=0;
    admincounter:=0; }
//egmos invisible memo version
adminlist.Visible:=false;
adminlist.Lines.LoadFromFile(extractfilepath(application.exename)+'\admins');
counter:=0;
admincounter:=0;
for counter:=0 to adminlist.Lines.Count do
begin
admins[counter+1]:=adminlist.Lines.Strings[counter];
if (AnsiLowerCase(user) = admins[counter+1]) then IsAdmin := true;
end;
 admincounter:=0;
counter:=0;





// temporairy security code
<<<<<<< main.pas
//if (AnsiLowerCase(user) = 'andre') or (AnsiLowerCase(user) = 'a-v-s')or (AnsiLowerCase(user) = 'nuky') then
if isadmin(user) then
=======
//if (AnsiLowerCase(user) = 'andre') or (AnsiLowerCase(user) = 'a-v-s')or (AnsiLowerCase(user) = 'nuky') then

>>>>>>> 1.26

//begin
// command to the bots
if command = '!nick' then begin form1.Nick.text:=data; form1.tcpclient.Sendln('NICK '+form1.nick.text);end;

if command = '!join' then
begin
form1.TcpClient.Sendln('PART '+ form1.channel.Text);
form1.channel.Text := data;
form1.TcpClient.Sendln('JOIN '+ form1.channel.Text);
end;
// commands in the channel
if NOT(contains(data,form1.Nick.Text)) then
begin
if command = '!kick'     then kick(data);
if command = '!ban'      then mode(data,'b',true);
if command = '!unban'    then mode(data,'b',false);
if command = '!op'       then mode(data,'o',true);
if command = '!deop'     then mode(data,'o',false);
if command = '!hop'      then mode(data,'h',true);
if command = '!dehop'    then mode(data,'h',false);
if command = '!voice'    then mode(data,'v',true);
if command = '!devoice'  then mode(data,'v',false);
end; // don't do that to itself
//end;

end; // end of *serv detection
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

// not sure what this does, but that is how xchat reacted
if  (contains(data,'MODE')) and (contains(data,'+i'))  then form1.TcpClient.Sendln('USERHOST '+form1.Nick.Text);


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

form1.Label1.Caption := command; // debug command


// try moving it if command = 'PRIVMSG ' then
begin
repeat
counter := counter + 1;
temp := data[counter];
target := target + temp;
until temp = ' ';

form1.Label2.Caption := target; // debug the target

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
form1.Label3.Caption := message; // debug the command
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
if (command = 'JOIN ' )and (not (username = form1.Nick.Text)) then
begin
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
form1.Label8.Caption := target;


if command='376 ' then
// ready to log in
begin

form1.tcpclient.Sendln('JOIN '+ form1.channel.Text);
form1.Label3.Caption := 'joining channel';
form1.ping.Enabled := true;
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
//form1.Label3.Caption := 'Server dropped';


end;





procedure TForm1.pingTimer(Sender: TObject);
begin
tcpclient.Sendln('PING : TEST')  ;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
server.Enabled := true;
port.Enabled := true;
nick.Enabled := true;
channel.Enabled := true;
label3.Caption :='diconnected';
Button1.Enabled := true;
Button2.Enabled := false;
tcpclient.Disconnect;
end;


procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
tcpclient.Disconnect;
end;



procedure TForm1.Button4Click(Sender: TObject);
begin
dice;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
tcpclient.Sendln('JOIN '+ channel.Text);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
if form1.tcpclient.Connected = false then panel1.Color := clred else
if receivingdata = true then panel1.Color := clgreen else
if receivingdata = false then panel1.Color := clgray;
end;

procedure TForm1.joinerTimer(Sender: TObject);
begin
tcpclient.Sendln('JOIN '+ channel.Text)  ;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
adminlist:=tmemo.Create(self);
adminlist.Parent:=self;
adminlist.visible:=falsE;
end;

end.
