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
    Dialogs, StdCtrls, ExtCtrls, Sockets, ShellAPI, IRCBot_CompileTime, OSinfo,
    general_codes,network_stuff,irc_protocol, irc_protocol2, strings, bot_commands;

procedure RestoreSettings();
procedure SaveSettings();
procedure AddStation(name,server,port:string);
procedure RemoveStation(name:string);
procedure ListStations();

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
                if not (temp = ',') then
                    begin station := station + temp end
            until temp = ',';
      //say ( 'DEBUG : STATION NAME IS '+ station );

            server :='';
            repeat
                read (musicfile, temp);
                if not (temp = ',') then
                    begin server := server + temp end
            until temp = ',';
      //say ( 'DEBUG : SERVER IS '+ server );
            port :='';
            repeat
                read (musicfile, temp);
                if not (temp = ',') then
                    begin port := port + temp end
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
        if (not eof(settingfile)) then
            begin

            repeat
                read (settingfile, temp);
                if not (temp = ',') then
                    begin data := data + temp end
            until temp = ',';
            form1.server.text := data;
            data :='';
            repeat
                read (settingfile, temp);
                if not (temp = ',') then
                    begin data := data + temp end
            until temp = ',';
            form1.port.text := data ;
            data :='';
            repeat
                read (settingfile, temp);
                if not (temp = ',') then
                    begin data := data + temp end
            until temp = ',';
            form1.channel.text := data;
            data :='';
            repeat
                read (settingfile, temp);
                if not (temp = ',') then
                    begin data := data + temp end
            until temp = ',';
            form1.nick.text := data;
            data :='';

            repeat
                read (settingfile, temp);
                if not (temp = ',') then
                    begin data := data + temp end
            until temp = ',';
            convert := data;
            form1.ChanServID.checked := convert;
            data :='';

            repeat
                read (settingfile, temp);
                if not (temp = ',') then
                    begin data := data + temp end
            until temp = ',';
            form1.ChanPass.text := data;
            data :='';

            repeat
                read (settingfile, temp);
                if not (temp = ',') then
                    begin data := data + temp end
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


procedure TForm1.GoClick(Sender: TObject);

    begin
        uptime :=0;
        irc_live := true;
        writeln (quotefile, ' ');
        writeln (quotefile, 'Logging starts at ' + time_now + ' '+ date_now);
        writeln (quotefile, 'Joining '+ irc_channel);
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

            //sniffed
            //USER andre_winxp 786at1600 irc.chat4all.org :Andre van Schoubroeck
            irc_Sendln('USER blaatbot2005 localhost '+ server.Text + ' :' + bot_version);

            server.Enabled := false;
            port.Enabled := false;
            nick.Enabled := false;
            channel.Enabled := false;
            ChanservID.Enabled:=false;
            ChanPass.Enabled := false;
            bot_status:='Waiting for server...';
            end
        else
            begin
            bot_status:='Server did not respond';
            status.Repaint;
            AutoConnect_Timer.Interval:=10000;
            if irc_live then
                begin AutoConnect_Timer.Enabled:=true end;

            end;
    end;

procedure TReceive.Execute;
    begin
        repeat

            sleep (1); // sleep for 1 ms to keep the cpu usage low
            if  form2.TcpClient.WaitForData() then
                begin
                receivingdata := true;
                receiveddata := irc_Receiveln();
                readdata(receiveddata);
                receiveddata :='';
                end
            else
                begin receivingdata := false end;;

        until (irc_Connected = false);
        form1.Panel1.Color := clred;
        uptime :=0;
        irc_Disconnect;

        pingcount:=0; // fix for the ping timeout bug
        pongcount:=0; // on lost connection

        form1.AutoConnect_Timer.Interval:=10000;
        form1.AutoConnect_Timer.Enabled:=true;

    end;





procedure TForm1.pingTimer(Sender: TObject);
    var
        tempstring : string;
    begin
        if NOT (pingcount = pongcount) then
            begin
            status.Caption := 'PING TIMEOUT : Reconnect';
            status.Repaint;
            write (logfile,'PING TIMEOUT: PING ');
            write (logfile,pingcount);
            write (logfile,'  PONG ');
            write (logfile,pongcount);
            write (logfile, chr(13));
            end;

        pingcount := pingcount + 1;
        convert := pingcount;
        tempstring := convert;
        irc_Sendln('PING : '+tempstring)  ;
    end;

procedure TForm1.StopClick(Sender: TObject);
    begin
        AutoConnect_Timer.Enabled:=false;
        irc_Sendln('QUIT '+ irc_channel +' BlaatBot Disconnecting');
        irc_live:=false;
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

    {
procedure TForm1.Button4Click(Sender: TObject);
    begin
        dice;
    end;

procedure TForm1.Button3Click(Sender: TObject);
    begin
        restoresettings();
    end;
     }

procedure TForm1.status_uodater(Sender: TObject);
    begin
        If irc_Connected then
            begin uptime := uptime + 1 end ;
        if form1.longwait.Checked then
            begin form2.timeouttimer.Interval:=3000000000; end
        else
            begin form2.timeouttimer.Interval:=10000 end;
        // Update current time and date.

        time_now :=TimeToStr(time);
        date_now := DateToStr(date);

        if time_now = '03:33:33' then
            begin CheckForUpdate() end;

        if timeout then
            begin
            timeout :=false;
            write (logfile,'Login Timeout' + chr(13) );
            irc_Disconnect;
            status.Caption := 'Connected, but no answer';
            status.Repaint;
            end;

        if irc_Connected = false then
            begin panel1.Color := clred end
        else
            if receivingdata = true then
                begin panel1.Color := clgreen end
            else
                if receivingdata = false then
                    begin panel1.Color := clgray end;
        if ( irc_Connected = false ) AND (form2.ping.Enabled = true) then
            begin form1.Status.Caption := 'Server dropped connection' end;form1.status.Repaint;
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
        bot_version:='BlaatBot2005 (Compile Date ' + DateToStr(CompileTime)+' @ '+TimeToStr(CompileTime) +')';
        Form1.Caption:=bot_version;
        restoresettings();

        irc_channel:=channel.Text;
        irc_nick := nick.Text;
        irc_nickpass := chanpass.text;

        if ChanServID.Checked then
            begin ChanPass.Enabled := true end
        else
            begin ChanPass.Enabled := false end;
        irc_live:=AutoConnect.Checked;
        AutoConnect_Timer.Enabled:=AutoConnect.Checked;
    end;

procedure TForm1.serverChange(Sender: TObject);
    begin
        if ready then
            begin savesettings() end;
    end;

procedure TForm1.portChange(Sender: TObject);
    begin
        if ready then
            begin savesettings() end
    end;

procedure TForm1.channelChange(Sender: TObject);
    begin
        if ready then
            begin savesettings() end
    end;

procedure TForm1.NickChange(Sender: TObject);
    begin
        if ready then
            begin savesettings() end
    end;

procedure TForm1.ChanPassChange(Sender: TObject);
    begin
        if ready then
            begin savesettings() end
    end;

procedure TForm1.ChanServIDClick(Sender: TObject);
    begin
        if ready then
            begin savesettings() end;
        if ChanServID.Checked then
            begin ChanPass.Enabled := true end
        else
            begin ChanPass.Enabled := false end;
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

            repeat
                count := count + 1;
                temp := EditCommands.Text[count];
                if NOT((temp = ' ') or (temp = '')) then
                    begin command := command + temp end;
            until (temp = '' )or (temp = ' ');
            if not (temp= '') then
                begin repeat
                    count := count + 1;
                    temp := EditCommands.Text[count];
                    if not (temp = '') then
                        begin data := data + temp end
                until temp = '' end;
            DoSomething('áðµíñ',EditCommands.Text,command,data,false);
            Key := #0;
            EditCommands.Clear;
            end;
    end;

procedure TForm1.RunTempBatClick(Sender: TObject);
    begin
        ShellExecute   (   handle,'open',  'temp.bat' , nil, nil, SW_HIDE);
    end;

procedure TForm1.Time_TimerTimer(Sender: TObject);
    begin
        silence_timer:=silence_timer+1;
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
        time_now :=TimeToStr(time);
        date_now := DateToStr(date);

        if irc_connected then
            begin if receivingdata then
                begin panel1.Color:=clgreen end
            else
                begin panel1.Color:=clgray end end
        else
            begin panel1.color:=clred end;


        if time_now = '03:33:33' then
            begin CheckForUpdate() end;
        if time_now = '11:11:11' then
            begin say('Lalalalalala') end; // do something ... add something crazy here
        if time_now = '06:06:06' then
            begin say('Muhahahahaha') end; // do something ... add something EVIL  here


        if silence_timer = 666 then
            begin    // sut that stupid bot
            silence_timer:=0;
            if SPAM then
                begin randomquote() end;
            end;
    end;

procedure TForm1.AutoConnect_TimerTimer(Sender: TObject);
    begin
        AutoConnect_Timer.Enabled:=false;
        if irc_live then
            begin go.Click end;
    end;

end.
