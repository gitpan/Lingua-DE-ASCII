#!/usr/bin/perl

use strict;
use warnings;

use Term::ProgressBar;
use Test::More tests => 1;
use Lingua::DE::ASCII;

use constant CHUNK_SIZE => 250;

local @ARGV = map {"t/words_with_$_.dat"} 
    ("foreign", "ä", "ö", "ü", "ß", "ae", "oe", "ue", "ss");

chomp( my @all_words = <> );

my $progress    = Term::ProgressBar->new({
    name  => 'Words testet from the big dictionary',
    count => scalar(@all_words) / CHUNK_SIZE,
    ETA   => 'linear'
});

foreach my $chunk (0 .. scalar(@all_words) / CHUNK_SIZE) {

    # test each word in a random environment
    test_chunk_text(join "\n",
        map {join " ", $all_words[rand @all_words], $_, $all_words[rand @all_words]}
            @all_words[$chunk .. $chunk+CHUNK_SIZE-1]
    );

    # test each word following by itselfs to check
    # whether all internal regexps are working global
    test_chunk_text(join "\n",
        map "$_ $_", @all_words[$chunk .. $chunk+CHUNK_SIZE-1]
   );   

    $progress->update($chunk);
}

sub test_chunk_text {
    my $chunk_text = shift;    
    my $from_latin1_ascii = to_latin1(to_ascii($chunk_text));
    my $from_latin1       = to_latin1($chunk_text);

    assert_chunks_equal(
        $from_latin1_ascii, $chunk_text,
        "to_latin1(to_ascii(string)): "
    );
    assert_chunks_equal($from_latin1,$chunk_text, "to_latin1(string): ");

}   


sub assert_chunks_equal {
    my @got  = split /\n/, shift;
    my @orig = split /\n/, shift;
    my $msg  = shift;

    while (defined(my $got = shift(@got)) && defined(my $orig = shift(@orig))) {
        $got eq $orig or diag("$msg: $orig => $got"),fail,exit;
    }
}

ok(1);
