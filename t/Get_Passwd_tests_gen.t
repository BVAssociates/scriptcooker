#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;
use Test::More tests => 12;

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
# Get_Passwd         | perl -F: -ane 'print @F[0,2] if $F[0] eq "root"'
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
root0
EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_Passwd         | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\'', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_Passwd         | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_Passwd         | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_Passwd         | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> output <".q{root0}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_Passwd         | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> errstd") or diag($return_error);


##################
# Get_Passwd -u root | perl -F: -ane 'print @F[0,2] if $F[0] eq "root"'
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
root0
EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_Passwd -u root | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\'', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_Passwd -u root | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_Passwd -u root | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_Passwd -u root | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> output <".q{root0}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_Passwd -u root | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> errstd") or diag($return_error);


##################
# Get_Group         | perl -F: -ane 'print @F[0,2] if $F[0] eq "root"'
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
root0
EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_Group         | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\'', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_Group         | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_Group         | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_Group         | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> output <".q{root0}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_Group         | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> errstd") or diag($return_error);


##################
# Get_Group -g root | perl -F: -ane 'print @F[0,2] if $F[0] eq "root"'
##################

$expected_code = 0;
$expected_string = <<'EXPECTED_OUTPUT';
root0
EXPECTED_OUTPUT
chomp $expected_string;
$expected_error = << 'EXPECTED_ERRSTD';

EXPECTED_ERRSTD
chomp $expected_error;

run3('Get_Group -g root | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\'', undef, \$return_string, \$return_error);

$home=quotemeta($ENV{TOOLS_HOME});
$return_string =~ s/$home/TOOLS_HOME/g;
$return_error =~ s/$home/TOOLS_HOME/g;

if ( $? == -1 ) {
	BAIL_OUT("<".'Get_Group -g root | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> retourne -1");
}
$return_code = $? >> 8;

is ( $return_code ,$expected_code , "<".'Get_Group -g root | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> return code $expected_code");
is ( $return_string ,$expected_string , "<".'Get_Group -g root | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> output <".q{root0}.">");

# test si a renvoyer une erreur ou non
is ( $return_error ne '', $expected_error ne '', "<".'Get_Group -g root | perl -F: -ane \'print @F[0,2] if $F[0] eq "root"\''."> errstd") or diag($return_error);

