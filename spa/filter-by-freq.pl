#!/usr/bin/perl

use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

open FREQLIST, "freqlist";

binmode(FREQLIST, ":utf8");

while (<FREQLIST>) {
    /^\s*[\#!]/ and next;
    s/^\s*//; s/\s*$//;
    $hf{lc($_)} = 1 unless ((length($_) < 3 and $. > 1600) or (length($_) ==3 and $. > 3200) or (length($_) == 4 and $. > 30000));
}

while (<>) {
    $stem=$base="";
    /^\s*[\#!]/ and next;
    /^\s*LEXICON\s+(\S+)/ and $contlex=$1;
    next unless $contlex =~ /^ROOT$/;
    /^\s*LEXICON/ and print "\nLEXICON ${contlex}HF\n" and next;
    /^\s*(([^!:\+ ]*)(\+[^!: ]+)?:)?([^! ]+)/ and $stem=lc($4) and $base=lc($2);
    $stem=~tr/%^//d;
    if ($hf{$stem} or $hf{$base} or (m% /(ADJ|DET);% and $hf{$stem."o"})) {
	print }
}
