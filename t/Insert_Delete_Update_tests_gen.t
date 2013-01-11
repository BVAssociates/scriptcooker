#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;
use Test::More tests => 318;

my $expected_code;
my $expected_string;
my $expected_error;
my $return_code;
my $return_string;
my $return_error;

my $home;

use ScriptCooker::Utils;
source_profile('t/sample/profile.RT.minimal');
die("<t/sample/tab/empty_table> doit exister et etre vide au debut du test") if (!-z "t/sample/tab/empty_table");

##################
# Delete
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Delete [-h] FROM <Table> [WHERE <Condition>]
Procedure : Delete, Type : Erreur, Severite : 202
Message : Ligne de commande incorrecte

EXPECTED_ERRSTD
chomp $expected_error;

run3('Delete', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Delete'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Delete'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Delete'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Delete'."> errstd") or diag($return_error);


##################
# Insert
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Insert [-h] [-f] INTO <Table> [<Columns>] VALUES <-|Values>
Procedure : Insert, Type : Erreur, Severite : 202
Message : Ligne de commande incorrecte

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert'."> errstd") or diag($return_error);


##################
# Replace
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Replace [-h] INTO <Table> VALUES <-|Values> [WHERE Condition]
Procedure : Replace, Type : Erreur, Severite : 202
Message : Le nom de la table n'est pas specifie

EXPECTED_ERRSTD
chomp $expected_error;

run3('Replace', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Replace'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Replace'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Replace'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Replace'."> errstd") or diag($return_error);


##################
# Delete from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Delete from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Delete from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Delete from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Delete from empty_table'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Delete from empty_table'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Insert into empty_table
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Insert [-h] [-f] INTO <Table> [<Columns>] VALUES <-|Values>
Procedure : Insert, Type : Erreur, Severite : 202
Message : Ligne de commande incorrecte

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table'."> errstd") or diag($return_error);


##################
# Insert into empty_table values clef2%2
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Insert, Type : Erreur, Severite : 202
Message : Il n'y a pas assez de valeurs par rapport au nombre de colonnes

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table values clef2%2', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table values clef2%2'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table values clef2%2'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table values clef2%2'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table values clef2%2'."> errstd") or diag($return_error);


##################
# Insert into empty_table description values desc1
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Insert, Type : Erreur, Severite : 202
Message : La valeur d'une cle primaire ne peut-etre nulle.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table description values desc1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table description values desc1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table description values desc1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table description values desc1'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table description values desc1'."> errstd") or diag($return_error);


##################
# Insert into empty_table clef,description values clef1%desc1
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Insert, Type : Erreur, Severite : 202
Message : La colonne valeur doit absolument contenir une valeur

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table clef,description values clef1%desc1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table clef,description values clef1%desc1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table clef,description values clef1%desc1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table clef,description values clef1%desc1'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table clef,description values clef1%desc1'."> errstd") or diag($return_error);


##################
# Insert into empty_table values clef1%not_a_number%desc1
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Insert, Type : Erreur, Severite : 202
Message : La valeur donnee pour la colonne valeur n'est pas correcte.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table values clef1%not_a_number%desc1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table values clef1%not_a_number%desc1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table values clef1%not_a_number%desc1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table values clef1%not_a_number%desc1'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table values clef1%not_a_number%desc1'."> errstd") or diag($return_error);


##################
# Insert into empty_table values clef1%1%desc1
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table values clef1%1%desc1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table values clef1%1%desc1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table values clef1%1%desc1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table values clef1%1%desc1'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table values clef1%1%desc1'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef1%1%desc1

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef1%1%de...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Insert into empty_table values clef espace%1%desc espace
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Insert, Type : Erreur, Severite : 202
Message : Il y a trop de valeurs par rapport au nombre de colonnes

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table values clef espace%1%desc espace', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table values clef espace%1%desc espace'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table values clef espace%1%desc espace'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table values clef espace%1%desc espace'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table values clef espace%1%desc espace'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef1%1%desc1

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef1%1%de...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Insert into empty_table values "clef espace%1%desc espace"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table values "clef espace%1%desc espace"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table values "clef espace%1%desc espace"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table values "clef espace%1%desc espace"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table values "clef espace%1%desc espace"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table values "clef espace%1%desc espace"'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef1%1%desc1

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Insert into empty_table values "clef espace2" 1 "desc espace"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table values "clef espace2" 1 "desc espace"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table values "clef espace2" 1 "desc espace"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table values "clef espace2" 1 "desc espace"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table values "clef espace2" 1 "desc espace"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table values "clef espace2" 1 "desc espace"'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef1%1%desc1

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Insert into empty_table values "clef espace3%1" "desc espace"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table values "clef espace3%1" "desc espace"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table values "clef espace3%1" "desc espace"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table values "clef espace3%1" "desc espace"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table values "clef espace3%1" "desc espace"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table values "clef espace3%1" "desc espace"'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef1%1%desc1

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Insert into empty_table values clef1%1%insert
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Insert, Type : Erreur, Severite : 202
Message : Non unicite de la clef de la ligne a inserer

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table values clef1%1%insert', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table values clef1%1%insert'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table values clef1%1%insert'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table values clef1%1%insert'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table values clef1%1%insert'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef1%1%desc1

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Insert -f into empty_table values clef1%1%insert
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert -f into empty_table values clef1%1%insert', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert -f into empty_table values clef1%1%insert'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert -f into empty_table values clef1%1%insert'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert -f into empty_table values clef1%1%insert'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert -f into empty_table values clef1%1%insert'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef1%1%insert

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Insert into empty_table clef,valeur,description values clef2%2%desc2
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table clef,valeur,description values clef2%2%desc2', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table clef,valeur,description values clef2%2%desc2'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table clef,valeur,description values clef2%2%desc2'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table clef,valeur,description values clef2%2%desc2'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table clef,valeur,description values clef2%2%desc2'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef1%1%insert
clef2%2%desc2

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Insert into empty_table clef,valeur values clef3%3
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table clef,valeur values clef3%3', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table clef,valeur values clef3%3'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table clef,valeur values clef3%3'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table clef,valeur values clef3%3'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table clef,valeur values clef3%3'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef1%1%insert
clef2%2%desc2
clef3%3%

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Insert into empty_table valeur,description,clef values 4%desc4%clef4
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table valeur,description,clef values 4%desc4%clef4', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table valeur,description,clef values 4%desc4%clef4'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table valeur,description,clef values 4%desc4%clef4'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table valeur,description,clef values 4%desc4%clef4'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table valeur,description,clef values 4%desc4%clef4'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef1%1%insert
clef2%2%desc2
clef3%3%
clef4%4%desc4

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# echo clef5%5%desc5 | Insert into empty_table values -
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo clef5%5%desc5 | Insert into empty_table values -', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo clef5%5%desc5 | Insert into empty_table values -'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo clef5%5%desc5 | Insert into empty_table values -'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo clef5%5%desc5 | Insert into empty_table values -'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo clef5%5%desc5 | Insert into empty_table values -'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef1%1%insert
clef2%2%desc2
clef3%3%
clef4%4%desc4
clef5%5%desc5

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# echo clef espace4%5%desc espace | Insert into empty_table values -
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo clef espace4%5%desc espace | Insert into empty_table values -', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo clef espace4%5%desc espace | Insert into empty_table values -'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo clef espace4%5%desc espace | Insert into empty_table values -'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo clef espace4%5%desc espace | Insert into empty_table values -'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo clef espace4%5%desc espace | Insert into empty_table values -'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%2%desc2
clef3%3%
clef4%4%desc4
clef5%5%desc5

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# echo 6%clef6%desc6 | Insert into empty_table valeur,clef,description values -
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo 6%clef6%desc6 | Insert into empty_table valeur,clef,description values -', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo 6%clef6%desc6 | Insert into empty_table valeur,clef,description values -'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo 6%clef6%desc6 | Insert into empty_table valeur,clef,description values -'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo 6%clef6%desc6 | Insert into empty_table valeur,clef,description values -'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo 6%clef6%desc6 | Insert into empty_table valeur,clef,description values -'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%2%desc2
clef3%3%
clef4%4%desc4
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Insert into empty_table_nokey values clef1%1%desc1
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table_nokey values clef1%1%desc1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table_nokey values clef1%1%desc1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table_nokey values clef1%1%desc1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table_nokey values clef1%1%desc1'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table_nokey values clef1%1%desc1'."> errstd") or diag($return_error);


##################
# Select -s from empty_table_nokey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef1%1%desc1

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table_nokey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table_nokey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table_nokey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table_nokey'."> output <".q{clef1%1%de...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table_nokey'."> errstd") or diag($return_error);


##################
# Insert into empty_table_nokey values clef2%2%desc2
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table_nokey values clef2%2%desc2', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table_nokey values clef2%2%desc2'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table_nokey values clef2%2%desc2'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table_nokey values clef2%2%desc2'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table_nokey values clef2%2%desc2'."> errstd") or diag($return_error);


##################
# Select -s from empty_table_nokey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef1%1%desc1
clef2%2%desc2

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table_nokey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table_nokey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table_nokey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table_nokey'."> output <".q{clef1%1%de...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table_nokey'."> errstd") or diag($return_error);


##################
# Insert into empty_table_nokey values clef1%1%desc1
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into empty_table_nokey values clef1%1%desc1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into empty_table_nokey values clef1%1%desc1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into empty_table_nokey values clef1%1%desc1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into empty_table_nokey values clef1%1%desc1'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into empty_table_nokey values clef1%1%desc1'."> errstd") or diag($return_error);


##################
# Select -s from empty_table_nokey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef1%1%desc1
clef1%1%desc1
clef2%2%desc2

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table_nokey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table_nokey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table_nokey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table_nokey'."> output <".q{clef1%1%de...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table_nokey'."> errstd") or diag($return_error);


##################
# InsertAndExec into table_fkey values TEST:50:
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('InsertAndExec into table_fkey values TEST:50:', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'InsertAndExec into table_fkey values TEST:50:'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'InsertAndExec into table_fkey values TEST:50:'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'InsertAndExec into table_fkey values TEST:50:'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'InsertAndExec into table_fkey values TEST:50:'."> errstd") or diag($return_error);


##################
# Select -s from table_fkey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
composant1:1:composant d'ordre 1
composant2:2:composant d'ordre 2
composant1bis:1:composant d'ordre 1, bis
composant3:3:composant d'ordre 3
TEST:50:

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_fkey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_fkey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_fkey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_fkey'."> output <".q{composant1...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_fkey'."> errstd") or diag($return_error);


##################
# Select -s from table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20
2%deuxieme%20120101120000%0%40
3%troisieme%20100101120000%o%60
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20
50%Description avec espace%20110101000000%0%60

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple'."> errstd") or diag($return_error);


##################
# RemoveAndExec from table_fkey values TEST:50:
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('RemoveAndExec from table_fkey values TEST:50:', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'RemoveAndExec from table_fkey values TEST:50:'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'RemoveAndExec from table_fkey values TEST:50:'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'RemoveAndExec from table_fkey values TEST:50:'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'RemoveAndExec from table_fkey values TEST:50:'."> errstd") or diag($return_error);


##################
# Select -s from table_fkey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
composant1:1:composant d'ordre 1
composant2:2:composant d'ordre 2
composant1bis:1:composant d'ordre 1, bis
composant3:3:composant d'ordre 3

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_fkey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_fkey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_fkey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_fkey'."> output <".q{composant1...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_fkey'."> errstd") or diag($return_error);


##################
# Select -s from table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20
2%deuxieme%20120101120000%0%40
3%troisieme%20100101120000%o%60
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple'."> errstd") or diag($return_error);


##################
# Insert into table_simple ID values 100
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Insert into table_simple ID values 100', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Insert into table_simple ID values 100'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Insert into table_simple ID values 100'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Insert into table_simple ID values 100'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Insert into table_simple ID values 100'."> errstd") or diag($return_error);


##################
# Select -s from table_simple |perl -F% -ane '$F[2]=length($F[2]);print join("%",@F)'
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%14%1%20
2%deuxieme%14%0%40
3%troisieme%14%o%60
4%quatrieme%14%Y%80
5%cinquieme%14%Y%90
6%sixieme%14%Y%100n
7%septieme%15%Y%10
8%huitieme%14%errror_bool%10
toto%mauvais ID%14%0%20
100%%14%0%0

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple |perl -F% -ane \'$F[2]=length($F[2]);print join("%",@F)\'', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple |perl -F% -ane \'$F[2]=length($F[2]);print join("%",@F)\''."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple |perl -F% -ane \'$F[2]=length($F[2]);print join("%",@F)\''."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple |perl -F% -ane \'$F[2]=length($F[2]);print join("%",@F)\''."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple |perl -F% -ane \'$F[2]=length($F[2]);print join("%",@F)\''."> errstd") or diag($return_error);


##################
# Replace into empty_table values clef2%22%replace
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Replace into empty_table values clef2%22%replace', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Replace into empty_table values clef2%22%replace'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Replace into empty_table values clef2%22%replace'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Replace into empty_table values clef2%22%replace'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Replace into empty_table values clef2%22%replace'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%22%replace
clef3%3%
clef4%4%desc4
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Replace into empty_table values "clef3" "33" "replace1"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Replace into empty_table values "clef3" "33" "replace1"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Replace into empty_table values "clef3" "33" "replace1"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Replace into empty_table values "clef3" "33" "replace1"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Replace into empty_table values "clef3" "33" "replace1"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Replace into empty_table values "clef3" "33" "replace1"'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%22%replace
clef3%33%replace1
clef4%4%desc4
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Replace into empty_table values "clef3%33" "replace"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Replace into empty_table values "clef3%33" "replace"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Replace into empty_table values "clef3%33" "replace"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Replace into empty_table values "clef3%33" "replace"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Replace into empty_table values "clef3%33" "replace"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Replace into empty_table values "clef3%33" "replace"'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%22%replace
clef3%33%replace
clef4%4%desc4
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# echo clef4%44%replace | Replace into empty_table values -
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo clef4%44%replace | Replace into empty_table values -', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo clef4%44%replace | Replace into empty_table values -'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo clef4%44%replace | Replace into empty_table values -'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo clef4%44%replace | Replace into empty_table values -'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo clef4%44%replace | Replace into empty_table values -'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%22%replace
clef3%33%replace
clef4%44%replace
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Replace into empty_table_nokey values clef1%1%replace
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Replace, Type : Erreur, Severite : 202
Message : Impossible de remplacer une ligne sur une table sans clef

EXPECTED_ERRSTD
chomp $expected_error;

run3('Replace into empty_table_nokey values clef1%1%replace', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Replace into empty_table_nokey values clef1%1%replace'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Replace into empty_table_nokey values clef1%1%replace'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Replace into empty_table_nokey values clef1%1%replace'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Replace into empty_table_nokey values clef1%1%replace'."> errstd") or diag($return_error);


##################
# Select -s from empty_table_nokey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef1%1%desc1
clef1%1%desc1
clef2%2%desc2

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table_nokey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table_nokey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table_nokey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table_nokey'."> output <".q{clef1%1%de...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table_nokey'."> errstd") or diag($return_error);


##################
# Replace into empty_table_nokey values clef1%1%replace where clef=clef1
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Replace into empty_table_nokey values clef1%1%replace where clef=clef1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Replace into empty_table_nokey values clef1%1%replace where clef=clef1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Replace into empty_table_nokey values clef1%1%replace where clef=clef1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Replace into empty_table_nokey values clef1%1%replace where clef=clef1'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Replace into empty_table_nokey values clef1%1%replace where clef=clef1'."> errstd") or diag($return_error);


##################
# Select -s from empty_table_nokey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef1%1%replace
clef1%1%replace
clef2%2%desc2

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table_nokey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table_nokey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table_nokey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table_nokey'."> output <".q{clef1%1%re...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table_nokey'."> errstd") or diag($return_error);


##################
# Modify into empty_table values clef2%22%replace with clef2%222%modify
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Modify into empty_table values clef2%22%replace with clef2%222%modify', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Modify into empty_table values clef2%22%replace with clef2%222%modify'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Modify into empty_table values clef2%22%replace with clef2%222%modify'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Modify into empty_table values clef2%22%replace with clef2%222%modify'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Modify into empty_table values clef2%22%replace with clef2%222%modify'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%222%modify
clef3%33%replace
clef4%44%replace
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Modify into empty_table values clef2 22 replace with "clef3" "333" "modify"
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Modify, Type : Erreur, Severite : 202
Message : Vous ne pouvez pas remplacer une cle !

EXPECTED_ERRSTD
chomp $expected_error;

run3('Modify into empty_table values clef2 22 replace with "clef3" "333" "modify"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Modify into empty_table values clef2 22 replace with "clef3" "333" "modify"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Modify into empty_table values clef2 22 replace with "clef3" "333" "modify"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Modify into empty_table values clef2 22 replace with "clef3" "333" "modify"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Modify into empty_table values clef2 22 replace with "clef3" "333" "modify"'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%222%modify
clef3%33%replace
clef4%44%replace
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Modify into empty_table values clef3 33 replace with "clef3" "333" "modify"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Modify into empty_table values clef3 33 replace with "clef3" "333" "modify"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Modify into empty_table values clef3 33 replace with "clef3" "333" "modify"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Modify into empty_table values clef3 33 replace with "clef3" "333" "modify"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Modify into empty_table values clef3 33 replace with "clef3" "333" "modify"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Modify into empty_table values clef3 33 replace with "clef3" "333" "modify"'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%222%modify
clef3%333%modify
clef4%44%replace
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# echo clef4%44%replace | Modify into empty_table values - with clef4%444%modify
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo clef4%44%replace | Modify into empty_table values - with clef4%444%modify', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo clef4%44%replace | Modify into empty_table values - with clef4%444%modify'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo clef4%44%replace | Modify into empty_table values - with clef4%444%modify'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo clef4%44%replace | Modify into empty_table values - with clef4%444%modify'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo clef4%44%replace | Modify into empty_table values - with clef4%444%modify'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%222%modify
clef3%333%modify
clef4%444%modify
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# echo clef4%4444%modify2 | Modify into empty_table values clef4%444%modify with -
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo clef4%4444%modify2 | Modify into empty_table values clef4%444%modify with -', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo clef4%4444%modify2 | Modify into empty_table values clef4%444%modify with -'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo clef4%4444%modify2 | Modify into empty_table values clef4%444%modify with -'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo clef4%4444%modify2 | Modify into empty_table values clef4%444%modify with -'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo clef4%4444%modify2 | Modify into empty_table values clef4%444%modify with -'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%222%modify
clef3%333%modify
clef4%4444%modify2
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# perl -e "print qq{clef4%4444%modify2\nclef4%444%modify\n}" | Modify into empty_table values - with -
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('perl -e "print qq{clef4%4444%modify2\\nclef4%444%modify\\n}" | Modify into empty_table values - with -', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'perl -e "print qq{clef4%4444%modify2\\nclef4%444%modify\\n}" | Modify into empty_table values - with -'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'perl -e "print qq{clef4%4444%modify2\\nclef4%444%modify\\n}" | Modify into empty_table values - with -'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'perl -e "print qq{clef4%4444%modify2\\nclef4%444%modify\\n}" | Modify into empty_table values - with -'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'perl -e "print qq{clef4%4444%modify2\\nclef4%444%modify\\n}" | Modify into empty_table values - with -'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%222%modify
clef3%333%modify
clef4%444%modify
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Modify into empty_table_nokey values clef1%1%replace with clef1%1%modify
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Modify into empty_table_nokey values clef1%1%replace with clef1%1%modify', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Modify into empty_table_nokey values clef1%1%replace with clef1%1%modify'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Modify into empty_table_nokey values clef1%1%replace with clef1%1%modify'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Modify into empty_table_nokey values clef1%1%replace with clef1%1%modify'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Modify into empty_table_nokey values clef1%1%replace with clef1%1%modify'."> errstd") or diag($return_error);


##################
# Select -s from empty_table_nokey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef1%1%modify
clef1%1%modify
clef2%2%desc2

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table_nokey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table_nokey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table_nokey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table_nokey'."> output <".q{clef1%1%mo...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table_nokey'."> errstd") or diag($return_error);


##################
# Remove from empty_table
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Remove [-h] [-f] FROM <Table> VALUES <-|Values>
Procedure : Remove, Type : Erreur, Severite : 202
Message : Ligne de commande incorrecte

EXPECTED_ERRSTD
chomp $expected_error;

run3('Remove from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Remove from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Remove from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Remove from empty_table'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Remove from empty_table'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%222%modify
clef3%333%modify
clef4%444%modify
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Remove from empty_table VALUES clef5%5
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Remove, Type : Erreur, Severite : 202
Message : Il n'y a pas assez de valeurs par rapport au nombre de colonnes

EXPECTED_ERRSTD
chomp $expected_error;

run3('Remove from empty_table VALUES clef5%5', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Remove from empty_table VALUES clef5%5'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Remove from empty_table VALUES clef5%5'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Remove from empty_table VALUES clef5%5'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Remove from empty_table VALUES clef5%5'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%222%modify
clef3%333%modify
clef4%444%modify
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Remove from empty_table VALUES clef5%5%
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Remove, Type : Erreur, Severite : 202
Message : Aucune ligne trouvee a supprimer

EXPECTED_ERRSTD
chomp $expected_error;

run3('Remove from empty_table VALUES clef5%5%', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Remove from empty_table VALUES clef5%5%'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Remove from empty_table VALUES clef5%5%'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Remove from empty_table VALUES clef5%5%'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Remove from empty_table VALUES clef5%5%'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%222%modify
clef3%333%modify
clef4%444%modify
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Remove -f from empty_table VALUES clef5%5%
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Remove -f from empty_table VALUES clef5%5%', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Remove -f from empty_table VALUES clef5%5%'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Remove -f from empty_table VALUES clef5%5%'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Remove -f from empty_table VALUES clef5%5%'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Remove -f from empty_table VALUES clef5%5%'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%222%modify
clef3%333%modify
clef4%444%modify
clef5%5%desc5
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Remove from empty_table VALUES clef5%5%desc5
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Remove from empty_table VALUES clef5%5%desc5', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Remove from empty_table VALUES clef5%5%desc5'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Remove from empty_table VALUES clef5%5%desc5'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Remove from empty_table VALUES clef5%5%desc5'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Remove from empty_table VALUES clef5%5%desc5'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace%1%desc espace
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%222%modify
clef3%333%modify
clef4%444%modify
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Remove from empty_table VALUES "clef espace" "1" "desc espace"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Remove from empty_table VALUES "clef espace" "1" "desc espace"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Remove from empty_table VALUES "clef espace" "1" "desc espace"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Remove from empty_table VALUES "clef espace" "1" "desc espace"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Remove from empty_table VALUES "clef espace" "1" "desc espace"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Remove from empty_table VALUES "clef espace" "1" "desc espace"'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%222%modify
clef3%333%modify
clef4%444%modify
clef6%6%desc6

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# echo clef6%6%desc6 | Remove from empty_table values -
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo clef6%6%desc6 | Remove from empty_table values -', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo clef6%6%desc6 | Remove from empty_table values -'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo clef6%6%desc6 | Remove from empty_table values -'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo clef6%6%desc6 | Remove from empty_table values -'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo clef6%6%desc6 | Remove from empty_table values -'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef1%1%insert
clef2%222%modify
clef3%333%modify
clef4%444%modify

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Remove from empty_table_nokey VALUES clef1%1%modify
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Remove from empty_table_nokey VALUES clef1%1%modify', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Remove from empty_table_nokey VALUES clef1%1%modify'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Remove from empty_table_nokey VALUES clef1%1%modify'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Remove from empty_table_nokey VALUES clef1%1%modify'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Remove from empty_table_nokey VALUES clef1%1%modify'."> errstd") or diag($return_error);


##################
# Select -s from empty_table_nokey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef2%2%desc2

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table_nokey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table_nokey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table_nokey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table_nokey'."> output <".q{clef2%2%de...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table_nokey'."> errstd") or diag($return_error);


##################
# Delete from table_simple where ID=100
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Delete from table_simple where ID=100', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Delete from table_simple where ID=100'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Delete from table_simple where ID=100'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Delete from table_simple where ID=100'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Delete from table_simple where ID=100'."> errstd") or diag($return_error);


##################
# Select -s from table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
1%premier%20110101120000%1%20
2%deuxieme%20120101120000%0%40
3%troisieme%20100101120000%o%60
4%quatrieme%20110101140001%Y%80
5%cinquieme%20110101140002%Y%90
6%sixieme%20110101140003%Y%100n
7%septieme%20110101140004X%Y%10
8%huitieme%20110101140004%errror_bool%10
toto%mauvais ID%20110101140005%0%20

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from table_simple'."> output <".q{1%premier%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from table_simple'."> errstd") or diag($return_error);


##################
# Delete from empty_table where clef = clef1
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Delete from empty_table where clef = clef1', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Delete from empty_table where clef = clef1'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Delete from empty_table where clef = clef1'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Delete from empty_table where clef = clef1'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Delete from empty_table where clef = clef1'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef2%222%modify
clef3%333%modify
clef4%444%modify

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Delete from empty_table where clef = clef2 AND valeur = 4
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Delete from empty_table where clef = clef2 AND valeur = 4', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Delete from empty_table where clef = clef2 AND valeur = 4'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Delete from empty_table where clef = clef2 AND valeur = 4'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Delete from empty_table where clef = clef2 AND valeur = 4'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Delete from empty_table where clef = clef2 AND valeur = 4'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef2%222%modify
clef3%333%modify
clef4%444%modify

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Delete from empty_table where clef = clef4 AND valeur = 4
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Delete from empty_table where clef = clef4 AND valeur = 4', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Delete from empty_table where clef = clef4 AND valeur = 4'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Delete from empty_table where clef = clef4 AND valeur = 4'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Delete from empty_table where clef = clef4 AND valeur = 4'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Delete from empty_table where clef = clef4 AND valeur = 4'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef espace2%1%desc espace
clef espace3%1%desc espace
clef espace4%5%desc espace
clef2%222%modify
clef3%333%modify
clef4%444%modify

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef espac...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Delete from empty_table where description '~' desc
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Delete from empty_table where description \'~\' desc', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Delete from empty_table where description \'~\' desc'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Delete from empty_table where description \'~\' desc'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Delete from empty_table where description \'~\' desc'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Delete from empty_table where description \'~\' desc'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
clef2%222%modify
clef3%333%modify
clef4%444%modify

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{clef2%222%...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Delete from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Delete from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Delete from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Delete from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Delete from empty_table'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Delete from empty_table'."> errstd") or diag($return_error);


##################
# Select -s from empty_table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table'."> errstd") or diag($return_error);


##################
# Delete from empty_table_nokey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Delete from empty_table_nokey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Delete from empty_table_nokey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Delete from empty_table_nokey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Delete from empty_table_nokey'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Delete from empty_table_nokey'."> errstd") or diag($return_error);


##################
# Select -s from empty_table_nokey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from empty_table_nokey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from empty_table_nokey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from empty_table_nokey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from empty_table_nokey'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from empty_table_nokey'."> errstd") or diag($return_error);

