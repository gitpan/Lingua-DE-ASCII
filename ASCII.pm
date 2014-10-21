package Lingua::DE::ASCII;

use 5.006;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw(to_ascii to_latin1);
our %EXPORT_TAGS = ( 'all' => [ @EXPORT ]);
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our $VERSION = '0.03';

my %ascii = (qw(
        � A
		� A
		� A
		� A
		� Ae
		� A
		� Ae
		� C
		� E
		� E
		� E
		� E
		� I
		� I
		� I
		� I
		� D
		� N
		� O
		� O
		� O
		� O
		� Oe
		� x
		� Oe
		� U
		� U
		� U
		� Ue
		� Y
		� Th
		� ss 	
		� a
		� a
		� a
		� a
		� ae
		� a
		� ae
		� c
		� e
		� e
		� e
		� e
		� i
		� i
		� i
		� i
		� p
		� n
		� o
		� o
		� o
		� o
		� oe
		� o
		� oe 
		� u
		� u
		� u
		� ue
		� y
		� th
		� y
		� +-
		� ^2
		� ^3
		� ue
		� P
		� .
		� ^1
        � >>
        � <<
        ),
	     ("�" => "'",
	      "�" => ",",
          "�" => "(R)",
          "�" => "(C)")
    );

# remove all unknown chars
$ascii{$_} = '' foreach (grep {!defined($ascii{$_})} map {chr} (128..255));

my $non_ascii_char = join("", map {chr} (128..255));

sub to_ascii($) {
    my $text = shift or return;
    $text =~ s/([$non_ascii_char])/$ascii{$1}/eg;
    return $text;
}

my %mutation = qw(ae �
		  Ae �
		  oe �
		  Oe �
		  ue �
		  Ue �);

my $vocal = qr/[aeiou���AEIOU���]/;
my $consonant = qr/[bcdfghjklmnpqrstvwxzBCDFGHJKLMNPQRSTVWXZ]/;
my $letter = qr/[abcdefghijklmnopqrstuvwxyz���ABCDEFGHIJKLMNOPQRSTUVWXYZ���]/;

my $prefix = qr/(?:[Aa](?:[nb]|u[fs]|bend)|
                   [Bb]e(?:reit|i||isammen|vor|)|
                   [Dd](?:a(?>f�r|neben|rum|r|)|
                       icke?|
                       rin|
                       urch|
                       rei
                    )|
                   [Ee]in|
                   [Ee]nt|
                   [Ee]r|
                   [Ff]e(?:hl|st)|
                   [Ff]rei|
                   (?:[Gg](?:erade|
                             leich|
                             ro�|
                             ross)
                   )|
                   [Ll]os|
                   [Gg]e(?:heim(?:nis)?)?|
                   [Gg]enug|
                   [Gg]ut|
                   [Hh](?:alb|eraus|erum|in(?:(?:un)?ter)?)|
                   [Kk]rank|
                   [Kk]und|
                   [Mm]ehr|
                   [Mm]it|
                   [Nn]ach|
                   [Nn]icht|
                   [Nn]eun|
                   (?:[Ss](?:ch�n|till|tramm))|
                   [Tt]ot|
                   [Uu]m|
                   [Vv][eo]r|
                   [Vv]ier(?:tel)?|
                   [Ww]e[gh]|
                   [Ww]ichtig|
                   [Uu]n|
                   [Zz]u(?:r�ck|sammen)?|
                   [Zz]wei|
                   [��]ber
                )
               /x;

my $town_with_a = qr/[Ff]uld|
                     [Aa]lton|
                     [Gg]han|
                     [Gg]oth|
                     [Ll]ausch|
                     [Mm]oden|
                     [Nn]izz|
                     [Pp]anam|
                     [Pp]arm|
                     [Rr]ig|
                     [Ss]myrn|
                     [Ss]ofi/x;

my $town_with_o = qr/[Kk]air|
                     [Oo]sl|
                     [Tt]og|
                     [Tt]oki/x;
                     
sub to_latin1($) {
    local $_ = shift or return;

	if (/[Aa]e/) {
	    s/ (?<! [Gg]al)               # Galaempf�nge
    	   (?<! [Jj]en)               # Jenaer Glas  
           (?<! Dek)                  # Dekaeder
           (?<! [^n]dek)
           (?<! [Hh]ex)
           (?<! [Ii]kos)
           (?<! [Tt]etr)
           (?<! [Oo]kt)
           (?<! [Mm]eg)
           (?<!  Pent)                # upper case, because of Gruppent�ter
           (?<! [Ss]of)               # Sofaecke
           ae
           (?!rleb)                   # e.g. Ahaerlebnis
           (?!rreg[^i])               #      Malariaerreger
           (?=\w)                     # no � at the end of a word
           (?!n\b)                    # even not if in plural
           (?!pid)                    # Choleraepidemie
           (?!in)                     # Kameraeinstellung
           (?!lit)                    # dingsda-elit
           (?!lem)                    # ...element
     	 /�/gx;
        s/(?<=[rtz])ae(?=n\b)/�/g;                # Eoz�n, Kapit�n, Souver�n
        s/phorae/phor�/g;             # Epiphor�
        s/kenae/ken�/g;               # Myken�
        s/ovae\b/ov�/g;
        s/($town_with_a)�r/$1aer/g;
        s/(?<=[mr])�(?=ls?\b|li)/ae/g; # Mari�
        s/(?<=\b[Pp]r)ae/�/g;         # Pr�...
        s/(?<=bd)ae(?=n)/�/g;         # Molybd�n
        s/(?<=[^Aa]ns)
          (?<!kens)
          (?<!eins)
          �
          (?![uetg])      # Mensaessen != Ameisens�ure, Ans�en, Ans�gen
          (?![fm]t|         # Bratens�fte, ...�mter
              ngs|        # ...-�ngste
              r[gz]|         # ...-s�rge, ...-�rzte
              c[kh]|         # ...-s�cke
              n[dgk]e|         # ...-�nderung, ...-�nge, ... -s�nke
              [lh]e          #s�le, ... s�he
          )
         /ae/gx; 
        
        s/\bAe (?!r[oiu])/�/gx;         # Ae at beginning of a word, like Aerobic != �ra, �ren
    }

	if (/[Oo]e/) {
	    # oe => �
    	s/(?<! [bB]enz )             # Benzoes�ure 
	      (?<! [Bb]ru tt)            # Bruttoertr�ge
	      (?<! [Nn]e tt)             # Nettoertr�ge
	      (?<! [^e]ot)               # Fotoelektrizit�t != Stereot�ne
	      (?<! iez)                  # Piezoelektronik
		  (?<! [Tt]herm)                 # Thermoelektrizit�t
          (?<! [Bb]i)                # Bio...
          (?<!  ktr)                 # Elektro..., 
          (?<! [Gg]astr)               
          (?<! [Mm]ikr)              # Mikro...
          (?<! [Rr]homb)
          (?<! [Tt]rapez)
	      ( [oO] e )
	      (?! u)
          (?!ffi[^gn])                     # Koeffizent  != H�ffige, Sch�ffin, ...effekt
          (?!ffek)                   # ..effekt
          (?!rot)                    # �rot
          (?!lem)                    # element
          (?!rgo)                    # ergometer
          (?!mpf)                    # empfang
    	 /$mutation{$1}/egx;
         
         s/($town_with_o)�r/$1oer/g;
	 }
    
	if (/[Uu]e/) {
        die $_ if /�/;
	    # ue => �, but take care for 'eue','�ue', 'aue', 'que'
    	s/(?:(?<![oa�eA�EqQzZ]) | 
        	 (?<=nde) | 
	         (?<=ga)  |                 # Joga�bung
    	     (?<=era) |                 # kamera�berwachte
	    	 (?<=ve)  |                 # Reserve�bung
             (?<=deo) |                 # video�ber...
             (?<=ldo) |                 # Saldo�ber...
   	 	     (?<=(?<![eEfFgGtT])[rR]e) |	  	# Re�ssieren, but not treuem
	         (?<=$vocal ne)|             # Routine�berpr�fung 
             (?<=[Vv]orne)              # vorne�ber
    	   )
           (?<![Ss]tat)              # Statue
           (?<!x)                    # Sexuelle
           ( [uU] e )
           (?= [\w\-])                   # no � at the end of a word
	       (?! i)                    # Zueilende - �-...
           (?! llst\w)                 # Spirituellste
         /$mutation{$1}/egx;
         
        s/(?<=[Zz])ue(?=g | n[dfgs] | c[hk] | be[lr] | rn[^t] | ri?ch | bl)/�/gx; 
        s/(?<=z)ue(?=rnte?[mnrs]?t?\b)/�/g;
        s/(?<=\b[Aa]bz)�(?=rnt)/ue/g;        # Abzuerntende
        s/v�n\b/vuen/g;
        s/(?<=ga)�(?=r(in)?)\b/ue/g;      # ...gauer like Argauer, Thurgauer, ...
         
        {no warnings;
         s/((?:${prefix}|en)s)?(([tT])�n(de?|\b))(?!chen|lein|lich)
          /$1 ? "$1$2" : "$3uen$4"/xgeo;# Gro�tuende, but abst�nde, St�ndchen
        }
        s/($prefix s? t)�(r(ische?[mnrs]?|
                           i?[ns](nen)?)?\b)/$1ue$2/gx;
        s/($prefix t)�(?=s?t\b|risch)/$1 ? "$1ue" : "$1�"/gxe;  # zur�cktuest, gro�tuerisch 
        s/gr�nz/gruenz/g;
        s/(?<!en)�(s?)(?!\w)/ue$1/g;   # Im deutschen enden keine Worte auf �, bis auf Ausnahmen
        s/z�(?!rich)([rs][befhiosz�])/zue$1/g; # Zuerz�hlende != z�richerisch
    
        s/([uU] e) (?=bt)/$mutation{$1}/egx;  # �bte
        s/(?<=[Dd])�(?=ll)/ue/g;              # Duell
        s/e�rt/euert/g;   # geneuert
        s/re�(?=[nv]|s?t)/reue/g;   # reuen
        
        s/([Au]ssen|
           [Dd]oppel|
           [Dd]reh|
           [Ee]ingangs|
           [Ee]ntree|
           [Ee]tagen|
           [Ff]all|
           [Gg]eheim|
           [Hh]aus|
           [Hh]inter|
           [Kk]eller|
           [Kk]irchen|
           [Kk]orridor|
           [Nn]ot|
           [Oo]fen|
           [Pp]endel|
           [Ss]aal|
           (?:[Ss]ch(?:iebe|
                       rank|
                       wing))|
           [Ss]eiten|
           [Tt]apeten|
           [Vv]erbindungs|
           [Vv]order|
           [Ww]agen|
           [Ww]ohnungs|
           [Zz]wischen) tuer (?!isch)/$1t�r/gx;
    }
	
	if (/ss/) {
   	     # russ => ru�
    	 s/(?<=(?<![dD])(?<!sau)(?<![Vv]i)[rRfF][u�])  # Brachosaurusses, Virusses
	       ss 
    	   (?! el) (?! le)                    # Br�ssel, Br�ssler
      	   (?! isch)                          # Russisch
           (?! land)                          # Ru�land
           (?! tau)
           (?! o)
          /�/gx;
          
         # ss => � with many exceptions
         s/(?<= $letter{2})
           (?<! $consonant $consonant)
           (?<! (?<! [��bBfFmMsSeE] ) [u�] )  # b��en, Fu�, ..., but Fluss
           (?<! [Mm] u)   # musst, musste, ...
           (?<! su)
           (?<! [bBdDfFhgGHkKlLmMnNpPrRsStTuUvVwWzZ] i )   # 'wissen', -nisse,
           (?<! [dgsklnt] )
           (?<! [bBdDfFgGhHiIjJkKnNtTwWlLpP] a )     # is a short vocal
           (?<! (?<![Ss]t) (?<![fF]) [rR]a)                # Rasse != Stra�e, fra�en
           (?<! [Qq]u a)
           (?<! [bBfFgGhHlLnNpPsSwW] �)          # (short vocal) Abl�sse, 
           (?<! [cCdDfFgGhHjJlLmMnNpPrsStTwWzZ] e )           # is very short vocal
           (?<! sae)                             # Mensaessen
           (?<! ion )                            # Direktionssekret�rin
           (?<! en )                             # dingenssachen 
           (?<! [fFhHoO] l o)
           (?<! (?<![gG]) [rR] o)                # Ross-Schl�chter, but Baumgro�e          
           (?<! [bBdDgGkKnNpPzZ] [o�])
           (?<! [sS]chl �)
           (?<! [bBkKuU]e)                       # Kessel
           (?<! [yj])
	       (?<! [br]r $vocal)
           (?<! [Pp]r ei)

           ss

           (?! ch )
           (?! isch )                        # gen�ssisch
           (?! t[��o])                   
           (?! tr[ao])   # Davisstra�e, but Schwei�treibende, ...-stroh
           (?! treif)
           (?! tur)   # Eissturm, but Schwei�tuch
	       (?! t�(?:ck|[hr]))  # Beweisst�ck,  Bischofsst�hle, Kursst�rze, but Schwei�t�cher
	       (?! tau?[bd])   # Preisstabilit�t, ...-stadt
           (?! ist)   # Di�tassistentin
           (?! te[pu])   # ...steppe, ...steuern
           (?! eins?\b)   # ...-sein
           (?! eit)
           (?! i[vl])    # Massiv, Fossil
           (?! l?ich)  # gr�sslich  ...sicherung
	       (?! �ge)   # Kreiss�ge
	       (?! �[tu])    # Siegess�ule, Tagess�tze
           (?! ier)   # K�rassier
           (?! ag)   # Massage, lossagen
           (?! ard)   # Bussard
           (?! p [���i]) # K�s-sp�tzle, # ...-spitze
           (?! pr[e�ai])                   # losspr�che, sprechen, sprach
           (?! [oy])
           (?! eh)    # ...-seh, setzen
           (?! itz)   # ...-sitz
           (?! ist)
           (?! ees?\b) # ... -see
           (?! aise)  # foreign words don't have an �
           (?! age)
           (?! agte)  # ...-sagte
           (?! upp)   # ...-suppe
           (?! anc) # Renaissance
           (?! egn)  # ...-segne
	      /�/gxo;
          
          s/(?<= [AaEe]u)                        # drau�en
	        ss 
            (?! [���]) 
            (?! e[ehg])                             # Chaussee, ...seh
            (?=\b|e|l)
		  /�/gxo;                    # scheu�lich 

         s/((?<=[fs][������]) |
            (?<=[Ss]p[a�])    
		   )                      # ends on long vocal plus ss, like
           ss                                  # Gef�� != Schluss
          (?! [���])
          (?! er)                           # Gef��e != F�sser
          (?! iv)
          (?=\b|e|$consonant)                 # end of word or plural or new composite (Gef��verschluss)
         /�/gxo;
         
         s/(?<=verg[�a])ss(?=e|\b)/�/g;  # verg��e

        s/(?<!chlo)                                # Schloss
          (?<! (?<![gG]) [rR] o)
          (?<! [bBpPgG] o )  # goss, Boss
          ((?<=o) |(?<=ie))          # Flo�, gro�, Grie�brei, Nu�, but no Ross-Schl�chter 
          ss
          (?! ch)
          (?! t? [���])
          (?! teu)
          (?! pr[�eai])                   # losspr�che
          (?=\b|es|$consonant)
        /�/gxo;
        s/(�u|(?<!chl)�)sschen/$1�chen/go;
        
        s/(?<=[bBeEnN][Ss]a)ss(?=\b|en)/�/g; # absa�, beisammensa�en
        s/($prefix)sass/$1sa�/g;

        s/(?:(?<=[mM][ai])|(?<=[Ss]�)|(?<=[Ss]t�)|(?<=[Ww]ei))ss(?=ge|lich)/�/go;
        
        s/(?<=[Gg]ro) ss (?=t|$vocal) (?!ist)/�/gx;   # gro�t�te, gro�-o...
        s/(?<=[Ss]pa) ss (?!ion) (?!age) (?!iv)/�/gx;         # spa�ig, but not Matth�uspassion

        
        if (/�/) {
            s/(?<=[mM][u�])�(?=te|en|er)/ss/go;
            s/($prefix|en)?([Ss]a)�([ea])/$1 ? "$1$2�$3" : "$2ss$3"/goe;  
                     # Gef�ngnisinsasse, Sassafra != aufsa�en, beisammensa�en

            s/(?<=[rR] [a�]) (?<![Gg]r�) � (?=l |e [rl](?!$vocal) | chen)/ss/gxo;      # R�sser, R�ssel
    
	        s/(?<=(?<![GgPp])
	              (?<![Bb]e)
		          (?<![Ee]nt)
    		      (?<![Vv]er)
	    	      [Rr]u
	          )
    	      �
	          (?=[ei](?![sg])(?>nnen|n|)(\b|\S{5,}))
	        /ss/gxo;  # Russe, Russin, != Pru�e, != Gru�, != Beru�en, != Entru�en, != Ru�es, != Ru�ige
            s/Ru�ki/Russki/g;
            
            #s/(?<=[rb])�(?=[tpy])/ss/g;
            s/(?<=$consonant)�(?=$consonant|y)/ss/g;
            s/(?<=[^i]e)�(?=en)/ss/g;
            s/(?<=[Aa]u)�(?=end(?!i)|etz)/ss/g;
            s/(?<!�)u�(?=el|lig)/uss/;  # Fussel
            s/(?<=[gG]lo)�/ss/g;
            s/(?<=sa)�(?=in)/ss/g;
            s/(?<=M[aou])�(?=$vocal)/ss/g;  # Massai, Massaker, Massel, Mossul, Musselin
            s/ma�(?=el|ak|ig)/mass/g;
            s/\bma�(?=en\w)/mass/g;
            s/((?:\b|$prefix)flo)�/$1ss/g;
        }
        
        s/($prefix)?scho(ss|�)/$1 ? "$1schoss" : "scho�"/ge;
	}
    
    # symbols
    s/\(R\)/�/g;
    s/\(C\)/�/g;

    # special characters
    s/<<(\D*?)>>/�$1�/g;    # if there are numbers between,
    s/>>(\D*?)<</�$1�/g;    # it could be also a mathematical/physical equation

    # foreign words
    s/cademie/cad�mie/g;
    s/rancais/ran�ais/g;
    s/leen/l�en/g;
    s/grement/gr�ment/g;
    s/lencon/len�on/g;
    s/Ancien Regime/Ancien R�gime/g;
    s/Andre(?=s?\b)/Andr�/g;
    s/Apercu/Aper�u/g;
    s/([aA])pres/$1pr�s/g;
    s/Apero/Ap�ro/g;
    s/Aragon/Arag�n/g;
    s/deco/d�co/g;
    s/socie/soci�/g;
    s/([aA])suncion/$1sunci�n/g;
    s/([aA])ttache/$1ttach�/g;
    s/Balpare/Balpar�/g;
    s/Bartok/Bart�k/g;
    s/Baumegrad/Baum�grad/g;
    s/Beaute/Beaut�/g;
    s/Epoque/�poque/g;
    s/Bj�rnson/Bj�rnson/g;
    s/Bogota/Bogot�/g;
    s/Bokmal/Bokm�l/g;
    s/Boucle/Boucl�/g;
    s/rree/rr�e/g;
    s/Bruyere/Bruy�re/g;
    s/Bebe/B�b�/g;
    s/echamel/�chamel/g;
    s/Beret/B�ret/g;
    s/([cC])afe/$1af�/g;
    s/([cC])reme/$1r�me/g;
    s/alderon/alder�n/g;
    s/Cam�s/Cam�es/g;
    s/anape/anap�/g;
    s/Cano�a/Canossa/g;
    s/celebre/c�l�bre/g;
    s/tesimo/t�simo/g;
    s/eparee/�par�e/g;
    s/Elysee/�lys�e/g;
    s/onniere/onni�re/g;
    s/Charite/Charit�/g;
    s/inee/in�e/g;
    s/hicoree/hicor�e/g;
    s/Chateau/Ch�teau/g;
    s/Cigany/Cig�ny/g;
    s/Cinecitta/Cinecitt�/g;
    s/Cliche/Clich�/g;
    s/Cloisonne/Cloisonn�/g;
    s/Cloque/Cloqu�/g;
    s/dell\'Arte/dell�Arte/g;
    s/Communique/Communiqu�/g;
    s/Consomme/Consomm�/g;
    s/d\'Ampezzo/d�Ampezzo/g;
    s/d\'Etat/d�Etat/g;
    s/Coupe/Coup�/g;
    s/Cox\'Z/Cox�/g;
    s/Craquele/Craquel�/g;
    s/roise/rois�/g;
    s/(?<! l)
      (?<! pap)
      iere\b
     /i�re/g;

    s/([cC])reme/$1r�me/g;
    s/fraiche/fra�che/g;
    s/Crepe/Cr�pe/g;
    s/Csikos/Csik�s/g;
    s/Csardas/Cs�rd�s/g;
    s/Cure/Cur�/g;
    s/Cadiz/C�diz/g;
    s/Centimo/C�ntimo/g;
    s/Cezanne/C�zanne/g;
    s/Cordoba/C�rdoba/g;

    s/Dauphine/Dauphin�/g;
    s/Dekollete/Dekollet�/g;
    s/ieces/i�ces/g;
    s/troch�u�/troch�uss/g;
    s/Drape/Drap�/g;
    s/m��(?=[et])/m�ss/g;
    s/Dvorak/Dvor�k/g;
    s/([dD])eja/$1�j�/g;
    s/habille/habill�/g;
    s/Detente/D�tente/g;

    s/Ekarte/Ekart�/g;
    s/El Nino/El Ni�o/g;
    s/Epingle/Epingl�/g;
    s/Expose/Expos�/g;
    s/Faure/Faur�/g;
    s/Filler/Fill�r/g;
    s/Siecle/Si�cle/g;
    s/l��el/l�ssel/g;
    s/Bergere/Berg�re/g;
    s/Fouche/Fouch�/g;
    s/Fouque/Fouqu�/g;
    s/elementaire/�l�mentaire/g;
    s/ternite(s?)\b/ternit�$1/g;
    s/risee/ris�e/g;
    s/roi(�|ss)e/roiss�/g;
    s/\bFrotte(?=\b|s\b)/Frott�/g;
    s/Fume/Fum�/g;
    s/([Gg])arcon/$1ar�on/g;
    s/([Gg])ef�ss/$1ef��/g;
    s/Gemechte/Gem�chte/g;
    s/Geneve/Gen�ve/g;
    s/Glace/Glac�/g;
    s/Godemiche/Godemich�/g;
    s/Godthab/Godth�b/g;
    s/(?<=[Gg])�(?=th)/oe/g;
    s/lame(?=\b|s)/lam�/g;
    s/uyere/uy�re/g;
    s/Grege/Gr�ge/g;
    s/Gulyas/Guly�s/g;
    s/abitue/abitu�/g;
    s/Haler/Hal�r/g;
    s/ornuss/ornu�/g;
    s/Horvath/Horv�th/g;
    s/Hottehue/Hotteh�/g;
    s/Hacek/H�cek/g;
    s/matoz�n/matozoen/g;
    s/chlosse(?![rsn])/chlo�e/g;
    s/doree/dor�e/g;
    s/Jerome/J�r�me/g;
    s/Kodaly/Kod�ly/g;
    s/�rzitiv/oerzitiv/g;
    s/nique/niqu�/g;
    s/Kalman/K�lm�n/g;
    s/iberte/ibert�/g;
    s/Egalite/�galit�/g;
    s/Linne/Linn�/g;
    s/([fF])asss/$1a�s/g;
    s/Lome/Lom�/g;
    s/Makore/Makor�/g;
    s/Mallarme/Mallarm�/g;
    s/aree/ar�e/g;
    s/Maitre/Ma�tre/g;
    s/([Mm]$vocal)liere\b/$1li�re/g;
    s/Mouline/Moulin�/g;
    s/Mousterien/Moust�rien/g;
    s/Malaga/M�laga/g;
    s/Meche/M�che/g;
    s/erimee/�rim�e/g;
    s/eglige/eglig�/g;
    s/eaute/eaut�/g;
    s/egritude/�gritude/g;
    s/anache/anach�/g;
    s/Pappmache/Pappmach�/g;
    s/Parana/Paran�/g;
    s/Pathetique/Path�tique/g;
    s/Merite/M�rite/g;
    s/([Pp])reuss/$1reu�/g;
    s/otege/oteg�/g;
    s/recis/r�cis/g;
    s/P�rilit�t/Puerilit�t/g;
    s/Ratine/Ratin�/g;
    s/Raye/Ray�/g;
    s/Renforce/Renforc�/g;
    s/Rene/Ren�/g;
    s/Rev�/Revue/g;
    s/Riksmal/Riksm�l/g;
    s/xupery/xup�ry/g;
    s/S(?:�|ae)ns/Sa�ns/g;
    s/Jose(?=s?\b)/Jos�/g;
    s/bernaise/b�rnaise/g;
    s/Sassnitz/Sa�nitz/g;
	s/Saone/Sa�ne/g;
	s/Sch�nt�r/Sch�ntuer/g;   # more probable
	s/ch��ling/ch�ssling/g;
	s/Senor/Se�or/g;
	s/Skues/Sk�s/g;
	s/Souffle(?=s|\b)/Souffl�/g;
	s/Spass/Spa�/g;
	s/(?<=[Cc])oupe/oup�/g;
	s/St�l\b/Sta�l/g;
	s/Suarez/Su�rez/g;
	s/Sao\b/S�o/g;
	s/Tome(?=s|\b)/Tom�/g;
	s/Seance/S�ance/g;
	s/Serac/S�rac/g;
	s/Sevres/S�vres/g;
	s/Stassfurt/Sta�furt/g;
	s/Troms�/Troms�/g;
	s/Trouvere/Trouv�re/g;
	s/T�nder/T�nder/g;
	s/ariete/ariet�/g;
	s/Welline/Wellin�/g;
	s/Yucatan/Yucat�n/g;
	s/((?<!\w)$prefix g)ass(?!$vocal)/$1a�/gx;
	s/((?<!\w)$prefix)ass/$1a�/gx;
    s/((?<!\w)$prefix)�sse/$1��e/g;
    s/(\A|\W)�sse/$1��e/g;
	s/($prefix) (?<![Ee]in)    # != einfl��en
                (?<![Ee]inzu)  #    einzufl��en
       fl��(e(n?|s?t))\b
      /$1fl�ss$2/gx;   # exception of rule
    s/(${prefix}|\b)sch��e/$1sch�sse/go; # also an exception
    {no warnings; s/($prefix)?spr��e/$1spr�sse/go;}
    s/($prefix)dr��e/$1dr�sse/g;
	s/\bass(?=\b|en\b)/a�/go;  # a�
    s/\^2/�/go;
    s/\^3/�/go;
    s/gemecht/gem�cht/go;
    s/(?<=[Hh])ue\b/�/g;
    s/a�elbe/asselbe/g;
    s/linnesch/linn�sch/g;
    s/(?<=\b[Mm]u)ss(?=t?\b)/�/g;
    s/mech(?=e|s?t)/m�ch/g;
    s/metallise/m�tallis�/g;
    s/la(\W+)la/l�$1l�/g;
    s/(?<=\b[Oo]l)e\b/�/g;
    s/peu(\W+)a(\W+)peu/peu$1�$2peu/g;
    s/reussisch/reu�isch/g;
    s/sans gene\b/sans g�ne/g;
    s/(?<=\b[Ss]a)ss(?=(en|es?t)\b)/�/g;
    s/\bskal\b/sk�l/g;
    s/(?<=\bst)ue(?=nde)/�/g;
    s/(?<=[Tt]sch)ue(?=s)/�/g;
    s/([Tt])ete-a-([Tt])ete/$1�te-�-$2�te/g;
    s/voila/voil�/g;
    s/Alandinseln/�landinseln/g;
    s/Angstr�m/�ngstr�m/g;
    s/Egalite/�galit�/g;
    s/(?<=[Ll]and)bu�e/busse/g;
    s/\ba(?=\W+(?:condition|deux mains|fonds perdu|gogo|jour|la))/�/g;
    s/a discretion/� discr�tion/g;
    s/(?<=[Bb]ai)�(?=e)/ss/g;
    s/(?<=[Hh]au)�(?=e)/ss/g;
    s/\bue\./�./g;
    s/�berflo�/�berfloss/g;
    s/�chm/Aechm/g;  # e.g. Aechmea
    s/(?<=[Aa]n)�(?=ro)/ae/g;
    s/pr�ter/praeter/g;
    s/Anaphorae/Anaphor�/g;
    s/B�deker/Baedeker/g;
    s/Aspiratae/Aspirat�/g;
    s/ham�r(?=(?:[sn]|in|innen)?\b)/hamaer/g;   # Bahamer, Bahamerin and similar
    s/(?<=[Pp])�(?=se)/ae/g;  # Bel Paese
    s/C�lius/Caelius/g;
    s/(?<=Famul)ae\b/�/g;
    s/(?<=F)�(?=ce)/ae/g;  # Faeces
    s/((Gan)?[Gg])raen/$1r�n/g;
    s/(?<=[gG]r)�(?=c(?:um|as))/ae/g;
    s/H�ckel/Haeckel/g;
    s/Intimae/Intim�/g;
    s/Kannae/Kann�/g;
    s/Klavikulae/Klavikul�/g;
    s/Kolossae/Koloss�/g;
    s/Konjunktivae/Konjunktiv�/g;
    s/L�rtes/Laertes/g;
    s/ariae\b/ari�/g;
    s/\bM�st(?![eu])/Maest/g;
    s/r�cox/raecox/g;
    s/ich�l/ichael/g;
    s/(?<=[Ss])ae(?=nger)/�/g;
    s/(?<=[Pp])�(?=lla)/ae/g;
    s/Ph�t/Phaet/g;
    s/(?<=\b[Rr]a)                         # Raphael, Raffael ...
      (ff?|ph)�l/$1ael/gx;       # != Niagaraf�llen
    s/($prefix)saesse/$1s��e/g;
    s/(?<!ph)�(?=ro[bds])/ae/g;
    s/T�kwondo/Taekwondo/g;
    s/mondaen/mond�n/g;
    s/o\.ae\./o.�./g;
    s/Al�/Aloe/g;
    s/Apn�/Apnoe/g;
    s/B�ing/Boeing/g;
    s/�c\./oec./g;
    s/Her�/Heroe/g;
    s/H�k\b/Hoek/g;
    s/z�n\b/zoen/g;
    s/obszoen/obsz�n/g;
    s/Itzeh�/Itzehoe/g;
    s/J�l/Joel/g;
    s/(?<=[Kk])�(?=du|x)/oe/g;   # Koedukation, ...
    s/Ob�/Oboe/g;
    s/(?<=i)oe(?=se?[mnr]?)/�/g;
    s/(?<=\b[Pp])�(?=bene|[mt]|sie)(?!tt)/oe/g;
    s/($prefix)p�(?=bene|[mt]|sie)(?!tt)/$1poe/g;
    s/Pr�(?=[^bps])/Proe/g;
    s/stroeme/str�me/g;
    s/Crus�/Crusoe/g;
    s/Z�(?!\w)/Zoe/g;
    s/s�ben/soeben/g;
    s/Airbu�e/Airbusse/g;
    s/pio�es/piosses/g;
    s/Cottbu�/Cottbuss/g;
    s/Globu�/Globuss/g;
    s/Beisa�e/Beisasse/g;
    s/Boru�ia/Borussia/g;
    s/Bra�/Brass/g;
    s/Cai�a/Caissa/g;
    s/(?<=c$vocal)�(?=$vocal)/ss/g;
    s/(?<=[Bb]u)�(?=erl)/ss/g;
    s/(Cr?a)�(?=ata|i|us)/$1ss/g;
    s/(?<=[CZ]erberu)�/ss/g;
    s/Croi�ant/Croissant/g;
    s/Diglo�ie/Diglossie/g;
    s/(?<=\b[Ee]i)�(?=\w)/ss/g;
    s/Elsa�/Elsass/g;
    s/��/ss�/g;
    s/rima�e/rimasse/g;
    s/olo�/oloss/g;
    s/(?<=[Ll]ai)�/ss/g;  # Laissez-faire
    s/a�achu/assachu/g;
    s/fu�(?=l[ei])/fuss/g;
    s/gro�o/grosso/g;
    s/kt�l/ktuel/g;
    s/(?<=nn)�(?=lle)/ue/g;
    s/j�z\b/juez/g;
    s/BDUe/BD�/g;
    s/n�n\b/nuen/g;
    s/g�(tt|rr)e/gue$1e/g;
    s/Bl�(?=chip|jean|movie)/Blue/g;
    s/(?<=[Mm]en)ue/�/g;
    s/B�nos/Buenos/g;
    s/Deng�/Dengue/g;
    s/n�ndo(?=\b|s)/nuendo/g;
    s/(?<=b)�(?=nt([ei]n(nen)?)?\b)/ue/g;
    s/D�nja/Duenja/g;
    s/(?<=[Dd])�tt/uett/g;
    s/man�l/manuel/g;
    s/(?<=[Ff]ond)�/ue/g;
    s/F�rte/Fuerte/g;
    s/G�ricke/Guericke/g;
    s/(?<=[Gg])�(?=rill)/ue/g;
    s/G�rnica/Guernica/g;
    s/(?<=[vs]id)�(?=n)/ue/g;
    s/fl�nz/fluenz/g;
    s/ongr�n/ongruen/g;
    s/t�nte/tuente/g;
    s/t�lle/tuelle/g;
    s/([\w ��� ��� �]+t)�ll/$1 eq lc($1) ? "$1uell" : "$1�ll"/gex; #eventuell != H�kelt�ll    
    s/Event�ll/Eventuell/g;
    s/Lang�/Langue/g;
    s/Man�l/Manuel/g;
    s/Mig�l/Miguel/g;
    s/en�tt/enuett/g;
    s/g�rite/guerite/g;
    s/in�nd/inuend/g;
    s/(?<=[Gg])�(?=st)/ue/g;
    s/P�blo/Pueblo/g;
    s/(?<=[Pp])�(?=rto)/ue/g;
    s/Re�(?=[nv])/Reue/g;
    s/Sam�l/Samuel/g;
    s/S�ve/Sueve/g;
    s/S�z/Suez/g;
    s/(?<=[Tt])�(?=rei)/ue/g;
    s/�rdingen/Uerdingen/g;
    s/�cker/Uecker/g;
    s/s�ll/suell/g;
    s/nn�ll/nnuell/g;

    s/\beinz�ng/einzueng/g;
    s/\bt�(?=s?t\b)/tue/g;
    return $_;
}

1;
__END__

=head1 NAME

Lingua::DE::ASCII - Perl extension to convert german umlauts to and from ascii

=head1 SYNOPSIS

  use Lingua::DE::ASCII;
  print to_ascii("Umlaute wie �,�,�,� oder auch � usw. " .
                 "sind nicht im ASCII Format " .
                 "und werden deshalb umgeschrieben);
  print to_latin1("Dies muesste auch rueckwaerts funktionieren ma cherie");
                 

=head1 DESCRIPTION

This module enables conversion from and to the ASCII format of german texts.

It has two methods: C<to_ascii> and C<to_latin1> which one do exactly what they 
say.

Please note that both methods take only one scalar as argument and 
not whole a list.

=head2 EXPORT

to_ascii($string)
to_latin1($string)

=head1 BUGS

That's only a stupid computer program, faced with a very hard ai problem.
So there will be some words that will be always hard to retranslate from ascii 
to latin1 encoding. A known example is the difference between "Ma�(einheit)" and
"Masseentropie" or similar. Another examples are "fl�sse" and "Fl��e"
or "(Der Schornstein) ru�e" and "Russe", "Geheimtuer(isch)" and "Geheimt�r", 
"anzu-ecken" and "anz�cken". 
Also, it's  hard to find the right spelling for the prefixes "miss-" or "mi�-".
In doubt I tried to use to more common word.
I tried it with a huge list of german words, but please tell me if you find a 
serious back-translation bug.

This module is intended for ANSI code that is e.g. different from windows coding.

Misspelled words will create a lot of extra mistakes by the program.
In doubt it's better to write with new Rechtschreibung.

The C<to_latin1> method is not very quick,
it's programmed to handle as many exceptions as possible.

I avoided localizations for character handling
(thus it should work on every computer),
but the price is that in some rare cases of words with multiple umlauts
(like "H�kelt�lle") some buggy conversions can occur.
Please tell me if you find such words.

=head1 AUTHOR

Janek Schleicher, <bigj@kamelfreund.de>

=head1 SEE ALSO

Lingua::DE::Sentence   (another cool module)

=cut
