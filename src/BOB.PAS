{$A+,B-,D-,E-,F-,G+,I-,L-,N-,O-,P-,Q-,R-,S+,T-,V-,X+,Y-}
{$M 16384,0,0}

program bobharris;

const
 adj:array [0..24] of string[15]=('Sodden','Deranged','Tepid','Twisted',
  'Amphibian','Mutant','Psychedelic','Sharon''s','Coughing','Creased',
  'Electric','Hot','Slimy','Happy','Tiny','Xenophobe','Tank-top','Fishy',
  'Bearded','Butch','Liberal','Nasty','Whistling','Prehensile','Laser');
 noun:array [0..24] of string[15]=('Pustules','Nadgers','Buttocks',
  'Hornets','Cretins','Dadoes','Postmen','Breville','Panty-liner','Teeth',
  'Earwigs','Sexpots','Noses','Armpits','Bunnies','Teaspoons','Hippies',
  'Beagles','Coinage','Foundation','Breathtest','Swordfish','Vaseline',
  'Yorkshiremen','Giblets');


begin
 randomize;
 writeln('And now on Whistle Test: ',adj[random(25)],' ',noun[random(25)]);
end.
