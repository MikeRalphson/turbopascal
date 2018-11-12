program IsIt1980;

uses dos;

var
 year,month,day,dow:word;

begin
 getdate(year,month,day,dow);
 if year=1980 then halt(1) else halt(0);
end.
