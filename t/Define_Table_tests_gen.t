#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;
use Test::More tests => 63;

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
# Define_Table
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Define_Table [-h] <Table>
Procedure : Define_Table, Type : Erreur, Severite : 202
Message : Le nombre d'arguments est incorrect

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table'."> errstd") or diag($return_error);


##################
# Define_Table unknown_table
##################

$expected_code = 203;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Define_Table, Type : Erreur, Severite : 203
Message : Impossible de trouver ou d'ouvrir le fichier de definition unknown_table.def

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table unknown_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table unknown_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table unknown_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table unknown_table'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table unknown_table'."> errstd") or diag($return_error);


##################
# Define_Table error_messages_bad
##################

$expected_code = 203;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
La definition suivante est incorrecte :
BADFIELD="BADVALUE"
Procedure : Define_Table, Type : Erreur, Severite : 203
Message : Le fichier de definition error_messages_bad n'est pas valide

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table error_messages_bad', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table error_messages_bad'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table error_messages_bad'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table error_messages_bad'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table error_messages_bad'."> errstd") or diag($return_error);


##################
# Define_Table error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/error_messages.def' ; export DEFFILE
TABLE='error_messages' ; export TABLE
HEADER="Liste des messages d'erreur de variable evaluee" ; export HEADER
TYPE='FT' ; export TYPE
SEP=';' ; export SEP
FILE='TOOLS_HOME/tab/error_messages' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='Function;Error;Message' ; export FORMAT
SIZE='20s;4n;80s' ; export SIZE
ROW='$Function;$Error;$Message' ; export ROW
KEY='Function;Error' ; export KEY
NOTNULL='Function;Error;Message' ; export NOTNULL
SORT='' ; export SORT

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table error_messages'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table error_messages'."> errstd") or diag($return_error);


##################
# Define_Table error_messages_reverse
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/error_messages_reverse.def' ; export DEFFILE
TABLE='error_messages_reverse' ; export TABLE
HEADER="Liste des messages d'erreur de variable evaluee" ; export HEADER
TYPE='FT' ; export TYPE
SEP=';' ; export SEP
FILE='' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='Function;Error;Message' ; export FORMAT
SIZE='20s;4n;80s' ; export SIZE
ROW='$Function;$Error;$Message' ; export ROW
KEY='Function;Error' ; export KEY
NOTNULL='Function;Error;Message' ; export NOTNULL
SORT='Function,Error' ; export SORT

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table error_messages_reverse', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table error_messages_reverse'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table error_messages_reverse'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table error_messages_reverse'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table error_messages_reverse'."> errstd") or diag($return_error);


##################
# Define_Table error_messages.def
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/error_messages.def' ; export DEFFILE
TABLE='error_messages.def' ; export TABLE
HEADER="Liste des messages d'erreur de variable evaluee" ; export HEADER
TYPE='FT' ; export TYPE
SEP=';' ; export SEP
FILE='' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='Function;Error;Message' ; export FORMAT
SIZE='20s;4n;80s' ; export SIZE
ROW='$Function;$Error;$Message' ; export ROW
KEY='Function;Error' ; export KEY
NOTNULL='Function;Error;Message' ; export NOTNULL
SORT='' ; export SORT

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table error_messages.def', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table error_messages.def'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table error_messages.def'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table error_messages.def'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table error_messages.def'."> errstd") or diag($return_error);


##################
# Define_Table error_messages_notab
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/error_messages_notab.def' ; export DEFFILE
TABLE='error_messages_notab' ; export TABLE
HEADER='Liste des messages d erreur de test' ; export HEADER
TYPE='FT' ; export TYPE
SEP=';' ; export SEP
FILE='' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='Function;Error;Message' ; export FORMAT
SIZE='20s;4n;80s' ; export SIZE
ROW='$Function;$Error;$Message' ; export ROW
KEY='Function;Error' ; export KEY
NOTNULL='Function;Error;Message' ; export NOTNULL
SORT='Function,Error' ; export SORT

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table error_messages_notab', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table error_messages_notab'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table error_messages_notab'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table error_messages_notab'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table error_messages_notab'."> errstd") or diag($return_error);


##################
# Define_Table error_messages_file
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/error_messages_file.def' ; export DEFFILE
TABLE='error_messages_file' ; export TABLE
HEADER='Liste des messages d erreur de test' ; export HEADER
TYPE='FT' ; export TYPE
SEP=';' ; export SEP
FILE='t/sample/tab/error_messages' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='Function;Error;Message' ; export FORMAT
SIZE='20s;4n;80s' ; export SIZE
ROW='$Function;$Error;$Message' ; export ROW
KEY='Function;Error' ; export KEY
NOTNULL='Function;Error;Message' ; export NOTNULL
SORT='Function,Error' ; export SORT

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table error_messages_file', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table error_messages_file'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table error_messages_file'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table error_messages_file'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table error_messages_file'."> errstd") or diag($return_error);


##################
# Define_Table error_messages_file_bad
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/error_messages_file_bad.def' ; export DEFFILE
TABLE='error_messages_file_bad' ; export TABLE
HEADER='Liste des messages d erreur de test' ; export HEADER
TYPE='FT' ; export TYPE
SEP=';' ; export SEP
FILE='t/sample/tab/error_messages_xxx' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='Function;Error;Message' ; export FORMAT
SIZE='20s;4n;80s' ; export SIZE
ROW='$Function;$Error;$Message' ; export ROW
KEY='Function;Error' ; export KEY
NOTNULL='Function;Error;Message' ; export NOTNULL
SORT='Function,Error' ; export SORT

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table error_messages_file_bad', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table error_messages_file_bad'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table error_messages_file_bad'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table error_messages_file_bad'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table error_messages_file_bad'."> errstd") or diag($return_error);


##################
# Define_Table error_messages_file_dyn
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/error_messages_file_dyn.def' ; export DEFFILE
TABLE='error_messages_file_dyn' ; export TABLE
HEADER='Liste des messages d erreur de test' ; export HEADER
TYPE='FT' ; export TYPE
SEP=';' ; export SEP
FILE='`Search_File -t error_messages`' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='Function;Error;Message' ; export FORMAT
SIZE='20s;4n;80s' ; export SIZE
ROW='$Function;$Error;$Message' ; export ROW
KEY='Function;Error' ; export KEY
NOTNULL='Function;Error;Message' ; export NOTNULL
SORT='Function,Error' ; export SORT

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table error_messages_file_dyn', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table error_messages_file_dyn'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table error_messages_file_dyn'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table error_messages_file_dyn'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table error_messages_file_dyn'."> errstd") or diag($return_error);


##################
# Define_Table error_messages_file_dyn_bad
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/error_messages_file_dyn_bad.def' ; export DEFFILE
TABLE='error_messages_file_dyn_bad' ; export TABLE
HEADER='Liste des messages d erreur de test' ; export HEADER
TYPE='FT' ; export TYPE
SEP=';' ; export SEP
FILE='error_messages_xxx' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='Function;Error;Message' ; export FORMAT
SIZE='20s;4n;80s' ; export SIZE
ROW='$Function;$Error;$Message' ; export ROW
KEY='Function;Error' ; export KEY
NOTNULL='Function;Error;Message' ; export NOTNULL
SORT='Function,Error' ; export SORT

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table error_messages_file_dyn_bad', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table error_messages_file_dyn_bad'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table error_messages_file_dyn_bad'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table error_messages_file_dyn_bad'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table error_messages_file_dyn_bad'."> errstd") or diag($return_error);


##################
# Define_Table error_messages_doublesep
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/error_messages_doublesep.def' ; export DEFFILE
TABLE='error_messages_doublesep' ; export TABLE
HEADER="Liste des messages d'erreur de variable evaluee" ; export HEADER
TYPE='FT' ; export TYPE
SEP='%%' ; export SEP
FILE='TOOLS_HOME/tab/error_messages_doublesep' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='Function%%Error%%Message' ; export FORMAT
SIZE='20s%%4n%%80s' ; export SIZE
ROW='$Function%%$Error%%$Message' ; export ROW
KEY='Function%%Error' ; export KEY
NOTNULL='Function%%Error%%Message' ; export NOTNULL
SORT='' ; export SORT

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table error_messages_doublesep', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table error_messages_doublesep'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table error_messages_doublesep'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table error_messages_doublesep'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table error_messages_doublesep'."> errstd") or diag($return_error);


##################
# Define_Table pci
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/pci.def' ; export DEFFILE
TABLE='pci' ; export TABLE
HEADER='Panneau de commandes associé à la table ' ; export HEADER
TYPE='FT' ; export TYPE
SEP='~' ; export SEP
FILE='`Search_File $TableName.pci`' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='NodeType~Group~Label~Responsabilities~Condition~PreProcessing~Processor~Arguments~Confirm~PostProcessing~Icon' ; export FORMAT
SIZE='12s~20s~20s~12s~40s~30s~10s~30s~1b~30s~10s' ; export SIZE
ROW='$NodeType~$Group~$Label~$Responsabilities~$Condition~$PreProcessing~$Processor~$Arguments~$Confirm~$PostProcessing~$Icon' ; export ROW
KEY='NodeType~Label' ; export KEY
NOTNULL='' ; export NOTNULL
SORT='NodeType,Group,Label' ; export SORT

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table pci', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table pci'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table pci'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table pci'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table pci'."> errstd") or diag($return_error);


##################
# Define_Table logstd
##################

$expected_code = 201;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/logstd.def' ; export DEFFILE
TABLE='logstd' ; export TABLE
HEADER='Messages consignes' ; export HEADER
TYPE='FT' ; export TYPE
SEP='|' ; export SEP
FILE='$BV_LOGFILE' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='Date|Domain|Pere|Fils|User|Proc|TypeMessage|Severity|Message' ; export FORMAT
SIZE='19d|20s|6n|6n|8s|40s|20s|3n|100s' ; export SIZE
ROW='$Date|$Domain|$Pere|$Fils|$User|$Proc|$TypeMessage|$Severity|$Message' ; export ROW
KEY='' ; export KEY
NOTNULL='Date|Domain|Pere|Fils|User|Proc|TypeMessage|Severity|Message' ; export NOTNULL
SORT='' ; export SORT

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Define_Table, Type : Erreur, Severite : 201
Message : La table logstd ne possede pas de cle primaire.

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table logstd', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table logstd'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table logstd'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table logstd'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table logstd'."> errstd") or diag($return_error);


##################
# Define_Table table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/table_simple.def' ; export DEFFILE
TABLE='table_simple' ; export TABLE
HEADER='table simple' ; export HEADER
TYPE='FT' ; export TYPE
SEP='%' ; export SEP
FILE='TOOLS_HOME/tab/table_simple' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='ID%Description%Date%Bool%Pourcentage' ; export FORMAT
SIZE='4n%80s%20d%2b%10p' ; export SIZE
ROW='$ID%$Description%$Date%$Bool%$Pourcentage' ; export ROW
KEY='ID' ; export KEY
NOTNULL='' ; export NOTNULL
SORT='' ; export SORT

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table table_simple'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table table_simple'."> errstd") or diag($return_error);


##################
# Define_Table table_fkey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/table_fkey.def' ; export DEFFILE
TABLE='table_fkey' ; export TABLE
HEADER='table avec FKEY' ; export HEADER
TYPE='FT' ; export TYPE
SEP=':' ; export SEP
FILE='TOOLS_HOME/tab/table_fkey' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='Composant:Ordre:Description' ; export FORMAT
SIZE='20s:4n:80s' ; export SIZE
ROW='$Composant:$Ordre:$Description' ; export ROW
KEY='Composant' ; export KEY
NOTNULL='Ordre' ; export NOTNULL
SORT='' ; export SORT
FKEY01='[Ordre] on table_simple[ID]' ; export FKEY01
FKEY02='[Ordre] on table_fukey[ID]' ; export FKEY02

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table table_fkey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table table_fkey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table table_fkey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table table_fkey'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table table_fkey'."> errstd") or diag($return_error);


##################
# Define_Table table_fkey_double
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/table_fkey_double.def' ; export DEFFILE
TABLE='table_fkey_double' ; export TABLE
HEADER='table avec FKEY' ; export HEADER
TYPE='FT' ; export TYPE
SEP=':' ; export SEP
FILE='' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='Composant:Ordre:Description' ; export FORMAT
SIZE='20s:4n:80s' ; export SIZE
ROW='$Composant:$Ordre:$Description' ; export ROW
KEY='Composant' ; export KEY
NOTNULL='Ordre' ; export NOTNULL
SORT='' ; export SORT
FKEY01='[Ordre,Composant] on table_simple[ID,Description]' ; export FKEY01

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table table_fkey_double', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table table_fkey_double'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table table_fkey_double'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table table_fkey_double'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table table_fkey_double'."> errstd") or diag($return_error);


##################
# Define_Table table_fukey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/table_fukey.def' ; export DEFFILE
TABLE='table_fukey' ; export TABLE
HEADER='table avec FUKEY' ; export HEADER
TYPE='FT' ; export TYPE
SEP=';' ; export SEP
FILE='TOOLS_HOME/tab/table_fukey' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='ID;Description' ; export FORMAT
SIZE='4n;80s' ; export SIZE
ROW='$ID;$Description' ; export ROW
KEY='ID' ; export KEY
NOTNULL='' ; export NOTNULL
SORT='' ; export SORT
FUKEY01='[ID] on table_simple[ID]' ; export FUKEY01

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table table_fukey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table table_fukey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table table_fukey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table table_fukey'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table table_fukey'."> errstd") or diag($return_error);


##################
# Define_Table table_fukey2
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
DEFFILE='TOOLS_HOME/def/table_fukey2.def' ; export DEFFILE
TABLE='table_fukey2' ; export TABLE
HEADER='table avec FUKEY recursive' ; export HEADER
TYPE='FT' ; export TYPE
SEP=';' ; export SEP
FILE='TOOLS_HOME/tab/table_fukey2' ; export FILE
COMMAND='' ; export COMMAND
FORMAT='ID;Description' ; export FORMAT
SIZE='4n;80s' ; export SIZE
ROW='$ID;$Description' ; export ROW
KEY='ID' ; export KEY
NOTNULL='' ; export NOTNULL
SORT='' ; export SORT
FUKEY01='[ID] on table_simple[ID]' ; export FUKEY01
FUKEY02='[ID] on table_fukey3[ID]' ; export FUKEY02

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table table_fukey2', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table table_fukey2'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table table_fukey2'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table table_fukey2'."> output <".q{DEFFILE='T...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table table_fukey2'."> errstd") or diag($return_error);


##################
# Define_Table table_fkey_error
##################

$expected_code = 203;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Define_Table, Type : Erreur, Severite : 203
Message : Impossible de trouver ou d'ouvrir le fichier de definition table_error.def

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table table_fkey_error', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table table_fkey_error'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table table_fkey_error'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table table_fkey_error'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table table_fkey_error'."> errstd") or diag($return_error);


##################
# Define_Table table_fkey_field_error
##################

$expected_code = 203;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Define_Table, Type : Erreur, Severite : 203
Message : La colonne field_error (Table table_simple) n'existe pas

EXPECTED_ERRSTD
chomp $expected_error;

run3('Define_Table table_fkey_field_error', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Define_Table table_fkey_field_error'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Define_Table table_fkey_field_error'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Define_Table table_fkey_field_error'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Define_Table table_fkey_field_error'."> errstd") or diag($return_error);

