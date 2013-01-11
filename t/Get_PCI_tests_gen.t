#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;
use Test::More tests => 48;

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
# Get_PCI
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Get_PCI [-h] [-e] [-t] [-s] FOR <Table> 
 		  [WHERE <Condition>] [WITH JOIN [ Condition ]]
Procedure : Get_PCI, Type : Erreur, Severite : 202
Message : Ligne de commande incorrecte

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI'."> errstd") or diag($return_error);


##################
# Get_PCI FOR unknown_table
##################

$expected_code = 203;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Get_PCI, Type : Erreur, Severite : 203
Message : Impossible de trouver ou d'ouvrir le fichier de definition unknown_table.def

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI FOR unknown_table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI FOR unknown_table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI FOR unknown_table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI FOR unknown_table'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI FOR unknown_table'."> errstd") or diag($return_error);


##################
# Get_PCI FOR error_messages
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='~'@@FORMAT='NodeType~Group~Label~Responsabilities~Condition~PreProcessing~Processor~Arguments~Confirm~PostProcessing~Icon'@@ROW='$NodeType~$Group~$Label~$Responsabilities~$Condition~$PreProcessing~$Processor~$Arguments~$Confirm~$PostProcessing~$Icon'@@SIZE='12s~20s~20s~12s~40s~30s~10s~30s~1b~30s~10s'@@HEADER='Panneau de commandes associé à la table '@@KEY='NodeType~Label'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI FOR error_messages', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI FOR error_messages'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI FOR error_messages'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI FOR error_messages'."> output <".q{SEP='~'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI FOR error_messages'."> errstd") or diag($return_error);


##################
# Get_PCI FOR table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='~'@@FORMAT='NodeType~Group~Label~Responsabilities~Condition~PreProcessing~Processor~Arguments~Confirm~PostProcessing~Icon'@@ROW='$NodeType~$Group~$Label~$Responsabilities~$Condition~$PreProcessing~$Processor~$Arguments~$Confirm~$PostProcessing~$Icon'@@SIZE='12s~20s~20s~12s~40s~30s~10s~30s~1b~30s~10s'@@HEADER='Panneau de commandes associé à la table '@@KEY='NodeType~Label'
Table~~explorer~user~~~Explore~~~~Expand
Item~Explorer~clef etrangeres~user~~~Explore~table_fkey~~~Expand
Item~Explorer~clef etrangeres FUKEY~user~~~Explore~table_fukey~~~Expand
Item~Test~desactivé~user~perl -e 'exit 1'~~Explore~table_fkey~~~Expand
Item~Test~activé~user~perl -e 'exit 0'~~Explore~table_fkey~~~Expand
Item~Test $TEST_VAR~variable $TEST_VAR~user,$TEST_VAR~perl -e 'exit length "$TEST_VAR"'~~Explore~$TEST_VAR~$TEST_VAR~$TEST_VAR~$TEST_VAR
Item~Test ${TEST_VAR}~variable ${TEST_VAR}~user,${TEST_VAR}~perl -e 'exit length "${TEST_VAR}"'~~Explore~${TEST_VAR}~${TEST_VAR}~${TEST_VAR}~${TEST_VAR}

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI FOR table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI FOR table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI FOR table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI FOR table_simple'."> output <".q{SEP='~'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI FOR table_simple'."> errstd") or diag($return_error);


##################
# Get_PCI FOR table_simple WHERE NodeType = Table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='~'@@FORMAT='NodeType~Group~Label~Responsabilities~Condition~PreProcessing~Processor~Arguments~Confirm~PostProcessing~Icon'@@ROW='$NodeType~$Group~$Label~$Responsabilities~$Condition~$PreProcessing~$Processor~$Arguments~$Confirm~$PostProcessing~$Icon'@@SIZE='12s~20s~20s~12s~40s~30s~10s~30s~1b~30s~10s'@@HEADER='Panneau de commandes associé à la table '@@KEY='NodeType~Label'
Table~~explorer~user~~~Explore~~~~Expand

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI FOR table_simple WHERE NodeType = Table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI FOR table_simple WHERE NodeType = Table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI FOR table_simple WHERE NodeType = Table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI FOR table_simple WHERE NodeType = Table'."> output <".q{SEP='~'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI FOR table_simple WHERE NodeType = Table'."> errstd") or diag($return_error);


##################
# Get_PCI FOR table_fkey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='~'@@FORMAT='NodeType~Group~Label~Responsabilities~Condition~PreProcessing~Processor~Arguments~Confirm~PostProcessing~Icon'@@ROW='$NodeType~$Group~$Label~$Responsabilities~$Condition~$PreProcessing~$Processor~$Arguments~$Confirm~$PostProcessing~$Icon'@@SIZE='12s~20s~20s~12s~40s~30s~10s~30s~1b~30s~10s'@@HEADER='Panneau de commandes associé à la table '@@KEY='NodeType~Label'
Table~~explorer~user~~~Explore~~~~Expand
Item~Action~script~user~~~ExecuteProcedure~ls~~~Expand
~Insert~PreAction~~perl -e "exit 1"~~ExecuteProcedure~nope~~~
~Insert~PostAction~~~{DESC="Description avec espace"}{DATE=20110101000000}{PORCENT='60'}~ExecuteProcedure~InsertAndExec into table_simple values "$Ordre%$DESC%$DATE%%$PORCENT"~~~
~Remove~PreAction~~~~ExecuteProcedure~Delete from table_simple Where ID=$Ordre~~~

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI FOR table_fkey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI FOR table_fkey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI FOR table_fkey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI FOR table_fkey'."> output <".q{SEP='~'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI FOR table_fkey'."> errstd") or diag($return_error);


##################
# Get_PCI FOR table_fukey
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='~'@@FORMAT='NodeType~Group~Label~Responsabilities~Condition~PreProcessing~Processor~Arguments~Confirm~PostProcessing~Icon'@@ROW='$NodeType~$Group~$Label~$Responsabilities~$Condition~$PreProcessing~$Processor~$Arguments~$Confirm~$PostProcessing~$Icon'@@SIZE='12s~20s~20s~12s~40s~30s~10s~30s~1b~30s~10s'@@HEADER='Panneau de commandes associé à la table '@@KEY='NodeType~Label'
Table~~explorer~user~~~Explore~~~~Expand
Item~Action~script~user~~~ExecuteProcedure~ls~~~Expand

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI FOR table_fukey', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI FOR table_fukey'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI FOR table_fukey'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI FOR table_fukey'."> output <".q{SEP='~'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI FOR table_fukey'."> errstd") or diag($return_error);


##################
# Get_PCI FOR table_fkey WITH JOIN
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='~'@@FORMAT='NodeType~Group~Label~Responsabilities~Condition~PreProcessing~Processor~Arguments~Confirm~PostProcessing~Icon'@@ROW='$NodeType~$Group~$Label~$Responsabilities~$Condition~$PreProcessing~$Processor~$Arguments~$Confirm~$PostProcessing~$Icon'@@SIZE='12s~20s~20s~12s~40s~30s~10s~30s~1b~30s~10s'@@HEADER='Panneau de commandes associé à la table '@@KEY='NodeType~Label'
Table~~explorer~user~~~Explore~~~~Expand
Item~Action~script~user~~~ExecuteProcedure~ls~~~Expand
~Insert~PreAction~~perl -e "exit 1"~~ExecuteProcedure~nope~~~
~Insert~PostAction~~~{DESC="Description avec espace"}{DATE=20110101000000}{PORCENT='60'}~ExecuteProcedure~InsertAndExec into table_simple values "$Ordre%$DESC%$DATE%%$PORCENT"~~~
~Remove~PreAction~~~~ExecuteProcedure~Delete from table_simple Where ID=$Ordre~~~

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI FOR table_fkey WITH JOIN', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI FOR table_fkey WITH JOIN'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI FOR table_fkey WITH JOIN'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI FOR table_fkey WITH JOIN'."> output <".q{SEP='~'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI FOR table_fkey WITH JOIN'."> errstd") or diag($return_error);


##################
# Get_PCI FOR table_fukey WITH JOIN
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='~'@@FORMAT='NodeType~Group~Label~Responsabilities~Condition~PreProcessing~Processor~Arguments~Confirm~PostProcessing~Icon'@@ROW='$NodeType~$Group~$Label~$Responsabilities~$Condition~$PreProcessing~$Processor~$Arguments~$Confirm~$PostProcessing~$Icon'@@SIZE='12s~20s~20s~12s~40s~30s~10s~30s~1b~30s~10s'@@HEADER='Panneau de commandes associé à la table '@@KEY='NodeType~Label'
Table~~explorer~user~~~Explore~~~~Expand
Item~Action~script~user~~~ExecuteProcedure~ls~~~Expand
Table~~explorer~user~~~Explore~~~~Expand
Item~Explorer~clef etrangeres~user~~~Explore~table_fkey~~~Expand
Item~Explorer~clef etrangeres FUKEY~user~~~Explore~table_fukey~~~Expand
Item~Test~desactivé~user~perl -e 'exit 1'~~Explore~table_fkey~~~Expand
Item~Test~activé~user~perl -e 'exit 0'~~Explore~table_fkey~~~Expand
Item~Test $TEST_VAR~variable $TEST_VAR~user,$TEST_VAR~perl -e 'exit length "$TEST_VAR"'~~Explore~$TEST_VAR~$TEST_VAR~$TEST_VAR~$TEST_VAR
Item~Test ${TEST_VAR}~variable ${TEST_VAR}~user,${TEST_VAR}~perl -e 'exit length "${TEST_VAR}"'~~Explore~${TEST_VAR}~${TEST_VAR}~${TEST_VAR}~${TEST_VAR}

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI FOR table_fukey WITH JOIN', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI FOR table_fukey WITH JOIN'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI FOR table_fukey WITH JOIN'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI FOR table_fukey WITH JOIN'."> output <".q{SEP='~'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI FOR table_fukey WITH JOIN'."> errstd") or diag($return_error);


##################
# Get_PCI FOR table_fukey WITH JOIN NodeType = Table
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='~'@@FORMAT='NodeType~Group~Label~Responsabilities~Condition~PreProcessing~Processor~Arguments~Confirm~PostProcessing~Icon'@@ROW='$NodeType~$Group~$Label~$Responsabilities~$Condition~$PreProcessing~$Processor~$Arguments~$Confirm~$PostProcessing~$Icon'@@SIZE='12s~20s~20s~12s~40s~30s~10s~30s~1b~30s~10s'@@HEADER='Panneau de commandes associé à la table '@@KEY='NodeType~Label'
Table~~explorer~user~~~Explore~~~~Expand
Item~Action~script~user~~~ExecuteProcedure~ls~~~Expand
Table~~explorer~user~~~Explore~~~~Expand

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI FOR table_fukey WITH JOIN NodeType = Table', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI FOR table_fukey WITH JOIN NodeType = Table'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI FOR table_fukey WITH JOIN NodeType = Table'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI FOR table_fukey WITH JOIN NodeType = Table'."> output <".q{SEP='~'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI FOR table_fukey WITH JOIN NodeType = Table'."> errstd") or diag($return_error);


##################
# Get_PCI -s FOR table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Table~~explorer~user~~~Explore~~~~Expand
Item~Explorer~clef etrangeres~user~~~Explore~table_fkey~~~Expand
Item~Explorer~clef etrangeres FUKEY~user~~~Explore~table_fukey~~~Expand
Item~Test~desactivé~user~perl -e 'exit 1'~~Explore~table_fkey~~~Expand
Item~Test~activé~user~perl -e 'exit 0'~~Explore~table_fkey~~~Expand
Item~Test $TEST_VAR~variable $TEST_VAR~user,$TEST_VAR~perl -e 'exit length "$TEST_VAR"'~~Explore~$TEST_VAR~$TEST_VAR~$TEST_VAR~$TEST_VAR
Item~Test ${TEST_VAR}~variable ${TEST_VAR}~user,${TEST_VAR}~perl -e 'exit length "${TEST_VAR}"'~~Explore~${TEST_VAR}~${TEST_VAR}~${TEST_VAR}~${TEST_VAR}

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI -s FOR table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI -s FOR table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI -s FOR table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI -s FOR table_simple'."> output <".q{Table~~exp...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI -s FOR table_simple'."> errstd") or diag($return_error);


##################
# Get_PCI -t FOR table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='~'@@FORMAT='NodeType~Group~Label~Responsabilities~Condition~PreProcessing~Processor~Arguments~Confirm~PostProcessing~Icon'@@ROW='$NodeType~$Group~$Label~$Responsabilities~$Condition~$PreProcessing~$Processor~$Arguments~$Confirm~$PostProcessing~$Icon'@@SIZE='12s~20s~20s~12s~40s~30s~10s~30s~1b~30s~10s'@@HEADER='Panneau de commandes associé à la table '@@KEY='NodeType~Label'
Table~~explorer~user~true~~Explore~~~~Expand
Item~Explorer~clef etrangeres~user~true~~Explore~table_fkey~~~Expand
Item~Explorer~clef etrangeres FUKEY~user~true~~Explore~table_fukey~~~Expand
Item~Test~desactivé~user~false~~Explore~table_fkey~~~Expand
Item~Test~activé~user~true~~Explore~table_fkey~~~Expand
Item~Test $TEST_VAR~variable $TEST_VAR~user,$TEST_VAR~true~~Explore~$TEST_VAR~$TEST_VAR~$TEST_VAR~$TEST_VAR
Item~Test ${TEST_VAR}~variable ${TEST_VAR}~user,${TEST_VAR}~true~~Explore~${TEST_VAR}~${TEST_VAR}~${TEST_VAR}~${TEST_VAR}

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI -t FOR table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI -t FOR table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI -t FOR table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI -t FOR table_simple'."> output <".q{SEP='~'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI -t FOR table_simple'."> errstd") or diag($return_error);

delete $ENV{TEST_VAR};

##################
# Get_PCI -e FOR table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='~'@@FORMAT='NodeType~Group~Label~Responsabilities~Condition~PreProcessing~Processor~Arguments~Confirm~PostProcessing~Icon'@@ROW='$NodeType~$Group~$Label~$Responsabilities~$Condition~$PreProcessing~$Processor~$Arguments~$Confirm~$PostProcessing~$Icon'@@SIZE='12s~20s~20s~12s~40s~30s~10s~30s~1b~30s~10s'@@HEADER='Panneau de commandes associé à la table '@@KEY='NodeType~Label'
Table~~explorer~user~~~Explore~~~~Expand
Item~Explorer~clef etrangeres~user~~~Explore~table_fkey~~~Expand
Item~Explorer~clef etrangeres FUKEY~user~~~Explore~table_fukey~~~Expand
Item~Test~desactivé~user~perl -e 'exit 1'~~Explore~table_fkey~~~Expand
Item~Test~activé~user~perl -e 'exit 0'~~Explore~table_fkey~~~Expand
Item~Test $TEST_VAR~variable $TEST_VAR~user,$TEST_VAR~perl -e 'exit length "$TEST_VAR"'~~Explore~$TEST_VAR~$TEST_VAR~$TEST_VAR~$TEST_VAR
Item~Test ${TEST_VAR}~variable ${TEST_VAR}~user,${TEST_VAR}~perl -e 'exit length "${TEST_VAR}"'~~Explore~${TEST_VAR}~${TEST_VAR}~${TEST_VAR}~${TEST_VAR}

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI -e FOR table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI -e FOR table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI -e FOR table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI -e FOR table_simple'."> output <".q{SEP='~'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI -e FOR table_simple'."> errstd") or diag($return_error);


##################
# Get_PCI -est FOR table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Table~~explorer~user~true~~Explore~~~~Expand
Item~Explorer~clef etrangeres~user~true~~Explore~table_fkey~~~Expand
Item~Explorer~clef etrangeres FUKEY~user~true~~Explore~table_fukey~~~Expand
Item~Test~desactivé~user~false~~Explore~table_fkey~~~Expand
Item~Test~activé~user~true~~Explore~table_fkey~~~Expand
Item~Test $TEST_VAR~variable $TEST_VAR~user,$TEST_VAR~true~~Explore~$TEST_VAR~$TEST_VAR~$TEST_VAR~$TEST_VAR
Item~Test ${TEST_VAR}~variable ${TEST_VAR}~user,${TEST_VAR}~true~~Explore~${TEST_VAR}~${TEST_VAR}~${TEST_VAR}~${TEST_VAR}

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI -est FOR table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI -est FOR table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI -est FOR table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI -est FOR table_simple'."> output <".q{Table~~exp...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI -est FOR table_simple'."> errstd") or diag($return_error);

$ENV{TEST_VAR}='test_value';

##################
# Get_PCI -e FOR table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP='~'@@FORMAT='NodeType~Group~Label~Responsabilities~Condition~PreProcessing~Processor~Arguments~Confirm~PostProcessing~Icon'@@ROW='$NodeType~$Group~$Label~$Responsabilities~$Condition~$PreProcessing~$Processor~$Arguments~$Confirm~$PostProcessing~$Icon'@@SIZE='12s~20s~20s~12s~40s~30s~10s~30s~1b~30s~10s'@@HEADER='Panneau de commandes associé à la table '@@KEY='NodeType~Label'
Table~~explorer~user~~~Explore~~~~Expand
Item~Explorer~clef etrangeres~user~~~Explore~table_fkey~~~Expand
Item~Explorer~clef etrangeres FUKEY~user~~~Explore~table_fukey~~~Expand
Item~Test~desactivé~user~perl -e 'exit 1'~~Explore~table_fkey~~~Expand
Item~Test~activé~user~perl -e 'exit 0'~~Explore~table_fkey~~~Expand
Item~Test test_value~variable test_value~user,test_value~perl -e 'exit length "test_value"'~~Explore~test_value~test_value~test_value~test_value
Item~Test test_value~variable test_value~user,test_value~perl -e 'exit length "test_value"'~~Explore~test_value~test_value~test_value~test_value

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI -e FOR table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI -e FOR table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI -e FOR table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI -e FOR table_simple'."> output <".q{SEP='~'@@F...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI -e FOR table_simple'."> errstd") or diag($return_error);


##################
# Get_PCI -est FOR table_simple
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
Table~~explorer~user~true~~Explore~~~~Expand
Item~Explorer~clef etrangeres~user~true~~Explore~table_fkey~~~Expand
Item~Explorer~clef etrangeres FUKEY~user~true~~Explore~table_fukey~~~Expand
Item~Test~desactivé~user~false~~Explore~table_fkey~~~Expand
Item~Test~activé~user~true~~Explore~table_fkey~~~Expand
Item~Test test_value~variable test_value~user,test_value~false~~Explore~test_value~test_value~test_value~test_value
Item~Test test_value~variable test_value~user,test_value~false~~Explore~test_value~test_value~test_value~test_value

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_PCI -est FOR table_simple', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_PCI -est FOR table_simple'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_PCI -est FOR table_simple'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_PCI -est FOR table_simple'."> output <".q{Table~~exp...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_PCI -est FOR table_simple'."> errstd") or diag($return_error);

