package Lingua::DE::ASCII;

use 5.006;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw(to_ascii to_latin1);
our %EXPORT_TAGS = ( 'all' => [ @EXPORT ]);
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our $VERSION = '0.01';

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
		¹ ^1),
	     ("´" => "'",
	      "¸" => ",",
          "®" => "(R)",
          "©" => "(C)")
    );

# remove all unknown chars
$ascii{$_} = '' foreach (grep {!defined($ascii{$_})} map {chr} (128..255));

my $non_ascii_char = join("", map {chr} (128..255));

sub to_ascii {
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

my $prefix = qr/(?:[Aa](?:[nb]|u[fs])|
                   [Bb]e(?>reit|i|vor|)|
                   [Dd](?:a(?>für|neben|rum|)|
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
                   [Gg]e|
                   [Gg]ut|
                   [Hh](?:alb|eraus|erum|inunter)|
                   [Kk]rank|
                   [Mm]ehr|
                   [Mm]it|
                   [Nn]ach|
                   [Nn]eun|
                   (?:[Ss](?:chön|till|tramm))|
                   [Tt]ot|
                   [Uu]m|
                   [Vv][eo]r|
                   [Vv]ier(?:tel)?|
                   [Ww]eg|
                   [Zz]u(?:rück|sammen)?|
                   [Zz]wei|
                   [Üü]ber
                )
               /x;

sub to_latin1 {
    local $_ = shift or return;

	if (/[Aa]e/) {
	    s/ (?<! [Gg]al)               # Galaempfänge
    	   (?<! [Jj]en)               # Jenaer Glas  
           ([aA] e)
     	/ $mutation{$1}/egx;
	}

	if (/[Oo]e/) {
	    # oe => ö
    	s/(?<! [bB]enz )             # Benzoesäure 
	      (?<! [Bb]ru tt)            # Bruttoerträge
	      (?<! [Nn]e tt)             # Nettoerträge
	      (?<! [^e]ot)               # Fotoelektrizität != Stereotöne
	      (?<! iez)                  # Piezoelektronik
		  (?<! [Tt]herm)                 # Thermoelektrizität
	      ( [oO] e )
	      (?! u)
    	 /$mutation{$1}/egx;
	 }
    
	if (/[Uu]e/) {
	    # ue => ü, but take care for 'eue','äue', 'aue', 'que'
    	s/(?:(?<![aäeAÄEqQ]) | 
        	 (?<=nde) | 
	         (?<=ga)  |                 # Jogaübung
    	     (?<=era) |                 # kameraüberwachte
	    	 (?<=ve)  |                 # Reserveübung
   	 	     (?<=(?<![tT])[rR]e) |	  	# Reüssieren, but not treuem
	         (?<=$vocal ne)|             # Routineüberprüfung 
             (?<=[Vv]orne)              # vorneüber
    	   )
           (?<![Ss]tat)              # Statue
           ( [uU] e )
	       (?! i)                    # Zueilende
         /$mutation{$1}/egx;
        {no warnings;
         s/((?:${prefix}|en)s)?(tün(de?|\b))(?!chen|lein|lich)
          /$1 ? "$1$2" : "tuen$3"/xgeo;# Großtuende, but abstünde, Stündchen
        }
        #s/(?<=önt)ü(?=s?t)/ue/g;  # schöntuest
        #s/(?<=sst)ü(?=s?t\b)/ue/gx;       # großtuest, großtut
        s/($prefix t)ü(?=s?t\b|risch)/$1 ? "$1ue" : "$1ü"/gxe;  # zurücktuest, großtuerisch 
        s/grünz/gruenz/g;
        s/(?<!en)ü(s?)(?!\w)/ue$1/g;   # Im deutschen enden keine Worte auf ü, bis auf Ausnahmen
        s/zü(?!rich)([rs][befhioszö])/zue$1/g; # Zuerzählende != züricherisch
    
        s/([uU] e) (?=bt)/$mutation{$1}/egx;  # Übte
        s/(?<=[Dd])ü(?=ll)/ue/g;              # Duell
    }
	
	if (/ss/) {
   	     # russ => ruß
    	 s/(?<=(?<![dD])[rRfF][uü]) 
	       ss 
    	   (?! el) (?! le)                    # Brüssel, Brüssler
      	   (?! isch)                          # Russisch
           (?! land)                          # Rußland
          /ß/gx;
    
         # ss => ß with many excptions
         s/(?<= $letter{2})
           (?<! $consonant $consonant)
           (?<! (?<! [äÄbBfFmMsSeE] ) [uü] )  # büßen, Fuß, ..., but Fluss
           (?<! [Mm] u)   # musst, musste, ...
           (?<! su)
           (?<! [bBdDfFhHkKlLmMnNrRtTwWzZ] i )   # 'wissen', -nisse,
           (?<! [dgsklnt] )
           (?<! [bBfFgGhHkKnNtTwWlLpPiI] a )     # is a short vocal
           (?<! [bBfFgGhHlLnNpPsSwW] ä)          # (short vocal) Ablässe, 
           (?<! [dDfFlmMnNrsStTzZ] e )           # is very short vocal
           (?<! ion )                            # Direktionssekretärin
           (?<! en )                             # dingenssachen 
           (?<! [fFhHoO] l o)
           (?<! (?<![gG]) [rR] o)                # Ross-Schlächter, but Baumgroße          
           (?<! [gGnNpP] [oö])
           (?<! [sS]chl ö)
           (?<! [bBkKuU]e)                       # Kessel
	       (?<! rr $vocal)

           ss

           (?! ch )
           (?! isch )                        # genössisch
           (?! t[äöo])                   
           (?! tra)   # Davisstraße, but Schweißtreibende
           (?! tur)   # Eissturm, but Schweißtuch
	       (?! tü(?:ck|[hr]))  # Beweisstück,  Bischofsstühle, Kursstürze, but Schweißtücher
	       (?! tab)   # Preisstabilität
           (?! ist)   # Diätassistentin
           (?! iv)    # Massiv	
           (?! lich)  # grässlich  
	       (?! äge)   # Kreissäge
	       (?! ä[tu])    # Siegessäule, Tagessätze
           (?! ier)   # Kürassier
           (?! age)   # Massage
           (?! ard)   # Bussard
           (?! p [äöü]) # Käs-spätzle
           (?! prä)                   # losspräche
	      /ß/gxo;
          
          s/(?<= [AaEe]u)                        # draußen
	        ss 
            (?! [äöü]) 
            (?! ee)                             # Chaussee
            (?=\b|e|l)
		  /ß/gxo;                    # scheußlich 

         s/((?<=[fs][äöüÄÖÜ]) |
            (?<=[Ss]p[aä])    
		   )                      # ends on long vocal plus ss, like
           ss                                  # Gefäß != Schluss
          (?! [äöü])
          (?! er)                           # Gefäße != Fässer
          (?=\b|e|$consonant)                 # end of word or plural or new composite (Gefäßverschluss)
         /ß/gxo;
         
         s/(?<=erg[äa])ss(?=e|\b)/ß/g;  # vergäße

        s/(?<!chlo)                                # Schloss
          (?<! (?<![gG]) [rR] o)
          (?<! go )  # goss
          ((?<=o) |(?<=ie))          # Floß, groß, Grießbrei, Nuß, but no Ross-Schlächter 
          ss
          (?! ch)
          (?! t? [äöü])
          (?! prä)                   # losspräche
          (?=\b|es|$consonant)
        /ß/gxo;
        s/(äu|(?<!chl)ö)sschen/$1ßchen/go;
        s/chlosst/chloßt/go;  # geschloßt
        
        s/(?<=[bBeEnN][Ss]a)ss(?=\b|en)/ß/g; # absaß, beisammensaßen

        s/(?:(?<=[mM][ai])|(?<=[Ss]ü)|(?<=[Ss]tö)|(?<=[Ww]ei))ss(?=ge|lich)/ß/go;
        
        s/(?<=[Gg]ro) ss (?=t)/ß/gx;   # großtäte
        s/(?<=[Ss]pa) ss (?!ion)/ß/gx;         # spaßig, but not Matthäuspassion

        
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
	          (?=[ei](?![sg])(|n|nnen)\b)
	        /ss/gxo;  # Russe, Russin, != Pruße, != Gruß, != Berußen, != Entrußen, != Rußes, != Rußige
            
        }
        
        s/($prefix)?scho(ss|ß)/$1 ? "$1schoss" : "schoß"/ge;
	}
    
    # symbols
    s/\(R\)/®/g;
    s/\(C\)/©/g;

    # foreign words
    s/cademie/cadémie/g;
    s/rancais/rançais/g;
    s/leen/léen/g;
    s/grement/grément/g;
    s/lencon/lençon/g;
    s/Ancien Regime/Ancien Régime/g;
    s/Andre/André/g;
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
    s/Göthe/Goethe/g;
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
    s/([Mm]$vocal)liere/$1lière/g;
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
	s/\b($prefix g?)ass/$1aß/gx;
    s/\b($prefix)ässe/$1äße/g;
    s/(\A|\W)ässe/$1äße/g;
	s/($prefix) (?<![Ee]in)    # != einflößen
                (?<![Ee]inzu)  #    einzuflößen
       flöß(e(n?|s?t))\b
      /$1flöss$2/gx;   # exception of rule
    s/(${prefix}|\b)schöße/$1schösse/go; # also an exception
    {no warnings; s/($prefix)?spröße/$1sprösse/go;}
    s/($prefix)dröße/$1drösse/g;
	s/\b([Aa])ss(?=\b|en\b)/$1ß/go;  # aß
    s/\^2/²/go;
    s/\^3/³/go;
    s/gemecht/gemècht/go;
    s/Musse/Muße/go;
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
    s/a(?=\W+(?:condition|deux mains|fonds perdu|gogo|jour|la))/à/g;
    s/a discretion/à discrétion/g;
    s/(?<=[Bb]ai)ß(?=e)/ss/g;
    s/(?<=[Hh]au)ß(?=e)/ss/g;
    s/\bue\./ü./g;
    s/überfloß/überfloss/g;
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

=head2 EXPORT

to_ascii($string)
to_latin1($string)

=head1 BUGS

That's only a stupid computer program, faced with a very hard ai problem.
So there will be some words that will be always hard to retranslate from ascii 
to latin1 encoding. A known example is the difference between "Maß(einheit)" and
"Masseentropie" or similar. Another examples are "flösse" and "Flöße"
or "(Der Schornstein) ruße" and "Russe". 
Also, it's  hard to find the right spelling for the prefixes "miss-" or "miß-".
In doubt I tried to use to more common word.
I tried it with a huge list of german words, but please tell me if you find a 
serious back-translation bug.

This module is intended for ANSI code that is e.g. different from windows coding.

Misspelled words will create a lot of extra mistakes by the program.
In doubt it's better to write with new Rechtschreibung.

The C<to_latin1> method is not very quick,
it's programmed to handle as many exceptions as possible.

=head1 AUTHOR

Janek Schleicher, <bigj@kamelfreund.de>

=head1 SEE ALSO

Lingua::DE::Sentence   (another cool module)

=cut
