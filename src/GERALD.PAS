{$A-,B-,D-,E+,F-,G-,I-,L-,N-,O-,R-,S-,V-,X-}
{$M 16384,0,655360}
program gerald;

uses dos,crt;

{$I lastrev.inc}

{General purpose machine speed tester, based on my machine}

const
 myfastdisplay:longint=1192;
 mybiosdisplay:longint=2445;
 myrealnumbers:longint=1220;
 mymemorymover:longint=1055;

var
 hour,min,sec,hun:word;
 loop,start,finish,
 fastdisplay,
 biosdisplay,
 realnumbers,
 memorymover:longint;

function convert(hour,min,sec,hun:longint):longint;

begin
 convert:=hun+(sec*100)+(min*6000)+(hour*360000);
end;

function total(start,finish:longint):longint;

begin
 if finish<start then inc(finish,8640000);
 total:=finish-start;
end;

procedure testdisplay;

begin
 clrscr;
 for loop:=1 to 10000 do write(' * ');
 clrscr;
end;

procedure testreal;

var
 result:real;

begin
 for loop:=6000 to 10000 do result:=sqrt(loop);
end;

{procedure testmemory;

type
 buffer=array [1..60000] of byte;

var
 p,d:^buffer;

begin
 d:=ptr(0,0);
 getmem(p,60000);
 for loop:=1 to 175 do move(d^,p^,60000);
 freemem(p,60000);
end;}

begin

 directvideo:=false;

 gettime(hour,min,sec,hun);
 start:=convert(hour,min,sec,hun);
 testdisplay;
 gettime(hour,min,sec,hun);
 finish:=convert(hour,min,sec,hun);
 biosdisplay:=total(start,finish);
 if (biosdisplay<=0) then biosdisplay:=1;

 directvideo:=true;
 checksnow:=false;

 gettime(hour,min,sec,hun);
 start:=convert(hour,min,sec,hun);
 testdisplay;
 gettime(hour,min,sec,hun);
 finish:=convert(hour,min,sec,hun);
 fastdisplay:=total(start,finish);
 if (fastdisplay<=0) then fastdisplay:=1;

 writeln();
 writeln('Testing floating point number crunching...');

 gettime(hour,min,sec,hun);
 start:=convert(hour,min,sec,hun);
 testreal;
 gettime(hour,min,sec,hun);
 finish:=convert(hour,min,sec,hun);
 realnumbers:=total(start,finish);
 if (realnumbers<=0) then realnumbers:=1;

 {writeln(#10'Testing memory to memory movement...');

 gettime(hour,min,sec,hun);
 start:=convert(hour,min,sec,hun);
 testmemory;
 gettime(hour,min,sec,hun);
 finish:=convert(hour,min,sec,hun);
 memorymover:=total(start,finish);}

 clrscr;
 writeln('Fast display rate: ',myfastdisplay/fastdisplay{:1:3});
 writeln('Bios display rate: ',mybiosdisplay/biosdisplay{:1:3});
 writeln('Floating point   : ',myrealnumbers/realnumbers{:1:3});
 {writeln('Memory movement  : ',mymemorymover/memorymover:1:3);}

end.
