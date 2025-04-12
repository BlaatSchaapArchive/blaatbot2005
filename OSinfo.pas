{ code from the Windows Version Detection Program }


unit OSinfo;

interface
uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls;

procedure  GetOSINFO    ();
function   GetOSNAME    () : String;
function   GetOSTYPE    () : String;
function   GetOSSP      () : String;
function   GetOSVERSION () : String;

var

    osname,osversion,ostype,ossp : string;


{ vars from winverdet }
    Version: TOSVersionInfo;
    lbRetVal: Boolean;
    Result:boolean;
    convert : variant ;
    OS : string;
    readrosver : integer;
    winver : string;
    temp : string;


implementation


procedure  GetOSINFO  ();
    begin
  { prepare }
        Version.dwOSVersionInfoSize := SizeOf(Version);
        lbRetVal := GetVersionEx(Version);

  { windows type detection }
        if (Version.dwPlatformId = 0) then
            begin ostype:='Win32S' end;
        if (Version.dwPlatformId = 1) then
            begin ostype:='Windows 95' end;
        if (Version.dwPlatformId = 2) then
            begin ostype:='Windows NT' end;


        convert:=  version.dwMajorVersion;
        temp := convert;
        osversion := temp + '.';
        convert:=  version.dwMinorVersion;
        temp := convert;
        osversion:= osversion + temp + '.';
        convert:= version.dwBuildNumber;
        temp := convert;
        osversion := osversion + temp ;

        osname:='Unknown';// inital value

        if (Version.dwPlatformId = 1) and (version.dwMajorVersion = 4) and (version.dwMinorVersion = 0) then
            begin osname := 'Windows 95' end;
        if (Version.dwPlatformId = 1) and (version.dwMajorVersion = 4) and (version.dwMinorVersion = 10) then
            begin osname := 'Windows 98' end;
        if (Version.dwPlatformId = 1) and (version.dwMajorVersion = 4) and (version.dwMinorVersion = 95) then
            begin osname := 'Windows ME' end;
        if (Version.dwPlatformId = 2) and (version.dwMajorVersion = 4) and (version.dwMinorVersion = 0) then
            begin osname := 'Windows NT 4.0' end;
        if (Version.dwPlatformId = 2) and (version.dwMajorVersion = 5) and (version.dwMinorVersion = 0) then
            begin osname := 'Windows 2000' end;
        if (Version.dwPlatformId = 2) and (version.dwMajorVersion = 5) and (version.dwMinorVersion = 1) then
            begin osname := 'Windows XP' end;
        if (Version.dwPlatformId = 2) and (version.dwMajorVersion = 5) and (version.dwMinorVersion = 2) then
            begin osname := 'Windows 2003' end;
        if (Version.dwPlatformId = 2) and (version.dwMajorVersion = 6) and (version.dwMinorVersion = 0) then
            begin osname := 'Windows Vista' end;

        ossp :=  Version.szCSDVersion;




        readrosver := 15  ;
        repeat
            OS := OS + version.szCSDVersion[readrosver];
            readrosver := readrosver + 1;
        until readrosver = 22  ;

        IF OS = 'ReactOS' then
            begin
            osname := 'ReactOS';
            osversion := '';
            osname := osname + ' ';
            readrosver := 23  ;
            repeat
                osname := osname + version.szCSDVersion[readrosver];
                readrosver := readrosver + 1;
                ossp := '';
            until version.szCSDVersion[readrosver]='';//readrosver = 127  ;
            end;
    end;

function   GetOSNAME () : String;
    begin
        GetOSINFO ();
        result:= OSNAME;
    end;
function   GetOSTYPE () : String;
    begin
        GetOSINFO ();
        result:= OSTYPE;
    end;
function   GetOSSP   () : String;
    begin
        GetOSINFO ();
        result:= OSSP;
    end;

function   GetOSVERSION   () : String;
    begin
        GetOSINFO ();
        result:= OSVERSION;
    end;



end.
