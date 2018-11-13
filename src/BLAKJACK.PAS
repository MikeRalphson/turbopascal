{$A+,B-,D+,E-,F-,I-,L+,N-,O-,R-,S+,V-}
{$M 16384,0,655360}
program blakjack;

uses crt;

const
 decksize    = 52;
 maxhandsize = 5;
 mincards    = 5;
 dealerstays = 17;
 busted      = 21;
 startamount = 100;
 minbet      = 1;

 wins   : longint = 0;
 losses : longint = 0;
 draws  : longint = 0;
 hands  : longint = 0;

 place  : byte = 11;

const
 lastrev='10/10/90';

type
 cardsuit = (spades, hearts, clubs, diamonds);
 cardvalue = (duece, three, four, five, six, seven, eight, nine, ten,
              jack, queen, king, ace);
 cardstate = (picked, indeck);
 card = record
         suit : cardsuit;
         value : cardvalue;
         state : cardstate;
        end;
 hand = array [1..maxhandsize] of card;
 highscore = record
              points:longint;
              name:string[35];
             end;

var
 deck         : array[1..decksize] of card;
 cardsleft    : integer;
 suitname     : array[cardsuit] of string[8];
 valuename    : array[cardvalue] of string[5];
 countvalue   : array[cardvalue] of integer;
 player       : hand;
 dealer       : hand;
 money        : longint;
 bet          : longint;
 curcard      : integer;
 temp         : string;
 name         : string[35];
 score        : array [1..11] of highscore;
 scorefile    : file of highscore;
 loop         : word;
 demon        : string[80];
 ptrick,
 dtrick       : boolean;

procedure correct(var s:string);

var
 cha:byte;
 loop:byte;
 news:string;
 lens:byte;

begin
 news:='';
 lens:=length(s);
 for loop:=1 to lens do begin
  cha:=ord(s[loop]);
  if cha in [32,65..90,97..122] then news:=news+s[loop];
 end;
 s:=news;
 for loop:=2 to lens do begin
  cha:=ord(s[loop]);
  if cha in [65..90] then s[loop]:=chr(cha+32);
 end;
 s[1]:=upcase(s[1]);
 for cha:=2 to length(s) do if s[pred(cha)]=' ' then s[cha]:=upcase(s[cha]);
end;

procedure stats;

var
 inner,outer:word;
 temp:highscore;
 c:char;

begin
 writeln;
 writeln('Of the ',hands,' hands, you won ',wins,', the computer won ',losses,' and you drew ',draws);

 score[place].name:=name;
 score[place].points:=money;
 if place<11 then begin
  score[11].name:=demon;
  score[11].points:=100;
 end;

 for outer:=1 to 11 do
  for inner:=succ(outer) to 11 do
  if score[inner].points>score[outer].points then begin
   temp:=score[outer];
   score[outer]:=score[inner];
   score[inner]:=temp;
 end;
 writeln;
 writeln(' The ten biggest winners on the Blackjack table are:');
 writeln;
 rewrite(scorefile);
 for loop:=1 to 10 do begin
  writeln(score[loop].points:25,' --- ',score[loop].name);
  while length(score[loop].name)<35 do score[loop].name:=score[loop].name+' ';
  write(scorefile,score[loop]);
 end;
 close(scorefile);
end;

procedure printcard(acard: card);

{write the suit and value of a card}

begin
 writeln('the ',valuename[acard.value],' of ',suitname[acard.suit]);
end;

procedure instructions;

var
 response : char;

begin
 write('Do you want instructions? (y/N)');
 response:=upcase(readkey);
 writeln;
 if response='Y' then begin
  clrscr;
  writeln('Blackjack (also known as 21 and pontoon) is a fun and infuriating game that');
  writeln('combines luck and skill. The Dealer (the computer) deals two cards to you');
  writeln('and two for himself. The Dealer turns up his first card. Then you get to look');
  writeln('at your cards without the Dealer seeing them.');
  writeln;
  writeln('The general idea of the game is to make the value of your cards as close to');
  writeln('twenty-one without going over. If you do this with the two cards you are dealt');
  writeln('this is known as a blackjack. If you do not wish to add any more cards to your');
  writeln('hand, you can stick. You must have thirteen or more to stick. Picture cards');
  writeln('count ten, and aces are either one or eleven. Adding another card to your hand');
  writeln('is known as hitting.');
  writeln;
  writeln('If you manage to fill your hand (five cards) without going bust (ie over 21)');
  writeln('this is known as a five-card trick, and beats everything except a blackjack.');
  writeln;
  writeln('You start with 100 pounds, except if you are in the hall of fame, in which');
  writeln('case, you carry over your winnings.');
  writeln;
  writeln('Neither splitting, nor modification of the bet after the hand has been dealt');
  writeln('is allowed.');
  writeln;
  write('*** Press any key to start ***');
  response:=readkey;
  clrscr;
 end;
 writeln;
end;

function inhand(c: card; whose: hand): boolean;

{Returns true if card c is in the hand}

var
 handindex : integer;

begin
 inhand := false;
 for handindex := 1 to maxhandsize do
  if ((c.suit = whose[handindex].suit) and
      (c.value = whose[handindex].value)) then begin
   inhand := true;
  end;
end;

function randcard(l: integer) : integer;

{Returns a random index into the deck}

begin
 randcard := succ(random(l));
end;

procedure clearhand(var ahand: hand);

{Clears a player's hand}

var
 handindex : integer;

begin
 for handindex := 1 to maxhandsize do ahand[handindex].state := indeck;
end;

procedure initialise;

{Initialises the names of the suits and values}

var
 i       : integer;
 cardval : cardvalue;

begin
 clearhand(player);
 clearhand(dealer);
 money := startamount;
 cardsleft := 0;
 i := 2;
 for cardval := duece to ten do begin
  countvalue[cardval] := i;
  inc(i);
 end;
 for cardval := jack to king do countvalue[cardval] := 10;
 countvalue[ace] := 11;
 valuename[duece] := 'two';
 valuename[three] := 'three';
 valuename[four]  := 'four';
 valuename[five]  := 'five';
 valuename[six]   := 'six';
 valuename[seven] := 'seven';
 valuename[eight] := 'eight';
 valuename[nine]  := 'nine';
 valuename[ten]   := 'ten';
 valuename[jack]  := 'jack';
 valuename[queen] := 'queen';
 valuename[king]  := 'king';
 valuename[ace]   := 'ace';
 suitname[diamonds] := 'diamonds';
 suitname[spades]   := 'spades';
 suitname[hearts]   := 'hearts';
 suitname[clubs]    := 'clubs';
 randomize;
end;

procedure shuffle;

{shuffles the cards that are not in either player's hand. the initial shuffle
 does all the cards because both hands start empty.}

var
 asuit  : cardsuit;
 avalue : cardvalue;
 i      : integer;

{exchange the cards at the two positions in the deck}

 procedure swapcard(first, second : integer);

 var
  tempcard : card;

 begin
  tempcard := deck[first];
  deck[first] := deck[second];
  deck[second] := tempcard;
 end;

begin
 i := 1;
 for asuit := spades to diamonds do
  for avalue := duece to ace do with deck[i] do begin
   suit := asuit;
   value := avalue;
   if not (inhand(deck[i], player) or inhand(deck[i], dealer)) then begin
    state := indeck;
    inc(i);
   end;
 end;
 curcard := 0;
 cardsleft := pred(i);
 for i := 1 to cardsleft do swapcard(i, randcard(cardsleft));
end;

function pickcard : integer;

{returns the index into the deck of the next card. calls shuffle if deck
 is nearly finished.}

begin
 if cardsleft < mincards then begin
  writeln(#10#13,'Reshuffling...');
  shuffle;
 end;
 inc(curcard);
 deck[curcard].state := picked;
 dec(cardsleft);
 pickcard := curcard;
end;

function countcards(someone: hand): integer;

{determines the sum of the values in a hand. a card's state must be
 'picked' for it to be included. aces are assumed to be 11. if the
 count is over 21 and there are aces in it, as many as are needed
 will be devalued to 1.}

var
 handindex, sum, numaces : integer;

begin
 sum := 0;
 numaces := 0;
 for handindex := 1 to maxhandsize do
  if someone[handindex].state = picked then with someone[handindex] do begin
   if value = ace then inc(numaces);
   inc(sum,countvalue[value]);
  end;
  while (numaces > 0) and (sum > busted) do begin
  dec(numaces);
  dec(sum,10);
 end;
 countcards := sum;
end;

function blackjack(someone: hand): boolean;

{Returns true if the argument hand is a blackjack}

begin
 blackjack := ((countvalue[someone[1].value] = 10) and
               (countvalue[someone[2].value] = 11)) or
              ((countvalue[someone[1].value] = 11) and
               (countvalue[someone[2].value] = 10));
end;

procedure getbet;

const
 betprompt = ' pounds. Amount to bet (0 to end)? ';

var
 code:integer;
 c:char;
 temp2:string;

begin
 write('You have ',money,betprompt);
 readln(temp);
 temp2:='';
 bet:=succ(money);
 for loop:=1 to length(temp) do if temp[loop] in ['0'..'9'] then
  temp2:=temp2+temp[loop];
 if temp2<>'' then val(temp2,bet,code);
 while (bet<0) or (bet>money) do begin
  writeln;
  writeln(^G,'A bet must be between 1 and ',money,' pounds.');
  writeln;
  write('You have ',money,betprompt);
  readln(temp);
  temp2:='';
  bet:=succ(money);
  for loop:=1 to length(temp) do if temp[loop] in ['0'..'9'] then
   temp2:=temp2+temp[loop];
  if temp2<>'' then val(temp2,bet,code);
 end;
 if bet = 0 then begin
  writeln;
  write('Do you really want to quit (y/N) ?');
  c:=upcase(readkey);
  writeln;
  if c='Y' then begin
   writeln;
   writeln('You quit with ',money,' pounds.');
   stats;
   halt;
  end else begin
   bet:=-1;
   writeln;
  end;
 end;
end;

procedure dealhands;

{Deals the cards to both participants for this hand}

begin
 player[1] := deck[pickcard];
 dealer[1] := deck[pickcard];
 player[2] := deck[pickcard];
 dealer[2] := deck[pickcard];
 writeln;
 write('The dealer''s turn-up card is ');
 printcard(dealer[2]);
 writeln;
 write('You drew ');
 printcard(player[1]);
 write('and ');
 printcard(player[2]);
end;

procedure playertakes;

{Asks the player if more cards are wanted}

var
 atcard : integer;
 answer : char;

begin
 atcard := 3;
 answer := 'H';
 while (atcard <= maxhandsize) and (countcards(player) < busted) and
       (answer = 'H') do begin
  writeln;
  if countcards(player)<13 then begin
   writeln('You must draw another card...');
   delay(1000);
  end else begin
   write('You''ve got ',countcards(player),'. Hit or stick? (h/S)');
   answer:=upcase(readkey);
   writeln;
  end;
  if answer='H' then begin
   player[atcard] := deck[pickcard];
   writeln;
   write('You drew ');
   printcard(player[atcard]);
   inc(atcard);
  end;
 end;
 if (countcards(player) <= busted) and (atcard > maxhandsize) then begin
  writeln('Your hand is full...');
  ptrick:=true;
 end else ptrick:=false;
 writeln;
 writeln('Your total is ',countcards(player));
end;

procedure dealertakes;

var
 atcard : integer;

begin
 writeln;
 write('Dealer''s hole card is ');
 printcard(dealer[1]);
 atcard := 3;
 while (atcard<=maxhandsize) and (countcards(dealer)<dealerstays) do begin
  dealer[atcard] := deck[pickcard];
  write('Dealer drew ');
  printcard(dealer[atcard]);
  inc(atcard);
 end;
 dtrick:=(atcard>maxhandsize) and (countcards(dealer)<=busted);
end;

procedure whowon;

var
 oldmoney:longint;

begin
 oldmoney:=money;
 writeln;
 writeln('Dealer has ',countcards(dealer),'.');
 if blackjack(dealer) then begin
  writeln('Dealer''s blackjack wins.');
  dec(money,bet);
 end else if blackjack(player) then begin
  writeln('Your blackjack wins!');
  inc(money,bet);
 end else if ptrick then begin
  write('You''ve got a five-card trick');
  if dtrick then writeln('. So did the dealer. No payout.')
  else begin
   inc(money,bet);
   writeln('!');
  end end else if dtrick then begin
  writeln('Dealer got a five-card trick.');
  dec(money,bet);
 end else if countcards(player) > busted then begin
  write('You busted.');
  if countcards(dealer) > busted then writeln(' So did the dealer. No payout.')
  else begin
   dec(money,bet);
   writeln;
  end end else if countcards(dealer) > busted then begin
  writeln('Dealer busts.');
  inc(money,bet);
 end else if countcards(dealer) = countcards(player) then writeln('It''s a draw... No payout.')
 else if countcards(dealer) > countcards(player) then begin
  dec(money,bet);
  writeln('You lost...');
 end else begin
  inc(money,bet);
  writeln('You won!');
 end;
 writeln;
 if oldmoney>money then inc(losses) else
  if oldmoney<money then inc(wins) else
   inc(draws);
 inc(hands);
end;

begin
 directvideo:=false;
 demon:='The Demon Dealer';
 initialise;
 clrscr;
 writeln;
 writeln('Blackjack v1.00 (',lastrev,') Public Domain for SearchLight!');
 writeln;
 writeln('Welcome to the online casino! Through this door is Blackjack for one.');
 writeln;
 if paramcount=0 then begin
  writeln('Local mode (or BB is not passing user name correctly).');
  writeln;
  write('Please enter your full name: ');
  readln(temp);
  if temp='' then exit;
  writeln;
 end else temp:=paramstr(1);
 while pos('_',temp)>0 do temp[pos('_',temp)]:=' ';
 if length(temp)>35 then temp:=copy(temp,1,35);
 name:=temp;
 correct(name);
 while length(name)<35 do name:=name+' ';
 assign(scorefile,'BLAKJACK.DAT');
 reset(scorefile);
 if ioresult>0 then begin
  rewrite(scorefile);
  for loop:=1 to 10 do begin
   score[loop].points:=100;
   score[loop].name:=demon;
   write(scorefile,score[loop]);
  end;
 end else for loop:=1 to 10 do begin
  read(scorefile,score[loop]);
  if (score[loop].name=name) and (money=startamount) then begin
   money:=score[loop].points;
   writeln('You carry over your winnings of ',money,' pounds into this game.');
   writeln;
   place:=loop;
  end;
 end;
 close(scorefile);
 instructions;
 shuffle;
 repeat
  repeat
   getbet;
  until bet>=minbet;
  clrscr;
  dealhands;
  if not blackjack(player) then playertakes;
  dealertakes;
  whowon;
  clearhand(player);
  clearhand(dealer);
 until money <= 0;
 writeln('You''ve run out of money!');
 stats;
end.
