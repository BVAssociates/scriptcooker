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
# Parameters parameters
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='%%'@@FORMAT='VAR%%VAR_IMBRIQUE%%VAR_FALSE%%VAR_VIDE%%VAR_VAR%%VAR_COMPOSE%%VAR_STATIC'@@ROW='$VAR%%$VAR_IMBRIQUE%%$VAR_FALSE%%$VAR_VIDE%%$VAR_VAR%%$VAR_COMPOSE%%$VAR_STATIC'@@SIZE='20s%%20s%%20s%%20s%%20s%%20s%%20s'@@HEADER='Variables de la tables parameters'@@KEY=''
$(echo "var" | sed 's/var/valeur/')%%$(echo "var" | sed $(echo 's/var/valeur/'))%%$(echo "false" && false)%%%%${TESTVAR}%%${TESTVAR} et ${TESTVAR}%%static

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Parameters parameters', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Parameters parameters'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Parameters parameters'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Parameters parameters'."> output <".q{SEP='%%'@@...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Parameters parameters'."> errstd") or diag($return_error);


##################
# Parameters t/sample/tab/parameters
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='%%'@@FORMAT='VAR%%VAR_IMBRIQUE%%VAR_FALSE%%VAR_VIDE%%VAR_VAR%%VAR_COMPOSE%%VAR_STATIC'@@ROW='$VAR%%$VAR_IMBRIQUE%%$VAR_FALSE%%$VAR_VIDE%%$VAR_VAR%%$VAR_COMPOSE%%$VAR_STATIC'@@SIZE='20s%%20s%%20s%%20s%%20s%%20s%%20s'@@HEADER='Variables de la tables parameters'@@KEY=''
$(echo "var" | sed 's/var/valeur/')%%$(echo "var" | sed $(echo 's/var/valeur/'))%%$(echo "false" && false)%%%%${TESTVAR}%%${TESTVAR} et ${TESTVAR}%%static

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Parameters t/sample/tab/parameters', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Parameters t/sample/tab/parameters'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Parameters t/sample/tab/parameters'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Parameters t/sample/tab/parameters'."> output <".q{SEP='%%'@@...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Parameters t/sample/tab/parameters'."> errstd") or diag($return_error);

$ENV{PARAMETERS_FILE}="$ENV{TOOLS_HOME}/tab/parameters";

##################
# Parameters
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='%%'@@FORMAT='VAR%%VAR_IMBRIQUE%%VAR_FALSE%%VAR_VIDE%%VAR_VAR%%VAR_COMPOSE%%VAR_STATIC'@@ROW='$VAR%%$VAR_IMBRIQUE%%$VAR_FALSE%%$VAR_VIDE%%$VAR_VAR%%$VAR_COMPOSE%%$VAR_STATIC'@@SIZE='20s%%20s%%20s%%20s%%20s%%20s%%20s'@@HEADER='Variables de la tables parameters'@@KEY=''
$(echo "var" | sed 's/var/valeur/')%%$(echo "var" | sed $(echo 's/var/valeur/'))%%$(echo "false" && false)%%%%${TESTVAR}%%${TESTVAR} et ${TESTVAR}%%static

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Parameters', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Parameters'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Parameters'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Parameters'."> output <".q{SEP='%%'@@...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Parameters'."> errstd") or diag($return_error);


##################
# Parameters -s
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
$(echo "var" | sed 's/var/valeur/')%%$(echo "var" | sed $(echo 's/var/valeur/'))%%$(echo "false" && false)%%%%${TESTVAR}%%${TESTVAR} et ${TESTVAR}%%static

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Parameters -s', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Parameters -s'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Parameters -s'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Parameters -s'."> output <".q{$(echo "va...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Parameters -s'."> errstd") or diag($return_error);


##################
# Parameters -v
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='%%'@@FORMAT='VAR%%VAR_IMBRIQUE%%VAR_FALSE%%VAR_VIDE%%VAR_VAR%%VAR_COMPOSE%%VAR_STATIC'@@ROW='"valeur"%%"valeur"%%"false"%%%%variable evaluee%%variable evaluee et variable evaluee%%static'@@SIZE='20s%%20s%%20s%%20s%%20s%%20s%%20s'@@HEADER='Variables de la tables parameters'@@KEY=''
valeur%%valeur%%false%%%%variable evaluee%%variable evaluee et variable evaluee%%static

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;
SKIP: {
skip q{BUG dans I-TOOLS 2.0}, 3;


run3('Parameters -v', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Parameters -v'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Parameters -v'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Parameters -v'."> output <".q{SEP='%%'@@...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Parameters -v'."> errstd") or diag($return_error);

}


##################
# Parameters -vs
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
valeur%%valeur%%false%%%%variable evaluee%%variable evaluee et variable evaluee%%static

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Parameters -vs', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Parameters -vs'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Parameters -vs'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Parameters -vs'."> output <".q{valeur%%va...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Parameters -vs'."> errstd") or diag($return_error);


##################
# Parameters -e
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='%%'; export SEP
FORMAT='VAR%%VAR_IMBRIQUE%%VAR_FALSE%%VAR_VIDE%%VAR_VAR%%VAR_COMPOSE%%VAR_STATIC'; export FORMAT
ROW='$VAR%%$VAR_IMBRIQUE%%$VAR_FALSE%%$VAR_VIDE%%$VAR_VAR%%$VAR_COMPOSE%%$VAR_STATIC'; export ROW
SIZE='20s%%20s%%20s%%20s%%20s%%20s%%20s'; export SIZE
HEADER='Variables de la tables parameters'; export HEADER
KEY=''; export KEY
VAR="$(echo "\""var"\"" | sed 's/var/valeur/')"; export VAR
VAR_IMBRIQUE="$(echo "\""var"\"" | sed $(echo 's/var/valeur/'))"; export VAR_IMBRIQUE
VAR_FALSE="$(echo "\""false"\"" && false)"; export VAR_FALSE
VAR_VIDE=""; export VAR_VIDE
VAR_VAR="${TESTVAR}"; export VAR_VAR
VAR_COMPOSE="${TESTVAR} et ${TESTVAR}"; export VAR_COMPOSE
VAR_STATIC="static"; export VAR_STATIC

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Parameters -e', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Parameters -e'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Parameters -e'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Parameters -e'."> output <".q{SEP='%%'; ...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Parameters -e'."> errstd") or diag($return_error);


##################
# Parameters -ev
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='%%'; export SEP
FORMAT='VAR%%VAR_IMBRIQUE%%VAR_FALSE%%VAR_VIDE%%VAR_VAR%%VAR_COMPOSE%%VAR_STATIC'; export FORMAT
ROW='"valeur"%%"valeur"%%"false"%%%%variable evaluee%%variable evaluee et variable evaluee%%static'; export ROW
SIZE='20s%%20s%%20s%%20s%%20s%%20s%%20s'; export SIZE
HEADER='Variables de la tables parameters'; export HEADER
KEY=''; export KEY
VAR="valeur"; export VAR
VAR_IMBRIQUE="valeur"; export VAR_IMBRIQUE
VAR_FALSE="false"; export VAR_FALSE
VAR_VIDE=""; export VAR_VIDE
VAR_VAR="variable evaluee"; export VAR_VAR
VAR_COMPOSE="variable evaluee et variable evaluee"; export VAR_COMPOSE
VAR_STATIC="static"; export VAR_STATIC

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;
SKIP: {
skip q{BUG dans I-TOOLS 2.0}, 3;


run3('Parameters -ev', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Parameters -ev'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Parameters -ev'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Parameters -ev'."> output <".q{SEP='%%'; ...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Parameters -ev'."> errstd") or diag($return_error);

}


##################
# Parameters -es
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
VAR="$(echo "\""var"\"" | sed 's/var/valeur/')"; export VAR
VAR_IMBRIQUE="$(echo "\""var"\"" | sed $(echo 's/var/valeur/'))"; export VAR_IMBRIQUE
VAR_FALSE="$(echo "\""false"\"" && false)"; export VAR_FALSE
VAR_VIDE=""; export VAR_VIDE
VAR_VAR="${TESTVAR}"; export VAR_VAR
VAR_COMPOSE="${TESTVAR} et ${TESTVAR}"; export VAR_COMPOSE
VAR_STATIC="static"; export VAR_STATIC

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Parameters -es', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Parameters -es'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Parameters -es'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Parameters -es'."> output <".q{VAR="$(ech...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Parameters -es'."> errstd") or diag($return_error);


##################
# Parameters -evs
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
VAR="valeur"; export VAR
VAR_IMBRIQUE="valeur"; export VAR_IMBRIQUE
VAR_FALSE="false"; export VAR_FALSE
VAR_VIDE=""; export VAR_VIDE
VAR_VAR="variable evaluee"; export VAR_VAR
VAR_COMPOSE="variable evaluee et variable evaluee"; export VAR_COMPOSE
VAR_STATIC="static"; export VAR_STATIC

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Parameters -evs', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Parameters -evs'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Parameters -evs'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Parameters -evs'."> output <".q{VAR="valeu...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Parameters -evs'."> errstd") or diag($return_error);

