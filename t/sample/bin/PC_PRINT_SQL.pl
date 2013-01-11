#! /usr/bin/env perl
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
#@I-SIS USAGE : Usage : Read_Row [-h] [-e] [-n] [-q] [-H]
#
#@I-SIS OPT : -h : l'utilisation de la ligne de commande
#@I-SIS OPT : -H : n'affecte pas le HEADER
#@I-SIS OPT : -n : affecte des variables vide si STDIN est vide
#@I-SIS OPT : -e : export au format bourne shell
#@I-SIS OPT : -q : quotes doubles
#
#@I-SIS ARG : 
#
#@I-SIS ENV : TOOLS_HOME
#
###############################################################################

# Inclusions obligatoires
use strict;
use warnings;
use Getopt::Std;
use ScriptCooker::ITools 1.0.0;
use ScriptCooker::Utils 1.0.0;
use Carp;

# variables globales

sub usage {
    die("usage: ",<<USAGE );
USAGE
}

#  Traitement des Options
###########################################################

my %opts;
getopts( 'h', \%opts ) or usage();

usage() if $opts{h};


#  Traitement des arguments
###########################################################

if ( @ARGV > 0 ) {
    log_error( _t("Le nombre d'argument est incorrect"));
    usage();
}


#  Corps du script
###########################################################


foreach my $row ( select_from_table("error_messages") ) {
    my $message = $row->{Message};
    $message =~ s/'/''/g;
    print "insert into error_messages (Function,Error,Message) values ('$row->{Function}','$row->{Error}','$message');\n"
}

