{$A+,B-,D+,E-,F-,I-,L-,N-,O-,R-,S+,V-}
{$M 16384,0,655360}

program albion;

type
 gender=(male,female);
 title=(king,queen,cprince,cprincess,prince,princess,regent,baron,duke,aristo);
 namestr=string[20];
 person=record
  name:namestr;
  sex:gender;
  status:title;
  partner:longint;          { These are the genealogical pointers  }
  prevsibling:longint;      { They provide a family tree structure }
  succsibling:longint;      { which enables next-of-kin to be      }
  firstchild:longint;       { calculated and family-wide searches  }
  father:longint;           { to be made. A negative value is NIL  }
  mother:longint;
  str,con,int,
  wis,dex,cha:byte;
  birthyear:word;
  birthdate:word;
  alive:boolean;
 end;
 {playerfile=file of person;}

const
 sex:array [male..female] of string[6]=('Male','Female');
 year:word=1300;

function dice(number,sides:word):word;

var
 temp,loop,r:word;

begin
 temp:=0;
 {for loop:=1 to number do inc(temp,succ(random(sides)));}
 for loop:=1 to number do begin
  r:=random(sides);  
  inc(temp,succ(r));
 end;
 dice:=temp;
end;

function age(var temp:person):word;

begin
 age:=year-temp.birthdate;
end;

procedure create(var p:person;name:namestr;sex:gender);

begin
 p.name:=name;
 p.sex:=sex;
 p.str:=dice(3,6);
 p.int:=dice(3,6);
 p.con:=dice(3,6);
 p.wis:=dice(3,6);
 p.dex:=dice(3,6);
 p.cha:=dice(3,6);
end;

procedure display(p:person);

begin
 writeln;
 writeln('Character display: ',p.name,' ',sex[p.sex]);
 writeln;
 writeln('Strength      ',p.str);
 writeln('Constitution  ',p.con);
 writeln('Intelligence  ',p.int);
 writeln('Wisdom        ',p.wis);
 writeln('Dexterity     ',p.dex);
 writeln('Charisma      ',p.cha);
end;

var
 current:person;
 {playfile:array [1..6] of playerfile;}

begin
 randomize;
 writeln;
 writeln('Abstract part of albion game, character creation.');
 writeln;
 writeln('Size of each character record is ',sizeof(current),' bytes');
 writeln;
 create(current,'Arthur',male);
 display(current);
 create(current,'Guinevere',female);
 display(current);
 create(current,'Mordred',male);
 display(current);
end.
