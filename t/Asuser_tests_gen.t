#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;
use Test::More skip_all => q{desactive car necessite les droits root};

my $expected_code;
my $expected_string;
my $expected_error;
my $return_code;
my $return_string;
my $return_error;

my $home;

use ScriptCooker::Utils;
source_profile('t/sample/profile.RT.minimal');
$ENV{BV_LOGASUSER}='t/sample/log/ITasuser.log';

##################
# rootami
##################

$expected_code = 1;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('rootami', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'rootami'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'rootami'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'rootami'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'rootami'."> errstd") or diag($return_error);


##################
# Asuser
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Asuser [-h] [-v] [-e] [-p <Path>] <User> <Cmd...>
Procedure : Asuser, Type : Erreur, Severite : 202
Message : Le nombre d'arguments est incorrect

EXPECTED_ERRSTD
chomp $expected_error;

run3('Asuser', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Asuser'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Asuser'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Asuser'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Asuser'."> errstd") or diag($return_error);


##################
# Asuser root "id -u"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
0

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Asuser root "id -u"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Asuser root "id -u"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Asuser root "id -u"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Asuser root "id -u"'."> output <".q{0}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Asuser root "id -u"'."> errstd") or diag($return_error);

