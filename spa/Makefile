all: spa.hfst spa-decompose.hfst spa.test.diff spa-decompose.test.diff

test: spa.test.diff spa-decompose.test.diff

install: install-spa.hfst install-spa-decompose.hfst

#install-%.hfst: %.hfst
#	FILE=/opt/hfst/lex/archive/$<.`date +%F`; cp -f $< $$FILE; rm -f /opt/hfst/lex/$<; ln -s $$FILE /opt/hfst/lex/$<

install-spa.hfst: spa.hfst spa.test
	FILE=/opt/hfst/lex/archive/$<.`date +%F`; cp -f $< $$FILE; rm -f /opt/hfst/lex/$<; ln -s $$FILE /opt/hfst/lex/$<
	cp -f $< ../lexicons/es.hfst
	cp -f spa.test spa.test.official

install-spa-decompose.hfst: spa-decompose.hfst spa-decompose.test
	FILE=/opt/hfst/lex/archive/$<.`date +%F`; cp -f $< $$FILE; rm -f /opt/hfst/lex/$<; ln -s $$FILE /opt/hfst/lex/$<
	cp -f $< ../lexicons/es-decompose.hfst
	cp -f spa-decompose.test spa-decompose.test.official

spagen.hfst: spa.fst-txt
	hfst-txt2fst -i $< | hfst-invert | hfst-fst2fst -O > $@

sp%.hfst: sp%.fst-txt
	hfst-txt2fst -i $< | hfst-fst2fst -O > $@

spa.fst-txt: spanish.fst spanish.lex
	foma -l spanish$*.fst -e 'regex Analysis;' -e 'write att > $@' -s

spa-decompose.fst-txt: spanish-decompose.fst spanish-decompose.lex
	foma -l spanish-decompose.fst -e 'regex Decomposition;' -e 'write att > $@' -s

eswiktionary.bases.unrec:
	tr 'A-Z ' 'a-z_' < /j/corpora/text/spa/eswiktionary.bases | hfst-lookup spa.hfst | grep -F '+?' | cut -f1 | sort -u > $@

eswiktionary.lex: wktnr2lex.pl /j/wiktionary/eswiktionary-20130328-pages-articles.xml eswiktionary.bases.unrec
	./wktnr2lex.pl /j/wiktionary/eswiktionary-20130328-pages-articles.xml | sort -u > $@

# spanish.lex: kimmo2fst.pl newspan.dic eswiktionary.lex
#	./$^ > $@

%-decompose.lex: %.lex
	perl -pe 's/^!DECOMPOSE[ 	]*//' $< > $@

spanish-decompose.lex: spanish.lex ./filter-by-freq.pl freqlist Makefile
	perl -pe 's/^!DECOMPOSE[ 	]*//; /^ *LEXICON +([^ \n]+)/ and $$contlex=$$1; if ($$contlex=~/^ROOT$$/) { s%^ *(([^: ]+:)?..?.?) (/(ADJ-NUMBER|ABBR|MASC|FEM|PERS|CL|INDEF|PROP|GEN|C-|End))%\1¬ \3%; s%^ *(([^: ]+:)..?) (/ADJ;)%\1¬ \3%; s/^ *([^:]+)¬ /\1:\1¬ /;}' $< | grep -v '^END$$' > $@
	perl -pe 's/^!DECOMPOSE[ 	]*//' $< | ./filter-by-freq.pl >> $@
	echo END >> $@

spanish-decompose.fst: spanish.fst
	perl -pe 's/(spanish)\.lex/\1-decompose.lex/' $< > $@

sp%.test.diff: sp%.test.official sp%.test
	-diff $^ > $@

sp%.test: sp%.hfst sp%.test.in
	hfst-lookup $< < sp$*.test.in > $@
