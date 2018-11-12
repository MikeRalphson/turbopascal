{$A+,B-,D-,E-,F-,G-,I-,L-,N-,O-,R-,S+,V-,X-}
{$M 2048,0,0}
program ascii;

uses dos,crt;

var
 loop:byte;

begin
 checksnow:=false;
 window(1,1,80,23);
 textattr:=120;
 clrscr;
 gotoxy(26,2);
 writeln('Ascii Chart (Decimal Values)');
 window(2,4,79,23);
 for loop:=0 to 255 do begin
  textattr:=123;
  write(loop,' ');
  textattr:=127;
  if loop<14 then write('*')
  else write(chr(loop));
  write(' ');
 end;
 normvideo;
 window(1,24,80,25);
 clrscr;
end.
