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

unit system_code;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Sockets, ExtCtrls, ShellAPI, strings;

type
    TForm2 = class(TForm)
        Updater: TTimer;
        TimeoutTimer: TTimer;
        TcpClient_Update: TTcpClient;
        TcpClient: TTcpClient;
        ping: TTimer;
        timer_doupgrade: TTimer;
        procedure reconnectTimer(Sender: TObject);
        procedure reconnect2Timer(Sender: TObject);
        procedure UpdaterTimer(Sender: TObject);
        procedure TimeoutTimerTimer(Sender: TObject);
        procedure pingTimer(Sender: TObject);
        procedure timer_doupgradeTimer(Sender: TObject);
    private
    { Private declarations }
    public
    { Public declarations }
    end;

var
    Form2: TForm2;

implementation

uses main;

{$R *.dfm}

procedure TForm2.reconnectTimer(Sender: TObject);
    begin
        write (logfile, 'Reconnecting.....' + chr(13));
        form1.status.Caption:='Reconnecting.....';form1.status.Repaint;
//stop.Click;
        tcpclient.Disconnect;
        form1.go.click;
//reconnect.Enabled:=false;

    end;


procedure TForm2.reconnect2Timer(Sender: TObject);
    begin
//reconnect.Enabled:=false;
        write (logfile, 'Reconnecting.....' + chr(13));
        form1.status.Caption:='Reconnecting.....';form1.status.Repaint;
//stop.Click;
        tcpclient.Disconnect;
        form1.go.click;
//reconnect2.Enabled:=false;

    end;

procedure TForm2.UpdaterTimer(Sender: TObject);
    begin
        If Tcpclient.Connected then
            begin uptime := uptime + 1 end ;
        if form1.longwait.Checked then
            begin timeouttimer.Interval:=3000000000; end
        else
            begin timeouttimer.Interval:=10000 end;
// Update current time and date.





        if timeout then
            begin
            timeout :=false;
            write (logfile,'Login Timeout' + chr(13) );
  //stop.Click;
            tcpclient.Disconnect;
            form1.status.Caption := 'Connected, but no answer';
            form1.status.Repaint;
            end;

        if tcpclient.Connected = false then
            begin form1.panel1.Color := clred end
        else
            if receivingdata = true then
                begin form1.panel1.Color := clgreen end
            else
                if receivingdata = false then
                    begin form1.panel1.Color := clgray end;

//if ( irc_Connected = false ) AND (form1.ping.Enabled = true) then  form1.Status.Caption := 'Server dropped connection';form1.status.Repaint;
// *** ping online ?
    end;

procedure TForm2.TimeoutTimerTimer(Sender: TObject);
    begin
        timeout := true;

    end;

procedure TForm2.pingTimer(Sender: TObject);

    var
        tempstring : string;
    begin
//write (logfile,'PING ');
//write (logfile,pingcount);
//write (logfile, chr(13));
        if NOT (pingcount = pongcount) then
// PING TIMEOUT //
            begin
            bot_status:= 'PING TIMEOUT : Reconnect';
            tcpclient.Sendln('PART '+ irc_channel +' Ping Timeout, Disconnecting...');
            tcpclient.Disconnect;
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
        tcpclient.Sendln('PING : '+tempstring)  ;

    end;

procedure TForm2.timer_doupgradeTimer(Sender: TObject);
    begin
        timer_doupgrade.Enabled:=false;
        ShellExecute(Handle, 'open', PChar('Updater.exe'), nil, nil, SW_SHOWNORMAL);
        form1.close;
    end;

end.
