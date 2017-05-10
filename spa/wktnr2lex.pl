#!/usr/bin/perl -C31

use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

open UNREC, "eswiktionary.bases.unrec";

while (<UNREC>) {
    chomp; $unrec{$_}=1 }

while (<>) {
    m%</text>% and $base="";
    /<text[^<>]*>\{\{es\|([^{}|<>&]+)/i and $base=$1;
    if (/^===\{\{([^{}|]+)\|es/) { $pos = $1 }
    if (/^===(Sustantivo (masculino|femenino|y adjectivo)|Adverbio|Adjec?tivo|Verbo)/) { $pos = lc($1) }
    if ($base and $unrec{$base}) {
	if (/\{\{inflect\.es\.(sust\.reg|sust\.-ón|sust\.reg-cons|sust\.agudo-cons|adj\.reg-cons|sust\.ad-lib\|$base\|${base}e?s\})/) { 
	    if ($pos eq "sustantivo masculino") {
		if ($base=~s/o$//) {
		    print "${base}o:$base /MASC-N;\n" }
		else { 
		    print "${base} /MASC-N-SING-PLUR;\n" }}
	    elsif ($pos eq "sustantivo femenino") {
		if ($base=~s/a$//) {
		    print "${base}a:$base /FEM-N;\n" }
		else { 
		    print "${base} /FEM-N-SING-PLUR;\n" }}
	    elsif ($pos eq "sustantivo y adjetivo") {
		if ($base=~/a$/) {
		    print "${base} /BOTH-N-SING-PLUR;\n" }}
	    elsif ($pos eq "adjetivo") {
		if ($base=~s/o$//) {
		    print "${base} /ADJ;\n" }}}
	elsif (/\{\{inflect\.es\.adj\.reg[|\}]/) { 
	    if ($base=~s/o$//) {
		print "${base} /ADJ;\n" }}
	elsif (/^\{\{(W\.)?es\.v\.conj\.ar[{}|]/i) {
	    if ($base=~s/ar$//) {
		print "${base}ar:${base} /AR-REG;\n" }}
	elsif (/\{\{(W\.)?es\.v\.conj\.arse\|([^|=]+=[^|=]\|)*([^|{}]+)(\|([^|{}]+))?\}\}/i) {
	    $st1=$2; $st2=$5;
	    if ($base=~/arse$/) {
		if (!$st2 or $st1 eq $st2) {
		    print "${base}:${st1} /AR-REG-SE;\n" }
		else {
		    print "${base}:${st1} /AR-NO-STEM-CHANGE-1-SE;\n${base}:${st2} /AR-STEM-CHANGE;\n" }}}
	elsif (/\{\{(w\.)?es\.v\.conj\.2\.ar\|([^|=]+=[^|=]\|)*([^|{}]+)\|([^|{}]+)\}\}/i) {
	    $st1=$3; $st2=$4;
	    if ($base=~/ar$/) {
		print "${base}:${st1} /AR-NO-STEM-CHANGE-1;\n${base}:${st2} /AR-STEM-CHANGE;\n" }}
	elsif (/\{\{(w\.)?es\.v\.conj\.ir/i) {
	    if ($base=~s/ir$//) {
		print "${base}ir:${base} /IR-REG;\n" }
	    elsif ($base=~s/irse$//) {
		print "${base}irse:${base} /IR-REG-SE;\n" }}
	elsif (/\{\{(w\.)?es\.v\.conj\.er\|([^|=]+=[^|=]\|)*([^|{}]+)\|([^|{}]+)([^|=]+=[^|=]\|)*\}\}/i) {
	    $st1=$3; $st2=$4;
	    if ($base=~/er$/) {
		print "${base}:${st1} /ER-NO-STEM-CHANGE-1;\n${base}:${st2} /ER-STEM-CHANGE;\n" }}
	elsif (/\{\{(w\.)?es\.v\.conj\.er/i) {
	    if ($base=~s/er$//) {
		print "${base}er:${base} /ER-REG;\n" }
	    elsif ($base=~s/erse$//) {
		print "${base}erse:${base} /ER-REG-SE;\n" }}

	if (/^===\{*adverbio/i) {      
	    print "$base /ADV;\n" }
    }
}
