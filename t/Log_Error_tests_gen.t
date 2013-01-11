#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;
use Test::More tests => 111;

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
# Purge_Log logstd
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Purge_Log logstd', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Purge_Log logstd'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Purge_Log logstd'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Purge_Log logstd'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Purge_Log logstd'."> errstd") or diag($return_error);


##################
# Purge_Log logerr
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Purge_Log logerr', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Purge_Log logerr'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Purge_Log logerr'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Purge_Log logerr'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Purge_Log logerr'."> errstd") or diag($return_error);

delete $ENV{BV_PROC};
delete $ENV{BV_DOMAIN};
delete $ENV{BV_PERE};
delete $ENV{BV_FILS};

##################
# Log_Error
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Log_Error, Type : Erreur, Severite : 202
Message : Variable d'environnement BV_PROC manquante ou non exportee !

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Error', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Error'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Error'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Error'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Error'."> errstd") or diag($return_error);


##################
# Purge_Log logstd
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Purge_Log logstd', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Purge_Log logstd'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Purge_Log logstd'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Purge_Log logstd'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Purge_Log logstd'."> errstd") or diag($return_error);


##################
# Purge_Log logerr
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Purge_Log logerr', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Purge_Log logerr'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Purge_Log logerr'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Purge_Log logerr'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Purge_Log logerr'."> errstd") or diag($return_error);

$ENV{BV_PROC}="proc_test";
$ENV{BV_DOMAIN}="domaine_test";
$ENV{BV_PERE}=1;
$ENV{BV_FILS}=7777;
delete $ENV{BV_SEVERITE};

##################
# Log_Start
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Debut, Severite : 0
Message : Debut du traitement de proc_test

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Start', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Start'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Start'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Start'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Start'."> errstd") or diag($return_error);


##################
# Log_Error 100 "test d'erreur"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Erreur, Severite : 0
Message : test d'erreur

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Error 100 "test d\'erreur"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Error 100 "test d\'erreur"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Error 100 "test d\'erreur"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Error 100 "test d\'erreur"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Error 100 "test d\'erreur"'."> errstd") or diag($return_error);


##################
# Log_Error -- -o 100 "test d'erreur"
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Usage : Log_Error [-h] [-s] [-l] [-o] <NumError> [<Message>]
Procedure : proc_test, Type : Erreur, Severite : 202
Message : Le numero d'erreur -o n'est pas correct

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Error -- -o 100 "test d\'erreur"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Error -- -o 100 "test d\'erreur"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Error -- -o 100 "test d\'erreur"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Error -- -o 100 "test d\'erreur"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Error -- -o 100 "test d\'erreur"'."> errstd") or diag($return_error);


##################
# Log_Info "test d'info"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Info, Severite : 0
Message : test d'info

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Info "test d\'info"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Info "test d\'info"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Info "test d\'info"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Info "test d\'info"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Info "test d\'info"'."> errstd") or diag($return_error);


##################
# Log_Info -- -o "test d'info"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Info, Severite : 0
Message : -o test d'info

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Info -- -o "test d\'info"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Info -- -o "test d\'info"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Info -- -o "test d\'info"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Info -- -o "test d\'info"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Info -- -o "test d\'info"'."> errstd") or diag($return_error);


##################
# Log_End
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Resultat, Severite : 0
Message : Fin normale du processus numero 7777 de nom proc_test

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_End', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_End'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_End'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_End'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_End'."> errstd") or diag($return_error);

$ENV{BV_SEVERITE}=0;

##################
# Log_Start
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Debut, Severite : 0
Message : Debut du traitement de proc_test

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Start', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Start'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Start'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Start'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Start'."> errstd") or diag($return_error);


##################
# Log_Error 99 "id col" "T1"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Erreur, Severite : 0
Message : Le champ id col est mal decrit dans la table T1

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Error 99 "id col" "T1"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Error 99 "id col" "T1"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Error 99 "id col" "T1"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Error 99 "id col" "T1"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Error 99 "id col" "T1"'."> errstd") or diag($return_error);


##################
# Log_Error -- 99 "id col" "T2"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Erreur, Severite : 0
Message : Le champ id col est mal decrit dans la table T2

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Error -- 99 "id col" "T2"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Error -- 99 "id col" "T2"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Error -- 99 "id col" "T2"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Error -- 99 "id col" "T2"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Error -- 99 "id col" "T2"'."> errstd") or diag($return_error);


##################
# Log_Info "test d'info"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Info, Severite : 0
Message : test d'info

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Info "test d\'info"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Info "test d\'info"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Info "test d\'info"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Info "test d\'info"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Info "test d\'info"'."> errstd") or diag($return_error);


##################
# Log_End
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Resultat, Severite : 0
Message : Fin normale du processus numero 7777 de nom proc_test

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_End', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_End'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_End'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_End'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_End'."> errstd") or diag($return_error);

$ENV{BV_DOMAIN}="autredomaine_test";
$ENV{BV_SEVERITE}=200;

##################
# Log_Start
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Debut, Severite : 0
Message : Debut du traitement de proc_test

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Start', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Start'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Start'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Start'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Start'."> errstd") or diag($return_error);


##################
# Log_Error 100 "test d'erreur"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Erreur, Severite : 200
Message : test d'erreur

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Error 100 "test d\'erreur"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Error 100 "test d\'erreur"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Error 100 "test d\'erreur"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Error 100 "test d\'erreur"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Error 100 "test d\'erreur"'."> errstd") or diag($return_error);


##################
# Log_Info "test d'info"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Info, Severite : 200
Message : test d'info

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Info "test d\'info"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Info "test d\'info"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Info "test d\'info"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Info "test d\'info"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Info "test d\'info"'."> errstd") or diag($return_error);


##################
# Log_End
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Resultat, Severite : 200
Message : Fin anormale du processus numero 7777 de nom proc_test

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_End', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_End'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_End'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_End'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_End'."> errstd") or diag($return_error);


##################
# Log_Start -s
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Debut, Severite : 0
Message : Debut du traitement de proc_test

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Start -s', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Start -s'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Start -s'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Start -s'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Start -s'."> errstd") or diag($return_error);


##################
# Log_Error -s 100 "test d'erreur"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Erreur, Severite : 200
Message : test d'erreur

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Error -s 100 "test d\'erreur"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Error -s 100 "test d\'erreur"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Error -s 100 "test d\'erreur"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Error -s 100 "test d\'erreur"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Error -s 100 "test d\'erreur"'."> errstd") or diag($return_error);


##################
# Log_Info -s "test d'info"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Info, Severite : 200
Message : test d'info

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Info -s "test d\'info"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Info -s "test d\'info"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Info -s "test d\'info"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Info -s "test d\'info"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Info -s "test d\'info"'."> errstd") or diag($return_error);


##################
# Log_End -s
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : proc_test, Type : Resultat, Severite : 200
Message : Fin anormale du processus numero 7777 de nom proc_test

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_End -s', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_End -s'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_End -s'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_End -s'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_End -s'."> errstd") or diag($return_error);


##################
# Log_Start -l
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Start -l', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Start -l'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Start -l'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Start -l'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Start -l'."> errstd") or diag($return_error);


##################
# Log_Error -l 100 "test d'erreur"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Error -l 100 "test d\'erreur"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Error -l 100 "test d\'erreur"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Error -l 100 "test d\'erreur"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Error -l 100 "test d\'erreur"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Error -l 100 "test d\'erreur"'."> errstd") or diag($return_error);


##################
# Log_Info -l "test d'info"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Info -l "test d\'info"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Info -l "test d\'info"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Info -l "test d\'info"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Info -l "test d\'info"'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Info -l "test d\'info"'."> errstd") or diag($return_error);


##################
# Log_End -l
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_End -l', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_End -l'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_End -l'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_End -l'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_End -l'."> errstd") or diag($return_error);


##################
# Log_Start -o | perl -F"\|" -ane "print join(',',@F[1],@F[5],@F[7..8]).qq{\n}"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
autredomaine_test,proc_test,0,Debut du traitement de proc_test


EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;
SKIP: {
skip q{Changement de format}, 3;


run3('Log_Start -o | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Start -o | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Start -o | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Start -o | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> output <".q{autredomai...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Start -o | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> errstd") or diag($return_error);

}


##################
# Log_Error -o 100 "test d'erreur" | perl -F"\|" -ane "print join(',',@F[1],@F[5],@F[7..8]).qq{\n}"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
autredomaine_test,proc_test,200,test d'erreur


EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Error -o 100 "test d\'erreur" | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Error -o 100 "test d\'erreur" | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Error -o 100 "test d\'erreur" | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Error -o 100 "test d\'erreur" | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> output <".q{autredomai...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Error -o 100 "test d\'erreur" | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> errstd") or diag($return_error);


##################
# Log_Info -o "test d'info" | perl -F"\|" -ane "print join(',',@F[1],@F[5],@F[7..8]).qq{\n}"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
autredomaine_test,proc_test,200,test d'info


EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Log_Info -o "test d\'info" | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_Info -o "test d\'info" | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_Info -o "test d\'info" | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_Info -o "test d\'info" | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> output <".q{autredomai...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_Info -o "test d\'info" | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> errstd") or diag($return_error);


##################
# Log_End -o | perl -F"\|" -ane "print join(',',@F[1],@F[5],@F[7..8]).qq{\n}"
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
autredomaine_test,proc_test,200,Fin anormale du processus numero 7777 de nom proc_test


EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;
SKIP: {
skip q{Changement de format}, 3;


run3('Log_End -o | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Log_End -o | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Log_End -o | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Log_End -o | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> output <".q{autredomai...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Log_End -o | perl -F"\\|" -ane "print join(\',\',@F[1],@F[5],@F[7..8]).qq{\\n}"'."> errstd") or diag($return_error);

}


##################
# Purge_Log -t Debut logstd
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Purge_Log -t Debut logstd', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Purge_Log -t Debut logstd'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Purge_Log -t Debut logstd'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Purge_Log -t Debut logstd'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Purge_Log -t Debut logstd'."> errstd") or diag($return_error);


##################
# Purge_Log -u user logstd
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Purge_Log -u user logstd', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Purge_Log -u user logstd'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Purge_Log -u user logstd'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Purge_Log -u user logstd'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Purge_Log -u user logstd'."> errstd") or diag($return_error);


##################
# Purge_Log -o20 logstd
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Purge_Log -o20 logstd', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Purge_Log -o20 logstd'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Purge_Log -o20 logstd'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Purge_Log -o20 logstd'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Purge_Log -o20 logstd'."> errstd") or diag($return_error);


##################
# Purge_Log logstd
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Purge_Log logstd', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Purge_Log logstd'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Purge_Log logstd'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Purge_Log logstd'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Purge_Log logstd'."> errstd") or diag($return_error);


##################
# Purge_Log logerr
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Purge_Log logerr', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Purge_Log logerr'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Purge_Log logerr'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Purge_Log logerr'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Purge_Log logerr'."> errstd") or diag($return_error);

