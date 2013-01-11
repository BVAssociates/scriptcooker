#! /usr/bin/perl -w
#
#   I-SIS, 2011
#
#@I-SIS APP : I-SIS                                   $Revision: 1.1 $
#
#@I-SIS I-CLES : I-TOOLS
#
#@I-SIS Date : 27/09/2011                             Auteur : V. Bauchart
#                                                     (BV Associates)
#   Historique des modifications
#
#   ---------------------------------------------------------------------
#   |   Date    |    Auteur   |         Description                     |
#   ---------------------------------------------------------------------
#   ---------------------------------------------------------------------
#
#@I-SIS FONCTION : 
#
#@I-SIS USAGE : Usage : make_bat.pl <repertoire bin>
#
#@I-SIS OPT : -h : l'utilisation de la ligne de commande
#
#@I-SIS ARG : <repertoire bin> : racine du répertoire qui contient les fichiers à transformer
#
#@I-SIS ENV : TOOLS_HOME
#
###############################################################################

# Inclusions obligatoires
use strict;
use warnings;
use Getopt::Std;
use File::Glob ':glob'; #glob pour windows!
use File::Basename;


# variables globales

sub usage {
    die(_t("usage: [_1]",<<USAGE ));
make_bat.pl <repertoire bin>
USAGE
}

#  Traitement des Options
###########################################################

my %opts;
getopts( 'h', \%opts ) or usage();

usage() if $opts{h};



#  Traitement des arguments
###########################################################

if ( @ARGV < 0 ) {
    usage();
}

my $dir=shift @ARGV;

if ( ! $dir ) {
    if ( $ENV{TOOLS_HOME} ) {
        $dir = $ENV{TOOLS_HOME}.'/bin';
    }
    else {
        usage();
    }
}

#  Corps du script
###########################################################

my $here = dirname($0);

foreach my $script_name ( glob($dir."/*") ) {
	next if $script_name =~ /\.(bat|exe)$/;
	
    $script_name =~ s/\.pl$//;
	my $batch_name = $script_name.'.bat';
	
	print "Création de $batch_name\n";
	open my $batch, '>', $batch_name;
    
    print $batch <<'BATCH' ;
@echo off
perl -x -MScriptCooker::Win32 -S %0 %*
BATCH

    close $batch;
}