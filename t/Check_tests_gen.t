#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;
use Test::More tests => 45;

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
# Check
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Check [-h] <Table> [ON [<FKey_Table> [, ...]]] [WHERE <Condition>]
Procedure : Check, Type : Erreur, Severite : 202
Message : Ligne de commande incorrecte

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check'."> errstd") or diag($return_error);


##################
# Check error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
-- Check de la table error_messages ...

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check error_messages'."> output <".q{-- Check d...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check error_messages'."> errstd") or diag($return_error);


##################
# Check error_messages_dup
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';
-- Check de la table error_messages_dup ...

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Cle Check;65 : Non unique.
Cle Check;65 : Non unique.
Cle Check;65 : Non unique.
Cle Check;65 : Non unique.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check error_messages_dup', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check error_messages_dup'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check error_messages_dup'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check error_messages_dup'."> output <".q{-- Check d...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check error_messages_dup'."> errstd") or diag($return_error);


##################
# Check error_messages_null
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';
-- Check de la table error_messages_null ...

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Cle PATH; : La colonne Error doit contenir une valeur.
Cle Insert;8 : La colonne Message doit contenir une valeur.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check error_messages_null', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check error_messages_null'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check error_messages_null'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check error_messages_null'."> output <".q{-- Check d...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check error_messages_null'."> errstd") or diag($return_error);


##################
# Check table_command_nokey
##################

$expected_code = 201;
$expected_string = <<'EXPECTED_OUTPUT';
-- Check de la table table_command_nokey ...

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
La table table_command_nokey ne possede pas de cle primaire.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check table_command_nokey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check table_command_nokey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check table_command_nokey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check table_command_nokey'."> output <".q{-- Check d...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check table_command_nokey'."> errstd") or diag($return_error);


##################
# Check table_command_nosort
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
-- Check de la table table_command_nosort ...

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check table_command_nosort', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check table_command_nosort'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check table_command_nosort'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check table_command_nosort'."> output <".q{-- Check d...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check table_command_nosort'."> errstd") or diag($return_error);


##################
# Check table_simple
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';
-- Check de la table table_simple ...

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Cle 6 : Le type d'une des valeurs des colonnes n'est pas correct.
Cle 7 : Le type d'une des valeurs des colonnes n'est pas correct.
Cle 8 : Le type d'une des valeurs des colonnes n'est pas correct.
Cle toto : Le type d'une des valeurs des colonnes n'est pas correct.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check table_simple'."> output <".q{-- Check d...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check table_simple'."> errstd") or diag($return_error);


##################
# Check table_simple on table_fkey >/dev/null
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Check, Type : Erreur, Severite : 202
Message : La table table_fkey n'est pas une table de reference.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check table_simple on table_fkey >/dev/null', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check table_simple on table_fkey >/dev/null'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check table_simple on table_fkey >/dev/null'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check table_simple on table_fkey >/dev/null'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check table_simple on table_fkey >/dev/null'."> errstd") or diag($return_error);


##################
# Check table_fkey ON >/dev/null
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check table_fkey ON >/dev/null', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check table_fkey ON >/dev/null'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check table_fkey ON >/dev/null'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check table_fkey ON >/dev/null'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check table_fkey ON >/dev/null'."> errstd") or diag($return_error);


##################
# Check table_fkey ON table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
-- Check de la table table_fkey ...
-- Check sur la table table_simple ...

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check table_fkey ON table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check table_fkey ON table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check table_fkey ON table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check table_fkey ON table_simple'."> output <".q{-- Check d...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check table_fkey ON table_simple'."> errstd") or diag($return_error);


##################
# Check table_fkey ON table_fukey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
-- Check de la table table_fkey ...
-- Check sur la table table_fukey ...

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check table_fkey ON table_fukey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check table_fkey ON table_fukey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check table_fkey ON table_fukey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check table_fkey ON table_fukey'."> output <".q{-- Check d...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check table_fkey ON table_fukey'."> errstd") or diag($return_error);


##################
# Check table_fkey on table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
-- Check de la table table_fkey ...
-- Check sur la table table_simple ...

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check table_fkey on table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check table_fkey on table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check table_fkey on table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check table_fkey on table_simple'."> output <".q{-- Check d...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check table_fkey on table_simple'."> errstd") or diag($return_error);


##################
# Check table_fukey on
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
-- Check de la table table_fukey ...
-- Check sur la table table_simple ...

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check table_fukey on', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check table_fukey on'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check table_fukey on'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check table_fukey on'."> output <".q{-- Check d...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check table_fukey on'."> errstd") or diag($return_error);


##################
# Check table_fkey_bad ON table_simple
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';
-- Check de la table table_fkey_bad ...
-- Check sur la table table_simple ...

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Cle 99 : Aucune reference.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check table_fkey_bad ON table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check table_fkey_bad ON table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check table_fkey_bad ON table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check table_fkey_bad ON table_simple'."> output <".q{-- Check d...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check table_fkey_bad ON table_simple'."> errstd") or diag($return_error);


##################
# Check table_fkey_bad ON table_simple WHERE Ordre '<' 10
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
-- Check de la table table_fkey_bad ...
-- Check sur la table table_simple ...

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Check table_fkey_bad ON table_simple WHERE Ordre \'<\' 10', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Check table_fkey_bad ON table_simple WHERE Ordre \'<\' 10'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Check table_fkey_bad ON table_simple WHERE Ordre \'<\' 10'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Check table_fkey_bad ON table_simple WHERE Ordre \'<\' 10'."> output <".q{-- Check d...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Check table_fkey_bad ON table_simple WHERE Ordre \'<\' 10'."> errstd") or diag($return_error);

