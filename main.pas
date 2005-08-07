unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Sockets;

    procedure dice();
//    procedure contains(data,what: string);
    function contains (data,what: string) : boolean;

    procedure readdata(data: string);
    procedure Say(msg: string);
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

  receiveddata : string  ;
  loginsleep : integer;

// converting procedures into functions

  receivednick : string  ;
  receivedchan : string  ;
  receivingdata : boolean;
  convert       : variant; 


implementation

{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
var
loginnow : boolean;
loginsleep : integer;
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
tcpclient.Sendln('USER dcgbot dgchost '+ server.Text + ' :dGC BOT');
//sniffed
//USER andre_winxp 786at1600 irc.chat4all.org :Andre van Schoubroeck

server.Enabled := false;
port.Enabled := false;
nick.Enabled := false;
channel.Enabled := false;

// if server.Text = 'irc.chat4all.org' then sleep (10000);
// found the code to detect when the server is ready
// moving login code to readdata

ping.Enabled := true;

end else label3.caption :='server down';
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
temp := (temp + ' &  ');
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

      //  sleep (1000); // to see what it does
until (counter3 = datalenght - wordlenght) or (tempstring = what);
//if (tempstring = what) then temp_contains := true else temp_contains := false;
if (tempstring = what) then Result := true else Result := false;


end; // end of check for datalenght > whatlenght
end; // end check for valid data


end;

procedure dosomething(user, line, command, data: string; inchannel : boolean);
var
number     : integer;                  
begin
// say in private to rejoin the channel, ( when it is kicked ? )
if (inchannel = false) and contains(line,'rejoin') then form1.TcpClient.Sendln('JOIN '+ form1.channel.Text);

if (inchannel = false) and contains(line,'bot') then say('I am  '+form1.nick.Text);

if (inchannel = false) and (command = 'channel') then
begin
form1.TcpClient.Sendln('PART '+ form1.channel.Text);
form1.channel.Text := data;
form1.TcpClient.Sendln('JOIN '+ form1.channel.Text);
end;

if (inchannel = false) and (line = ( CHR(1) +'VERSION' + CHR(1))) then
//received a CTCP version
form1.TcpClient.Sendln('NOTICE ' + user + ' :'+ CHR($01) + 'VERSION dCGbot bèta ' + CHR($01))
else
if inchannel = false then
begin
randomize;
number := random(6);
if ( number = 0 ) then saypriv('I am '+ form1.Nick.Text, user);
if ( number = 1 ) then saypriv(user, user);
if ( number = 2 ) then saypriv('You must be bored', user);
if ( number = 3 ) then saypriv('www.deGekkenClub.tk', user);
if ( number = 4 ) then saypriv('Wat moet je ? ', user);
if ( number = 5 ) then saypriv('I am only a bot....', user);
end;

// example how to use the new contains function
if contains(line,'gek') then action('is gek ');
if contains(line,'bot') then say('I am a bot');
// line is the full line,
//command is the first word,
//data is the rest

if command = '!kill' then action('kills '+data);
if command = '!dice' then dice;
if command = '!test' then announce('blah blah blah blah');
if command = '!test2'then action('blah blah blah');



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

if NOT (data = '') then // check if there is data
begin
//form1.Label4.Caption := '' ;
counter := counter + 1; // ignoring the first letter :
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


if command = 'PRIVMSG ' then
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

if AnsiLowerCase(target) = (form1.nick.Text + ' ') then
//message in private
begin
ok := true;
inchannel := false;
end;

if ok = true then
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


// end;// end of separating commands



dosomething (username, message,mCommand,mData, inchannel);

// and now comes the action
// write some stuff here
// or better, put it
// in a new procedure




end; // end of channel message


end; //end of PRIVMSG


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


if (data[1] = 'P') and (usertemp ='ING ') then // we removed the first character
  begin
pinger :='';
counter :=5;
  repeat
counter := counter + 1;
temp := data[counter];
pinger := pinger + temp ;
until temp = '';
form1.TcpClient.Sendln('PONG '+ pinger) ;


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

sleep (25); // sleep for 100 ms to keep the cpu usage low
if  form1.TcpClient.WaitForData() then
begin
receivingdata := true;
receiveddata := form1.tcpclient.Receiveln();
form1.memo1.Text := form1.memo1.Text  + receiveddata  ;
 readdata(receiveddata);
// and now read the received data
 receiveddata :='';
// and get rid of it

end else receivingdata := false;;

until (form1.TcpClient.Connected = false);


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
if receivingdata = true then panel1.Color := clgreen;
if receivingdata = false then panel1.Color := clgray;
end;

procedure TForm1.joinerTimer(Sender: TObject);
begin
tcpclient.Sendln('JOIN '+ channel.Text)  ;
end;

end.
