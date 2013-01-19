#! /usr/bin/env perl
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
# --------------------------------------------------------------
# BV Associates, 2011
#
# CLES :     I-TOOLS
# REVISION : $Revision: 395 $
# AUTEUR :   V. Bauchart (BV Associates)
# DATE :     27/09/2011
#
# --------------------------------------------------------------
#
# OBJECTIF
#    
#
# SYNOPSIS
#    Usage : Modele [-h] ...
#
# OPTIONS
#    -h pour avoir l'utilisation de la ligne de commande
#
# ARGUMENTS
#    arg1 : ...
#
# PREREQUIS
#    TOOLS_HOME
#
# REMARQUE
#
# --------------------------------------------------------------
#
# HISTORIQUE
#
# --------------------------------------------------------------

# Inclusions obligatoires
use strict;
use warnings;
use Getopt::Std;

# Inclusions des I-TOOLS
use ScriptCooker::ITools;
use ScriptCooker::Utils;

# variables globales

my $global;

#  Fonctions
###########################################################

sub usage {
        die('Usage: Modele [-h] ...');
}


sub myfunc {
    my $arg1=shift;
    my $arg2=shift;

    return;
}

#  Traitement des Options
###########################################################

my %opts;
getopts( 'h', \%opts ) or usage();


usage() if $opts{h};


#  Traitement des arguments
###########################################################

if ( @ARGV != 1 ) {
    log_error("Le nombre d'arguments est incorrect");
    usage();
}

my $arg1 = shift @ARGV;

if ( $arg1 !~ /^[\w_]+$/ ) {
    die('Le premier argument doit être composé de caractères alphanumeriques');
}

#  Corps du script
###########################################################

my @processes = select_from_table(
                        'ps',
                        { Condition => "Uid = $arg1" }
                    );

foreach my $process ( @processes ) {
    printf("%s (%d) : %s\n", $process->{Uid}, $process->{Pid}, $process->{Command});
}
