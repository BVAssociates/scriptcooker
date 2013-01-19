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
# $Revision: 413 $
#
# ------------------------------------------------------------
#
# Description : Module ITable
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
package ScriptCooker::ITable;

our $VERSION=2.1.0;

# -------
# Imports systemes
# -------
use strict;
use warnings;

use Carp;
my $package=__PACKAGE__;
$Carp::Internal{$package} = 1;

# -------
# Imports libs
# -------
use ScriptCooker::Define 2.1.0;
use ScriptCooker::Pci    2.1.0;
use ScriptCooker::Log    2.1.0 qw{$logger _t};


##################################################
##  Constructeur
##################################################


# ------------------------------------------
# Nom : ITable::open
#
# Description :
# Constructeur (type Factory) qui crée un objet ScriptCooker::Define 
# et qui construit et renvoie un objet de type ScriptCooker::ITable::*
# correspondant au type de données à acceder (ITools, Oracle,...)
#
# Arguments :
#   - table_name : nom de la table à ouvrir
#   - options : reference vers un HASH qui contiendra des options
#        Les options sont gérés par chaque classe ITable::*
#
# Retourne :
#   - un objet de type type ITable::* correspondant au type de table
# ------------------------------------------

sub open {
    my $self = shift;
    
    my $table_name = shift;
    my $options = shift;

    if ( ! $table_name ) {
        croak(_t("usage: [_1]"),__PACKAGE__."->open(table_name, options)");
    }
    
    my $define_obj = ScriptCooker::Define->new($table_name, $options );
    
    if ( ! defined $define_obj ) {
        die(_t("Impossible de creer l'objet [_1]"),"ScriptCooker::Define");
    }
    
    if (not defined $define_obj->type() ) {
        die(_t("Impossible de retrouver le type de [_1]"),"$table_name");
    }
    
    my $required_module = "ScriptCooker::ITable::".ucfirst(lc($define_obj->type() ) );
    
    # Load the correct object for TYPE
    eval "use $required_module";
    if ($@) {
        warn($@);
        croak(_t("Impossible de charger la librairie d'acces au TYPE : [_1]"),$define_obj->type());
    }
    
    my $itable = $required_module->open($define_obj,$options);

    if ( $table_name eq '-' ) {
        # pas de message, car on ne connait pas le nom de la table
    }
    else {
        $itable->pci(ScriptCooker::Pci->open($table_name));
        $logger->info(_t("Ouverture de la table [_1] de type [_2]",$table_name,$define_obj->type()));
    }

    return $itable;
}

1;  # so the require or use succeeds



=head1 NAME

Package ScriptCooker::ITable

=head1 SYNOPSIS

 use ScriptCooker::ITable 2.1.0;

 my $table = ScriptCooker::ITable->open("ps");
 $table->query_field("Uid","Pid");

 while ( my %row = $table->fetch_row() ) {
     print "$row{Pid} : $row{UID}\n";
 }

=cut

=head1 DESCRIPTION

Super-classe permettant de créer l'objet de type ScriptCooker::ITable::* correspondant au type
de table à acceder.

Par exemple, l'ouverture d'une table de TYPE=FT renverra un objet de type ScriptCooker::ITable::Ft.

=head1 AUTHOR

Copyright (c) 2011 BV Associates. Tous droits réservés.

=cut
