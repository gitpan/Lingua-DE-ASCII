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
        À A
		Á A
		Â A
		Ã A
		Ä Ae
		Å A
		Æ Ae
		Ç C
		È E
		É E
		Ê E
		Ë E
		Ì I
		Í I
		Î I
		Ï I
		Ð D
		Ñ N
		Ò O
		Ó O
		Ô O
		Õ O
		Ö Oe
		× x
		Ø Oe
		Ù U
		Ú U
		Û U
		Ü Ue
		Ý Y
		Þ Th
		ß ss 	
		à a
		á a
		â a
		ã a
		ä ae
		å a
		æ ae
		ç c
		è e
		é e
		ê e
		ë e
		ì i
		í i
		î i
		ï i
		ð p
		ñ n
		ò o
		ó o
		ô o
		õ o
		ö oe
		÷ o
		ø oe 
		ù u
		ú u
		û u
		ü ue
		ý y
		þ th
		ÿ y
		± +-
		² ^2
		³ ^3
		µ ue
		¶ P
		· .
		¹ ^1
        » >>
        « <<
        ),
	     ("´" => "'",
	      "¸" => ",",
          "®" => "(R)",
          "©" => "(C)")
    );

# remove all unknown chars
$ascii{$_} = '' foreach (grep {!defined($ascii{$_})} map {chr} (128..255));

my $non_ascii_char = join("", map {chr} (128..255));

sub to_ascii($) {
    my $text = shift or return;
    $text =~ s/([$non_ascii_char])/$ascii{$1}/eg;
    return $text;
}

my %mutation = qw(ae ä
		  Ae Ä
		  oe ö
		  Oe Ö
		  ue ü
		  Ue Ü);

my $vocal = qr/[aeiouäöüAEIOUÄÖÜ]/;
my $consonant = qr/[bcdfghjklmnpqrstvwxzBCDFGHJKLMNPQRSTVWXZ]/;
my $letter = qr/[abcdefghijklmnopqrstuvwxyzäöüABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ]/;

my $prefix = qr/(?:[Aa](?:[nb]|u[fs]|bend)|
                   [Bb]e(?:reit|i||isammen|vor|)|
                   [Dd](?:a(?>für|neben|rum|r|)|
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
                             roß|
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
                   (?:[Ss](?:chön|till|tramm))|
                   [Tt]ot|
                   [Uu]m|
                   [Vv][eo]r|
                   [Vv]ier(?:tel)?|
                   [Ww]e[gh]|
                   [Ww]ichtig|
                   [Uu]n|
                   [Zz]u(?:rück|sammen)?|
                   [Zz]wei|
                   [Üü]ber
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
	    s/ (?<! [Gg]al)               # Galaempfänge
    	   (?<! [Jj]en)               # Jenaer Glas  
           (?<! Dek)                  # Dekaeder
           (?<! [^n]dek)
           (?<! [Hh]ex)
           (?<! [Ii]kos)
           (?<! [Tt]etr)
           (?<! [Oo]kt)
           (?<! [Mm]eg)
           (?<!  Pent)                # upper case, because of Gruppentäter
           (?<! [Ss]of)               # Sofaecke
           ae
           (?!rleb)                   # e.g. Ahaerlebnis
           (?!rreg[^i])               #      Malariaerreger
           (?=\w)                     # no ä at the end of a word
           (?!n\b)                    # even not if in plural
           (?!pid)                    # Choleraepidemie
           (?!in)                     # Kameraeinstellung
           (?!lit)                    # dingsda-elit
           (?!lem)                    # ...element
     	 /ä/gx;
        s/(?<=[rtz])ae(?=n\b)/ä/g;                # Eozän, Kapitän, Souverän
        s/phorae/phorä/g;             # Epiphorä
        s/kenae/kenä/g;               # Mykenä
        s/ovae\b/ovä/g;
        s/($town_with_a)är/$1aer/g;
        s/(?<=[mr])ä(?=ls?\b|li)/ae/g; # Mariä
        s/(?<=\b[Pp]r)ae/ä/g;         # Prä...
        s/(?<=bd)ae(?=n)/ä/g;         # Molybdän
        s/(?<=[^Aa]ns)
          (?<!kens)
          (?<!eins)
          ä
          (?![uetg])      # Mensaessen != Ameisensäure, Ansäen, Ansägen
          (?![fm]t|         # Bratensäfte, ...ämter
              ngs|        # ...-ängste
              r[gz]|         # ...-särge, ...-ärzte
              c[kh]|         # ...-säcke
              n[dgk]e|         # ...-änderung, ...-änge, ... -sänke
              [lh]e          #säle, ... sähe
          )
         /ae/gx; 
        
        s/\bAe (?!r[oiu])/Ä/gx;         # Ae at beginning of a word, like Aerobic != Ära, Ären
    }

	if (/[Oo]e/) {
	    # oe => ö
    	s/(?<! [bB]enz )             # Benzoesäure 
	      (?<! [Bb]ru tt)            # Bruttoerträge
	      (?<! [Nn]e tt)             # Nettoerträge
	      (?<! [^e]ot)               # Fotoelektrizität != Stereotöne
	      (?<! iez)                  # Piezoelektronik
		  (?<! [Tt]herm)                 # Thermoelektrizität
          (?<! [Bb]i)                # Bio...
          (?<!  ktr)                 # Elektro..., 
          (?<! [Gg]astr)               
          (?<! [Mm]ikr)              # Mikro...
          (?<! [Rr]homb)
          (?<! [Tt]rapez)
	      ( [oO] e )
	      (?! u)
          (?!ffi[^gn])                     # Koeffizent  != Höffige, Schöffin, ...effekt
          (?!ffek)                   # ..effekt
          (?!rot)                    # örot
          (?!lem)                    # element
          (?!rgo)                    # ergometer
          (?!mpf)                    # empfang
    	 /$mutation{$1}/egx;
         
         s/($town_with_o)ör/$1oer/g;
	 }
    
	if (/[Uu]e/) {
        die $_ if /ß/;
	    # ue => ü, but take care for 'eue','äue', 'aue', 'que'
    	s/(?:(?<![oaäeAÄEqQzZ]) | 
        	 (?<=nde) | 
	         (?<=ga)  |                 # Jogaübung
    	     (?<=era) |                 # kameraüberwachte
	    	 (?<=ve)  |                 # Reserveübung
             (?<=deo) |                 # videoüber...
             (?<=ldo) |                 # Saldoüber...
   	 	     (?<=(?<![eEfFgGtT])[rR]e) |	  	# Reüssieren, but not treuem
	         (?<=$vocal ne)|             # Routineüberprüfung 
             (?<=[Vv]orne)              # vorneüber
    	   )
           (?<![Ss]tat)              # Statue
           (?<!x)                    # Sexuelle
           ( [uU] e )
           (?= [\w\-])                   # no ü at the end of a word
	       (?! i)                    # Zueilende - Ü-...
           (?! llst\w)                 # Spirituellste
         /$mutation{$1}/egx;
         
        s/(?<=[Zz])ue(?=g | n[dfgs] | c[hk] | be[lr] | rn[^t] | ri?ch | bl)/ü/gx; 
        s/(?<=z)ue(?=rnte?[mnrs]?t?\b)/ü/g;
        s/(?<=\b[Aa]bz)ü(?=rnt)/ue/g;        # Abzuerntende
        s/vün\b/vuen/g;
        s/(?<=ga)ü(?=r(in)?)\b/ue/g;      # ...gauer like Argauer, Thurgauer, ...
         
        {no warnings;
         s/((?:${prefix}|en)s)?(([tT])ün(de?|\b))(?!chen|lein|lich)
          /$1 ? "$1$2" : "$3uen$4"/xgeo;# Großtuende, but abstünde, Stündchen
        }
        s/($prefix s? t)ü(r(ische?[mnrs]?|
                           i?[ns](nen)?)?\b)/$1ue$2/gx;
        s/($prefix t)ü(?=s?t\b|risch)/$1 ? "$1ue" : "$1ü"/gxe;  # zurücktuest, großtuerisch 
        s/grünz/gruenz/g;
        s/(?<!en)ü(s?)(?!\w)/ue$1/g;   # Im deutschen enden keine Worte auf ü, bis auf Ausnahmen
        s/zü(?!rich)([rs][befhioszö])/zue$1/g; # Zuerzählende != züricherisch
    
        s/([uU] e) (?=bt)/$mutation{$1}/egx;  # Übte
        s/(?<=[Dd])ü(?=ll)/ue/g;              # Duell
        s/eürt/euert/g;   # geneuert
        s/reü(?=[nv]|s?t)/reue/g;   # reuen
        
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
           [Zz]wischen) tuer (?!isch)/$1tür/gx;
    }
	
	if (/ss/) {
   	     # russ => ruß
    	 s/(?<=(?<![dD])(?<!sau)(?<![Vv]i)[rRfF][uü])  # Brachosaurusses, Virusses
	       ss 
    	   (?! el) (?! le)                    # Brüssel, Brüssler
      	   (?! isch)                          # Russisch
           (?! land)                          # Rußland
           (?! tau)
           (?! o)
          /ß/gx;
          
         # ss => ß with many exceptions
         s/(?<= $letter{2})
           (?<! $consonant $consonant)
           (?<! (?<! [äÄbBfFmMsSeE] ) [uü] )  # büßen, Fuß, ..., but Fluss
           (?<! [Mm] u)   # musst, musste, ...
           (?<! su)
           (?<! [bBdDfFhgGHkKlLmMnNpPrRsStTuUvVwWzZ] i )   # 'wissen', -nisse,
           (?<! [dgsklnt] )
           (?<! [bBdDfFgGhHiIjJkKnNtTwWlLpP] a )     # is a short vocal
           (?<! (?<![Ss]t) (?<![fF]) [rR]a)                # Rasse != Straße, fraßen
           (?<! [Qq]u a)
           (?<! [bBfFgGhHlLnNpPsSwW] ä)          # (short vocal) Ablässe, 
           (?<! [cCdDfFgGhHjJlLmMnNpPrsStTwWzZ] e )           # is very short vocal
           (?<! sae)                             # Mensaessen
           (?<! ion )                            # Direktionssekretärin
           (?<! en )                             # dingenssachen 
           (?<! [fFhHoO] l o)
           (?<! (?<![gG]) [rR] o)                # Ross-Schlächter, but Baumgroße          
           (?<! [bBdDgGkKnNpPzZ] [oö])
           (?<! [sS]chl ö)
           (?<! [bBkKuU]e)                       # Kessel
           (?<! [yj])
	       (?<! [br]r $vocal)
           (?<! [Pp]r ei)

           ss

           (?! ch )
           (?! isch )                        # genössisch
           (?! t[äöo])                   
           (?! tr[ao])   # Davisstraße, but Schweißtreibende, ...-stroh
           (?! treif)
           (?! tur)   # Eissturm, but Schweißtuch
	       (?! tü(?:ck|[hr]))  # Beweisstück,  Bischofsstühle, Kursstürze, but Schweißtücher
	       (?! tau?[bd])   # Preisstabilität, ...-stadt
           (?! ist)   # Diätassistentin
           (?! te[pu])   # ...steppe, ...steuern
           (?! eins?\b)   # ...-sein
           (?! eit)
           (?! i[vl])    # Massiv, Fossil
           (?! l?ich)  # grässlich  ...sicherung
	       (?! äge)   # Kreissäge
	       (?! ä[tu])    # Siegessäule, Tagessätze
           (?! ier)   # Kürassier
           (?! ag)   # Massage, lossagen
           (?! ard)   # Bussard
           (?! p [äöüi]) # Käs-spätzle, # ...-spitze
           (?! pr[eäai])                   # losspräche, sprechen, sprach
           (?! [oy])
           (?! eh)    # ...-seh, setzen
           (?! itz)   # ...-sitz
           (?! ist)
           (?! ees?\b) # ... -see
           (?! aise)  # foreign words don't have an ß
           (?! age)
           (?! agte)  # ...-sagte
           (?! upp)   # ...-suppe
           (?! anc) # Renaissance
           (?! egn)  # ...-segne
	      /ß/gxo;
          
          s/(?<= [AaEe]u)                        # draußen
	        ss 
            (?! [äöü]) 
            (?! e[ehg])                             # Chaussee, ...seh
            (?=\b|e|l)
		  /ß/gxo;                    # scheußlich 

         s/((?<=[fs][äöüÄÖÜ]) |
            (?<=[Ss]p[aä])    
		   )                      # ends on long vocal plus ss, like
           ss                                  # Gefäß != Schluss
          (?! [äöü])
          (?! er)                           # Gefäße != Fässer
          (?! iv)
          (?=\b|e|$consonant)                 # end of word or plural or new composite (Gefäßverschluss)
         /ß/gxo;
         
         s/(?<=verg[äa])ss(?=e|\b)/ß/g;  # vergäße

        s/(?<!chlo)                                # Schloss
          (?<! (?<![gG]) [rR] o)
          (?<! [bBpPgG] o )  # goss, Boss
          ((?<=o) |(?<=ie))          # Floß, groß, Grießbrei, Nuß, but no Ross-Schlächter 
          ss
          (?! ch)
          (?! t? [äöü])
          (?! teu)
          (?! pr[äeai])                   # losspräche
          (?=\b|es|$consonant)
        /ß/gxo;
        s/(äu|(?<!chl)ö)sschen/$1ßchen/go;
        
        s/(?<=[bBeEnN][Ss]a)ss(?=\b|en)/ß/g; # absaß, beisammensaßen
        s/($prefix)sass/$1saß/g;

        s/(?:(?<=[mM][ai])|(?<=[Ss]ü)|(?<=[Ss]tö)|(?<=[Ww]ei))ss(?=ge|lich)/ß/go;
        
        s/(?<=[Gg]ro) ss (?=t|$vocal) (?!ist)/ß/gx;   # großtäte, groß-o...
        s/(?<=[Ss]pa) ss (?!ion) (?!age) (?!iv)/ß/gx;         # spaßig, but not Matthäuspassion

        
        if (/ß/) {
            s/(?<=[mM][uü])ß(?=te|en|er)/ss/go;
            s/($prefix|en)?([Ss]a)ß([ea])/$1 ? "$1$2ß$3" : "$2ss$3"/goe;  
                     # Gefängnisinsasse, Sassafra != aufsaßen, beisammensaßen

            s/(?<=[rR] [aö]) (?<![Gg]rö) ß (?=l |e [rl](?!$vocal) | chen)/ss/gxo;      # Rösser, Rössel
    
	        s/(?<=(?<![GgPp])
	              (?<![Bb]e)
		          (?<![Ee]nt)
    		      (?<![Vv]er)
	    	      [Rr]u
	          )
    	      ß
	          (?=[ei](?![sg])(?>nnen|n|)(\b|\S{5,}))
	        /ss/gxo;  # Russe, Russin, != Pruße, != Gruß, != Berußen, != Entrußen, != Rußes, != Rußige
            s/Rußki/Russki/g;
            
            #s/(?<=[rb])ß(?=[tpy])/ss/g;
            s/(?<=$consonant)ß(?=$consonant|y)/ss/g;
            s/(?<=[^i]e)ß(?=en)/ss/g;
            s/(?<=[Aa]u)ß(?=end(?!i)|etz)/ss/g;
            s/(?<!ä)uß(?=el|lig)/uss/;  # Fussel
            s/(?<=[gG]lo)ß/ss/g;
            s/(?<=sa)ß(?=in)/ss/g;
            s/(?<=M[aou])ß(?=$vocal)/ss/g;  # Massai, Massaker, Massel, Mossul, Musselin
            s/maß(?=el|ak|ig)/mass/g;
            s/\bmaß(?=en\w)/mass/g;
            s/((?:\b|$prefix)flo)ß/$1ss/g;
        }
        
        s/($prefix)?scho(ss|ß)/$1 ? "$1schoss" : "schoß"/ge;
	}
    
    # symbols
    s/\(R\)/®/g;
    s/\(C\)/©/g;

    # special characters
    s/<<(\D*?)>>/«$1»/g;    # if there are numbers between,
    s/>>(\D*?)<</»$1«/g;    # it could be also a mathematical/physical equation

    # foreign words
    s/cademie/cadémie/g;
    s/rancais/rançais/g;
    s/leen/léen/g;
    s/grement/grément/g;
    s/lencon/lençon/g;
    s/Ancien Regime/Ancien Régime/g;
    s/Andre(?=s?\b)/André/g;
    s/Apercu/Aperçu/g;
    s/([aA])pres/$1près/g;
    s/Apero/Apéro/g;
    s/Aragon/Aragón/g;
    s/deco/déco/g;
    s/socie/socié/g;
    s/([aA])suncion/$1sunción/g;
    s/([aA])ttache/$1ttaché/g;
    s/Balpare/Balparé/g;
    s/Bartok/Bartók/g;
    s/Baumegrad/Baumégrad/g;
    s/Beaute/Beauté/g;
    s/Epoque/Époque/g;
    s/Björnson/Bjørnson/g;
    s/Bogota/Bogotá/g;
    s/Bokmal/Bokmål/g;
    s/Boucle/Bouclé/g;
    s/rree/rrée/g;
    s/Bruyere/Bruyère/g;
    s/Bebe/Bébé/g;
    s/echamel/échamel/g;
    s/Beret/Béret/g;
    s/([cC])afe/$1afé/g;
    s/([cC])reme/$1rème/g;
    s/alderon/alderón/g;
    s/Camös/Camões/g;
    s/anape/anapé/g;
    s/Canoßa/Canossa/g;
    s/celebre/célèbre/g;
    s/tesimo/tésimo/g;
    s/eparee/éparée/g;
    s/Elysee/Élysée/g;
    s/onniere/onnière/g;
    s/Charite/Charité/g;
    s/inee/inée/g;
    s/hicoree/hicorée/g;
    s/Chateau/Château/g;
    s/Cigany/Cigány/g;
    s/Cinecitta/Cinecittà/g;
    s/Cliche/Cliché/g;
    s/Cloisonne/Cloisonné/g;
    s/Cloque/Cloqué/g;
    s/dell\'Arte/dell´Arte/g;
    s/Communique/Communiqué/g;
    s/Consomme/Consommé/g;
    s/d\'Ampezzo/d´Ampezzo/g;
    s/d\'Etat/d´Etat/g;
    s/Coupe/Coupé/g;
    s/Cox\'Z/Cox´/g;
    s/Craquele/Craquelé/g;
    s/roise/roisé/g;
    s/(?<! l)
      (?<! pap)
      iere\b
     /ière/g;

    s/([cC])reme/$1rème/g;
    s/fraiche/fraîche/g;
    s/Crepe/Crêpe/g;
    s/Csikos/Csikós/g;
    s/Csardas/Csárdás/g;
    s/Cure/Curé/g;
    s/Cadiz/Cádiz/g;
    s/Centimo/Céntimo/g;
    s/Cezanne/Cézanne/g;
    s/Cordoba/Córdoba/g;

    s/Dauphine/Dauphiné/g;
    s/Dekollete/Dekolleté/g;
    s/ieces/ièces/g;
    s/trochäuß/trochäuss/g;
    s/Drape/Drapé/g;
    s/müß(?=[et])/müss/g;
    s/Dvorak/Dvorák/g;
    s/([dD])eja/$1éjà/g;
    s/habille/habillé/g;
    s/Detente/Détente/g;

    s/Ekarte/Ekarté/g;
    s/El Nino/El Niño/g;
    s/Epingle/Epinglé/g;
    s/Expose/Exposé/g;
    s/Faure/Fauré/g;
    s/Filler/Fillér/g;
    s/Siecle/Siècle/g;
    s/lößel/lössel/g;
    s/Bergere/Bergère/g;
    s/Fouche/Fouché/g;
    s/Fouque/Fouqué/g;
    s/elementaire/élémentaire/g;
    s/ternite(s?)\b/ternité$1/g;
    s/risee/risée/g;
    s/roi(ß|ss)e/roissé/g;
    s/\bFrotte(?=\b|s\b)/Frotté/g;
    s/Fume/Fumé/g;
    s/([Gg])arcon/$1arçon/g;
    s/([Gg])efäss/$1efäß/g;
    s/Gemechte/Gemèchte/g;
    s/Geneve/Genève/g;
    s/Glace/Glacé/g;
    s/Godemiche/Godemiché/g;
    s/Godthab/Godthåb/g;
    s/(?<=[Gg])ö(?=th)/oe/g;
    s/lame(?=\b|s)/lamé/g;
    s/uyere/uyère/g;
    s/Grege/Grège/g;
    s/Gulyas/Gulyás/g;
    s/abitue/abitué/g;
    s/Haler/Halér/g;
    s/ornuss/ornuß/g;
    s/Horvath/Horváth/g;
    s/Hottehue/Hottehü/g;
    s/Hacek/Hácek/g;
    s/matozön/matozoen/g;
    s/chlosse(?![rsn])/chloße/g;
    s/doree/dorée/g;
    s/Jerome/Jérôme/g;
    s/Kodaly/Kodály/g;
    s/örzitiv/oerzitiv/g;
    s/nique/niqué/g;
    s/Kalman/Kálmán/g;
    s/iberte/iberté/g;
    s/Egalite/Égalité/g;
    s/Linne/Linné/g;
    s/([fF])asss/$1aßs/g;
    s/Lome/Lomé/g;
    s/Makore/Makoré/g;
    s/Mallarme/Mallarmé/g;
    s/aree/arée/g;
    s/Maitre/Maître/g;
    s/([Mm]$vocal)liere\b/$1lière/g;
    s/Mouline/Mouliné/g;
    s/Mousterien/Moustérien/g;
    s/Malaga/Málaga/g;
    s/Meche/Mèche/g;
    s/erimee/érimée/g;
    s/eglige/egligé/g;
    s/eaute/eauté/g;
    s/egritude/égritude/g;
    s/anache/anaché/g;
    s/Pappmache/Pappmaché/g;
    s/Parana/Paraná/g;
    s/Pathetique/Pathétique/g;
    s/Merite/Mérite/g;
    s/([Pp])reuss/$1reuß/g;
    s/otege/otegé/g;
    s/recis/récis/g;
    s/Pürilität/Puerilität/g;
    s/Ratine/Ratiné/g;
    s/Raye/Rayé/g;
    s/Renforce/Renforcé/g;
    s/Rene/René/g;
    s/Revü/Revue/g;
    s/Riksmal/Riksmål/g;
    s/xupery/xupéry/g;
    s/S(?:ä|ae)ns/Saëns/g;
    s/Jose(?=s?\b)/José/g;
    s/bernaise/bérnaise/g;
    s/Sassnitz/Saßnitz/g;
	s/Saone/Saône/g;
	s/Schöntür/Schöntuer/g;   # more probable
	s/chößling/chössling/g;
	s/Senor/Señor/g;
	s/Skues/Sküs/g;
	s/Souffle(?=s|\b)/Soufflé/g;
	s/Spass/Spaß/g;
	s/(?<=[Cc])oupe/oupé/g;
	s/Stäl\b/Staël/g;
	s/Suarez/Suárez/g;
	s/Sao\b/São/g;
	s/Tome(?=s|\b)/Tomé/g;
	s/Seance/Séance/g;
	s/Serac/Sérac/g;
	s/Sevres/Sévres/g;
	s/Stassfurt/Staßfurt/g;
	s/Tromsö/Tromsø/g;
	s/Trouvere/Trouvère/g;
	s/Tönder/Tønder/g;
	s/ariete/arieté/g;
	s/Welline/Welliné/g;
	s/Yucatan/Yucatán/g;
	s/((?<!\w)$prefix g)ass(?!$vocal)/$1aß/gx;
	s/((?<!\w)$prefix)ass/$1aß/gx;
    s/((?<!\w)$prefix)ässe/$1äße/g;
    s/(\A|\W)ässe/$1äße/g;
	s/($prefix) (?<![Ee]in)    # != einflößen
                (?<![Ee]inzu)  #    einzuflößen
       flöß(e(n?|s?t))\b
      /$1flöss$2/gx;   # exception of rule
    s/(${prefix}|\b)schöße/$1schösse/go; # also an exception
    {no warnings; s/($prefix)?spröße/$1sprösse/go;}
    s/($prefix)dröße/$1drösse/g;
	s/\bass(?=\b|en\b)/aß/go;  # aß
    s/\^2/²/go;
    s/\^3/³/go;
    s/gemecht/gemècht/go;
    s/(?<=[Hh])ue\b/ü/g;
    s/aßelbe/asselbe/g;
    s/linnesch/linnésch/g;
    s/(?<=\b[Mm]u)ss(?=t?\b)/ß/g;
    s/mech(?=e|s?t)/mèch/g;
    s/metallise/métallisé/g;
    s/la(\W+)la/là$1là/g;
    s/(?<=\b[Oo]l)e\b/é/g;
    s/peu(\W+)a(\W+)peu/peu$1à$2peu/g;
    s/reussisch/reußisch/g;
    s/sans gene\b/sans gêne/g;
    s/(?<=\b[Ss]a)ss(?=(en|es?t)\b)/ß/g;
    s/\bskal\b/skål/g;
    s/(?<=\bst)ue(?=nde)/ü/g;
    s/(?<=[Tt]sch)ue(?=s)/ü/g;
    s/([Tt])ete-a-([Tt])ete/$1ête-à-$2ête/g;
    s/voila/voilà/g;
    s/Alandinseln/Ålandinseln/g;
    s/Angström/Ångström/g;
    s/Egalite/Égalité/g;
    s/(?<=[Ll]and)buße/busse/g;
    s/\ba(?=\W+(?:condition|deux mains|fonds perdu|gogo|jour|la))/à/g;
    s/a discretion/à discrétion/g;
    s/(?<=[Bb]ai)ß(?=e)/ss/g;
    s/(?<=[Hh]au)ß(?=e)/ss/g;
    s/\bue\./ü./g;
    s/überfloß/überfloss/g;
    s/Ächm/Aechm/g;  # e.g. Aechmea
    s/(?<=[Aa]n)ä(?=ro)/ae/g;
    s/präter/praeter/g;
    s/Anaphorae/Anaphorä/g;
    s/Bädeker/Baedeker/g;
    s/Aspiratae/Aspiratä/g;
    s/hamär(?=(?:[sn]|in|innen)?\b)/hamaer/g;   # Bahamer, Bahamerin and similar
    s/(?<=[Pp])ä(?=se)/ae/g;  # Bel Paese
    s/Cälius/Caelius/g;
    s/(?<=Famul)ae\b/ä/g;
    s/(?<=F)ä(?=ce)/ae/g;  # Faeces
    s/((Gan)?[Gg])raen/$1rän/g;
    s/(?<=[gG]r)ä(?=c(?:um|as))/ae/g;
    s/Häckel/Haeckel/g;
    s/Intimae/Intimä/g;
    s/Kannae/Kannä/g;
    s/Klavikulae/Klavikulä/g;
    s/Kolossae/Kolossä/g;
    s/Konjunktivae/Konjunktivä/g;
    s/Lärtes/Laertes/g;
    s/ariae\b/ariä/g;
    s/\bMäst(?![eu])/Maest/g;
    s/räcox/raecox/g;
    s/ichäl/ichael/g;
    s/(?<=[Ss])ae(?=nger)/ä/g;
    s/(?<=[Pp])ä(?=lla)/ae/g;
    s/Phät/Phaet/g;
    s/(?<=\b[Rr]a)                         # Raphael, Raffael ...
      (ff?|ph)äl/$1ael/gx;       # != Niagarafällen
    s/($prefix)saesse/$1säße/g;
    s/(?<!ph)ä(?=ro[bds])/ae/g;
    s/Täkwondo/Taekwondo/g;
    s/mondaen/mondän/g;
    s/o\.ae\./o.ä./g;
    s/Alö/Aloe/g;
    s/Apnö/Apnoe/g;
    s/Böing/Boeing/g;
    s/öc\./oec./g;
    s/Herö/Heroe/g;
    s/Hök\b/Hoek/g;
    s/zön\b/zoen/g;
    s/obszoen/obszön/g;
    s/Itzehö/Itzehoe/g;
    s/Jöl/Joel/g;
    s/(?<=[Kk])ö(?=du|x)/oe/g;   # Koedukation, ...
    s/Obö/Oboe/g;
    s/(?<=i)oe(?=se?[mnr]?)/ö/g;
    s/(?<=\b[Pp])ö(?=bene|[mt]|sie)(?!tt)/oe/g;
    s/($prefix)pö(?=bene|[mt]|sie)(?!tt)/$1poe/g;
    s/Prö(?=[^bps])/Proe/g;
    s/stroeme/ströme/g;
    s/Crusö/Crusoe/g;
    s/Zö(?!\w)/Zoe/g;
    s/söben/soeben/g;
    s/Airbuße/Airbusse/g;
    s/pioßes/piosses/g;
    s/Cottbuß/Cottbuss/g;
    s/Globuß/Globuss/g;
    s/Beisaße/Beisasse/g;
    s/Borußia/Borussia/g;
    s/Braß/Brass/g;
    s/Caißa/Caissa/g;
    s/(?<=c$vocal)ß(?=$vocal)/ss/g;
    s/(?<=[Bb]u)ß(?=erl)/ss/g;
    s/(Cr?a)ß(?=ata|i|us)/$1ss/g;
    s/(?<=[CZ]erberu)ß/ss/g;
    s/Croißant/Croissant/g;
    s/Digloßie/Diglossie/g;
    s/(?<=\b[Ee]i)ß(?=\w)/ss/g;
    s/Elsaß/Elsass/g;
    s/ßé/ssé/g;
    s/rimaße/rimasse/g;
    s/oloß/oloss/g;
    s/(?<=[Ll]ai)ß/ss/g;  # Laissez-faire
    s/aßachu/assachu/g;
    s/fuß(?=l[ei])/fuss/g;
    s/großo/grosso/g;
    s/ktül/ktuel/g;
    s/(?<=nn)ü(?=lle)/ue/g;
    s/jüz\b/juez/g;
    s/BDUe/BDÜ/g;
    s/nün\b/nuen/g;
    s/gü(tt|rr)e/gue$1e/g;
    s/Blü(?=chip|jean|movie)/Blue/g;
    s/(?<=[Mm]en)ue/ü/g;
    s/Bünos/Buenos/g;
    s/Dengü/Dengue/g;
    s/nündo(?=\b|s)/nuendo/g;
    s/(?<=b)ü(?=nt([ei]n(nen)?)?\b)/ue/g;
    s/Dünja/Duenja/g;
    s/(?<=[Dd])ütt/uett/g;
    s/manül/manuel/g;
    s/(?<=[Ff]ond)ü/ue/g;
    s/Fürte/Fuerte/g;
    s/Güricke/Guericke/g;
    s/(?<=[Gg])ü(?=rill)/ue/g;
    s/Gürnica/Guernica/g;
    s/(?<=[vs]id)ü(?=n)/ue/g;
    s/flünz/fluenz/g;
    s/ongrün/ongruen/g;
    s/tünte/tuente/g;
    s/tülle/tuelle/g;
    s/([\w äöü ÄÖÜ ß]+t)üll/$1 eq lc($1) ? "$1uell" : "$1üll"/gex; #eventuell != Häkeltüll    
    s/Eventüll/Eventuell/g;
    s/Langü/Langue/g;
    s/Manül/Manuel/g;
    s/Migül/Miguel/g;
    s/enütt/enuett/g;
    s/gürite/guerite/g;
    s/inünd/inuend/g;
    s/(?<=[Gg])ü(?=st)/ue/g;
    s/Püblo/Pueblo/g;
    s/(?<=[Pp])ü(?=rto)/ue/g;
    s/Reü(?=[nv])/Reue/g;
    s/Samül/Samuel/g;
    s/Süve/Sueve/g;
    s/Süz/Suez/g;
    s/(?<=[Tt])ü(?=rei)/ue/g;
    s/Ürdingen/Uerdingen/g;
    s/Ücker/Uecker/g;
    s/süll/suell/g;
    s/nnüll/nnuell/g;

    s/\beinzüng/einzueng/g;
    s/\btü(?=s?t\b)/tue/g;
    return $_;
}

1;
__END__

=head1 NAME

Lingua::DE::ASCII - Perl extension to convert german umlauts to and from ascii

=head1 SYNOPSIS

  use Lingua::DE::ASCII;
  print to_ascii("Umlaute wie ä,ö,ü,ß oder auch é usw. " .
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
to latin1 encoding. A known example is the difference between "Maß(einheit)" and
"Masseentropie" or similar. Another examples are "flösse" and "Flöße"
or "(Der Schornstein) ruße" and "Russe", "Geheimtuer(isch)" and "Geheimtür", 
"anzu-ecken" and "anzücken". 
Also, it's  hard to find the right spelling for the prefixes "miss-" or "miß-".
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
(like "Häkeltülle") some buggy conversions can occur.
Please tell me if you find such words.

=head1 AUTHOR

Janek Schleicher, <bigj@kamelfreund.de>

=head1 SEE ALSO

Lingua::DE::Sentence   (another cool module)

=cut
