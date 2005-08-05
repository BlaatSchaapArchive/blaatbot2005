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
  private
    { Private declarations }
  public
    { Public declarations }
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
tcpclient.Sendln('PRIVMSG '+edit2.Text+' test');


end;

procedure TForm1.testTimer(Sender: TObject);
begin

memo1.Text := memo1.Text + tcpclient.Receiveln()   ;




end;

end.
