#!/usr/bin/perl
#
#    This file is part of ScriptCooker.
#
#    ScriptCooker is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    ScriptCooker is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with ScriptCooker.  If not, see <http://www.gnu.org/licenses/>.
#
#
#   I-SIS, 2009
#
#@I-SIS APP : I-TOOLS                                   $Revision: 1.1 $
#
#@I-SIS Date : 01/09/2010                             Auteur : V. Bauchart
#                                                     (BV Associates)
#   Historique des modifications
#
#   ---------------------------------------------------------------------
#   |   Date    |    Auteur   |         Description                     |
#   ---------------------------------------------------------------------
#   ---------------------------------------------------------------------
#
#@I-SIS FONCTION : créer un banc de test compatible avec
#       le module Test de Perl les fichiers t/gentests/* contiennent
#       la liste des commandes à tester.
#		On peut inclure du code Perl pour valoriser des
#		variables avec #include
#
#@I-SIS USAGE : make_test.pl -d nb
#
#@I-SIS OPTION : -d : ajoute un delay en seconde entre chaque commande
#

use strict;
use File::Basename;
use IPC::Run3;
use Getopt::Std;
use Data::Dumper;

use ScriptCooker::Utils;

########################################################
#      Fonctions
########################################################

sub usage {
	die "USAGE: $0 [-v] fichier [fichier ...]";
}

my $global_verbose;
sub debug {
	my $message = shift;

	return if not $global_verbose;

	warn $message;
	return;
}

sub print_header {
    my $file=shift;

	print $file <<HEADER ;
#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run3;
use Test::More;

my \$expected_code;
my \$expected_string;
my \$expected_error;
my \$return_code;
my \$return_string;
my \$return_error;

my \$home;

HEADER

	return;
}

sub print_expected_values {
    my $file=shift;
	my $command     = shift;
	my $return_code = shift;
	my $output      = shift;
	my $errstd      = shift;

	print $file <<SECTION ;

##################
# $command
##################

SECTION

	print $file "\$expected_code = $return_code;\n";

	print $file "\$expected_string = <<'EXPECTED_OUTPUT';\n";
	print $file $output;
	print $file "\nEXPECTED_OUTPUT\n";
    print $file "chomp \$expected_string;\n";

	print $file "\$expected_error = << 'EXPECTED_ERRSTD';\n";
	print $file $errstd;
	print $file "\nEXPECTED_ERRSTD\n";
    print $file "chomp \$expected_error;\n";

	return;
}

sub print_test {
    my $file=shift;
	my $command      = shift;
	my $result_short = shift;

    $Data::Dumper::Terse = 1;
    $Data::Dumper::Indent = 0;
    $command=Dumper($command);


	print $file <<TEST ;

run3($command, undef, \\\$return_string, \\\$return_error);

\$home=quotemeta(\$ENV{TOOLS_HOME});
\$return_string =~ s/\$home/TOOLS_HOME/g;
\$return_error =~ s/\$home/TOOLS_HOME/g;

if ( \$? == -1 ) {
	BAIL_OUT("<".$command."> retourne -1");
}
\$return_code = \$? >> 8;

is ( \$return_code ,\$expected_code , "<".$command."> return code \$expected_code");
is ( \$return_string ,\$expected_string , "<".$command."> output <".q{$result_short}.">");

# test si a renvoyer une erreur ou non
is ( \$return_error ne '', \$expected_error ne '', "<".$command."> errstd") or diag(\$return_error);

TEST

    # retourne le nombre de test
	return 3;
}

sub print_special {
    my $file=shift;
	my $perl_code = shift;

	print $file $perl_code."\n";

	return;
}

########################################################
#      Verifications
########################################################

my %opts;
getopts( 'vd:p:', \%opts ) or usage();

$global_verbose++ if $opts{v};

my $delay = $opts{d};
my $prefix_path = $opts{p};
if ( $prefix_path ) {
    chdir $prefix_path or usage();
}

if ( @ARGV < 0 ) {
	usage();
}


debug("verification de l'environnement");
if ( ! $ENV{BV_HOME} ) {
    die ("Variable d'environnement BV_HOME maquante");
}
if ( ! $ENV{TOOLS_HOME} ) {
    die ("Variable d'environnement TOOLS_HOME maquante");
}
if ( ! -d 't/' ) {
	die "Le répertoire t/ n'existe pas";
}

debug("chargemement de l'environnement de test");
source_profile('t/sample/profile.RT.minimal');

########################################################
#      Programme principal
########################################################

my @file_to_read=glob('t/gentest/*_tests');

if ( ! @file_to_read ) {
    die ("aucun fichier à lire dans t/gentests/");
}

# drapeau de validation de code retour
my $command_must_work=1;
my $skip_test=0;
my $skip_all=0;
my %ENV_SAVE=%ENV;
foreach my $filename ( @file_to_read ) {
    my $test_nb = 0;

    # reset de l'environnement
    %ENV=%ENV_SAVE;

    my $test_file = "t/".basename($filename)."_gen.t";

    my $parse_file_fd;
    my $test_file_fd;

    open ( $parse_file_fd, '<', $filename) or die ("opening $filename : $!");

    debug("ouverture du fichier $test_file");
    open ( $test_file_fd, '>', $test_file) or die ("write $test_file : $!");

    print_header($test_file_fd);

    TEST:
    while (<$parse_file_fd>) {
        chomp;


        # instruction speciale
        if ( /^#include (.*)$/ ) {
            my $perl_code=$1;

            debug("eval <$_> as Perl");
            eval($perl_code);
            die($@) if $@;

            print_special( $test_file_fd, $perl_code );

            next TEST;
        }
        # Aucun test ne sera effectué
        elsif ( /^#skip_all\s*(.*)$/ ) {
            $skip_all = $1;
            if ( ! $skip_all ) {
                    $skip_all = 'aucune raison donnee';
            }

            next TEST;
        }
        # previent que la prochaine command sera en erreur
        elsif ( /^#next error/ ) {
            $command_must_work=0;

            next TEST;
        }
        elsif ( /^#next skip (.*)/ ) {
            if ($1) {
                $skip_test=$1;
            }
            else {
                $skip_test="Aucune raison donnée";
            }

            next TEST;
        }
        # ignore ligne vide
        elsif ( /^#/ or /^\s*$/) {
            next TEST;
        }

        # ajoute un delay (necessaire sur HP-UX)
        sleep($delay) if $delay;

        my $command=$_;
        debug("Traitement de <$command>");

        my $result;
        my $result_err;
        eval { run3($command, undef, \$result, \$result_err) };
        if ( $@ ) {
            print $test_file_fd q{die "Probleme lors de la generation du script : $@"};
            die "<$command> failed : $@";
        }
        my $return_code = $? >> 8;

        if ( $command_must_work xor ( $return_code == 0 ) ) {
                warn $result_err;
                warn "<$command> a retourne $return_code";
        }
        # reinitialise
        $command_must_work=1;

        my $home=quotemeta($ENV{TOOLS_HOME});
        $result =~ s/$home/TOOLS_HOME/g;
        $result_err =~ s/$home/TOOLS_HOME/g;

        my $result_short=substr($result, 0, 10);
        $result_short =~ s/\n.*//m;
        if ( length($result) > 10 ) {
            $result_short .= '...';
        }
        
        print_expected_values($test_file_fd, $command, $return_code, $result, $result_err);

        if ( $skip_test ) {
            print_special($test_file_fd, "SKIP: {\nskip q{$skip_test}, 3;\n");
        }

        print_test($test_file_fd, $command, $result_short);
        $test_nb += 3;

        if ( $skip_test ) {
            print_special($test_file_fd, "}\n");
            $skip_test = undef;
        }

    }

    close $test_file_fd or die $!;
    close $parse_file_fd or die $!;

    # utilise le raccourcis $^I (perl -i) pour modifier le nombre de test au debut du fichier
    local @ARGV=($test_file);
    $^I="";
    while (<>) {

        if ( /use Test::More/ ) {
            if ( $skip_all ) {
                print "use Test::More skip_all => q{$skip_all};\n";
                $skip_all=0;
            }
            else {
                print "use Test::More tests => $test_nb;\n";
            }
        }
        else {
            print;
        }
    }
}
