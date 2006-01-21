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
  if (Version.dwPlatformId = 0) then ostype:='Win32S';
  if (Version.dwPlatformId = 1) then ostype:='Windows 95';
  if (Version.dwPlatformId = 2) then ostype:='Windows NT';


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
    osname := 'Windows 95';
    if (Version.dwPlatformId = 1) and (version.dwMajorVersion = 4) and (version.dwMinorVersion = 10) then
    osname := 'Windows 98';
    if (Version.dwPlatformId = 1) and (version.dwMajorVersion = 4) and (version.dwMinorVersion = 95) then
    osname := 'Windows ME';
    if (Version.dwPlatformId = 2) and (version.dwMajorVersion = 4) and (version.dwMinorVersion = 0) then
    osname := 'Windows NT 4.0';
    if (Version.dwPlatformId = 2) and (version.dwMajorVersion = 5) and (version.dwMinorVersion = 0) then
    osname := 'Windows 2000';
    if (Version.dwPlatformId = 2) and (version.dwMajorVersion = 5) and (version.dwMinorVersion = 1) then
    osname := 'Windows XP';
    if (Version.dwPlatformId = 2) and (version.dwMajorVersion = 5) and (version.dwMinorVersion = 2) then
    osname := 'Windows 2003';
    if (Version.dwPlatformId = 2) and (version.dwMajorVersion = 6) and (version.dwMinorVersion = 0) then
    osname := 'Windows Vista';

    ossp :=  Version.szCSDVersion;




     readrosver := 15  ;
     repeat
     OS := OS + version.szCSDVersion[readrosver];
     readrosver := readrosver + 1;
     until readrosver = 22  ;

     IF OS = 'ReactOS' then begin
     osname := 'ReactOS';
     osversion := '';
     readrosver := 23  ;
     repeat
     osversion := osversion + version.szCSDVersion[readrosver];
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
