###############################################
# FST rules for Spanish
# Based on K-Span PC-Kimmo automata
# K-Span © 2002 Copyright University of Maryland. All Rights Reserved. 
# Licensed under the Open Software License version 1.1 (see OSLicense.txt)
#
# Converted into HFST format by Anna Ronkainen, © 2013 Onomatics, Inc.
# Licensed under the Open Software License version 1.1 (see OSLicense.txt)
# 
###############################################

define V [ a | e | i | I | o | u | U | á | é | í | ó | ú | ü ] ;
define A [ á | é | í | ó | ú ] ;
define N [ a | e | i | I | o | u | U | ü ] ;
define K [ b | c | C | d | f | g | G | h | j | J | k | l | m | n | ñ | p | q | r | s | t | v | w | x | y | z | Z ] ;
define B [ u | U | o | a | ú | ü | ó | á ] ;
define L [ e | o | a | é | ó | á ] ;
define H [ i | I | u | U | í | ú | ü ] ;
define F [ e | i | I | é | í ] ;
define X [ z | x ] ;
define KV [ K | V ] ;

define SUFF [ %+A | %+ACC%/DAT | %+ACC%/NOM%/DAT | %+ADV | %+C | %+COND | %+D | %+F | %+FIRST | %+FIRST%/THIRD | %+FUT | %+GEN | %+IMPERATIVE | %+IMPERF | %+INDIC | %+INF | %+M | %+M%/F | %+N | %+NOM%/ACC | %+NOM%/ACC%/DAT | %+P | %+PAST | %+PERFECT | %+PLUR | %+PRES | %+PRES%/FUT%/PAST | %+PROG | %+PRONOUN | %+PRONOUN%/ANAPHOR | %+SECOND | %+SING | %+SING%/PLUR | %+SUBJ | %+THIRD | %+V ] ;
define ADF SUFF;
define BOUND [ .#. | %- | %# ] ;

define GJmutation [
[ J -> j || _ %^ F ] .o.
[ J -> g || _ %^ B ]
];

define CZCmutation [
[ C -> z || _ %^ B ] .o.
[ Z -> z || _ c %^ B ] .o.
[ C -> c || _ %^ F ] .o.
[ Z -> 0 || _ c %^ F ]
];

define GUGQUCmutation [
[ u -> 0 || K _ u %^ B ] .o.
[ q u -> c || K _ %^ B ]
];

define NNGmutation [
[ G -> g || _ %^ B ] .o.
[ G -> 0 || _ %^ F ]
];

define Uumlautmutation [
[ U -> ü || _ %^ F ] .o.
[ U -> u ]
];

define CQUGGUmutation [
[ g -> g u || _ %^ [ e | é ] ] .o.
[ c -> q u || _ %^ [ e | é ] ]
];

define IYNLLCHmutation [
[ i %^ i -> y || V _ [ V - [ i | í ]]] .o.
[ i -> y || V _ %^ [ V - í ]] .o.
[ i -> y || V %^ _ [ V - í ]] .o.
[ i -> 0 || _ %^ [ i | í ]] .o.
[ i -> 0 || [ ñ | ll | ch ] %^ _ V ]
];

define IIImutation [
[ i %^ i -> y || _ L ] .o.
[ i %^ i -> i || _ K ]
];

define Kpluralize [
[ s -> e s || [ K - z ] %^ _ BOUND ]];

define ZCmutation [
[ z -> c || _ %^ F ] .o.
[ z %^ -> c %^ e || _ s BOUND ] .o.
[ x %^ -> c %^ e || _ s BOUND ]
];

define IARUARmutation [
[ I -> í || [ KV - g ] _ %^ L K ] .o.
[ I -> í || [ KV - g ] _ %^ L BOUND ] .o.
[ I -> i ] .o. 
[ U -> ú || [ KV - g ] _ %^ L K ] .o.
[ U -> ú || [ KV - g ] _ %^ L BOUND ] .o.
[ U -> u ]
];

define removeaccent [
[ á -> a || _ K %^ ( V ) K ] .o.
[ é -> e || _ K %^ ( V ) K ] .o.
[ í -> i || _ K %^ ( V ) K ] .o.
[ ó -> o || _ K %^ ( V ) K ] .o.
[ ú -> u || _ K %^ ( V ) K ] .o.
[ %^ s -> %^ e s || A KV+ N K _ ]
];

define addaccent [
[ a (->) á || _ K+ e n %^ e s BOUND ] .o.
[ e (->) é || _ K+ e n %^ e s BOUND ] .o.
[ i (->) í || _ K+ e n %^ e s BOUND ] .o.
[ o (->) ó || _ K+ e n %^ e s BOUND ] .o.
[ u (->) ú || _ K+ e n %^ e s BOUND ]
];

define optaccent [
[ á (->) a ] .o.
[ é (->) e ] .o.
[ í (->) i ] .o.
[ ó (->) o ] .o.
[ ú (->) u ] .o.
[ ü (->) u ] .o.
[ ñ (->) n ]
];

define Cleanup [
[ %# -> q w y j i b o q w y j i b o || .#. ? (?) (?) _ ? (?) (?) .#. ] .o.
[ %¬ -> q w y j i b o q w y j i b o || .#. ?* _ ?* %# ?+ .#. ] .o.
[ %^ -> 0 ] .o.
[ %¬ -> 0 ] .o.
[ I -> i ] .o.
[ U -> u ] .o.
[ C -> c ] .o.
[ G -> g ] .o.
[ J -> j ] .o.
[ Z -> z ]
];

define WordBoundary [
  [ %# -> 0 ]
];

define Rules [ GJmutation .o. CZCmutation .o. GUGQUCmutation .o. NNGmutation .o. Uumlautmutation .o. CQUGGUmutation .o. IYNLLCHmutation .o. IIImutation .o. Kpluralize .o. ZCmutation .o. IARUARmutation .o. removeaccent .o. addaccent .o. optaccent .o. Cleanup ];

# delete compounds with >4 segments or >n suffixes
define RestrictCompounding 
[ ~[ ?* %# ?* %# ?* %# ?* %# ?* | ?* %¬ ?* %# ?* ]];
#[ ~[ ?* %- ?* %- ?* %- ?* %- ?* | 
# short segments restricted by frequency in filter-by-freq.pl
#     ?^<4 %- ?* | ?* %- ?^<4 | ?* %- ?^<4 %- ?* |
# no adfix tags in decompose lexicon 
#     ?* ADF ?* ADF ?* ADF ?* ] ];
#     ?* %^ *? %^ *? %^ *? %^ *? ] ];

read lexc spanish.lex
define Lexicon;

define Analysis [ RestrictCompounding .o. Lexicon .o. Rules .o. WordBoundary ].i;

define Decomposition [ [ Lexicon.l .o. Rules .o. WordBoundary ].i .o. Rules ];