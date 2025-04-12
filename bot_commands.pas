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
unit bot_commands;

interface
uses SysUtils, irc_protocol, general_codes, strings, network_stuff,
    IRCbot_CompileTime, system_code;

procedure DoSomething(user, line, command, data: string; inchannel : boolean);
implementation
procedure DoSomething(user, line, command, data: string; inchannel : boolean);
    var
        number     : integer;
//IsAdmin    : boolean;
//Counter    : integer;
        quotes : textfile ; //does delphi allow the same file to be opened twice ?
        quoteline : string;
        quotecount : integer;

    begin
// try this to fix the find stops logging
// only temp solution, it can't stay this way
// ReQuote;
// not working....

        silence_timer:=0;

        if NOT(Contains(line,chr(1))) then
            begin writeln(quotefile, '['+ date_now + ' ' + time_now + '] <'+user + '>  ' + line) end
        else
            begin writeln(quotefile, '['+ date_now + ' ' + time_now + '] *'+user + '  ' + line) end;
// action, still strip the chr(1);




        if not (command='') then
//if (command[1]='!') then Form1.MemoOutput.Lines.Add(user + ' : ' + command + ' ' + data);
// logger

            begin if not (contains(user,'serv')) then
                begin
// to prevent reacting on  *serv
// say in private to rejoin the channel, ( when it is kicked ? )
//if (inchannel = false) and contains(line,'rejoin') then form1.TcpClient.Sendln('JOIN '+ form1.channel.Text);

//if (inchannel = false) and contains(line,form1.Nick.edit) then say('I am  '+form1.nick.Text);

                if (inchannel = false) and (line = ( CHR(1) +'VERSION' + CHR(1))) then
//received a CTCP version
                    begin irc_sendln('NOTICE ' + user + ' :'+ CHR($01) + 'VERSION '+ bot_version + CHR($01)) end
                else

                    if inchannel = false then
                        begin
                        randomize;
                        number := 7; //disable
//number := random(6);
// put strings in a file ?





                        if ( number = 0 ) then
                            begin saypriv('I am '+ irc_nick, user) end;
                        if ( number = 1 ) then
                            begin saypriv(user, user) end;
                        if ( number = 2 ) then
                            begin saypriv('You must be bored', user) end;
                        if ( number = 3 ) then
                            begin saypriv('blaatschaap.nukysrealm.net', user) end;
                        if ( number = 4 ) then
                            begin saypriv('Wat moet je ? ', user) end;
                        if ( number = 5 ) then
                            begin saypriv('I am only a bot....', user) end;
                        end;

// example how to use the new contains function
// it's annyoing
//if contains(line,'blaat') and (not (user = lastjoined)) then
//begin
//say('Inderdaad, blaat in het kwadraat!');
//lastjoined := user;    //reuse,flood protect
//end;


                if ( command = '!stat' ) then
                    begin GetStats() end;

                if (command = 'brb') or (command = 'bbl' ) then
                    begin say (orange + 'See you soon, '+ user) end;
                if (command = 'biw') or (command = 'back') then
                    begin say (orange + 'Welcome back, '+user) end;

                if ( command = '!convert' ) then
                    begin DoConvert(data) end;

                if (command = '!music') and (data ='') then
                    begin
  //say ( 'DEBUG : MUSIC' );
                    musicplaying;
                    end;

{
if ( command = '!music' ) and (ReadParams(data,0,false) ='add') then
  begin
  AddStation( ReadParams(data,1,false) ,  //name
              ReadParams(data,2,false) ,  //server
              ReadParams(data,3,false) ); //port
  end;

if ( command = '!music' ) and (ReadParams(data,0,false) ='remove') then
  begin
  RemoveStation( ReadParams(data,1,false) );  //name
  end;

if ( command = '!music' ) and (ReadParams(data,0,false) ='list') then
  begin
  ListStations();
  end;

}
                if command = '!find' then
                    begin
//flush(quotefile);
//close(quotefile);
                    ReQuote;
                    sleep(350); // give the batch file time to run
                    assign (quotes,'tempq');
                    reset ( quotes );
                    quotecount := 0;
                    while not eof(quotes) do
                        begin
                        readln ( quotes, quoteline );
     // say ( 'DEBUG: ' + quoteline);
                        if contains(quoteline,data) then
                            begin
                            quotecount := quotecount + 1;
                            if (quotecount < 6 ) then
                                begin say (quoteline) end;
                            end;
                        end;
                    close (quotes);  // Andre was stupid, forgot to close the fucking file !!
                    end;

                if command = '!kill' then
                    begin action('kills '+data) end;
                if command = '!nuke' then
                    begin action('nukes '+data) end;
                if command = '!dice' then
                    begin dice end;
                if command = '!torture' then
                    begin action('tortures '+data) end;  // Torture code
                if command = '!strangle' then
                    begin action('strangles '+data) end;
                if command = '!stab' then
                    begin action('stabs '+data) end;
                if command = '!slice' then
                    begin action('slices '+data) end;
                if command = '!cut' then
                    begin action('cuts '+data) end;
                if command = '!throw' then
                    begin action('throws '+data) end;
                if command = '!shoot' then
                    begin action('shoots '+data) end;
                if command = '!pie' then
                    begin action('gives '+ user+' a piece of '+data+' pie.') end;
                if command = '!beer' then
                    begin action('gives '+ user+' a glass of '+data+' beer.') end;
                if command = '!cola' then
                    begin action('gives '+ user+' a glass of '+data+' cola.') end;
                if command = '!coffee' then
                    begin action('gives '+ user+' a cup of '+data+' coffee.') end;
                if command = '!tea' then
                    begin action('gives '+ user+' a cup of '+data+' tea.') end;

                if command = '!give' then
                    begin action('gives ' + data ) end;

                if not IsAdmin(user) then
                    begin KickBadWords(line,user) end;

// Code meow start here
                if command = '!meow' then
                    begin say(irc_nick  + char(39) + 's cat: meow') end;
// End code meow

                if (command = '!pet') and ( data = 'turtle' ) then
                    begin say(irc_nick  + char(39) + 's turtle: roar') end;
                if (command = '!pet') and ( data = 'cat' ) then
                    begin say(irc_nick  + char(39) + 's cat: meow') end;

                if (command = '!woof') or ( (command = '!pet') and ( data = 'dog' ) ) then
                    begin
                    say ( 'Sorry, no dogs allowed in here ');
                    kick (user);
                    end;

                if ( command = '!randomquote' ) then
                    begin randomquote() end;

                if ( command = '!info' ){and  (AnsiLowerCase(data) = AnsiLowerCase(form1.Nick.text)) }then
                    begin
                    announce('I am BlaatSchaap IRC Bot');
                    announce('My Source Code is available at sourceforge');
                    announce('Compile date: ' + DateToStr(CompileTime) + ' ' + TimeToStr(CompileTime) );
                    if CompilePC = 'FLAPPIE' then
                        begin announce('Original Build') end
                    else
                        begin announce ('Custum Build') end;
                    announce('My code is under the zlib licence');
                    announce('Check http://blaatschaap.nukysrealm.net/content.php?content.5 or');
                    announce('http://www.sf.net/projects/dgcshell for more info');
                    end;

                    begin

                    if ( command = '!help' ) and (data = 'user')then
                        begin
                        say(' ');
                        say(' Current supported user commands are:');
                        say('   !info                   !help                 ');
                        say('   !music                  !porn                 ');
                        say('   !dice                   !cut      <name>      ');
                        say('   !nuke     <name>        !torture  <name>      ');
                        say('   !kill     <name>        !strangle <name>      ');
                        say('   !stab     <name>        !slice    <name>      ');
                        say('   !meow                   !woof                 ');
                        say('   !convert <what> <from> <to>                   ');
                        end
                    else
                        if ( command = '!help' ) and (data = 'admin')then
                            begin
                            say(' ');
                            say(' Current supported admin commands are:');
                            say('   !op       <username>    !deop     <username>   ');
                            say('   !hop      <username>    !dehop    <username>   ');
                            say('   !voice    <username>    !devoice  <username>   ');
                            say('   !ban      <username>    !unban    <username>   ');
                            say('   !nick     <newbotnick>  !join     <channel>    ');
                            say('   !update                 !raw      <data>       ');
                            say('   !say      <text>        !saypriv  <nick> <text>');
                            say('   !announce <text>        !action   <data>       ');
                            end
                        else
                            if ( command = '!help' )then
                                begin say ('!help <commands>');
                                say ('user');
                                say ('admin'); end;


                    end;

                if ( command = '!porn' ) then


                    begin
                    spammer := 0;
                    repeat
                        saypriv ( ' now you will be SPAMMED',user);
                        spammer := spammer + 1;
                    until (spammer = 5);
                    say ( 'de bot kickt '+user+' !!!!');
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
                    if command = '!update'   then
                        begin CheckForUpdate() end;
                    if command = '!forceupdate' then
                        begin ForceUpgrade() end;
                    if command = '!raw'      then
                        begin irc_sendln(data) end;
                    if command = '!id'       then
                        begin saypriv('identify '+irc_nickpass,'NickServ') end;
                    if command = '!action'   then
                        begin action(data) end;
                    if command = '!say'      then
                        begin say(data) end;
                    if command = '!saypriv'  then
                        begin saypriv(readparams(data,1,true),readparams(data,0,false)) end;
                    if command = '!announce' then
                        begin announce(data) end;
                    if command = '!rejoin'   then
                        begin  irc_sendln('JOIN '+ irc_channel);
                        writeln (quotefile, ' ');
                        writeln (quotefile, 'Joining '+ irc_channel);
                        writeln (quotefile, ' '); end;



                    if (command = '!admin') and (ReadParams(data,0,false)= 'list')  then
                        begin listadmin() end;

                    if (command = '!admin') and (ReadParams(data,0,false)= 'add') then
                        begin
                        if NOT ((ReadParams(data,1,false)) = '') then
                            begin
                            AddAdmin(ReadParams(data,1,false));
                            announce(user + ' added '+ (ReadParams(data,1,false)) + ' to the admin list.')
                            end
                        else
                            begin say('who?') end;
                        end;


                    if (command = '!admin') and (ReadParams(data,0,false)= 'remove') then
                        begin
                        if NOT ((ReadParams(data,1,false)) = '') then
                            begin
                            RemoveAdmin(ReadParams(data,1,false));
                            announce(user + ' removed '+ (ReadParams(data,1,false)) + ' from the admin list.')
                            end
                        else
                            begin announce('who?') end;
                        end;



                    if (command = '!badword') and (ReadParams(data,0,false)= 'list')  then
                        begin listbadwords() end;




                    if (command = '!badword') and (ReadParams(data,0,false)= 'remove') then
                        begin
                        if NOT ((ReadParams(data,1,false)) = '') then
                            begin
                            RemoveBadword(ReadParams(data,1,true));
                            announce(user + ' removed '+ (ReadParams(data,1,true)) + ' from the bad word list.')
                            end
                        else
                            begin announce('no word to remove') end;
                        end;

                    if (command = '!spamon') then
                        begin SPAM := true end;
                    if (command = '!spamoff') then
                        begin SPAM := false end;

                    if (command = '!badword') and (ReadParams(data,0,false)= 'add') then
                        begin
                        if NOT ((ReadParams(data,1,false)) = '') then
                            begin
                            AddBadWord(ReadParams(data,1,true));
                            announce(user + ' added '+ (ReadParams(data,1,false)) + ' to the bad word list.')
                            end
                        else
                            begin announce('no word to add') end;
                        end;



// add check for illegal signs in nick ..
// check what is allowed to be in a nick first ..
                    if command = '!nick' then
                        begin irc_nick:=data; irc_Sendln('NICK '+irc_nick);
// update GUI ...??
                        end;

                    if command = '!join' then
                        begin
                        if data[1]='#' then
                            begin
                            irc_Sendln('PART '+ irc_channel + ' Moving to ' + data);
                            irc_channel := data;
                            irc_Sendln('JOIN '+ irc_channel);
                            writeln (quotefile, ' ');
                            writeln (quotefile, 'Joining '+ irc_channel);
                            writeln (quotefile, ' '); 


  // add check for succesfull join.
  // check how to do so ...
  // add check for illegal signs in channel name
                            end
                        else
                            begin say ('Channels should begin with # ') end;
                        end;

// commands in the channel
//if NOT(contains(data,form1.Nick.Text)) then


// add check if bot is +h / +o / +a / +q
                    if NOT(data=irc_nick) then
                        begin

                        if command = '!kick'     then
                            begin
                            if AnsiLowerCase(data)=AnsiLowerCase(user) then
                                begin say ('Do you really want to kick yourself?') end
                            else
                                begin kick(data) end;  end;

                        if command = '!ban'      then
                            begin mode(data,'b',true) end;
                        if command = '!unban'    then
                            begin mode(data,'b',false) end;
                        if command = '!op'       then
                            begin mode(data,'o',true) end;
                        if command = '!deop'     then
                            begin mode(data,'o',false) end;
                        if command = '!hop'      then
                            begin mode(data,'h',true) end;
                        if command = '!dehop'    then
                            begin mode(data,'h',false) end;
                        if command = '!voice'    then
                            begin mode(data,'v',true) end;
                        if command = '!devoice'  then
                            begin mode(data,'v',false) end;
                        end; // don't do that to itself

                    end;

                end end; // end of *serv detection
    end;


end.
