unit General_code;

interface
function ReadParams(data : string; number : integer; space : boolean):string;

implementation

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


end.
 