unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Sockets;

type
  TForm1 = class(TForm)
    TcpClient: TTcpClient;
    ping: TTimer;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Memo1: TMemo;
    test: TTimer;
    procedure Button1Click(Sender: TObject);

    procedure testTimer(Sender: TObject);
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

{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
begin
tcpclient.RemoteHost := edit1.Text;
tcpclient.RemotePort := edit3.Text;
if tcpclient.Connect then
tcpclient.Sendln('USER Host Server * :Name');
tcpclient.Sendln('NICK TEST');
tcpclient.Sendln('JOIN '+ edit2.Text);
//tcpclient.Sendln('PRIVMSG '+edit2.Text+' test');
test.Enabled := true;

end;

procedure TReceive.Execute;
begin
if form1.TcpClient.Connected and form1.TcpClient.WaitForData() then
form1.memo1.Text := form1.memo1.Text  + form1.tcpclient.Receiveln()  ;

end;



procedure TForm1.testTimer(Sender: TObject);
begin
treceive.Create(false);
end;

end.
