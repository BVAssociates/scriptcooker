#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;
use Test::More tests => 75;

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
# Search_File
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Search_File [-h] {-f|-e|-l|-d|-c|-t|-T|-p PATH} File | File.suf
Procedure : Search_File, Type : Erreur, Severite : 202
Message : Le nombre d'arguments est incorrect

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File'."> errstd") or diag($return_error);


##################
# Search_File table_simple
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Search_File [-h] {-f|-e|-l|-d|-c|-t|-T|-p PATH} File | File.suf
Procedure : Search_File, Type : Erreur, Severite : 202
Message : Option ou suffixe de recherche invalide !

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File table_simple'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File table_simple'."> errstd") or diag($return_error);


##################
# Search_File -t table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TOOLS_HOME/tab/table_simple

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -t table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -t table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -t table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -t table_simple'."> output <".q{TOOLS_HOME...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -t table_simple'."> errstd") or diag($return_error);


##################
# Search_File -T table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TOOLS_HOME/tab/table_simple

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -T table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -T table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -T table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -T table_simple'."> output <".q{TOOLS_HOME...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -T table_simple'."> errstd") or diag($return_error);


##################
# Search_File -p BV_TABPATH table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TOOLS_HOME/tab/table_simple

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -p BV_TABPATH table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -p BV_TABPATH table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -p BV_TABPATH table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -p BV_TABPATH table_simple'."> output <".q{TOOLS_HOME...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -p BV_TABPATH table_simple'."> errstd") or diag($return_error);

$ENV{TEST_PATH}=$ENV{TOOLS_HOME};

##################
# Search_File -p TEST_PATH profile.RT.minimal
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TOOLS_HOME/profile.RT.minimal

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -p TEST_PATH profile.RT.minimal', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -p TEST_PATH profile.RT.minimal'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -p TEST_PATH profile.RT.minimal'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -p TEST_PATH profile.RT.minimal'."> output <".q{TOOLS_HOME...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -p TEST_PATH profile.RT.minimal'."> errstd") or diag($return_error);


##################
# Search_File -t error_messages_file
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Search_File, Type : Erreur, Severite : 202
Message : Impossible de trouver la table error_messages_file

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -t error_messages_file', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -t error_messages_file'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -t error_messages_file'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -t error_messages_file'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -t error_messages_file'."> errstd") or diag($return_error);


##################
# Search_File -T error_messages_file
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
t/sample/tab/error_messages

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -T error_messages_file', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -T error_messages_file'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -T error_messages_file'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -T error_messages_file'."> output <".q{t/sample/t...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -T error_messages_file'."> errstd") or diag($return_error);


##################
# Search_File -T error_messages_file_bad
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Search_File, Type : Erreur, Severite : 202
Message : Impossible de trouver le fichier t/sample/tab/error_messages_xxx

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -T error_messages_file_bad', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -T error_messages_file_bad'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -T error_messages_file_bad'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -T error_messages_file_bad'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -T error_messages_file_bad'."> errstd") or diag($return_error);


##################
# Search_File -T error_messages_file_dyn
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TOOLS_HOME/tab/error_messages

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -T error_messages_file_dyn', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -T error_messages_file_dyn'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -T error_messages_file_dyn'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -T error_messages_file_dyn'."> output <".q{TOOLS_HOME...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -T error_messages_file_dyn'."> errstd") or diag($return_error);


##################
# Search_File -t error_messages_file_dyn
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Search_File, Type : Erreur, Severite : 202
Message : Impossible de trouver la table error_messages_file_dyn

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -t error_messages_file_dyn', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -t error_messages_file_dyn'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -t error_messages_file_dyn'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -t error_messages_file_dyn'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -t error_messages_file_dyn'."> errstd") or diag($return_error);


##################
# Search_File -T error_messages_file_dyn_bad
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Search_File, Type : Erreur, Severite : 202
Message : Impossible de trouver le fichier error_messages_xxx

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -T error_messages_file_dyn_bad', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -T error_messages_file_dyn_bad'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -T error_messages_file_dyn_bad'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -T error_messages_file_dyn_bad'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -T error_messages_file_dyn_bad'."> errstd") or diag($return_error);


##################
# Search_File -T error_messages_notab
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Search_File, Type : Erreur, Severite : 202
Message : Impossible de trouver la table error_messages_notab

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -T error_messages_notab', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -T error_messages_notab'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -T error_messages_notab'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -T error_messages_notab'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -T error_messages_notab'."> errstd") or diag($return_error);


##################
# Search_File -T table_command
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Search_File, Type : Erreur, Severite : 202
Message : La table table_command est une table virtuelle

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -T table_command', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -T table_command'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -T table_command'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -T table_command'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -T table_command'."> errstd") or diag($return_error);


##################
# Search_File -T logstd
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TOOLS_HOME/log/ITstd.log

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -T logstd', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -T logstd'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -T logstd'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -T logstd'."> output <".q{TOOLS_HOME...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -T logstd'."> errstd") or diag($return_error);


##################
# Search_File -d table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TOOLS_HOME/def/table_simple.def

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -d table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -d table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -d table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -d table_simple'."> output <".q{TOOLS_HOME...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -d table_simple'."> errstd") or diag($return_error);


##################
# Search_File -d error_messages_bad
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TOOLS_HOME/def/error_messages_bad.def

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -d error_messages_bad', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -d error_messages_bad'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -d error_messages_bad'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -d error_messages_bad'."> output <".q{TOOLS_HOME...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -d error_messages_bad'."> errstd") or diag($return_error);


##################
# Search_File table_simple.def
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TOOLS_HOME/def/table_simple.def

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File table_simple.def', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File table_simple.def'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File table_simple.def'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File table_simple.def'."> output <".q{TOOLS_HOME...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File table_simple.def'."> errstd") or diag($return_error);


##################
# Search_File -d table_simple.def
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TOOLS_HOME/def/table_simple.def

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -d table_simple.def', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -d table_simple.def'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -d table_simple.def'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -d table_simple.def'."> output <".q{TOOLS_HOME...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -d table_simple.def'."> errstd") or diag($return_error);


##################
# Search_File -c table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TOOLS_HOME/pci/table_simple.pci

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -c table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -c table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -c table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -c table_simple'."> output <".q{TOOLS_HOME...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -c table_simple'."> errstd") or diag($return_error);


##################
# Search_File table_simple.pci
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TOOLS_HOME/pci/table_simple.pci

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File table_simple.pci', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File table_simple.pci'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File table_simple.pci'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File table_simple.pci'."> output <".q{TOOLS_HOME...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File table_simple.pci'."> errstd") or diag($return_error);


##################
# Search_File -c table_simple.pci
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TOOLS_HOME/pci/table_simple.pci

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -c table_simple.pci', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -c table_simple.pci'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -c table_simple.pci'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -c table_simple.pci'."> output <".q{TOOLS_HOME...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -c table_simple.pci'."> errstd") or diag($return_error);


##################
# Search_File -e PC_LIST_TABLE
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
TOOLS_HOME/bin/PC_LIST_TABLE

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -e PC_LIST_TABLE', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -e PC_LIST_TABLE'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -e PC_LIST_TABLE'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -e PC_LIST_TABLE'."> output <".q{TOOLS_HOME...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -e PC_LIST_TABLE'."> errstd") or diag($return_error);


##################
# Search_File -f t/sample/bin/PC_LIST_TABLE
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
t/sample/bin/PC_LIST_TABLE

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -f t/sample/bin/PC_LIST_TABLE', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -f t/sample/bin/PC_LIST_TABLE'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -f t/sample/bin/PC_LIST_TABLE'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -f t/sample/bin/PC_LIST_TABLE'."> output <".q{t/sample/b...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -f t/sample/bin/PC_LIST_TABLE'."> errstd") or diag($return_error);


##################
# Search_File -f t/sample/bin/unknown_file
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Search_File, Type : Erreur, Severite : 202
Message : Impossible de trouver le fichier t/sample/bin/unknown_file

EXPECTED_ERRSTD
chomp $expected_error;

run3('Search_File -f t/sample/bin/unknown_file', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Search_File -f t/sample/bin/unknown_file'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Search_File -f t/sample/bin/unknown_file'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Search_File -f t/sample/bin/unknown_file'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Search_File -f t/sample/bin/unknown_file'."> errstd") or diag($return_error);

