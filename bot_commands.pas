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
writeln(quotefile, '['+ date_now + ' ' + time_now + '] <'+user + '>  ' + line)
else
writeln(quotefile, '['+ date_now + ' ' + time_now + '] *'+user + '  ' + line);
// action, still strip the chr(1);




if not (command='') then
//if (command[1]='!') then Form1.MemoOutput.Lines.Add(user + ' : ' + command + ' ' + data);
// logger

if not (contains(user,'serv')) then begin
// to prevent reacting on  *serv
// say in private to rejoin the channel, ( when it is kicked ? )
//if (inchannel = false) and contains(line,'rejoin') then form1.TcpClient.Sendln('JOIN '+ form1.channel.Text);

//if (inchannel = false) and contains(line,form1.Nick.edit) then say('I am  '+form1.nick.Text);

if (inchannel = false) and (line = ( CHR(1) +'VERSION' + CHR(1))) then
//received a CTCP version
irc_sendln('NOTICE ' + user + ' :'+ CHR($01) + 'VERSION '+ bot_version + CHR($01))
else

if inchannel = false then
begin
randomize;
number := 7; //disable
//number := random(6);
// put strings in a file ?





if ( number = 0 ) then saypriv('I am '+ irc_nick, user);
if ( number = 1 ) then saypriv(user, user);
if ( number = 2 ) then saypriv('You must be bored', user);
if ( number = 3 ) then saypriv('blaatschaap.nukysrealm.net', user);
if ( number = 4 ) then saypriv('Wat moet je ? ', user);
if ( number = 5 ) then saypriv('I am only a bot....', user);
end;

// example how to use the new contains function
// it's annyoing
//if contains(line,'blaat') and (not (user = lastjoined)) then
//begin
//say('Inderdaad, blaat in het kwadraat!');
//lastjoined := user;    //reuse,flood protect
//end;


if ( command = '!stat' ) then GetStats();

if (command = 'brb') or (command = 'bbl' ) then say (orange + 'See you soon, '+ user);
if (command = 'biw') or (command = 'back') then say (orange + 'Welcome back, '+user);

if ( command = '!convert' ) then DoConvert(data);

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
       if (quotecount < 6 ) then say (quoteline);
        end;
      end;
close (quotes);  // Andre was stupid, forgot to close the fucking file !!
end;

if command = '!kill' then action('kills '+data);
if command = '!nuke' then action('nukes '+data);
if command = '!dice' then dice;
if command = '!torture' then action('tortures '+data);  // Torture code
if command = '!strangle' then action('strangles '+data);
if command = '!stab' then action('stabs '+data);
if command = '!slice' then action('slices '+data);
if command = '!cut' then action('cuts '+data);
if command = '!throw' then action('throws '+data);
if command = '!shoot' then action('shoots '+data);
if command = '!pie' then action('gives '+ user+' a piece of '+data+' pie.');
if command = '!beer' then action('gives '+ user+' a glass of '+data+' beer.');
if command = '!cola' then action('gives '+ user+' a glass of '+data+' cola.');
if command = '!coffee' then action('gives '+ user+' a cup of '+data+' coffee.');
if command = '!tea' then action('gives '+ user+' a cup of '+data+' tea.');

if command = '!give' then action('gives ' + data );

if not IsAdmin(user) then KickBadWords(line,user);

// Code meow start here
if command = '!meow' then say(irc_nick  + char(39) + 's cat: meow');
// End code meow

if (command = '!pet') and ( data = 'turtle' ) then say(irc_nick  + char(39) + 's turtle: roar');
if (command = '!pet') and ( data = 'cat' ) then say(irc_nick  + char(39) + 's cat: meow');

if (command = '!woof') or ( (command = '!pet') and ( data = 'dog' ) ) then begin
say ( 'Sorry, no dogs allowed in here ');
kick (user);
end;

if ( command = '!randomquote' ) then randomquote();

if ( command = '!info' ){and  (AnsiLowerCase(data) = AnsiLowerCase(form1.Nick.text)) }then
begin
announce('I am BlaatSchaap IRC Bot');
announce('My Source Code is available at sourceforge');
announce('Compile date: ' + DateToStr(CompileTime) + ' ' + TimeToStr(CompileTime) );
if CompilePC = 'FLAPPIE' then announce('Original Build') else announce ('Custum Build');
announce('My code is under the zlib licence');
announce('Check http://blaatschaap.nukysrealm.net/content.php?content.5 or');
announce('http://www.sf.net/projects/dgcshell for more info');
end;

begin

if ( command = '!help' ) and (data = 'user')then begin
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
end else
if ( command = '!help' ) and (data = 'admin')then begin
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
end else
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
if command = '!update'   then CheckForUpdate();
if command = '!forceupdate' then ForceUpgrade();
if command = '!raw'      then irc_sendln(data);
if command = '!id'       then saypriv('identify '+irc_nickpass,'NickServ');
if command = '!action'   then action(data);
if command = '!say'      then say(data);
if command = '!saypriv'  then saypriv(readparams(data,1,true),readparams(data,0,false));
if command = '!announce' then announce(data);
if command = '!rejoin'   then
  begin  irc_sendln('JOIN '+ irc_channel);
      writeln (quotefile, ' ');
  writeln (quotefile, 'Joining '+ irc_channel);
      writeln (quotefile, ' '); end;



if (command = '!admin') and (ReadParams(data,0,false)= 'list')  then
listadmin();

if (command = '!admin') and (ReadParams(data,0,false)= 'add') then
begin
if NOT ((ReadParams(data,1,false)) = '') then
begin
AddAdmin(ReadParams(data,1,false));
announce(user + ' added '+ (ReadParams(data,1,false)) + ' to the admin list.')
end else say('who?');
end;


if (command = '!admin') and (ReadParams(data,0,false)= 'remove') then
begin
if NOT ((ReadParams(data,1,false)) = '') then
begin
RemoveAdmin(ReadParams(data,1,false));
announce(user + ' removed '+ (ReadParams(data,1,false)) + ' from the admin list.')
end else announce('who?');
end;



if (command = '!badword') and (ReadParams(data,0,false)= 'list')  then
listbadwords();




if (command = '!badword') and (ReadParams(data,0,false)= 'remove') then
begin
if NOT ((ReadParams(data,1,false)) = '') then
begin
RemoveBadword(ReadParams(data,1,true));
announce(user + ' removed '+ (ReadParams(data,1,true)) + ' from the bad word list.')
end else announce('no word to remove');
end;

if (command = '!spamon') then SPAM := true;
if (command = '!spamoff') then SPAM := false;

if (command = '!badword') and (ReadParams(data,0,false)= 'add') then
begin
if NOT ((ReadParams(data,1,false)) = '') then
begin
AddBadWord(ReadParams(data,1,true));
announce(user + ' added '+ (ReadParams(data,1,false)) + ' to the bad word list.')
end else announce('no word to add');
end;



// add check for illegal signs in nick ..
// check what is allowed to be in a nick first ..
if command = '!nick' then begin irc_nick:=data; irc_Sendln('NICK '+irc_nick);
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
  end else
say ('Channels should begin with # ');
end;

// commands in the channel
//if NOT(contains(data,form1.Nick.Text)) then


// add check if bot is +h / +o / +a / +q
if NOT(data=irc_nick) then
begin

if command = '!kick'     then
begin
if AnsiLowerCase(data)=AnsiLowerCase(user) then say ('Do you really want to kick yourself?')
else kick(data);  end;

if command = '!ban'      then mode(data,'b',true);
if command = '!unban'    then mode(data,'b',false);
if command = '!op'       then mode(data,'o',true);
if command = '!deop'     then mode(data,'o',false);
if command = '!hop'      then mode(data,'h',true);
if command = '!dehop'    then mode(data,'h',false);
if command = '!voice'    then mode(data,'v',true);
if command = '!devoice'  then mode(data,'v',false);
end; // don't do that to itself

end;

end; // end of *serv detection
end;


end.
