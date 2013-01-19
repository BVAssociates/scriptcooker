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
# ------------------------------------------------------------
# Copyright (c) 2011, BV Associates. Tous droits reserves.
# ------------------------------------------------------------
#
# $Revision: 368 $
#
# ------------------------------------------------------------
#
# Description : Module ScriptCooker::Win32     
# Date :        26/06/2011    
# Auteur :      V. Bauchart   
# Projet :      I-TOOLS       
#
# ------------------------------------------------------------
#
# Historique des modifications
#
# $Log$
#
# ------------------------------------------------------------

# Declaration du package
package ScriptCooker::Win32;

# -------
# Imports systemes 
# -------
use strict;
use warnings;

use Encode;
# ------------------
# Variables globales
# ------------------
our (@ISA, @EXPORT, @EXPORT_OK);

our $VERSION = 2.1.0;

# variable sauvegarde du @ARGV original
my @ARGV_backup;
# variable sauvegarde du %ENV original
my %ENV_backup;

# -------------------------
# Section de chargement
# Declaration des "exports"
# -------------------------
BEGIN {
    require Exporter;
    @ISA = qw(Exporter);

    @EXPORT = qw(
        win32_get_env
    );
    
    # Fonctions exportees à la demande
    @EXPORT_OK = qw(
        win32_decode_env
        win32_restore_env
    );

}

##################################################
# Fonctions
##################################################

# Encode au format Perl tout ce qui vient de l'exterieur
# On suppose que la première commande appelé est lancé par un CMD
# ATTENTION aux effets de bords dans les programmes lancés qui ne serait pas au courant de la modification!
sub win32_decode_env {

    # Variable d'environnement informant les sous-processus que l'environnement est déjà prêt
    if ( ! $ENV{BV_WIN32_ENCODE} ) {
        @ARGV_backup = @ARGV;
        %ENV_backup  = %ENV;
        
        map { $_=encode("cp850",$_) } @ARGV;
        map { $_=encode("cp850",$_) } values %ENV;
        
        $ENV{BV_WIN32_ENCODE}="TRUE";
    }
    
    return;
}

sub win32_get_env {
    my %ENV_temp=%ENV;
    map { $_=decode("cp850",$_) } values %ENV_temp;
    return %ENV_temp;
}

sub win32_restore_env {

    if ( $ENV{BV_WIN32_ENCODE} ) {
        @ARGV = @ARGV_backup;
        %ENV  = %ENV_backup;

        delete $ENV{BV_WIN32_ENCODE};
    }
    
    return;
}

##################################################
# initialisation
##################################################

BEGIN {
    
    # lance immediatement le décodage de l'environnement issu du CMD.EXE
    win32_decode_env();
}

1;
