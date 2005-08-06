unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Sockets;

    procedure readdata(data: string);
    procedure Say(msg: string);
    procedure Announce(msg: string);
    procedure Action(msg: string);
    procedure dosomething(user, data: string; inchannel : boolean);

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
    RadioButton1: TRadioButton;
    Timer1: TTimer;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure pingTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
  receivednick : string  ;
  receivedchan : string  ;


implementation

{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
begin
button1.Enabled := false;
tcpclient.RemoteHost := server.Text;
tcpclient.RemotePort := port.Text;
if tcpclient.Connect then
tcpclient.Sendln('USER Host Server * : dGC BOT');
tcpclient.Sendln('NICK '+ nick.Text);
tcpclient.Sendln('JOIN '+ channel.Text);
treceive.Create(false);
ping.Enabled := true;

end;

procedure dosomething(user, data: string; inchannel : boolean);
begin
if inchannel = false then
begin
say(user + ' is talking to the bot in private ');
end;

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
namelen : integer;
counter2: integer;
begin

counter := 0;
counter2 := 0;


if NOT (data = '') then // check if there is data
begin
//form1.Label4.Caption := '' ;
counter := counter + 1;
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

if target = (form1.channel.Text + ' ') then
// message in the channel
begin
counter := counter + 1;
temp := data[counter];
// ignore the ':' ?
repeat
counter := counter + 1;
temp := data[counter];
message := message + temp;
until temp = '';    // end of data
form1.Label3.Caption := message; // debug the command

dosomething (username, message, true);

// and now comes the action
// write some stuff here
// or better, put it
// in a new procedure




end; // end of channel message

if target = (form1.Nick.Text + ' ') then
// private message
begin
counter := counter + 1;
temp := data[counter];
// ignore the ':' ?
repeat
counter := counter + 1;
temp := data[counter];
message := message + temp;
until temp = '';    // end of data
form1.Label3.Caption := message; // debug the command

dosomething (username, message, false);
// and now comes the action
// write some stuff here
// or better, put it
// in a new procedure



end; // end of private message

end; //end of PRIVMSG

end; //enf of user message , could now add the PONG command
end; //end of valid data
end;



procedure Say(msg: string);
begin

form1.TcpClient.Sendln('PRIVMSG ' + form1.channel.Text + ' '+ msg);
end;

procedure Announce(msg: string);
begin

end;

procedure Action(msg: string);
begin

end;




procedure TReceive.Execute;
begin
repeat
if  form1.TcpClient.WaitForData() then
begin
receiveddata := form1.tcpclient.Receiveln();
form1.memo1.Text := form1.memo1.Text  + receiveddata  ;
sleep (10);
end;

 readdata(receiveddata);
// and now read the received data
 receiveddata :='';
// and get rid of it

until (form1.TcpClient.Connected = false);

end;





procedure TForm1.pingTimer(Sender: TObject);
begin
tcpclient.Sendln('PING : TEST')  ;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
tcpclient.Disconnect;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
say('test');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
tcpclient.Disconnect;
end;

end.
