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
unit strings;

interface

const
// colors

    White      : string = '0';
    Black      : string = '1';
    DBlue      : string = '2';
    DGreen     : string = '3';
    Red        : string = '4';
    DRed       : string = '5';
    DPurple    : string = '6';
    Orange     : string = '7';
    Yellow     : string = '8';
    Green      : string = '9';
    DCyan      : string = '10';
    Cyan       : string = '11';
    Blue       : string = '12';
    Purple     : string = '13';
    Dgray      : string = '14';
    Gray       : string = '15';





var
    irc_server,irc_port,irc_channel,irc_nick,irc_nickpass : string;
    irc_nickserv, irc_live : boolean;
    http_server,http_port                    : string;
    sc_server,sc_port                        : string;
    bot_version : string;

    SPAM : boolean; // nuky stfu

    bot_status : string;

    randomnumber : integer;
    silence_timer: integer;

// from main

    logfile : textfile; //debug
    timeout      : boolean;
    currentversion : string;

    receiveddata : string  ;
//  loginsleep : integer;

// converting procedures into functions

    receivednick : string  ;
    receivedchan : string  ;
    receivingdata : boolean;
    pingcount     : integer;
    pongcount     : integer;
    convert       : variant;
    time_convert  : variant;
    time_now, date_now : string;
    lastjoined    : string;
    uptime : integer;
    spammer : integer;
//  kicktime      : boolean;
//  quotefile     : textfile;
// from the crash code
//  Adminsfile    : TextFile;
//  AdminCounter  : Integer;
//  Admins : array [1..10]of String; // try it


    ready : boolean ;


implementation

end.
