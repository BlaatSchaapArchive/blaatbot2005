unit init;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Sockets, ExtCtrls;

type
    TForm2 = class(TForm)
        wait2: TTimer;
        wait1: TTimer;
        Updater: TTimer;
        Timer_doupgrade: TTimer;
        TimeoutTimer: TTimer;
        TcpClient_Update: TTcpClient;
        TcpClient: TTcpClient;
        ShoutCastInfo: TTcpClient;
        reconnect2: TTimer;
        reconnect: TTimer;
        ping: TTimer;
        procedure reconnectTimer(Sender: TObject);
        procedure wait1Timer(Sender: TObject);
        procedure wait2Timer(Sender: TObject);
        procedure reconnect2Timer(Sender: TObject);
        procedure UpdaterTimer(Sender: TObject);
        procedure TimeoutTimerTimer(Sender: TObject);
        procedure pingTimer(Sender: TObject);
        procedure Timer_doupgradeTimer(Sender: TObject);
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
        status.Caption:='Reconnecting.....';status.Repaint;
//stop.Click;
        tcpclient.Disconnect;
        go.click;
        reconnect.Enabled:=false;

    end;

procedure TForm2.wait1Timer(Sender: TObject);
    begin
        if wait2.Enabled = true then
            begin
// this may not happen
            status.Caption := 'Reconnect timer bug';status.Repaint;
            write(logfile,'Reconnect timer bug : 1 nog actief' + chr(13));
            end;
    end;

procedure TForm2.wait2Timer(Sender: TObject);
    begin
        if wait1.Enabled = true then
            begin
// this may not happen
            status.Caption := 'Reconnect timer bug';status.Repaint;
            write(logfile,'Reconnect timer bug : 1 nog actief' + chr(13));
            end;
    end;

procedure TForm2.reconnect2Timer(Sender: TObject);
    begin
        reconnect.Enabled:=false;
        write (logfile, 'Reconnecting.....' + chr(13));
        status.Caption:='Reconnecting.....';status.Repaint;
//stop.Click;
        tcpclient.Disconnect;
        go.click;
        reconnect2.Enabled:=false;

    end;

procedure TForm2.UpdaterTimer(Sender: TObject);
    begin
        If Tcpclient.Connected then
            begin uptime := uptime + 1 end ;
        if longwait.Checked then
            begin timeouttimer.Interval:=3000000000; end
        else
            begin timeouttimer.Interval:=10000 end;
// Update current time and date.


//time_convert  := time;
        time_now :=TimeToStr(time);
//time_convert  := date;
        date_now := DateToStr(date);

        if time_now = '03:33:33' then
            begin CheckForUpdate() end;



        if timeout then
            begin
            timeout :=false;
            write (logfile,'Login Timeout' + chr(13) );
  //stop.Click;
            tcpclient.Disconnect;
            status.Caption := 'Connected, but no answer';
            status.Repaint;
            if  (not wait2.Enabled ) or
                (not reconnect.Enabled ) or
                (not reconnect2.enabled) then
                begin wait1.enabled := true end
            else
                if  (not wait1.Enabled ) or
                    (not reconnect.Enabled ) or
                    (not reconnect2.enabled) then
                    begin wait2.enabled := true end
                else
                    begin status.Caption := 'timeout / reconnect bug' end;status.Repaint;

            end;

        if form1.tcpclient.Connected = false then
            begin panel1.Color := clred end
        else
            if receivingdata = true then
                begin panel1.Color := clgreen end
            else
                if receivingdata = false then
                    begin panel1.Color := clgray end;
        if ( form1.TcpClient.Connected = false ) AND (form1.ping.Enabled = true) then
            begin form1.Status.Caption := 'Server dropped connection' end;form1.status.Repaint;

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
            status.Caption := 'PING TIMEOUT : Reconnect';
            status.Repaint;
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

procedure TForm2.Timer_doupgradeTimer(Sender: TObject);
    begin
        timer_doupgrade.Enabled:=false;
        ShellExecute(Handle, 'open', PChar('Updater.exe'), nil, nil, SW_SHOWNORMAL);
        form1.close;

    end;

end.
