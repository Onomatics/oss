#!/usr/bin/perl -C31

use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

$altercations="\n";

while (<>) {
    tr/&//d;
    if (/^ *END/) {}
    elsif (s/^ *ALTERNATION +([^ ]+) +//) {
	$altercations.="LEXICON $1\n";
	s/[ \n]+/;\n/g;
	$altercations.="$_\n"; }
    elsif (/^ *(LEXICON|\n)/) {
	s/INITIAL/Root/;
	$out.=$_ }
    elsif (s/^( *;)/! $1/) {
	$out.=$_ }
    elsif (/; *$/) { # already correct format
	$out.=$_ }
    else {
	warn "parse error: $_" unless (/^ *([^ \t\n]+ +)?([^ \t\n\"]+)( +\".*\")? *\n/);
	$stem=$1; $cont=$2; $info=$3;
	$stem=~s/ +$//;
	$stem=~s/\+/%\^/g;
	$stem=~tr/~@<{*>}/ñáéíóúü/;
	$cont=~s/^INITIAL$/Root/;
	if ($info) {
	    $base=$tags="";
	    if ($info=~/\(root +([^ \(\)]+)\)/) {
		$base=$1;
		$base=~tr/~@<{*>}/ñáéíóúü/ }
	    else {
		while ($info=~m/\((aspect|case|cat|gen|mood|num-agr|number|person|pnform|tense) +([^()]+?) *\)/g) {
		    $tags.="+".uc($2) }
		$tags=~s% +%/%g;
		$tags=~s%^(.+)\+A(\+|$)%+A\1\2%;
		$tags=~/\+N($|\+)/ and $tags=~s%\+THIRD%%;
		$tags=~s/(\+N(\+.+)?)\+N($|\+)/\1\3/;
		$tags=~s%(\+[MF/]+)(\+SING|\+PLUR|\+SING/PLUR)%\2\1%;
		$tags=~s%(\+SING|\+PLUR|\+SING/PLUR)\+N%\+N\1%;
		foreach $tag (split /\+/, $tags) {
		    $alltags{"+$tag"}=1 }}}
	if ((!$base or $base eq $stem) and !$tags) {
	    $out.="$stem $cont;\n" }
	else {
	    $out.="$base$tags:$stem $cont;\n" }}}

$multichar=join " ", keys %alltags;
$multichar=~s/(^| )\+( |$)/\1\2/;

$out=~s/\nLEXICON End\n \#;\n/\n/;

print "Multichar_Symbols $multichar\n";
print $out;

$altercations=~s/^INITIAL;/Root;/gm;
print $altercations;
print "\nLEXICON End\n\#;\n";
print "\nEND\n";
