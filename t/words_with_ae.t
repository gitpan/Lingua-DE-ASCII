#!/usr/bin/perl -w

use strict;
use warnings;

use Lingua::DE::ASCII;
use Test::More qw/no_plan/;

use strict;
use warnings;
use diagnostics;

my $non_ascii_chars = join("", map {chr} (128..255));

while (<DATA>) {
    chomp;
    print STDERR "." if ($. % 5_000) == 1;
    $_ eq to_latin1(to_ascii($_)) or diag("$_ => " . to_latin1(to_ascii($_))),fail,exit;
}

ok("Words with ae could be translated without errors");

1;

__DATA__
Aechmea
Aechmeen
Aerial
Aeriale
Aerialen
Aerials
Aerobe
Aerobem
Aeroben
Aerober
Aerobes
Aerobic
Aerobics
Aerobier
Aerobiern
Aerobiers
Aerobiont
Aerobionten
Aerodynamik
Aeroflot
Aerogramm
Aerogramme
Aerogrammen
Aerogrammes
Aerolith
Aerolithe
Aerolithen
Aeroliths
Aerologie
Aeromechanik
Aerometer
Aerometern
Aerometers
Aeronautik
Aeroplan
Aeroplane
Aeroplanen
Aeroplanes
Aerosalon
Aerosalons
Aerosol
Aerosole
Aerosolen
Aerosols
Aerostatik
Aerotaxe
Aerotaxen
Aerotaxi
Aerotaxis
Ahaerlebnis
Ahaerlebnisse
Ahaerlebnissen
Ahaerlebnisses
Altonaer
Altonaern
Altonaers
Anaerobe
Anaerobem
Anaeroben
Anaerober
Anaerobes
Ani praeter
Ani praetern
Ani praeternaturalis
Anus praeter
Anus praeternaturalis
Aurae
Baedeker
Baedekern
Baedekers
Baedeker®
Bahamaer
Bahamaerin
Bahamaerinnen
Bahamaern
Bahamaers
Bel Paese
Belpaese
Belpaese®
Blastulae
Blastulaen
Bullae
Bullaen
Caelius
Cannae
Captatio Benevolentiae
Carcinomae
Carcinomaen
Causae
Causaen
Cellae
Cellaen
Choleraepidemie
Choleraepidemien
Clavikulae
Clavikulaen
Corneae
Corneaen
Curicula Vitae
Curiculum Vitae
Curricula Vitae
Curriculum Vitae
Danae
Dekaeder
Dekaedern
Dekaeders
Dementiae
Dementiaen
Dies Irae
Dodekaeder
Dodekaedern
Dodekaeders
Faeces
Fibulae
Fuldaer
Fuldaerin
Fuldaerinnen
Fuldaern
Fuldaers
Galaempfang
Galaempfangs
Galaempfänge
Galaempfängen
Ghanaer
Ghanaerin
Ghanaerinnen
Ghanaern
Ghanaers
Gothaer
Gothaern
Gothaers
Graecum
Graecums
Haeckel
Haeckels
Hexaeder
Hexaedern
Hexaeders
Hexaedrische
Hexaedrischem
Hexaedrischen
Hexaedrischer
Hexaedrisches
Hexaemeron
Hexaemerons
Ikosaeder
Ikosaedern
Ikosaeders
Ikositetraeder
Ikositetraedern
Ikositetraeders
Ismael
Ismaels
Israel
Israeli
Israelis
Israelische
Israelischem
Israelischen
Israelischer
Israelisches
Israelit
Israeliten
Israelitische
Israelitischem
Israelitischen
Israelitischer
Israelitisches
Israels
Jenaer
Jenaer Glas
Jenaer Glases
Jenaer Glas®
Jenaern
Jenaers
Kameraeinstellung
Kameraeinstellungen
Lacrimae Christi
Laertes
Lapsus Linguae
Lapsus Memoriae
Laternae magicae
Lauschaer Glaswaren
Maestosi
Maestoso
Maestosos
Maestri
Maestro
Maestros
Magistrae
Malariaerreger
Malariaerregern
Malariaerregers
Maturitas praecox
Maxillae
Maxillaen
Megaelektronenvolt
Megaelektronenvoltes
Mensaessen
Mensaessens
Michael
Michaela
Michaeli
Michaels
Michaelstag
Michaelstage
Michaelstagen
Michaelstages
Modenaer
Modenaern
Modenaers
Monsterae
Mount-Saint-Michael
Mount-Saint-Michaels
Nizzaer
Nizzaern
Nizzaers
Oktaeder
Oktaedern
Oktaeders
Orbitae
Paella
Paellas
Panamaer
Panamaerinnen
Panamaern
Panamaers
Parmaer
Parmaern
Parmaers
Pentaeder
Pentaedern
Pentaeders
Pentagondodekaeder
Pentagondodekaedern
Pentagondodekaeders
Phaethon
Präraffaelit
Präraffaeliten
Pulpae
Pulpaen
Rafael
Rafaels
Raffael
Raffaels
Raphael
Raphaels
Reggae
Retinae
Retinaen
Rigaer
Rigaern
Rigaers
Sankt-Michaelis-Tag
Sankt-Michaelis-Tage
Sankt-Michaelis-Tagen
Sankt-Michaelis-Tages
Smyrnaer
Smyrnaern
Smyrnaers
Sofaecke
Sofaecken
Sofiaer
Sofiaern
Sofiaers
Steppaerobic
Taekwondo
Tetraeder
Tetraedern
Tetraeders
Uvulae
Vitae
Voltaelement
Voltaelemente
Voltaelementen
Voltaelements
ad calendas graecas
aerob
aerobe
aerobem
aeroben
aerober
aerobes
aerodynamisch
aerodynamische
aerodynamischem
aerodynamischen
aerodynamischer
aerodynamischere
aerodynamischerem
aerodynamischeren
aerodynamischerer
aerodynamischeres
aerodynamisches
aerodynamischste
aerodynamischstem
aerodynamischsten
aerodynamischster
aerodynamischstes
aerostatisch
aerostatische
aerostatischem
aerostatischen
aerostatischer
aerostatisches
anaerob
anaerobe
anaerobem
anaeroben
anaerober
anaerobes
graecas
hexaedrisch
hexaedrische
hexaedrischem
hexaedrischen
hexaedrischer
hexaedrisches
israelisch
israelische
israelischem
israelischen
israelischer
israelisches
israelitisch
israelitische
israelitischem
israelitischen
israelitischer
israelitisches
oktaedrisch
oktaedrische
oktaedrischem
oktaedrischen
oktaedrischer
oktaedrisches
raffaelisch
raffaelische
raffaelischem
raffaelischen
raffaelischer
raffaelisches
vae victis
