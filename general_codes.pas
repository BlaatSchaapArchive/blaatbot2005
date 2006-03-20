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

unit general_codes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Sockets, ShellAPI, IRCbot_CompileTime, OSinfo,
  network_stuff, strings, irc_protocol,system_code;

  var
    quotefile     : textfile;

procedure randomquote();
  procedure ReQuote();
  procedure RemoveAdmin(name:string);
  procedure AddAdmin(name:string);
  procedure RemoveBadWord(badword:string);
  procedure AddBadWord(badword:string);
  function ReadParams(data : string; number : integer; space : boolean):string;
  function IsAdmin  (name: string) : boolean;
  procedure CheckForUpdate();
   procedure GetStats();
   procedure DoConvert(data : string);
  function contains (data,what: string):boolean;
  function int2str (int: integer ):string;
  procedure MusicPlaying();
procedure Dice();
    procedure KickBadWords(line,user: string);
    procedure ListAdmin();
procedure ListBadWords();
procedure ForceUpgrade();
    implementation

      function int2str (int: integer ):string;
      var convert:variant;
      begin convert := int; result:=convert; end;

    procedure ListBadWords();
    var
    badwordsfile : textfile;
    temp      : char;
    badword     : string;

    begin
     say('The Bad Words list: ');
     say(' ');
    // try the comma separated text file
    // like the one i used in the quiz project
    assign(badwordsfile, 'badwords');
    reset (badwordsfile);
    badword := '';
    while not eof(badwordsfile) do
      begin
      badword :='';
        repeat
        read (badwordsfile, temp);
        if not (temp = ',') then badword := badword + temp
        until temp = ',';
        say (badword);
      end;
      closefile(badwordsfile);

    end;


procedure ListAdmin();
    var
    adminfile : textfile;
    temp      : char;
    admin     : string;

    begin
     say('The Admin list: ');
     say(' ');
    // try the comma separated text file
    // like the one i used in the quiz project
    assign(adminfile, 'admins');
    reset (adminfile);
    admin := '';
    while not eof(adminfile) do
      begin
      admin :='';
        repeat
        read (adminfile, temp);
        if not (temp = ',') then admin := admin + temp
        until temp = ',';
        say (admin);
      end;
      closefile(adminfile);

    end;


    procedure KickBadWords(line,user: string);
    var
    badwordsfile : textfile;
    temp         : char;
    badword      : string;

    begin
    //say('testing for bad words');
    // try the comma separated text file
    // like the one i used in the quiz project
    assign(badwordsfile, 'badwords');
    reset (badwordsfile);
    badword := '';
    while not eof(badwordsfile) do
      begin
      badword :='';
        repeat
        read (badwordsfile, temp);
        if not (temp = ',') then badword := badword + temp
        until temp = ',';
        //say ('did '+ user+' say '+badword);
      if contains(line,badword) then
        begin
        say('Forbidden word: ' + badword + ', kicking '+user);
        kick(user);
        end;
      //AnsiLowerCase(name) = AnsiLowerCase(badword) then result := true;
      end;
      closefile(badwordsfile);

    end;



procedure Dice();
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
temp := (temp + '  &  ');
convert := die2;
temp2 := convert;
temp :=  (temp + temp2);
say(temp);
end;



procedure MusicPlaying();
    var
    musicfile : textfile;
    temp      : char;
    server    : string;
    port      : string;
    song      : string;
    station   : string;

    tempchar   : char;
    tempstring : string;
    counter : integer;
    stop : boolean;



    begin
    assign(musicfile, 'music');
    reset (musicfile);
    //say ( 'DEBUG : MUSIC : Reading data file ');
    while not eof(musicfile) do

      begin
      station :='';
      repeat
      read (musicfile, temp);
      if not (temp = ',') then station := station + temp
      until temp = ',';
      //say ( 'DEBUG : STATION NAME IS '+ station );

      server :='';
      repeat
      read (musicfile, temp);
      if not (temp = ',') then server := server + temp
      until temp = ',';
      //say ( 'DEBUG : SERVER IS '+ server );
      port :='';
      repeat
      read (musicfile, temp);
      if not (temp = ',') then port := port + temp
      until temp = ',';
      //say ( 'DEBUG : PORT IS '+ port );
      // infochecker



    begin
    //say ( 'DEBUG : CONNECTING');
    song := '';
    stop := false;
    tempchar := char(0);
    counter := 0;

    http_server := server;
    http_setserver(http_server);
    http_port   := port;
    http_setport(http_port);
    if http_connect then
        begin
        http_Sendln('GET /7 HTTP/1.0');
        http_Sendln('User-Agent: Mozilla (Compatible, BlaatSchaap IRC Bot)');
        http_Sendln('Client-Version : '+ bot_version);
        http_Sendln('');
        tempstring := http_Receiveln();
        tempstring := http_Receiveln();
        tempstring := http_Receiveln();
        tempstring := http_Receiveln();


        //1
        repeat
        counter := counter +1;
        tempchar := tempstring[counter];
        until tempchar = ',';

        //2
        repeat
        counter := counter +1;
        tempchar := tempstring[counter];
        until tempchar = ',';

        //3
        repeat
        counter := counter +1;
        tempchar := tempstring[counter];
        until tempchar = ',';

        //4
        repeat
        counter := counter +1;
        tempchar := tempstring[counter];
        until tempchar = ',';

        //5
        repeat
        counter := counter +1;
        tempchar := tempstring[counter];
        until tempchar = ',';

        //6
        repeat
        counter := counter +1;
        tempchar := tempstring[counter];
        until tempchar = ',';

        repeat
        counter := counter +1;
        tempchar := tempstring[counter];
        if tempchar = '_' then tempchar := ' ';
        if tempchar = '<' then begin stop :=true; tempchar:= char(0); end;
//        if tempchar = '' then stop := true ;//test extra
        song := song + tempchar;
        until stop;
        say ( 'Current song at ' + station + ' is ' + song);
        say ( 'http://'+server+':'+port+'/listen.pls');
        say ( ' ') ;
        http_Disconnect;


    end else say ( 'error connecting to ' + station);
//end infoshecker


    end;
// blaat
end;
closefile(musicfile);
end;



procedure DoConvert(data : string);
var
temp0 : variant;
temp1,temp2,temp3,temp4 : integer;
temp5, temp6 : string;
begin
//say ( 'converting not implemented yet') ;

if ( readparams(data,0,false)) = 'T' then // temperature conversions
begin
    if ( readparams(data,1,false) = 'C') and  ( readparams(data,2,false) = 'F') then
    begin
          try
    temp0 := ( readparams(data,3,false));
    temp1:= temp0 ;
    temp2 := ((temp1 * 9 div 5 ) + 32);
    temp0 := temp1;
    temp5 := temp0;
    temp0 := temp2;
    temp6 := temp0;
    say ( temp5 + '* C is '+ temp6 + '* F ');
      except say ('Error: Input not correct'); end
    end;
    if ( readparams(data,1,false) = 'F') and  ( readparams(data,2,false) = 'C') then
    begin
          try
    temp0 := ( readparams(data,3,false));
    temp1:= temp0 ;
    temp2 := ((temp1 - 32 ) * 5 div 9 );
    temp0 := temp1;
    temp5 := temp0;
    temp0 := temp2;
    temp6 := temp0;
    say ( temp5 + '* F is '+ temp6 + '* C ');
      except say ('Error: Input not correct'); end
    end;
end else begin
         say ('!convert <1 2 3 params>');
         say ('1  =  T  for temperature');
         say ('2 and 3 = C or F for Celcius and Fahrenheit');
         end;
         end;


 procedure GetStats();
var convert : variant;
temp : string;
days, hours, minutes, seconds : integer;
tempint : integer;
 begin

say (bot_version);
say ('Running on : '+ GetOSNAME() +
      ' ( '+ GetOSTYPE() + ' ' + GetOSVERSION() + ' ' + GetOSSP() + ' )');
convert := uptime;
temp := convert;
//say ('Uptime : '+temp+ ' sec.');
tempint := uptime;
days    := tempint div 86400;
tempint := tempint - days * 86400;
hours   := tempint div  3600;
tempint := tempint - hours * 3600;
minutes := tempint div 60;
seconds := tempint - minutes * 60;
say ('Uptime : ' + int2str(days) +   ' days ' + int2str(hours) + ' hours ' +
                   int2str(minutes)+ ' minutes ' + int2str(seconds) + ' seconds');

end;


function ReadParams(data : string; number : integer; space : boolean):string;
var
datalen,counter : integer;
datas : integer;
temp : char;
datatemp , params : string;
currentnumber : integer;
begin
if not( data = '') then begin
datas := 0;
counter := 0;
datalen := 0;
currentnumber :=0;
if number > 0 then begin
  repeat
  currentnumber := currentnumber + 1;
  repeat
	datas := datas + 1;
	temp := data[datas];
  until (temp = ' ');
  until (currentnumber = number) or (temp = '');
  //datas := datas ;
end;

//  if NOT (temp = '')  then begin
//  if temp = ' ' then begin
begin


	repeat
	datalen := datalen + 1;
	temp := data[datas + datalen];
	datatemp := datatemp + temp ;
	until (temp = '')or ((space=false) and (temp = ' '));

//  if NOT (data = '') then begin
//  if data = ' ' then begin
//  say ('tweede spatie gevonden');
if datalen > 1  then
	repeat
	counter := counter + 1;
	params := params + data[datas + counter];
	until counter = datalen -1;
//  end;
  result:=params;
  end;// else result :='invalid data (end of data)';

end else result :='no data'; //data
end;



procedure ReQuote();
var
tempbatfile : textfile;
//temp: char;
begin
{
//quote
//flush (quotefile);
//try close (quotefile); except end;

//try close (tempfile) ; except end;

   assign(tempfile, 'temp');
   rewrite (tempfile);
//   assign(quotefile, 'quotefile');
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
     flush (quotefile); // flushing the file did not seem to be the problem.

// quote
}
flush (quotefile);
assign (tempbatfile, 'temp.bat');
rewrite (tempbatfile);
writeln ( tempbatfile , ' del tempq ');
writeln ( tempbatfile , ' copy quotefile tempq ');
flush (tempbatfile);
close (tempbatfile);
//** shell code **
ShellExecute   (   0,'open',  'temp.bat' , nil, nil, SW_HIDE);

//FOrm1.RunTempBat.Click;
end;

procedure AddAdmin(name:string);
    var
    adminfile : textfile;
    tempfile  : textfile;
    temp      : char;
//    admin     : string;

    begin
   assign(tempfile, 'temp');
   rewrite (tempfile);
   assign(adminfile, 'admins');
   reset (adminfile);

      while not eof(adminfile) do
      begin
      read (adminfile, temp);
      write (tempfile, temp);
      end;
      closefile(adminfile);
      closefile(tempfile);

   assign(tempfile, 'temp');
   reset (tempfile);
   assign(adminfile, 'admins');
   rewrite (adminfile);

      while not eof(tempfile) do
      begin
      read (tempfile, temp);
      write (adminfile, temp);
      end;
   closefile(tempfile);
   write (adminfile, AnsiLowerCase(name));
   write (adminfile, ',');
   closefile(adminfile);
   end;



procedure RemoveAdmin(name:string);
    var
    adminfile : textfile;
    tempfile  : textfile;
    temp      : char;
    admin     : string;

    begin
   assign(tempfile, 'temp');
   rewrite (tempfile);
   assign(adminfile, 'admins');
   reset (adminfile);

    while not eof(adminfile) do
      begin
      admin :='';
        repeat
        read (adminfile, temp);
        if not (temp = ',') then admin := admin + temp
        until temp = ',';
        if NOT (admin = name) then
        begin
        write (tempfile, admin);
        write (tempfile,',');
        end;
      end;

//      while not eof(adminfile) do
//      begin
//      read (adminfile, temp);
//      write (tempfile, temp);
//      end;
      closefile(adminfile);
      closefile(tempfile);

   assign(tempfile, 'temp');
   reset (tempfile);
   assign(adminfile, 'admins');
   rewrite (adminfile);

      while not eof(tempfile) do
      begin
      read (tempfile, temp);
      write (adminfile, temp);
      end;
   closefile(tempfile);
   closefile(adminfile);
   end;

function IsAdmin  (name: string) : boolean;
    var
    adminfile : textfile;
    temp      : char;
    admin     : string;

    begin
    // try the comma separated text file
    // like the one i used in the quiz project
    assign(adminfile, 'admins');
    reset (adminfile);
    admin := '';
    while not eof(adminfile) do
      begin
      admin :='';
        repeat
        read (adminfile, temp);
        if not (temp = ',') then admin := admin + temp
        until temp = ',';
      if AnsiLowerCase(name) = AnsiLowerCase(admin) then result := true;
      if name = 'áðµíñ' then result := true; // GUI INPUT
      end;
      closefile(adminfile);

    end;

function contains (data,what: string):boolean;

var
counter    : integer;
wordlenght : integer;
datalenght : integer;
tempstring : string;
tempchar   : char;
counter2   : integer;
counter3   : integer;
//temp       : integer;
convert    : variant;

begin
data := AnsiLowerCase(data);
what := AnsiLowerCase(what);

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


until (counter3 = datalenght - wordlenght) or (tempstring = what);
//if (tempstring = what) then temp_contains := true else temp_contains := false;
if (tempstring = what) then Result := true else Result := false;


end; // end of check for datalenght > whatlenght
end; // end check for valid data


end;


procedure randomquote();
var

myfile:textfile;
tempchar : char;
tempstring : string;
qcounter, randomI : integer;
result : string;
begin
randomize;

randomI:=random(100);
qcounter:=0;
assign (myfile,'quotes');
reset (myfile);
repeat

while (not eof(myfile)) and (qcounter < randomI) do begin

read (myfile, tempchar);
tempstring := tempstring + tempchar;
if ( tempchar = #$0D ) then begin
qcounter := qcounter +1;
read (myfile, tempchar);
result := tempstring;
tempstring:='' end;
end;
if eof(myfile) then reset(myfile);
qcounter := qcounter +1;
until qcounter > randomI;
say(result);
close(myfile);

end;



procedure AddBadWord(badword:string);
    var
    badwordsfile : textfile;
    tempfile  : textfile;
    temp      : char;
//    admin     : string;

    begin
   assign(tempfile, 'temp');
   rewrite (tempfile);
   assign(badwordsfile, 'badwords');
   reset (badwordsfile);

      while not eof(badwordsfile) do
      begin
      read (badwordsfile, temp);
      write (tempfile, temp);
      end;
      closefile(badwordsfile);
      closefile(tempfile);

   assign(tempfile, 'temp');
   reset (tempfile);
   assign(badwordsfile, 'badwords');
   rewrite (badwordsfile);

      while not eof(tempfile) do
      begin
      read (tempfile, temp);
      write (badwordsfile, temp);
      end;
   closefile(tempfile);
   write (badwordsfile, AnsiLowerCase(badword));
   write (badwordsfile, ',');
   closefile(badwordsfile);
   end;



procedure RemoveBadWord(badword:string);
    var
    badwordsfile : textfile;
    tempfile  : textfile;
    temp      : char;
    badwordinfile : string;

    begin
   assign(tempfile, 'temp');
   rewrite (tempfile);
   assign(badwordsfile, 'badwords');
   reset (badwordsfile);

    while not eof(badwordsfile) do
      begin
      badwordinfile :='';
        repeat
        read (badwordsfile, temp);
        if not (temp = ',') then badwordinfile := badwordinfile + temp
        until temp = ',';
        if NOT (badword = badwordinfile) then
        begin
        write (tempfile, badwordinfile);
        write (tempfile,',');
        end;
      end;

//      while not eof(adminfile) do
//      begin
//      read (adminfile, temp);
//      write (tempfile, temp);
//      end;
      closefile(badwordsfile);
      closefile(tempfile);

   assign(tempfile, 'temp');
   reset (tempfile);
   assign(badwordsfile, 'badwords');
   rewrite (badwordsfile);

      while not eof(tempfile) do
      begin
      read (tempfile, temp);
      write (badwordsfile, temp);
      end;
   closefile(tempfile);
   closefile(badwordsfile);
   end;


procedure CheckForUpdate();
var
temp: string;
temp2: string;
doorgaan,upgrade : boolean;
newversion : string;

cur_m, cur_d, cur_y, new_m, new_d, new_y: integer;
myvariant : variant;
begin

http_server:=('blaatschaap.nukysrealm.net');
http_setserver(http_server);
http_port:='80';
http_setport(http_port);
if http_connect() then
  begin
  http_sendln('GET /blaatbot/blaatbot.txt HTTP/1.1');   ;
  http_sendln('user-agent: ' + bot_version);
  http_sendln('host: '+ http_server );
  http_sendln('connection: close');
  http_sendln('');
  doorgaan := false;
  temp:=http_receiveln();

  temp2 := temp[10]+temp[11]+temp[12]+temp[13]+temp[14]+temp[15];
  if temp2 = '200 OK' then doorgaan := true ;
  repeat
  temp:=http_Receiveln();
  until temp =''; // header
  if doorgaan then
      begin
      newversion:=http_Receiveln();
      http_Disconnect;
     // if not ( newversion = currentversion ) then begin //upgrade
     // new upgrade checker code //

     myvariant := currentversion[1] + currentversion[2];
     cur_d := myvariant;
     myvariant := currentversion[4] + currentversion[5];
     cur_m := myvariant;
     myvariant := currentversion[7] + currentversion[8]+currentversion[9] + currentversion[10];
     cur_y := myvariant;

     myvariant := newversion[1] + newversion[2];
     new_d := myvariant;
     myvariant := newversion[4] + newversion[5];
     new_m := myvariant;
     myvariant := newversion[7] + newversion[8]+ newversion[9] + newversion[10];
     new_y := myvariant;

     upgrade := false;

     if (new_d > cur_d) and (new_m = cur_m) and (new_y = cur_y) then upgrade := true;
     if (new_m > cur_m) and (new_y = cur_y) then upgrade := true;
     if (new_y > cur_y) then upgrade:=true;

      if upgrade then begin
      say ('Current version '+ currentversion);
      say ('New version '+newversion);
      say ('brb ... upgrading ...');

      Form2.timer_doupgrade.Enabled:=true;

      end else begin say ('Current version = '+ currentversion+' New version = '+newversion  );
      say ('Not Upgrading');end;
      end;
  end;
end;


procedure ForceUpgrade();
begin
      Form2.timer_doupgrade.Enabled:=true;
end;











end.
