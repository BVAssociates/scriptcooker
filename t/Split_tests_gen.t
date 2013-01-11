#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;
use Test::More tests => 30;

my $expected_code;
my $expected_string;
my $expected_error;
my $return_code;
my $return_string;
my $return_error;

my $home;

use ScriptCooker::Utils;
source_profile('t/sample/profile.RT.minimal');

##################
# echo "" | Split
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';


EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo "" | Split', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo "" | Split'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo "" | Split'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo "" | Split'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo "" | Split'."> errstd") or diag($return_error);


##################
# echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
abcdefghijklmnopkrstuvwxyz

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1'."> output <".q{abcdefghij...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1'."> errstd") or diag($return_error);


##################
# echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
abcdefgh

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8'."> output <".q{abcdefgh}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8'."> errstd") or diag($return_error);


##################
# echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
abcdefgh:ijklmnopkrstuvwxyz

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9'."> output <".q{abcdefgh:i...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9'."> errstd") or diag($return_error);


##################
# echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
abcdefgh:ijklmnop

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16'."> output <".q{abcdefgh:i...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16'."> errstd") or diag($return_error);


##################
# echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
abcdefgh:ijklmnop:krstuvwxyz

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17'."> output <".q{abcdefgh:i...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17'."> errstd") or diag($return_error);


##################
# echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17 24
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
abcdefgh:ijklmnop:krstuvwx

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17 24', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17 24'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17 24'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17 24'."> output <".q{abcdefgh:i...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo "abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17 24'."> errstd") or diag($return_error);


##################
# echo "       abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17 24 25 26
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
a:bcdefghi:jklmnopk:rs

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo "       abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17 24 25 26', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo "       abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17 24 25 26'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo "       abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17 24 25 26'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo "       abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17 24 25 26'."> output <".q{a:bcdefghi...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo "       abcdefghijklmnopkrstuvwxyz" | Split -s: 1 8 9 16 17 24 25 26'."> errstd") or diag($return_error);


##################
# echo "       abcdefghijklmnopkrstuvwxyz" | Split -x -s: 1 8 9 16 17 24 25 26
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
       a:bcdefghi:jklmnopk:rs

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo "       abcdefghijklmnopkrstuvwxyz" | Split -x -s: 1 8 9 16 17 24 25 26', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo "       abcdefghijklmnopkrstuvwxyz" | Split -x -s: 1 8 9 16 17 24 25 26'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo "       abcdefghijklmnopkrstuvwxyz" | Split -x -s: 1 8 9 16 17 24 25 26'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo "       abcdefghijklmnopkrstuvwxyz" | Split -x -s: 1 8 9 16 17 24 25 26'."> output <".q{       a:b...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo "       abcdefghijklmnopkrstuvwxyz" | Split -x -s: 1 8 9 16 17 24 25 26'."> errstd") or diag($return_error);


##################
# Split -f $SAMPLE/tab/error_messages -s: 1 8 9 16 17 24 25 26
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
# $Revis:ion: 1.2:$:
#-------:--------:--------:--
#Fonctio:n (ou ge:neric);C:od
#-------:--------:--------:--
:
#-------:--------:--------:--
#A parti:r de la:Version:V1
#   . Va:riables:d'enviro:nn
#   . Po:ssiblite:s de sub:st
#-------:--------:--------:--
:
#-------:--------:--------:--
#A parti:r de la:Version:V1
#   . Mi:se a jou:r des me:ss
#   . Pl:age 1-20:0 : IToo:ls
#   . Pl:age 201-:300 : Ga:se
#   . Pl:age 301-:400 : Se:rv
#   . Pl:age 401-:500 : Un:ix
#   . Pl:age 501-:600 : Or:ac
#:
#Mises a:jour ef:fectuees::
#   . Mo:dificati:ons de n:um
#   . Su:ppressio:n de num:er
#   . ->:Cf. err:or_messa:ge
#-------:--------:--------:--
:
#-------:--------:--------:--
# Erreur:s generi:ques ITo:ol
#-------:--------:--------:--
TEST;1;t:est sans:quote:
TEST;2;t:est avec:' des ':q
TEST;3;t:est avec:" des ":d
TEST;4;t:est avec:\" des:\'
TEST;5;t:est avec:\\ echa:pp
TEST;6;t:est avec:trop de:;
TEST;7;t:est avec:des $va:ri
TEST;8;t:est avec:des $va:ri
TEST;9;t:est avec:des $va:ri
TEST_${T:ESTVAR};:0;test a:ve
Check;65:;Non uni:cite de:la
Insert;8:;La cond:ition de:s
Insert;9:7;Aucune:valeur:a
Modify;8:;La cond:ition de:s
Modify;6:8;Aucune:ligne t:ro
Modify;9:7;Aucune:valeur:a
Remove;6:8;Aucune:ligne t:ro
Replace;:8;La con:dition d:e
Replace;:68;Aucun:e ligne:tr
Replace;:97;Aucun:e valeur:a
generic;:1;Imposs:ible de:tr
generic;:2;Imposs:ible de:tr
generic;:3;Imposs:ible de:tr
generic;:4;Imposs:ible de:tr
generic;:5;Le fic:hier de:de
generic;:6;La tab:le %s es:t
generic;:7;La col:onne %s:n'
generic;:8;La con:dition d:e
generic;:9;La cha:ine de d:ef
generic;:10;Impos:sible d':ou
generic;:11;Impos:sible d':ec
generic;:12;Impos:sible de:s
generic;:13;Impos:sible de:c
generic;:14;Impos:sible de:r
generic;:15;Impos:sible de:c
generic;:16;Erreu:r lors d:'u
generic;:17;La co:mmande <:%s
generic;:18;La va:riable r:ac
generic;:19;L'eva:luation:de
generic;:20;L'opt:ion %s n:'e
generic;:21;Le no:mbre d'a:rg
generic;:22;L'arg:ument %s:n
generic;:23;Utili:sation i:nc
generic;:24;Ligne:de comm:an
generic;:25;Erreu:r lors d:'u
generic;:26;Erreu:r lors d:'u
generic;:27;Erreu:r lors d:u
generic;:28;Impos:sible de:r
generic;:29;Erreu:r lors d:e
generic;:30;Votre:licence:d
generic;:31;Le Ho:stid de:la
generic;:32;La li:cence n':es
generic;:33;Il n':y a pas:de
generic;:34;Le no:mbre de:cl
generic;:35;Le no:m de fic:hi
generic;:36;Le fi:chier %s:e
generic;:37;Impos:sible de:p
generic;:38;Le de:lai maxi:mu
generic;:39;Le fi:chier %s:n
generic;:40;Impos:sible de:r
generic;:41;Le no:mbre max:im
generic;:42;Le Ha:ndle d'u:ne
generic;:43;Le no:mbre max:im
generic;:44;Impos:sible de:r
generic;:45;Un Ha:ndle n'e:st
generic;:46;Le no:mbre max:im
generic;:47;Le no:mbre max:im
generic;:48;Impos:sible de:r
generic;:49;Impos:sible de:r
generic;:50;Erreu:r lors d:e
generic;:51;Erreu:r de typ:e
generic;:52;Impos:sible d':ec
generic;:53;Impos:sible de:d
generic;:54;Le nu:mero d'e:rr
generic;:55;Le me:ssage d':in
generic;:56;Le nu:mero d'e:rr
generic;:57;Le nu:mero d'e:rr
generic;:58;Le ty:pe de me:ss
generic;:59;Le no:m de tab:le
generic;:60;La co:lonne %s:d
generic;:61;Il n':y a pas:as
generic;:62;Il y:a trop d:e
generic;:63;La va:leur don:ne
generic;:64;Le no:m de la:ta
generic;:65;Non u:nicite d:e
generic;:66;Le gr:oupe d'u:ti
generic;:67;Impos:sible de:r
generic;:68;Aucun:e ligne:tr
generic;:69;Entet:e de def:in
generic;:70;Varia:bles d'e:nv
generic;:71;Il n':y a pas:de
generic;:72;Impos:sible d':ou
generic;:73;Impos:sible d':ou
generic;:74;Impos:sible d':ou
generic;:75;Erreu:r generi:qu
generic;:76;Erreu:r de syn:ta
generic;:77;Une v:aleur a:in
generic;:78;Impos:sible de:s
generic;:79;Impos:sible de:l
generic;:80;La re:quete in:te
generic;:81;Le no:uveau se:pa
generic;:82;Le no:mbre max:im
generic;:83;La co:lonne %s:a
generic;:84;La so:urce de:do
generic;:85;La ta:ble %s n:e
generic;:86;Vous:ne pouve:z
generic;:87;Impos:sible de:c
generic;:88;Le no:mbre max:im
generic;:89;Optio:n ou suf:fi
generic;:90;Pas d:e librai:ri
generic;:91;Varia:ble d'en:vi
generic;:92;Param:etre <+:re
generic;:93;Le ty:pe de la:c
generic;:94;Impos:sible de:r
generic;:95;Impos:sible de:r
generic;:96;L'ope:rateur d:e
generic;:97;Aucun:e valeur:d
generic;:98;La ta:ille max:im
generic;:99;Le ch:amp %s e:st
generic;:100;%s:
generic;:101;Le p:arametre:%
generic;:102;L'ut:ilisateu:r
generic;:103;La c:le de re:fe
generic;:104;Erre:ur lors:du
generic;:105;La v:ariable:%s
generic;:106;Prob:leme lor:s
generic;:107;Envi:ronnemen:t
generic;:108;Prob:leme pou:r
generic;:109;La t:able %s:n'
generic;:110;Impo:ssible d:e
generic;:111;La t:able %s:ex
generic;:112;Prob:leme pou:r
generic;:113;Erre:ur lors:du
generic;:114;Erre:ur lors:de
generic;:115;Erre:ur lors:du
generic;:116;Des:enregist:re
generic;:117;La c:ontraint:e
generic;:118;Le n:ombre ma:xi
generic;:119;Le n:ombre ma:xi
generic;:120;Impo:ssible d:e
generic;:121;La t:able %s:n'
generic;:122;La t:able %s:ex
generic;:123;Les:droits s:ur
generic;:124;Prob:leme pou:r
generic;:125;Le t:ype de l:a
generic;:126;L'ut:ilisateu:r
generic;:127;Les:colonnes:%
generic;:128;La t:able %s:ne
generic;:129;La v:aleur d':un
generic;:130;Opti:ons de c:om
generic;:131;Le t:ri de sé:lé
generic;:132;Le f:ormat de:l
generic;:133;Les:eléments:%
generic;:134;La d:ate '%s':n
generic;:148;Vous:n'avez:pa
generic;:149;Prob:leme d'e:nv
generic;:150;Mot:de Passe:i
generic;:151;Vari:ables in:co
generic;:152;L'in:tance %s:e
:
#-------:--------:--------:--
# Erreur:s GASEL:: 201-30:0
#-------:--------:--------:--
V1_alim_:30_motcl:e;0001;E:CH
V1_alim_:30_motcl:e;0002;A:rg
V1_alim_:30_motcl:e;0003;R:an
V1_alim_:30_motcl:e;0004;E:CH
V1_alim_:40_meth;:0001;Le:mo
V1_alim_:40_meth;:0002;L'I:ns
V1_alim_:40_meth;:0003;L'I:ns
V1_alim_:40_meth;:0004;L'I:ns
:
#-------:--------:--------:--
# Erreur:s generi:ques Ser:vi
#-------:--------:--------:--
PC_CHGST:AT_SERV;:0004;Auc:un
generic;:301;Le m:odule ap:pl
generic;:302;L'in:stance d:e
generic;:303;Le s:cript fi:ls
generic;:304;Le s:cript fi:ls
generic;:305;Le s:cript fi:ls
generic;:306;Le s:cript fi:ls
generic;:308;Erre:ur a l'e:xe
generic;:309;Le s:ervice %:s
generic;:310;Le s:ervice %:s
generic;:311;Le s:ervice %:s
generic;:312;Le s:ervice %:s
generic;:313;Le s:ervice %:s
generic;:314;Le s:ervice %:s
generic;:315;Le m:odule ap:pl
generic;:316;La r:essource:%
generic;:317;Impo:ssible d:e
generic;:318;Impo:ssible d:e
generic;:319;La t:able %s:n'
generic;:320;Le t:ype de r:es
generic;:321;Le T:ype de S:er
:
#-------:--------:--------:--
# Erreur:s generi:ques Uni:x
#-------:--------:--------:--
generic;:401;Le r:epertoir:e
generic;:402;Impo:ssible d:e
generic;:403;Impo:ssible d:'e
generic;:404;Impo:ssible d:e
generic;:405;Le f:ichier %:s
generic;:406;Le f:ichier %:s
generic;:408;Le f:ichier %:s
generic;:409;Erre:ur lors:de
generic;:410;Prob:leme lor:s
generic;:411;Prob:leme lor:s
generic;:412;Prob:leme lor:s
generic;:413;Prob:leme lor:s
generic;:414;Le L:ecteur %:s
generic;:415;Le d:evice %s:n
generic;:416;Prob:leme lor:s
generic;:417;Le l:ecteur %:s
generic;:420;Impo:ssible d:'a
:
#-------:--------:--------:--
# Erreur:s generi:ques Ora:cl
#-------:--------:--------:--
ME_CREAT:E_SYNORA:;0001;Pr:ob
ME_DROP_:SYNORA;0:001;Prob:le
ME_LOAD_:TABORA;0:001;Eche:c
ME_RESTO:RE_TABOR:A;0001;E:rr
ME_SECUR:E_TABORA:;0001;Im:po
ME_SECUR:E_TABORA:;0002;Im:po
ME_SECUR:E_TABORA:;0003;Er:re
ME_SECUR:E_TABORA:;0004;Im:po
ME_SECUR:E_TABORA:;0365;Pr:ob
ME_TRUNC:_TABORA;:176;Prob:le
PC_BACK_:TBSORA;1:37;Probl:em
PC_BACK_:TBSORA;1:38;Probl:em
PC_BACK_:TBSORA;1:39;Probl:em
PC_LISTB:ACK_ARCH:ORA;0001:;I
PC_LISTB:ACK_ARCH:ORA;0002:;I
PC_LISTB:ACK_CTRL:ORA;128;:Im
PC_LISTB:ACK_CTRL:ORA;132;:Im
PC_LISTI:D_INSORA:;182;Imp:os
PC_SWITC:H_LOGORA:;127;Pro:bl
PC_SWITC:H_LOGORA:;128;Imp:os
generic;:501;L'in:stance O:ra
generic;:502;L'in:stance O:ra
generic;:503;%s n:'est pas:u
generic;:504;%s n:'est pas:u
generic;:505;La b:ase Orac:le
generic;:506;Impo:ssible d:e
generic;:507;Impo:ssible d:e
generic;:508;Le f:ichier d:e
generic;:509;Les:controlf:il
generic;:510;Les:parametr:es
generic;:511;Para:metre lo:g_
generic;:512;Para:metre lo:g_
generic;:513;L'ar:chivage:de
generic;:514;L'ar:chivage:de
generic;:515;Scri:pt SQL %:s
generic;:517;Le s:cript SQ:L
generic;:518;Prob:leme lor:s
generic;:519;Prob:leme a l:'e
generic;:520;Aucu:n Archiv:e
:
#-------:--------:-#:
# Erreur:s SQLNET:#:
#-------:--------:-#:
PC_INITF:_SQLNET;:004;La c:on
FT_LISTL:ST_SQLNE:T;346;Au:cu
FT_LIST_:TNSNAME;:346;Aucu:n
PC_ENV_S:QLNET;50:6;Imposs:ib
PC_LISTI:D_SQLNET:;182;Imp:os
PC_STAT_:TNSNAME;:001;Le s:er
PC_STAT_:TNSNAME;:002;Il n:'y
PC_STAT_:TNSNAME;:003;Erre:ur

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Split -f $SAMPLE/tab/error_messages -s: 1 8 9 16 17 24 25 26', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Split -f $SAMPLE/tab/error_messages -s: 1 8 9 16 17 24 25 26'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Split -f $SAMPLE/tab/error_messages -s: 1 8 9 16 17 24 25 26'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Split -f $SAMPLE/tab/error_messages -s: 1 8 9 16 17 24 25 26'."> output <".q{# $Revis:i...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Split -f $SAMPLE/tab/error_messages -s: 1 8 9 16 17 24 25 26'."> errstd") or diag($return_error);

