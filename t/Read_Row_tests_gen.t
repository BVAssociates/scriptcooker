#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;
use Test::More tests => 99;

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
# echo "" | Read_Row
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Read_Row, Type : Erreur, Severite : 202
Message : Variables d'environnement SEP ou FORMAT absente !

EXPECTED_ERRSTD
chomp $expected_error;

run3('echo "" | Read_Row', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'echo "" | Read_Row'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'echo "" | Read_Row'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'echo "" | Read_Row'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'echo "" | Read_Row'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages | Read_Row
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function='TEST'
export Error='1'
export Message='test sans quote'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages | Read_Row', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages | Read_Row'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages | Read_Row'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages | Read_Row'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages | Read_Row'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages | Read_Row -n
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function='TEST'
export Error='1'
export Message='test sans quote'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages | Read_Row -n', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages | Read_Row -n'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages | Read_Row -n'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages | Read_Row -n'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages | Read_Row -n'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages | Read_Row -e
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'; export SEP
FORMAT='Function;Error;Message'; export FORMAT
ROW='$Function;$Error;$Message'; export ROW
SIZE='20s;4n;80s'; export SIZE
HEADER='Liste des messages d'\''erreur de variable evaluee'; export HEADER
KEY='Function;Error'; export KEY
Function='TEST'; export Function
Error='1'; export Error
Message='test sans quote'; export Message

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages | Read_Row -e', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages | Read_Row -e'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages | Read_Row -e'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages | Read_Row -e'."> output <".q{SEP=';'; e...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages | Read_Row -e'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages | Read_Row -H
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER=''
export KEY='Function;Error'
export Function='TEST'
export Error='1'
export Message='test sans quote'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages | Read_Row -H', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages | Read_Row -H'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages | Read_Row -H'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages | Read_Row -H'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages | Read_Row -H'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages | Read_Row -q
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function="TEST"
export Error="1"
export Message="test sans quote"

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages | Read_Row -q', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages | Read_Row -q'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages | Read_Row -q'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages | Read_Row -q'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages | Read_Row -q'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function='TEST'
export Error='2'
export Message='test avec '\'' des '\'' quote'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -n
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function='TEST'
export Error='2'
export Message='test avec '\'' des '\'' quote'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -n', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -n'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -n'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -n'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -n'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -e
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'; export SEP
FORMAT='Function;Error;Message'; export FORMAT
ROW='$Function;$Error;$Message'; export ROW
SIZE='20s;4n;80s'; export SIZE
HEADER='Liste des messages d'\''erreur de variable evaluee'; export HEADER
KEY='Function;Error'; export KEY
Function='TEST'; export Function
Error='2'; export Error
Message='test avec '\'' des '\'' quote'; export Message

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -e', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -e'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -e'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -e'."> output <".q{SEP=';'; e...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -e'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -H
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER=''
export KEY='Function;Error'
export Function='TEST'
export Error='2'
export Message='test avec '\'' des '\'' quote'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -H', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -H'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -H'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -H'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -H'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -q
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function="TEST"
export Error="2"
export Message="test avec ' des ' quote"

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -q', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -q'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -q'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -q'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=2 | Read_Row -q'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function='TEST'
export Error='3'
export Message='test avec " des " double quote'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -n
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function='TEST'
export Error='3'
export Message='test avec " des " double quote'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -n', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -n'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -n'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -n'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -n'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -e
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'; export SEP
FORMAT='Function;Error;Message'; export FORMAT
ROW='$Function;$Error;$Message'; export ROW
SIZE='20s;4n;80s'; export SIZE
HEADER='Liste des messages d'\''erreur de variable evaluee'; export HEADER
KEY='Function;Error'; export KEY
Function='TEST'; export Function
Error='3'; export Error
Message='test avec " des " double quote'; export Message

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -e', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -e'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -e'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -e'."> output <".q{SEP=';'; e...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -e'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -H
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER=''
export KEY='Function;Error'
export Function='TEST'
export Error='3'
export Message='test avec " des " double quote'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -H', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -H'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -H'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -H'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -H'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -q
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function="TEST"
export Error="3"
export Message="test avec "\"" des "\"" double quote"

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -q', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -q'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -q'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -q'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=3 | Read_Row -q'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function='TEST'
export Error='4'
export Message='test avec \" des \'\'' quote echappees'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -n
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function='TEST'
export Error='4'
export Message='test avec \" des \'\'' quote echappees'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -n', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -n'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -n'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -n'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -n'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -e
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'; export SEP
FORMAT='Function;Error;Message'; export FORMAT
ROW='$Function;$Error;$Message'; export ROW
SIZE='20s;4n;80s'; export SIZE
HEADER='Liste des messages d'\''erreur de variable evaluee'; export HEADER
KEY='Function;Error'; export KEY
Function='TEST'; export Function
Error='4'; export Error
Message='test avec \" des \'\'' quote echappees'; export Message

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -e', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -e'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -e'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -e'."> output <".q{SEP=';'; e...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -e'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -H
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER=''
export KEY='Function;Error'
export Function='TEST'
export Error='4'
export Message='test avec \" des \'\'' quote echappees'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -H', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -H'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -H'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -H'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -H'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -q
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function="TEST"
export Error="4"
export Message="test avec \"\"" des \' quote echappees"

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -q', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -q'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -q'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -q'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=4 | Read_Row -q'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function='TEST'
export Error='6'
export Message='test avec trop de '

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -n
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function='TEST'
export Error='6'
export Message='test avec trop de '

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -n', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -n'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -n'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -n'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -n'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -e
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
SEP=';'; export SEP
FORMAT='Function;Error;Message'; export FORMAT
ROW='$Function;$Error;$Message'; export ROW
SIZE='20s;4n;80s'; export SIZE
HEADER='Liste des messages d'\''erreur de variable evaluee'; export HEADER
KEY='Function;Error'; export KEY
Function='TEST'; export Function
Error='6'; export Error
Message='test avec trop de '; export Message

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -e', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -e'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -e'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -e'."> output <".q{SEP=';'; e...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -e'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -H
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER=''
export KEY='Function;Error'
export Function='TEST'
export Error='6'
export Message='test avec trop de '

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -H', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -H'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -H'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -H'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -H'."> errstd") or diag($return_error);


##################
# Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -q
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function="TEST"
export Error="6"
export Message="test avec trop de "

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -q', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -q'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -q'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -q'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r1 from error_messages where Function=TEST AND Error=6 | Read_Row -q'."> errstd") or diag($return_error);


##################
# Select -r0 from error_messages | Read_Row
##################

$expected_code = 71;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r0 from error_messages | Read_Row', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r0 from error_messages | Read_Row'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r0 from error_messages | Read_Row'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r0 from error_messages | Read_Row'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r0 from error_messages | Read_Row'."> errstd") or diag($return_error);


##################
# Select -r0 from error_messages | Read_Row -n
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export SEP=';'
export FORMAT='Function;Error;Message'
export ROW='$Function;$Error;$Message'
export SIZE='20s;4n;80s'
export HEADER='Liste des messages d'\''erreur de variable evaluee'
export KEY='Function;Error'
export Function=''
export Error=''
export Message=''

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -r0 from error_messages | Read_Row -n', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -r0 from error_messages | Read_Row -n'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -r0 from error_messages | Read_Row -n'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -r0 from error_messages | Read_Row -n'."> output <".q{export SEP...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -r0 from error_messages | Read_Row -n'."> errstd") or diag($return_error);


##################
# Select -s -r1 from error_messages | Read_Row
##################

$expected_code = 202;
$expected_string = <<'EXPECTED_OUTPUT';

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';
Procedure : Read_Row, Type : Erreur, Severite : 202
Message : Variables d'environnement SEP ou FORMAT absente !

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s -r1 from error_messages | Read_Row', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s -r1 from error_messages | Read_Row'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s -r1 from error_messages | Read_Row'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s -r1 from error_messages | Read_Row'."> output <".q{}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s -r1 from error_messages | Read_Row'."> errstd") or diag($return_error);

source_profile('t/sample/Define_Table_error_messages.sh');

##################
# Select -s -r1 from error_messages | Read_Row
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export Function='TEST'
export Error='1'
export Message='test sans quote'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s -r1 from error_messages | Read_Row', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s -r1 from error_messages | Read_Row'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s -r1 from error_messages | Read_Row'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s -r1 from error_messages | Read_Row'."> output <".q{export Fun...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s -r1 from error_messages | Read_Row'."> errstd") or diag($return_error);


##################
# Select -s from error_messages | while Read_Row; do : ;done
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
export Function='TEST'
export Error='1'
export Message='test sans quote'
export Function='TEST'
export Error='2'
export Message='test avec '\'' des '\'' quote'
export Function='TEST'
export Error='3'
export Message='test avec " des " double quote'
export Function='TEST'
export Error='4'
export Message='test avec \" des \'\'' quote echappees'
export Function='TEST'
export Error='5'
export Message='test avec \\ echappements \n'
export Function='TEST'
export Error='6'
export Message='test avec trop de '
export Function='TEST'
export Error='7'
export Message='test avec des $variables $TESTVAR'
export Function='TEST'
export Error='8'
export Message='test avec des $variables $(echo "commande evaluee")'
export Function='TEST'
export Error='9'
export Message='test avec des $variables `echo "commande evaluee"`'
export Function='TEST_${TESTVAR}'
export Error='0'
export Message='test avec des une clef contenant une variable'
export Function='Check'
export Error='65'
export Message='Non unicite de la clef'
export Function='Insert'
export Error='8'
export Message='La condition de selection de cle n'\''est pas valide'
export Function='Insert'
export Error='97'
export Message='Aucune valeur a inserer n'\''est specifiee'
export Function='Modify'
export Error='8'
export Message='La condition de selection de la cle n est pas valide'
export Function='Modify'
export Error='68'
export Message='Aucune ligne trouvee a modifier'
export Function='Modify'
export Error='97'
export Message='Aucune valeur a modifier n'\''est specifiee'
export Function='Remove'
export Error='68'
export Message='Aucune ligne trouvee a supprimer'
export Function='Replace'
export Error='8'
export Message='La condition de selection de la cle n'\''est pas valide'
export Function='Replace'
export Error='68'
export Message='Aucune ligne trouvee a remplacer'
export Function='Replace'
export Error='97'
export Message='Aucune valeur a remplacer n'\''est specifiee'
export Function='generic'
export Error='1'
export Message='Impossible de trouver l'\''executable %s'
export Function='generic'
export Error='2'
export Message='Impossible de trouver la table %s'
export Function='generic'
export Error='3'
export Message='Impossible de trouver ou d'\''ouvrir le fichier de definition %s'
export Function='generic'
export Error='4'
export Message='Impossible de trouver le fichier %s'
export Function='generic'
export Error='5'
export Message='Le fichier de definition %s n'\''est pas valide'
export Function='generic'
export Error='6'
export Message='La table %s est une table virtuelle'
export Function='generic'
export Error='7'
export Message='La colonne %s n'\''existe pas'
export Function='generic'
export Error='8'
export Message='La condition de selection n'\''est pas valide'
export Function='generic'
export Error='9'
export Message='La chaine de definition %s n'\''est pas valide ou est absente'
export Function='generic'
export Error='10'
export Message='Impossible d'\''ouvrir le fichier %s'
export Function='generic'
export Error='11'
export Message='Impossible d'\''ecrire dans le fichier %s'
export Function='generic'
export Error='12'
export Message='Impossible de supprimer le fichier %s'
export Function='generic'
export Error='13'
export Message='Impossible de changer les droits sur le fichier %s'
export Function='generic'
export Error='14'
export Message='Impossible de renommer/deplacer le fichier %s en %s'
export Function='generic'
export Error='15'
export Message='Impossible de copier le fichier %s'
export Function='generic'
export Error='16'
export Message='Erreur lors d'\''une ecriture dans le fichier %s'
export Function='generic'
export Error='17'
export Message='La commande <%s> a echoue'
export Function='generic'
export Error='18'
export Message='La variable racine BV_HOME ou TOOLS_HOME n'\''est pas exportee !'
export Function='generic'
export Error='19'
export Message='L'\''evaluation de <%s> est incorrecte !'
export Function='generic'
export Error='20'
export Message='L'\''option %s n'\''est pas valide'
export Function='generic'
export Error='21'
export Message='Le nombre d'\''arguments est incorrect'
export Function='generic'
export Error='22'
export Message='L'\''argument %s n'\''est pas valide'
export Function='generic'
export Error='23'
export Message='Utilisation incorrecte de l'\''option -h'
export Function='generic'
export Error='24'
export Message='Ligne de commande incorrecte'
export Function='generic'
export Error='25'
export Message='Erreur lors d'\''une allocation de memoire %s'
export Function='generic'
export Error='26'
export Message='Erreur lors d'\''une re-allocation de memoire %s'
export Function='generic'
export Error='27'
export Message='Erreur lors du chargement de la librairie %s !'
export Function='generic'
export Error='28'
export Message='Impossible de retrouver le symbole %s en librairie !'
export Function='generic'
export Error='29'
export Message='Erreur lors de la fermeture de la librairie %s !'
export Function='generic'
export Error='30'
export Message='Votre licence d'\''utilisation %s a expire !'
export Function='generic'
export Error='31'
export Message='Le Hostid de la machine n'\''est pas valide !'
export Function='generic'
export Error='32'
export Message='La licence n'\''est pas valide !'
export Function='generic'
export Error='33'
export Message='Il n'\''y a pas de licence valide pour ce produit !'
export Function='generic'
export Error='34'
export Message='Le nombre de clients pour ce produit est depasse !'
export Function='generic'
export Error='35'
export Message='Le nom de fichier %s n'\''est pas valide'
export Function='generic'
export Error='36'
export Message='Le fichier %s est verouille'
export Function='generic'
export Error='37'
export Message='Impossible de poser un verrou sur le fichier %s'
export Function='generic'
export Error='38'
export Message='Le delai maximum d'\''attente de deverouillage a ete atteint'
export Function='generic'
export Error='39'
export Message='Le fichier %s n'\''est pas verouille'
export Function='generic'
export Error='40'
export Message='Impossible de retirer le verrou du fichier %s'
export Function='generic'
export Error='41'
export Message='Le nombre maximal de selections simultanees est depasse'
export Function='generic'
export Error='42'
export Message='Le Handle d'\''une requete n'\''est pas valide'
export Function='generic'
export Error='43'
export Message='Le nombre maximal de conditions est depasse'
export Function='generic'
export Error='44'
export Message='Impossible de retrouver la librairie %s !'
export Function='generic'
export Error='45'
export Message='Un Handle n'\''est pas valide'
export Function='generic'
export Error='46'
export Message='Le nombre maximal de fichiers ouverts est depasse'
export Function='generic'
export Error='47'
export Message='Le nombre maximal %s d'\''allocations de memoire est depasse'
export Function='generic'
export Error='48'
export Message='Impossible de retrouver le fichier de menu %s'
export Function='generic'
export Error='49'
export Message='Impossible de retrouver le dictionnaire graphique %s'
export Function='generic'
export Error='50'
export Message='Erreur lors de l'\''execution de la fonction de log'
export Function='generic'
export Error='51'
export Message='Erreur de type '\''%s'\'' lors de la deconnexion Oracle !'
export Function='generic'
export Error='52'
export Message='Impossible d'\''ecrire dans le fichier log %s'
export Function='generic'
export Error='53'
export Message='Impossible de determiner le nom du traitement'
export Function='generic'
export Error='54'
export Message='Le numero d'\''erreur est manquant'
export Function='generic'
export Error='55'
export Message='Le message d'\''information est manquant'
export Function='generic'
export Error='56'
export Message='Le numero d'\''erreur %s n'\''a pas de message associe'
export Function='generic'
export Error='57'
export Message='Le numero d'\''erreur %s n'\''est pas correct'
export Function='generic'
export Error='58'
export Message='Le type de message de log n'\''est pas correct'
export Function='generic'
export Error='59'
export Message='Le nom de table %s n'\''est pas valide'
export Function='generic'
export Error='60'
export Message='La colonne %s doit absolument contenir une valeur'
export Function='generic'
export Error='61'
export Message='Il n'\''y a pas assez de valeurs par rapport au nombre de colonnes'
export Function='generic'
export Error='62'
export Message='Il y a trop de valeurs par rapport au nombre de colonnes'
export Function='generic'
export Error='63'
export Message='La valeur donnee pour la colonne %s n'\''est pas correcte.'
export Function='generic'
export Error='64'
export Message='Le nom de la table n'\''est pas specifie'
export Function='generic'
export Error='65'
export Message='Non unicite de la clef de la ligne a inserer'
export Function='generic'
export Error='66'
export Message='Le groupe d'\''utilisateurs %s n'\''existe pas'
export Function='generic'
export Error='67'
export Message='Impossible de remplacer une ligne sur une table sans clef'
export Function='generic'
export Error='68'
export Message='Aucune ligne trouvee'
export Function='generic'
export Error='69'
export Message='Entete de definition invalide !'
export Function='generic'
export Error='70'
export Message='Variables d'\''environnement SEP ou FORMAT absente !'
export Function='generic'
export Error='71'
export Message='Il n'\''y a pas de lignes en entree stdin !'
export Function='generic'
export Error='72'
export Message='Impossible d'\''ouvrir le fichier %s en ecriture !'
export Function='generic'
export Error='73'
export Message='Impossible d'\''ouvrir le fichier %s en lecture !'
export Function='generic'
export Error='74'
export Message='Impossible d'\''ouvrir le fichier %s en lecture et ecriture !'
export Function='generic'
export Error='75'
export Message='Erreur generique Oracle : %s'
export Function='generic'
export Error='76'
export Message='Erreur de syntaxe dans la requete SQL generee : %s'
export Function='generic'
export Error='77'
export Message='Une valeur a inserer est trop large pour sa colonne !'
export Function='generic'
export Error='78'
export Message='Impossible de se connecter a Oracle avec l'\''utilisateur %s'
export Function='generic'
export Error='79'
export Message='Impossible de locker la table %s. Ressource deja occupee !'
export Function='generic'
export Error='80'
export Message='La requete interne SQL s'\''est terminee en erreur !'
export Function='generic'
export Error='81'
export Message='Le nouveau separateur n'\''est pas specifie !'
export Function='generic'
export Error='82'
export Message='Le nombre maximal de colonnes %s du dictionnaire est depasse !'
export Function='generic'
export Error='83'
export Message='La colonne %s apparait plusieurs fois dans le dictionnaire !'
export Function='generic'
export Error='84'
export Message='La source de donnees %s du dictionnaire est invalide !'
export Function='generic'
export Error='85'
export Message='La table %s ne peut-etre verouillee ou deverouillee !'
export Function='generic'
export Error='86'
export Message='Vous ne pouvez pas remplacer une cle !'
export Function='generic'
export Error='87'
export Message='Impossible de creer un nouveau processus %s !'
export Function='generic'
export Error='88'
export Message='Le nombre maximal de tables %s est depasse'
export Function='generic'
export Error='89'
export Message='Option ou suffixe de recherche invalide !'
export Function='generic'
export Error='90'
export Message='Pas de librairie chargee pour acceder a la base de donnees !'
export Function='generic'
export Error='91'
export Message='Variable d'\''environnement %s manquante ou non exportee !'
export Function='generic'
export Error='92'
export Message='Parametre <+ recent que> inferieur au parametre <+ vieux que>.'
export Function='generic'
export Error='93'
export Message='Le type de la colonne %s est invalide !'
export Function='generic'
export Error='94'
export Message='Impossible de retrouver le formulaire %s'
export Function='generic'
export Error='95'
export Message='Impossible de retrouver le panneau de commandes %s.'
export Function='generic'
export Error='96'
export Message='L'\''operateur de selection est incorrect !'
export Function='generic'
export Error='97'
export Message='Aucune valeur donnee'
export Function='generic'
export Error='98'
export Message='La taille maximale %s d'\''une ligne est depassee !'
export Function='generic'
export Error='99'
export Message='Le champ %s est mal decrit dans la table %s'
export Function='generic'
export Error='100'
export Message='%s'
export Function='generic'
export Error='101'
export Message='Le parametre %s n'\''est pas un chiffre'
export Function='generic'
export Error='102'
export Message='L'\''utilisateur %s n'\''existe pas'
export Function='generic'
export Error='103'
export Message='La cle de reference de la contrainte sur %s est incorrecte.'
export Function='generic'
export Error='104'
export Message='Erreur lors du delete sur %s'
export Function='generic'
export Error='105'
export Message='La variable %s n'\''est pas du bon type'
export Function='generic'
export Error='106'
export Message='Probleme lors du chargement de l'\''environnement %s'
export Function='generic'
export Error='107'
export Message='Environnement %s non accessible'
export Function='generic'
export Error='108'
export Message='Probleme pour acceder a la table %s'
export Function='generic'
export Error='109'
export Message='La table %s n'\''existe pas ou n'\''est pas accessible'
export Function='generic'
export Error='110'
export Message='Impossible de retrouver l'\''objet %s'
export Function='generic'
export Error='111'
export Message='La table %s existe sous plusieurs schemas'
export Function='generic'
export Error='112'
export Message='Probleme pour recuperer les contraintes de %s'
export Function='generic'
export Error='113'
export Message='Erreur lors du disable de contraintes de %s'
export Function='generic'
export Error='114'
export Message='Erreur lors de l'\''enable de contraintes de %s'
export Function='generic'
export Error='115'
export Message='Erreur lors du chargement de la table %s'
export Function='generic'
export Error='116'
export Message='Des enregistrements ont ete rejetes pour la table %s'
export Function='generic'
export Error='117'
export Message='La contrainte %s est invalide !'
export Function='generic'
export Error='118'
export Message='Le nombre maximal %s de cles etrangeres est depasse.'
export Function='generic'
export Error='119'
export Message='Le nombre maximal %s de contraintes est depasse.'
export Function='generic'
export Error='120'
export Message='Impossible de creer le fichier %s'
export Function='generic'
export Error='121'
export Message='La table %s n'\''est pas une table de reference.'
export Function='generic'
export Error='122'
export Message='La table %s existe sous plusieurs cles etrangères.'
export Function='generic'
export Error='123'
export Message='Les droits sur le fichier %s sont incorrects.'
export Function='generic'
export Error='124'
export Message='Probleme pour recuperer les informations '\''%s'\'' de la Machine %s.'
export Function='generic'
export Error='125'
export Message='Le type de la licence est invalide.'
export Function='generic'
export Error='126'
export Message='L'\''utilisateur %s n'\''est pas administrateur du systeme.'
export Function='generic'
export Error='127'
export Message='Les colonnes %s doivent absolument contenir une valeur.'
export Function='generic'
export Error='128'
export Message='La table %s ne possede pas de cle primaire.'
export Function='generic'
export Error='129'
export Message='La valeur d'\''une cle primaire ne peut-etre nulle.'
export Function='generic'
export Error='130'
export Message='Options de commande %s incompatibles'
export Function='generic'
export Error='131'
export Message='Le tri de séléction '\''%s'\'' est invalide.'
export Function='generic'
export Error='132'
export Message='Le format de la date '\''%s'\'' est invalide.'
export Function='generic'
export Error='133'
export Message='Les eléments % de la date doivent être séparés par un caractère.'
export Function='generic'
export Error='134'
export Message='La date '\''%s'\'' ne correspond pas au format %s.'
export Function='generic'
export Error='148'
export Message='Vous n'\''avez pas les droits %s.'
export Function='generic'
export Error='149'
export Message='Probleme d'\''environnement %s'
export Function='generic'
export Error='150'
export Message='Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID'
export Function='generic'
export Error='151'
export Message='Variables inconnues BV_ORAUSER et/ou BV_ORAPASS'
export Function='generic'
export Error='152'
export Message='L'\''intance %s est invalide ou non demarrée.'
export Function='V1_alim_30_motcle'
export Error='0001'
export Message='ECHEC ce l'\''Insert Arg de %s dans t_me_alma'
export Function='V1_alim_30_motcle'
export Error='0002'
export Message='Argument de la methode %s non declare dans me_alma'
export Function='V1_alim_30_motcle'
export Error='0003'
export Message='Rang de l'\''argument de la methode %s incoherent'
export Function='V1_alim_30_motcle'
export Error='0004'
export Message='ECHEC de l'\''insertion du mot cle %s dans t_me_ma'
export Function='V1_alim_40_meth'
export Error='0001'
export Message='Le mot cle d'\''action %s n'\''existe pas'
export Function='V1_alim_40_meth'
export Error='0002'
export Message='L'\''Insertion de la methode physique %s a echoue'
export Function='V1_alim_40_meth'
export Error='0003'
export Message='L'\''Insertion de la variable interne %s a echoue'
export Function='V1_alim_40_meth'
export Error='0004'
export Message='L'\''Insertion du type physique %s a echoue'
export Function='PC_CHGSTAT_SERV'
export Error='0004'
export Message='Aucune instance n'\''est associee a l'\''application %s'
export Function='generic'
export Error='301'
export Message='Le module applicatif %s n'\''est pas ou mal declaré.'
export Function='generic'
export Error='302'
export Message='L'\''instance de service %s ne semble pas exister.'
export Function='generic'
export Error='303'
export Message='Le script fils <%s> a retourne un warning'
export Function='generic'
export Error='304'
export Message='Le script fils <%s> a retourne une erreur bloquante'
export Function='generic'
export Error='305'
export Message='Le script fils <%s> a retourne une erreur fatale'
export Function='generic'
export Error='306'
export Message='Le script fils <%s> a retourne un code d'\''erreur errone %s'
export Function='generic'
export Error='308'
export Message='Erreur a l'\''execution de %s'
export Function='generic'
export Error='309'
export Message='Le service %s '\''%s'\'' n'\''existe pas.'
export Function='generic'
export Error='310'
export Message='Le service %s '\''%s'\'' est deja demarre.'
export Function='generic'
export Error='311'
export Message='Le service %s '\''%s'\'' est deja arrete.'
export Function='generic'
export Error='312'
export Message='Le service %s '\''%s'\'' n'\''a pas demarre correctement.'
export Function='generic'
export Error='313'
export Message='Le service %s '\''%s'\'' ne s'\''est pas arrete correctement.'
export Function='generic'
export Error='314'
export Message='Le service %s '\''%s'\'' n'\''est pas ou mal declaré.'
export Function='generic'
export Error='315'
export Message='Le module applicatif %s ne possède aucune instance de service.'
export Function='generic'
export Error='316'
export Message='La ressource %s '\''%s'\'' n'\''est pas ou mal declaré.'
export Function='generic'
export Error='317'
export Message='Impossible de choisir un type pour le Service %s '\''%s'\''.'
export Function='generic'
export Error='318'
export Message='Impossible de choisir un type de service pour le I-CLES %s.'
export Function='generic'
export Error='319'
export Message='La table %s n'\''est pas collectable.'
export Function='generic'
export Error='320'
export Message='Le type de ressource %s n'\''est pas ou mal déclaré.'
export Function='generic'
export Error='321'
export Message='Le Type de Service %s du I-CLES %s n'\''existe pas.'
export Function='generic'
export Error='401'
export Message='Le repertoire %s n'\''existe pas'
export Function='generic'
export Error='402'
export Message='Impossible de creer le repertoire %s'
export Function='generic'
export Error='403'
export Message='Impossible d'\''ecrire dans le repertoire %s'
export Function='generic'
export Error='404'
export Message='Impossible de lire le contenu du repertoire %s'
export Function='generic'
export Error='405'
export Message='Le fichier %s n'\''existe pas ou est vide'
export Function='generic'
export Error='406'
export Message='Le fichier %s existe deja'
export Function='generic'
export Error='408'
export Message='Le fichier %s n'\''est pas au format %s'
export Function='generic'
export Error='409'
export Message='Erreur lors de l'\''initialisation du fichier %s'
export Function='generic'
export Error='410'
export Message='Probleme lors de la restauration/decompression de %s'
export Function='generic'
export Error='411'
export Message='Probleme lors de la decompression de %s'
export Function='generic'
export Error='412'
export Message='Probleme lors de la compression de %s'
export Function='generic'
export Error='413'
export Message='Probleme lors de la securisation/compression de %s'
export Function='generic'
export Error='414'
export Message='Le Lecteur %s doit etre NO REWIND pour avancer/reculer'
export Function='generic'
export Error='415'
export Message='Le device %s n'\''existe pas ou est indisponible'
export Function='generic'
export Error='416'
export Message='Probleme lors de la creation du lien vers %s'
export Function='generic'
export Error='417'
export Message='Le lecteur %s est inaccessible'
export Function='generic'
export Error='420'
export Message='Impossible d'\''aller sous le répertoire '\''%s'\''.'
export Function='ME_CREATE_SYNORA'
export Error='0001'
export Message='Probleme a la creation du Synonyme %s'
export Function='ME_DROP_SYNORA'
export Error='0001'
export Message='Probleme a la suppression du Synonyme %s'
export Function='ME_LOAD_TABORA'
export Error='0001'
export Message='Echec du Load sqlldr de %s'
export Function='ME_RESTORE_TABORA'
export Error='0001'
export Message='Erreur lors de la restauration de la table %s'
export Function='ME_SECURE_TABORA'
export Error='0001'
export Message='Impossible de recuperer la taille du tablespace %s'
export Function='ME_SECURE_TABORA'
export Error='0002'
export Message='Impossible de recuperer la taille de la table %s'
export Function='ME_SECURE_TABORA'
export Error='0003'
export Message='Erreur lors de la securisation de la table %s'
export Function='ME_SECURE_TABORA'
export Error='0004'
export Message='Impossible de recuperer la taille de la sauvegarde'
export Function='ME_SECURE_TABORA'
export Error='0365'
export Message='Probleme lors de la mise a jour de la table %s'
export Function='ME_TRUNC_TABORA'
export Error='176'
export Message='Probleme de truncate sur %s (Contrainte type P referencee) '
export Function='PC_BACK_TBSORA'
export Error='137'
export Message='Probleme pour mettre le TBSPACE %s en BEGIN BACKUP'
export Function='PC_BACK_TBSORA'
export Error='138'
export Message='Probleme pour mettre le TBSPACE %s en END BACKUP'
export Function='PC_BACK_TBSORA'
export Error='139'
export Message='Probleme pour manipuler le TBSPACE %s'
export Function='PC_LISTBACK_ARCHORA'
export Error='0001'
export Message='Il manque la sequence d'\''archives %s pour la base %s'
export Function='PC_LISTBACK_ARCHORA'
export Error='0002'
export Message='Il n'\''existe pas d'\''archives commençant a la sequence %s.'
export Function='PC_LISTBACK_CTRLORA'
export Error='128'
export Message='Impossible d'\''interroger les logfiles de %s'
export Function='PC_LISTBACK_CTRLORA'
export Error='132'
export Message='Impossible d'\''interroger les controlfiles de %s'
export Function='PC_LISTID_INSORA'
export Error='182'
export Message='Impossible de trouver la Base du user %s'
export Function='PC_SWITCH_LOGORA'
export Error='127'
export Message='Probleme lors du switch des logfiles de %s'
export Function='PC_SWITCH_LOGORA'
export Error='128'
export Message='Impossible d'\''interroger les logfiles pour %s'
export Function='generic'
export Error='501'
export Message='L'\''instance Oracle %s n'\''est pas demarree'
export Function='generic'
export Error='502'
export Message='L'\''instance Oracle %s n'\''est pas arretee'
export Function='generic'
export Error='503'
export Message='%s n'\''est pas un mode d'\''arret Oracle valide'
export Function='generic'
export Error='504'
export Message='%s n'\''est pas un mode de demarrage Oracle valide'
export Function='generic'
export Error='505'
export Message='La base Oracle %s existe deja dans /etc/oratab'
export Function='generic'
export Error='506'
export Message='Impossible de retrouver l'\''environnement de l'\''instance Oracle %s'
export Function='generic'
export Error='507'
export Message='Impossible de retrouver l'\''init file de la base %s'
export Function='generic'
export Error='508'
export Message='Le fichier de config de %s n'\''est pas renseigne dans l'\''initfile'
export Function='generic'
export Error='509'
export Message='Les controlfiles de %s ne sont pas renseignes dans les initfiles'
export Function='generic'
export Error='510'
export Message='Les parametres d'\''archive %s n'\''existent pas dans les initfiles'
export Function='generic'
export Error='511'
export Message='Parametre log_archive_dest de %s non defini dans les initfiles'
export Function='generic'
export Error='512'
export Message='Parametre log_archive_format de %s non defini dans les initfiles'
export Function='generic'
export Error='513'
export Message='L'\''archivage de %s n'\''est pas demarre correctement'
export Function='generic'
export Error='514'
export Message='L'\''archivage de %s n'\''est pas arrete correctement'
export Function='generic'
export Error='515'
export Message='Script SQL %s non accessible'
export Function='generic'
export Error='517'
export Message='Le script SQL %s ne s'\''est pas execute correctement'
export Function='generic'
export Error='518'
export Message='Probleme lors de la suppression de la table %s '
export Function='generic'
export Error='519'
export Message='Probleme a l'\''execution du delete ou truncate de %s sur $ORACLE_SID'
export Function='generic'
export Error='520'
export Message='Aucun Archive Oracle pour la Base %s'
export Function='PC_INITF_SQLNET'
export Error='004'
export Message='La configuration SqlNet %s de %s est introuvable'
export Function='FT_LISTLST_SQLNET'
export Error='346'
export Message='Aucun Listener convenablement declare dans %s'
export Function='FT_LIST_TNSNAME'
export Error='346'
export Message='Aucun Service TNS convenablement declare dans %s'
export Function='PC_ENV_SQLNET'
export Error='506'
export Message='Impossible de trouver l'\''environnement de l'\''instance Sqlnet %s'
export Function='PC_LISTID_SQLNET'
export Error='182'
export Message='Impossible de trouver le Noyau SqlNet du user %s'
export Function='PC_STAT_TNSNAME'
export Error='001'
export Message='Le service TNS %s n'\''est pas decrit'
export Function='PC_STAT_TNSNAME'
export Error='002'
export Message='Il n'\''y a pas de listener demarre servant le service TNS %s'
export Function='PC_STAT_TNSNAME'
export Error='003'
export Message='Erreur de configuration de l'\''adresse du service TNS %s'

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Select -s from error_messages | while Read_Row; do : ;done', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Select -s from error_messages | while Read_Row; do : ;done'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Select -s from error_messages | while Read_Row; do : ;done'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Select -s from error_messages | while Read_Row; do : ;done'."> output <".q{export Fun...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Select -s from error_messages | while Read_Row; do : ;done'."> errstd") or diag($return_error);


##################
# PC_PRINT_SQL
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
insert into error_messages (Function,Error,Message) values ('TEST','1','test sans quote');
insert into error_messages (Function,Error,Message) values ('TEST','2','test avec '' des '' quote');
insert into error_messages (Function,Error,Message) values ('TEST','3','test avec " des " double quote');
insert into error_messages (Function,Error,Message) values ('TEST','4','test avec \" des \'' quote echappees');
insert into error_messages (Function,Error,Message) values ('TEST','5','test avec \ echappements ');
insert into error_messages (Function,Error,Message) values ('TEST','6','test avec trop de');
insert into error_messages (Function,Error,Message) values ('TEST','7','test avec des $variables $TESTVAR');
insert into error_messages (Function,Error,Message) values ('TEST','8','test avec des $variables $(echo "commande evaluee")');
insert into error_messages (Function,Error,Message) values ('TEST','9','test avec des $variables `echo "commande evaluee"`');
insert into error_messages (Function,Error,Message) values ('TEST_${TESTVAR}','0','test avec des une clef contenant une variable');
insert into error_messages (Function,Error,Message) values ('Check','65','Non unicite de la clef');
insert into error_messages (Function,Error,Message) values ('Insert','8','La condition de selection de cle n''est pas valide');
insert into error_messages (Function,Error,Message) values ('Insert','97','Aucune valeur a inserer n''est specifiee');
insert into error_messages (Function,Error,Message) values ('Modify','8','La condition de selection de la cle n est pas valide');
insert into error_messages (Function,Error,Message) values ('Modify','68','Aucune ligne trouvee a modifier');
insert into error_messages (Function,Error,Message) values ('Modify','97','Aucune valeur a modifier n''est specifiee');
insert into error_messages (Function,Error,Message) values ('Remove','68','Aucune ligne trouvee a supprimer');
insert into error_messages (Function,Error,Message) values ('Replace','8','La condition de selection de la cle n''est pas valide');
insert into error_messages (Function,Error,Message) values ('Replace','68','Aucune ligne trouvee a remplacer');
insert into error_messages (Function,Error,Message) values ('Replace','97','Aucune valeur a remplacer n''est specifiee');
insert into error_messages (Function,Error,Message) values ('generic','1','Impossible de trouver l''executable %s');
insert into error_messages (Function,Error,Message) values ('generic','2','Impossible de trouver la table %s');
insert into error_messages (Function,Error,Message) values ('generic','3','Impossible de trouver ou d''ouvrir le fichier de definition %s');
insert into error_messages (Function,Error,Message) values ('generic','4','Impossible de trouver le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','5','Le fichier de definition %s n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','6','La table %s est une table virtuelle');
insert into error_messages (Function,Error,Message) values ('generic','7','La colonne %s n''existe pas');
insert into error_messages (Function,Error,Message) values ('generic','8','La condition de selection n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','9','La chaine de definition %s n''est pas valide ou est absente');
insert into error_messages (Function,Error,Message) values ('generic','10','Impossible d''ouvrir le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','11','Impossible d''ecrire dans le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','12','Impossible de supprimer le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','13','Impossible de changer les droits sur le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','14','Impossible de renommer/deplacer le fichier %s en %s');
insert into error_messages (Function,Error,Message) values ('generic','15','Impossible de copier le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','16','Erreur lors d''une ecriture dans le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','17','La commande <%s> a echoue');
insert into error_messages (Function,Error,Message) values ('generic','18','La variable racine BV_HOME ou TOOLS_HOME n''est pas exportee !');
insert into error_messages (Function,Error,Message) values ('generic','19','L''evaluation de <%s> est incorrecte !');
insert into error_messages (Function,Error,Message) values ('generic','20','L''option %s n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','21','Le nombre d''arguments est incorrect');
insert into error_messages (Function,Error,Message) values ('generic','22','L''argument %s n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','23','Utilisation incorrecte de l''option -h');
insert into error_messages (Function,Error,Message) values ('generic','24','Ligne de commande incorrecte');
insert into error_messages (Function,Error,Message) values ('generic','25','Erreur lors d''une allocation de memoire %s');
insert into error_messages (Function,Error,Message) values ('generic','26','Erreur lors d''une re-allocation de memoire %s');
insert into error_messages (Function,Error,Message) values ('generic','27','Erreur lors du chargement de la librairie %s !');
insert into error_messages (Function,Error,Message) values ('generic','28','Impossible de retrouver le symbole %s en librairie !');
insert into error_messages (Function,Error,Message) values ('generic','29','Erreur lors de la fermeture de la librairie %s !');
insert into error_messages (Function,Error,Message) values ('generic','30','Votre licence d''utilisation %s a expire !');
insert into error_messages (Function,Error,Message) values ('generic','31','Le Hostid de la machine n''est pas valide !');
insert into error_messages (Function,Error,Message) values ('generic','32','La licence n''est pas valide !');
insert into error_messages (Function,Error,Message) values ('generic','33','Il n''y a pas de licence valide pour ce produit !');
insert into error_messages (Function,Error,Message) values ('generic','34','Le nombre de clients pour ce produit est depasse !');
insert into error_messages (Function,Error,Message) values ('generic','35','Le nom de fichier %s n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','36','Le fichier %s est verouille');
insert into error_messages (Function,Error,Message) values ('generic','37','Impossible de poser un verrou sur le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','38','Le delai maximum d''attente de deverouillage a ete atteint');
insert into error_messages (Function,Error,Message) values ('generic','39','Le fichier %s n''est pas verouille');
insert into error_messages (Function,Error,Message) values ('generic','40','Impossible de retirer le verrou du fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','41','Le nombre maximal de selections simultanees est depasse');
insert into error_messages (Function,Error,Message) values ('generic','42','Le Handle d''une requete n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','43','Le nombre maximal de conditions est depasse');
insert into error_messages (Function,Error,Message) values ('generic','44','Impossible de retrouver la librairie %s !');
insert into error_messages (Function,Error,Message) values ('generic','45','Un Handle n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','46','Le nombre maximal de fichiers ouverts est depasse');
insert into error_messages (Function,Error,Message) values ('generic','47','Le nombre maximal %s d''allocations de memoire est depasse');
insert into error_messages (Function,Error,Message) values ('generic','48','Impossible de retrouver le fichier de menu %s');
insert into error_messages (Function,Error,Message) values ('generic','49','Impossible de retrouver le dictionnaire graphique %s');
insert into error_messages (Function,Error,Message) values ('generic','50','Erreur lors de l''execution de la fonction de log');
insert into error_messages (Function,Error,Message) values ('generic','51','Erreur de type ''%s'' lors de la deconnexion Oracle !');
insert into error_messages (Function,Error,Message) values ('generic','52','Impossible d''ecrire dans le fichier log %s');
insert into error_messages (Function,Error,Message) values ('generic','53','Impossible de determiner le nom du traitement');
insert into error_messages (Function,Error,Message) values ('generic','54','Le numero d''erreur est manquant');
insert into error_messages (Function,Error,Message) values ('generic','55','Le message d''information est manquant');
insert into error_messages (Function,Error,Message) values ('generic','56','Le numero d''erreur %s n''a pas de message associe');
insert into error_messages (Function,Error,Message) values ('generic','57','Le numero d''erreur %s n''est pas correct');
insert into error_messages (Function,Error,Message) values ('generic','58','Le type de message de log n''est pas correct');
insert into error_messages (Function,Error,Message) values ('generic','59','Le nom de table %s n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','60','La colonne %s doit absolument contenir une valeur');
insert into error_messages (Function,Error,Message) values ('generic','61','Il n''y a pas assez de valeurs par rapport au nombre de colonnes');
insert into error_messages (Function,Error,Message) values ('generic','62','Il y a trop de valeurs par rapport au nombre de colonnes');
insert into error_messages (Function,Error,Message) values ('generic','63','La valeur donnee pour la colonne %s n''est pas correcte.');
insert into error_messages (Function,Error,Message) values ('generic','64','Le nom de la table n''est pas specifie');
insert into error_messages (Function,Error,Message) values ('generic','65','Non unicite de la clef de la ligne a inserer');
insert into error_messages (Function,Error,Message) values ('generic','66','Le groupe d''utilisateurs %s n''existe pas');
insert into error_messages (Function,Error,Message) values ('generic','67','Impossible de remplacer une ligne sur une table sans clef');
insert into error_messages (Function,Error,Message) values ('generic','68','Aucune ligne trouvee');
insert into error_messages (Function,Error,Message) values ('generic','69','Entete de definition invalide !');
insert into error_messages (Function,Error,Message) values ('generic','70','Variables d''environnement SEP ou FORMAT absente !');
insert into error_messages (Function,Error,Message) values ('generic','71','Il n''y a pas de lignes en entree stdin !');
insert into error_messages (Function,Error,Message) values ('generic','72','Impossible d''ouvrir le fichier %s en ecriture !');
insert into error_messages (Function,Error,Message) values ('generic','73','Impossible d''ouvrir le fichier %s en lecture !');
insert into error_messages (Function,Error,Message) values ('generic','74','Impossible d''ouvrir le fichier %s en lecture et ecriture !');
insert into error_messages (Function,Error,Message) values ('generic','75','Erreur generique Oracle : %s');
insert into error_messages (Function,Error,Message) values ('generic','76','Erreur de syntaxe dans la requete SQL generee : %s');
insert into error_messages (Function,Error,Message) values ('generic','77','Une valeur a inserer est trop large pour sa colonne !');
insert into error_messages (Function,Error,Message) values ('generic','78','Impossible de se connecter a Oracle avec l''utilisateur %s');
insert into error_messages (Function,Error,Message) values ('generic','79','Impossible de locker la table %s. Ressource deja occupee !');
insert into error_messages (Function,Error,Message) values ('generic','80','La requete interne SQL s''est terminee en erreur !');
insert into error_messages (Function,Error,Message) values ('generic','81','Le nouveau separateur n''est pas specifie !');
insert into error_messages (Function,Error,Message) values ('generic','82','Le nombre maximal de colonnes %s du dictionnaire est depasse !');
insert into error_messages (Function,Error,Message) values ('generic','83','La colonne %s apparait plusieurs fois dans le dictionnaire !');
insert into error_messages (Function,Error,Message) values ('generic','84','La source de donnees %s du dictionnaire est invalide !');
insert into error_messages (Function,Error,Message) values ('generic','85','La table %s ne peut-etre verouillee ou deverouillee !');
insert into error_messages (Function,Error,Message) values ('generic','86','Vous ne pouvez pas remplacer une cle !');
insert into error_messages (Function,Error,Message) values ('generic','87','Impossible de creer un nouveau processus %s !');
insert into error_messages (Function,Error,Message) values ('generic','88','Le nombre maximal de tables %s est depasse');
insert into error_messages (Function,Error,Message) values ('generic','89','Option ou suffixe de recherche invalide !');
insert into error_messages (Function,Error,Message) values ('generic','90','Pas de librairie chargee pour acceder a la base de donnees !');
insert into error_messages (Function,Error,Message) values ('generic','91','Variable d''environnement %s manquante ou non exportee !');
insert into error_messages (Function,Error,Message) values ('generic','92','Parametre <+ recent que> inferieur au parametre <+ vieux que>.');
insert into error_messages (Function,Error,Message) values ('generic','93','Le type de la colonne %s est invalide !');
insert into error_messages (Function,Error,Message) values ('generic','94','Impossible de retrouver le formulaire %s');
insert into error_messages (Function,Error,Message) values ('generic','95','Impossible de retrouver le panneau de commandes %s.');
insert into error_messages (Function,Error,Message) values ('generic','96','L''operateur de selection est incorrect !');
insert into error_messages (Function,Error,Message) values ('generic','97','Aucune valeur donnee');
insert into error_messages (Function,Error,Message) values ('generic','98','La taille maximale %s d''une ligne est depassee !');
insert into error_messages (Function,Error,Message) values ('generic','99','Le champ %s est mal decrit dans la table %s');
insert into error_messages (Function,Error,Message) values ('generic','100','%s');
insert into error_messages (Function,Error,Message) values ('generic','101','Le parametre %s n''est pas un chiffre');
insert into error_messages (Function,Error,Message) values ('generic','102','L''utilisateur %s n''existe pas');
insert into error_messages (Function,Error,Message) values ('generic','103','La cle de reference de la contrainte sur %s est incorrecte.');
insert into error_messages (Function,Error,Message) values ('generic','104','Erreur lors du delete sur %s');
insert into error_messages (Function,Error,Message) values ('generic','105','La variable %s n''est pas du bon type');
insert into error_messages (Function,Error,Message) values ('generic','106','Probleme lors du chargement de l''environnement %s');
insert into error_messages (Function,Error,Message) values ('generic','107','Environnement %s non accessible');
insert into error_messages (Function,Error,Message) values ('generic','108','Probleme pour acceder a la table %s');
insert into error_messages (Function,Error,Message) values ('generic','109','La table %s n''existe pas ou n''est pas accessible');
insert into error_messages (Function,Error,Message) values ('generic','110','Impossible de retrouver l''objet %s');
insert into error_messages (Function,Error,Message) values ('generic','111','La table %s existe sous plusieurs schemas');
insert into error_messages (Function,Error,Message) values ('generic','112','Probleme pour recuperer les contraintes de %s');
insert into error_messages (Function,Error,Message) values ('generic','113','Erreur lors du disable de contraintes de %s');
insert into error_messages (Function,Error,Message) values ('generic','114','Erreur lors de l''enable de contraintes de %s');
insert into error_messages (Function,Error,Message) values ('generic','115','Erreur lors du chargement de la table %s');
insert into error_messages (Function,Error,Message) values ('generic','116','Des enregistrements ont ete rejetes pour la table %s');
insert into error_messages (Function,Error,Message) values ('generic','117','La contrainte %s est invalide !');
insert into error_messages (Function,Error,Message) values ('generic','118','Le nombre maximal %s de cles etrangeres est depasse.');
insert into error_messages (Function,Error,Message) values ('generic','119','Le nombre maximal %s de contraintes est depasse.');
insert into error_messages (Function,Error,Message) values ('generic','120','Impossible de creer le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','121','La table %s n''est pas une table de reference.');
insert into error_messages (Function,Error,Message) values ('generic','122','La table %s existe sous plusieurs cles etrangères.');
insert into error_messages (Function,Error,Message) values ('generic','123','Les droits sur le fichier %s sont incorrects.');
insert into error_messages (Function,Error,Message) values ('generic','124','Probleme pour recuperer les informations ''%s'' de la Machine %s.');
insert into error_messages (Function,Error,Message) values ('generic','125','Le type de la licence est invalide.');
insert into error_messages (Function,Error,Message) values ('generic','126','L''utilisateur %s n''est pas administrateur du systeme.');
insert into error_messages (Function,Error,Message) values ('generic','127','Les colonnes %s doivent absolument contenir une valeur.');
insert into error_messages (Function,Error,Message) values ('generic','128','La table %s ne possede pas de cle primaire.');
insert into error_messages (Function,Error,Message) values ('generic','129','La valeur d''une cle primaire ne peut-etre nulle.');
insert into error_messages (Function,Error,Message) values ('generic','130','Options de commande %s incompatibles');
insert into error_messages (Function,Error,Message) values ('generic','131','Le tri de séléction ''%s'' est invalide.');
insert into error_messages (Function,Error,Message) values ('generic','132','Le format de la date ''%s'' est invalide.');
insert into error_messages (Function,Error,Message) values ('generic','133','Les eléments % de la date doivent être séparés par un caractère.');
insert into error_messages (Function,Error,Message) values ('generic','134','La date ''%s'' ne correspond pas au format %s.');
insert into error_messages (Function,Error,Message) values ('generic','148','Vous n''avez pas les droits %s.');
insert into error_messages (Function,Error,Message) values ('generic','149','Probleme d''environnement %s');
insert into error_messages (Function,Error,Message) values ('generic','150','Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID');
insert into error_messages (Function,Error,Message) values ('generic','151','Variables inconnues BV_ORAUSER et/ou BV_ORAPASS');
insert into error_messages (Function,Error,Message) values ('generic','152','L''intance %s est invalide ou non demarrée.');
insert into error_messages (Function,Error,Message) values ('V1_alim_30_motcle','0001','ECHEC ce l''Insert Arg de %s dans t_me_alma');
insert into error_messages (Function,Error,Message) values ('V1_alim_30_motcle','0002','Argument de la methode %s non declare dans me_alma');
insert into error_messages (Function,Error,Message) values ('V1_alim_30_motcle','0003','Rang de l''argument de la methode %s incoherent');
insert into error_messages (Function,Error,Message) values ('V1_alim_30_motcle','0004','ECHEC de l''insertion du mot cle %s dans t_me_ma');
insert into error_messages (Function,Error,Message) values ('V1_alim_40_meth','0001','Le mot cle d''action %s n''existe pas');
insert into error_messages (Function,Error,Message) values ('V1_alim_40_meth','0002','L''Insertion de la methode physique %s a echoue');
insert into error_messages (Function,Error,Message) values ('V1_alim_40_meth','0003','L''Insertion de la variable interne %s a echoue');
insert into error_messages (Function,Error,Message) values ('V1_alim_40_meth','0004','L''Insertion du type physique %s a echoue');
insert into error_messages (Function,Error,Message) values ('PC_CHGSTAT_SERV','0004','Aucune instance n''est associee a l''application %s');
insert into error_messages (Function,Error,Message) values ('generic','301','Le module applicatif %s n''est pas ou mal declaré.');
insert into error_messages (Function,Error,Message) values ('generic','302','L''instance de service %s ne semble pas exister.');
insert into error_messages (Function,Error,Message) values ('generic','303','Le script fils <%s> a retourne un warning');
insert into error_messages (Function,Error,Message) values ('generic','304','Le script fils <%s> a retourne une erreur bloquante');
insert into error_messages (Function,Error,Message) values ('generic','305','Le script fils <%s> a retourne une erreur fatale');
insert into error_messages (Function,Error,Message) values ('generic','306','Le script fils <%s> a retourne un code d''erreur errone %s');
insert into error_messages (Function,Error,Message) values ('generic','308','Erreur a l''execution de %s');
insert into error_messages (Function,Error,Message) values ('generic','309','Le service %s ''%s'' n''existe pas.');
insert into error_messages (Function,Error,Message) values ('generic','310','Le service %s ''%s'' est deja demarre.');
insert into error_messages (Function,Error,Message) values ('generic','311','Le service %s ''%s'' est deja arrete.');
insert into error_messages (Function,Error,Message) values ('generic','312','Le service %s ''%s'' n''a pas demarre correctement.');
insert into error_messages (Function,Error,Message) values ('generic','313','Le service %s ''%s'' ne s''est pas arrete correctement.');
insert into error_messages (Function,Error,Message) values ('generic','314','Le service %s ''%s'' n''est pas ou mal declaré.');
insert into error_messages (Function,Error,Message) values ('generic','315','Le module applicatif %s ne possède aucune instance de service.');
insert into error_messages (Function,Error,Message) values ('generic','316','La ressource %s ''%s'' n''est pas ou mal declaré.');
insert into error_messages (Function,Error,Message) values ('generic','317','Impossible de choisir un type pour le Service %s ''%s''.');
insert into error_messages (Function,Error,Message) values ('generic','318','Impossible de choisir un type de service pour le I-CLES %s.');
insert into error_messages (Function,Error,Message) values ('generic','319','La table %s n''est pas collectable.');
insert into error_messages (Function,Error,Message) values ('generic','320','Le type de ressource %s n''est pas ou mal déclaré.');
insert into error_messages (Function,Error,Message) values ('generic','321','Le Type de Service %s du I-CLES %s n''existe pas.');
insert into error_messages (Function,Error,Message) values ('generic','401','Le repertoire %s n''existe pas');
insert into error_messages (Function,Error,Message) values ('generic','402','Impossible de creer le repertoire %s');
insert into error_messages (Function,Error,Message) values ('generic','403','Impossible d''ecrire dans le repertoire %s');
insert into error_messages (Function,Error,Message) values ('generic','404','Impossible de lire le contenu du repertoire %s');
insert into error_messages (Function,Error,Message) values ('generic','405','Le fichier %s n''existe pas ou est vide');
insert into error_messages (Function,Error,Message) values ('generic','406','Le fichier %s existe deja');
insert into error_messages (Function,Error,Message) values ('generic','408','Le fichier %s n''est pas au format %s');
insert into error_messages (Function,Error,Message) values ('generic','409','Erreur lors de l''initialisation du fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','410','Probleme lors de la restauration/decompression de %s');
insert into error_messages (Function,Error,Message) values ('generic','411','Probleme lors de la decompression de %s');
insert into error_messages (Function,Error,Message) values ('generic','412','Probleme lors de la compression de %s');
insert into error_messages (Function,Error,Message) values ('generic','413','Probleme lors de la securisation/compression de %s');
insert into error_messages (Function,Error,Message) values ('generic','414','Le Lecteur %s doit etre NO REWIND pour avancer/reculer');
insert into error_messages (Function,Error,Message) values ('generic','415','Le device %s n''existe pas ou est indisponible');
insert into error_messages (Function,Error,Message) values ('generic','416','Probleme lors de la creation du lien vers %s');
insert into error_messages (Function,Error,Message) values ('generic','417','Le lecteur %s est inaccessible');
insert into error_messages (Function,Error,Message) values ('generic','420','Impossible d''aller sous le répertoire ''%s''.');
insert into error_messages (Function,Error,Message) values ('ME_CREATE_SYNORA','0001','Probleme a la creation du Synonyme %s');
insert into error_messages (Function,Error,Message) values ('ME_DROP_SYNORA','0001','Probleme a la suppression du Synonyme %s');
insert into error_messages (Function,Error,Message) values ('ME_LOAD_TABORA','0001','Echec du Load sqlldr de %s');
insert into error_messages (Function,Error,Message) values ('ME_RESTORE_TABORA','0001','Erreur lors de la restauration de la table %s');
insert into error_messages (Function,Error,Message) values ('ME_SECURE_TABORA','0001','Impossible de recuperer la taille du tablespace %s');
insert into error_messages (Function,Error,Message) values ('ME_SECURE_TABORA','0002','Impossible de recuperer la taille de la table %s');
insert into error_messages (Function,Error,Message) values ('ME_SECURE_TABORA','0003','Erreur lors de la securisation de la table %s');
insert into error_messages (Function,Error,Message) values ('ME_SECURE_TABORA','0004','Impossible de recuperer la taille de la sauvegarde');
insert into error_messages (Function,Error,Message) values ('ME_SECURE_TABORA','0365','Probleme lors de la mise a jour de la table %s');
insert into error_messages (Function,Error,Message) values ('ME_TRUNC_TABORA','176','Probleme de truncate sur %s (Contrainte type P referencee)');
insert into error_messages (Function,Error,Message) values ('PC_BACK_TBSORA','137','Probleme pour mettre le TBSPACE %s en BEGIN BACKUP');
insert into error_messages (Function,Error,Message) values ('PC_BACK_TBSORA','138','Probleme pour mettre le TBSPACE %s en END BACKUP');
insert into error_messages (Function,Error,Message) values ('PC_BACK_TBSORA','139','Probleme pour manipuler le TBSPACE %s');
insert into error_messages (Function,Error,Message) values ('PC_LISTBACK_ARCHORA','0001','Il manque la sequence d''archives %s pour la base %s');
insert into error_messages (Function,Error,Message) values ('PC_LISTBACK_ARCHORA','0002','Il n''existe pas d''archives commençant a la sequence %s.');
insert into error_messages (Function,Error,Message) values ('PC_LISTBACK_CTRLORA','128','Impossible d''interroger les logfiles de %s');
insert into error_messages (Function,Error,Message) values ('PC_LISTBACK_CTRLORA','132','Impossible d''interroger les controlfiles de %s');
insert into error_messages (Function,Error,Message) values ('PC_LISTID_INSORA','182','Impossible de trouver la Base du user %s');
insert into error_messages (Function,Error,Message) values ('PC_SWITCH_LOGORA','127','Probleme lors du switch des logfiles de %s');
insert into error_messages (Function,Error,Message) values ('PC_SWITCH_LOGORA','128','Impossible d''interroger les logfiles pour %s');
insert into error_messages (Function,Error,Message) values ('generic','501','L''instance Oracle %s n''est pas demarree');
insert into error_messages (Function,Error,Message) values ('generic','502','L''instance Oracle %s n''est pas arretee');
insert into error_messages (Function,Error,Message) values ('generic','503','%s n''est pas un mode d''arret Oracle valide');
insert into error_messages (Function,Error,Message) values ('generic','504','%s n''est pas un mode de demarrage Oracle valide');
insert into error_messages (Function,Error,Message) values ('generic','505','La base Oracle %s existe deja dans /etc/oratab');
insert into error_messages (Function,Error,Message) values ('generic','506','Impossible de retrouver l''environnement de l''instance Oracle %s');
insert into error_messages (Function,Error,Message) values ('generic','507','Impossible de retrouver l''init file de la base %s');
insert into error_messages (Function,Error,Message) values ('generic','508','Le fichier de config de %s n''est pas renseigne dans l''initfile');
insert into error_messages (Function,Error,Message) values ('generic','509','Les controlfiles de %s ne sont pas renseignes dans les initfiles');
insert into error_messages (Function,Error,Message) values ('generic','510','Les parametres d''archive %s n''existent pas dans les initfiles');
insert into error_messages (Function,Error,Message) values ('generic','511','Parametre log_archive_dest de %s non defini dans les initfiles');
insert into error_messages (Function,Error,Message) values ('generic','512','Parametre log_archive_format de %s non defini dans les initfiles');
insert into error_messages (Function,Error,Message) values ('generic','513','L''archivage de %s n''est pas demarre correctement');
insert into error_messages (Function,Error,Message) values ('generic','514','L''archivage de %s n''est pas arrete correctement');
insert into error_messages (Function,Error,Message) values ('generic','515','Script SQL %s non accessible');
insert into error_messages (Function,Error,Message) values ('generic','517','Le script SQL %s ne s''est pas execute correctement');
insert into error_messages (Function,Error,Message) values ('generic','518','Probleme lors de la suppression de la table %s');
insert into error_messages (Function,Error,Message) values ('generic','519','Probleme a l''execution du delete ou truncate de %s sur $ORACLE_SID');
insert into error_messages (Function,Error,Message) values ('generic','520','Aucun Archive Oracle pour la Base %s');
insert into error_messages (Function,Error,Message) values ('PC_INITF_SQLNET','004','La configuration SqlNet %s de %s est introuvable');
insert into error_messages (Function,Error,Message) values ('FT_LISTLST_SQLNET','346','Aucun Listener convenablement declare dans %s');
insert into error_messages (Function,Error,Message) values ('FT_LIST_TNSNAME','346','Aucun Service TNS convenablement declare dans %s');
insert into error_messages (Function,Error,Message) values ('PC_ENV_SQLNET','506','Impossible de trouver l''environnement de l''instance Sqlnet %s');
insert into error_messages (Function,Error,Message) values ('PC_LISTID_SQLNET','182','Impossible de trouver le Noyau SqlNet du user %s');
insert into error_messages (Function,Error,Message) values ('PC_STAT_TNSNAME','001','Le service TNS %s n''est pas decrit');
insert into error_messages (Function,Error,Message) values ('PC_STAT_TNSNAME','002','Il n''y a pas de listener demarre servant le service TNS %s');
insert into error_messages (Function,Error,Message) values ('PC_STAT_TNSNAME','003','Erreur de configuration de l''adresse du service TNS %s');

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('PC_PRINT_SQL', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'PC_PRINT_SQL'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'PC_PRINT_SQL'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'PC_PRINT_SQL'."> output <".q{insert int...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'PC_PRINT_SQL'."> errstd") or diag($return_error);


##################
# PC_PRINT_SQL.pl
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
insert into error_messages (Function,Error,Message) values ('TEST','1','test sans quote');
insert into error_messages (Function,Error,Message) values ('TEST','2','test avec '' des '' quote');
insert into error_messages (Function,Error,Message) values ('TEST','3','test avec " des " double quote');
insert into error_messages (Function,Error,Message) values ('TEST','4','test avec \" des \'' quote echappees');
insert into error_messages (Function,Error,Message) values ('TEST','5','test avec \\ echappements \n');
insert into error_messages (Function,Error,Message) values ('TEST','6','test avec trop de ; separ;ateurs;');
insert into error_messages (Function,Error,Message) values ('TEST','7','test avec des $variables $TESTVAR');
insert into error_messages (Function,Error,Message) values ('TEST','8','test avec des $variables $(echo "commande evaluee")');
insert into error_messages (Function,Error,Message) values ('TEST','9','test avec des $variables `echo "commande evaluee"`');
insert into error_messages (Function,Error,Message) values ('TEST_${TESTVAR}','0','test avec des une clef contenant une variable');
insert into error_messages (Function,Error,Message) values ('Check','65','Non unicite de la clef');
insert into error_messages (Function,Error,Message) values ('Insert','8','La condition de selection de cle n''est pas valide');
insert into error_messages (Function,Error,Message) values ('Insert','97','Aucune valeur a inserer n''est specifiee');
insert into error_messages (Function,Error,Message) values ('Modify','8','La condition de selection de la cle n est pas valide');
insert into error_messages (Function,Error,Message) values ('Modify','68','Aucune ligne trouvee a modifier');
insert into error_messages (Function,Error,Message) values ('Modify','97','Aucune valeur a modifier n''est specifiee');
insert into error_messages (Function,Error,Message) values ('Remove','68','Aucune ligne trouvee a supprimer');
insert into error_messages (Function,Error,Message) values ('Replace','8','La condition de selection de la cle n''est pas valide');
insert into error_messages (Function,Error,Message) values ('Replace','68','Aucune ligne trouvee a remplacer');
insert into error_messages (Function,Error,Message) values ('Replace','97','Aucune valeur a remplacer n''est specifiee');
insert into error_messages (Function,Error,Message) values ('generic','1','Impossible de trouver l''executable %s');
insert into error_messages (Function,Error,Message) values ('generic','2','Impossible de trouver la table %s');
insert into error_messages (Function,Error,Message) values ('generic','3','Impossible de trouver ou d''ouvrir le fichier de definition %s');
insert into error_messages (Function,Error,Message) values ('generic','4','Impossible de trouver le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','5','Le fichier de definition %s n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','6','La table %s est une table virtuelle');
insert into error_messages (Function,Error,Message) values ('generic','7','La colonne %s n''existe pas');
insert into error_messages (Function,Error,Message) values ('generic','8','La condition de selection n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','9','La chaine de definition %s n''est pas valide ou est absente');
insert into error_messages (Function,Error,Message) values ('generic','10','Impossible d''ouvrir le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','11','Impossible d''ecrire dans le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','12','Impossible de supprimer le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','13','Impossible de changer les droits sur le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','14','Impossible de renommer/deplacer le fichier %s en %s');
insert into error_messages (Function,Error,Message) values ('generic','15','Impossible de copier le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','16','Erreur lors d''une ecriture dans le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','17','La commande <%s> a echoue');
insert into error_messages (Function,Error,Message) values ('generic','18','La variable racine BV_HOME ou TOOLS_HOME n''est pas exportee !');
insert into error_messages (Function,Error,Message) values ('generic','19','L''evaluation de <%s> est incorrecte !');
insert into error_messages (Function,Error,Message) values ('generic','20','L''option %s n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','21','Le nombre d''arguments est incorrect');
insert into error_messages (Function,Error,Message) values ('generic','22','L''argument %s n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','23','Utilisation incorrecte de l''option -h');
insert into error_messages (Function,Error,Message) values ('generic','24','Ligne de commande incorrecte');
insert into error_messages (Function,Error,Message) values ('generic','25','Erreur lors d''une allocation de memoire %s');
insert into error_messages (Function,Error,Message) values ('generic','26','Erreur lors d''une re-allocation de memoire %s');
insert into error_messages (Function,Error,Message) values ('generic','27','Erreur lors du chargement de la librairie %s !');
insert into error_messages (Function,Error,Message) values ('generic','28','Impossible de retrouver le symbole %s en librairie !');
insert into error_messages (Function,Error,Message) values ('generic','29','Erreur lors de la fermeture de la librairie %s !');
insert into error_messages (Function,Error,Message) values ('generic','30','Votre licence d''utilisation %s a expire !');
insert into error_messages (Function,Error,Message) values ('generic','31','Le Hostid de la machine n''est pas valide !');
insert into error_messages (Function,Error,Message) values ('generic','32','La licence n''est pas valide !');
insert into error_messages (Function,Error,Message) values ('generic','33','Il n''y a pas de licence valide pour ce produit !');
insert into error_messages (Function,Error,Message) values ('generic','34','Le nombre de clients pour ce produit est depasse !');
insert into error_messages (Function,Error,Message) values ('generic','35','Le nom de fichier %s n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','36','Le fichier %s est verouille');
insert into error_messages (Function,Error,Message) values ('generic','37','Impossible de poser un verrou sur le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','38','Le delai maximum d''attente de deverouillage a ete atteint');
insert into error_messages (Function,Error,Message) values ('generic','39','Le fichier %s n''est pas verouille');
insert into error_messages (Function,Error,Message) values ('generic','40','Impossible de retirer le verrou du fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','41','Le nombre maximal de selections simultanees est depasse');
insert into error_messages (Function,Error,Message) values ('generic','42','Le Handle d''une requete n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','43','Le nombre maximal de conditions est depasse');
insert into error_messages (Function,Error,Message) values ('generic','44','Impossible de retrouver la librairie %s !');
insert into error_messages (Function,Error,Message) values ('generic','45','Un Handle n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','46','Le nombre maximal de fichiers ouverts est depasse');
insert into error_messages (Function,Error,Message) values ('generic','47','Le nombre maximal %s d''allocations de memoire est depasse');
insert into error_messages (Function,Error,Message) values ('generic','48','Impossible de retrouver le fichier de menu %s');
insert into error_messages (Function,Error,Message) values ('generic','49','Impossible de retrouver le dictionnaire graphique %s');
insert into error_messages (Function,Error,Message) values ('generic','50','Erreur lors de l''execution de la fonction de log');
insert into error_messages (Function,Error,Message) values ('generic','51','Erreur de type ''%s'' lors de la deconnexion Oracle !');
insert into error_messages (Function,Error,Message) values ('generic','52','Impossible d''ecrire dans le fichier log %s');
insert into error_messages (Function,Error,Message) values ('generic','53','Impossible de determiner le nom du traitement');
insert into error_messages (Function,Error,Message) values ('generic','54','Le numero d''erreur est manquant');
insert into error_messages (Function,Error,Message) values ('generic','55','Le message d''information est manquant');
insert into error_messages (Function,Error,Message) values ('generic','56','Le numero d''erreur %s n''a pas de message associe');
insert into error_messages (Function,Error,Message) values ('generic','57','Le numero d''erreur %s n''est pas correct');
insert into error_messages (Function,Error,Message) values ('generic','58','Le type de message de log n''est pas correct');
insert into error_messages (Function,Error,Message) values ('generic','59','Le nom de table %s n''est pas valide');
insert into error_messages (Function,Error,Message) values ('generic','60','La colonne %s doit absolument contenir une valeur');
insert into error_messages (Function,Error,Message) values ('generic','61','Il n''y a pas assez de valeurs par rapport au nombre de colonnes');
insert into error_messages (Function,Error,Message) values ('generic','62','Il y a trop de valeurs par rapport au nombre de colonnes');
insert into error_messages (Function,Error,Message) values ('generic','63','La valeur donnee pour la colonne %s n''est pas correcte.');
insert into error_messages (Function,Error,Message) values ('generic','64','Le nom de la table n''est pas specifie');
insert into error_messages (Function,Error,Message) values ('generic','65','Non unicite de la clef de la ligne a inserer');
insert into error_messages (Function,Error,Message) values ('generic','66','Le groupe d''utilisateurs %s n''existe pas');
insert into error_messages (Function,Error,Message) values ('generic','67','Impossible de remplacer une ligne sur une table sans clef');
insert into error_messages (Function,Error,Message) values ('generic','68','Aucune ligne trouvee');
insert into error_messages (Function,Error,Message) values ('generic','69','Entete de definition invalide !');
insert into error_messages (Function,Error,Message) values ('generic','70','Variables d''environnement SEP ou FORMAT absente !');
insert into error_messages (Function,Error,Message) values ('generic','71','Il n''y a pas de lignes en entree stdin !');
insert into error_messages (Function,Error,Message) values ('generic','72','Impossible d''ouvrir le fichier %s en ecriture !');
insert into error_messages (Function,Error,Message) values ('generic','73','Impossible d''ouvrir le fichier %s en lecture !');
insert into error_messages (Function,Error,Message) values ('generic','74','Impossible d''ouvrir le fichier %s en lecture et ecriture !');
insert into error_messages (Function,Error,Message) values ('generic','75','Erreur generique Oracle : %s');
insert into error_messages (Function,Error,Message) values ('generic','76','Erreur de syntaxe dans la requete SQL generee : %s');
insert into error_messages (Function,Error,Message) values ('generic','77','Une valeur a inserer est trop large pour sa colonne !');
insert into error_messages (Function,Error,Message) values ('generic','78','Impossible de se connecter a Oracle avec l''utilisateur %s');
insert into error_messages (Function,Error,Message) values ('generic','79','Impossible de locker la table %s. Ressource deja occupee !');
insert into error_messages (Function,Error,Message) values ('generic','80','La requete interne SQL s''est terminee en erreur !');
insert into error_messages (Function,Error,Message) values ('generic','81','Le nouveau separateur n''est pas specifie !');
insert into error_messages (Function,Error,Message) values ('generic','82','Le nombre maximal de colonnes %s du dictionnaire est depasse !');
insert into error_messages (Function,Error,Message) values ('generic','83','La colonne %s apparait plusieurs fois dans le dictionnaire !');
insert into error_messages (Function,Error,Message) values ('generic','84','La source de donnees %s du dictionnaire est invalide !');
insert into error_messages (Function,Error,Message) values ('generic','85','La table %s ne peut-etre verouillee ou deverouillee !');
insert into error_messages (Function,Error,Message) values ('generic','86','Vous ne pouvez pas remplacer une cle !');
insert into error_messages (Function,Error,Message) values ('generic','87','Impossible de creer un nouveau processus %s !');
insert into error_messages (Function,Error,Message) values ('generic','88','Le nombre maximal de tables %s est depasse');
insert into error_messages (Function,Error,Message) values ('generic','89','Option ou suffixe de recherche invalide !');
insert into error_messages (Function,Error,Message) values ('generic','90','Pas de librairie chargee pour acceder a la base de donnees !');
insert into error_messages (Function,Error,Message) values ('generic','91','Variable d''environnement %s manquante ou non exportee !');
insert into error_messages (Function,Error,Message) values ('generic','92','Parametre <+ recent que> inferieur au parametre <+ vieux que>.');
insert into error_messages (Function,Error,Message) values ('generic','93','Le type de la colonne %s est invalide !');
insert into error_messages (Function,Error,Message) values ('generic','94','Impossible de retrouver le formulaire %s');
insert into error_messages (Function,Error,Message) values ('generic','95','Impossible de retrouver le panneau de commandes %s.');
insert into error_messages (Function,Error,Message) values ('generic','96','L''operateur de selection est incorrect !');
insert into error_messages (Function,Error,Message) values ('generic','97','Aucune valeur donnee');
insert into error_messages (Function,Error,Message) values ('generic','98','La taille maximale %s d''une ligne est depassee !');
insert into error_messages (Function,Error,Message) values ('generic','99','Le champ %s est mal decrit dans la table %s');
insert into error_messages (Function,Error,Message) values ('generic','100','%s');
insert into error_messages (Function,Error,Message) values ('generic','101','Le parametre %s n''est pas un chiffre');
insert into error_messages (Function,Error,Message) values ('generic','102','L''utilisateur %s n''existe pas');
insert into error_messages (Function,Error,Message) values ('generic','103','La cle de reference de la contrainte sur %s est incorrecte.');
insert into error_messages (Function,Error,Message) values ('generic','104','Erreur lors du delete sur %s');
insert into error_messages (Function,Error,Message) values ('generic','105','La variable %s n''est pas du bon type');
insert into error_messages (Function,Error,Message) values ('generic','106','Probleme lors du chargement de l''environnement %s');
insert into error_messages (Function,Error,Message) values ('generic','107','Environnement %s non accessible');
insert into error_messages (Function,Error,Message) values ('generic','108','Probleme pour acceder a la table %s');
insert into error_messages (Function,Error,Message) values ('generic','109','La table %s n''existe pas ou n''est pas accessible');
insert into error_messages (Function,Error,Message) values ('generic','110','Impossible de retrouver l''objet %s');
insert into error_messages (Function,Error,Message) values ('generic','111','La table %s existe sous plusieurs schemas');
insert into error_messages (Function,Error,Message) values ('generic','112','Probleme pour recuperer les contraintes de %s');
insert into error_messages (Function,Error,Message) values ('generic','113','Erreur lors du disable de contraintes de %s');
insert into error_messages (Function,Error,Message) values ('generic','114','Erreur lors de l''enable de contraintes de %s');
insert into error_messages (Function,Error,Message) values ('generic','115','Erreur lors du chargement de la table %s');
insert into error_messages (Function,Error,Message) values ('generic','116','Des enregistrements ont ete rejetes pour la table %s');
insert into error_messages (Function,Error,Message) values ('generic','117','La contrainte %s est invalide !');
insert into error_messages (Function,Error,Message) values ('generic','118','Le nombre maximal %s de cles etrangeres est depasse.');
insert into error_messages (Function,Error,Message) values ('generic','119','Le nombre maximal %s de contraintes est depasse.');
insert into error_messages (Function,Error,Message) values ('generic','120','Impossible de creer le fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','121','La table %s n''est pas une table de reference.');
insert into error_messages (Function,Error,Message) values ('generic','122','La table %s existe sous plusieurs cles etrangères.');
insert into error_messages (Function,Error,Message) values ('generic','123','Les droits sur le fichier %s sont incorrects.');
insert into error_messages (Function,Error,Message) values ('generic','124','Probleme pour recuperer les informations ''%s'' de la Machine %s.');
insert into error_messages (Function,Error,Message) values ('generic','125','Le type de la licence est invalide.');
insert into error_messages (Function,Error,Message) values ('generic','126','L''utilisateur %s n''est pas administrateur du systeme.');
insert into error_messages (Function,Error,Message) values ('generic','127','Les colonnes %s doivent absolument contenir une valeur.');
insert into error_messages (Function,Error,Message) values ('generic','128','La table %s ne possede pas de cle primaire.');
insert into error_messages (Function,Error,Message) values ('generic','129','La valeur d''une cle primaire ne peut-etre nulle.');
insert into error_messages (Function,Error,Message) values ('generic','130','Options de commande %s incompatibles');
insert into error_messages (Function,Error,Message) values ('generic','131','Le tri de séléction ''%s'' est invalide.');
insert into error_messages (Function,Error,Message) values ('generic','132','Le format de la date ''%s'' est invalide.');
insert into error_messages (Function,Error,Message) values ('generic','133','Les eléments % de la date doivent être séparés par un caractère.');
insert into error_messages (Function,Error,Message) values ('generic','134','La date ''%s'' ne correspond pas au format %s.');
insert into error_messages (Function,Error,Message) values ('generic','148','Vous n''avez pas les droits %s.');
insert into error_messages (Function,Error,Message) values ('generic','149','Probleme d''environnement %s');
insert into error_messages (Function,Error,Message) values ('generic','150','Mot de Passe inconnu pour le user %s sur la base $ORACLE_SID');
insert into error_messages (Function,Error,Message) values ('generic','151','Variables inconnues BV_ORAUSER et/ou BV_ORAPASS');
insert into error_messages (Function,Error,Message) values ('generic','152','L''intance %s est invalide ou non demarrée.');
insert into error_messages (Function,Error,Message) values ('V1_alim_30_motcle','0001','ECHEC ce l''Insert Arg de %s dans t_me_alma');
insert into error_messages (Function,Error,Message) values ('V1_alim_30_motcle','0002','Argument de la methode %s non declare dans me_alma');
insert into error_messages (Function,Error,Message) values ('V1_alim_30_motcle','0003','Rang de l''argument de la methode %s incoherent');
insert into error_messages (Function,Error,Message) values ('V1_alim_30_motcle','0004','ECHEC de l''insertion du mot cle %s dans t_me_ma');
insert into error_messages (Function,Error,Message) values ('V1_alim_40_meth','0001','Le mot cle d''action %s n''existe pas');
insert into error_messages (Function,Error,Message) values ('V1_alim_40_meth','0002','L''Insertion de la methode physique %s a echoue');
insert into error_messages (Function,Error,Message) values ('V1_alim_40_meth','0003','L''Insertion de la variable interne %s a echoue');
insert into error_messages (Function,Error,Message) values ('V1_alim_40_meth','0004','L''Insertion du type physique %s a echoue');
insert into error_messages (Function,Error,Message) values ('PC_CHGSTAT_SERV','0004','Aucune instance n''est associee a l''application %s');
insert into error_messages (Function,Error,Message) values ('generic','301','Le module applicatif %s n''est pas ou mal declaré.');
insert into error_messages (Function,Error,Message) values ('generic','302','L''instance de service %s ne semble pas exister.');
insert into error_messages (Function,Error,Message) values ('generic','303','Le script fils <%s> a retourne un warning');
insert into error_messages (Function,Error,Message) values ('generic','304','Le script fils <%s> a retourne une erreur bloquante');
insert into error_messages (Function,Error,Message) values ('generic','305','Le script fils <%s> a retourne une erreur fatale');
insert into error_messages (Function,Error,Message) values ('generic','306','Le script fils <%s> a retourne un code d''erreur errone %s');
insert into error_messages (Function,Error,Message) values ('generic','308','Erreur a l''execution de %s');
insert into error_messages (Function,Error,Message) values ('generic','309','Le service %s ''%s'' n''existe pas.');
insert into error_messages (Function,Error,Message) values ('generic','310','Le service %s ''%s'' est deja demarre.');
insert into error_messages (Function,Error,Message) values ('generic','311','Le service %s ''%s'' est deja arrete.');
insert into error_messages (Function,Error,Message) values ('generic','312','Le service %s ''%s'' n''a pas demarre correctement.');
insert into error_messages (Function,Error,Message) values ('generic','313','Le service %s ''%s'' ne s''est pas arrete correctement.');
insert into error_messages (Function,Error,Message) values ('generic','314','Le service %s ''%s'' n''est pas ou mal declaré.');
insert into error_messages (Function,Error,Message) values ('generic','315','Le module applicatif %s ne possède aucune instance de service.');
insert into error_messages (Function,Error,Message) values ('generic','316','La ressource %s ''%s'' n''est pas ou mal declaré.');
insert into error_messages (Function,Error,Message) values ('generic','317','Impossible de choisir un type pour le Service %s ''%s''.');
insert into error_messages (Function,Error,Message) values ('generic','318','Impossible de choisir un type de service pour le I-CLES %s.');
insert into error_messages (Function,Error,Message) values ('generic','319','La table %s n''est pas collectable.');
insert into error_messages (Function,Error,Message) values ('generic','320','Le type de ressource %s n''est pas ou mal déclaré.');
insert into error_messages (Function,Error,Message) values ('generic','321','Le Type de Service %s du I-CLES %s n''existe pas.');
insert into error_messages (Function,Error,Message) values ('generic','401','Le repertoire %s n''existe pas');
insert into error_messages (Function,Error,Message) values ('generic','402','Impossible de creer le repertoire %s');
insert into error_messages (Function,Error,Message) values ('generic','403','Impossible d''ecrire dans le repertoire %s');
insert into error_messages (Function,Error,Message) values ('generic','404','Impossible de lire le contenu du repertoire %s');
insert into error_messages (Function,Error,Message) values ('generic','405','Le fichier %s n''existe pas ou est vide');
insert into error_messages (Function,Error,Message) values ('generic','406','Le fichier %s existe deja');
insert into error_messages (Function,Error,Message) values ('generic','408','Le fichier %s n''est pas au format %s');
insert into error_messages (Function,Error,Message) values ('generic','409','Erreur lors de l''initialisation du fichier %s');
insert into error_messages (Function,Error,Message) values ('generic','410','Probleme lors de la restauration/decompression de %s');
insert into error_messages (Function,Error,Message) values ('generic','411','Probleme lors de la decompression de %s');
insert into error_messages (Function,Error,Message) values ('generic','412','Probleme lors de la compression de %s');
insert into error_messages (Function,Error,Message) values ('generic','413','Probleme lors de la securisation/compression de %s');
insert into error_messages (Function,Error,Message) values ('generic','414','Le Lecteur %s doit etre NO REWIND pour avancer/reculer');
insert into error_messages (Function,Error,Message) values ('generic','415','Le device %s n''existe pas ou est indisponible');
insert into error_messages (Function,Error,Message) values ('generic','416','Probleme lors de la creation du lien vers %s');
insert into error_messages (Function,Error,Message) values ('generic','417','Le lecteur %s est inaccessible');
insert into error_messages (Function,Error,Message) values ('generic','420','Impossible d''aller sous le répertoire ''%s''.');
insert into error_messages (Function,Error,Message) values ('ME_CREATE_SYNORA','0001','Probleme a la creation du Synonyme %s');
insert into error_messages (Function,Error,Message) values ('ME_DROP_SYNORA','0001','Probleme a la suppression du Synonyme %s');
insert into error_messages (Function,Error,Message) values ('ME_LOAD_TABORA','0001','Echec du Load sqlldr de %s');
insert into error_messages (Function,Error,Message) values ('ME_RESTORE_TABORA','0001','Erreur lors de la restauration de la table %s');
insert into error_messages (Function,Error,Message) values ('ME_SECURE_TABORA','0001','Impossible de recuperer la taille du tablespace %s');
insert into error_messages (Function,Error,Message) values ('ME_SECURE_TABORA','0002','Impossible de recuperer la taille de la table %s');
insert into error_messages (Function,Error,Message) values ('ME_SECURE_TABORA','0003','Erreur lors de la securisation de la table %s');
insert into error_messages (Function,Error,Message) values ('ME_SECURE_TABORA','0004','Impossible de recuperer la taille de la sauvegarde');
insert into error_messages (Function,Error,Message) values ('ME_SECURE_TABORA','0365','Probleme lors de la mise a jour de la table %s');
insert into error_messages (Function,Error,Message) values ('ME_TRUNC_TABORA','176','Probleme de truncate sur %s (Contrainte type P referencee) ');
insert into error_messages (Function,Error,Message) values ('PC_BACK_TBSORA','137','Probleme pour mettre le TBSPACE %s en BEGIN BACKUP');
insert into error_messages (Function,Error,Message) values ('PC_BACK_TBSORA','138','Probleme pour mettre le TBSPACE %s en END BACKUP');
insert into error_messages (Function,Error,Message) values ('PC_BACK_TBSORA','139','Probleme pour manipuler le TBSPACE %s');
insert into error_messages (Function,Error,Message) values ('PC_LISTBACK_ARCHORA','0001','Il manque la sequence d''archives %s pour la base %s');
insert into error_messages (Function,Error,Message) values ('PC_LISTBACK_ARCHORA','0002','Il n''existe pas d''archives commençant a la sequence %s.');
insert into error_messages (Function,Error,Message) values ('PC_LISTBACK_CTRLORA','128','Impossible d''interroger les logfiles de %s');
insert into error_messages (Function,Error,Message) values ('PC_LISTBACK_CTRLORA','132','Impossible d''interroger les controlfiles de %s');
insert into error_messages (Function,Error,Message) values ('PC_LISTID_INSORA','182','Impossible de trouver la Base du user %s');
insert into error_messages (Function,Error,Message) values ('PC_SWITCH_LOGORA','127','Probleme lors du switch des logfiles de %s');
insert into error_messages (Function,Error,Message) values ('PC_SWITCH_LOGORA','128','Impossible d''interroger les logfiles pour %s');
insert into error_messages (Function,Error,Message) values ('generic','501','L''instance Oracle %s n''est pas demarree');
insert into error_messages (Function,Error,Message) values ('generic','502','L''instance Oracle %s n''est pas arretee');
insert into error_messages (Function,Error,Message) values ('generic','503','%s n''est pas un mode d''arret Oracle valide');
insert into error_messages (Function,Error,Message) values ('generic','504','%s n''est pas un mode de demarrage Oracle valide');
insert into error_messages (Function,Error,Message) values ('generic','505','La base Oracle %s existe deja dans /etc/oratab');
insert into error_messages (Function,Error,Message) values ('generic','506','Impossible de retrouver l''environnement de l''instance Oracle %s');
insert into error_messages (Function,Error,Message) values ('generic','507','Impossible de retrouver l''init file de la base %s');
insert into error_messages (Function,Error,Message) values ('generic','508','Le fichier de config de %s n''est pas renseigne dans l''initfile');
insert into error_messages (Function,Error,Message) values ('generic','509','Les controlfiles de %s ne sont pas renseignes dans les initfiles');
insert into error_messages (Function,Error,Message) values ('generic','510','Les parametres d''archive %s n''existent pas dans les initfiles');
insert into error_messages (Function,Error,Message) values ('generic','511','Parametre log_archive_dest de %s non defini dans les initfiles');
insert into error_messages (Function,Error,Message) values ('generic','512','Parametre log_archive_format de %s non defini dans les initfiles');
insert into error_messages (Function,Error,Message) values ('generic','513','L''archivage de %s n''est pas demarre correctement');
insert into error_messages (Function,Error,Message) values ('generic','514','L''archivage de %s n''est pas arrete correctement');
insert into error_messages (Function,Error,Message) values ('generic','515','Script SQL %s non accessible');
insert into error_messages (Function,Error,Message) values ('generic','517','Le script SQL %s ne s''est pas execute correctement');
insert into error_messages (Function,Error,Message) values ('generic','518','Probleme lors de la suppression de la table %s ');
insert into error_messages (Function,Error,Message) values ('generic','519','Probleme a l''execution du delete ou truncate de %s sur $ORACLE_SID');
insert into error_messages (Function,Error,Message) values ('generic','520','Aucun Archive Oracle pour la Base %s');
insert into error_messages (Function,Error,Message) values ('PC_INITF_SQLNET','004','La configuration SqlNet %s de %s est introuvable');
insert into error_messages (Function,Error,Message) values ('FT_LISTLST_SQLNET','346','Aucun Listener convenablement declare dans %s');
insert into error_messages (Function,Error,Message) values ('FT_LIST_TNSNAME','346','Aucun Service TNS convenablement declare dans %s');
insert into error_messages (Function,Error,Message) values ('PC_ENV_SQLNET','506','Impossible de trouver l''environnement de l''instance Sqlnet %s');
insert into error_messages (Function,Error,Message) values ('PC_LISTID_SQLNET','182','Impossible de trouver le Noyau SqlNet du user %s');
insert into error_messages (Function,Error,Message) values ('PC_STAT_TNSNAME','001','Le service TNS %s n''est pas decrit');
insert into error_messages (Function,Error,Message) values ('PC_STAT_TNSNAME','002','Il n''y a pas de listener demarre servant le service TNS %s');
insert into error_messages (Function,Error,Message) values ('PC_STAT_TNSNAME','003','Erreur de configuration de l''adresse du service TNS %s');

EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('PC_PRINT_SQL.pl', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'PC_PRINT_SQL.pl'."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'PC_PRINT_SQL.pl'."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'PC_PRINT_SQL.pl'."> output <".q{insert int...}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'PC_PRINT_SQL.pl'."> errstd") or diag($return_error);

