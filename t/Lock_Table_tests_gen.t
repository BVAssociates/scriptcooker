#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;
use Test::More tests => 27;

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
# Lock_Table
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Lock_Table [-h] [-u] [-t timeout] Table ... 
 		   L'option -t permet de definir le delai maximal de lock 
 		   Delai de lock par defaut = 5s ou $GSL_TABLE_LCKTRY
Procedure : Lock_Table, Type : Erreur, Severite : 202
Message : Ligne de commande incorrecte

EXPECTED_ERRSTD
chomp $expected_error;

run3('Lock_Table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Lock_Table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Lock_Table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Lock_Table'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Lock_Table'."> errstd") or diag($return_error);


##################
# Lock_Table -u error_messages 
##################

$expected_code = 201;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Lock_Table, Type : Erreur, Severite : 201
Message : Le fichier TOOLS_HOME/tab/error_messages n'est pas verouille

EXPECTED_ERRSTD
chomp $expected_error;
SKIP: {
skip q{Comportement non reporté en I-TOOLS 2.1}, 3;


run3('Lock_Table -u error_messages ', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Lock_Table -u error_messages '."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Lock_Table -u error_messages '."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Lock_Table -u error_messages '."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Lock_Table -u error_messages '."> errstd") or diag($return_error);

}


##################
# Lock_Table -u error_messages error_messages
##################

$expected_code = 201;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Lock_Table, Type : Erreur, Severite : 201
Message : Le fichier TOOLS_HOME/tab/error_messages n'est pas verouille
Procedure : Lock_Table, Type : Erreur, Severite : 201
Message : Le fichier TOOLS_HOME/tab/error_messages n'est pas verouille

EXPECTED_ERRSTD
chomp $expected_error;
SKIP: {
skip q{Comportement non reporté en I-TOOLS 2.1}, 3;


run3('Lock_Table -u error_messages error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Lock_Table -u error_messages error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Lock_Table -u error_messages error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Lock_Table -u error_messages error_messages'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Lock_Table -u error_messages error_messages'."> errstd") or diag($return_error);

}


##################
# Lock_Table error_messages 
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Lock_Table error_messages ', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Lock_Table error_messages '."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Lock_Table error_messages '."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Lock_Table error_messages '."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Lock_Table error_messages '."> errstd") or diag($return_error);


##################
# Lock_Table error_messages 
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Lock_Table, Type : Erreur, Severite : 202
Message : Le delai maximum d'attente de deverouillage a ete atteint

EXPECTED_ERRSTD
chomp $expected_error;
SKIP: {
skip q{Comportement non reporté en I-TOOLS 2.1}, 3;


run3('Lock_Table error_messages ', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Lock_Table error_messages '."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Lock_Table error_messages '."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Lock_Table error_messages '."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Lock_Table error_messages '."> errstd") or diag($return_error);

}


##################
# Lock_Table -t0 error_messages 
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Lock_Table, Type : Erreur, Severite : 202
Message : Le delai maximum d'attente de deverouillage a ete atteint

EXPECTED_ERRSTD
chomp $expected_error;
SKIP: {
skip q{Comportement non reporté en I-TOOLS 2.1}, 3;


run3('Lock_Table -t0 error_messages ', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Lock_Table -t0 error_messages '."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Lock_Table -t0 error_messages '."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Lock_Table -t0 error_messages '."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Lock_Table -t0 error_messages '."> errstd") or diag($return_error);

}


##################
# Lock_Table -u error_messages 
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Lock_Table -u error_messages ', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Lock_Table -u error_messages '."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Lock_Table -u error_messages '."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Lock_Table -u error_messages '."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Lock_Table -u error_messages '."> errstd") or diag($return_error);


##################
# Lock_Table error_messages error_messages_dup
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Lock_Table error_messages error_messages_dup', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Lock_Table error_messages error_messages_dup'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Lock_Table error_messages error_messages_dup'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Lock_Table error_messages error_messages_dup'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Lock_Table error_messages error_messages_dup'."> errstd") or diag($return_error);


##################
# Lock_Table -u error_messages error_messages_dup
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Lock_Table -u error_messages error_messages_dup', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Lock_Table -u error_messages error_messages_dup'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Lock_Table -u error_messages error_messages_dup'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Lock_Table -u error_messages error_messages_dup'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Lock_Table -u error_messages error_messages_dup'."> errstd") or diag($return_error);

