#!/usr/bin/perl -w

use strict;
use warnings;

use Lingua::DE::ASCII;
use Test::More tests => 1;

use strict;
use warnings;
use diagnostics;

my $non_ascii_chars = join("", map {chr} (128..255));

while (<DATA>) {
    chomp;
    my $ascii_text        = to_ascii($_);  
    my $iso_text          = to_latin1($ascii_text);
    my $iso_text_from_iso = to_latin1($_);
    $ascii_text !~ /[$non_ascii_chars]/o or diag("to_ascii:  $_ => $ascii_text"),fail,exit;
    $iso_text          eq $_             or diag("to_latin1:\n$_ =>\n$ascii_text =>\n$iso_text"),fail,exit;
    $iso_text_from_iso eq $_             or diag("to_latin1(latinstr):\n $_ => $iso_text_from_iso"),fail,exit;
}

ok("Special characters could be translated without errors");

1;

__DATA__
»Herr Kommandant,« sagte Herr Bantes, dieses und die anstoßenden Zimmer hatte auch Ihr Herr Vorfahre; nehmen Sie vorlieb.
»Ich hoffe indes,« sagte Waldrich, »Sie werden mit mir und meinen Leuten nicht unzufrieden sein.«
»Eine Tochter!« antwortete Frau Bantes, und zeigte auf das junge Frauenzimmer, das bescheiden die Augen zum Teller niedersenkte.
Er sagte den Eltern etwas Verbindliches, so gut er es in der ersten Bestürzung aufzubringen wusste, und war herzlich zufrieden, als der alte Papa rief: »Noch einen Löffel Sauce und dergleichen, zu Ihrem trockenen Braten da, Herr Kommandant!«
»Lass gut sein, Mama!« rief der Papa.
»Wer weiß, er wäre am Ende vielleicht auch ein Windbeutel und dergleichen geworden, wie der Georg.«
»Aber wissen Sie denn, Papa, ob Georg wirklich solch ein Windbeutel geworden, wie Sie ihn sich vorstellen?« sagte Friederike.
»Hätte der Bursch«, so schloss die Historie nutzanwendend, »auf der Universität etwas Rechtschaffenes gelernt, so wäre er nicht unter die Soldaten und dergleichen gegangen.«
»Ich weiß nicht,« entgegnete die Tochter, »ob er auf der Universität fleißig gewesen; aber ich weiß, dass er wenigstens mit guten Herzen ging, sich für eine heilige Sache zu opfern.«
»Komm mir doch nicht immer mit deiner heiligen Sache und dergleichen!« rief Herr Bantes.
Grüßen -- hier ist nur wichtig, dass ein ue mit einem sz vorkommt, da dies einmal einem eingebauten Bug entsprach
