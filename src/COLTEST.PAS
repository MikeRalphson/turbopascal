program coltest;

uses
 crt,dos;

var
 loop:word;

begin
 for loop:=0 to 255 do begin
  textattr:=loop;
  write(loop); {:4}
  if loop mod 16=15 then begin
   textattr:=7;
   writeln;
  end;
 end;
 textattr:=7;
 clreol;
 writeln;
end.
