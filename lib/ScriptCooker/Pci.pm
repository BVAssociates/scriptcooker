# ------------------------------------------------------------
# Copyright (c) 2011, BV Associates. Tous droits reserves.
# ------------------------------------------------------------
#
# $Revision: 351 $
#
# ------------------------------------------------------------
#
# Description : Module Pci
# Date :        26/06/2011
# Auteur :      V. Bauchart
# Projet :      I-TOOLS
#
# ------------------------------------------------------------
#
# HISTORIQUE
# 27/07/2012 - T. ZUMBIEHL (BV Associates)
# Remplacement ITOOLS_COMPAT par IT20_COMPLIANT
#
# ------------------------------------------------------------



####################################################
## Decalaration de classe DefinePci
####################################################
# Declaration du package
package ScriptCooker::DefinePci;

our $VERSION=2.1.0;


# -------
# Imports systemes
# -------
use strict;
use warnings;

use Carp qw( croak carp );
use Fcntl qw(:DEFAULT :flock);

# -------
# Imports libs
# -------
use ScriptCooker::Log   2.1.0 qw($logger _t);
use ScriptCooker::Utils 2.1.0;

# Heritage
use ScriptCooker::Define 2.1.0;
use base qw{ScriptCooker::Define};

# Declaration des attributs
use fields qw{ 
    pci_name
};

####################################################
## Methodes de DefinePci
####################################################


# ------------------------------------------
# Nom : DefinePci::new
#
# Description :
# Constructeur de la classe DefinePci
#
# Arguments :
#   - table_name : nom du PCI a ouvrir
#
# Retourne :
#   - un objet de type Define
# ------------------------------------------
#override Define::new
sub new {
    my $self=shift;

    my $pci_name=shift;

    # s'assure que la table existe bien
    my $definition=ScriptCooker::Define->new($pci_name);
    
    # cr�er un nouvel objet si non-h�rit�
    $self=fields::new($self) if ! ref $self;

    # ouvre la definition g�n�rique d'un pci
    $self->SUPER::new("pci");

    $self->{pci_name}=$pci_name;

    return $self;
}

# ------------------------------------------
# Nom : DefinePci::file
#
# Description :
# Retourne le chemin des donn�es du PCI
# Si n�c�ssaire evalue la valeur
#
# Retourne :
#   - scalaire : chemin des donn�es de la table
# ------------------------------------------
sub file {
    my $self=shift;

    # Variable pilotant le pci � chercher
    local $ENV{TableName}=$self->{pci_name};
    
    # tente de chercher le pci
    my $file = eval { $self->SUPER::file() };

    return $file;
}


# ------------------------------------------
# Nom : DefinePci::header
#
# Description :
# Retourne la variable HEADER propre � un PCI
#
# Retourne :
#   - scalaire
# ------------------------------------------
sub header {
    my $self=shift;

    # Les I-TOOLS 2.0.x n'affiche pas le bon entete
    if ( $ENV{IT20_COMPLIANT} ) { 
        local $ENV{TableName}="";
    }

    return $self->SUPER::header();
}

1;




####################################################
## Decalaration de classe Pci
####################################################
# Declaration du package
package ScriptCooker::Pci;

our $VERSION=2.1.0;

# -------
# Imports systemes
# -------
use strict;
use warnings;

use Carp qw( croak carp );
use Fcntl qw(:DEFAULT :flock);

# -------
# Imports libs
# -------
use ScriptCooker::Log   2.1.0 qw($logger _t);
use ScriptCooker::Utils 2.1.0;

# Heritage

use ScriptCooker::ITable::Ft 2.1.0;
use base qw{ScriptCooker::ITable::Ft};

# Declaration des attributs
use fields qw{ 
    eval_condition
    eval_env_vars
};


####################################################
## Constructeur
####################################################


# ------------------------------------------
# Nom : Ft::open
#
# Description :
# Constructeur de la classe Ft
#
# Arguments :
#   - table_name : nom de la table a ouvrir
#
# Retourne :
#   - un objet de type Ft
# ------------------------------------------
#override ITools_interface::open
sub open {
    my $self = shift;

    # mandatory parameter
    if (@_ < 1) {
        croak ("'new' take 1 argument")
    }   

    # cr�er une definition sp�ciale PCI
    my $definition = ScriptCooker::DefinePci->new(@_);

    # cr�er un objet si non-h�rit�
    $self=fields::new($self) if ! ref $self;

    # appelle normalement le constructeur
    $self->SUPER::open($definition);

    $self->{eval_condition} = undef;
    $self->{eval_env_vars} = undef;

    $logger->info(_t("Ouverture du panneau de commande de la table [_1]",$definition->{pci_name}));
    
    return $self;
}

####################################################
## Methodes publiques
####################################################

# ------------------------------------------
# Nom : Pci::eval_condition
#
# Description :
#   Si vrai, les condition de PCI seront evalu�es en true ou false
#
# Retourne :
#   - scalaire : valeur courante
# ------------------------------------------
sub eval_condition {
    my $self=shift;

    if ( @_ ) {
        $self->{eval_condition} = shift @_;
    }

    return $self->{eval_condition};
}

# ------------------------------------------
# Nom : Pci::eval_env_vars
#
# Description :
#   Si vrai, les variables de type Shell seront evalu�es
#
# Retourne :
#   - scalaire : valeur courante
# ------------------------------------------
sub eval_env_vars {
    my $self=shift;

    if ( @_ ) {
        $self->{eval_env_vars} = shift @_;
    }

    return $self->{eval_env_vars};
}

####################################################
## Methodes privees
####################################################


# ------------------------------------------
# Nom : Pci::fetch_row
#
# Description :
#   Renvoie la prochaine ligne du PCI validant les conditions de selection
#   sous forme d'un dictionnaire de type colonne => valeur
#
# Retourne :
#   - hash : dictionnaire aux colonnes selectionn�es
# ------------------------------------------
#override ITools_interface::fetch_row
sub fetch_row {
    my $self=shift;

    my %return_hash;

    if ( $self->definition()->file() ) {
        %return_hash=$self->SUPER::fetch_row();
    }

    if ( %return_hash && $self->{eval_env_vars} ) {
        foreach my $field ( $self->field() ) {
            $return_hash{$field} = evaluate_variables($return_hash{$field}, {
                                                            leave_unknown=>1,
                                                          });
        }
    }

    if ( exists $return_hash{Condition} && $self->{eval_condition} ) {
        # traitement des conditions
        if ( ! $return_hash{Condition} ) {
            $return_hash{Condition}='true';
        }
        else {
            my $pre_condition=$return_hash{Condition};
            system($pre_condition);
            if ( $? == 0 ) {
                $return_hash{Condition}='true';
            }
            else {
                $return_hash{Condition}='false';
            }
        }
    }

    return %return_hash;
}



1;  # so the require or use succeeds

=head1 NAME

ITable::Pci : Classe de type ScriptCooker::ITable sp�cifique aux tables PCI

=head1 SYNOPSIS

 my $pci_table = ITable::Pci->open("table");

 while (my %menu_entry = $pci_table->fetch_row()) {
     ...
 }

=cut
