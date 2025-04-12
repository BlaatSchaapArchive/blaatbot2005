unit irc_protocol2;

interface

uses Dialogs, SysUtils, general_codes, strings,bot_commands,
    network_stuff, irc_protocol, system_code;
procedure ReadData(data: string);
implementation

// begin of irc read data

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
            if NOT (data[1] = 'P') then
                begin counter := counter + 1 end; // ignoring the first letter :
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
                    until (temp = ' ') or (temp='');


//     showmessage(target);
//form1.Label2.Caption := target; // debug the target

                    if AnsiLowerCase(target) = AnsiLowerCase(irc_channel + ' ') then
// message in the channel
                        begin
                        ok := true;
                        inchannel := true;
                        end;

                    if AnsiLowerCase(target) = AnsiLowerCase((irc_nick + ' ')) then
//message in private
                        begin
                        ok := true;
                        inchannel := false;
                        end;

                    if ok = true then
                        begin

                        if command = 'PRIVMSG ' then
                            begin counter := counter + 1 end;   // ignore the ':'
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
                        if not (mcount = 1) then
                            begin
                            if (temp = ' ') then
                                begin


                                repeat
                                    sCount := sCount + 1;
                                    temp := mCommandTemp[sCount];
                                    mCommand := mCommand + temp;
                                until scount = mcount - 1;
 //remove the ' '


                                if not (mcount = dcount) then
                                    begin //no space at the end

                                    repeat
                                        mCount := mCount + 1;
                                        temp := Message[mCount];
                                        mData := mData + temp;
                                    until mcount = dcount; 
                                    end; // read the data


                                end
                            else
                                begin mCommand := mCommandTemp end ;
                            end; // begins with a space

// mot deze weg
                        end;// end of separating commands


// i think this is where the separation should be
                    if command = 'PRIVMSG ' then
                        begin

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
                    begin if mCommand = irc_nick  then
                        begin
                        irc_Sendln('JOIN '+ irc_channel);
                        say('Ouch .... '+username+', stop kicking me, it hurts.' );
                        end end;

                if (command = 'JOIN ' ) then
                    begin
                    if (AnsiLowercase ( username ) = 'zijjia' ) then
                        begin
                        say ('Welcome by bot friend');
                        action('hugs  '+ username ) end
                    else

                        if (AnsiLowercase ( username ) = 'bludwyn' ) then
                            begin say('WeeeMooo') end;
  // greet the bitch


                    if (not (username = irc_nick)) and (not (username = lastjoined)) then
                        begin
                        lastjoined := username;
//say('Heey, ' +  username + ', welcome to ' + irc_channel);
                        announcepriv('Heey, ' +  username + ', welcome to ' + irc_channel,username);

                        end;
                    mode (username,'v',true);
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

                end
            else
                begin //end of user message , could now add the PONG command


                repeat
                    counter := counter + 1;
                    temp := data[counter];
                    command := command + temp;
                until (temp = ' ') or (temp = ''); // acces violation fix ?



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
//    mcount := mcount - 1;
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
                    irc_Sendln('PONG '+ pinger) ;

//wtf ? remove code adds some chr($0) ?!?!?!

                    end
                else
                    begin






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
                    bot_status:='BlaatSchaap Bot Ready...';
// update status code
//form1.status.Repaint;

                    irc_Sendln('JOIN '+ irc_channel);
                    form2.ping.Enabled := true;
                    mode('','B',true);// some servers support mode B for BOTS
                    if irc_nickserv then
                        begin saypriv('identify '+irc_nickpass,'NickServ') end;
//ok ... move that shit
// add check if password is accepted ?
                    end;



                end; // end of server message
            end; //end of valid data

    end;



// end of irc read data

end.
